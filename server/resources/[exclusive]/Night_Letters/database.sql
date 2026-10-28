CREATE TABLE IF NOT EXISTS `night_letters` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `sender_id` int(11) NOT NULL,
    `receiver_id` int(11) NOT NULL,
    `subject` varchar(255) NOT NULL,
    `message` longtext NOT NULL,
    `date` varchar(50) NOT NULL,
    `timestamp` int(11) NOT NULL DEFAULT 0,
    `deleted_sender` tinyint(1) DEFAULT 0,
    `deleted_receiver` tinyint(1) DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Caso você já possua a tabela e queira apenas atualizar as colunas novas:
-- ALTER TABLE `night_letters` ADD COLUMN IF NOT EXISTS `timestamp` INT(11) NOT NULL DEFAULT 0;
-- ALTER TABLE `night_letters` ADD COLUMN IF NOT EXISTS `deleted_sender` TINYINT(1) DEFAULT 0;
-- ALTER TABLE `night_letters` ADD COLUMN IF NOT EXISTS `deleted_receiver` TINYINT(1) DEFAULT 0;