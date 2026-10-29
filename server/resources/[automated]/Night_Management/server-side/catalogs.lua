local CatalogVRP = module("vrp","lib/Proxy").getInterface("vRP")
local Resource = GetCurrentResourceName()

local function Admin(Source)
    local Passport = CatalogVRP.Passport(Source)
    return Passport and CatalogVRP.HasPermission(Passport,Config.Permissions.Permission)
end

local function Notify(Source,Message)
    TriggerClientEvent("Notify",Source,"Painel gestor",Message,"amarelo",5000)
end

local function Integer(Value,Min,Max)
    Value = tonumber(Value)
    if Value and Value == Value and Value >= Min and Value <= Max and Value % 1 == 0 then return Value end
end

local function Read(File)
    return Storage.Read(File)
end

local function Save(Source,File,Data)
    if not Storage.Write(File,Data) then
        Notify(Source,"Não foi possível salvar no banco de dados.")
        return false
    end
    return true
end

local function Robberies(Source)
    if GetResourceState("inventory") ~= "started" then Notify(Source,"O inventory precisa estar iniciado.") return end
    TriggerClientEvent("Night_Management:catalog",Source,"Robberies",exports.inventory:ManagementRobberies())
end

RegisterNetEvent("Night_Management:requestRobberies",function()
    if Admin(source) then Robberies(source) end
end)

RegisterNetEvent("Night_Management:saveRobbery",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" or GetResourceState("inventory") ~= "started" then return end
    local Catalog = exports.inventory:ManagementRobberies()
    local Current
    for _,Entry in ipairs(Catalog) do if Entry.id == Data.id then Current = Entry break end end
    if not Current then return end
    local Entry = { Enabled = Data.Enabled == true }
    for Key,Limits in pairs({ Police = {0,1000}, Delay = {0,604800}, Timer = {1,86400}, Wanted = {0,86400}, Min = {0,100000000}, Max = {0,100000000} }) do
        Entry[Key] = Integer(Data[Key],Limits[1],Limits[2])
        if not Entry[Key] then Notify(Source,"Preencha os valores inteiros dentro dos limites.") return end
    end
    if Entry.Min > Entry.Max then Notify(Source,"A recompensa mínima não pode superar a máxima.") return end
    local Entries = Read("data/robberies.json")
    Entries[Data.id] = Entry
    if Save(Source,"data/robberies.json",Entries) then
        TriggerEvent("Night_Management:robberiesChanged",Entries)
        Robberies(Source)
        Notify(Source,"Configuração de roubo salva.")
    end
end)

RegisterNetEvent("Night_Management:deleteRobbery",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" or type(Data.id) ~= "string" or GetResourceState("inventory") ~= "started" then return end
    local Found = false
    for _,Entry in ipairs(exports.inventory:ManagementRobberies()) do if Entry.id == Data.id then Found = true break end end
    if not Found then return end
    local Entries = Read("data/robberies.json")
    Entries[Data.id] = { Deleted = true }
    if Save(Source,"data/robberies.json",Entries) then
        TriggerEvent("Night_Management:robberiesChanged",Entries)
        Robberies(Source)
        Notify(Source,"Tipo de roubo removido.")
    end
end)

-- Pontos de roubo (data/robbery_points.json); na primeira edição copia a lista atual do inventory
local function RobberyPoints(Source)
    if GetResourceState("inventory") ~= "started" then Notify(Source,"O inventory precisa estar iniciado.") return end
    TriggerClientEvent("Night_Management:catalog",Source,"RobberyPoints",exports.inventory:ManagementRobberyPoints())
end

local function SaveRobberyPoints(Source,Points)
    local Entries = {}
    for _,Point in pairs(Points) do Entries[tostring(Point.id)] = Point end
    if Save(Source,"data/robbery_points.json",Entries) then
        TriggerEvent("Night_Management:robberyPointsChanged",Entries)
        RobberyPoints(Source)
        return true
    end
end

RegisterNetEvent("Night_Management:requestRobberyPoints",function()
    if Admin(source) then RobberyPoints(source) end
end)

