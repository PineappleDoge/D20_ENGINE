-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = shared.Framework

return {
	Name = "thru";
	Aliases = {"t", "through"};
	Description = "Teleports you through whatever your mouse is hovering over, placing you equidistantly from the wall.";
	Group = "DefaultDebug";
	Args = {
		{
			Type = "number";
			Name = "Extra distance";
			Description = "Go through the wall an additional X studs.";
			Default = 0;
		}
	};

	Run = function(context, extra)
		-- We implement this here because player position is owned by the client.
		-- No reason to bother the server for this!

		local mouse = context.Executor:GetMouse()
		local character = Framework.Character

		if not character then
			return "You don't have a character."
		end

		local pos = character.physics.Position
		local diff = (mouse.Hit.p - pos)

		character.physics.CFrame = CFrame.new((diff * 2) + (diff.unit * extra) + pos)

		return "Blinked!"
	end
}