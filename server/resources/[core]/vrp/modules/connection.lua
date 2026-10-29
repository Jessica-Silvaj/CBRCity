-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(Reason)
	Disconnect(source,Reason)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Disconnect(source,Reason)
	local Armour = 0
	local Health = 100
	local Coords = SpawnCoords[1]
	local Ped = GetPlayerPed(source)

	if DoesEntityExist(Ped) then
		Armour = GetPedArmour(Ped)
		Health = GetEntityHealth(Ped)
		Coords = GetEntityCoords(Ped)
	end

	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Datatable = vRP.Datatable(Passport)
	if not Datatable then
		return false
	end

	if Arena[Passport] then
		Datatable.Pos = Arena[Passport].Pos
		Datatable.Stress = Arena[Passport].Stress
		Datatable.Hunger = Arena[Passport].Hunger
		Datatable.Thirst = Arena[Passport].Thirst
		Datatable.Armour = Arena[Passport].Armour
		Datatable.Health = Arena[Passport].Health
		Datatable.Inventory = Arena[Passport].Inventory

		local Route = Arena[Passport].Route
		GlobalState["Arena:"..Route] = GlobalState["Arena:"..Route] - 1
		Arena[Passport] = nil
	else
		Datatable.Armour = Armour
		Datatable.Health = Health
		Datatable.Pos = Coords
	end
	
	if DisconnectReason then
		exports.chat:Postit(Passport,Coords,Reason,DisconnectReason)
	end

	local License = vRP.Identities(source)
	TriggerEvent("Disconnect",Passport,source,License)
	vRP.Query("characters/LastLogin",{ Passport = Passport })
	vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Datatable", Information = json.encode(Datatable) })
	exports["discord"]:Embed("Disconnect","**[SOURCE]:** "..source.."\n**[PASSAPORTE]:** "..Passport.."\n**[VIDA]:** "..Datatable.Health.."\n**[COLETE]:** "..Datatable.Armour.."\n**[COORDS]:** "..Datatable.Pos.."\n**[MOTIVO]:** "..Reason)

	if Characters[source] then
		Characters[source] = nil
	end

	if Sources[Passport] then
		Sources[Passport] = nil
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnecting",function(_,__,deferrals)
    deferrals.defer()

    local Source = source
    local License = vRP.Identities(Source)

    if not License then
		return deferrals.update("Não foi possível efetuar conexão com a "..(BaseMode == "steam" and "Steam" or "Rockstar")..".")
    end

    local Account = vRP.Account(License) or ( vRP.Query("accounts/NewAccount", { License = License, Token = vRP.GenerateToken() }) and vRP.Account(License) )

	if Account then
		if Maintenance then
			if Maintenance[License] then
				deferrals.done()
			else
				return deferrals.update("O servidor encontra-se em manutenção.\nPara mais informações, acesse: "..ServerLink)
			end
		end
	end

    if not Account then
		return deferrals.update("Não foi possível efetuar conexão com a " ..(BaseMode == "steam" and "Steam" or "Rockstar") .. ".")
    end

	local BannedStatus = vRP.Banned(Source,Account)
	if BannedStatus and (Account.Banned == -1 or (not Banned.Enter and Account.Banned > 0)) then
		if type(BannedStatus) == "table" and BannedStatus[1] == "Other" then
			return deferrals.update("Banido | "..BannedStatus[2].."\nInformamos que o motivo do seu banimento são por questões unilaterais, ou seja, onde outra pessoa da sua rede ou seu computador e periféricos comprometeu a sua conexão por completo devido a uma punição, fazendo assim com que a nossa equipe de administração não tenha qualquer tipo de ação nesse caso.")
		else
			return deferrals.update("Consequência: Banido\nTempo: "..(Account.Banned == -1 and "Permanente" or Account.Banned .. " minutos").."\nMotivo: "..(Account.Reason or "Banimento administrativo"))
		end
	end

	if Whitelisted and not Account.Whitelist then
		return deferrals.update("Efetue sua liberação através do discord enviando "..Account[Liberation].."\nAcesse através do link: "..ServerLink.."")
	end

	vRP.Query("accounts/LastLogin",{ License = License })
	deferrals.done()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CharacterChosen(source,Passport,Model)
	Sources[Passport] = source

	if not Characters[source] then
		vRP.Query("characters/LastLogin",{ Passport = Passport })

		local License = vRP.Identities(source)
		local Account = vRP.Account(License)
		local Character = vRP.SingleQuery("characters/Person",{ Passport = Passport })

		Characters[source] = { Datatable = vRP.UserData(Passport,"Datatable") }

		for Index,v in pairs(Account) do
			Characters[source][Index] = v
		end

		for Index,v in pairs(Character) do
			Characters[source][Index] = v
		end

		-- Colunas BIGINT podem vir do banco como texto; os saldos são comparados com números (PaymentBank etc.)
		for _,Index in ipairs({ "Bank","Gemstone" }) do
			Characters[source][Index] = tonumber(Characters[source][Index]) or 0
		end

		if Model then
			Characters[source].Datatable.Inventory = {}

			for Item,Amount in pairs(CharacterItens) do
				vRP.GenerateItem(Passport,Item,Amount,false)
			end

			local Table = {
				{ Name = "Barbershop", Information = json.encode(BarbershopInit[Model]) },
				{ Name = "Clothings", Information = json.encode(SkinshopInit[Model]) },
				{ Name = "Tattooshop", Information = json.encode({}) },
				{ Name = "Datatable", Information = json.encode({}) }
			}

			for _,v in ipairs(Table) do
				vRP.Query("playerdata/SetData",{ Passport = Passport, Name = v.Name, Information = v.Information })
			end
		end

		local Gemstone = tonumber(Account.Gemstone) or 0
		if Gemstone > 0 then
			TriggerClientEvent("hud:AddGemstone",source,Gemstone)
		end

		exports["discord"]:Embed("Connect","**[SOURCE]:** "..source.."\n**[PASSAPORTE]:** "..Passport.."\n**[ADDRESS]:** "..GetPlayerEndpoint(source).."\n**[LICENSE]:** "..Account.License.."\n**[discord:** <@"..Account.Discord..">")

		if DiscordBot then
			exports["discord"]:Content("Rename",Account.Discord.." #"..Passport.." "..Character.Name.." "..Character.Lastname)
		end

		TriggerEvent("CharacterChosen",Passport,source,Model ~= nil)
	else
		DropPlayer(source,"Desconectado")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Archive(Archive,Text)
	local Message = LoadResourceFile("archives",Archive)
	SaveResourceFile("archives",Archive,(Message or "")..Text.."\n",-1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Kick(source,Reason)
	if Disconnect(source,Reason) then
		DropPlayer(source,Reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REJOINPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RejoinPlayer(source)
	Disconnect(source, "Troca de Personagem")
end