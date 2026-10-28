-- Spectrem Director manual database schema
-- Version: 2.8.0 - Beta
-- Use this file only if the resource cannot create its tables automatically.
--
-- Recommended import order:
--   1. Make sure your server database exists.
--   2. Import this file into that database.
--   3. Start oxmysql before spectrem_director.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `spectrem_director_ped_folders` (
    `id` VARCHAR(60) NOT NULL,
    `name` VARCHAR(120) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spectrem_director_peds` (
    `id` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `model` VARCHAR(100) NOT NULL DEFAULT 'mp_m_freemode_01',
    `appearance` LONGTEXT NOT NULL,
    `folder_id` VARCHAR(60) NULL DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_spectrem_director_peds_folder_id` (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spectrem_director_custom_scenes` (
    `id` VARCHAR(60) NOT NULL,
    `name` VARCHAR(150) NOT NULL,
    `entries` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spectrem_director_ghost_replays` (
    `id` VARCHAR(60) NOT NULL,
    `name` VARCHAR(150) NOT NULL,
    `recording_data` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spectrem_director_ped_replays` (
    `id` VARCHAR(60) NOT NULL,
    `name` VARCHAR(150) NOT NULL,
    `recording_data` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spectrem_director_vehicle_sessions` (
    `id` VARCHAR(80) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `frames` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spectrem_director_saved_vehicles` (
    `id` VARCHAR(60) NOT NULL,
    `name` VARCHAR(120) NOT NULL,
    `model` VARCHAR(100) NOT NULL DEFAULT '',
    `model_hash` VARCHAR(32) NOT NULL,
    `properties` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_spectrem_saved_vehicles_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spectrem_director_club_presets` (
    `id` VARCHAR(80) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `config` LONGTEXT NOT NULL,
    `coords` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spectrem_director_timeline_projects` (
    `id` VARCHAR(80) NOT NULL,
    `owner` VARCHAR(100) NOT NULL,
    `name` VARCHAR(150) NOT NULL,
    `duration` INT UNSIGNED NOT NULL DEFAULT 180,
    `clips` LONGTEXT NOT NULL,
    `editor` LONGTEXT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_spectrem_timeline_owner_updated` (`owner`, `updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
