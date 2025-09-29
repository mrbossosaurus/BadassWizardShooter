# Tomorrow Work Plan: Double-Barrel Shotgun Implementation

## Overview
Transform the current boring single-bullet system into a powerful double-barrel shotgun that embodies the "badass biker-wizard" power fantasy with meaningful tactical knockback mechanics.

## Core Design Goals
- **Power Fantasy**: Gun so strong it kicks you back when fired
- **Tactical Knockback**: Only works in air (prevents ground spam, rewards air combat)
- **Visual Impact**: Multiple pellets, screen shake, powerful effects
- **Limited Ammo**: 2-shot capacity forces reload timing decisions

---

## Phase 1: Shotgun Pellet System (HIGH PRIORITY)

### Task 1.1: Replace Single Bullet with Pellet Spread
**Current Issue**: `player.gd:116` shoots one boring `bullet.tscn`
**New System**: Fire 6-8 pellets in spread pattern

**Implementation Plan:**
1. **Modify shooting function** in `player.gd:114`
   - Loop to create multiple pellets per shot
   - Add spread angle calculation (±15 degrees from center)
   - Randomize each pellet direction within spread cone

2. **Update bullet.gd for pellet behavior**
   - Reduce individual pellet damage (1 damage → 0.5 damage per pellet)
   - Shorter lifetime for pellets (5s → 2s)
   - Different visual appearance (smaller, faster)

**Expected Result**: Each shot fires 6-8 pellets in shotgun spread pattern

### Task 1.2: Visual Upgrade
**Replace boring sphere bullets with:**
- Smaller, faster projectiles
- Muzzle flash effect at gun barrel
- Screen shake on fire
- Particle effects for pellet impacts

---

## Phase 2: Player Knockback System (HIGH PRIORITY)

### Task 2.1: Air-Only Knockback Detection
**Core Mechanic**: Shotgun pushes player backward, but ONLY when airborne

**Implementation Plan:**
1. **Add knockback variables** to `player.gd`:
   ```gdscript
   @export var shotgun_knockback_force: float = 8.0
   @export var knockback_only_in_air: bool = true
   ```

2. **Modify shoot() function**:
   - Check `is_on_floor()` before applying knockback
   - Apply force opposite to camera facing direction
   - Only affect X/Z velocity (don't interfere with gravity)

3. **Knockback physics**:
   - Calculate backward direction: `camera.global_transform.basis.z`
   - Apply impulse to `velocity` in that direction
   - Scale by `shotgun_knockback_force`

**Expected Result**: Shooting in air propels player backward, ground shots have no knockback

### Task 2.2: Advanced Knockback Features
- **Sliding synergy**: Shooting while sliding could boost slide speed
- **Jump-shot combos**: Use knockback for movement tricks
- **Visual feedback**: Screen kick animation when knockback triggers

---

## Phase 3: Reload System (MEDIUM PRIORITY)

### Task 3.1: Two-Shot Capacity
**Current**: Unlimited shots with fire rate cooldown
**New**: 2 shots, then mandatory reload

**Implementation Plan:**
1. **Add ammo variables** to `player.gd`:
   ```gdscript
   @export var max_shotgun_ammo: int = 2
   var current_shotgun_ammo: int = 2
   @export var reload_time: float = 2.0
   var is_reloading: bool = false
   ```

2. **Modify shooting logic**:
   - Check ammo before shooting
   - Decrement ammo on successful shot
   - Trigger reload when ammo = 0
   - Block shooting during reload

3. **Reload mechanics**:
   - Manual reload (R key) or automatic when empty
   - Reload timer with progress feedback
   - Visual/audio cues for reload completion

**Expected Result**: Players must manage 2-shot capacity with strategic reloading

### Task 3.2: UI Integration
- Add ammo counter to `world.gd` UI display
- Show "RELOADING..." indicator during reload
- Visual shells/ammo representation

---

## Phase 4: Audio & Visual Polish (MEDIUM PRIORITY)

### Task 4.1: Powerful Shotgun Audio
- **Gunshot sound**: Deep, booming shotgun blast
- **Reload sounds**: Shell ejection, barrel click, loading
- **Knockback audio**: Whoosh effect when player gets pushed

### Task 4.2: Enhanced Visual Effects
- **Muzzle flash**: Bright flash at gun position
- **Screen shake**: Camera shake on fire (stronger for air shots)
- **Shell ejection**: Visual shells flying out during reload
- **Impact effects**: Better hit particles for pellets

---

## Phase 5: Balance & Polish (LOW PRIORITY)

### Task 5.1: Damage Balancing
**Current damage math**: 1 bullet × 1 damage = 1 total damage
**New damage math**: 6 pellets × 0.5 damage = 3 total damage (if all hit)

- Balance total damage vs. spread accuracy
- Ensure close-range lethality, long-range falloff
- Test against current enemy health values

### Task 5.2: Integration with Existing Systems
- **Mystery box upgrades**: "Tighter spread", "Extra pellets", "Faster reload"
- **Shop purchases**: Ammo capacity, knockback force, reload speed
- **Enemy interactions**: Ensure pellets properly trigger enemy damage

---

## Expected Timeline (1-2 Work Sessions)

**Session 1 (Tomorrow):**
- Phase 1: Pellet spread system
- Phase 2.1: Basic air knockback
- Quick visual improvements

**Session 2 (Next Day):**
- Phase 3: Reload system
- Phase 4: Audio/visual polish
- Balance testing

---

## Success Criteria

**When this is complete, you should have:**
✅ Shotgun that fires 6-8 pellets in spread pattern
✅ Powerful knockback that only works in air
✅ 2-shot reload system with timing strategy
✅ Satisfying audio/visual feedback
✅ Perfect integration with existing slide/movement systems

**Power Fantasy Achievement**: Gun so powerful it launches you backward, but you can use that tactically for movement and aerial combat!

---

**Note**: Keep all existing systems (sliding, upgrades, enemies) working during implementation. Test frequently to ensure no regressions.

Sleep well! Tomorrow we build a weapon worthy of a badass biker-wizard! 🔫⚡