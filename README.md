# Fear and Fortune

Hello, TikTok team! I'm excited to share with you my open-source game which serves not only as an example of my coding skills but also showcases an innovative game engine framework I've developed using TypeScript.

## Features:

1. **Custom Game Engine**: Built from scratch using TypeScript, providing high flexibility and optimized for my specific game needs.
2. **Dependency Injection Pattern**: Ensures that the game components are loosely coupled, making them more maintainable and testable.
3. **React Framework**: Utilized for UI engineering, providing a seamless and responsive user interface experience within the game.
4. **Data-Driven Design**: Enables easy tweaking of game variables, aiding in rapid prototyping and iteration.
5. **Domain-Driven Design**: The game is developed with a focus on bridging video game design vocabulary and systems into practical game development. This approach emphasizes modeling based on the real-world system, making the codebase more understandable and modular.

## Game Overview: A Lovecraftian Survival RPG on Roblox

Fear and Fortune plunges players into the icy, treacherous expanses of an 18th-century Arctic expedition, but this is no ordinary journey. Inspired by the haunting narratives of Lovecraftian horror, players find themselves amidst a realm where ancient mysteries intertwine with palpable dread.

In this massive multiplayer RPG built for Roblox, you and your friends will embark on a survival horror adventure like no other. As participants in this chilling expedition, you'll scavenge for valuable artifacts, weapons, and essential resources. However, the true essence of "Fear and Fortune" lies in its looter-extraction mechanics: treasures are laden with curses, and extracting them becomes a dangerous dance with the unknown.

Every corner of the Arctic hides shadows and secrets, making trust, strategy, and collaboration essential for survival. Will you brave the horrors to secure your fortune, or will the overwhelming fear lead to your doom? Join the expedition and discover the fate that awaits you.


## Installation:

1. Clone this repository: `git clone [repository_link]`
2. Navigate to the project directory: `cd FEAR-AND-FORTUNE`
3. Install all the required libraries: `npm i`
4. Develop Targeted Place: `npm dev:game` or `npm dev:lobby`

## Technical Aspects:

### DevOps CI/CD Pipeline
- Automated Game Publishing: With a single push to our repository, our pipeline automatically builds and publishes the game's public version, making the latest updates and features instantly available to players.
- Integrated with GitHub Actions: By leveraging GitHub Actions, we ensure a robust, efficient, and consistent build process, minimizing downtime and maximizing game uptime.

### Custom Game Engine:

- Built to provide modularity and flexibility. It enables developers to create many flavours of game genres under my Game Framework.
- Demonstrates my capability to understand and develop deep technical systems from scratch.

### Dependency Injection:

- Improves code maintainability by decoupling classes.
- Allows for efficient testing by swapping dependencies.

### React Framework for UI:

- Enables a modern, responsive UI experience.
- Integrates seamlessly with the game's core components.

### Data-Driven & Domain-Driven Design:

- Game variables and configurations are easily adjustable without code changes.
- Codebase designed to reflect real-world systems, enhancing modularity and understandability.

### Game Design Patterns
In "Fear and Fortune", I deeply value maintainability, scalability, and a coherent structure. My approach leans heavily on tried-and-tested game design patterns, ensuring not only the smooth gameplay experience but also the sustainability of our development process. Some of the patterns I've integrated include:

- **Observer Pattern for UI**: This ensures that our user interface remains responsive and updated in real-time as game states change. Through this pattern, UI components are notified automatically about game events, providing players with a dynamic, immersive experience.

- **Singleton Pattern**: Used for crucial game components to ensure only one instance exists. This pattern centralizes the management of game resources, avoiding redundancy and optimizing performance.

- **State Pattern for Game States**: This pattern is instrumental in managing different states of our game (like menu, play, pause, game over). It ensures smooth transitions between states and keeps game logic clear and organized.
