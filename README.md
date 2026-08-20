# DESCENT

DESCENT is a survival/horror game on Roblox built using [Rojo](https://rojo.space/). 
Players must navigate a dangerous environment, manage their resources, and survive as they descend deeper.

## Features

- **Survival Mechanics:** Monitor and manage your oxygen, stamina, and health. Beware of suffocation effects and deadly traps.
- **Elevator Game Loop:** The core progression revolves around an elevator controller, moving between levels and safe zones.
- **Immersive First-Person:** Locked first-person camera with realistic head rotation, flashlight mechanics, and dynamic lighting.
- **Interactive Environment:** Inventory system with item pickups, and interactive events like Fuel QTEs (Quick Time Events).
- **Advanced Movement:** Dynamic crouching and stamina-based sprinting.
- **Multiplayer Ready:** Includes a spectator mode for players who have died, and server-side validation for most mechanics.

## Repository Structure

- `src/server/` - Server-side game logic (Elevator, Inventory, Traps, Oxygen, Game Loop).
- `src/StarterCharacterScripts/` - Client-side character movement and camera controllers (First-person, Crouch, Head Rotation).
- `src/StarterPlayerScripts/` - Client-side UI, lighting, and screen effects (Spectator, Inventory, Suffocation).
- `DESCENT.rbxl` - The main Roblox Studio place file.