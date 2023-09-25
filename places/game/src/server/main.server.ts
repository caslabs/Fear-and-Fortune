import { Flamework } from "@flamework/core";

//Systems
Flamework.addPaths("places/game/src/systems/TaskSystem/services");
Flamework.addPaths("places/game/src/systems/GameFlowSystem/services/");
Flamework.addPaths("places/game/src/systems/AudioSystem/MusicSystem/services/");
Flamework.addPaths("places/game/src/systems/AnimationSystem/services/");
Flamework.addPaths("places/game/src/systems/EnvironmentSystem/TimeSystem/DayNightSystem/services/");
Flamework.addPaths("places/game/src/systems/EnvironmentSystem/TimeSystem/AtmosphereSystem/services/");
Flamework.addPaths("places/game/src/systems/ProgressionSystem/ElevationSystem/services/");
Flamework.addPaths("places/game/src/systems/LevelSystem/services/");
Flamework.addPaths("places/game/src/systems/InventorySystem/services/");
Flamework.addPaths("places/game/src/systems/AISystem/services");
Flamework.addPaths("places/game/src/systems/ProfessionSystem/services");
Flamework.addPaths("places/game/src/systems/MatchMakingSystem/services");
Flamework.addPaths("places/game/src/systems/CraftingSystem/services/");
Flamework.addPaths("places/game/src/systems/AISystem/services/");
Flamework.addPaths("places/game/src/systems/BadgeSystem/services/");

// Player Mechanics
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/RespawnMechanic/services/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/DeathMechanic/services/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/StealthMechanic/services/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/");
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/PartyMechanic/services/");
// Prototype PLayer Mechanics
Flamework.addPaths("places/game/src/mechanics/PlayerMechanics/_Prototype/SanityMechanic/services/");

//Game Entities
Flamework.addPaths("places/game/src/entities/Structures/Gate/services/");
Flamework.addPaths("places/game/src/entities/Structures/Ladder/services/");
Flamework.addPaths("places/game/src/entities/Structures/ExitPortal/services/");
Flamework.addPaths("places/game/src/entities/Tools/Axe/services/");
Flamework.addPaths("places/game/src/entities/Tools/Pickaxe/services/");
Flamework.addPaths("places/game/src/entities/Tools/Canteen/services/");

//Flamework.addPaths("places/game/src/entities/Structures/ExitPortal/services/");
Flamework.addPaths("places/game/src/entities/Resources/IronWood/services/");
Flamework.addPaths("places/game/src/entities/Resources/EldritchStone/services/");
Flamework.addPaths("places/game/src/entities/Resources/HumanMeat/services/");
Flamework.addPaths("places/game/src/entities/Resources/Chest/services/");
Flamework.addPaths("places/game/src/entities/Resources/Crate/services/");

Flamework.ignite();
