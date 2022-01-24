-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Teams = game:GetService("Teams")
local Util = require(script.Parent.Parent.Shared.Util)

local teamType = {
	Transform = function (text)
		local findTeam = Util.MakeFuzzyFinder(Teams:GetTeams())

		return findTeam(text)
	end;

	Validate = function (teams)
		return #teams > 0, "No team with that name could be found."
	end;

	Autocomplete = function (teams)
		return Util.GetNames(teams)
	end;

	Parse = function (teams)
		return teams[1];
	end;
}

local teamPlayersType = {
	Listable = true;
	Transform = teamType.Transform;
	Validate = teamType.Validate;
	Autocomplete = teamType.Autocomplete;

	Parse = function (teams)
		return teams[1]:GetPlayers()
	end;
}

return function (cmdr)
	cmdr:RegisterType("team", teamType)
	cmdr:RegisterType("teams", Util.MakeListableType(teamType))
	cmdr:RegisterType("teamPlayers", teamPlayersType)
end