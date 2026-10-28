CREATE TABLE IF NOT EXISTS `saltytrains_xp` (
    `identifier` VARCHAR(255) NOT NULL,
    `xp` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
