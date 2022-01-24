-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author 

local Framework = _G.Framework

local funcs = {
	get = function(context, players, value)
		if not Framework.Enums.Skins:find(value) then
			return "This skin doesn't exist!"
		end
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			if pObject then
				local str = "doesn't have"
				if pObject.Skins:find(value) then
					str = "has"
				end
				context:Reply(v.Name.." "..str.." the "..value.." skin.")
			end
		end
	end,
	give = function(context, players, value)
		if not Framework.Enums.Skins:find(value) then
			return "This skin doesn't exist!"
		end
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			pObject:awardSkin(value, true)
		end
		return ("Gave the %s skin to %d people."):format(value, #players)
	end,
	take = function(context, players, value)
		if value == "Black & White" then
			return "You can't take D20's favorite skin away. It's against the law."
		end
		if not Framework.Enums.Skins:find(value) then
			return "This skin doesn't exist!"
		end
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			if pObject then
				if pObject.Data.skin == value then
					pObject:setSkin("Black & White")
				end
				if pObject.Skins:find(value) then
					pObject.Skins:find(value):destroy()
				end
			end
		end
		return ("Took the %s skin from %d people."):format(value, #players)
	end
}

return function (context, func, players, value)
	if funcs[func] then
		return funcs[func](context, players, value)
	end

	return "Invalid function!"
end