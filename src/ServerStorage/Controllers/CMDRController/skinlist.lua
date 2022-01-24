-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = shared.Framework

return {
	Name = "skinlist";
	Description = "Gets a list of all of the skins.";
	Group = "DefaultDebug";
	Args = {};

	Run = function(context)
		local tab = {}
		for i,v in next, Framework.Enums.Skins:getChildren() do
			tab[#tab+1] = v.name
		end
		for i = 1,math.ceil(#tab/10) do
			local count = math.min(10, #tab - (#tab - i * 10 + 10))
			local off = (#tab - i * 10 + 10)
			local str = ""
			for j = 1,count do
				local v = tab[off + j]
				if j ~= 1 then
					str = str..", "..'"'..v..'"'
				else
					str = '"'..v..'"'
				end
			end
			context:Reply(str)
		end
		return "Skin list returned."
	end
}