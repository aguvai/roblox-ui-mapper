local Preferences = require(script.Parent.Parent.Parent.Preferences)
local overlayUIName = Preferences.OverlayUIName

local Validate = {}

function Validate.validatePlayer(player)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		warn("Expected Player object for player parameter, got " .. typeof(player))
		return false
	else
		return true
	end
end

function Validate.validateOptions(options, requiredFields)
	if typeof(options) ~= "table" then
		warn("Expected table for options parameter, got " .. typeof(options))
		return false
	end
	
	if requiredFields == nil then
		warn("requiredFields parameter is nil")
		return false
	end

	for _, v in pairs(requiredFields) do
		if options[v:lower()] == nil then
			warn("Options table missing required field: " .. v)
			return false
		end
	end

	return true
end

function Validate.fetchOverlayScreenGUI(player)
	local playergui = player:WaitForChild("PlayerGui", 5)

	if not playergui then
		warn("PlayerGui not found for player: " .. player.Name)
		return nil
	end
	
	local overlayGUI = playergui:WaitForChild(overlayUIName, 5)
	
	if not overlayGUI then
		warn(string.format("Overlay ScreenGUI not found in PlayerGui for player: %s.\nExpected name: '%s'.\nRefer to Overlay UI naming rules in UIHandling --> OverlayHandling --> Preferences", player.Name, overlayUIName))
		return nil
	end

	return overlayGUI
end

return Validate