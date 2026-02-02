# Changelog

All notable changes to LXR Oil Corporation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-02

### Added
- 🛢️ **Oil Well System**
  - Place oil wells at any location
  - Quality degradation system (1% per cycle)
  - Coal-based fuel system (max 100 coal)
  - Repair system with resource requirements (iron bar, wood, cash)
  - Destroy oil wells to recover item
  - Interactive menu system
  - Status checking (ID, owner, quality, coal)
  - Maximum 3 oil wells per personal player

- 🎯 **Barrel Production System**
  - Automated cron job production (10-minute cycles)
  - Coal consumption during production
  - Quality-based production eligibility
  - Production chance configuration (50% default)
  - Maximum 10 barrels per oil well
  - Barrel spawn offsets around wells
  - Automatic cleanup when quality reaches 0

- 📦 **Barrel Management**
  - Pick up barrels with animation
  - Carry barrel system with prop attachment
  - Drop barrels at new locations
  - Sell up to 3 barrels at a time
  - Multiple selling locations (Valentine, Blackwater, Saint Denis, Annesburg)
  - Configurable sell price ($50 default)
  - Database tracking for ownership

- 💼 **Business Management**
  - 4 business tiers:
    - Personal Operation (Free, 3 wells, 0 workers)
    - Small Business ($5,000, 5 wells, 2 workers, 10% production bonus)
    - Oil Company ($15,000, 10 wells, 5 workers, 25% production bonus)
    - Oil Corporation ($50,000, 20 wells, 10 workers, 50% production bonus)
  - Business upgrade system
  - Production and quality bonuses per tier
  - Sell price bonuses per tier
  - Business offices in major towns
  - Interactive business menu

- 👷 **Worker Management**
  - 3 worker types:
    - Laborer ($50 salary, 5% production bonus)
    - Experienced Worker ($100 salary, 10% production bonus)
    - Expert Engineer ($200 salary, 20% production bonus)
  - Hire/fire system
  - Worker salary tracking
  - Production and quality bonuses per worker
  - Maximum workers based on business tier

- 🎮 **Mission System**
  - 4 mission types:
    - Delivery (Transport barrels, requires wagon)
    - Exploration (Survey land for oil sites)
    - Maintenance (Emergency repairs)
    - Protection (Defend wells from threats)
  - Reward system (money + XP)
  - Time limits for missions
  - Mission cooldowns (global and per-type)
  - Mission giver NPCs
  - Mission progress tracking

- 📊 **Progression System**
  - XP rewards for:
    - Oil well placement (50 XP)
    - Oil well repair (25 XP)
    - Barrel production (5 XP per barrel)
    - Barrel sold (10 XP per barrel)
    - Missions completed (varies by type)
  - Level system (100 XP per level)
  - Level requirements for features
  - Statistics tracking (barrels sold, income, missions)

- 💰 **Income Tracking**
  - Transaction logging for:
    - Barrel sales (income)
    - Oil well repairs (expense)
    - Business upgrades (expense)
    - Worker hiring (expense)
    - Rent payments (expense)
    - Mission rewards (income)
  - Daily, weekly, monthly income views
  - All-time statistics
  - Database-backed tracking

- 🚛 **Wagon System**
  - Wagon requirements for large deliveries
  - 8 supported wagon types
  - Configurable barrel capacity per wagon
  - Wagon validation for missions

- 🎨 **Visual Features**
  - Map blips for:
    - Oil wells (with custom icon)
    - Business offices
    - Selling locations
    - Mission givers
  - Interactive targets (rsg-target, ox_target)
  - Oil derrick props (p_oilderrick01x)
  - Barrel props (p_barrel02ax)
  - NPC spawning for sellers and mission givers
  - Animations for:
    - Oil well placement
    - Oil well repair
    - Barrel pickup
    - Barrel drop

- 🔧 **Framework Support**
  - LXRCore (Primary)
  - RSG-Core (Primary)
  - QBR-Core
  - QR-Core
  - VORP Core
  - RedEM:RP
  - Standalone mode
  - Auto-detection system
  - Framework bridge for universal compatibility

- 🎯 **Target System Support**
  - rsg-target (Recommended)
  - ox_target
  - qb-target
  - Auto-detection

- 🔔 **Notification Support**
  - ox_lib (Recommended)
  - RSG Core notifications
  - VORP notifications
  - Native RedM notifications

- 🌍 **Localization**
  - English (Complete)
  - Locale system for easy translation
  - Support for multiple languages
  - Georgian references in branding

- 🛡️ **Security Features**
  - Resource name protection
  - SQL injection prevention (parameterized queries)
  - Server-side validation
  - Owner verification for oil wells
  - Transaction verification for sales

- 📖 **Documentation**
  - Comprehensive README.md
  - Detailed INSTALLATION.md
  - CHANGELOG.md
  - Inline code documentation
  - Configuration examples
  - Troubleshooting guide

- 🏷️ **Branding**
  - LXR/The Lux Empire branding
  - The Land of Wolves server branding
  - ASCII art headers
  - Version checking system
  - Developer credits
  - Server information blocks

### Technical Details
- Database: 7 tables with proper foreign keys and cascading
- Performance: Optimized queries and cron jobs
- Code Structure: Modular client/server separation
- Error Handling: Comprehensive error checking
- Memory Management: Proper prop cleanup and garbage collection

### Configuration Options
- 100+ configuration options
- Fully customizable locations
- Adjustable timers and cooldowns
- Configurable prices and rewards
- Flexible business tiers
- Mission customization

---

## [Unreleased]

### Planned Features
- Oil refinery system for processing
- Trading system between players
- Company shares and partnerships
- Advanced worker AI with pathfinding
- More mission types and variants
- Seasonal events and bonuses
- Mobile oil camps
- Oil wagon transport improvements
- Leaderboards and rankings
- Oil field competition events

---

**Made with ❤️ by iBoss21 for The Land of Wolves 🐺**

[1.0.0]: https://github.com/iboss21/lxr-oil-corp/releases/tag/v1.0.0
