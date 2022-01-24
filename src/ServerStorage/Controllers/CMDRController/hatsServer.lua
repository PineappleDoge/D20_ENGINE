-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author 

local Framework = _G.Framework

local funcs = {
	get = function(context, players, value)
		if value == "None" then
			return "The players have this. Trust me."
		end
		if not Framework.Enums.Hats:find(value) then
			return "This hat doesn't exist!"
		end
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			if pObject then
				local str = "doesn't have"
				if pObject.Hats:find(value) then
					str = "has"
				end
				context:Reply(v.Name.." "..str.." the "..value.." hat.")
			end
		end
	end,
	give = function(context, players, value)
		if value == "None" then
			return "You can't give a player nothing."
		end
		if not Framework.Enums.Hats:find(value) then
			return "This hat doesn't exist!"
		end
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			pObject:awardHat(value, true)
		end
		return ("Gave the %s hat to %d people."):format(value, #players)
	end,
	take = function(context, players, value)
		if value == "None" then
			return "You can't take nothing from a player."
		end
		if not Framework.Enums.Hats:find(value) then
			return "This hat doesn't exist!"
		end
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			if pObject then
				if pObject.Data.hat == value then
					pObject:setHat("None")
				end
				if pObject.Hats:find(value) then
					pObject.Hats:find(value):destroy()
				end
			end
		end
		return ("Took the %s hat from %d people."):format(value, #players)
	end
}

return function (context, func, players, value)
	if funcs[func] then
		return funcs[func](context, players, value)
	end

	return "Invalid function!"
end