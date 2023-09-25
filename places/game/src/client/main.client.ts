import { Flamework } from "@flamework/core";

//Systems
Flamework.addPaths("places/game/src/systems/TaskSystem/controller/");
Flamework.addPaths("places/game/src/systems/GameFlowSystem/controller/");
Flamework.addPaths("places/game/src/systems/AudioSystem/MusicSystem/controller/");
Flamework.addPaths("places/game/src/systems/AudioSystem/SoundSystem/controller/");
Flamework.addPaths("places/game/src/systems/ProgressionSystem/ElevationSystem/controller");
Flamework.addPaths("places/game/src/systems/NarrartiveSystem/DialogueSystem/components");
Flamework.addPaths("places/game/src/systems/NarrartiveSystem/CharacterSystem/NPCSystem/components");
Flamework.addPaths("places/game/src/systems/AISystem/components/");
Flamework.addPaths("places/game/src/systems/LevelSystem/components");
Flamework.addPaths("places/game/src/systems/EnvironmentSystem/TimeSystem/WeatherSystem/controller");
Flamework.addPaths("places/game/src/systems/LevelSystem/controller");
Flamework.addPaths("places/game/src/systems/ProfessionSystem/controller");
Flamework.addPaths("places/game/src/systems/MatchMakingSystem/controller");
Flamework.addPaths("places/game/src/systems/EnvironmentSystem/TimeSystem/DayNightSystem/controller");
Flamework.addPaths("places/game/src/systems/CraftingSystem/controller");
Flamework.addPaths("places/game/src/systems/AnimationSystem/controller/");

//Game Mechanics
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/LifeMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/ResourceMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/RespawnMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/UIMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/CameraMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/DeathMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/StealthMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/SettingMechanic/controller/");

//Prototype Mechanics TODO: Playtest
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/_Prototype/SanityMechanic/controller/");

//Game Entities
Flamework.addPaths("places/game/src/entities/Structures/ExitPortal/controller/");
Flamework.addPaths("places/game/src/entities/Tools/Axe/controller/");
Flamework.addPaths("places/game/src/entities/Tools/Pickaxe/controller/");
Flamework.addPaths("places/game/src/entities/Tools/Canteen/controller/");

Flamework.ignite();
