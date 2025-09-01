local playerGUI = script.Parent
local buttonHolder = playerGUI:WaitForChild("ButtonHolder")

---------------------------------------------------------------------
-- [[ SCREENGUI REFERENCES ]] --

--[[  INFO: 
	* All ScreenGUIs linked to an open button must have:
		--> An immediate "MainFrame" child
		--> A close button named "GUICloseButton"
	* The button's name must contain the corresponding GUI's name as follows:
		--> GUI_NAME + "OpenButton"
	
	* GUIs not following this hierarchy will be ignored.
--]]
---------------------------------------------------------------------

local guiMap = {}

local function mapGUIToContentsFromButton(gui, button)
	local mainframe
	local closebutton
	for _, descendant in gui:GetDescendants() do
		if descendant.Name == "MainFrame" then
			mainframe = descendant
		elseif descendant.Name == "GUICloseButton" then
			closebutton = descendant
		end
	end

	-- Complete mapping
	if mainframe and closebutton then
		guiMap[gui] = {
			openButton = button,
			closeButton = closebutton,
			mainFrame = mainframe,
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
				print(string.format(("mapping %s to contents"), gui.Name))
				coroutine.wrap(function()
					mapGUIToContentsFromButton(gui, button)
				end)()
				
			end
		end
	end
	
end)()