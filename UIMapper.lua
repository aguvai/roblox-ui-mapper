-- [[ SERVICES ]] --
local TweenService = game:GetService("TweenService")

-- [[ VARIABLES ]] --
local playerGUI = script.Parent
local buttonHolder = playerGUI:WaitForChild("ButtonHolder")

-- [[ MODULES ]] --
local modules = game.ReplicatedStorage.UIHandling
local Preferences = require(modules.UIPreferences)
local AnimationFunctions = require(modules.AnimationFunctions)

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
	
	* GUIs not following these conventions will be ignored.
	* Names are not case sensitive
--]]
---------------------------------------------------------------------

-- [[ Store button-to-GUI mappings ]] --
local guiMap = {}

local function mapGUIToContentsFromButton(gui, button)

	if not button:IsA("ImageButton") or not button:IsA("TextButton") then
		for _, v in pairs (button:GetDescendants()) do
			if v:IsA("ImageButton") or v:IsA("TextButton") then
				button = v
				break
			end
		end
	end

	local mainframe
	local closebutton
	local associatedPrompts = {}

	for _, descendant in gui:GetDescendants() do

		-- // 1. Check for mainframe
		if descendant.Name:lower() == Preferences.naming_rules.mainFrame_name:lower() then 
			mainframe = descendant

		-- // 2. Check for close button
		elseif descendant.Name:lower() == Preferences.naming_rules.closeButton_name:lower() then 
			closebutton = descendant

		-- // 3. Check for associated open prompts
		elseif descendant.Name:lower() == Preferences.naming_rules.associatedOpenPrompts_name:lower() then 
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
				
				local objValue = prompt -- your ObjectValue instance

				-- Wait until Value is set
				if not objValue.Value then
					objValue:GetPropertyChangedSignal("Value"):Wait()
				end

				if not objValue.Value:IsA("ProximityPrompt") then
					warn("ObjectValue in AssociatedOpenPrompts must reference a ProximityPrompt")
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

end

for _, holder in ipairs (buttonHolder:GetChildren()) do
	for _, button in ipairs (holder:GetChildren()) do
		local guiName = button.Name:gsub("_OpenButton", "")

		local gui = playerGUI:FindFirstChild(guiName)
		if gui then

			mapGUIToContentsFromButton(gui, button)
		else
			
		end
	end
end


-- [[ NORMALIZE UI ON GAME START ]] --
coroutine.wrap(function()
	for index, gui in pairs (guiMap) do
		gui.mainFrame.Position = Preferences.UI_closedPosition
		gui.mainFrame.Visible = false
	end
end)()


-- [[ OPEN/CLOSE GUI FUNCTIONS ]] --

-- // Helpers
local function clearGUIs()
	for _, gui in pairs(guiMap) do
		gui.mainFrame.Visible = false
		gui.mainFrame.Position = Preferences.UI_closedPosition
	end
end


-- // References
local tweenPreferences = Preferences.tweenPreferences
local openTween = tweenPreferences.openTween
local closeTween = tweenPreferences.closeTween

-- // Close function
local closingDebounce = false
local function closeGUI(mainFrame)
	if not mainFrame.Visible then return end
	if closingDebounce then return end
	closingDebounce = true

	mainFrame:TweenPosition(Preferences.UI_closedPosition, closeTween.easingDirection, closeTween.easingStyle, closeTween.time, true)
	task.wait(closeTween.time)

	mainFrame.Visible = false
	closingDebounce = false
end

-- // Open function
local function openGUI(mainFrame)
	if mainFrame.Visible then 
		closeGUI(mainFrame)
		return
	end

	clearGUIs()
	mainFrame.Visible = true
	mainFrame:TweenPosition(Preferences.UI_openedPosition, openTween.easingDirection, openTween.easingStyle, openTween.time, true)
end

-- // open/close
for index, gui in pairs (guiMap) do
	
	local openButton = gui.openButton
	local closeButton = gui.closeButton
	local associatedPrompts = gui.associatedOpenPrompts
	local mainFrame = gui.mainFrame
	
	-- // 1. Open Button
	openButton.MouseButton1Click:Connect(function()
		openGUI(mainFrame)
	end)
	
	openButton.MouseEnter:Connect(function()
		AnimationFunctions.open_hoverEnter(openButton)
	end)
	
	openButton.MouseLeave:Connect(function()
		AnimationFunctions.open_hoverLeave(openButton)
	end)
	
	-- // 2. Associated Open Prompts
	for _, prompt in pairs (gui.associatedOpenPrompts) do
		prompt.Triggered:Connect(function()
			openGUI(mainFrame)
		end)
	end
	
	-- // 3. Close Button
	closeButton.MouseButton1Click:Connect(function()
		closeGUI(mainFrame)
	end)
	
	closeButton.MouseEnter:Connect(function()
		AnimationFunctions.close_hoverEnter(closeButton)
	end)
	
	closeButton.MouseLeave:Connect(function()
		AnimationFunctions.close_hoverLeave(closeButton)
	end)
	
end