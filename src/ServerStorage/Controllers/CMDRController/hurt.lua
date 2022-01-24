-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "hurt";
	Aliases = {"damage"};
	Description = "Hurts a player or set of players.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "victims";
			Description = "The players to hurt.";
		},
		{
			Type = "number";
			Name = "damage";
			Description = "The amount of damage to deal.";
		}
	};
}