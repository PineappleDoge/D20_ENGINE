local Framework = _G.Framework

local Enums = _G.Class:new()
Enums:setName("Enums")
Enums:setParent(Framework)
Enums:generate()

for i,v in next, script:GetChildren() do
	v = require(v)
	v:setParent(Enums)
	v:generate()
	for i,v in next, v:getDescendants() do
		v:generate()
	end
end

return Enums