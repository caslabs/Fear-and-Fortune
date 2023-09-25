import { Flamework } from "@flamework/core";

//Systems
Flamework.addPaths("places/tutorial/src/systems/TaskSystem/services");
Flamework.addPaths("places/tutorial/src/systems/GameFlowSystem/services/");
Flamework.addPaths("places/tutorial/src/systems/AudioSystem/MusicSystem/services/");
Flamework.addPaths("places/tutorial/src/systems/EnvironmentSystem/TimeSystem/DayNightSystem/services/");
Flamework.addPaths("places/tutorial/src/systems/EnvironmentSystem/TimeSystem/AtmosphereSystem/services/");
Flamework.addPaths("places/tutorial/src/systems/ProgressionSystem/ElevationSystem/services/");
Flamework.addPaths("places/tutorial/src/systems/LevelSystem/services/");
Flamework.addPaths("places/tutorial/src/systems/InventorySystem/services/");
Flamework.addPaths("places/tutorial/src/systems/AISystem/services");
Flamework.addPaths("places/tutorial/src/systems/ProfessionSystem/services");
Flamework.addPaths("places/tutorial/src/systems/MatchMakingSystem/services");

// Player Mechanics
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/RespawnMechanic/services/");
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/DeathMechanic/services/");

// Prototype PLayer Mechanics
Flamework.addPaths("places/tutorial/src/mechanics/PlayerMechanics/_Prototype/SanityMechanic/services/");

//tutorial Entities
Flamework.addPaths("places/tutorial/src/entities/Structures/Gate/services/");
Flamework.addPaths("places/tutorial/src/entities/Structures/Ladder/services/");
Flamework.addPaths("places/tutorial/src/entities/Resources/IronWood/services/");

Flamework.ignite();
