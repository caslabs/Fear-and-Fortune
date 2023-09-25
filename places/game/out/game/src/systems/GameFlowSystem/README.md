Those are typically handled by a separate system, often called a game state manager, scene manager, or something similar. This system keeps track of the overall state of the game and transitions between different states such as "game win" "game over", "teleport to player


The GameFlow system acts like a "director" that orchestrates the sequence of events in the game. It communicates with the different subsystems (like the HUD, Narrative system, etc.) to control the state and progression of the game. Here is a rough sequence for your scenario:
