
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")

local Server = {}
Tunnel.bindInterface("lb-phone-police",Server)

local function query(sql,params)
	local ok,result = pcall(function()
		return exports.oxmysql:query_async(sql,params or {})
	end)

	if ok and type(result) == "table" then
		return result
	end

	return {}
end

local function identity(Passport)
	return vRP.Identity(parseInt(Passport)) or {}
end

local function fullNameFromIdentity(Passport)
	local Identity = identity(Passport)
	return (Identity.name or Identity.Name or "Passaporte").." "..(Identity.name2 or Identity.Lastname or tostring(Passport))
end

local function fullName(row)
	if not row then
		return "Desconhecido"
	end

	return tostring(row.name or row.Name or "Passaporte").." "..tostring(row.name2 or row.Lastname or row.lastname or row.id or "")
end


local function licenseCategories(Passport)
	local Categories = {}
	
	local NightData = vRP.UserData(Passport, "autoescola_cnh")
	if type(NightData) == "string" then
		local ok, parsed = pcall(json.decode, NightData)
		if ok and parsed then NightData = parsed end
	end
	
	if type(NightData) == "table" then
		for Key, Value in pairs(NightData) do
			if Value == true then
				Categories[#Categories + 1] = tostring(Key)
			end
		end
	end

	if #Categories == 0 then
		local Data = vRP.UserData(Passport,"Driverlicense") or {}
		for Key,Value in pairs(Data.categories or {}) do
			if type(Key) == "number" then
				Categories[#Categories + 1] = tostring(Value)
			elseif Value then
				Categories[#Categories + 1] = tostring(Key)
			end
		end
	end
	
	table.sort(Categories)
	return Categories
end

local AuthorizedGroups = {
	"Admin",
	"Policia"
}

local function accessGroup(Passport)
	if not Passport then
		return false
	end

	for _,Group in pairs(AuthorizedGroups) do
		if vRP.HasGroup(Passport,Group) or vRP.HasPermission(Passport,Group) or vRP.HasService(Passport,Group) then
			return Group
		end
	end

	local TypeGroup = vRP.GetUserType(Passport,"Policia")
	if TypeGroup and TypeGroup ~= "Bombeiro" then
		return TypeGroup
	end

	return false
end

function Server.login()
	local Passport = vRP.Passport(source)
	local Group = accessGroup(Passport)

	if not Group then
		return { status = "unauthorized", passport = Passport }
	end

	return {
		status = "authorized",
		id = Passport,
		name = fullNameFromIdentity(Passport),
		group = Group
	}
end
local function VehicleName(model)
	local ok, name = pcall(function()
		return exports.vrp:VehicleName(model)
	end)
	if ok and name and name ~= "" then
		return name
	end
	return model
end

local function getSerial(Passport)
	local rows = query("SELECT a.Token FROM characters c JOIN accounts a ON a.License = c.License WHERE c.id = @Passport LIMIT 1", { Passport = Passport })
	return rows[1] and rows[1].Token or "Desconhecido"
end

local function getGender(Passport, skin)
	if not skin or skin == "" then
		local rows = query("SELECT Skin FROM characters WHERE id = @Passport", { Passport = Passport })
		if rows[1] and rows[1].Skin then
			skin = tostring(rows[1].Skin)
		end
	end
	skin = tostring(skin or "")

	if string.find(skin, "mp_m_freemode_01", 1, true) then
		return "Masculino"
	elseif string.find(skin, "mp_f_freemode_01", 1, true) or string.find(skin, "-1667301416", 1, true) then
		return "Feminino"
	end
	return "Outro"
end

local function formatPhone(num)
	num = tostring(num or "")
	if string.len(num) >= 9 and not string.find(num, "%(") then
		return "(" .. string.sub(num, 1, 3) .. ")" .. string.sub(num, 4)
	end
	return num
end

local function phone(row,Passport)
	local phoneNumber = nil
	local rows = query("SELECT phone_number FROM phone_phones WHERE owner_id = @Passport LIMIT 1", { Passport = parseInt(Passport) })
	if rows[1] and rows[1].phone_number then
		phoneNumber = tostring(rows[1].phone_number)
	else
		local Identity = Passport and identity(Passport) or {}
		phoneNumber = tostring(row and (row.phone or row.Phone) or Identity.phone or Identity.Phone or "Desconhecido")
	end
	
	return formatPhone(phoneNumber)
end

local function personById(Passport)
	return vRP.Identity(parseInt(Passport))
end

local function wanted(Passport,row)
	local rows = query("SELECT COUNT(*) as count FROM mdt_creative_wanted WHERE Passport = @Passport", { Passport = parseInt(Passport) })
	return rows[1] and parseInt(rows[1].count) > 0
end

local function personPayload(row, identityId)
	if not row then
		return nil
	end

	local Passport = parseInt(identityId or row.id or row.Passport)
	local Fines = query("SELECT * FROM fines WHERE Passport = @Passport",{ Passport = Passport })
	local History = {}

	for _,Fine in ipairs(Fines) do
		History[#History + 1] = {
			fine = parseInt(Fine.Value or 0),
			reason = Fine.Message or "Registro",
			created_at = os.time(),
			arrest_time = 0
		}
	end

	return {
		id = Passport,
		user_id = Passport,
		name = fullName(row),
		phone = phone(row,Passport),
		serial = getSerial(Passport),
		age = parseInt(row.age or row.Age or 20),
		sex = (getGender(Passport, row.skin or row.Skin) == "Masculino") and "M" or "F",
		blood = tostring(row.blood or row.Blood or "1"),
		gun_license = false,
		wanted = { status = wanted(Passport,row), reason = wanted(Passport,row) and "Prisao ativa" or nil },
		criminal_history = History
	}
end

local function vehicleRowsByPlate(plate)
	return query([[
		SELECT v.*, c.*
		FROM vehicles v
		LEFT JOIN characters c ON c.id = v.Passport
		WHERE v.Plate = @Plate
		LIMIT 1
	]],{ Plate = tostring(plate or "") })
end

function Server.getVehicle(plate)
	local Row = vehicleRowsByPlate(plate)[1]
	if not Row then
		return { validPlate = false, customErrorMessage = "Placa invalida" }
	end

	local Owner = parseInt(Row.Passport or Row.id or 0)
	return {
		validPlate = true,
		vehicle = {
			ownerName = fullName(Row),
			ownerId = Owner,
			ownerPhone = phone(Row,Owner),
			ownerIsWanted = wanted(Owner,Row),
			vehicleModel = VehicleName(Row.Vehicle or Row.vehicle) or Row.Vehicle or Row.vehicle,
			vehiclePlate = Row.Plate or Row.plate,
			vehicleTax = parseInt(Row.Tax or Row.tax or 0),
			isVehicleApprehended = parseInt(Row.Arrest or Row.arrest or 0) > os.time(),
			isVehicleStolen = false
		}
	}
end

function Server.getWeapon(serial)
	return { validSerial = false, customErrorMessage = "Registro nao encontrado" }
end

function Server.getIdentity(identityId)
	local Row = personById(identityId)
	if not Row then
		return { validIdentity = false, customErrorMessage = "RG invalido" }
	end

	return { validIdentity = true, identity = personPayload(Row, identityId) }
end

function Server.getDetran(identityId)
	local Row = personById(identityId)
	if not Row then
		return { validIdentity = false, customErrorMessage = "RG invalido" }
	end

	local Passport = parseInt(identityId)
	local Vehicles = {}
	local userVehicles = vRP.Query("vehicles/UserVehicles", { Passport = Passport })
	for _,Vehicle in pairs(userVehicles or {}) do
		local vehName = Vehicle.Vehicle or Vehicle.vehicle
		local vehPlate = Vehicle.Plate or Vehicle.plate
		local isWork = Vehicle.Work or Vehicle.work
		
		local ok, exists = pcall(function() return exports.vrp:VehicleExist(vehName) end)
		local vehicleExists = not ok or exists -- default to true if export fails just in case

		if vehicleExists and (isWork == false or isWork == 0 or isWork == "0" or isWork == nil) then
			Vehicles[#Vehicles + 1] = {
				model = VehicleName(vehName) or vehName,
				plate = vehPlate
			}
		end
	end

	local Payload = personPayload(Row, identityId)
	Payload.cnh = licenseCategories(Passport)
	Payload.vehicles = Vehicles
	return { validIdentity = true, identity = Payload }
end

function Server.getBodycamOfficers()
	local Officers = {}
	local Services = vRP.NumPermission("Policia")
	local myPassport = vRP.Passport(source)

	for Passport,TargetSource in pairs(Services or {}) do
		if TargetSource and TargetSource > 0 and parseInt(Passport) ~= parseInt(myPassport) then
			local Ped = GetPlayerPed(TargetSource)
			local Coords = Ped and GetEntityCoords(Ped) or vector3(0.0,0.0,0.0)
			Officers[#Officers + 1] = {
				id = parseInt(Passport),
				name = fullNameFromIdentity(Passport),
				phone = phone(nil,Passport),
				location = { x = Coords.x, y = Coords.y, z = Coords.z },
				timeInService = os.time()
			}
		end
	end

	return Officers
end

function Server.requestVideoPreview(officerId)
	return { success = false }
end

function Server.getWanteds()
	local Rows = query([[SELECT * FROM mdt_creative_wanted ORDER BY Timestamp DESC LIMIT 20]])
	local Wanteds = {}

	for _,Row in ipairs(Rows or {}) do
		Wanteds[#Wanteds + 1] = {
			id = parseInt(Row.Passport),
			name = fullNameFromIdentity(Row.Passport),
			image = Row.Image or ""
		}
	end


	return Wanteds
end