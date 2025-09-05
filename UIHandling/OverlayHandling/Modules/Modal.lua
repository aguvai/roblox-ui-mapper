local UtilitiesFolder = script.Parent.Utils
local Validate = require(UtilitiesFolder.Validate)

-- [[ * MAIN * ]] --

local Modal = {}

function Modal.show(player: Player, options: Table)
	
	if not Validate:ValidatePlayer(player) then return end
	if not Validate:ValidateOptions(options, {"title", "primarytext"}) then return end
	
	local PlayerGUI = Validate:FetchPlayerGUI(player)
	if not PlayerGUI then return end
	
	
end 

return Modal
