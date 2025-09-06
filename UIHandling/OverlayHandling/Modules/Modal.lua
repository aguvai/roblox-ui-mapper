local Preferences = require(script.Parent.Parent.Preferences)
local RotationHandler = require(script.Parent.Utils.RotationHandler)

local TweenService = game:GetService("TweenService")
local template = script:WaitForChild("ModalTemplate")

-- Glow animation
local function eminatingGlow(icon)
	local glow = icon:FindFirstChild("EminatingLight")
	if not glow then return end

	task.spawn(function()
		while glow.Parent == icon do
			local tweenIn = TweenService:Create(glow, TweenInfo.new(0.7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.95
			})
			tweenIn:Play()
			tweenIn.Completed:Wait()

			local tweenOut = TweenService:Create(glow, TweenInfo.new(0.7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.98
			})
			tweenOut:Play()
			tweenOut.Completed:Wait()
		end
	end)
end

-- Class table
local Modal = {}
Modal.__index = Modal

-- Constructor
function Modal.new(overlayGUI, options)
	local self = setmetatable({}, Modal)

	-- clone template
	self.gui = template:Clone()
	self.gui.Parent = overlayGUI:WaitForChild("ModalFrame", 5)
	self.gui.Visible = true
	self.gui.Position = UDim2.new(0, 0, -1, 0)

	-- instance state
	self.tweeningOut = false
	self.rotationCache = RotationHandler.normalizeRotation(self.gui)
	self.options = options

	-- build UI
	self:_buildLeftSide()
	self:_buildRightSide()

	-- set title
	self.gui.Title.Text = options.title

	-- close button
	self.gui.CloseButton.MouseButton1Click:Connect(function()
		self:tweenOut()
	end)

	-- animate in
	self:tweenIn()

	return self
end

-- Tween in
function Modal:tweenIn()
	local tween = TweenService:Create(self.gui, TweenInfo.new(Preferences.Modal.TweenInSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0)
	})
	tween:Play()

	task.wait((Preferences.Modal.TweenInSpeed) / 2)
	
	RotationHandler.restoreRotation(self.rotationCache)
end

-- Tween out
function Modal:tweenOut()
	if self.tweeningOut then return end
	self.tweeningOut = true

	local tween = TweenService:Create(self.gui, TweenInfo.new(Preferences.Modal.TweenOutSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(0, 0, -1, 0)
	})
	tween.Completed:Connect(function()
		self.gui:Destroy()
		self.tweeningOut = false
		RotationHandler.restoreRotation(self.rotationCache, true, Preferences.Modal.TweenOutSpeed - 0.2)
	end)
	tween:Play()
end

-- Build left side
function Modal:_buildLeftSide()
	local leftSide = self.gui.MainFrame.LeftSide
	local rightSide = self.gui.MainFrame.RightSide
	local options = self.options

	local icon = leftSide["1_Icon"]
	local supplementaltext = leftSide["2_SupplementalTextFrame"].SupplementalText

	if (not options.icon_id or options.icon_id == "") and (not options.under_icon_text or options.under_icon_text == "") then
		leftSide.Visible = false
		rightSide.Size = UDim2.new(0.8, 0, 0.9, 0)
	else
		if options.icon_id then
			icon.Image = "rbxassetid://"..options.icon_id
			eminatingGlow(icon)

			icon.IconText.Text = options.icon_text or ""
		end

		if options.under_icon_text and options.under_icon_text ~= "" then
			supplementaltext.Text = options.under_icon_text
		else
			supplementaltext.Parent.Visible = false
		end
	end
end

-- Build right side
function Modal:_buildRightSide()
	local rightSide = self.gui.MainFrame.RightSide
	local options = self.options

	rightSide["1_PrimaryTextFrame"].MainText.Text = options.primary_text
	local button = rightSide["2_ButtonFrame"]

	button.ButtonText.Text = options.button_text
	button.StrikethroughText.Visible = options.button_strikethrough_text ~= nil and options.button_strikethrough_text ~= ""
	if button.StrikethroughText.Visible then
		button.StrikethroughText.Text = options.button_strikethrough_text
	end

	button.Hitbox.MouseButton1Click:Connect(function()
		if options.button_action then
			options.button_action()
		end
		self:tweenOut()
	end)
end

return Modal