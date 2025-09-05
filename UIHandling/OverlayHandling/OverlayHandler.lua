local Modules = script.Parent.Modules
local Validate = require(Modules.Utils.Validate)

local modal = require(Modules.Modal)
local toast = require(Modules.Toast)
local notification = require(Modules.Notification)


local function validate(player, options, requiredFields)
	if not Validate.ValidatePlayer(player) then return nil end
	if not Validate.ValidateOptions(options, requiredFields) then return nil end

	local PlayerGUI = Validate.FetchPlayerGUI(player)
	if not PlayerGUI then return nil end
	
	return PlayerGUI
end

local OverlayHandler = {}

function OverlayHandler.showModal(player, options)
	local playerGUI = validate(player, options, {"title", "primarytext"})
	if not playerGUI then return end
	
	modal.show(playerGUI, options)
end

function OverlayHandler.showToast(player, options)
	local playerGUI = validate(player, options, {"primarytext"})
	if not playerGUI then return end
	
	toast.show(playerGUI, options)
end

function OverlayHandler.showNotification(player, options)
	local playerGUI = validate(player, options, {"title", "primarytext"})
	if not playerGUI then return end
	
	notification.show(playerGUI, options)
end

return OverlayHandler