-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, player, reason)
	local success = Framework.ServerController:unban(player, reason, context.Executor)
	if success then
		return "Unbanned "..player.."."
	else
		return "Couldn't find a user of that name!"
	end
end