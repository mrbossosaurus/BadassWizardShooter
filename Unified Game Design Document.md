# Unified Game Design Document: Cursed Biker-Wizard FPS

## Executive Summary

**One-Line Pitch:** A dark fantasy FPS roguelite where a cursed biker-wizard uses limited movement charges and runic firearms to survive procedural demon-infested tunnels, collecting souls for mystical upgrades.

## Core Vision & Attractors

### Primary Emotional Drivers
- **Tactical Power Fantasy** - Feel unstoppable while requiring skill and resource management
- **Movement as Expression** - Advanced movement mechanics (charge-based dash/jump/slide) as core tactical tools
- **Risk/Reward Addiction** - Mystery box upgrades and cursed altar choices creating meaningful gambling decisions
- **Visual Impact Obsession** - Satisfying feedback for every action (enemy obliteration, corruption clearing, runic effects)
- **Retro-Modern Fusion** - Classic FPS feel with contemporary roguelite progression depth

### Core Fantasy
**Character:** Immortal biker-wizard bound by soul contract, fighting through corrupted tunnels
**Power Fantasy:** Supernatural gunslinger with mystical mobility mastering resource-based movement
**Narrative Framework:** Player collects souls to stave off corruption while fighting through demonic outbreak

## Genre & Platform

**Primary Genre:** First-Person Shooter (Roguelite/Extraction subgenre)  
**Secondary Elements:** Action RPG progression, Resource management, Procedural generation  
**Platform:** PC (Godot 4.x, keyboard/mouse optimized)  
**Target Audience:** Fans of Doom Eternal movement, Risk of Rain 2 upgrades, Dead Cells progression

## Core Gameplay Loop

### Moment-to-Moment Gameplay
1. **Navigate** procedural tunnel networks using limited movement charges
2. **Combat** demon hordes with runic-enhanced firearms and tactical positioning  
3. **Manage** shield timer and movement charges under pressure
4. **Clear** corruption zones to create temporary safe bubbles
5. **Collect** souls from defeated enemies as primary currency

### Meta-Progression Loop
1. **Spawn** in corrupted tunnel system with specific objective (hack terminal, destroy core, escort relic)
2. **Fight** toward objective while managing finite resources and escalating difficulty
3. **Upgrade** at rare altars, choosing between safe upgrades or powerful cursed options
4. **Extract** upon objective completion or die trying
5. **Repeat** runs with accumulated knowledge and unlocked permanent upgrades

## Primary Mechanics

### Movement System (Core Innovation)
**Charge-Based Movement:**
- **Jump, Dash, Slide** each consume one charge from shared pool (3-5 charges max)
- **Auto-Recharge** system with 2-3 second cooldown per charge (upgradeable)
- **Strategic Resource Management** - every movement input has tactical weight
- **Slide Mechanics** - Changes collision shape for tactical positioning and speed maintenance
- **Future Expansion** - Wall-running unlocked through upgrades

**Current Implementation Gap:** Replace unlimited WASD movement in `player.gd:94`

### Combat System
**Primary Weapon - Runic Shotgun:**
- Double-barrel with buckshot spread and player knockback feedback
- **Runic Enhancement System** - Tap rune sequences during reload animations for elemental effects
- Bullet physics with satisfying impact and enemy destruction
- Visual damage through enemy deformation/obliteration

**Melee System:**
- **Boot-Kick Attack** - High knockback, only available while sprinting
- Integrates with movement system for advanced combat flow

**Current Implementation Gap:** Add runic reload system to `player.gd:114` shooting mechanics

### Defense System
**Shield + Health Model:**
- **Large Rechargeable Shield** (primary defense, acts as combat timer)
- **Small Non-Regenerating Health** (permanent damage consequence)
- Shield recharge creates natural combat rhythm and retreat incentives

**Current Implementation Gap:** Replace 100 HP system in `player.gd:6`

### Upgrade & Progression System
**Altar-Based Upgrades:**
- **Soul Currency** collected from enemy kills (replace money system)
- **Mystery Box Mechanics** - 3 random choices per altar activation
- **Cursed Upgrade Options** - High power boosts with meaningful drawbacks
- **Greed Lever** - Optional difficulty spike for enhanced rewards

**Upgrade Categories:**
- **Movement** - Additional charges, faster recharge, new movement types
- **Combat** - Weapon power, runic effects, firing speed
- **Defense** - Shield capacity, recharge rate, damage resistance
- **Utility** - Corruption resistance, soul collection efficiency, objective speed

