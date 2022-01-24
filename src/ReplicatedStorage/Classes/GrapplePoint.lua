local Framework = shared.Framework

local GrapplePoint = shared.Class:new()
GrapplePoint.object = nil
GrapplePoint.objects = {}
GrapplePoint.enabled = true

function GrapplePoint:update(dt)
	
end

function GrapplePoint:isObject(inst)
	return inst.Name == "GrapplePoint"
end

function GrapplePoint:Destroy()
	self.object:Destroy()
end

GrapplePoint:construct("GrapplePoint", function(newGP, object)
	newGP.object = object
	newGP.objects[object] = newGP
	object.Parent = workspace.Classes
end)

return GrapplePoint