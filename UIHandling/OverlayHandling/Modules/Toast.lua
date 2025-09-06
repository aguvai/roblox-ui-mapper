types = {
	"success",
	"error",
	"info",
	"warning",
}

local Preferences = require(script.Parent.Parent.Preferences)

local TweenService = game:GetService("TweenService")
local template = script:WaitForChild("ToastTemplate")

local typeColors = {
	["success"] = Color3.fromRGB(66, 226, 63),
	["error"] = Color3.fromRGB(186, 15, 15),
	["info"] = Color3.fromRGB(227, 227, 227),
	["warning"] = Color3.fromRGB(255, 185, 44)
}

local function normalizeText(options)
	local textColor = typeColors[options.type]
	if textColor == nil then
		-- fallback to info if type is invalid
		textColor = typeColors.info
		options.type = "info" 
	end
	
	if options.type ~= "info" then
		options.primary_text = string.format("%s: %s", string.upper(options.type), options.primary_text)
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
	
	-- initialize
	self.gui.Message.TextColor3 = textColor
	self.gui.BackgroundTransparency = 1
	self.gui.Message.TextTransparency = 1
	
	self.gui.Visible = true
	
	-- instance state
	self.options = options

	-- set primary text
	self.gui.Message.Text = options.primary_text

	-- animate in
	self:tweenIn()

	return self
end

-- [[ TWEEN FUNCTIONS ]] --
-- // Tween in
function Toast:tweenIn()
	-- tween background transparency in to .92
	local tweenBackground = TweenService:Create(self.gui, Preferences.Toast.TweenInInfo, {
		BackgroundTransparency = .92
	})
	tweenBackground:Play()
	
	-- tween message transparency in to 0
	local tweenText = TweenService:Create(self.gui.Message, Preferences.Toast.TweenInInfo, {
		TextTransparency = 0
	})
	tweenText:Play()
	
	task.spawn(function()
		task.wait(Preferences.Toast.secondsOnScreen)
		self:tweenOut()
	end)
end

function Toast:tweenOut()
	local tweenBackground = TweenService:Create(self.gui, Preferences.Toast.TweenOutInfo, {
		BackgroundTransparency = 1
	})
	tweenBackground:Play()
	
	local tweenText = TweenService:Create(self.gui.Message, Preferences.Toast.TweenOutInfo, {
		TextTransparency = 1
	})
	tweenText:Play()
	
	tweenBackground.Completed:Once(function()
		self.gui:Destroy()
	end)
end

return Toast