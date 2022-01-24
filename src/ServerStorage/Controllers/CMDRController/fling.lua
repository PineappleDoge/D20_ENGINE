-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "fling";
	Aliases = {"fl"};
	Description = "Flings a player or set of players with a certain velocity.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "from";
			Description = "The players to fling";
		},
		{
			Type = "number";
			Name = "power";
			Description = "The velocity to fling them"
		}
	};
}