-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "jump";
	Description = "Sets the jump power of a player or players' characters.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to effect.";
		},
		{
			Type = "number";
			Name = "jump";
			Description = "The new jump power of the character (default: 35).";
		},
	};
}