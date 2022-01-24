-- Spawns a new thread without waiting one step
-- @documentation https://rostrap.github.io/Libraries/Helper/FastSpawn/
-- @source https://raw.githubusercontent.com/RoStrap/Helper/master/FastSpawn.lua
-- @rostrap FastSpawn
-- @author Validark

local Instance_new = Instance.new

local function FastSpawn(Func, ...)
    --- Spawns a new thread to run a function on without waiting one step
    -- @param function Func The function to run on a new thread
	-- @{...} parameters to pass to Func


    local Bindable = Instance_new("BindableEvent")

	if ... ~= nil then
		local t = {...}
		Bindable.Event:Connect(function()
			Func(unpack(t))
		end)
	else
		Bindable.Event:Connect(Func)
	end

    Bindable:Fire()
    Bindable:Destroy()
end

return FastSpawn
