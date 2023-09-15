
local BASE_HEIGHT = 10
local CHUNK_SCALE = 3
local RENDER_DISTANCE = 50
local X_SCALE = 90
local Z_SCALE = 90
local GENERATION_SEED = math.random() 	
local Grass = Enum.Material.Grass 
local Mountain = Enum.Material.Rock
local Ground = Enum.Material.Ground
local Water = Enum.Material.Water
local Sand = Enum.Material.Sand
local Players = game:GetService("Players")
local chunks = {}


local function chunkExists(chunkX, chunkZ)
	if not chunks[chunkX] then
		chunks[chunkX] = {}
	end
	return chunks[chunkX][chunkZ]
end

local function mountLayer(x, heightY, z, material)
	local beginY = -BASE_HEIGHT
	local endY = heightY
	local position_X = x * 4 + 2
	local position_Y = (beginY + endY) * 4 / 2
	local position_Z = z * 4 + 2
	local cframe = CFrame.new(position_X, position_Y, position_Z)
	local size = Vector3.new(4, (endY - beginY) * 4, 4)
	workspace.Terrain:FillBlock(cframe, size, material)
end

function makeChunk(chunkX, chunkZ)
	local rootPosition = Vector3.new(chunkX * CHUNK_SCALE, 0, chunkZ * CHUNK_SCALE)
	chunks[chunkX][chunkZ] = true 
	for x = 0, CHUNK_SCALE - 1 do
		for z = 0, CHUNK_SCALE - 1 do
			local cx = (chunkX * CHUNK_SCALE) + x
			local cz = (chunkZ * CHUNK_SCALE) + z
			local noise = math.noise(GENERATION_SEED, cx / X_SCALE, cz / Z_SCALE)
			local cy = noise * BASE_HEIGHT
			mountLayer(cx, cy, cz, Grass) 
		end
	end
end

function checkSurroundings(location)
	local chunkX, chunkZ = math.floor(location.X / 4 / CHUNK_SCALE), math.floor(location.Z / 4 / CHUNK_SCALE)
	local range = math.max(1, RENDER_DISTANCE / CHUNK_SCALE)
	for x = -range, range do
		for z = -range, range do
			local cx = chunkX + x
			local cz = chunkZ + z
			if not chunkExists(cx, cz) then 
				makeChunk(cx, cz) 
			end
		end
	end
end

while true do
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character then
			local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				checkSurroundings(humanoidRootPart.Position) 
			end
		end
	end
	wait(0.001)
end
