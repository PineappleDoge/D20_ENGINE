local Vectors = {}

function Vectors:hor(v, h)
	return Vector3.new(v.X, h or 0, v.Z)
end

function Vectors:rotateVector(vector, cframe)
	local rot = math.atan2(cframe.lookVector.X,cframe.lookVector.Z) + math.pi
	return (CFrame.Angles(0,rot,0) * CFrame.new(vector)).p
end

function Vectors:getVelocity(floor, posOnFloor, accuracy) --gets the velocity of a position on the floor
	accuracy = accuracy or 6
	local vel = floor.Velocity
	local rot = floor.RotVelocity
	rot = CFrame.Angles((rot.X/accuracy),(rot.Y/accuracy),(rot.Z/accuracy))
	if floor:FindFirstChild("Pivot") and floor.Pivot:IsA("ObjectValue") then
		floor = floor.Pivot.Value
	end
	local posOffset = floor.CFrame:inverse() * CFrame.new(posOnFloor)
	return vel + ((floor.CFrame * rot * posOffset).p - posOnFloor) * accuracy
end

function Vectors:rot90(vector)
	return Vectors:rotateVector(vector, CFrame.Angles(0,math.pi/2,0))
end

function Vectors:lerpStud(s, e, a)
	a = a or 1
	if (s - e).magnitude > a then
		local alpha = a/(s - e).magnitude
		return s:lerp(e, alpha)
	else
		return e
	end
end

function Vectors:getRandomPos(part)
	return (part.CFrame * CFrame.new((math.random() - .5) * part.Size.X,(math.random() - .5) * part.Size.Y,(math.random() - .5) * part.Size.Z)).p
end

function Vectors:isColliding(part, pos)
	local offset = part.CFrame:inverse() * CFrame.new(pos)
	offset = offset.p + part.Size/2
	return offset.X > 0 and offset.X < part.Size.X and
		offset.Y > 0 and offset.Y < part.Size.Y and
		offset.Z > 0 and offset.Z < part.Size.Z
end

return Vectors