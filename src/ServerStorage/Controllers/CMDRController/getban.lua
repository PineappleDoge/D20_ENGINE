-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "getban";
	Description = "Gets the ban of a player.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "string";
			Name = "player";
			Description = "The player to check.";
		},
	};
}