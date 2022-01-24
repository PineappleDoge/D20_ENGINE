-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "time";
	Description = "Simulates a time change by changing the speed, jump power and gravity of a player or players' characters.";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to effect.";
		},
		{
			Type = "number";
			Name = "time";
			Description = "The new time modifier of the character (default: 1).";
		},
	};
}