-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAZENAMENTO DO PAINEL GESTOR - banco de dados (tabela night_management)
-- O banco é a fonte oficial; os arquivos data/*.json são regravados como espelho porque
-- vrp (stocks), inventory (robberies/robbery_points) e propertys (houses) leem esses arquivos ao iniciar.
-- Na primeira vez, o que existir em data/*.json e ainda não estiver no banco é importado.
-----------------------------------------------------------------------------------------------------------------------------------------
local Resource = GetCurrentResourceName()
local Files = { "data/atms.json","data/props.json","data/blips.json","data/houses.json","data/stocks.json","data/robberies.json","data/robbery_points.json" }
local Cache = {}

Storage = {}

local function Mirror(File,Data)
	SaveResourceFile(Resource,File,json.encode(Data,{ indent = true }),-1)
end

local function Decode(Raw)
	local Ok,Data = pcall(json.decode,Raw or "{}")
	return Ok and type(Data) == "table" and Data or {}
end

exports.oxmysql:query_async([[
	CREATE TABLE IF NOT EXISTS `night_management` (
		`Name` VARCHAR(64) NOT NULL,
		`Data` LONGTEXT NOT NULL,
		`Updated` INT(11) NOT NULL DEFAULT 0,
		PRIMARY KEY (`Name`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
]])

local Rows = {}
for _,Row in ipairs(exports.oxmysql:query_async("SELECT `Name`,`Data` FROM `night_management`") or {}) do
	Rows[Row.Name] = Row.Data
end

for _,File in ipairs(Files) do
	if Rows[File] then
		Cache[File] = Decode(Rows[File])
	else
		local Raw = LoadResourceFile(Resource,File)
		Cache[File] = Decode(Raw)
		if Raw and next(Cache[File]) then
			exports.oxmysql:query_async("INSERT IGNORE INTO `night_management` (`Name`,`Data`,`Updated`) VALUES (?,?,?)",{ File,json.encode(Cache[File]),os.time() })
			print("^2[Night_Management]^7 "..File.." importado para o banco.")
		end
	end

	Mirror(File,Cache[File])
end

function Storage.Read(File)
	return Cache[File] and json.decode(json.encode(Cache[File])) or {}
end

function Storage.Write(File,Data)
	local Ok,Result = pcall(function()
		return exports.oxmysql:query_async("INSERT INTO `night_management` (`Name`,`Data`,`Updated`) VALUES (?,?,?) ON DUPLICATE KEY UPDATE `Data` = VALUES(`Data`), `Updated` = VALUES(`Updated`)",{ File,json.encode(Data),os.time() })
	end)
	if not Ok or not Result then
		return false
	end

	Cache[File] = json.decode(json.encode(Data))
	Mirror(File,Cache[File])

	return true
end
