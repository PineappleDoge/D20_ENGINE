-- Aurora is a library that can manage status effects (known as "Auras") in your Roblox game.
-- @documentation https://github.com/evaera/Aurora/blob/master/README.md
-- @source https://github.com/evaera/Aurora/tree/master/lib
-- @rostrap Aurora
-- @author evaera

return {
	Display = {
		Title = "Movement Speed";
		Description = function(self)
			return ("Reduces movement speed by %d%% for %d seconds.")
			:format(math.floor(self.Effects.TestEffectWalkSpeedMax(self) / 16 * 100), self.Duration)
		end;
	};

	Status = {
		Duration = 10;
		Replicated = true;
		ShouldAuraRefresh = true;
	};

	Params = {
		Speed = 10;
		Test = 59;
	};

	Effects = {
		TestEffect = true
	}
}