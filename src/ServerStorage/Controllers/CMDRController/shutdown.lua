-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return {
	Name = "shutdown";
	Aliases = {"sd"};
	Description = "Shuts down the server and spawns a bunch of dice.";
	Group = "DefaultAdmin";
	Args = {};
}