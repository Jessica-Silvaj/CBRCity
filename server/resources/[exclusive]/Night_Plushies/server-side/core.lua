-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Night = {}
Tunnel.bindInterface("Night_Plushies", Night)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
local DatabaseReady = false
local PlushieDuration = math.max(1,math.floor(tonumber(Config.ValidityDays) or 30)) * 86400

vRP.Prepare("plushies/Table", "CREATE TABLE IF NOT EXISTS night_plushies (id INT AUTO_INCREMENT PRIMARY KEY, Passport INT NOT NULL, Plushie VARCHAR(100) NOT NULL, ExpiresAt BIGINT UNSIGNED NOT NULL DEFAULT 0)")
vRP.Prepare("plushies/Migrate", "ALTER TABLE night_plushies ADD COLUMN IF NOT EXISTS ExpiresAt BIGINT UNSIGNED NOT NULL DEFAULT 0")
vRP.Prepare("plushies/InitializeExpiry",("UPDATE night_plushies SET ExpiresAt = UNIX_TIMESTAMP() + %d WHERE ExpiresAt = 0"):format(PlushieDuration))
vRP.Prepare("plushies/ActiveCopy","SELECT * FROM night_plushies WHERE Passport = @Passport AND Plushie = @Plushie AND ExpiresAt > UNIX_TIMESTAMP() ORDER BY ExpiresAt DESC LIMIT 1")
vRP.Prepare("plushies/OwnedById","SELECT * FROM night_plushies WHERE id = @id AND Passport = @Passport AND ExpiresAt > UNIX_TIMESTAMP() LIMIT 1")
vRP.Prepare("plushies/AddPlushie",("INSERT INTO night_plushies (Passport,Plushie,ExpiresAt) VALUES (@Passport,@Plushie,UNIX_TIMESTAMP() + %d)"):format(PlushieDuration))
vRP.Prepare("plushies/GetPlushies","SELECT * FROM night_plushies WHERE Passport = @Passport AND ExpiresAt > UNIX_TIMESTAMP()")
vRP.Prepare("plushies/GetTotalPlushies","SELECT COUNT(*) as amount FROM night_plushies WHERE Plushie = @Plushie AND ExpiresAt > UNIX_TIMESTAMP()")
vRP.Prepare("plushies/RemPlushie","DELETE FROM night_plushies WHERE Passport = @Passport AND Plushie = @Plushie LIMIT 1")
vRP.Prepare("plushies/TransferPlushie","UPDATE night_plushies SET Passport = @toPassport WHERE id = @id AND Passport = @fromPassport AND ExpiresAt > UNIX_TIMESTAMP()")
vRP.Prepare("plushies/CleanInvalid","DELETE FROM night_plushies WHERE Plushie = 'pokemon1'")

