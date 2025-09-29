# Game Design Synthesis: Badass Wizard Extraction Shooter

## Core Attractors Identified

**Primary Emotional Drivers:**
- **Power Fantasy with Tactical Depth** - Feeling like an unstoppable magical warrior while requiring skill and strategy
- **Movement as Expression** - Advanced movement mechanics (sliding, wall-running) as core gameplay tools, not just navigation
- **Risk/Reward Addiction** - Mystery box upgrades with meaningful trade-offs and curses creating gambling-style engagement
- **Visual Impact Obsession** - Every action must have satisfying visual/audio feedback (enemy obliteration, weapon power visualization)
- **Retro-Modern Fusion** - Classic FPS feel with contemporary game design sophistication

**Recurring Creative Energy Points:**
- Tattooed biker wizard aesthetic combining supernatural and modern elements
- Movement mechanics that teach players through gameplay rather than tutorials
- Soul-based economy tied directly to combat effectiveness
- Environmental storytelling through visual aftermath of player actions

## Resolved Ambiguities

**Primary Direction Chosen:** Fast-paced arcade shooter with RPG progression elements over simulation-style tactical shooter
**Aesthetic Direction:** Low-poly retro with pixelated textures over modern realistic graphics
**Progression System:** Mystery box gambling with individual item costs over traditional linear upgrade trees
**Movement Philosophy:** Advanced movement as tactical tools over simple mobility enhancement

**Not Included:** Traditional shop interface, realistic graphics pipeline, cover-based tactical combat

## MVP Design Brief

### One-Line Pitch
A dark fantasy extraction shooter where a cursed biker wizard uses advanced movement mechanics and supernatural firearms to obliterate demons while gambling souls on magical upgrades.

### Genre & Platform
**Primary Genre:** First-Person Shooter (Extraction/Arena subgenre)  
**Secondary Elements:** Action RPG progression, Roguelike upgrade mechanics  
**Platform:** PC (Godot 4.x engine, designed for keyboard/mouse)  
**Target Audience:** Players who enjoy Doom Eternal, Risk of Rain 2, Dead Cells movement systems

### Core Gameplay Loop
1. **Combat Phase:** Fight waves of supernatural enemies using firearms and movement
2. **Collection Phase:** Gather souls from defeated enemies as currency
3. **Upgrade Phase:** Spend souls at mystery boxes for random powerful upgrades
4. **Escalation Phase:** Face increasingly challenging enemies with enhanced abilities
5. **Repeat** with compounding power and difficulty

### Primary Mechanics

**Movement System:**
- WASD + mouse look with advanced techniques (sliding, planned wall-running)
- Sliding changes collision shape for tactical positioning
- Movement abilities unlock through upgrades creating skill expression

**Combat System:**  
- Double barrel shotgun with buckshot spread and player knockback
- Bullet physics with satisfying impact feedback and enemy destruction
- Visual damage indication through enemy deformation/obliteration

**Upgrade System:**
- Mystery boxes with 3 random choices per activation
- Individual item pricing preventing unlimited purchases
- Meaningful upgrade categories: movement, combat, survivability

**Enemy AI:**
- Three-tier system: Fast/Weak, Balanced, Slow/Strong
- Intelligent spawning maintaining engagement without overwhelming
- Future expansion: Boss enemies requiring movement mastery

### Player Role & Objectives

**Character:** Cursed biker wizard fighting supernatural outbreak to collect souls for survival
**Core Fantasy:** Unstoppable magical gunslinger with supernatural mobility
**Victory Conditions:** Survive escalating waves while building power through strategic upgrade choices
**Failure States:** Health depletion triggers scene restart, maintaining progression consequence

**Narrative Framework:** 
- Wizard made deal with devil, slowly dying without soul collection
- Fighting devil's own army creates perpetual stalemate
- Player death is canonical - represents one reality where wizard failed

### Art Style / Narrative Theme

**Visual Style:** 
- PS1/early 3D aesthetic with low-poly models and pixelated textures
- Bold color contrasts with limited palette (purples, golds, blood reds, shadow blacks)
- Chunky geometric shapes with dramatic lighting

**Narrative Tone:**
- Dark fantasy with moral ambiguity (survival over heroism)
- Environmental storytelling through battle aftermath persistence
- Urban fantasy meets supernatural horror aesthetic

**Audio Direction:** 
- Chunky, immediate sound effects emphasizing weapon power
- Atmospheric ambient tracks supporting dungeon exploration feel
- Audio feedback crucial for combat satisfaction

### Technical Assumptions / Constraints

**Engine:** Godot 4.x with GDScript for rapid prototyping and learning-friendly development
**Asset Pipeline:** GIMP for textures, Blender for 3D models, focus on simple geometric forms
**Performance Target:** 60fps with 8+ enemies and complex particle effects
**Development Scope:** Single developer (high school student) with learning-as-building approach
**Platform Assumptions:** PC with keyboard/mouse, designed for modest hardware requirements

### What's Excluded (Edge Cuts)

**Multiplayer Systems:** Single-player focus for MVP development manageable scope
**Complex Narrative:** Environmental storytelling only, no cutscenes or dialogue systems  
**Realistic Graphics:** Stylized approach avoids complex lighting/rendering pipeline
**Multiple Weapon Types:** Focus on perfecting shotgun mechanics before expanding arsenal
**Large Open Worlds:** Arena-based encounters in contained environments for technical simplicity

## Expansion Suggestions

### Immediate Post-MVP Features
- **Wall-running mechanics** with level design supporting vertical movement
- **Speed visualization system** with dynamic FOV and screen effects
- **Additional enemy types** including fallen wizard boss encounters
- **Environmental hazards** requiring movement skill navigation
- **Weapon modification system** through magical augmentations

### Medium-Term Content Expansion
- **Relic artifact system** with powerful abilities and meaningful limitations
- **Multiple arena environments** with distinct tactical challenges
- **Curse system** at powerful upgrade stations with double-edged benefits
- **Environmental persistence** showing cumulative battle damage across sessions
- **Advanced enemy behaviors** responding to player movement mastery

### Long-Term Vision Features
- **Procedural arena generation** for infinite replayability
- **Multiple wizard character builds** with different starting abilities
- **Cooperative multiplayer** for shared arena survival
- **Mod support** for community-created enemies and upgrades
- **Mobile/console ports** expanding platform accessibility

### Technical Infrastructure Expansion
- **Save/load progression system** maintaining upgrade unlocks
- **Achievement/unlock system** encouraging varied playstyles  
- **Analytics integration** for balance tuning based on player behavior
- **Accessibility options** for broader player inclusion
- **Performance optimization** for lower-end hardware support

---

**Design Brief Completion Date:** January 29, 2025  
**Intended Audience:** AI development assistants and project continuation  
**Development Phase:** MVP implementation with established technical foundation  
**Core Philosophy:** Power fantasy through skill expression with meaningful risk/reward progression