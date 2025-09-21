types = {
	"success",
	"error",
	"info",
	"warning",
}

local Preferences = require(script.Parent.Parent.Preferences)

local TweenService = game:GetService("TweenService")
local template = script:WaitForChild("ToastTemplate")
template.BackgroundTransparency = 1
template["2_Message"].TextTransparency = 1
template["1_Title"].TextTransparency = 1

local typeColors = {
	["success"] = Color3.fromRGB(165, 217, 175),
	["error"] = Color3.fromRGB(186, 80, 80),
	["info"] = Color3.fromRGB(220, 220, 220),
	["warning"] = Color3.fromRGB(255, 185, 44)
}

local function normalizeText(options)
	local textColor = typeColors[options.type]
	if textColor == nil then
		-- fallback to info if type is invalid
		textColor = typeColors.info
		options.type = "info" 
	end

	return textColor
end

local Toast = {}
Toast.__index = Toast

function Toast.new(overlayGUI, options)
	local self = setmetatable({}, Toast)

	local textColor = normalizeText(options)

	-- clone template
	self.gui = template:Clone()
	self.gui.Parent = overlayGUI:WaitForChild("ToastFrame", 5)
	
	if options.play_notification_sound ~= nil and options.play_notification_sound == true then
		self.gui.Parent.Notification:Play()
	end
	
	if options.type == "success" then
		self.gui["2_Message"].Visible = false
	end
	
	-- initialize
	self.gui["1_Title"].TextColor3 = textColor
	self.gui.BackgroundTransparency = 1
	self.gui["2_Message"].TextTransparency = 1
	self.gui["1_Title"].TextTransparency = 1

	self.gui.Visible = true

	-- instance state
	self.options = options

	-- set primary text
	self.gui["2_Message"].Text = options.primary_text
	self.gui["1_Title"].Text = options.title or ""

	-- animate in
	self:tweenIn()

	return self
end

-- [[ TWEEN FUNCTIONS ]] --
-- // Tween in
function Toast:tweenIn()
	local tweenBackground = TweenService:Create(self.gui, Preferences.Toast.TweenInInfo, {
		BackgroundTransparency = .825
	})
	tweenBackground:Play()

	-- tween message transparency in to 0
	local tweenText = TweenService:Create(self.gui["2_Message"], Preferences.Toast.TweenInInfo, {
		TextTransparency = 0
	})
	tweenText:Play()
	TweenService:Create(self.gui["1_Title"], Preferences.Toast.TweenInInfo, {
		TextTransparency = 0
	}):Play()

	task.spawn(function()
		task.wait(Preferences.Toast.secondsOnScreen)
		self:tweenOut()
	end)
end

function Toast:tweenOut()
	if not self.gui then return end
	
	local tweenBackground = TweenService:Create(self.gui, Preferences.Toast.TweenOutInfo, {
		BackgroundTransparency = 1
	})
	tweenBackground:Play()

	local tweenText = TweenService:Create(self.gui["2_Message"], Preferences.Toast.TweenOutInfo, {
		TextTransparency = 1
	})
	tweenText:Play()
	TweenService:Create(self.gui["1_Title"], Preferences.Toast.TweenOutInfo, {
		TextTransparency = 1
	}):Play()

	tweenBackground.Completed:Once(function()
		self.gui:Destroy()
	end)
end

return Toast