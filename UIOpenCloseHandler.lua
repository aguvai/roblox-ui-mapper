-- [[ SERVICES ]] --
local TweenService = game:GetService("TweenService")

-- [[ VARIABLES ]] --
local playerGUI = script.Parent
local buttonHolder = playerGUI:WaitForChild("ButtonHolder")

-- [[ MODULES ]] --
local modules = game.ReplicatedStorage.UIHandling
local Preferences = require(modules.UIPreferences)
local AnimationFunctions = require(modules.AnimationFunctions)
local GUIMapper = require(modules.GUIMapper)

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

GUIMap = nil

for _, holder in ipairs (buttonHolder:GetChildren()) do
	for _, button in ipairs (holder:GetChildren()) do
		local guiName = button.Name:gsub("_OpenButton", "")

		local gui = playerGUI:FindFirstChild(guiName)
		if gui then
			GUIMapper.mapGUIToContentsFromButton(gui, button)
			GUIMap = GUIMapper:getMap()
		else
			-- If we can't link a button to a GUI, we handle it differently
			
		end
	end
end


-- [[ NORMALIZE UI ON GAME START ]] --
coroutine.wrap(function()
	for index, gui in pairs (GUIMap) do
		gui.mainFrame.Position = Preferences.UI_closedPosition
		gui.mainFrame.Visible = false
	end
end)()


-- [[ OPEN/CLOSE GUI FUNCTIONS ]] --

-- // Helpers
local function clearGUIs()
	for _, gui in pairs(GUIMap) do
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
for index, gui in pairs (GUIMap) do
	
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