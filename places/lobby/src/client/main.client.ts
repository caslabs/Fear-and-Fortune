import { Flamework } from "@flamework/core";

//Systems
Flamework.addPaths("places/lobby/src/systems/GameFlowSystem/controller/");
Flamework.addPaths("places/lobby/src/systems/AudioSystem/MusicSystem/controller/");
Flamework.addPaths("places/lobby/src/systems/AudioSystem/SoundSystem/controller/");
Flamework.addPaths("places/lobby/src/systems/MatchMakingSystem/controller/");
Flamework.addPaths("places/lobby/src/systems/ProfessionSystem/controller");
Flamework.addPaths("places/lobby/src/systems/InventorySystem/controller/");
Flamework.addPaths("places/lobby/src/systems/MetaSystem/TwitterSystem/controller/");
Flamework.addPaths("places/lobby/src/systems/MetaSystem/LeaderboardSystem/controller/");
//Game Mechanics
Flamework.addPaths("places/lobby/src/mechanics/PlayerMechanics/CharacterMechanic/controller/");
Flamework.addPaths("places/lobby/src/mechanics/PlayerMechanics/UIMechanic/controller/");
Flamework.addPaths("places/lobby/src/mechanics/PlayerMechanics/CameraMechanic/controller/");
Flamework.ignite();
