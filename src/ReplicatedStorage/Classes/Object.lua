local Framework = shared.Framework

local Object = shared.Class:new()
Object.objects = {}
Object.interacts = {}
Object.touches = {}
Object.object = nil
Object.lastUpdated = 0
Object.lastTouched = 0
Object.entered = false

function Object:update(dt)
	
end
function Object:enter()
	
end
function Object:exit()
	
end

function Object:getPosition()
	return Vector3.new()
end

function Object:getObject(instance)
	local parent = instance
	while parent and not self.objects[parent] do
		parent = parent.Parent
	end
	return self.objects[parent]
end

function Object:canInteract()
	local inputController = Framework.InputController
	return inputController.canInput:ready() and Framework.Character and Framework.Character.state == "None" and Framework.Character.floor
end

--make [:update(dt), :getPosition()], [:pause(), :unpause()], [:canInteract(), :interact()], [:touch(), :enter(), :exit()]

function Object:isObject(inst)
	return inst:FindFirstChild("Execute")
end

function Object:setInteract()
	self.interacts[#self.interacts + 1] = self.object
end

function Object:setTouch()
	self.touches[#self.touches + 1] = self.object
end

function Object:Destroy()
	self.object:Destroy()
end

Object:construct("Object", function(newObject, inst)
	newObject.object = inst
	newObject.objects[inst] = newObject
	
	inst.AncestryChanged:connect(function()
		if not inst:IsDescendantOf(game) then
			newObject:destroy()
		end
	end)
end)

return Object