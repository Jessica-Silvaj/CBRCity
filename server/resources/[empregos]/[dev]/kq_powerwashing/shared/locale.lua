-- Loaded locale strings table
local localeData = {}

-- Load a locale JSON file from a resource and merge into localeData
function loadLocale(resourceName, filePath)
    local fileContent = LoadResourceFile(resourceName, filePath)
    if not fileContent then
        print(string.format("Error: Could not load file '%s' from resource '%s'", filePath, resourceName))
        return
    end

    local parsed = json.decode(fileContent)
    if not parsed then
        print(string.format("Error: Could not parse JSON from file '%s' in resource '%s'", filePath, resourceName))
        return
    end

    for key, value in pairs(parsed) do
        localeData[key] = value
    end
end

-- Translate a dot-separated locale key, with optional variable substitution
-- Example: L("ui.title", { name = "John" })
function L(key, vars)
    -- Traverse nested keys split by "."
    local parts = {}
    for part in string.gmatch(key, "[^%.]+") do
        table.insert(parts, part)
    end

    local current = localeData
    for _, part in ipairs(parts) do
        current = current[part]
        if not current then
            return "[MISSING_LOCALE] " .. key
        end
    end

    -- Replace {{varName}} placeholders if vars provided
    if type(current) == "string" and vars then
        current = string.gsub(current, "{{%s*(%w+)%s*}}", function(varName)
            return vars[varName] or ("{{" .. varName .. "}}")
        end)
    end

    return current
end

-- Load the configured locale on startup
loadLocale(GetCurrentResourceName(), "locales/" .. Config.locale .. ".json")