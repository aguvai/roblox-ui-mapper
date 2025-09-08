local Preferences = require(script.Parent.Parent.Preferences)
local RotationHandler = require(script.Parent.Utils.RotationHandler)

local TweenService = game:GetService("TweenService")
local template = script:WaitForChild("ModalTemplate")

-- [[ UTILITY ]] --
local function cleanup(self)
	-- Disconnect all event connections
	for _, conn in ipairs(self.connections) do
		conn:Disconnect()
	end
	self.connections = {}

	-- Destroy GUI
	if self.gui then
		self.gui:Destroy()
	end
end

-- [[ ANIMATION FUNCTIONS ]] --
local function eminatingGlow(icon)
	local glow = icon.Parent:FindFirstChild("EminatingLight")
	if not glow then return end
	
	local tween = TweenService:Create(glow, TweenInfo.new(
		0.75, 
		Enum.EasingStyle.Linear, 
		Enum.EasingDirection.InOut, 
		-1,   -- repeat forever
		true  -- reverse back and forth
		), {
			ImageTransparency = 0.95
		})

	tween:Play()
end

-- [[ TWEEN FUNCTIONS ]] --
-- // Tween in
local function tweenIn(self)
	local tween = TweenService:Create(self.gui, Preferences.Modal.TweenInInfo, {
		Position = UDim2.new(0, 0, 0, 0)
	})
	tween:Play()

	task.wait((Preferences.Modal.TweenInInfo.Time) / 2)

	RotationHandler.restoreRotation(self.rotationCache)
end

-- // Tween out
local function tweenOut(self)
	RotationHandler.restoreRotation(self.rotationCache, true, (Preferences.Modal.TweenOutInfo.Time / 2))

	local tween = TweenService:Create(self.gui, Preferences.Modal.TweenOutInfo, {
		Position = UDim2.new(0, 0, -1, 0)
	})
	tween:Play()

	tween.Completed:Once(function()
		cleanup(self)
	end)
end

-- [[ BUILD FUNCTIONS ]] --
-- // Build left side
local function buildLeftSide(self)
	local leftSide = self.gui.MainFrame.LeftSide
	local rightSide = self.gui.MainFrame.RightSide

	local icon = leftSide["1_Icon"].Icon
	local supplementaltext = leftSide["2_SupplementalTextFrame"].SupplementalText

	if (not self.options.icon_id or self.options.icon_id == "") and (not self.options.under_icon_text or self.options.under_icon_text == "") then
		leftSide.Visible = false
		rightSide.Size = UDim2.new(0.8, 0, 0.9, 0)
	else
		if self.options.icon_id then
			icon.Image = "rbxassetid://" .. self.options.icon_id
			eminatingGlow(icon)

			icon.Parent.IconText.Text = self.options.icon_text or ""
		else
			icon.Parent.Visible = false
			supplementaltext.Size = UDim2.new(1, 0, .75, 0)
		end

		if self.options.under_icon_text and self.options.under_icon_text ~= "" then
			supplementaltext.Text = self.options.under_icon_text
		else
			supplementaltext.Parent.Visible = false
		end
	end
end

-- // Build right side
local function buildRightSide(self)
	local rightSide = self.gui.MainFrame.RightSide

	rightSide["1_PrimaryTextFrame"].MainText.Text = self.options.primary_text
	local button = rightSide["2_ButtonFrame"]

	button.ButtonText.Text = self.options.button_text
	button.StrikethroughText.Visible = self.options.button_strikethrough_text ~= nil and self.options.button_strikethrough_text ~= ""
	if button.StrikethroughText.Visible then
		button.StrikethroughText.Text = self.options.button_strikethrough_text
	end

	table.insert(self.connections, button.Hitbox.MouseButton1Click:Connect(function()

		--TODO: Figure out if we want to continue to show UI based on function return
		if self.options.button_action then
			self.options.button_action()
		end
		tweenOut(self)
	end))
	
	table.insert(self.connections, button.Hitbox.MouseEnter:Connect(function()
		button.BackgroundTransparency = .25
	end))
	
	table.insert(self.connections, button.Hitbox.MouseLeave:Connect(function()
		button.BackgroundTransparency = 0
	end))
end

-- [[ CONSTRUCTOR ]] --
local Modal = {}
Modal.__index = Modal

function Modal.new(overlayGUI, options)
	local modalFrame = overlayGUI:WaitForChild("ModalFrame", 5)
	if not modalFrame then return end
	-- Prevent multiple modals
	-- TODO: Shift to queue system
	if #modalFrame:GetChildren() > 0 then warn("Modal already present. Rejecting request.") return end 
	
	local self = setmetatable({}, Modal)
	self.options = options
	self.connections = {}

	-- Clone template
	self.gui = template:Clone()
	self.gui.Parent = modalFrame
	self.gui.Visible = true
	
	-- Initialize
	self.gui.Position = UDim2.new(0, 0, -1, 0)
	self.rotationCache = RotationHandler.normalizeRotation(self.gui)

	-- Build UI
	buildLeftSide(self)
	buildRightSide(self)

	-- Set title
	self.gui.Title.Text = options.title

	-- Close button
	self.gui.CloseButton.MouseButton1Click:Once(function()
		tweenOut(self)
	end)

	-- Animate in
	tweenIn(self)

	return self
end

return Modal