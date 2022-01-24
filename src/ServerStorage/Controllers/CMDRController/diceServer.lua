-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author 

local Framework = _G.Framework

local funcs = {
	get = function(context, players)
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			if pObject then
				context:Reply(v.Name.." has "..pObject.Data.dice.." dice.")
			end
		end
	end,
	give = function(context, players, value)
		if not value then
			return "Value required!"
		end
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			if pObject then
				pObject.Data.dice = pObject.Data.dice + value
				pObject.Data:update()
			end
		end
		return ("Gave %d dice to %d people."):format(value, #players)
	end,
	take = function(context, players, value)
		if not value then
			return "Value required!"
		end
		for i,v in next, players do
			local pObject = Framework.Players[v.userId]
			if pObject then
				pObject.Data.dice = math.max(0,pObject.Data.dice - value)
				pObject.Data:update()
			end
		end
		return ("Took %d dice from %d people."):format(value, #players)
	end
}

return function (context, func, players, value)
	if funcs[func] then
		return funcs[func](context, players, value)
	end

	return "Invalid function!"
end