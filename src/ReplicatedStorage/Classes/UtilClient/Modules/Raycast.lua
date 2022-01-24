local t = {
	Whitelist = function(ray,white,conditions)
		if type(white) ~= "table" then
			white = {white}
		end
		conditions = conditions or function() return true end
		if type(conditions) ~= "function" then
			error("Conditions have to be a function or nil.")
		end
		local part,pos,normal
		local success
		while not success do
			part,pos,normal = workspace:FindPartOnRayWithWhitelist(ray,white)
			if part and conditions(part,pos,normal) then
				return part,pos,normal
			elseif part == nil or pos == ray.Origin + ray.Direction then
				part = false
			end
			ray = Ray.new(pos,ray.Direction + (ray.Origin - pos))
		end
		return part,pos,normal
	end
}

setmetatable(t,{
	__call = function(self,ray,ignore,conditions,pr)
		if type(ignore) ~= "table" then
			ignore = {ignore}
		end
		conditions = conditions or function() return true end
		if type(conditions) ~= "function" then
			error("Conditions have to be a function or nil.")
		end
		local success
		while not success do
			local part,pos,normal = workspace:FindPartOnRayWithIgnoreList(ray,ignore)
			if part and conditions(part,pos,normal) then
				return part,pos,normal
			elseif part == nil then
				return nil,pos,normal
			end
			table.insert(ignore,1,part)
		end
	end
})
return t

 --[[
	local f = require(workspace.RaycastConditional)
	print(f(Ray,Ignore,function(part,pos,normal)
		return part.Name == "Part"
	end)
	print(f.Whitelist(Ray,Whitelist,function(part,pos,normal)
		return part.Name == "Part"
	end)
 --]]