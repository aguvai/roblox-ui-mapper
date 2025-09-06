local Preferences = require(script.Parent.Parent.Preferences)

local template = script:WaitForChild("ModalTemplate")


-- [[ ANIMATION FUNCTIONS ]] --
local TweenService = game:GetService("TweenService")

local function eminatingGlow(icon)
	local glow = icon.EminatingLight
	if not glow then return end

	task.spawn(function()
		while glow.Parent == icon do
			local tweenIn = TweenService:Create(glow, TweenInfo.new(.7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.95
			})
			tweenIn:Play()
			tweenIn.Completed:Wait()

			local tweenOut = TweenService:Create(glow, TweenInfo.new(.7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.98
			})
			tweenOut:Play()
			tweenOut.Completed:Wait()
		end
	end)
end


-- [[ BUILD FUNCTIONS ]] --

local function buildLeftSide(leftSide, rightSide, options)
	local icon = leftSide["1_Icon"]
	local supplementaltext = leftSide["2_SupplementalTextFrame"].SupplementalText

	if (options.icon_id == nil or options.icon_id == "") and (options.under_icon_text == nil or options.under_icon_text == "") then
		leftSide.Visible = false
		rightSide.Size = UDim2.new(.8, 0, .9, 0)
	else
		if options.icon_id ~= nil then
			icon.Image = "rbxassetid://"..options.icon_id
	
			eminatingGlow(icon)

			local iconText = icon.IconText
			iconText.Text = options.icon_text or ""
		end
		if options.under_icon_text ~= nil and options.under_icon_text ~= "" then
			supplementaltext.Text = options.under_icon_text
		else
			supplementaltext.Parent.Visible = false
		end
	end
end


local function buildRightSide(leftSide, rightSide, options)
	local primaryText = rightSide["1_PrimaryTextFrame"].MainText
	primaryText.Text = options.primary_text
	
	-- Action button handling
	local button = rightSide["2_ButtonFrame"]

	local buttonText = button.ButtonText
	buttonText.Text = options.button_text

	local buttonStrikethroughText = button.StrikethroughText
	
	if options.button_strikethrough_text == nil or options.button_strikethrough_text == "" then
		buttonStrikethroughText.Visible = false
	else
		buttonStrikethroughText.Text = options.button_strikethrough_text
	end
	
	local buttonHitbox = button.Hitbox
	buttonHitbox.MouseButton1Click:Connect(function()
		if options.button_action then
			options.button_action()
		end
		--TODO: TWEEN OUT
	end)
end

-- [[ * MAIN * ]] --

local Modal = {}

function Modal.show(overlayGUI, options)
	local modalHolder = overlayGUI:WaitForChild("ModalFrame", 5)
	if not modalHolder then warn("Could not find ModalFrame in OverlayGUI!") return end
	
	local modal = template:Clone()
	modal.Parent = modalHolder
	modal.Visible = true
	
	-- [[ EXTERNALS ]] --
	modal.Title.Text = options.title
	modal.CloseButton.MouseButton1Click:Connect(function()
		
	end)
	
	-- [[ MAINFRAME ]] --
	local mainframe = modal.MainFrame
	local leftSide = mainframe.LeftSide
	local rightSide = mainframe.RightSide
	
	-- [[ LEFT SIDE ]] --
	buildLeftSide(leftSide, rightSide, options)
	
	-- [[ RIGHT SIDE ]] --
	buildRightSide(leftSide, rightSide, options)
	
end 

return Modal