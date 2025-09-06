local Preferences = {}

Preferences.OverlayUIName = "OverlayUI"

Preferences.Toast = {
	secondsOnScreen = 4,
	
	TweenInInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	TweenOutInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
}

Preferences.Modal = {
	TweenInInfo = TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	TweenOutInfo = TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
}

Preferences.Notification = {
	secondsOnScreen = 10,
	
	TweenInInfo = TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	TweenOutInfo = TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
}

return Preferences