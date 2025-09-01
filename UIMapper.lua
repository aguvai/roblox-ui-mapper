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
	
	* GUIs not following these conventions will be ignored.
	* Names are not case sensitive
--]]
---------------------------------------------------------------------

-- * Names will not be case sensitive
local preferences = {

	naming_rules = {
		closeButton_name = "GUICloseButton",
		mainFrame_name = "mainFrame",
		associatedOpenPrompts_name = "associatedOpenPrompts",
	},
	
	UI_openTween = {
		time = .25,
		easingStyle = Enum.EasingStyle.Quart,
		easingDirection = Enum.EasingDirection.InOut,
	},
	
	UI_restingPosition = UDim2.new(0.5, 0, -1.5, 0),
}

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

		end
	end
end


-- [[ OPEN/CLOSE GUI FUNCTIONS ]] --

local function clearGUIs()
	for _, gui in pairs(guiMap) do
		gui.mainFrame.Visible = false
		gui.mainFrame.Position = preferences.UI_restingPosition
	end
end

local tweenPreferences = preferences.UI_openTween

for index, gui in pairs (guiMap) do
	gui.openButton.MouseButton1Click:Connect(function()
		if gui.mainFrame.Visible then return end
		
		clearGUIs()
		gui.mainFrame.Visible = true
		gui.mainFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), tweenPreferences.easingDirection, tweenPreferences.easingStyle, tweenPreferences.time, true)
	end)
end