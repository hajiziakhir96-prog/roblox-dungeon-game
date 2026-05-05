# Roblox Dungeon Game - Design Document

## Core Systems

### 1. Player Stats System
- **Stats:** Strength, Agility, Defense
- **Progression:** Level, Experience, Skill Points
- **Health:** Max Health berdasarkan level
- **Attributes:**
  - **Strength:** Increase maximum attack damage (1.5x multiplier)
  - **Agility:** Increase attack speed (2% per point above 5)
  - **Defense:** Reduce incoming damage (2% per point above 5, max 80%)

### 2. Combat System
- **Damage Calculation:** Base damage + Strength bonus ± variation (80-120%)
- **Critical Hit:** 15% chance, 1.5x damage multiplier
- **Attack Speed:** Cooldown based on Agility stat
- **Combo System:** +25% damage per consecutive hit (max 0.5s between hits)

### 3. Monster System
- **Monster Types:** Goblin, Orc, Troll (expandable)
- **Monster Stats:** Similar to player (health, strength, agility, defense)
- **AI Behavior:** Patrol, chase player, attack
- **Loot:** Experience drops, Gold drops, Item drops

### 4. Currency System
- **Gold:** Regular currency (earned from monsters)
- **Robux:** Premium currency (earned from special challenges, purchasable with real money)

## Game Flow

1. **Lobby Phase**
   - Players spawn in safe lobby
   - Can upgrade stats with skill points
   - View inventory and equipment
   - Wait for other players or enter dungeon alone

2. **Dungeon Phase**
   - Enter dungeon through portal
   - Monster spawn di berbagai lokasi
   - Boss door - entry blocked, opens when player deals enough damage
   - Boss fight - high difficulty, high rewards

3. **Combat Phase**
   - Player attacks monster with sword
   - Swing animation plays
   - Damage calculated based on stats
   - Monster AI attacks back
   - On monster death: gain experience, loot, gold

## Future Features
- Multiplayer co-op dungeon
- Equipment system (armor, weapons, accessories)
- Skill abilities (special moves)
- Dungeon difficulty levels
- Daily challenges
- Leaderboard system
