return function()
	if game.Lighting:FindFirstChildOfClass("Sky") then
		game.Lighting:FindFirstChildOfClass("Sky"):Destroy()
	end
	local s = game.Lighting.Skyboxes.Default:Clone()
	s.Parent = game.Lighting
end