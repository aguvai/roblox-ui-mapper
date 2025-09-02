local AnimationFunctions = {}

-- [[ OPEN BUTTON ]] --
AnimationFunctions.open_hoverEnter = function(button)
	local innerCircle = button.Parent.InnerCircle
	innerCircle:TweenSize(
		UDim2.new(0.95, 0, 0.95, 0),
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quart,
		.2,
		true
	)
end

AnimationFunctions.open_hoverLeave = function(button)
	local innerCircle = button.Parent.InnerCircle
	innerCircle:TweenSize(
		UDim2.new(0.8, 0, 0.8, 0),
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quart,
		.2,
		true
	)
end



-- [[ CLOSE BUTTON ]] --
AnimationFunctions.close_hoverEnter = function(button)
	button.Parent.BackgroundTransparency = .3
end

AnimationFunctions.close_hoverLeave = function(button)
	button.Parent.BackgroundTransparency = 0
end

return AnimationFunctions