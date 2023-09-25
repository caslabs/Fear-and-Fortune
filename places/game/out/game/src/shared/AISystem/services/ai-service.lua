-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local AISystemService
do
	AISystemService = setmetatable({}, {
		__tostring = function()
			return "AISystemService"
		end,
	})
	AISystemService.__index = AISystemService
	function AISystemService.new(...)
		local self = setmetatable({}, AISystemService)
		return self:constructor(...) or self
	end
	function AISystemService:constructor()
	end
	function AISystemService:onStart()
		print("AISystem Service Started")
		local RequestSpawnAI = Remotes.Server:Get("RequestSpawnAI")
		local SpawnAI = Remotes.Server:Get("SpawnAI")
		-- Listen for a request to spawn an AI
		RequestSpawnAI:Connect(function(player, aiType, spawnLocation)
			self:spawnAI(aiType, spawnLocation, player)
			print("spawned a AI")
		end)
	end
	function AISystemService:spawnAI(aiType, spawnLocation, player)
		local newAI = Instance.new("Part")
		newAI.Name = aiType
		newAI.Position = spawnLocation
		newAI.Parent = Workspace
		newAI.Touched:Connect(function(part)
			local _result = part.Parent
			if _result ~= nil then
				_result = _result:FindFirstChild("Humanoid")
			end
			if _result then
				local humanoid = part.Parent:FindFirstChild("Humanoid")
				humanoid:TakeDamage(humanoid.MaxHealth)
				player:SetAttribute("LastDamagedByAI", true)
			end
		end)
		return newAI.Name
	end
end
-- (Flamework) AISystemService metadata
Reflect.defineMetadata(AISystemService, "identifier", "game/src/shared/AISystem/services/ai-service@AISystemService")
Reflect.defineMetadata(AISystemService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(AISystemService, "$:flamework@Service", Service, { {} })
return {
	default = AISystemService,
}
