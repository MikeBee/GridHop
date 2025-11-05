# GridHop Development Roadmap

## 🎯 Current Status: MVP Complete ✅

**What's Working:**
- ✅ Hex grid system with pathfinding
- ✅ Hero with movement, attack, defend
- ✅ 2 enemy types with simple AI
- ✅ Push mechanics
- ✅ Turn-based combat
- ✅ Win/Lose conditions
- ✅ Basic HUD
- ✅ Gold collection

---

## 🗺️ Development Phases

### Phase 1: MVP Polish (1-2 weeks)
*Make the core loop feel great*

**Priority: HIGH**

- [ ] **Better Visuals**
  - Replace colored squares with actual sprites
  - Add attack animations (slash effects)
  - Add particle effects for hits
  - Add death animations
  - Grid tile improvements (textures, highlights)

- [ ] **Sound Design**
  - Attack sounds (thwack, slash)
  - Hit sounds (impacts)
  - Movement sounds (footsteps)
  - UI sounds (button clicks)
  - Ambient background music
  - Victory/defeat music

- [ ] **UI Improvements**
  - Damage numbers floating up
  - Status effect icons
  - Better button styling
  - Turn indicator animations
  - Tooltip on long-press (enemy stats)

- [ ] **Feel & Juice**
  - Screen shake on hits
  - Slow-motion on killing blows
  - Color flashes on damage
  - Better push animation
  - Victory/defeat transitions

**Success Metric:** Game feels satisfying to play for 5+ minutes

---

### Phase 2: Core Mechanics Expansion (2-3 weeks)
*Add tactical depth*

**Priority: HIGH**

- [ ] **Weapon System**
  ```swift
  protocol Weapon {
      var damage: Int
      var range: Int
      var pattern: AttackPattern
      var pushDistance: Int
      var cooldown: Int
  }
  ```
  - Sword (melee, push 1)
  - Spear (range 2, line attack)
  - Hammer (heavy damage, stun chance)
  - Dagger (fast, no push, poison)

- [ ] **Attack Patterns**
  - Single target (current)
  - Line attack (hits all in line)
  - Cone attack (3 tiles in front)
  - Area attack (all adjacent)

- [ ] **Consumables**
  - Health potion (heal 6 HP)
  - Bomb (4 area damage)
  - Teleport scroll (move anywhere)
  - Shield potion (grant shield)

- [ ] **Status Effects (expanded)**
  - Poison (✓ already implemented)
  - Stun (✓ already implemented)
  - Slow (reduce movement)
  - Burn (damage over time, spreads)
  - Freeze (skip turn + take extra damage)

- [ ] **Hero Abilities**
  - Leap (jump over enemies)
  - Whirlwind (attack all adjacent)
  - Shield bash (push + stun)
  - Counter stance (reflect damage)

**Success Metric:** 3+ viable playstyles, interesting decisions each turn

---

### Phase 3: Enemy Variety (2-3 weeks)
*Make encounters diverse and challenging*

**Priority: HIGH**

- [ ] **New Enemy Types**
  - Archer (range 3, low HP)
  - Tank (high HP, blocks paths)
  - Summoner (spawns minions)
  - Bomber (suicide explosion)
  - Healer (heals other enemies)
  - Elite variants (stronger versions)

- [ ] **Enemy Behaviors**
  - Aggressive (always moves toward hero)
  - Defensive (maintains distance)
  - Flanking (tries to surround)
  - Tactical (uses terrain)
  - Pack behavior (coordinate attacks)

- [ ] **Boss Enemies**
  - Multi-phase fights
  - Special abilities
  - Minion spawning
  - Area denial attacks

- [ ] **Encounter Design**
  - Balanced enemy compositions
  - Positioning puzzles
  - Ambush scenarios
  - Horde encounters

**Success Metric:** Each fight feels unique and requires different tactics

---

### Phase 4: Progression Systems (3-4 weeks)
*Add the "roguelite" meta*

