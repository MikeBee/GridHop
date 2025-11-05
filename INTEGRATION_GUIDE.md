# Quick Integration Guide

## Step-by-Step Instructions

### 1. Add New Files to Xcode

1. Open your `GridHop.xcodeproj` in Xcode
2. In the Project Navigator (left sidebar), right-click on the `GridHop` folder
3. Choose **"Add Files to GridHop..."**
4. Navigate to where you saved the output files
5. Select these NEW files:
   - `GridManager.swift`
   - `Actor.swift`
   - `Hero.swift`
   - `Enemy.swift`
   - `CombatManager.swift`
   - `HUD.swift`
6. Make sure **"Copy items if needed"** is CHECKED
7. Make sure **"Add to targets: GridHop"** is CHECKED
8. Click **"Add"**

### 2. Replace GameScene.swift

1. In Project Navigator, find and select `GameScene.swift`
2. Delete it (right-click → Delete → Move to Trash)
3. Right-click on `GridHop` folder again
4. Choose **"Add Files to GridHop..."**
5. Select the NEW `GameScene.swift` from outputs
6. Make sure **"Copy items if needed"** is CHECKED
7. Click **"Add"**

### 3. Update Project Settings (if needed)

The project should build without any additional settings, but verify:

1. Select the **GridHop** project in Project Navigator
2. Select the **GridHop** target
3. Go to **"Build Phases"** tab
4. Expand **"Compile Sources"**
5. Verify all 7 Swift files are listed:
   - AppDelegate.swift
   - GameViewController.swift
   - GameScene.swift ← NEW
   - GridManager.swift ← NEW
   - Actor.swift ← NEW
   - Hero.swift ← NEW
   - Enemy.swift ← NEW
   - CombatManager.swift ← NEW
   - HUD.swift ← NEW

### 4. Build the Project

1. Press **Cmd+B** or go to **Product → Build**
2. Check for any errors in the Issue Navigator
3. If you see errors, they're likely just missing files - make sure all files were added

### 5. Run on Simulator

1. Select a simulator from the device menu (e.g., iPhone 15)
2. Press **Cmd+R** or go to **Product → Run**
3. The game should launch!

### 6. Test Core Functionality

Once running, test these features:

✅ **Movement:**
- You should see a hex grid
- Your hero is the blue circle in the center
- Tap any green-highlighted tile to move there

✅ **Combat:**
- Red/orange circles are enemies
- Tap the "⚔️ Attack" button
- Red highlights appear on enemies in range
- Tap an enemy to attack
- Enemy should get pushed backward

✅ **Enemy Turn:**
- After your action, enemies show intent (⚔️ or arrows)
- They move or attack after a short delay
- Turn counter increases

✅ **UI:**
- Top bar shows HP and Gold
- Bottom has 3 action buttons
- HP updates when damaged

## Troubleshooting

### "No such module" errors
- Clean build folder: **Shift+Cmd+K**
- Rebuild: **Cmd+B**

### Files not compiling
- Check that all files are in **Build Phases → Compile Sources**
- Drag files into that list if missing

### Scene not loading
- Make sure `GameScene.swift` is the new version
- Check console for errors

### Touch not working
- Make sure you're running on simulator/device, not preview
- Check that GameViewController is loading the scene correctly

### Layout issues
- The game works in both portrait and landscape
- Try rotating the device/simulator

## Quick Verification Checklist

Before considering it "working," verify:

- [ ] Grid renders on screen
- [ ] Hero (blue) is visible in center
- [ ] 3 enemies spawn around hero
- [ ] Can tap tiles to move hero
- [ ] Can tap Attack button, then enemy
- [ ] Enemy takes damage and gets pushed
- [ ] Enemies show intent and take turns
- [ ] HP updates when damaged
- [ ] Game Over screen shows when hero dies
- [ ] Victory screen shows when all enemies die
- [ ] Can restart by tapping after game ends

## File Structure After Integration

Your project should look like this:

```
GridHop/
├── AppDelegate.swift
├── GameViewController.swift
├── GameScene.swift (REPLACED)
├── GameScene.sks
├── Actions.sks
├── GridManager.swift (NEW)
├── Actor.swift (NEW)
├── Hero.swift (NEW)
├── Enemy.swift (NEW)
├── CombatManager.swift (NEW)
├── HUD.swift (NEW)
├── Assets.xcassets/
└── Base.lproj/
```

## Next Steps After Integration

Once the game is running:

1. **Playtest** the basic combat loop
2. **Adjust balance** numbers in the code:
   - Hero HP in `Hero.swift` init
   - Enemy stats in `Enemy.swift` init
   - Damage/push values in Actor classes
3. **Identify what to add next**:
   - More enemy types?
   - Special abilities?
   - Better visuals?
   - Level progression?

## Need Help?

If something isn't working:

1. Check the Xcode console for error messages
2. Verify all files are added to the target
3. Try a clean build (Shift+Cmd+K, then Cmd+B)
4. Check that no old code conflicts exist

---

**You're ready to go!** The MVP is fully functional and ready for iteration.
