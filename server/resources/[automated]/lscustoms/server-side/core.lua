-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("lscustoms",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Networked = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Index)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or exports.bank:CheckTaxes(Passport) or exports.bank:CheckFines(Passport) then
		return false
	end

	local Location = Locations[Index]
	if not Location then
		return false
	end

	if Location.Permission and not vRP.HasService(Passport,Location.Permission) then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Save(Model,Plate,Initial)
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Price = Calculate(Initial,Model)
	if Price > 0 and not vRP.PaymentFull(Passport,Price,true) then
		return false
	end

	local OtherPassport = vRP.PassportPlate(Plate)
	if OtherPassport then
		local Name = OtherPassport..":"..Model
		local Consult = vRP.GetSrvData("LsCustoms:"..Name,true)
		for Index,v in pairs(Initial) do
			if Index == "VehicleExtras" then
				for Type,Data in pairs(v) do
					if Data.Installed ~= Data.Selected then
						Consult.VehicleExtras = Consult.VehicleExtras or {}
						Consult.VehicleExtras[Type] = Data.Selected
					end
				end
			elseif Index == "Respray" then
				Consult.Respray = {
					PrimaryColour = {
						Type = v.PrimaryColour.Selected.Type,
						Color = v.PrimaryColour.Selected.Color
					},
					SecondaryColour = {
						Type = v.SecondaryColour.Selected.Type,
						Color = v.SecondaryColour.Selected.Color
					},
					PearlescentColour = v.PearlescentColour.Selected,
					WheelColour = v.WheelColour.Selected,
					DashboardColour = v.DashboardColour.Selected,
					InteriorColour = v.InteriorColour.Selected
				}
			elseif Index == "Wheels" then
				for Type,Data in pairs(v) do
					if Data.Installed ~= Data.Selected then
						if Consult[Index] then
							if Type == "TyreSmoke" then
								Consult[Index].TyreSmoke = Initial[Index].TyreSmoke.Selected
							elseif Type == "CustomTyres" then
								Consult[Index].CustomTyres = Initial[Index].CustomTyres.Selected
							else
								Consult[Index].Category = Type
								Consult[Index].Value = Data.Selected
							end
						else
							if Type == "TyreSmoke" then
								Consult[Index] = {
									TyreSmoke = Initial[Index].TyreSmoke.Selected
								}
							elseif Type == "CustomTyres" then
								Consult[Index] = {
									CustomTyres = Initial[Index].CustomTyres.Selected
								}
							else
								Consult[Index] = {
									Category = Type,
									Value = Data.Selected
								}
							end
						end
					end
				end
			elseif v.Installed ~= v.Selected then
				Consult[Index] = v.Selected
			end
		end

		vRP.SetSrvData("LsCustoms:"..Name,Consult,true)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LSCUSTOMS:NETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:Network")
AddEventHandler("lscustoms:Network",function(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if Network then
		Networked[Passport] = { Network,Plate }
	else
		Networked[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if not Networked[Passport] then
		return false
	end

	SetTimeout(2500,function()
		local Network,Plate = table.unpack(Networked[Passport])
		TriggerEvent("garages:Deleted",Network,Plate)
		Networked[Passport] = nil
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Management:requestLscustoms")
AddEventHandler("Night_Management:requestLscustoms", function()
    local source = source
    if source ~= "" and source ~= nil then return end
    TriggerEvent("lscustoms:reloadLocations")
end)

RegisterServerEvent("lscustoms:requestLocations")
AddEventHandler("lscustoms:requestLocations", function()
    local source = source
    TriggerClientEvent("lscustoms:receiveLocations", source, Locations)
end)

AddEventHandler("lscustoms:reloadLocations", function()
    Locations = {}
    local query = exports.oxmysql:executeSync("SELECT * FROM lscustoms")
    if query then
        for _,v in pairs(query) do
            Locations[v.id] = {
                Logo = v.Logo ~= "" and v.Logo or "lscustoms.png",
                Permission = (v.Permission and v.Permission ~= "") and v.Permission or nil,
                Coords = vec4(v.X, v.Y, v.Z, v.H or 0.0)
            }
        end
    end
    TriggerClientEvent("lscustoms:receiveLocations", -1, Locations)
end)