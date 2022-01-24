-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, player, time, reason)
	time = Framework.Util.String:extractTime(time)
	local success = Framework.ServerController:tempBan(player, reason, time, context.Executor)
	if success == true then
		return "Tempbanned "..player.."."
	elseif success then
		return success
	else
		return "Couldn't find a user of that name!"
	end
end