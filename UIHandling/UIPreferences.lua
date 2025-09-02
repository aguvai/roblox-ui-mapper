local AnimationFunctions = require(script.Parent.AnimationFunctions)

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

	hoverFunctions = {
		openButton = {
			enter = AnimationFunctions.open_hoverEnter,
			leave = AnimationFunctions.open_hoverLeave,
		},
		
		closeButton = {
			enter = AnimationFunctions.close_hoverEnter,
			leave = AnimationFunctions.close_hoverLeave,
		}
	},
}

return UIPreferences