-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, player, reason)
	local Util = Framework.Util
	local bData = Framework.ServerController:getBan(player)
	if bData then
		if bData then
			if bData.Until == 0 then
				return "User has been permbanned by "..bData.BannedBy.." for: "..bData.Reason
			end
			if bData.Until == 1 then
				return "User has been unbanned by "..bData.BannedBy.." for: "..bData.Reason
			end
			if os.time() < bData.Until then
				local timeString = Util.String:getTime(math.ceil(bData.Until - os.time()))
				return "User has been tempbanned by "..bData.BannedBy.." for "..timeString.." for: "..bData.Reason
			else
				return "User has been tempbanned by "..bData.BannedBy.." for (unbanned) for: "..bData.Reason
			end
		end
	else
		return "Couldn't find a user of that name!"
	end
end