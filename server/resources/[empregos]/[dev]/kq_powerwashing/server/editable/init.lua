local tables = {
    ['kq_snowchains_vehicles'] = [[
CREATE TABLE IF NOT EXISTS `kq_snowchains_vehicles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `vehicle` varchar(50) NOT NULL DEFAULT '0',
    `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `vehicle` (`vehicle`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
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
    --Citizen.SetTimeout(50, EnsureTablesExists)
end)

