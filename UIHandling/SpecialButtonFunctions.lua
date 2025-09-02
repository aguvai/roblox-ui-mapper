-- [[ SERVICES ]] --
local MarketPlaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")

-- [[ MODULES ]] --
local AnimationFunctions = require(script.Parent.AnimationFunctions)
local GUIMapper = require(script.Parent.GUIMapper)


-- [[ SPECIAL BUTTON FUNCTIONS ]] --

local gamepassToPrompt = 1015193003
local function gamepassPrompt(player)
	MarketPlaceService:PromptGamePassPurchase(player, gamepassToPrompt)
end

local function inviteFriends(player)
	SocialService:PromptGameInvite(player)
end

-- [[ * MAIN * ]] --
local SpecialButtonFunctions = {}

SpecialButtonFunctions.actions = {
	GamepassPrompt_OpenButton = gamepassPrompt,

	InviteFriends_OpenButton = inviteFriends,
}

function SpecialButtonFunctions:handle(button, player)
	local action = self.actions[button.Name]
	if action then
		
		button = GUIMapper.validateButton(button)
		
		button.MouseButton1Click:Connect(function()
			action(player)
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