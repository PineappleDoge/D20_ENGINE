-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author 

local Framework = _G.Framework

return function (context, text)
	for i,v in next, Framework.Players:getChildren() do
		v:fireNet(v.object, "message", text)
	end

	return "Created announcement."
end