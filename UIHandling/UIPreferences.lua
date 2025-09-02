local UIPreferences = {
	-- Not case sensitive
	naming_rules = {
		closeButton_name = "GUICloseButton",
		mainFrame_name = "mainFrame",
		proximityPrompts_name = "ProximityPrompts",
	},

	-- Tween info / positions used by AnimationFunctions
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

	UI_closedPosition = UDim2.new(0.5, 0, -1.5, 0),
	UI_openedPosition = UDim2.new(0.5, 0, 0.5, 0),
}

return UIPreferences