**Priority: MEDIUM**

- [ ] **Run Structure**
  - 6-10 node map per run
  - Node types:
    - Combat (fight enemies)
    - Shop (buy items)
    - Camp (heal + choice)
    - Relic (powerful pickup)
    - Event (random encounters)
    - Boss (end of region)

- [ ] **Shop System**
  ```swift
  class Shop {
      var items: [ShopItem]
      var weapons: [Weapon]
      var relics: [Relic]
  }
  ```
  - Gold-based economy
  - Consumables
  - Weapons
  - Relics
  - Reroll option

- [ ] **Relic System**
  - Passive effects
  - Build-defining items
  - Synergies between relics
  - Rare/legendary tiers

- [ ] **Meta-Progression**
  ```swift
  struct PersistentUnlocks {
      var unlockedWeapons: [Weapon]
      var unlockedPerks: [Perk]
      var unlockedCharacters: [Character]
      var totalGoldCollected: Int
  }
  ```
  - Permanent unlocks
  - Starting item choices
  - Stat upgrades
  - New characters

- [ ] **Perks/Upgrades**
  - In-run upgrades at camps
  - Choice of 3 per camp
  - Build-defining choices

**Success Metric:** Progression feels meaningful, unlocks change gameplay

---

### Phase 5: Data-Driven Systems (2 weeks)
*Make balancing easy*

**Priority: MEDIUM**

- [ ] **JSON Definitions**
  - `enemies.json`
  ```json
  {
    "grunt": {
      "hp": 5,
      "damage": 2,
      "moveRange": 1,
      "attackRange": 1,
      "goldReward": 5
    }
  }
  ```
  - `weapons.json`
  - `items.json`
  - `perks.json`
  - `levels.json`

- [ ] **Data Loading System**
  ```swift
  class GameDataLoader {
      func loadEnemies() -> [String: EnemyData]
      func loadWeapons() -> [String: WeaponData]
      func loadItems() -> [String: ItemData]
  }
  ```

- [ ] **Live Reloading**
  - Hot-reload JSON in debug mode
  - No recompile needed for balance changes
  - CSV export for analysis

**Success Metric:** Can rebalance without recompiling, fast iteration

---

### Phase 6: Level Generation (2-3 weeks)
*Procedural content*

**Priority: MEDIUM**

- [ ] **Map Generator**
  ```swift
  class LevelGenerator {
      func generateRun(seed: Int) -> [Node]
      func generateEncounter(difficulty: Int) -> Encounter
      func selectEnemies(pool: [EnemyType], budget: Int) -> [Enemy]
  }
  ```

- [ ] **Encounter Templates**
  - Pre-designed enemy compositions
  - Difficulty scaling
  - Boss fights
  - Special encounters

- [ ] **Biomes/Themes**
  - Forest (grunts, archers)
  - Dungeon (brutes, traps)
  - Volcano (fire enemies)
  - Each with unique enemy pool

- [ ] **Difficulty Scaling**
  - Enemy stats increase
  - More enemies per encounter
  - Elite variants appear
  - Boss at end

**Success Metric:** Every run feels different, appropriate difficulty curve

---

### Phase 7: Save System (1 week)
*Persistence*

**Priority: MEDIUM**

- [ ] **Save Manager**
  ```swift
  class SaveManager {
      func saveGame()
      func loadGame() -> SaveData?
      func saveUnlocks()
      func loadUnlocks() -> Unlocks
  }
  ```

- [ ] **What to Save**
  - Persistent unlocks
  - Current run state (optional)
  - Settings
  - Statistics

- [ ] **Data Format**
  - JSON (human-readable)
  - Local file storage
  - Export/import option

**Success Metric:** Unlocks persist between sessions

---

### Phase 8: Polish & Accessibility (2 weeks)
*Make it feel professional*

**Priority: LOW (but important)

- [ ] **Settings Menu**
  - Sound volume
  - Music volume
  - Text size
  - Colorblind mode
  - Tutorial toggle

