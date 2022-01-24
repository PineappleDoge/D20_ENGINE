local Framework = shared.Framework

local Wall = shared.Class:new()
Wall.object = nil
Wall.objects = {}

function Wall:update(dt)
	
end

function Wall:isObject(inst)
	return inst:IsA("TrussPart") or inst.Name == "WallClimb"
end

function Wall:Destroy()
	self.object:Destroy()
end

Wall:construct("Wall", function(newWall, object)
	newWall.object = object
	newWall.objects[object] = newWall
	object.Parent = workspace.Classes
end)

return Wall