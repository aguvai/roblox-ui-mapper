local Preferences = require(script.Parent.UIPreferences)

local GUIMapper = {}

local guiMap = {}

function GUIMapper.getMap()
	return guiMap
end

function GUIMapper.mapGUIToContentsFromButton(gui, button)

	if not (button:IsA("ImageButton") or button:IsA("TextButton")) then
		for _, v in pairs (button:GetDescendants()) do
			if v:IsA("ImageButton") or v:IsA("TextButton") then
				button = v
				break
			end
		end
	end

	local mainframe
	local closebutton
	local proximityPromptsTable = {}

	for _, descendant in gui:GetDescendants() do

		-- // 1. Check for mainframe
		if descendant.Name:lower() == Preferences.naming_rules.mainFrame_name:lower() then 
			mainframe = descendant

			-- // 2. Check for close button
		elseif descendant.Name:lower() == Preferences.naming_rules.closeButton_name:lower() then 
			closebutton = descendant

			-- // 3. Check for proximity prompts
		elseif descendant.Name:lower() == Preferences.naming_rules.proximityPrompts_name:lower() then 
			if not descendant:IsA("Folder") then
				warn("ProximityPrompts must be a folder")
				continue
			end

			for _, prompt in ipairs(descendant:GetChildren()) do
				-- Validate folder contents
				if not prompt:IsA("ObjectValue") then
					warn("Only ObjectValues can be stored in ProximityPrompts")
					continue
				end

				local objValue = prompt -- your ObjectValue instance

				-- Wait until Value is set
				if not objValue.Value then
					objValue:GetPropertyChangedSignal("Value"):Wait()
				end

				if not objValue.Value:IsA("ProximityPrompt") then
					warn("ObjectValue in ProximityPrompts must reference a ProximityPrompt")
				end

				-- Store reference
				table.insert(proximityPromptsTable, prompt.Value)
			end
		end

	end

	-- Complete mapping
	if mainframe and closebutton then
		guiMap[gui] = {
			openButton = button,
			closeButton = closebutton,
			mainFrame = mainframe,
			proximityPrompts = proximityPromptsTable,
		}
	else
		warn("Missing MainFrame or GUICloseButton in GUI: " .. gui.Name)
	end

end

return GUIMapper