- [ ] **Tutorial System**
  - First-time player guide
  - Highlight mechanic
  - Tooltip system
  - Practice mode

- [ ] **Accessibility**
  - Colorblind-friendly
  - Text scaling
  - High contrast mode
  - Icon + text for everything

- [ ] **QoL Features**
  - Undo last move
  - Action preview
  - Threat indicator
  - Damage calculation display

**Success Metric:** Anyone can pick up and play

---

### Phase 9: Advanced Features (3+ weeks)
*Nice to have*

**Priority: LOW**

- [ ] **Daily Challenges**
  - Seeded runs
  - Leaderboards
  - Special modifiers

- [ ] **Achievement System**
  - Challenge achievements
  - Unlock achievements
  - Stats tracking

- [ ] **Multiple Characters**
  - Different starting stats
  - Unique abilities
  - Different playstyles

- [ ] **Mutation/Modifier System**
  - Run modifiers (harder but more rewards)
  - Chaos mode
  - Themed runs

- [ ] **Advanced AI**
  - Behavior trees
  - Tactical coordination
  - Adaptive difficulty

**Success Metric:** Tons of replayability

---

## 📊 Priority Matrix

### Do First (MVP Polish + Core Mechanics)
1. Better visuals & sound
2. Weapon system
3. More enemies
4. Attack patterns

### Do Second (Progression Loop)
5. Run structure
6. Shop system
7. Meta-progression
8. Data-driven design

### Do Third (Content & Polish)
9. Level generation
10. Save system
11. Accessibility
12. Advanced features

---

## 🎮 Suggested Development Sprints

### Sprint 1 (Week 1-2): Polish MVP
- Focus: Make current game feel great
- Output: Satisfying combat with good feedback

### Sprint 2 (Week 3-4): Weapons & Enemies
- Focus: Add variety to combat
- Output: 4 weapons, 4 new enemy types

### Sprint 3 (Week 5-6): Run Structure
- Focus: Build the meta-game
- Output: Shop, camps, node map

### Sprint 4 (Week 7-8): Progression
- Focus: Make runs matter
- Output: Unlocks, relics, upgrades

### Sprint 5 (Week 9-10): Data & Generation
- Focus: Procedural content
- Output: JSON configs, level generator

### Sprint 6 (Week 11-12): Save & Polish
- Focus: Persistence and feel
- Output: Save system, tutorial, settings

---

## 🔧 Technical Debt to Address

- [ ] Refactor touch handling (too much in GameScene)
- [ ] Separate rendering from logic
- [ ] Unit tests for combat math
- [ ] Unit tests for pathfinding
- [ ] Performance profiling (lots of actors)
- [ ] Memory management (sprite reuse)

---

## 📈 Metrics to Track

### During Development:
- Build time
- Crash rate
- Memory usage
- Frame rate (60 FPS target)

### Gameplay Metrics:
- Average run length
- Win rate
- Most used weapons
- Most dangerous enemies
- Gold earned per run

### Iteration Speed:
- Time to add new enemy
- Time to add new weapon
- Time to balance change

---

## 🎯 Definition of "Done"

A feature is done when:
- [ ] Code is written and tested
- [ ] No crashes or obvious bugs
- [ ] Feels good to play
- [ ] Data-driven (if applicable)
- [ ] Documented in code
- [ ] Playtested for balance

---

## 💡 Design Principles

1. **Every action should feel impactful**
2. **Show, don't tell** (visual feedback over text)
3. **Fail fast, iterate faster**
4. **Fun first, balance second**
5. **Mobile-first** (works on iPhone & iPad)
6. **Respect player time** (5-20 min runs)
7. **Clear information** (always show enemy intent)
8. **Tactical depth** (positioning matters)

---

**Remember:** This is YOUR game. Pick what sounds fun and start building! The MVP is working - everything else is iteration.

What excites you most? Start there! 🚀
