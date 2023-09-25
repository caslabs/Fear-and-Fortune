import { Flamework } from "@flamework/core";

//Player Mechanics
Flamework.addPaths("places/lobby/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/");
Flamework.addPaths("places/lobby/src/mechanics/PlayerMechanics/CurrencyMechanic/services/");
Flamework.addPaths("places/lobby/src/mechanics/PlayerMechanics/ProfessionMechanic/services/");
Flamework.addPaths("places/lobby/src/mechanics/PlayerMechanics/TradeMechanic/services/");

//Systems
Flamework.addPaths("places/lobby/src/systems/GameFlowSystem/services/");
Flamework.addPaths("places/lobby/src/systems/AudioSystem/MusicSystem/services/");
Flamework.addPaths("places/lobby/src/systems/MatchMakingSystem/services/");
Flamework.addPaths("places/lobby/src/systems/ProfessionSystem/services");
Flamework.addPaths("places/lobby/src/systems/InventorySystem/services/");
Flamework.addPaths("places/lobby/src/systems/MetaSystem/TwitterSystem/services/");
Flamework.addPaths("places/lobby/src/systems/MetaSystem/LeaderboardSystem/services/");
Flamework.ignite();