RegisterNetEvent("Night_Management:saveRobberyPoint",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" or GetResourceState("inventory") ~= "started" then return end
    local Modes = {}
    for _,Entry in ipairs(exports.inventory:ManagementRobberies()) do Modes[Entry.id] = true end
    if type(Data.Mode) ~= "string" or not Modes[Data.Mode] then Notify(Source,"Escolha um tipo de roubo válido.") return end
    local X,Y,Z = tonumber(Data.X),tonumber(Data.Y),tonumber(Data.Z)
    if not X or not Y or not Z or X ~= X or Y ~= Y or Z ~= Z or math.abs(X) > 20000 or math.abs(Y) > 20000 or math.abs(Z) > 5000 then
        Notify(Source,"Informe uma posição válida.") return
    end
    local Points,Highest = {},0
    for _,Point in ipairs(exports.inventory:ManagementRobberyPoints()) do
        Points[Point.id] = Point
        Highest = math.max(Highest,Point.id)
    end
    local Id = tonumber(Data.id)
    if not Id or not Points[Id] then Id = Highest + 1 end
    Points[Id] = { id = Id,Mode = Data.Mode,X = X,Y = Y,Z = Z }
    if SaveRobberyPoints(Source,Points) then Notify(Source,"Ponto de roubo salvo.") end
end)

RegisterNetEvent("Night_Management:deleteRobberyPoint",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" or GetResourceState("inventory") ~= "started" then return end
    local Points,Found = {},false
    for _,Point in ipairs(exports.inventory:ManagementRobberyPoints()) do
        if Point.id == tonumber(Data.id) then Found = true else Points[Point.id] = Point end
    end
    if not Found then return end
    if not next(Points) then Notify(Source,"Não é possível remover o último ponto de roubo.") return end
    if SaveRobberyPoints(Source,Points) then Notify(Source,"Ponto de roubo removido.") end
end)

local function Houses(Source,Selected)
    if GetResourceState("propertys") ~= "started" then Notify(Source,"O propertys precisa estar iniciado.") return end
    local Catalog = exports.propertys:ManagementHouses()
    Catalog.selected = Selected
    TriggerClientEvent("Night_Management:catalog",Source,"Houses",Catalog)
end

RegisterNetEvent("Night_Management:requestHouses",function()
    if Admin(source) then Houses(source) end
end)

RegisterNetEvent("Night_Management:saveHouse",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" or GetResourceState("propertys") ~= "started" then return end
    local Catalog = exports.propertys:ManagementHouses()
    if type(Data.Interior) ~= "string" or not Catalog.interiors[Data.Interior] then return end
    local Price = Integer(Data.Price,1,1000000000)
    local X,Y,Z = tonumber(Data.X),tonumber(Data.Y),tonumber(Data.Z)
    if not Price or not X or not Y or not Z or X ~= X or Y ~= Y or Z ~= Z or math.abs(X) > 20000 or math.abs(Y) > 20000 or math.abs(Z) > 5000 then
        Notify(Source,"Informe posição válida e preço inteiro positivo.") return
    end
    local Id = Data.id
    if Id and Id ~= "" then
        local Found = false
        for _,Entry in ipairs(Catalog.houses) do if Entry.id == Id then Found = true break end end
        if not Found or Id == "Hotel" then return end
        if CatalogVRP.SingleQuery("propertys/Exist",{ Name = Id }) then
            Notify(Source,"Esta casa tem proprietário. Não é possível alterar seu cadastro.") return
        end
    else
        local Highest = 0
        for _,Entry in ipairs(Catalog.houses) do Highest = math.max(Highest,tonumber(Entry.id:match("^Propertys(%d+)$")) or 0) end
        Id = "Propertys"..(Highest + 1)
    end
    local Entries = Read("data/houses.json")
    Entries[Id] = { X = X,Y = Y,Z = Z,Interior = Data.Interior,Price = Price }
    if Save(Source,"data/houses.json",Entries) then
        TriggerEvent("Night_Management:housesChanged",Entries)
        Houses(Source,Id)
        Notify(Source,"Casa salva: "..Id)
    end
end)

CatalogVRP.Prepare("Night_Management/vehicleCounts","SELECT Vehicle,COUNT(Vehicle) AS Amount FROM vehicles GROUP BY Vehicle")

-- Estoque da concessionária: valor salvo no painel > Stock do config do vrp > ilimitado
local function Stocks(Source)
    local Overrides = Read("data/stocks.json")
    local Counts = {}
    for _,Row in ipairs(CatalogVRP.Query("Night_Management/vehicleCounts") or {}) do
        Counts[Row.Vehicle] = tonumber(Row.Amount) or 0
    end

    local Entries = {}
    for Model,Vehicle in pairs(ListVehicles or {}) do
        if Vehicle.Mode ~= "Work" then
            local Stock = Vehicle.Stock
            if Overrides[Model] == false then
                Stock = nil
            elseif tonumber(Overrides[Model]) then
                Stock = tonumber(Overrides[Model])
            end

            Entries[#Entries + 1] = {
                id = Model,
                Name = Vehicle.Name or Model,
                Class = Vehicle.Mode == "Rental" and "Aluguel" or (Vehicle.Class or "-"),
                Sold = Counts[Model] or 0,
                Stock = Stock,
                Custom = Overrides[Model] ~= nil
            }
        end
    end

    table.sort(Entries,function(A,B) return A.Name:lower() < B.Name:lower() end)
    TriggerClientEvent("Night_Management:catalog",Source,"Stocks",Entries)
