-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "gnome";
	Description = "Gnome your chums with the all new 'You've been Gnomed' video file!";
	Group = "DefaultAdmin";
	Args = {
		{
			Type = "players";
			Name = "target";
			Description = "The players to g'nome."
		}
	};
}