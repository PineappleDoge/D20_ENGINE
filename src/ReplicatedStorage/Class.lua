Class = {}
_G.Class = Class
shared.Class = Class

Class.__classes = {Class = Class}
Class.__client = game.Players.LocalPlayer
Class.__server = not Class.__client
Class.__instances = {}
Class.__instanceLocation = nil
Class.__generated = Instance.new("BindableEvent")

Class.name = "Class"
Class.classType = "Class"
Class.instance = nil
Class.destroyed = false
Class.created = {}
Class.events = {}
Class.netEvents = {}
Class.invokes = {}
Class.netInvokes = {}
Class.parent = nil
Class.children = {}
Class.superclasses = {}
Class.subclasses = {}
Class.connections = {}
Class.constructor = function(newClass) end
Class.constructors = {}
Class.self = {}
Class.__wrapper = {self = Class}
Class.wrapMeta = {
	__index = function(wrap, index)
		return wrap.self[index]
	end,
	__newindex = function(wrap, index, value)
		if wrap[index] ~= value then
			wrap.self[index] = value
		end
	end,
	__tostring = function(wrap)
		local self = wrap.self
		return self.name.." ("..self.classType..")"
	end
}

local wait = function(val)
	local start = tick()
	val = val or 0
	repeat
		if Class.__server then
			game:GetService("RunService").Heartbeat:wait()
		else
			game:GetService("RunService").RenderStepped:wait()
		end
	until tick() - start >= val
end

