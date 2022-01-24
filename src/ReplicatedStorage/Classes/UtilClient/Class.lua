local Framework = shared.Framework

local Class = {}

function Class:getObject(inst)
	for i,v in next, shared.Class.__classes do
		if i ~= "Object" and v.isObject and v:isObject(inst) then
			local newFramework = v:new(inst)
			if inst:FindFirstChild("Execute") then
				coroutine.wrap(require(inst.Execute))(newFramework)
			end
			return newFramework
		end
	end
	if shared.Class:get("Object"):isObject(inst) then
		local newFramework = shared.Class:create("Object", inst)
		if inst:FindFirstChild("Execute") then
			coroutine.wrap(require(inst.Execute))(newFramework)
		end
		return newFramework
	end
end

function Class:createClasses(inst)
	for i,v in next, inst:GetChildren() do
		Class:getObject(v)
	end
end

function Class:getObjects(objectParts, region3)
	local parts = workspace:FindPartsInRegion3WithWhiteList(region3, objectParts)
	local objectIndex = {}
	local objects = {}
	for i,v in next, parts do
		local object = shared.Class:get("Object"):getObject(v)
		if object and not objectIndex[object] then
			objects[#objects + 1] = v
			objectIndex[object] = true
		end
	end
	return objects
end

function Class:getObjectsInRadius(objectParts, position, radius, bypass)
	local region3 = Region3.new(position - Vector3.new(radius,radius,radius),position + Vector3.new(radius,radius,radius))
	local parts = workspace:FindPartsInRegion3WithWhiteList(region3, objectParts, 25)
	local objectIndex = {}
	local objects = {}
	for i,v in next, parts do
		if bypass or (v.Position - position).magnitude <= radius then
			local object = shared.Class:get("Object"):getObject(v)
			if object and not objectIndex[object] then
				objects[#objects + 1] = object
				objectIndex[object] = true
			end
		end
	end
	return objects
end

return Class