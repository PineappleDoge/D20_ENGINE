local Framework = shared.Framework
local Util = Framework.Util

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)

function Controller:kick(str)
	game.Players.LocalPlayer:Kick(str)
end

coroutine.wrap(function()
	local remote = Instance.new('RemoteEvent')
	local dump = string.dump
	local wait = wait
	local pcall = pcall
	local Controller = Controller
	local kickf = Controller.kick
	local kick = function(...)
		kickf(Controller, ...)
	end
	while wait() do
	    if pcall(dump, remote.FireServer) then
	        kick("Attempting to change RemoteEvents")
	    end
	end
end)

coroutine.wrap(function()
	 game:WaitForChild("Script Context").Name = os.time()*math.random(-os.time(),os.time())
end)

return Controller