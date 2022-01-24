-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, player, reason)
	local success = Framework.ServerController:ban(player, reason, context.Executor)
	if success == true then
		return "Banned "..player.."."
	elseif success then
		return success
	else
		return "Couldn't find a user of that name!"
	end
end