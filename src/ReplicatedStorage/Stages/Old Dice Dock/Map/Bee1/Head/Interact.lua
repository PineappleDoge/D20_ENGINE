return {
	CanInteract = function()
		return shared.State == "None" and shared.CanMove <= 0 and shared.GamePaused <= 0 and shared.Floor
	end,
	Interact = function()
		shared.CanMove = shared.CanMove + 1
		for i,v in next,script.Parent.Parent:GetChildren() do
			if v:IsA("BasePart") then
				v.Material = "Neon"
			end
		end
		shared.Fade(.5,.5,function()
			workspace.Server.SetGlobalTag:FireServer(game.Players.LocalPlayer.Data.GlobalTags,"Folder","Beesmas"..script.Parent.Parent.Name,nil,"math.random(math.random(1,8036457))")
			workspace.CurrentCamera.CameraType = "Scriptable"
			workspace.CurrentCamera.CFrame = workspace.Stage.GameItems.BeesmasCamera.CFrame
		end,false,BrickColor.new("Gold").Color)
		wait(4)
		shared.Fade(.5,.5,function()
			workspace.CurrentCamera.CameraType = "Custom"
			shared.CanMove = shared.CanMove - 1
			script.Parent.Parent:Destroy()
		end,false,BrickColor.new("Gold").Color)
	end
}