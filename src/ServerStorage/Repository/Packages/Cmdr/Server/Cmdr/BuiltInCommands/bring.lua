-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "bring";
	Description = "Brings a player or set of players to you.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to bring";
		},
	};
}