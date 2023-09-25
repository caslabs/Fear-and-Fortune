import { Flamework } from "@flamework/core";

//Systems
Flamework.addPaths("places/tutorial/src/systems/TaskSystem/controller/");
Flamework.addPaths("places/tutorial/src/systems/GameFlowSystem/controller/");
Flamework.addPaths("places/tutorial/src/systems/AudioSystem/MusicSystem/controller/");
Flamework.addPaths("places/tutorial/src/systems/AudioSystem/SoundSystem/controller/");
Flamework.addPaths("places/tutorial/src/systems/ProgressionSystem/ElevationSystem/controller");
Flamework.addPaths("places/tutorial/src/systems/NarrartiveSystem/DialogueSystem/components");
Flamework.addPaths("places/tutorial/src/systems/NarrartiveSystem/CharacterSystem/NPCSystem/components");
Flamework.addPaths("places/tutorial/src/systems/LevelSystem/components");
Flamework.addPaths("places/tutorial/src/systems/EnvironmentSystem/TimeSystem/WeatherSystem/controller");
Flamework.addPaths("places/tutorial/src/systems/LevelSystem/controller");
Flamework.addPaths("places/tutorial/src/systems/ProfessionSystem/controller");
Flamework.addPaths("places/tutorial/src/systems/MatchMakingSystem/controller");

//tutorial Mechanics
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/CharacterMechanic/controller/");
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/LifeMechanic/controller/");
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/SprintMechanic/controller/");
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/RespawnMechanic/controller/");
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/UIMechanic/controller/");
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/CameraMechanic/controller/");
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/DeathMechanic/controller/");

//Prototype Mechanics TODO: Playtest
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/");
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/_Prototype/SanityMechanic/controller/");

Flamework.ignite();
