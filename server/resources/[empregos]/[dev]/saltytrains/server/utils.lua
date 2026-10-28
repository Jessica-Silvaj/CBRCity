function GetPlayerXP(identifier, cb)
    MySQL.query("SELECT xp FROM saltytrains_xp WHERE identifier = ?", { identifier }, function(result)
        if result and result[1] then
            cb(result[1].xp)
        else
            cb(0)
        end
    end)
end

function SavePlayerXP(identifier, xp)
    MySQL.query(
        "INSERT INTO saltytrains_xp (identifier, xp) VALUES (?, ?) ON DUPLICATE KEY UPDATE xp = ?",
        { identifier, xp, xp }
    )
end

function SendWebhook(webhookUrl, title, description, color)
    if not webhookUrl or webhookUrl == "" then return end
    PerformHttpRequest(webhookUrl, function() end, "POST", json.encode({
        embeds = {{
            title = title,
            description = description,
            color = color or 3447003,
        }}
    }), { ["Content-Type"] = "application/json" })
end
