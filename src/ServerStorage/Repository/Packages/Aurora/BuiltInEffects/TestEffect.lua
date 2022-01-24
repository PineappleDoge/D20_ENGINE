-- Aurora is a library that can manage status effects (known as "Auras") in your Roblox game.
-- @documentation https://github.com/evaera/Aurora/blob/master/README.md
-- @source https://github.com/evaera/Aurora/tree/master/lib
-- @rostrap Aurora
-- @author evaera

return {
	AllowedInstanceTypes = {"NumberValue"};

	Reducer = function (_, values)
		return #values
	end;

	Apply = function (self, name)
		self.Instance.Name = name
		self.Instance.Value = tick()
	end;

	Destructor = function (self)
		self.Instance.Name = "Destructed"
	end;
}