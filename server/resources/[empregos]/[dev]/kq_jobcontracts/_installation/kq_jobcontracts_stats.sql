CREATE TABLE IF NOT EXISTS `kq_jobcontracts_stats` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `player` char(50) NOT NULL DEFAULT '',
    `job` char(50) NOT NULL DEFAULT '',
    `jobs_finished` int(11) NOT NULL DEFAULT 0,
    `xp` int(11) NOT NULL DEFAULT 0,
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `player_job_unique` (`player`,`job`),
    KEY `player_job` (`player`,`job`)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
