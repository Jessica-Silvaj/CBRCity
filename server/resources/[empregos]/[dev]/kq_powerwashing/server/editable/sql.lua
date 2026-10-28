
local function GetVehicleIdentifier(vehicle)
    if not DoesEntityExist(vehicle) then
        return nil
    end
    -- You could replace this with your custom solution for getting the vehicles
    return GetVehicleNumberPlateText(vehicle) .. '-' .. GetEntityModel(vehicle)
end

--- SQL Stuff
local SQL_DRIVER = Config.sql.driver
local function SqlQuery(query, data)
    if SQL_DRIVER == 'mysql' then
        return MySQL.Sync.fetchAll(query, data or {})
    end

    if SQL_DRIVER == 'oxmysql' then
        return exports[SQL_DRIVER]:query_async(query, data or {})
    else
        return exports[SQL_DRIVER]:executeSync(query, data or {})
    end
end

local function SqlMutate(query, data)
    if SQL_DRIVER == 'mysql' then
        return MySQL.Sync.insert(query, data)
    end

    if SQL_DRIVER == 'oxmysql' then
        return exports[SQL_DRIVER]:insert_async(query, data)
    else
        return exports[SQL_DRIVER]:executeSync(query, data)
    end
end


DB = {
}

DB.SqlMutate = SqlMutate
DB.SqlQuery = SqlQuery
