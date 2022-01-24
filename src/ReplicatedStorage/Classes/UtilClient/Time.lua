local Framework = shared.Framework

local Time = {}

function Time:wait(n)
	local t = 0
	n = n or 0
	repeat
		local dt = game:GetService("RunService").RenderStepped:wait()
		if Framework.ClientController.paused:ready() then
			t = t + dt
		end
	until t >= n
	return t
end

function Time:waitObject(n, o)
	local t = 0
	local st = o.globalTime or 0
	repeat
		game:GetService("RunService").RenderStepped:wait()
		t = (o.globalTime or 0) - st
	until t >= n
	return t
end

function Time:waitFor(n)
	local t = 0
	n = n or 0
	repeat
		local dt = game:GetService("RunService").RenderStepped:wait()
		t = t + dt
	until t >= n
	return t
end

function Time:renderLoop(f, ti)
	local t = 0
	repeat
		local dt = game:GetService("RunService").RenderStepped:wait()
		if Framework.ClientController.paused:ready() then
			t = t + dt
			f(t, dt)
		end
	until t >= ti
	return t
end

return Time