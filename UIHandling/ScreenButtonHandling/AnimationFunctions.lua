-- [[ MODULES ]] --
local modules = script.Parent
local GUIMapper = require(modules.GUIMapper)
local Preferences = require(modules.Preferences)

-- [[ SERVICES ]] --
local TweenService = game:GetService("TweenService")


-- [[ * MAIN * ]]
local AnimationFunctions = {}

-- [[ OPEN BUTTON ]] --
AnimationFunctions.openButton_hoverEnter = function(button)
	local innerCircle = button.Parent:FindFirstChild("InnerCircle")
	if innerCircle then
		innerCircle:TweenSize(
			UDim2.new(0.95, 0, 0.95, 0),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quart,
			.2,
			true
		)
	end
end

AnimationFunctions.openButton_hoverLeave = function(button)
	local innerCircle = button.Parent:FindFirstChild("InnerCircle")
	if innerCircle then
		innerCircle:TweenSize(
			UDim2.new(0.8, 0, 0.8, 0),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quart,
			.2,
			true
		)
	end
end

-- [[ CLOSE BUTTON ]] --
AnimationFunctions.closeButton_hoverEnter = function(button)
	if button.Parent then
		button.Parent.BackgroundTransparency = .25
	end
end

AnimationFunctions.closeButton_hoverLeave = function(button)
	if button.Parent then
		button.Parent.BackgroundTransparency = 0
	end
end


-- [[ OPEN / CLOSE FRAMES ]]
-- pull tween/position preferences from Preferences
local openTween = Preferences.openTween
local closeTween = Preferences.closeTween
local closedPosition = Preferences.UI_closedPosition
local openedPosition = Preferences.UI_openedPosition

-- [[ HELPERS ]] --
AnimationFunctions.clearGUIs = function()
	for _, gui in pairs(GUIMapper.getMap()) do
		gui.mainFrame.Visible = false
		gui.mainFrame.Position = closedPosition
	end
end

-- // Close function
local closingDebounce = false
AnimationFunctions.closeGUI = function(mainFrame)
	if not mainFrame.Visible then return end
	if closingDebounce then return end
	closingDebounce = true

	mainFrame:TweenPosition(closedPosition, closeTween.easingDirection, closeTween.easingStyle, closeTween.time, true)
	task.wait(closeTween.time)

	mainFrame.Visible = false
	closingDebounce = false
end

-- // Open function
AnimationFunctions.openGUI = function(mainFrame)
	if mainFrame.Visible then 
		AnimationFunctions.closeGUI(mainFrame)
		return
	end

	AnimationFunctions.clearGUIs()
	mainFrame.Visible = true
	mainFrame:TweenPosition(openedPosition, openTween.easingDirection, openTween.easingStyle, openTween.time, true)
end

return AnimationFunctions