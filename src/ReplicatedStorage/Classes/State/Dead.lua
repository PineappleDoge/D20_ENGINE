local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.rootOffset = game.ReplicatedStorage.Assets.Character.Head.CFrame:inverse() * game.ReplicatedStorage.Assets.Character.Root.CFrame

function State:start(character)
	Framework.Sounds:play("Die")
	local Util = Framework.Util
	character.charAnim = "Die"
	character.physics.RotVelocity = Vector3.new()
	character.physics.CFrame = CFrame.new(character.physics.Position) * Util.CFrames:getRot(character.character.Head.CFrame)
	character.physics.CanCollide = false
	character.dieCollision.Anchored = false
	character.dieCollision.CanCollide = true
	character.dieCollision.CFrame = character.physics.CFrame
	character.dieCollision.Velocity = character.physics.Velocity
	local weld = Instance.new("Weld")
	weld.Parent = character.dieCollision
	weld.Part0 = character.physics
	weld.Part1 = character.dieCollision
	character.specialMoves = math.huge
	wait(.5)
	local Controller = Framework.HUDController
	Controller:fade(.375,0,function()
		Framework.ClientController:loadCharacter()
	end)
end

function State:update(dt, character)
	character.character.Root.CFrame = character.physics.CFrame * self.rootOffset
		+ Vector3.new(math.random()/1000 - 1/2000,math.random()/1000 - 1/2000,math.random()/1000 - 1/2000)
	character.texture = "texture20"
end

function State:stop(character)
	character.charAnim = ""
	character.physics.CanCollide = true
	character.dieCollision.Weld:Destroy()
	character.dieCollision.Anchored = true
	character.dieCollision.CanCollide = false
	character.trailEnabled = false
end

return State