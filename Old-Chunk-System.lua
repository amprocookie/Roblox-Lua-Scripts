--[[
V0.0.1 -- INITIAL UPDATE
V0.0.2 -- DETAIL UPDATE
V0.0.3 -- OPTIMIZATION UPDATE <--(current update)
]]
local RunService = game:GetService('RunService')
local MaxDistanceDetection = 1000

--Variables
local ChunkPlatformData = script:WaitForChild('ChunkPlatformData')
local ChunkCollisionData = script:WaitForChild('ChunkCollisionData')

--Functions
function GetDist(x1,y1,z1,x2,y2,z2)
	local x = math.abs(x1 - x2)
	local y = math.abs(y1 - y2)
	local z = math.abs(z1 - z2)
	local distance = math.sqrt(x*x + y*y + z*z)
	return distance
end

function NewChunkAsset(Position)
	local NewCA = Instance.new('Vector3Value')
	NewCA.Name = 'ChunkPos'
	NewCA.Value = Position
	return NewCA
end

function CleanChunkPlatformData()
	local StoredVect = {}
	for i, v in ipairs(ChunkPlatformData:GetChildren()) do
		if table.find(StoredVect, v.Position) then
			v:Destroy()
		else
			StoredVect[#StoredVect+1] = v.Position
		end
	end
end

function GetWithinSingularChunk(ChunkAsset)
	local Bool = nil
	if game.Players.LocalPlayer:DistanceFromCharacter(ChunkAsset.Value) <= MaxDistanceDetection then
		Bool = ChunkAsset.Value
	end
	return Bool
end

function GetChunksData()
	local CurrentData = ChunkCollisionData:GetChildren()
	local CurrentInChunk = {}
	for i, v in ipairs(ChunkCollisionData:GetChildren()) do
		local test = GetWithinSingularChunk(v)
		if test then
			CurrentInChunk[#CurrentInChunk+1] = GetWithinSingularChunk(v)
		end
	end
	return CurrentInChunk
end

function UpdateChunkAppearance(ChunkTableData)
	for i, v in ipairs(ChunkTableData) do
		local EX = script.Example:Clone()
		EX.Parent = ChunkPlatformData
		EX.Position = v
	end
end

function DeleteChunkCollisionData() --pls dont use dis or error lolz
	ChunkCollisionData:ClearAllChildren()
end

UpdateChunkAppearance(GetChunksData())

while wait(1) do
	
	UpdateChunkAppearance(GetChunksData(), true)
	
end
