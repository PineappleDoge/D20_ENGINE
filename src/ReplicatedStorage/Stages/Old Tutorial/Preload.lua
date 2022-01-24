return function()
	if game.Lighting:FindFirstChildOfClass("Sky") then
		game.Lighting:FindFirstChildOfClass("Sky"):Destroy()
	end
	local s = game.Lighting.Skyboxes.PeacefulMorning:Clone()
	s.Parent = game.Lighting
	shared.Framework.Sounds:playMusic("Tutorial")
end