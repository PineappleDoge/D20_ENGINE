-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "teleport";
	Aliases = {"tp"};
	Description = "Teleports a player or set of players to one target.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "from";
			Description = "The players to teleport";
		},
		{
			Type = "player";
			Name = "to";
			Description = "The player to teleport to"
		}
	};
}