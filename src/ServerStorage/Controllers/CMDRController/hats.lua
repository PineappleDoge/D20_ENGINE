-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "hats";
	Aliases = {};
	Description = "Gives, takes, or gets a player or players' hats.";
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
			Type = "string";
			Name = "hat";
			Description = "The name of the hat.";
		}
	};
}