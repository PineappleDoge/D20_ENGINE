-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "echo";
	Aliases = {};
	Description = "Echoes your text back to you.";
	Group = "DefaultUtil";
	Args = {
		{
			Type = "string";
			Name = "Text";
			Description = "The text."
		},
	};

	Run = function(_, text)
		return text
	end
}