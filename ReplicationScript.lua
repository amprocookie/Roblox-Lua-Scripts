local API = {}
function using(module)
	if module:IsA('Instance') then
		API[module.Name] = require(module)
	else
		error('Instance forms of modules are only allowed for the using() function')
	end
end




--UsedModules
using(script.AudioSingle)






function RemoveJoints(Parent)
	for i, v in ipairs(Parent:GetDescendants()) do
		if v:IsA('Motor6D') or v:IsA('Weld') then
			v:Destroy()
		end
	end
end

function Weld(P0, P1, C0, C1)
	local WeldPart = Instance.new('Weld')
	WeldPart.Part0 = P0
	WeldPart.Part1 = P1
	WeldPart.C1 = WeldPart.C1 * C0
	return WeldPart
end

local MouseState = false

local WeaponActivated = false
script.Parent.BeginTransformation.OnServerEvent:Connect(function(p, Char)
	script.Awoken.Archivable = false
	script.Theme.Archivable = false
	script.Hurt.Archivable = false
	
	local function GetMouseCF()
		return MouseState
	end
	
	local function LazerEFC()
		local P0 = Char.HumanoidRootPart
		local P1 = GetMouseCF()

		local function AttachToPart(Part, Attachment, Position)
			Attachment.Parent = Part
			Attachment.WorldPosition = Position
		end

		local function LazerCreateBeam(Color)
			spawn(function()
				while true do
					if MouseState == false then
						break
					end
					local P01Dist = (GetMouseCF().Position - P0.Position).Magnitude

					local Increment = P01Dist/10

					local TempPartParent = Instance.new("Part")
					TempPartParent.Anchored = true
					TempPartParent.Position = Vector3.new(0,0,0)
					TempPartParent.Size = Vector3.new(0,0,0)
					TempPartParent.CanCollide = false
					TempPartParent.Transparency = 1
					TempPartParent.Parent = workspace
					TempPartParent.Name = script.Name..'.lec'

					local PrevAttachment = nil
					for i = 0,P01Dist,Increment do
						if MouseState == false then
							break
						end
						local Attachment = Instance.new('Attachment')
						if i == 0 then
							PrevAttachment = Attachment
							AttachToPart(TempPartParent, Attachment, P0.Position)
						elseif i == P01Dist then
							AttachToPart(TempPartParent, Attachment, GetMouseCF().Position)
							local NewBeam = Instance.new('Beam')
							NewBeam.Color = ColorSequence.new(Color)
							NewBeam.Texture = 'http://www.roblox.com/asset/?id=38727848'
							NewBeam.TextureSpeed = 0
							NewBeam.Parent = TempPartParent
							NewBeam.Attachment0 = PrevAttachment
							NewBeam.Attachment1 = Attachment
							NewBeam.Transparency = NumberSequence.new(0)
							NewBeam.Width0 = 3
							NewBeam.Width1 = 3
							NewBeam.LightEmission = 1
						elseif i ~= P01Dist and i > 0 then
							AttachToPart(TempPartParent, Attachment, (P0.CFrame:Lerp(GetMouseCF(), i/P01Dist)).Position + Vector3.new(math.random(-2, 2),math.random(-2, 2),math.random(-2, 2)))
							local NewBeam = Instance.new('Beam')
							NewBeam.Color = ColorSequence.new(Color)
							NewBeam.Texture = 'http://www.roblox.com/asset/?id=38727848'
							NewBeam.TextureSpeed = 0
							NewBeam.Parent = TempPartParent
							NewBeam.Attachment0 = PrevAttachment
							NewBeam.Attachment1 = Attachment
							NewBeam.Transparency = NumberSequence.new(0)
							NewBeam.Width0 = 3
							NewBeam.Width1 = 3
							NewBeam.LightEmission = 1
							PrevAttachment = Attachment
						end
					end
					wait()
					TempPartParent:Destroy()
					if MouseState == false then
						break
					end
				end
			end)
		end

		LazerCreateBeam(Color3.new(0,1,0))
		LazerCreateBeam(Color3.new(1,1,1))
	end
	
	local CancelLazer = false
	
	WeaponActivated = true
	script.Parent = Char
	local OrigLazer = script.Lazer
	OrigLazer.Parent = game.SoundService
	for i, v in ipairs(p:WaitForChild('Backpack'):GetChildren()) do
		if v:IsA('Tool') or v:IsA('HopperBin') then
			v.Parent = nil
		end
	end
	local Tool = Char:FindFirstChildOfClass('Tool')
	if Tool then
		Tool.Parent = nil
	end
	
	local Humanoid = Char:FindFirstChildOfClass('Humanoid')
	Humanoid.WalkSpeed = 0
	Humanoid.JumpPower = 0
	
	OrigLazer:Play()
	for i = 0, 4, 0.05 do
		Humanoid.HipHeight = i
		OrigLazer.PlaybackSpeed = i/2
		wait()
	end
	local LazerClone = OrigLazer:Clone()
	LazerClone.Parent = Char.PrimaryPart
	LazerClone.PlaybackSpeed = 0.5
	OrigLazer:Destroy()
	LazerClone:Play()
	
	LazerClone.Archivable = false
	
	Humanoid.WalkSpeed = 4
	Humanoid.JumpPower = 15
	
	local AwokenSFX = script.Awoken
	AwokenSFX.Parent = Char.PrimaryPart
	AwokenSFX:Play()
	
	local AllParts = {}
	for _, Part in ipairs(Char:GetDescendants()) do
		if Part:IsA('BasePart') then
			if Part.Name ~= 'HumanoidRootPart' and not Part.Parent:IsA('Tool') then
				AllParts[#AllParts+1] = Part
			end
		end
	end
	
	local CloneContainer = Instance.new('Configuration', Char)
	CloneContainer.Name = Char.Name..'s_Clones'
	
	for _, Part in pairs(AllParts) do
		local Clone = Part:Clone()
		RemoveJoints(Clone)
		Clone.Anchored = true
		Clone.CanCollide = false
		Clone.Parent = CloneContainer
		local GoTo = (Clone.CFrame * CFrame.new(math.random(-1,1)*3,math.random(-1,1)*3,math.random(-1,1)*3)) * CFrame.Angles(math.random(-3, 3),math.random(-3, 3),math.random(-3, 3))
		spawn(function()
			for i = 0,1,0.05 do
				Clone.CFrame = Clone.CFrame:Lerp(GoTo, i)
				Clone.Transparency = i+(i/2)
				wait()
			end
			Clone:Destroy()
		end)
	end
	
	for _Name, Part in pairs(AllParts) do
		Part.Transparency = 0.5
		Part.Color = Color3.new(0, 0.5, 1)
		if Part:FindFirstChildOfClass('Decal') then
			Part:FindFirstChildOfClass('Decal'):Destroy()
		end
		if Part.Parent:IsA('Accessory') then
			AllParts[_Name] = nil
			Part.Parent:Destroy()
		end
	end
	
	for _, Part in ipairs(Char:GetDescendants()) do
		if Part:IsA('Pants') then
			Part:Destroy()
		end
		if Part:IsA('Shirt') then
			Part:Destroy()
		end
		if Part:IsA('ShirtGraphic') then
			Part:Destroy()
		end
		if Part:IsA('BasePart') and Part.name ~= 'HumanoidRootPart' then
			Part.Transparency = 0.5
		end
	end

	local Runes = Instance.new('Part')
	Runes.Size = Vector3.new(1,1,1)
	local mesh = Instance.new('SpecialMesh', Runes)
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = 'rbxassetid://168892387'
	mesh.TextureId = 'rbxassetid://168892465'
	mesh.VertexColor = Vector3.new(0, 0.5, 1)
	mesh.Name = 'Mesh'
	
	script.UpdateClientStatus.OnServerEvent:Connect(function(p, MouseInput, Targ)
		if MouseState == false then
			LazerClone.PlaybackSpeed = 2
			LazerEFC()
		elseif MouseInput == false then
			LazerClone.PlaybackSpeed = 0.5
		end
		if MouseInput ~= false then
			if Targ then
				if Targ.Parent then
					local TargHumanoid = Targ.Parent:FindFirstChildOfClass('Humanoid')
					if TargHumanoid then
						if TargHumanoid ~= Char:FindFirstChildOfClass('Humanoid') then
							TargHumanoid.Health = TargHumanoid.Health - 20
							API.AudioSingle(script.Hurt)
						end
					end
				end
			end
		end
		MouseState = MouseInput
	end)
	
	--Rune Spinner
	spawn(function()
		while true do
			spawn(function()
				local RuClone = Runes:Clone()
				RuClone.Parent = CloneContainer
				RuClone.Size = Vector3.new(1,1,1)
				local TempWeld = Weld(Char.Torso, RuClone, Char.Torso.CFrame, CFrame.new(0, 0, 5))
				TempWeld.C1 = TempWeld.C1 * CFrame.new(0, math.random(-3,3), 0)
				TempWeld.Parent = RuClone
				for i = 0, 180, math.random(2, 5) do
					TempWeld.C1 = TempWeld.C0 * CFrame.Angles(0, i/20, 0)
					RuClone.Transparency = i/180
					local Solved = (i/math.random(20,90))+1
					RuClone.Mesh.Scale = Vector3.new(Solved,1,Solved)
					wait()
				end
				RuClone:Destroy()
			end)
			wait(0.5)
		end
	end)
	
	while wait() do
		spawn(function()
			local Part = AllParts[math.random(1, #AllParts)]
			Part.Transparency = 1
			local Clone = Part:Clone()
			RemoveJoints(Clone)
			Clone.Anchored = true
			Clone.CanCollide = false
			for i, v in pairs(Clone:GetDescendants()) do
				if v:IsA('Decal') then
					v:Destroy()
				end
			end
			Clone.Parent = CloneContainer
			local GoTo = (Clone.CFrame * CFrame.new(math.random(-1,1)*3,math.random(-1,1)*3,math.random(-1,1)*3)) * CFrame.Angles(math.random(-3, 3),math.random(-3, 3),math.random(-3, 3))
			for i = 0,1,0.05 do
				Clone.CFrame = Part.CFrame:Lerp(GoTo, i)
				Clone.Transparency = i+0.5
				wait()
			end
			Clone:Destroy()
			Part.Transparency = 0.5
		end)
	end
end)
