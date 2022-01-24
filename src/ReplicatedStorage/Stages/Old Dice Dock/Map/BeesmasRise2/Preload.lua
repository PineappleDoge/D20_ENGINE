return function()
	local function Bees()
		local C = 0
		for i = 1,3 do
			if game.Players.LocalPlayer.Data.GlobalTags:FindFirstChild("BeesmasBee"..i) then
				C = C + 1
			end
		end
		return C
	end
	local TS = game:GetService("TweenService")
	if Bees() < 1 then
		for i,v in next,script.Parent:GetChildren() do
			if v:IsA("BasePart") then
				v.CFrame = v.CFrame - Vector3.new(0,10000,0)
			end
		end
		repeat wait() until Bees() >= 2
		for i,v in next,script.Parent:GetChildren() do
			if v:IsA("BasePart") then
				v.CFrame = v.CFrame + Vector3.new(0,10000 - 150,0)
				local t = TS:Create(v,TweenInfo.new(2.5),{
					CFrame = v.CFrame + Vector3.new(0,150,0)
				})
				t:Play()
			end
		end
	end
end