

--- SQL Stuff
local SQL_DRIVER = Config.sql.driver
local function SqlQuery(query, data)
    if SQL_DRIVER == 'mysql' then
        return MySQL.Sync.fetchAll(query, data or {})
    end

    if SQL_DRIVER == 'oxmysql' then
        if Config.sql.newOxMysql then
            return exports[SQL_DRIVER]:fetchSync(query, data or {})
        end
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
        return exports[SQL_DRIVER]:insertSync(query, data)
    else
        return exports[SQL_DRIVER]:executeSync(query, data)
    end
end

DB = {}
DB.SqlMutate = SqlMutate
DB.SqlQuery = SqlQuery

DB.GetPlayerJobStats = function(identifier, job)
    local query = [[
        SELECT jobs_finished, xp
        FROM kq_jobcontracts_stats
        WHERE player = @player AND job = @job
        LIMIT 1;
    ]]

    local result = SqlQuery(query, {
        ['@player'] = identifier,
        ['@job'] = job,
    })

    if result and result[1] then
        return {
            jobs_finished = result[1].jobs_finished or 0,
            xp = result[1].xp or 0,
        }
    end

    return { jobs_finished = 0, xp = 0 }
end

DB.UpdatePlayerJobStats = function(identifier, job, addXp, addJobsFinished)
    local mutation = [[
        INSERT INTO kq_jobcontracts_stats (player, job, xp, jobs_finished)
        VALUES (@player, @job, @xp, @jobs_finished)
        ON DUPLICATE KEY UPDATE
            xp = xp + @xp,
            jobs_finished = jobs_finished + @jobs_finished;
    ]]

    return SqlMutate(mutation, {
        ['@player'] = identifier,
        ['@job'] = job,
        ['@xp'] = addXp or 0,
        ['@jobs_finished'] = addJobsFinished or 0,
    })
end
