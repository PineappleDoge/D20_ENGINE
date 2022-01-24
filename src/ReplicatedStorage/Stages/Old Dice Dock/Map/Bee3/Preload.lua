return function()
	if game.Players.LocalPlayer.Data.GlobalTags:FindFirstChild("Beesmas"..script.Parent.Name) then
		script.Parent:Destroy()
		return
	end
	if game.Players.LocalPlayer.Admin.Value or not workspace:FindFirstChild("PreBeesmas") then
		script.Parent.Head.Interact.Name = "InteractScript"
	else
		script.Parent:Destroy()
	end
end