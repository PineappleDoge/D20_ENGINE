-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

return function (_, fromPlayers, toPlayer)
	if toPlayer.Character and toPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local position = toPlayer.Character.HumanoidRootPart.CFrame
		
		for _, player in ipairs(fromPlayers) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = position
			end
		end
		
		return ("Teleported %d players."):format(#fromPlayers)
	end
	
	return "Target player has no character."
end
