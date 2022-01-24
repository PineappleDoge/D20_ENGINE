-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author 

local Framework = _G.Framework

return function (context, text)
	coroutine.wrap(function()
		Framework.ServerController:shutdown()
	end)()

	return "Shutting down..."
end