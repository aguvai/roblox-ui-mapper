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
		local tweenInfo = TweenInfo.new(
			0.2,
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.InOut
		)
		local tween = TweenService:Create(innerCircle, tweenInfo, {
			Size = UDim2.new(0.95, 0, 0.95, 0)
		})
		tween:Play()
	end
end

AnimationFunctions.openButton_hoverLeave = function(button)
	local innerCircle = button.Parent:FindFirstChild("InnerCircle")
	if innerCircle then
		local tweenInfo = TweenInfo.new(
			0.2,
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.InOut
		)
		local tween = TweenService:Create(innerCircle, tweenInfo, {
			Size = UDim2.new(0.8, 0, 0.8, 0)
		})
		tween:Play()
	end
end

-- [[ CLOSE BUTTON ]] --
AnimationFunctions.closeButton_hoverEnter = function(button)
	if button.Parent then
		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local tween = TweenService:Create(button.Parent, tweenInfo, {
			BackgroundTransparency = 0.25
		})
		tween:Play()
	end
end

AnimationFunctions.closeButton_hoverLeave = function(button)
	if button.Parent then
		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local tween = TweenService:Create(button.Parent, tweenInfo, {
			BackgroundTransparency = 0
		})
		tween:Play()
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

	local tween = TweenService:Create(mainFrame, TweenInfo.new(
		closeTween.time,
		closeTween.easingStyle,
		closeTween.easingDirection
		), {
			Position = closedPosition	
		})

	tween:Play()
	tween.Completed:Connect(function()
		mainFrame.Visible = false
		closingDebounce = false
	end)
end

-- // Open function
AnimationFunctions.openGUI = function(mainFrame)
	if mainFrame.Visible then 
		AnimationFunctions.closeGUI(mainFrame)
		return
	end

	AnimationFunctions.clearGUIs()
	mainFrame.Visible = true

	local tween = TweenService:Create(mainFrame, TweenInfo.new(
		openTween.time,
		openTween.easingStyle,
		openTween.easingDirection
		), {
			Position = openedPosition
		})
	tween:Play()
end

return AnimationFunctions