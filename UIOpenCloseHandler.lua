-- [[ SERVICES ]] --
local TweenService = game:GetService("TweenService")

-- [[ VARIABLES ]] --
local playerGUI = script.Parent
local buttonHolder = playerGUI:WaitForChild("ButtonHolder")

-- [[ MODULES ]] --
local UIHandler = game.ReplicatedStorage.UIHandling
local ScreenButtonHandling = UIHandler.ScreenButtonHandling

local Preferences = require(ScreenButtonHandling.Preferences)
local AnimationFunctions = require(ScreenButtonHandling.AnimationFunctions)
local GUIMapper = require(ScreenButtonHandling.GUIMapper)
local SpecialButtonFunctions = require(ScreenButtonHandling.SpecialButtonFunctions)

---------------------------------------------------------------------

-- [[ Store button-to-GUI mappings ]] --

local GUIMap = nil

for _, holder in ipairs (buttonHolder:GetChildren()) do
	for _, button in ipairs (holder:GetChildren()) do
		local guiName = button.Name:gsub("_OpenButton", "")

		local gui = playerGUI:FindFirstChild(guiName)
		if gui then
			GUIMapper.mapGUIToContentsFromButton(gui, button)
			GUIMap = GUIMapper:getMap()
		else
			-- If we can't link a button to a GUI, we handle it differently
			local handled = SpecialButtonFunctions:handle(button, game.Players.LocalPlayer)
			if not handled then
				warn(string.format("No GUI or special action defined for button '%s'", button.Name))
			end
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


-- [[ OPEN/CLOSE FUNCTIONS ]] --
for index, gui in pairs (GUIMap) do
	
	local openButton = gui.openButton
	local closeButton = gui.closeButton
	local proximityPrompts = gui.proximityPrompts
	local mainFrame = gui.mainFrame
	
	-- // 1. Open Button
	openButton.MouseButton1Click:Connect(function()
		AnimationFunctions.openGUI(mainFrame)
	end)
	
	openButton.MouseEnter:Connect(function()
		AnimationFunctions.openButton_hoverEnter(openButton)
	end)
	
	openButton.MouseLeave:Connect(function()
		AnimationFunctions.openButton_hoverLeave(openButton)
	end)
	
	-- // 2. ProximityPrompts
	for _, prompt in pairs (gui.proximityPrompts) do
		prompt.Triggered:Connect(function()
			AnimationFunctions.openGUI(mainFrame)
		end)
	end
	
	-- // 3. Close Button
	closeButton.MouseButton1Click:Connect(function()
		AnimationFunctions.closeGUI(mainFrame)
	end)
	
	closeButton.MouseEnter:Connect(function()
		AnimationFunctions.closeButton_hoverEnter(closeButton)
	end)
	
	closeButton.MouseLeave:Connect(function()
		AnimationFunctions.closeButton_hoverLeave(closeButton)
	end)
end