-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = TS.import(script, TS.getModule(script, "@flamework", "core").out).Flamework
-- Systems
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "GameFlowSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "MusicSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "SoundSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "MatchMakingSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "ProfessionsSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "InventorySystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "TwitterSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "LeaderboardSystem" })
-- Game Mechanics
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "CharacterMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "UIMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "CameraMechanic" })
Flamework.ignite()
