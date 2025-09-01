local function hoverEnter(button)
	local innerCircle = button.Parent.InnerCircle
	innerCircle:TweenSize(
		UDim2.new(0.95, 0, 0.95, 0),
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quart,
		.2,
		true
	)
end

local function hoverLeave(button)
	local innerCircle = button.Parent.InnerCircle
	innerCircle:TweenSize(
		UDim2.new(0.8, 0, 0.8, 0),
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quart,
		.2,
		true
	)
end

local UIPreferences = {
	naming_rules = {
		closeButton_name = "GUICloseButton",
		mainFrame_name = "mainFrame",
		associatedOpenPrompts_name = "associatedOpenPrompts",
	},

	tweenPreferences = {
		openTween = {
			time = .3,
			easingStyle = Enum.EasingStyle.Quart,
			easingDirection = Enum.EasingDirection.Out,
		},
		closeTween = {
			time = .3,
			easingStyle = Enum.EasingStyle.Quart,
			easingDirection = Enum.EasingDirection.In,
		},
	},

	UI_closedPosition = UDim2.new(0.5, 0, -1.5, 0),
	UI_openedPosition = UDim2.new(0.5, 0, 0.5, 0),

	buttonHoverFunctions = {
		enter = hoverEnter,
		leave = hoverLeave,
	},
}

return UIPreferences
