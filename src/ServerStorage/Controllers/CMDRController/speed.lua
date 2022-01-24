-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "speed";
	Description = "Sets the speed of a player or players' characters.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to effect.";
		},
		{
			Type = "number";
			Name = "speed";
			Description = "The new speed of the character (default: 25).";
		},
	};
}