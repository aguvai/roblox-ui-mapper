-- [[ SERVICES ]] --
local TweenService = game:GetService("TweenService")

local playerGUI = script.Parent
local buttonHolder = playerGUI:WaitForChild("ButtonHolder")

---------------------------------------------------------------------
-- [[ SCREENGUI REFERENCES ]] --

--[[  INFO: 
	* All ScreenGUIs linked to an open button must have:
		--> An immediate "MainFrame" child
		--> A close button named "GUICloseButton"
	* The open button's name must contain the corresponding GUI's name as follows:
		--> GUI NAME + "OpenButton" (e.g. StoreGUI_OpenButton)
	* If the GUI can be opened with any proximity prompts in addition to the open button:
		--> Store references to the prompts in a folder within the ScreenGUI named "AssociatedOpenPrompts"
			--> References to proximity prompt objects must be stored in an ObjectValue 
	
	* GUIs not following this hierarchy will be ignored.
	* Names are not case sensitive
--]]
---------------------------------------------------------------------

-- * Names will not be case sensitive
local preferences = {
	openTween = TweenInfo.new(.25, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
	
	naming_rules = {
		closeButton_name = "GUICloseButton",
		mainFrame_name = "mainFrame",
		associatedOpenPrompts_name = "associatedOpenPrompts",
	}
	
}

-- [[ Store button-to-GUI mappings ]] --
local guiMap = {}

local function mapGUIToContentsFromButton(gui, button)
	
	local mainframe
	local closebutton
	local associatedPrompts = {}
	
	for _, descendant in gui:GetDescendants() do
		
		-- // 1. Check for mainframe
		if descendant.Name:lower() == preferences.naming_rules.mainFrame_name:lower() then 
			mainframe = descendant
		
		-- // 2. Check for close button
		elseif descendant.Name:lower() == preferences.naming_rules.closeButton_name:lower() then 
			closebutton = descendant
		
		-- // 3. Check for associated open prompts
		elseif descendant.Name:lower() == preferences.naming_rules.associatedOpenPrompts_name:lower() then 
			if not descendant:IsA("Folder") then
				warn("AssociatedOpenPrompts must be a folder")
				continue
			end
			
			for _, prompt in ipairs(descendant:GetChildren()) do
				-- Validate folder contents
				if not prompt:IsA("ObjectValue") then
					warn("Only ObjectValues can be stored in AssociatedOpenPrompts")
					continue
				end
				
				if not prompt.Value:IsA("ProximityPrompt") then
					warn("Only ProximityPrompt objects can be stored in AssociatedOpenPrompts")
					continue
				end
				
				-- Store reference
				table.insert(associatedPrompts, prompt.Value)
			end
		end
		
	end

	-- Complete mapping
	if mainframe and closebutton then
		guiMap[gui] = {
			openButton = button,
			closeButton = closebutton,
			mainFrame = mainframe,
			associatedOpenPrompts = associatedPrompts,
		}
	else
		warn("Missing MainFrame or GUICloseButton in GUI: " .. gui.Name)
	end
	print(guiMap)
end

coroutine.wrap(function()
	
	for _, holder in ipairs (buttonHolder:GetChildren()) do
		for _, button in ipairs (holder:GetChildren()) do
			local guiName = button.Name:gsub("_OpenButton", "")

			local gui = playerGUI:FindFirstChild(guiName)
			if gui then
				coroutine.wrap(function()
					mapGUIToContentsFromButton(gui, button)
				end)()
			end
		end
	end
	
end)()

-- [[ OPEN/CLOSE GUI FUNCTIONS ]] --