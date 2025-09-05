local Preferences = {}

overlayUI = script.OverlayUI
if not overlayUI.Value then
	overlayUI:GetPropertyChangedSignal("Value"):Wait()
end

Preferences.Positions = {
	top = UDim2.new(0.5, 0, 0, 0),
	middle = UDim2.new(0.5, 0, 0.5, 0),
	bottom = UDim2.new(0.5, 0, 1, 0),
	topRight = UDim2.new(1, 0, 0, 0),
	bottomRight = UDim2.new(1, 0, 1, 0),
}

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

Preferences.OverlayUI = overlayUI

return Preferences