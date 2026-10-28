local tables = {
    ['kq_jobcontracts_stats'] = [[
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
    ]],
}

local function EnsureTablesExists()

    for tableName, insertQuery in pairs(tables) do
        local checkQuery = [[
            SELECT COUNT(*) as count
            FROM information_schema.tables
            WHERE table_name = ']] .. tableName .. [['
        ]]

        local result = DB.SqlQuery(checkQuery)
        if result and result[1] and result[1].count == 0 then
            -- Table does not exist, create it
            DB.SqlMutate(insertQuery)
            print("^2" .. tableName .. " table created successfully.")
        end
    end
end

Citizen.CreateThread(function()
    --Call the function to ensure the tables exists
    Citizen.SetTimeout(50, EnsureTablesExists)
end)
