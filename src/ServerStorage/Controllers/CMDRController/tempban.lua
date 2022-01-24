-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "tempban";
	Aliases = {"tban"};
	Description = "Bans a player.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "string";
			Name = "player";
			Description = "The player to ban.";
		},
		{
			Type = "string";
			Name = "duration";
			Description = "The duration of the ban. Type: 1y12M30d24h60m60s";
		},
		{
			Type = "string";
			Name = "reason";
			Description = "The reason the player is banned.";
		},
	};
}