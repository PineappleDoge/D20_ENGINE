local Framework = shared.Framework

local Threshold = shared.Class:new()
Threshold.count = 0

function Threshold:add(n)
	self.count = self.count + n
end

function Threshold:sub(n)
	self.count = self.count - n
end

function Threshold:ready()
	return self.count <= 0
end

Threshold:construct("Threshold")

return Threshold