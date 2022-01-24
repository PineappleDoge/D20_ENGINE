local Planes = {}

function Planes:solveFor(variable, normal, pos, vector) --y = (d - mx - oz)/n [mx + ny + oz = d]
	if normal[variable] == 0 then
		return 0
	end
	pos = pos or Vector3.new()
	local Plane = {
		X = normal.X,
		Y = normal.Y,
		Z = normal.Z,
		D = normal.X * pos.X + normal.Y * pos.Y + normal.Z * pos.Z
	}
	local sum = Plane.D
	for i,v in next, Plane do
		if i ~= variable and i ~= "D" then
			sum = sum - v * vector[i]
		end
	end
	return sum/normal[variable]
end

function Planes:getDistance(normal, pointOnPlane, vector)
	return normal:Dot(vector - pointOnPlane)
end

function Planes:getClosestPoint(normal, pointOnPlane, vector)
	local Plane = {
		X = normal.X,
		Y = normal.Y,
		Z = normal.Z,
		D = normal.X * pointOnPlane.X + normal.Y * pointOnPlane.Y + normal.Z * pointOnPlane.Z
	}
	local dist = Planes:getDistance(normal, pointOnPlane, vector)
	return vector - dist * normal
end

return Planes