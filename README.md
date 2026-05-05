# Roblox Dungeon Game

Sebuah game Roblox dengan sistem combat, monster spawn, boss fights, dan stat upgrade system.

## Features
1. Monster spawn dalam dungeon
2. Boss door - boss keluar bila sentuh pintu
3. Sword dalam tangan player
4. Swing animation masa serang
5. Stat upgrade system - Strength, Agility, Defense
6. Robux currency system
7. Lobby untuk players menunggu
8. Dungeon yang besar dan terang

## Project Structure
```
roblox-dungeon-game/
├── src/
│   ├── modules/
│   │   ├── PlayerStats.lua
│   │   ├── Combat.lua
│   │   ├── Monster.lua
│   │   └── Currency.lua
│   ├── server/
│   │   ├── PlayerInitializer.lua
│   │   ├── MonsterSpawner.lua
│   │   └── BossManager.lua
│   └── client/
│       ├── CombatController.lua
│       └── UIController.lua
└── docs/
    └── DESIGN.md
```

## Development Status
- [x] Project Setup
- [ ] Core: Player Stats Module
- [ ] Core: Combat System
- [ ] Core: Monster Spawn System
- [ ] Features: Boss Door
- [ ] Features: Sword & Animation
- [ ] Features: Stat Upgrade UI
- [ ] Features: Robux System
- [ ] Map: Lobby Design
- [ ] Map: Dungeon Design
