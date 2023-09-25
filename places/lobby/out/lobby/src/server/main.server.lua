-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = TS.import(script, TS.getModule(script, "@flamework", "core").out).Flamework
-- Player Mechanics
Flamework._addPaths({ "ServerScriptService", "PlayerMechanics", "ProfileService" })
Flamework._addPaths({ "ServerScriptService", "PlayerMechanics", "CurrencyMechanic" })
Flamework._addPaths({ "ServerScriptService", "PlayerMechanics", "ProfessionMechanic" })
Flamework._addPaths({ "ServerScriptService", "PlayerMechanics", "TradeMechanic" })
-- Systems
Flamework._addPaths({ "ServerScriptService", "SystemServices", "GameFlowSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "MusicSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "MatchMakingSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "ProfessionsSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "InventorySystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "TwitterSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "LeaderboardSystem" })
Flamework.ignite()
