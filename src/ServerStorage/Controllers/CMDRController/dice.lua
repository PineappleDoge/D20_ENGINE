-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "dice";
	Aliases = {};
	Description = "Gives, takes, or gets a player or players' dice.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "string";
			Name = "function";
			Description = "The function. [give/take/get]";
		};
		{
			Type = "players";
			Name = "players";
			Description = "The players to effect.";
		};
		{
			Type = "number";
			Name = "value";
			Description = "The value to give/take. [give/take only]";
			Optional = true;
		}
	};
}