local Preferences = require(script.Parent.Parent.Preferences)

local TweenService = game:GetService("TweenService")
local template = script:WaitForChild("NotificationTemplate")

-- [[ TWEEN FUNCTIONS ]] --
-- // Tween out
function tweenOut(gui)
	local tweenOut = TweenService:Create(gui, Preferences.Notification.TweenOutInfo, {
		Position = UDim2.new(1.1, 0, 0, 0)
	})
	tweenOut:Play()

	tweenOut.Completed:Once(function()
		gui:Destroy()
	end)
end

-- // Tween in
local function tweenIn(gui)
	gui.Visible = true
	local tweenIn = TweenService:Create(gui, Preferences.Notification.TweenInInfo, {
		Position = UDim2.new(0, 0, 0, 0)
	})
	tweenIn:Play()

	task.spawn(function()
		task.wait(Preferences.Notification.secondsOnScreen)
		tweenOut(gui)
	end)
end

-- [[ BUILD FUNCTIONS ]] -- 
-- // left side
local function buildLeftSide(gui, options)
	local leftSide = gui.MainFrame.LeftSide
	
	leftSide.Icon.Image = tonumber(options.icon_id)
	if options.icon_text ~= nil and options.icon_text ~= "" then
		leftSide.Icon.IconText.Text = options.icon_text
	end
end

-- // right side
local function buildRightSide(gui, options)
	local rightSide = gui.MainFrame.RightSide
	
	local buttonFrame = rightSide.ButtonFrame
	local buttonText = buttonFrame.ButtonText
	local hitbox = buttonFrame.Hitbox
	buttonText.Text = options.button_text
	hitbox.MouseButton1Click:Connect(function()
		options.button_action()
		tweenOut(gui)	
	end)
	
	local primaryText = rightSide.PrimaryTextFrame.PrimaryText
	primaryText.Text = options.primary_text
end



local Notification = {}
Notification.__index = Notification

function Notification.new(overlayGUI, options)
	local self = setmetatable({}, Notification)
	self.options = options
	
	-- clone template
	self.gui = template:Clone()
	self.gui.Parent = overlayGUI:WaitForChild("NotificationFrame", 5)
	self.gui.Position = UDim2.new(1.1, 0, 0, 0)

	-- build
	self.gui.Title.Text = options.title
	
	if options.icon_id ~= nil and options.icon_id ~= "" then
		buildLeftSide(self.gui, self.options)
	else
		self.gui.MainFrame.LeftSide.Visible = false
		self.gui.MainFrame.RightSide.Size = UDim2.new(.9, 0, .8, 0)
	end
	
	buildRightSide(self.gui, self.options)

	-- animate in
	tweenIn(self.gui)

	return self
end

function Notification:Dismiss()
	tweenOut(self.gui)
end

return Notification