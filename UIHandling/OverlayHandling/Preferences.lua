local Preferences = {}

Preferences.Animations = {
	open = {
		time = 0.25,
		easingDirection = Enum.EasingDirection.Out,
		easingStyle = Enum.EasingStyle.Quad,
	},
	close = {
		time = 0.2,
		easingDirection = Enum.EasingDirection.In,
		easingStyle = Enum.EasingStyle.Quad,
	},
}

Preferences.OverlayUIName = "OverlayUI"

Preferences.Toast = {
	secondsOnScreen = 4
}

Preferences.Modal = {
	
}

Preferences.Notification = {
	secondsOnScreen = 10,
}

return Preferences