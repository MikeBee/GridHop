# GridHop

## 🎮 What's Been Built

### ✅ Core Systems Implemented

1. **Hex Grid System** (`GridManager.swift`)
   - Axial coordinate system for hex tiles
   - Pathfinding with A* algorithm
   - Reachable tile calculations
   - Circular grid layout (radius: 4)

2. **Actor System** (`Actor.swift`, `Hero.swift`, `Enemy.swift`)
   - Base Actor class with HP, movement, attack stats
   - Hero with defend ability and gold tracking
   - Two enemy types: Grunt (5 HP, 2 damage) and Brute (14 HP, 4 damage)
   - Visual HP display on all actors
   - Status effects: shield, poison, stun

3. **Combat Manager** (`CombatManager.swift`)
   - Turn-based combat flow
   - Player phase → Enemy phase cycle
   - Push mechanics on attacks
   - Death handling and gold rewards
   - Enemy AI decision making

4. **Game Scene** (`GameScene.swift`)
   - Full tactical grid visualization
   - Touch input for movement and attacks
   - Tile highlighting for valid moves/attacks
   - Game over and victory screens
   - Restart functionality

5. **HUD** (`HUD.swift`)
   - HP and Gold display
   - Turn counter
   - Action buttons (Attack, Defend, End Turn)
   - Real-time stat updates

### 🎯 Current Gameplay Loop

1. **Player Turn:**
   - Tap tiles to move (green highlights show valid moves)
   - Tap "⚔️ Attack" button, then tap enemy to attack
   - Tap "🛡️ Defend" to add +3 shield and end turn
   - Tap "End Turn" to skip to enemy phase

2. **Enemy Turn:**
   - Enemies show intent indicators (⚔️ for attack, arrows for movement)
   - Enemies move toward hero using pathfinding
   - Enemies attack if in range
   - Turn automatically returns to player

3. **Win/Lose Conditions:**
   - Victory: All enemies defeated
   - Defeat: Hero HP reaches 0
   - Collect gold from defeated enemies
   - Tap to restart after game ends

### ⚔️ Combat Mechanics

- **Push System:** Hero attacks push enemies 1 tile away
- **Damage:** Hero deals 3 damage, Grunts deal 2, Brutes deal 4
- **Defend:** Reduces next incoming damage and adds shield
- **Shield:** Absorbs damage before HP
- **Movement:** 1 tile per turn (can be upgraded later)
- **Attack Range:** Adjacent tiles only (melee)


## 🎨 Visual Guide

- **Blue Circle:** Your Hero
- **Red/Orange Circles:** Enemies (Grunts/Brutes)
- **Green Highlights:** Valid movement tiles
- **Red Highlights:** Valid attack targets
- **Numbers on Actors:** Current HP (+ shield if any)
- **Yellow Arrows:** Enemy movement intent
- **⚔️ Icon:** Enemy attack intent

## 🚀 What's Next (Future Features)

Based on your spec, here are the next development priorities:

### Phase 2 - Enhanced Gameplay:
- [ ] Add weapon system (different attack patterns)
- [ ] Implement consumables (health potions, bombs)
- [ ] Add more enemy types with varied AI
- [ ] Cooldown-based special abilities
- [ ] Retreat bonus mechanic

### Phase 3 - Progression:
- [ ] Level generator (procedural encounters)
- [ ] Shop system
- [ ] Relic/perk system
- [ ] Meta-progression (persistent unlocks)
- [ ] Multiple biomes/themes

### Phase 4 - Data-Driven:
- [ ] JSON-based enemy definitions
- [ ] External weapon/item configs
- [ ] Save/load system
- [ ] Debug console

### Phase 5 - Polish:
- [ ] Better sprites and animations
- [ ] Sound effects and music
- [ ] Particle effects
- [ ] Tutorial system
- [ ] Settings menu

## 🐛 Testing Checklist

- [x] Hero can move to adjacent tiles
- [x] Hero can attack enemies
- [x] Attacks push enemies backward
- [x] Enemies move toward hero
- [x] Enemies attack when adjacent
- [x] HP tracking works correctly
- [x] Game over triggers on hero death
- [x] Victory triggers when all enemies dead
- [x] Defend button grants shield
- [x] Turn counter increments
- [x] Gold awarded on enemy death

## 💡 Design Notes

### Deterministic AI
- Enemies always choose the shortest path
- Attack if in range, otherwise move closer
- Predictable for tactical planning
- Shows intent before acting

### Turn Structure
1. Player action selection
2. Action resolution (immediate)
3. Enemy intent display (0.8s)
4. Enemy actions execute (0.4s each)
5. Status effects process
6. Check win/lose conditions
7. Next turn begins

## 🎯 Balance Numbers (Initial)

```
Hero:
- HP: 12
- Movement: 1 tile
- Attack: 3 damage + push 1
- Defend: +3 shield

Grunt:
- HP: 5
- Movement: 1 tile
- Attack: 2 damage

Brute:
- HP: 14
- Movement: 1 tile
- Attack: 4 damage + push 1

Rewards:
- Grunt kill: 5 gold
- Brute kill: 15 gold
```

## 📝 Code Architecture

The code follows clean separation of concerns:

- **GridManager:** Pure logic, no rendering
- **Actors:** Data + minimal behavior
- **CombatManager:** Game rules & flow
- **GameScene:** Rendering & input
- **HUD:** UI only

This makes it easy to:
- Test individual systems
- Modify balance numbers
- Add new features
- Debug issues

## 🎓 Key Design Patterns Used

- **ECS-lite:** Actors as components
- **State Machine:** Game phases (player/enemy/gameover)
- **Command Pattern:** Actions resolved through manager
- **Observer:** HUD updates on game state changes
- **Factory:** Enemy creation by type
