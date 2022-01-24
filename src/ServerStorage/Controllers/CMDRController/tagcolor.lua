-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "tagcolor";
	Description = "Sets the tag color of a player or players.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to effect.";
		},
		{
			Type = "number";
			Name = "red";
			Description = "The red value of the color (0-255).";
		},
		{
			Type = "number";
			Name = "blue";
			Description = "The blue value of the color (0-255).";
		},
		{
			Type = "number";
			Name = "green";
			Description = "The green value of the color (0-255).";
		},
	};
}