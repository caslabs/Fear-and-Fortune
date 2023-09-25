# Sound System
The Sound System in a game is used in both paradigms, depending on the use case. For example,

Client-Driven Sound State Management

UI Sounds: These are the sounds that are triggered when a player interacts with the game's user interface. They include things like button clicks, menu opens/closes, etc. These sounds are typically managed on the client side, as they are tied directly to the player's actions and don't need to be synced across all clients.

Local Player Sounds: These are the sounds that are tied to the player's actions or environment, such as footsteps, weapon sounds, or ambient sounds. They are managed on the client side because they are local to the player and don't need to be synced across all clients.

Server-Driven Sound State Management

Global Sound Effects: These are the sounds that all players in the game should hear, such as the sound of an explosion, a global announcement, or the game's background music. These sounds are managed by the server because they need to be consistent for all players.

Spatial 3D Sounds: These are the sounds that are tied to specific locations or objects in the game world, such as the sound of a door opening or an enemy character's voice. These sounds are managed by the server because they need to be consistent for all players, and their volume or other properties might change based on the player's position relative to the source of the sound.
