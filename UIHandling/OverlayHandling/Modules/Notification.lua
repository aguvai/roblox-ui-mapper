local Preferences = require(script.Parent.Parent.Preferences)

local TweenService = game:GetService("TweenService")
local template = script:WaitForChild("NotificationTemplate")

-- [[ UTILITY ]] --
local function cleanupConnections(self)
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

-- [[ TWEEN FUNCTIONS ]] --
local function tweenOut(self)
	local gui = self.gui
	if not gui then return end

	local tween = TweenService:Create(gui, Preferences.Notification.TweenOutInfo, {
		Position = UDim2.new(1.1, 0, 0, 0)
	})
	tween:Play()

	tween.Completed:Once(function()
		cleanupConnections(self)
	end)
end

local function tweenIn(self)
	local gui = self.gui
	gui.Visible = true
	local tween = TweenService:Create(gui, Preferences.Notification.TweenInInfo, {
		Position = UDim2.new(0, 0, 0, 0)
	})
	tween:Play()

	task.spawn(function()
		task.wait(Preferences.Notification.secondsOnScreen)
		tweenOut(self)
	end)
end

-- [[ BUILD FUNCTIONS ]] --
local function buildLeftSide(gui, options)
	local leftSide = gui.MainFrame.LeftSide
	leftSide.Icon.Image = tonumber(options.icon_id)
	if options.icon_text and options.icon_text ~= "" then
		leftSide.Icon.IconText.Text = options.icon_text
	end
end

local function buildRightSide(self, gui, options)
	local rightSide = gui.MainFrame.RightSide
	local buttonFrame = rightSide.ButtonFrame
	local buttonText = buttonFrame.ButtonText
	local hitbox = buttonFrame.Hitbox
	buttonText.Text = options.button_text

	-- Track connections
	table.insert(self.connections, hitbox.MouseButton1Click:Connect(function()
		options.button_action()
		tweenOut(self)
	end))

	table.insert(self.connections, hitbox.MouseEnter:Connect(function() end))
	table.insert(self.connections, hitbox.MouseLeave:Connect(function() end))

	local primaryText = rightSide.PrimaryTextFrame.PrimaryText
	primaryText.Text = options.primary_text
end

-- [[ CLASS ]] --
local Notification = {}
Notification.__index = Notification

function Notification.new(overlayGUI, options)
	local self = setmetatable({}, Notification)
	self.options = options
	self.connections = {}

	-- Clone template
	self.gui = template:Clone()
	self.gui.Parent = overlayGUI:WaitForChild("NotificationFrame", 5)
	self.gui.Position = UDim2.new(1.1, 0, 0, 0)

	-- Build
	self.gui.Title.Text = options.title
	if options.icon_id and options.icon_id ~= "" then
		buildLeftSide(self.gui, self.options)
	else
		self.gui.MainFrame.LeftSide.Visible = false
		self.gui.MainFrame.RightSide.Size = UDim2.new(.9, 0, .8, 0)
	end
	buildRightSide(self, self.gui, self.options)

	-- Animate in
	tweenIn(self)

	return self
end

function Notification:Dismiss()
	tweenOut(self)
end

return Notification