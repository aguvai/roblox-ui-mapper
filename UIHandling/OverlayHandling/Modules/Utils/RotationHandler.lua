local TweenService = game:GetService("TweenService")

local RotationHandler = {}

function RotationHandler.normalizeRotation(container)
	local cache = {}
	for _, obj in ipairs(container:GetDescendants()) do
		if obj:IsA("GuiObject") and obj.Rotation ~= 0 then
			cache[obj] = obj.Rotation
			obj.Rotation = 0
		end
	end
	return cache
end

function RotationHandler.restoreRotation(cache, forceZero, duration)
	if not cache then return end
	duration = duration or 0.4

	for obj, rotation in pairs(cache) do
		if typeof(obj) == "Instance" and obj:IsA("GuiObject") then
			local targetRotation = forceZero and 0 or tonumber(rotation)

			local tween = TweenService:Create(
				obj,
				TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
				{ Rotation = targetRotation }
			)
			tween:Play()
		end
	end
end

return RotationHandler