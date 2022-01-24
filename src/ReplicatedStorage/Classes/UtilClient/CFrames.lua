local CFrames = {}

function CFrames:getRot(cframe)
	return cframe - cframe.p
end

function CFrames:lerpRotation(cfS, cfR, alpha) --lerp cfS's rotation to cfR's rotation at cfR's position
	return CFrame.new(cfR.p) * CFrames:getRot(cfS):lerp(CFrames:getRot(cfR), alpha)
end

function CFrames:getRVelocity(floor, dt) --gets the horizontal rotvelocity of a part
	local rot = floor.RotVelocity
	if floor:FindFirstChild("Pivot") and floor.Pivot:IsA("ObjectValue") then
		floor = floor.Pivot.Value
	end
	local frot = CFrames:getRot(floor.CFrame)
	rot = frot * CFrame.Angles((rot.X * dt),(rot.Y * dt),(rot.Z * dt)) * frot:inverse()
	return rot
end

return CFrames