# GridHop - Quick Reference Card

## 🎮 Controls

| Action | How To |
|--------|--------|
| **Move** | Tap a green-highlighted tile |
| **Attack** | Tap ⚔️ Attack button, then tap enemy |
| **Defend** | Tap 🛡️ Defend button (adds shield +3, ends turn) |
| **End Turn** | Tap "End Turn" button |
| **See Enemy Info** | Long-press on enemy (coming soon) |

---

## ⚔️ Combat Stats

### Hero
- **HP:** 12
- **Move:** 1 tile per turn
- **Attack:** 3 damage + push 1 tile
- **Defend:** +3 shield, ends turn

### Enemies

**Grunt** (Red)
- HP: 5
- Damage: 2
- Move: 1
- Reward: 5 gold

**Brute** (Orange)
- HP: 14
- Damage: 4
- Move: 1
- Push: 1
- Reward: 15 gold

---

## 🎯 Game Rules

### Turn Order
1. **Player Phase**
   - Choose action (move, attack, or defend)
   - Action resolves immediately
   
2. **Enemy Phase**
   - Enemies show intent (⚔️ = attack, arrow = move)
   - Wait 0.8 seconds
   - Each enemy acts in sequence
   - Enemies move toward hero or attack if adjacent

3. **End of Turn**
   - Status effects process (poison damage)
   - Check win/lose conditions
   - Next turn begins

### Push Mechanics
- **When you attack:** Enemy is pushed 1 tile away from you
- **When Brute attacks:** You are pushed 1 tile away
- **Blocked pushes:** If target tile is occupied or invalid, push fails
- **Strategic use:** Push enemies into each other or off the grid

### Status Effects
- **Shield:** Absorbs damage before HP
- **Poison:** Takes damage each turn, decreases by 1
- **Stun:** Skip next turn (not yet implemented)

### Victory & Defeat
- **Win:** Defeat all enemies
- **Lose:** Your HP reaches 0
- **Restart:** Tap screen after game ends

---

## 💡 Strategy Tips

### Movement
- Position yourself so enemies can't surround you
- Use push to create distance
- Corner enemies to prevent escape
- Stay near center of grid for mobility

### Combat
- Attack Grunts first (easier to kill)
- Use push to separate groups
- Defend when multiple enemies are adjacent
- Save defend for when you'd take lethal damage

### Resource Management
- Collect all gold (15g from Brutes is significant!)
- Defend strategically (don't waste shield)
- Every move matters in tight situations

### Enemy Behavior
- Enemies ALWAYS move toward you
- They attack if adjacent
- They're predictable - plan ahead
- Use their AI against them

---

## 🐛 Known Issues / Limitations

Current MVP limitations:
- No undo button
- No pause menu
- No tutorial
- Simple graphics (colored shapes)
- No sound effects yet
- Can't view enemy stats
- No items or weapons yet

All of these are planned for future updates!

---

## 🔧 Debug Info

### For Testing
- FPS counter: Visible in top-right (if enabled)
- Node count: Shows active sprites
- Console logs: Combat events, turns, deaths

### Common Issues
- **Touch not responding:** Make sure you're in Player Phase
- **Can't move:** Check if tile is highlighted (green)
- **Can't attack:** Check if enemy is in range (adjacent only)
- **Enemies not acting:** Wait for intent indicators to appear

---

## 📊 Initial Balance

These numbers are tuned for the MVP. Expected to change!

**Difficulty Curve:**
- Turn 1-3: Easy (learn mechanics)
- Turn 4-6: Medium (manage resources)
- Turn 7+: Hard (low HP, multiple enemies)

**Expected Run Time:**
- First time: 2-3 minutes
- Experienced: 1-2 minutes
- Mastery: 30-60 seconds

**Win Rate Target:**
- First try: ~30%
- After 5 games: ~60%
- After 10 games: ~80%

---

## 🎯 Core Design Philosophy

**The Hoplite Trinity:**
1. **Push** - Positional control
2. **Retreat** - Spacing management  
3. **Predict** - Read enemy intent

**Every Turn Should Offer:**
- A safe option (defend/retreat)
- A risky option (aggressive attack)
- A tactical option (positioning)

**Player Should Feel:**
- Clever when they win
- "One more try" when they lose
- Improvement over time

---

## 🚀 Version Info

**Version:** 0.1.0 (MVP)
**Date:** November 2025
**Status:** Prototype - Core loop functional

**What Works:**
✅ Grid movement
✅ Combat with push
✅ Enemy AI
✅ Win/lose conditions
✅ Turn management
✅ Basic UI

**Coming Next:**
- Better visuals & sound
- More enemy types
- Weapons & items
- Level progression
- Meta-unlocks

---

## 📝 Quick Playtesting Checklist

When testing builds, verify:
- [ ] Hero can move to adjacent tiles
- [ ] Attack button highlights enemies
- [ ] Attacks deal correct damage
- [ ] Push moves enemies backward
- [ ] Enemies show intent indicators
- [ ] Enemies move/attack appropriately
- [ ] Game over shows on death
- [ ] Victory shows when all enemies dead
- [ ] Can restart after game ends
- [ ] HP displays update correctly
- [ ] Gold increments on enemy death
- [ ] Turn counter increments
- [ ] Defend grants shield

---

## 🎓 For Developers

### Key Files
- `GridManager.swift` - Grid logic
- `CombatManager.swift` - Turn flow
- `GameScene.swift` - Input & rendering
- `Actor.swift` - Base stats
- `Hero.swift` - Player specifics
- `Enemy.swift` - AI behavior
- `HUD.swift` - UI display

### To Modify Balance
1. Open relevant class file
2. Find init() method
3. Change numbers
4. Rebuild & test

### To Add Features
1. Check ROADMAP.md for architecture guidance
2. Keep systems modular
3. Test incrementally
4. Update this reference!

---

**Happy developing! 🎮**

Keep this reference handy while playing and developing.
Update it as features are added!
