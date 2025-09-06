local Modules = script.Parent.Modules
local Validate = require(Modules.Utils.Validate)

local Modal = require(Modules.Modal)
local Toast = require(Modules.Toast)
local Notification = require(Modules.Notification)

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

	return Modal.new(overlayGUI, options)
end

function OverlayHandler.showToast(player, options)
	local overlayGUI = validate(player, options, {"primary_text"})
	if not overlayGUI then return end

	return Toast.new(overlayGUI, options)
end

function OverlayHandler.showNotification(player, options)
	local overlayGUI = validate(player, options, {"title", "primary_text", "button_text", "button_action"})
	if not overlayGUI then return end

	return Notification.new(overlayGUI, options)
end

return OverlayHandler