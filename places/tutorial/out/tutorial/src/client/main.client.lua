-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = TS.import(script, TS.getModule(script, "@flamework", "core").out).Flamework
-- Systems
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "TaskSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "GameFlowSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "MusicSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "SoundSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "ProgressionSystem", "ElevationSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsComponents", "DialogueComponent" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsComponents", "NPCComponent" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsComponents", "EventComponent" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "WeatherSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "LevelSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "ProfessionSystem" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "SystemsController", "MatchMakingSystem" })
-- tutorial Mechanics
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "CharacterMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "LifeMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "SprintMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "RespawnMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "UIMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "CameraMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "DeathMechanic" })
-- Prototype Mechanics TODO: Playtest
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "SelfDamageMechanic" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "MechanicsController", "PlayerMechanics", "SanityMechanic" })
Flamework.ignite()
