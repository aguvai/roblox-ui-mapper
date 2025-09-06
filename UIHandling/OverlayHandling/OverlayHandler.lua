local Modules = script.Parent.Modules
local Validate = require(Modules.Utils.Validate)

local modal = require(Modules.Modal)
local toast = require(Modules.Toast)
local notification = require(Modules.Notification)

local function validate(player, options, requiredFields)
	if not Validate.validatePlayer(player) then return nil end
	if not Validate.validateOptions(options, requiredFields) then return nil end

	local overlayGUI = Validate.fetchOverlayScreenGUI(player)
	if not overlayGUI then return nil end
	
	return overlayGUI
end


-- [[ * MAIN * ]] --
local OverlayHandler = {}

function OverlayHandler.showModal(player, options)
	local overlayGUI = validate(player, options, {"title", "primary_text", "button_text", "button_action"})
	if not overlayGUI then return end
	
	modal.show(overlayGUI, options)
end

function OverlayHandler.showToast(player, options)
	local overlayGUI = validate(player, options, {"primary_text"})
	if not overlayGUI then return end
	
	toast.show(overlayGUI, options)
end

function OverlayHandler.showNotification(player, options)
	local overlayGUI = validate(player, options, {"title", "primary_text"})
	if not overlayGUI then return end
	
	notification.show(overlayGUI, options)
end

return OverlayHandler