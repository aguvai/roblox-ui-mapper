-- [[ MODULES ]] --
local AnimationFunctions = require(script.Parent.AnimationFunctions)
local GUIMapper = require(script.Parent.GUIMapper)

-- [[ * MAIN * ]] --
local SpecialButtonFunctions = {}

SpecialButtonFunctions.actions = {
	GamepassPrompt_OpenButton = function(button)
		print("GAMEPASS")
	end,

	InviteFriends_OpenButton = function(button)
		print("INVITE")
	end,
}

function SpecialButtonFunctions:handle(button)
	local action = self.actions[button.Name]
	if action then
		
		button = GUIMapper.validateButton(button)
		
		button.MouseButton1Click:Connect(function()
			action(button)
		end)
		
		button.MouseEnter:Connect(function()
			AnimationFunctions.openButton_hoverEnter(button)
		end)
		
		button.MouseLeave:Connect(function()
			AnimationFunctions.openButton_hoverLeave(button)
		end)
		
		return true
	end
	return false
end

return SpecialButtonFunctions