local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)

function State:start(character)
	character.specialMoves = character.specialMoves + 1
	character.wallNormal = nil
	local move = Framework.localPlayer.Data.move
	return Framework.States[move]:start(character)
end

function State:update(dt, character)
	local move = Framework.localPlayer.Data.move
	return Framework.States[move]:update(dt, character)
end

function State:stop(character)
	local move = Framework.localPlayer.Data.move
	return Framework.States[move]:stop(character)
end

return State