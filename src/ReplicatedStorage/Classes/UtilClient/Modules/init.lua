local Modules = {}

for i,v in next, script:GetChildren() do
	Modules[v.Name] = require(v)
end

return Modules