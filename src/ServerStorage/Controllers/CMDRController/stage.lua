-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "stage";
	Description = "Teleports a player to a stage.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to teleport.";
		},
		{
			Type = "string";
			Name = "stage";
			Description = "The stage to teleport the players to.";
		},
	};
}