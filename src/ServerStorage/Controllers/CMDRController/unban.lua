-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "unban";
	Description = "Unbans a player.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "string";
			Name = "player";
			Description = "The player to unban.";
		},
		{
			Type = "string";
			Name = "reason";
			Description = "The reason the player is unbanned.";
		},
	};
}