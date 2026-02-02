-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - DATABASE SCHEMA
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- TABLE: lxr_oil_wells
-- Stores all oil well information
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_oil_wells` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `owner` VARCHAR(50) NOT NULL,
    `coords` VARCHAR(255) NOT NULL,
    `heading` FLOAT NOT NULL DEFAULT 0.0,
    `quality` INT(11) NOT NULL DEFAULT 100,
    `coal` INT(11) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_production` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `owner_idx` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- TABLE: lxr_oil_barrels
-- Stores all barrel information
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_oil_barrels` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `oil_well_id` INT(11) NOT NULL,
    `owner` VARCHAR(50) NOT NULL,
    `coords` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `owner_idx` (`owner`),
    INDEX `oil_well_id_idx` (`oil_well_id`),
    CONSTRAINT `fk_barrels_oil_well`
        FOREIGN KEY (`oil_well_id`) 
        REFERENCES `lxr_oil_wells` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- TABLE: lxr_oil_businesses
-- Stores player business information
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_oil_businesses` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `owner` VARCHAR(50) NOT NULL,
    `business_type` VARCHAR(50) NOT NULL DEFAULT 'personal',
    `business_name` VARCHAR(255) NOT NULL DEFAULT 'My Oil Business',
    `rent_paid_until` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `owner_unique` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- TABLE: lxr_oil_workers
-- Stores worker information for businesses
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_oil_workers` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `business_id` INT(11) NOT NULL,
    `worker_name` VARCHAR(255) NOT NULL,
    `worker_type` VARCHAR(50) NOT NULL DEFAULT 'Laborer',
    `salary` INT(11) NOT NULL DEFAULT 50,
    `hired_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_paid` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `business_id_idx` (`business_id`),
    CONSTRAINT `fk_workers_business`
        FOREIGN KEY (`business_id`) 
        REFERENCES `lxr_oil_businesses` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- TABLE: lxr_oil_income
-- Tracks all income and expenses
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_oil_income` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `owner` VARCHAR(50) NOT NULL,
    `transaction_type` VARCHAR(50) NOT NULL,
    `amount` INT(11) NOT NULL,
    `description` VARCHAR(255) NULL DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `owner_idx` (`owner`),
    INDEX `transaction_type_idx` (`transaction_type`),
    INDEX `created_at_idx` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- TABLE: lxr_oil_missions
-- Stores active and completed missions
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_oil_missions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `player` VARCHAR(50) NOT NULL,
    `mission_type` VARCHAR(50) NOT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'active',
    `progress` INT(11) NOT NULL DEFAULT 0,
    `reward` INT(11) NOT NULL DEFAULT 0,
    `xp` INT(11) NOT NULL DEFAULT 0,
    `started_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `completed_at` TIMESTAMP NULL DEFAULT NULL,
    `expires_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `player_idx` (`player`),
    INDEX `status_idx` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- TABLE: lxr_oil_player_data
-- Stores player-specific data (XP, level, etc.)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_oil_player_data` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `player` VARCHAR(50) NOT NULL,
    `xp` INT(11) NOT NULL DEFAULT 0,
    `level` INT(11) NOT NULL DEFAULT 0,
    `total_barrels_sold` INT(11) NOT NULL DEFAULT 0,
    `total_income` INT(11) NOT NULL DEFAULT 0,
    `total_missions` INT(11) NOT NULL DEFAULT 0,
    `last_mission` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `player_unique` (`player`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIAL DATA
-- ═══════════════════════════════════════════════════════════════════════════════

-- No initial data needed - tables are ready for use

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF DATABASE SCHEMA
-- ═══════════════════════════════════════════════════════════════════════════════
