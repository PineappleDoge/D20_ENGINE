local Framework = shared.Framework

local State = shared.Class:new()
State:setName("States")
State:setParent(Framework)

function State:start(character)
	
end

function State:update(dt, character)
	
end

function State:stop(character)
	
end

State:construct("State")

return State