**Current Implementation Gap:** Transform `shop_ui.gd` and `mystery_box.gd` into altar system

### Enemy & Spawning System
**Corruption-Based Spawning:**
- Replace timed enemy waves with **corruption density system**
- Killing enemies clears local corruption, creating temporary safe zones
- Standing in cleared areas too long spawns elite demons
- **Three-Tier Enemy Design:**
  - Fast/Weak (quick harassment)
  - Balanced (core threat)
  - Slow/Strong (area denial)

**Current Implementation Gap:** Replace `world.gd:46` arena spawning with corruption mechanics

### Level Structure
**Procedural Tunnel Networks:**
- **Objective-Based Runs** - Each run has specific goal (terminal hack, artifact retrieval, core destruction)
- **Modular Corridor System** - Tile-based generation for varied layouts
- **Corruption Visualization** - Visual density indicating danger/spawning likelihood
- **Environmental Storytelling** - Battle aftermath persists through level geometry

**Current Implementation Gap:** Replace arena `world.tscn` with procedural tunnel generator

## Art Style & Technical Direction

### Visual Style
**PS1/Retro 3D Aesthetic:**
- Low-poly models with 256×256 pixelated textures
- Bold color palette: purples, golds, blood reds, shadow blacks
- Chunky geometric shapes with dramatic lighting
- Heavy particles and visual effects for power fantasy satisfaction

### Audio Design
- **Chunky Weapon Audio** - Immediate, powerful sound feedback
- **Atmospheric Ambient** - Dark fantasy dungeon exploration tone
- **Audio-Driven Combat** - Sound crucial for combat satisfaction and feedback

### Technical Constraints
**Engine:** Godot 4.x with GDScript for rapid iteration
**Performance Target:** 60fps with 8+ enemies and complex effects
**Asset Pipeline:** GIMP textures, Blender models, geometric focus
**Development Scope:** Single developer with learning-integrated approach

## Current Implementation Status

### Completed Foundation (~20% toward vision)
- ✅ Core FPS mechanics (movement, shooting, camera)
- ✅ Basic enemy AI with three types
- ✅ Upgrade framework (shop/mystery box systems)
- ✅ UI integration and scene management
- ✅ Money economy (ready for souls conversion)

### Critical Implementation Gaps
1. **Movement Charges System** - Replace unlimited movement with resource management
2. **Shield/Health Overhaul** - Implement large shield + small health model
3. **Corruption Spawning** - Replace timed waves with corruption-density system
4. **Objective-Based Levels** - Add terminal/artifact goals to current arena
5. **Runic Reload System** - Add rune-tap mechanics during weapon reloading
6. **Altar Upgrades** - Transform shop systems into mysterious altar encounters

## Development Roadmap

### Phase 1: Core System Overhaul (2-3 weeks)
**Priority 1:** Movement charge system implementation
**Priority 2:** Shield/health system replacement  
**Priority 3:** Soul economy conversion (rename money variables)

### Phase 2: Level Structure Evolution (3-4 weeks)
**Priority 1:** Objective system addition to current arena
**Priority 2:** Corruption mechanics replacing timed enemy spawning
**Priority 3:** Single test corridor before procedural generation

### Phase 3: Combat Depth Enhancement (2-3 weeks)
**Priority 1:** Boot-kick melee system integration
**Priority 2:** Basic runic reload mechanics
**Priority 3:** Altar system replacing shop/mystery box UI

### Phase 4: Polish & Expansion (4-6 weeks)
**Priority 1:** Procedural tunnel generation
**Priority 2:** Advanced runic effects and combinations
**Priority 3:** Cursed upgrade system with meaningful drawbacks

## Design Philosophy

**Power Through Skill Expression:** Every mechanic should reward mastery while remaining accessible
**Meaningful Resource Management:** Limited charges create tactical weight for every action
**Risk/Reward Depth:** Every upgrade choice should present meaningful trade-offs
**Visual Satisfaction:** Every action must have immediate, satisfying audio-visual feedback
**Emergent Complexity:** Simple systems combining for deep strategic possibilities

---

**Design Document Version:** 1.0 Unified  
**Creation Date:** January 2025  
**Status:** Foundation implemented, core vision defined, ready for systematic development
**Next Action:** Begin movement charge system implementation in `player.gd`