function Class:new(...)
	local Arguments = {...}

	local newClass = {}
	newClass.__generated = Instance.new("BindableEvent")
	newClass.classType = self.classType
	newClass.instance = false
	newClass.destroyed = false
	
	newClass.created = {}
	newClass.events = {}
	newClass.netEvents = {}
	newClass.invokes = {}
	newClass.netInvokes = {}
	newClass.parent = nil
	newClass.children = {}
	newClass.superclasses = {}
	newClass.subclasses = {}
	newClass.connections = {}
	newClass.constructor = Class.constructor
	newClass.constructors = {}

	for i,v in next, self.superclasses do
		newClass.superclasses[i] = v
		v.created[#v.created + 1] = newClass
	end
	newClass.superclasses[#newClass.superclasses + 1] = self
	self.created[#self.created + 1] = newClass

	for i,v in next, self.constructors do
		newClass.constructors[i] = v
	end
	newClass.constructors[#newClass.constructors + 1] = {self.constructor, Arguments}

	newClass.__wrapper = {}
	newClass.__wrapper.self = newClass
	newClass.wrapMeta = {}
	for i,v in next,self.wrapMeta do
		newClass.wrapMeta[i] = v
	end

	setmetatable(newClass, {
		__index = function(newClass, index)
			if rawget(newClass, index) then
				return rawget(newClass, index)
			elseif self[index] then
				return self[index]
			else
				return Class.find(newClass,index)
			end
		end
	})
	
	setmetatable(newClass.__wrapper, newClass.wrapMeta)
	newClass = newClass.__wrapper
	
	for i,v in next, newClass.constructors do
		v[1](newClass, unpack(v[2]))
	end

	for i,v in next,newClass.superclasses do
		v:send("subCreate", newClass)
	end

	self:send("subCreate", newClass)
	self:send("create", newClass)
	
	newClass:send("finish")

	return newClass
end

function Class:construct(classType, constructor)
	if self.name == "Class" then
		self:setName(classType)
	end
	self.classType = classType
	self.__classes[classType] = self
	self.constructor = constructor
	for i,v in next,self.superclasses do
		v.subclasses[#v.subclasses + 1] = self
	end
end

function Class:get(classType)
	return self.__classes[classType]
end

function Class:create(classType, ...)
	return self:get(classType):new(...)
end

function Class:getProperties()
	local Props = {}
	for i,v in next,self.superclasses do
		for i,v in next,v.self do
			Props[i] = v
		end
	end
	for i,v in next,self.self do
		Props[i] = v
	end
	return Props
end

function Class:getClass(instance)
	if typeof(instance) ~= "Instance" then
		return nil
	end
	if not self.__instances[instance] and instance:FindFirstChild("classType") then
		return Class:generate(instance)
	end
	return self.__instances[instance]
end

function Class:setParent(newParent)
	local oldParent = self.parent
	if oldParent and oldParent.children[self.name] then
		for i,v in next,oldParent.children[self.name] do
			if v == self then
				table.remove(oldParent.children[self.name], i)
			end
		end
		if #oldParent.children[self.name] == 0 then
			oldParent.children[self.name] = nil
		end
		oldParent:send("childRemoved", self)
		repeat
			oldParent:send("descendantRemoved", self)
			oldParent = oldParent.parent
		until not oldParent
	end
	self.parent = newParent
	if newParent then
		newParent.children[self.name] = newParent.children[self.name] or {}
		newParent.children[self.name][#newParent.children[self.name] + 1] = self
		newParent:send("childAdded", self)
		repeat
			newParent:send("descendantAdded", self)
			newParent = newParent.parent
		until not newParent
	end
end

function Class:setName(newName)
	newName = tostring(newName)
	local parent = self.parent
	if parent and parent.children[self.name] then
		for i,v in next,parent.children[self.name] do
			if v == self then
				table.remove(parent.children[self.name], i)
			end
		end
		if #parent.children[self.name] == 0 then
			parent.children[self.name] = nil
		end
		parent.children[newName] = parent.children[newName] or {}
		parent.children[newName][#parent.children[newName] + 1] = self
	end
	self.name = newName
end

function Class:clearAllChildren()
	for i,v in next, self:getChildren() do
		v:destroy()
	end
end

function Class:getChildren()
	local Table = {}
	for i,v in next,self.children do
		for i,v in pairs(v) do
			Table[#Table + 1] = v
		end
	end
	return Table
end

function recurseDescendants(self, Table)
	for i,v in next, self:getChildren() do
		Table[#Table + 1] = v
		recurseDescendants(v, Table)
	end
end

function Class:getDescendants()
	local Table = {}
	recurseDescendants(self, Table)
	return Table
end

function Class:destroy()
	if self.destroyed then
		return
	end
	self:setParent(nil)
	self.destroyed = true
	local self = self.self
	self.wrapMeta.__tostring = function()
		return self.name.." (Destroyed)"
	end
	self:send("destroyed")
	for i,v in next,self:getChildren() do
		v:destroy()
	end
	if self.Destroy then
		self:Destroy()
	end
	if self.instance and self.__server then
		self.instance:Destroy()
	end
	setmetatable(self, {})
end

function Class:fire(name, ...)
	if self.events[name] then
		for i,v in next,self.events[name] do
			if (v[2].destroyed or not v[2]) then
				table.remove(self.events[name],i)
			else
				coroutine.wrap(v[1])(...)
			end
		end
	end
end

function Class:onEvent(name, obj, value)
	self.events[name] = self.events[name] or {}
	self.events[name][#self.events[name] + 1] = {value,obj}
	local ev = self.events[name][#self.events[name]]
	return function()
		for i,v in next,self.events[name] do
			if v == ev then
				table.remove(self.events[name],i)
			end
		end
	end
end

local fireServer = Instance.new("RemoteEvent").FireServer
local fireClient = Instance.new("RemoteEvent").FireClient

function Class:fireNet(target, name, ...)
	if not self.instance then
		error("Class needs instance to fire a net event!")
	end
	if self.__server then
		if type(target) ~= "table" then
			target = {target}
		end
		if target == nil then
			target = game.Players:GetChildren()
		end
		for i,v in next,target do
			fireClient(self.instance.RemoteEvent, v, name, ...) --Client reads as (name, ...)
		end
	else
		fireServer(self.instance.RemoteEvent, target, name, ...) --Server reads as (player, name, ...)
	end
end

function Class:onNetEvent(name, obj, value)
	self.netEvents[name] = self.netEvents[name] or {}
	self.netEvents[name][#self.netEvents[name] + 1] = {value,obj}
	local ev = self.netEvents[name][#self.netEvents[name]]
	return function()
		for i,v in next,self.netEvents[name] do
			if v == ev then
				table.remove(self.netEvents[name],i)
			end
		end
	end
end

function Class:doNetEvent(name, ...)
	if self.netEvents[name] then
		for i,v in next,self.netEvents[name] do
			if (v[2].destroyed or not v[2]) then
				table.remove(self.netEvents[name],i)
			else
				coroutine.wrap(v[1])(...)
			end
		end
	end
end

function Class:invoke(name, ...)
	local Table = {}
	if self.invokes[name] then
		for i,v in next,self.invokes[name] do
			if (v[2].destroyed or not v[2]) then
				table.remove(self.netEvents,i)
			else
				local Args = {...}
				if Table[i - 1] then
					for i,v in next,Table[i - 1] do
						Args[#Args + 1] = v
					end
				end
				Table[i] = {v[1](unpack(Args))}
			end
		end
	end
	return Table
end

function Class:onInvoke(name, obj, value)
	self.invokes[name] = self.invokes[name] or {}
	self.invokes[name][#self.invokes[name] + 1] = {value,obj}
	local ev = self.invokes[name][#self.invokes[name]]
	return function()
		for i,v in next,self.invokes[name] do
			if v == ev then
				table.remove(self.invokes[name],i)
			end
		end
	end
end

local invokeServer = Instance.new("RemoteFunction").InvokeServer
local invokeClient = Instance.new("RemoteFunction").InvokeClient

function Class:invokeNet(target, name, ...)
	if not self.instance then
		error("Class needs instance to invoke the net!")
	end
	if self.__server then
		return invokeClient(self.instance.RemoteFunction, target, name, ...) --Client reads as (name, ...)
	else
		return invokeServer(self.instance.RemoteFunction, target, name, ...) --Server reads as (player, name, ...)
	end
end

function Class:onNetInvoke(name, obj, value)
	self.netInvokes[name] = self.netInvokes[name] or {}
	self.netInvokes[name][#self.netInvokes[name] + 1] = {value, obj}
	local ev = self.netInvokes[name][#self.netInvokes[name]]
	return function()
		for i,v in next,self.netInvokes[name] do
			if v == ev then
				table.remove(self.netInvokes[name],i)
			end
		end
	end
end

function Class:doNetInvoke(name, ...)
	local Table = {}
	if self.netInvokes[name] then
		for i,v in next,self.netInvokes[name] do
			if (v[2].destroyed or not v[2]) then
				table.remove(self.netEvents,i)
			else
				Table[i] = {v[1](...)}
			end
		end
	end
	return Table
end

function Class:send(...)
	self:fire(...)
	return self:invoke(...)
end

function Class:isA(classType, supersIncluded)
	if supersIncluded ~= false then
		for i,v in next, self.superclasses do
			if v.classType == classType then
				return true
			end
		end
	end
	return self.classType == classType
end

function Class:isDescendantOf(ancestor)
	local Parent = Class
	repeat
		Parent = Parent.parent
	until Parent == ancestor or not Parent
	
	return Parent == ancestor
end

function Class:isAncestorOf(descendant)
	return descendant:isDescendantOf(self)
end

function Class:addConn(connection)
	self.connections[#self.connections + 1] = connection
end

function Class:generate(...)
	local arguments = {...}
	if self.__server then
		local instance = Instance.new("Folder")
		self.__instances[instance] = self
		self.instance = instance
		
		local rEvent = Instance.new("RemoteEvent")
		local rFunc = Instance.new("RemoteFunction")
		rEvent.Parent = instance
		rFunc.Parent = instance
		
		self:addConn(rEvent.OnServerEvent:connect(function(player, name, ...)
			self:doNetEvent(name, player, ...)
		end))
		rFunc.OnServerInvoke = function(player, name, ...)
			return self:doNetInvoke(name, player, ...)
		end
		
		self:onEvent("afterSet",self,function()
			self:update()
		end)
		
		self:update()
		instance.Parent = self.__instanceLocation
		self:send("generate")
		self.__generated:Fire()
		for i,v in next,self:getChildren() do
			v:update()
		end
		return instance
	else
		local instance = arguments[1]
		if not instance:IsA("Folder") then
			return
		end
		
		if self.__instances[instance] then
			return self.__instances[instance]
		end
		
		local class = self:create(instance:WaitForChild("classType").Value)
		self.__instances[instance] = class
		class.instance = instance
		
		local rEvent = instance:WaitForChild("RemoteEvent")
		local rFunc = instance:WaitForChild("RemoteFunction")
		
		class:addConn(rEvent.OnClientEvent:connect(function(...)
			class:doNetEvent(...)
		end))
		rFunc.OnClientInvoke = function(...)
			return class:doNetInvoke(...)
		end
		
		function getValue(ind,val)
			if ind == "instance" then
				return val
			end
			return self:getClass(val) or val
		end
		
		local process = function(value)
			if not value.ClassName:find("Remote") then
				class:addConn(value.Changed:connect(function()
					if value.Name == "parent" then
						class:setParent(getValue(value.Name, value.Value))
						class:send("update", value.Name)
						return
					end
					if value.Name == "name" then
						class:setName(value.Value)
						class:send("update", value.Name)
						return
					end
					class[value.Name] = getValue(value.Name, value.Value)
					class:send("update", value.Name)
				end))
				if value.Name == "parent" then
					class:setParent(getValue(value.Name, value.Value))
					return
				end
				if value.Name == "name" then
					class:setName(value.Value)
					return
				end
				class[value.Name] = getValue(value.Name, value.Value)
				value.AncestryChanged:connect(function()
					if not value:IsDescendantOf(game) then
						if value.Name == "parent" then
							class:setParent(nil)
							class:send("update", value.Name)
							return
						end
						class[value.Name] = nil
						class:send("update", value.Name)
					end
				end)
			end
		end
		
		class:addConn(instance.AncestryChanged:connect(function()
			if not instance:isDescendantOf(game) then
				class:destroy()
			end
		end))
		
		instance.ChildAdded:connect(process)
		for i,v in next,instance:GetChildren() do
			process(v)
		end
		
		class:send("generate")
		self.__generated:Fire()
		return class
	end
end

function Class:isAClass(value)
	return typeof(value) == "table" and value.classType
end

local valueTypes = {
	number = "NumberValue",
	string = "StringValue",
	boolean = "BoolValue",
	CFrame = "CFrameValue",
	Vector3 = "Vector3Value",
	Color3 = "Color3Value",
	Instance = "ObjectValue",
	Ray = "RayValue",
	BrickColor = "BrickColorValue"
}

function Class:update()
	if not self.__server then
		warn(self.classType..":update() can only be called from the server.")
		return
	end
	local instance = self.instance
	if not instance then
		return
	end
	for i,v in next,self:getProperties() do
		if Class:isAClass(v) and v.instance then
			v = v.instance
		end
		if i:sub(1,2) ~= "__" and valueTypes[typeof(v)] then
			if not instance:FindFirstChild(i) then
				local inst = Instance.new(valueTypes[typeof(v)])
				inst.Name = i
				inst.Value = v
				inst.Parent = instance
			end
		end
	end
	for i,v in next,instance:GetChildren() do
		if not v.ClassName:find("Remote") then
			local val = self[v.Name]
			if val == nil then
				v:Destroy()
			else
				if Class:isAClass(val) and val.instance then
					val = val.instance
				end
				v.Value = val
			end
		end
	end
	instance.Name = tostring(self)
end

function Class:bindGenerate(instance)
	self.__instanceLocation = instance
	if self.__client then
		for i,v in next,instance:GetChildren() do
			self:generate(v)
		end
		self:addConn(instance.ChildAdded:connect(function(v)
			self:generate(v)
		end))
	end
end

function Class:waitForGen()
	repeat wait() until self.instance
end

function Class:hookCreate(condition, func)
	local disconnect
	local conns = {}
	disconnect = self:onEvent("create", self, function(newClass)
		conns[#conns + 1] = newClass:waitForGen()
		if condition(newClass) and disconnect then
			func(newClass)
			disconnect()
			disconnect = nil
			for i,v in next, conns do
				v:disconnect()
			end
		end
	end)
end

function Class:find(name)
	name = tostring(name)
	if self.children[name] then
		return self.children[name][1]
	end
end

function Class:waitForChild(name)
	if not self:find(name) then
		repeat wait() until self:find(name)
	end
	return self:find(name)
end

function Class:serialize()
	local t = {}
	for i,v in next, self:getProperties() do
		if Class[i] == nil and i ~= "parent" then
			t[i] = v
		end
	end
	return t
end

function Class:deserialize(data)
	if not data then
		return
	end
	for i,v in next, data do
		self[i] = v
	end
	self:update()
end

setmetatable(Class, {
	__index = function(Class, index)
		if rawget(Class, index) then
			return rawget(Class, index)
		else
			return Class.find(Class, index)
		end
	end
})
setmetatable(Class.__wrapper, Class.wrapMeta)
Class = Class.__wrapper

return Class