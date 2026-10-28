local Config = LoadNailConfig()

vRP.Prepare("night_nailshop/CreateTable",[[
    CREATE TABLE IF NOT EXISTS `night_nailshop` (
        `Passport` int(11) NOT NULL,
        `nail_data` longtext DEFAULT '{}',
        PRIMARY KEY (`Passport`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
]])

vRP.Prepare("night_nailshop/Get","SELECT nail_data FROM `night_nailshop` WHERE Passport = @Passport")
vRP.Prepare("night_nailshop/Set","REPLACE INTO `night_nailshop` (Passport,nail_data) VALUES (@Passport,@nail_data)")

AddEventHandler("onResourceStart",function(resourceName)
    if resourceName ~= GetCurrentResourceName() or not Config.AutoRunSQL then return end
    vRP.Query("night_nailshop/CreateTable",{})
    Debug("info","Database table checked")
end)
