-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = TS.import(script, TS.getModule(script, "@flamework", "core").out).Flamework
-- Systems
Flamework._addPaths({ "ServerScriptService", "SystemServices", "TaskSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "GameFlowSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "MusicSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "DayNightSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "AtmosphereSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "ProgressionSystem", "ElevationSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "LevelSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "InventorySystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "AISystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "ProfessionSystem" })
Flamework._addPaths({ "ServerScriptService", "SystemServices", "MatchMakingSystem" })
-- Player Mechanics
Flamework._addPaths({ "ServerScriptService", "MechanicServices", "RespawnMechanic" })
Flamework._addPaths({ "ServerScriptService", "MechanicServices", "DeathMechanic" })
-- Prototype PLayer Mechanics
Flamework._addPaths({ "ServerScriptService", "MechanicServices", "SanityMechanic" })
-- tutorial Entities
Flamework._addPaths({ "ServerScriptService", "Entities", "GateStructure" })
Flamework._addPaths({ "ServerScriptService", "Entities", "LadderStructure" })
Flamework._addPaths({ "ServerScriptService", "Entities", "IronWoodResource" })
Flamework.ignite()
