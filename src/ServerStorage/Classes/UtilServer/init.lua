local Framework = _G.Framework

local Util = _G.Class:new()
Util:setName("Util")
Util:setParent(Framework)

for i,v in next, script:GetChildren() do
	Util[v.Name] = require(v)
end

return Util