end

RegisterNetEvent("Night_Management:requestStocks",function()
    if Admin(source) then Stocks(source) end
end)

RegisterNetEvent("Night_Management:saveStock",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" or type(Data.id) ~= "string" or not (ListVehicles and ListVehicles[Data.id]) then return end

    local Entries = Read("data/stocks.json")
    if Data.Reset == true then
        Entries[Data.id] = nil
    elseif Data.Stock == nil or Data.Stock == "" then
        Entries[Data.id] = false
    else
        local Stock = Integer(Data.Stock,0,100000)
        if not Stock then Notify(Source,"O estoque deve ser um número inteiro entre 0 e 100000.") return end
        Entries[Data.id] = Stock
    end

    if Save(Source,"data/stocks.json",Entries) then
        TriggerEvent("Night_Management:stocksChanged",Entries)
        Stocks(Source)
        Notify(Source,"Estoque atualizado.")
    end
end)

-- Marcações no mapa criadas pelo painel (data/blips.json), enviadas a todos os jogadores
local function Blips()
    local Entries = {}
    for Id,Blip in pairs(Read("data/blips.json")) do
        Blip.id = Id
        Entries[#Entries + 1] = Blip
    end
    table.sort(Entries,function(A,B) return tostring(A.Name):lower() < tostring(B.Name):lower() end)
    return Entries
end

local function BroadcastBlips()
    local Entries = Blips()
    TriggerClientEvent("Night_Management:blips",-1,Entries)
    return Entries
end

RegisterNetEvent("Night_Management:loadBlips",function()
    TriggerClientEvent("Night_Management:blips",source,Blips())
end)

RegisterNetEvent("Night_Management:requestBlips",function()
    if Admin(source) then TriggerClientEvent("Night_Management:catalog",source,"Blips",Blips()) end
end)

RegisterNetEvent("Night_Management:saveBlip",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" then return end

    local Name = type(Data.Name) == "string" and Data.Name:gsub("^%s+",""):gsub("%s+$","") or ""
    if Name == "" or #Name > 60 then Notify(Source,"Informe um nome com até 60 caracteres.") return end

    local Entry = {
        Name = Name,
        Sprite = Integer(Data.Sprite,0,1000),
        Color = Integer(Data.Color,0,85),
        Scale = tonumber(Data.Scale),
        ShortRange = Data.ShortRange == true,
        X = tonumber(Data.X), Y = tonumber(Data.Y), Z = tonumber(Data.Z)
    }
    if not Entry.Sprite or not Entry.Color then Notify(Source,"Ícone (0-1000) e cor (0-85) devem ser números inteiros.") return end
    if not Entry.Scale or Entry.Scale < 0.1 or Entry.Scale > 3.0 then Notify(Source,"O tamanho deve ficar entre 0.1 e 3.0.") return end
    if not Entry.X or not Entry.Y or not Entry.Z then Notify(Source,"Informe a posição da marcação.") return end

    local Entries = Read("data/blips.json")
    local Id = type(Data.id) == "string" and Entries[Data.id] and Data.id or ("blip_"..os.time().."_"..math.random(1000,9999))
    Entries[Id] = Entry

    if Save(Source,"data/blips.json",Entries) then
        TriggerClientEvent("Night_Management:catalog",Source,"Blips",BroadcastBlips())
        Notify(Source,"Marcação salva.")
    end
end)

RegisterNetEvent("Night_Management:deleteBlip",function(Data)
    local Source = source
    if not Admin(Source) or type(Data) ~= "table" or type(Data.id) ~= "string" then return end

    local Entries = Read("data/blips.json")
    if not Entries[Data.id] then return end
    Entries[Data.id] = nil

    if Save(Source,"data/blips.json",Entries) then
        TriggerClientEvent("Night_Management:catalog",Source,"Blips",BroadcastBlips())
        Notify(Source,"Marcação removida.")
    end
end)
