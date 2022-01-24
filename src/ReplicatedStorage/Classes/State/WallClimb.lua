local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)

function State:start(character)
	
end

function State:update(dt, character)
	local Util = Framework.Util
	local ray = Ray.new(character.physics.Position,-character.wallNormal * 2)
	local p,pos,normal = Util.Modules.Raycast(ray, character.ignoreTable, function(npart)
		return shared.Class:get("Wall").objects[npart]
	end)
	if not p then
		character:changeState("None")
	else
		character.tiltMod = .1
		character.wallNormal = normal
		local dir = Util.Vectors:hor(Util.Vectors:rotateVector(Vector3.new(character.rawInput.X,0,0),workspace.CurrentCamera.CFrame),-character.rawInput.Z)
		dir = Util.Planes:getClosestPoint(character.wallNormal, Vector3.new(), dir)
		if dir.magnitude > 0 then
			dir = dir.Unit
		end
		local speed = dir * character.speed * .75
		speed = speed + p.Velocity
		speed = Util.Planes:getClosestPoint(character.wallNormal, Vector3.new(), speed)
		character.actualGravity = 0
		character.force = character.force - character.wallNormal * character.physics:GetMass() * 50
			+ (speed - character.physics.Velocity) * character.physics:GetMass() * 25
		character.charAnim = "WallClimb"
		character.charAnimSpeed = math.clamp((character.physics.Velocity - p.Velocity).magnitude/10,0,1)
	end
end

function State:stop(character)
	
end

return State