CreateThread(function()
	Wait(1000)
	local Success,Error = pcall(function()
		vRP.Query("plushies/Table",{})
		vRP.Query("plushies/Migrate",{})
		vRP.Query("plushies/InitializeExpiry",{})
	end)
	DatabaseReady = Success
	if not Success then
		print("[Night_Plushies] Falha ao preparar validade das pelúcias: "..tostring(Error))
		return
	end
	vRP.Query("plushies/CleanInvalid",{})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPER CLIENT TRIGGERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function SyncClientPlushies(src, data)
	TriggerClientEvent("Night_Plushies:syncPlushies", src, data)
end

local function CloseClientPlushies(src)
	TriggerClientEvent("Night_Plushies:close", src)
end

local function AttachClientProp(src, model, pos)
	TriggerClientEvent("Night_Plushies:attachProp", src, model, pos)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Actived = {}
local PendingWinners = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINPLUSHIE
-----------------------------------------------------------------------------------------------------------------------------------------
local function WinPlushieHandler(Plushie)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Actived[Passport] then
		if PendingWinners[Passport] and PendingWinners[Passport] == Plushie then
			vRP.Query("plushies/AddPlushie",{ Passport = Passport, Plushie = Plushie })
			TriggerClientEvent("Notify",source,"Coleção","Você recebeu uma pelúcia! Validade: <b>"..(Config.ValidityDays or 30).." dias</b>.","verde",5000)
			PendingWinners[Passport] = nil
		else
			print("^1[NIGHT-PLUSHIES] Jogador "..Passport.." tentou ganhar um item não sorteado: "..tostring(Plushie).."^7")
		end

		Actived[Passport] = nil
	end
end

RegisterServerEvent("Night_Plushies:winPlushie")
AddEventHandler("Night_Plushies:winPlushie", WinPlushieHandler)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLUSHIES
-----------------------------------------------------------------------------------------------------------------------------------------
function Night.getPlushies()
	if not DatabaseReady then return {} end
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.Query("plushies/GetPlushies",{ Passport = Passport })
		local filtered = {}
		for _, v in ipairs(Consult or {}) do
			if v.Plushie ~= "pokemon1" and CollectionsCatalog and CollectionsCatalog[v.Plushie] and not CollectionsCatalog[v.Plushie].hidden then
				table.insert(filtered, v)
			end
		end
		return filtered
	end

	return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTOTALPLUSHIES
-----------------------------------------------------------------------------------------------------------------------------------------
function Night.getTotalPlushies(plushieId)
	if not DatabaseReady then return 0 end
	local consult = vRP.Query("plushies/GetTotalPlushies", { Plushie = plushieId })
	if consult and consult[1] then
		return consult[1].amount or 0
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATA
-----------------------------------------------------------------------------------------------------------------------------------------
function Night.getData()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Identity = vRP.Identity(Passport)
		if Identity then
			return {
				gems = vRP.UserGemstone(Identity.License) or 0,
				price = (Config and Config.RoulettePrice) or 250
			}
		end
	end

	return { gems = 0, price = 250 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPINROULETTE
-----------------------------------------------------------------------------------------------------------------------------------------
function Night.spinRoulette()
	if not DatabaseReady then return { success = false } end
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Actived[Passport] then
		local price = (Config and Config.RoulettePrice) or 250
		
		if vRP.PaymentGems(Passport, price) then
			Actived[Passport] = true

			local rand = math.random(100)
			local chosenRarity = "common"
			local currentPercent = 0

			local rates = (Config and Config.RarityRates) or {
				["common"] = 70,
				["rare"] = 20,
				["epic"] = 8,
				["legendary"] = 2
			}

			local rarities = { "legendary", "epic", "rare", "common" }
			for _, rarity in ipairs(rarities) do
				local chance = rates[rarity] or 0
				if rand <= (currentPercent + chance) then
					chosenRarity = rarity
					break
				end

				currentPercent = currentPercent + chance
			end

			local possibleItems = {}
			local catalog = CollectionsCatalog or {}
			for id, item in pairs(catalog) do
				if (item.rarity or "common") == chosenRarity and not item.hidden then
					table.insert(possibleItems, id)
				end
			end

			if #possibleItems == 0 then
				for id, item in pairs(catalog) do
					if not item.hidden then
						table.insert(possibleItems, id)
					end
				end
			end

			local winnerId = possibleItems[math.random(#possibleItems)]
			local winnerData = catalog[winnerId]

			if winnerData then
				PendingWinners[Passport] = winnerId

				return {
					success = true,
					winner = {
						id = winnerId,
						name = winnerData.name,
						rarity = winnerData.rarity or "common"
					}
				}
			end
		end
	end

	return { success = false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EQUIPPLUSHIE
-----------------------------------------------------------------------------------------------------------------------------------------
local EquippedPlushies = {}

local function RefreshEquipped(Source,Passport)
	local Current = EquippedPlushies[Passport]
	if not DatabaseReady or not Current or not next(Current) then return end
	local Valid = {}
	for _,Row in ipairs(vRP.Query("plushies/GetPlushies",{ Passport = Passport }) or {}) do
		Valid[Row.Plushie] = math.max(Valid[Row.Plushie] or 0,tonumber(Row.ExpiresAt) or 0)
	end
	local Changed,Removed = false,false
	for Slot,Data in pairs(Current) do
		local Catalog = CollectionsCatalog[Data.id]
		if not Valid[Data.id] or not Catalog or Catalog.hidden then
			Current[Slot] = nil
			Changed,Removed = true,true
		elseif Data.expiresAt ~= Valid[Data.id] then
			Data.expiresAt = Valid[Data.id]
			Changed = true
		end
	end
	if Changed then
		local _,First = next(Current)
		Player(Source).state:set("plushies",Current,true)
		Player(Source).state:set("plushie",First or { id = "none" },true)
		Player(Source).state:set("plushieEquipped",next(Current) ~= nil,true)
		SyncClientPlushies(Source,Current)
		if Removed then
			TriggerClientEvent("Notify",Source,"Coleção","Uma pelúcia venceu ou deixou de estar disponível e foi desequipada.","amarelo",5000)
		end
	end
end

CreateThread(function()
	while true do
		Wait(1000)
		if DatabaseReady then
			for Passport,Current in pairs(EquippedPlushies) do
				local Source = vRP.Source(Passport)
				if not Source then
					EquippedPlushies[Passport] = nil
				else
					for _,Data in pairs(Current) do
						if (tonumber(Data.expiresAt) or 0) <= os.time() then
							RefreshEquipped(Source,Passport)
							break
						end
					end
				end
			end
		end
	end
end)

AddEventHandler("Disconnect",function(Passport)
	EquippedPlushies[Passport] = nil
end)

function Night.equipPlushie(plushieId, position)
	if not DatabaseReady then return end
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		-- Verificação de Reintegração
		local rData = vRP.GetServerData("Reintegracao:"..Passport)
		local expireTime = 0
		if type(rData) ~= "table" then expireTime = tonumber(rData) or 0 end
		if os.time() < expireTime then
			TriggerClientEvent("Notify", source, "Aviso", "Você está em período de reintegração e não pode remover a pelúcia!", "amarelo", 5000)
			return
		end

		EquippedPlushies[Passport] = EquippedPlushies[Passport] or {}

		-- Desequipar TUDO
		if not plushieId or plushieId == "none" or plushieId == "" then
			EquippedPlushies[Passport] = {}
			Player(source).state:set("plushies", {}, true)
			Player(source).state:set("plushie", { id = "none" }, true)
			Player(source).state:set("plushieEquipped", false, true)
			SyncClientPlushies(source, {})
			TriggerClientEvent("Notify", source, "Sucesso", "Você desequipou todas as pelúcias!", "verde", 5000)
			return
		end

		local plushieData = CollectionsCatalog[plushieId]
		if not plushieData or plushieData.hidden then
			TriggerClientEvent("Notify", source, "Negado", "Esta pelúcia não pode ser equipada.", "vermelho", 5000)
			return
		end

		local slot = GetPlushieSlot(plushieId, position)

		-- Desequipar item específico
		if position == "unequip" or position == "desequipar" then
			for s, data in pairs(EquippedPlushies[Passport]) do
				if data.id == plushieId then
					EquippedPlushies[Passport][s] = nil
				end
			end

			Player(source).state:set("plushies", EquippedPlushies[Passport], true)
			Player(source).state:set("plushieEquipped", next(EquippedPlushies[Passport]) ~= nil, true)
			SyncClientPlushies(source, EquippedPlushies[Passport])
			TriggerClientEvent("Notify", source, "Sucesso", "Você desequipou a pelúcia!", "verde", 5000)
			return
		end

		-- Toggle: se clicar na mesma pelúcia e mesma posição/slot que já está equipada, desequipa
		if EquippedPlushies[Passport][slot] and EquippedPlushies[Passport][slot].id == plushieId and (EquippedPlushies[Passport][slot].position == position or (not position and not EquippedPlushies[Passport][slot].position)) then
			EquippedPlushies[Passport][slot] = nil
			Player(source).state:set("plushies", EquippedPlushies[Passport], true)
			Player(source).state:set("plushieEquipped", next(EquippedPlushies[Passport]) ~= nil, true)
			SyncClientPlushies(source, EquippedPlushies[Passport])
			TriggerClientEvent("Notify", source, "Sucesso", "Você desequipou a pelúcia!", "verde", 5000)
			return
		end

		local Owned = vRP.Query("plushies/ActiveCopy",{ Passport = Passport, Plushie = plushieId })
		local Copy = Owned and Owned[1]
		if not Copy then
			RefreshEquipped(source,Passport)
			TriggerClientEvent("Notify",source,"Coleção","Você não possui uma pelúcia válida deste tipo. A validade é de 30 dias após receber.","amarelo",5000)
			return
		end

		-- Garante que a mesma pelúcia não fique duplicada em outro slot diferente
		for s, data in pairs(EquippedPlushies[Passport]) do
			if data.id == plushieId then
				EquippedPlushies[Passport][s] = nil
			end
		end

		-- Equipa a pelúcia no slot correspondente
		EquippedPlushies[Passport][slot] = {
			id = plushieId,
			position = position,
			slot = slot,
			expiresAt = tonumber(Copy.ExpiresAt),
			bonus = Config.Bonification and plushieData.bonus or nil
		}

		Player(source).state:set("plushies", EquippedPlushies[Passport], true)
		Player(source).state:set("plushie", EquippedPlushies[Passport][slot], true)
		Player(source).state:set("plushieEquipped", true, true)

		SyncClientPlushies(source, EquippedPlushies[Passport])
		TriggerClientEvent("Notify", source, "Sucesso", "Você equipou a pelúcia!", "verde", 5000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return end

	local players = GetPlayers()
	for _, source in ipairs(players) do
		Player(source).state:set("plushies", {}, true)
		Player(source).state:set("plushie", { id = "none" }, true)
		Player(source).state:set("plushieEquipped", false, true)
		SyncClientPlushies(source, {})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("getPlushieBonus", function(source, bonusType)
	if not DatabaseReady or not Config.Bonification then return 0 end
	local Passport = vRP.Passport(source)
	if not Passport then return 0 end
	RefreshEquipped(source,Passport)
	local Total = 0
	for _,Data in pairs(EquippedPlushies[Passport] or {}) do
		local Catalog = CollectionsCatalog[Data.id]
		if (tonumber(Data.expiresAt) or 0) > os.time() and Catalog and not Catalog.hidden and Catalog.bonus then
			Total = Total + (tonumber(Catalog.bonus[bonusType]) or 0)
		end
	end
	return Total
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERPLUSHIE
-----------------------------------------------------------------------------------------------------------------------------------------
function Night.transferPlushie(plushieId)
	if not DatabaseReady then return end
	plushieId = tonumber(plushieId)
	if not plushieId then return end
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Owned = vRP.Query("plushies/OwnedById",{ id = plushieId, Passport = Passport })
		if not Owned or not Owned[1] then
			TriggerClientEvent("Notify",source,"Coleção","Esta pelúcia venceu ou não pertence a você.","amarelo",5000)
			return
		end
		local Keyboard = vKEYBOARD.Primary(source, "Passaporte")
		if Keyboard then
			local otherPassport = parseInt(Keyboard[1])
			if otherPassport > 0 and otherPassport ~= Passport then
				local otherSource = vRP.Source(otherPassport)
				if otherSource then
					local identity = vRP.Identity(Passport)
					local otherIdentity = vRP.Identity(otherPassport)
					
					if identity and otherIdentity then
						local senderName = (identity.name or identity.Name or "Desconhecido") .. " " .. (identity.name2 or identity.Lastname or "")
						if vRP.Request(otherSource, "Transferência de Pelúcia", "Você deseja aceitar a pelúcia de <b>" .. senderName .. "</b>?") then
							local consult = exports.oxmysql:update_async("UPDATE night_plushies SET Passport = ? WHERE id = ? AND Passport = ? AND ExpiresAt > UNIX_TIMESTAMP()",{ otherPassport,plushieId,Passport })
							
							if tonumber(consult) and tonumber(consult) > 0 then
								RefreshEquipped(source,Passport)
								TriggerClientEvent("Notify", source, "Sucesso", "Pelúcia transferida com sucesso!", "verde", 5000)
								TriggerClientEvent("Notify", otherSource, "Sucesso", "Você recebeu uma nova pelúcia!", "verde", 5000)
								CloseClientPlushies(source)
							else
								TriggerClientEvent("Notify", source, "Erro", "Não foi possível transferir a pelúcia.", "vermelho", 5000)
							end
						else
							TriggerClientEvent("Notify", source, "Aviso", "A transferência foi recusada.", "amarelo", 5000)
						end
					else
						TriggerClientEvent("Notify", source, "Erro", "Identidade não encontrada.", "vermelho", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "Erro", "O destinatário precisa estar online para aceitar.", "vermelho", 5000)
				end
			else
				TriggerClientEvent("Notify", source, "Erro", "Passaporte inválido ou você não pode transferir para si mesmo.", "vermelho", 5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND: DAR TODOS OS PETS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("giveallpets", function(source, args, rawCommand)
	if not DatabaseReady then return end
    local Passport = vRP.Passport(source)
    if Passport then
        -- Verifica se o jogador tem permissão de Admin (Mude "Admin" se a sua permissão for diferente)
        if vRP.HasPermission(Passport, "Admin") or vRP.HasPermission(Passport, "admin") then
            
            -- Se digitar /giveallpets [ID], vai para o ID. Se digitar só /giveallpets, vai para quem digitou.
            local TargetPassport = parseInt(args[1])
            if TargetPassport == 0 or not TargetPassport then
                TargetPassport = Passport
            end

            local count = 0

            -- Faz um loop por toda a lista de pets configurada no seu arquivo shared/client
            for petId, petData in pairs(CollectionsCatalog) do
                if petId ~= "pokemon1" and not petData.hidden then
                    vRP.Query("plushies/AddPlushie", { Passport = TargetPassport, Plushie = petId })
                    count = count + 1
                end
            end

            -- Notifica quem usou o comando
            TriggerClientEvent("Notify", source, "Sucesso", "Você enviou <b>"..count.."</b> pets para o Passaporte <b>"..TargetPassport.."</b>.", "verde", 5000)
            
            -- Opcional: Notifica o jogador que recebeu (caso não seja a mesma pessoa)
            if TargetPassport ~= Passport then
                local TargetSource = vRP.Source(TargetPassport)
                if TargetSource then
                    TriggerClientEvent("Notify", TargetSource, "Importante", "Você recebeu todos os pets da coleção da administração!", "azul", 5000)
                end
            end
        else
            TriggerClientEvent("Notify", source, "Negado", "Você não tem permissão para usar este comando.", "vermelho", 5000)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REINTEGRACAO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("reintegrar", function(source, args, rawCommand)
	local source = source
	local Passport = vRP.Passport(source)
	
	if Passport and (vRP.HasGroup(Passport, "Admin") or vRP.HasGroup(Passport, "Moderador") or vRP.HasGroup(Passport, "Suporte")) then
		local targetPassport = parseInt(args[1])
		local days = parseInt(args[2])

		if targetPassport > 0 and days > 0 then
			local expireTime = os.time() + (days * 24 * 60 * 60)
			vRP.SetServerData("Reintegracao:"..targetPassport, expireTime)

			TriggerClientEvent("Notify", source, "Sucesso", "Passaporte <b>"..targetPassport.."</b> colocado em reintegração por "..days.." dias.", "verde", 5000)

			-- Se ele estiver online, força a pelúcia agora
			local targetSource = vRP.Source(targetPassport)
			if targetSource then
				TriggerClientEvent("Notify", targetSource, "Aviso", "Você foi colocado em reintegração e recebeu uma marcação temporária.", "amarelo", 10000)
				-- Força equipar (pode precisar do position, se não tiver usa nil)
				local plushieData = CollectionsCatalog and CollectionsCatalog["pokemon1"]
				if plushieData then
					Player(targetSource).state:set("plushie", { id = "pokemon1", position = nil }, true)
					Player(targetSource).state:set("plushieEquipped", true, true)
				end
				AttachClientProp(targetSource, "pokemon1", nil)
			end
		else
			TriggerClientEvent("Notify", source, "Aviso", "Uso correto: /reintegrar [passaporte] [dias]", "amarelo", 5000)
		end
	end
end)

RegisterCommand("removerreintegracao", function(source, args, rawCommand)
	local source = source
	local Passport = vRP.Passport(source)
	
	if Passport and (vRP.HasGroup(Passport, "Admin") or vRP.HasGroup(Passport, "Moderador")) then
		local targetPassport = parseInt(args[1])

		if targetPassport > 0 then
			vRP.RemoveServerData("Reintegracao:"..targetPassport)
			TriggerClientEvent("Notify", source, "Sucesso", "Reintegração do passaporte <b>"..targetPassport.."</b> removida.", "verde", 5000)

			local targetSource = vRP.Source(targetPassport)
			if targetSource then
				Player(targetSource).state:set("plushie", { id = "none" }, true)
				Player(targetSource).state:set("plushieEquipped", false, true)
				AttachClientProp(targetSource, "none")
				TriggerClientEvent("Notify", targetSource, "Sucesso", "Seu período de reintegração acabou.", "verde", 5000)
			end
		else
			TriggerClientEvent("Notify", source, "Aviso", "Uso correto: /removerreintegracao [passaporte]", "amarelo", 5000)
		end
	end
end)

AddEventHandler("Connect", function(Passport, source)
	local rData = vRP.GetServerData("Reintegracao:"..Passport)
	local expireTime = 0
	if type(rData) ~= "table" then expireTime = tonumber(rData) or 0 end
	if expireTime > os.time() then
		local src = vRP.Source(Passport)
		if src then
			TriggerClientEvent("Notify", src, "Aviso", "Você ainda está em período de reintegração.", "amarelo", 10000)
			local plushieData = CollectionsCatalog and CollectionsCatalog["pokemon1"]
			if plushieData then
				Player(src).state:set("plushie", { id = "pokemon1", position = nil }, true)
				Player(src).state:set("plushieEquipped", true, true)
			end
			AttachClientProp(src, "pokemon1", nil)
		end
	elseif expireTime > 0 and expireTime <= os.time() then
		vRP.RemoveServerData("Reintegracao:"..Passport)
	end
end)
