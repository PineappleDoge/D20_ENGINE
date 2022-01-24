local Framework = shared.Framework

local Lines = {}

function Lines:getClosestPoint(pointA, pointB, vector)
	local dir = (pointB - pointA).Unit
	return Framework.Util.Planes:getClosestPoint(dir, vector, pointA + (pointA - pointB).Unit * 1000)
end

return Lines