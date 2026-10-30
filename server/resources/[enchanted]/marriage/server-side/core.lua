-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Steps = {
	["namoro"] = { Previous = false, Label = "namorar", Title = "Namoro", Boxes = { { Box = "datingbox", Ring = "datingring" } } },
	["noivado"] = { Previous = "namoro", Label = "noivar", Title = "Noivado", Boxes = { { Box = "engagementbox", Ring = "engagementring" } } },
	["casamento"] = { Previous = "noivado", Label = "casar", Title = "Casamento", Boxes = { { Box = "alliance3", Ring = "alliance2" }, { Box = "weddingbox", Ring = "weddingring" } } }
}

local NextStep = {
	["none"] = "namoro",
	["namoro"] = "noivado",
	["noivado"] = "casamento"
}

-- Alianças com nome geradas pelo sistema antigo, migradas como casamento no login
local Legacy = { ["alliance"] = true, ["alliance2"] = true }
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Busy = {}
local MaxDistance = 3.0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATABASE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	exports.oxmysql:query_async([[
		CREATE TABLE IF NOT EXISTS `relationships` (
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`Passport1` int(11) NOT NULL,
			`Passport2` int(11) NOT NULL,
			`Status` varchar(20) NOT NULL DEFAULT 'namoro',
			`Ring` varchar(50) NOT NULL,
			`Created` timestamp NOT NULL DEFAULT current_timestamp(),
			PRIMARY KEY (`id`),
			UNIQUE KEY `Passport1` (`Passport1`),
			UNIQUE KEY `Passport2` (`Passport2`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
	]])

	exports.oxmysql:query_async([[
		CREATE TABLE IF NOT EXISTS `relationships_removals` (
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`Passport` int(11) NOT NULL,
			`Item` varchar(100) NOT NULL,
			PRIMARY KEY (`id`),
			KEY `Passport` (`Passport`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
	]])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETRELATIONSHIP
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetRelationship(Passport)
	local Consult = exports.oxmysql:single_async("SELECT * FROM relationships WHERE Passport1 = ? OR Passport2 = ? LIMIT 1",{ Passport,Passport })
	if Consult then
		Consult.Partner = (Consult.Passport1 == Passport) and Consult.Passport2 or Consult.Passport1
	end

	return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVERING
-----------------------------------------------------------------------------------------------------------------------------------------
local function RemoveRing(Passport,Ring,Partner)
	if not Ring then
		return
	end

	local Item = Ring.."-"..Partner
	if vRP.Source(Passport) then
		vRP.TakeItem(Passport,Item,1,true)
	else
		-- Offline: o anel é retirado quando a pessoa entrar
		exports.oxmysql:insert_async("INSERT INTO relationships_removals (Passport,Item) VALUES (?,?)",{ Passport,Item })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARBY
-----------------------------------------------------------------------------------------------------------------------------------------
local function Nearby(source,OtherSource)
	local Ped = GetPlayerPed(source)
	local OtherPed = GetPlayerPed(OtherSource)
	if Ped == 0 or OtherPed == 0 then
		return false
	end

	return #(GetEntityCoords(Ped) - GetEntityCoords(OtherPed)) <= MaxDistance
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINDBOX
-----------------------------------------------------------------------------------------------------------------------------------------
local function FindBox(Passport,Step)
	for _,v in ipairs(Steps[Step].Boxes) do
		if vRP.ItemAmount(Passport,v.Box) >= 1 then
			return v
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARRIAGE:REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("marriage:Request")
AddEventHandler("marriage:Request",function(OtherSource)
	local source = source
	local OtherSource = parseInt(OtherSource)
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(OtherSource)
	if not Passport or not OtherPassport or Passport == OtherPassport or Busy[Passport] or Busy[OtherPassport] then
		return false
	end

	if not Nearby(source,OtherSource) then
		TriggerClientEvent("Notify",source,"Relacionamento","Chegue mais perto da pessoa.","amarelo",5000)
		return false
	end

	local Identity = vRP.Identity(Passport)
	local OtherIdentity = vRP.Identity(OtherPassport)
	if not Identity or not OtherIdentity then
		return false
	end

	local Relationship = GetRelationship(Passport)
	local OtherRelationship = GetRelationship(OtherPassport)

	if Relationship and Relationship.Partner ~= OtherPassport then
		TriggerClientEvent("Notify",source,"Relacionamento","Você já está em um relacionamento.","amarelo",5000)
		return false
	end

	if OtherRelationship and OtherRelationship.Partner ~= Passport then
		TriggerClientEvent("Notify",source,"Relacionamento","Essa pessoa já está em um relacionamento.","amarelo",5000)
		return false
	end

	local Step = NextStep[Relationship and Relationship.Status or "none"]
	if not Step then
		TriggerClientEvent("Notify",source,"Relacionamento","Vocês já são casados.","amarelo",5000)
		return false
	end

	local Selected = FindBox(Passport,Step)
	if not Selected then
		TriggerClientEvent("Notify",source,"Relacionamento","Para "..Steps[Step].Label.." você precisa de <b>"..exports.vrp:ItemName(Steps[Step].Boxes[#Steps[Step].Boxes].Box).."</b>, à venda na <b>Joalheria</b>.","amarelo",8000)
		return false
	end

	Busy[Passport] = true
	Busy[OtherPassport] = true

	vRPC.playAnim(source,false,{"amb@medic@standing@kneel@idle_a","idle_a"},true)
	vRPC.CreateObjects(source,"ultra@propose","propose","ultra_ringcase",49,28422,0.08,0.01,-0.055,0.0,180.0,-90.0)

	local FullName = (Identity.Name.." "..Identity.Lastname)
	local OtherFullName = (OtherIdentity.Name.." "..OtherIdentity.Lastname)
	local Accepted = vRP.Request(OtherSource,Steps[Step].Title,"<b>"..FullName.."</b> está pedindo para "..Steps[Step].Label.." com você. Aceitar?")

	vRPC.Destroy(source)
	Busy[Passport] = nil
	Busy[OtherPassport] = nil

	if not Accepted then
		TriggerClientEvent("marriage:Reject",source,OtherFullName)
		return false
	end

	-- Revalida tudo depois da resposta, pois o pedido pode ficar aberto por alguns segundos
	Relationship = GetRelationship(Passport)
	OtherRelationship = GetRelationship(OtherPassport)
	if (Relationship and Relationship.Partner ~= OtherPassport) or (OtherRelationship and OtherRelationship.Partner ~= Passport) or NextStep[Relationship and Relationship.Status or "none"] ~= Step then
		return false
	end

	if not vRP.Source(OtherPassport) or not Nearby(source,OtherSource) then
		TriggerClientEvent("Notify",source,"Relacionamento","A pessoa se afastou.","amarelo",5000)
		return false
	end

	if not vRP.TakeItem(Passport,Selected.Box,1,true) then
		TriggerClientEvent("Notify",source,"Relacionamento","Você não possui mais <b>"..exports.vrp:ItemName(Selected.Box).."</b>.","amarelo",5000)
		return false
	end

	if Relationship then
		RemoveRing(Passport,Relationship.Ring,OtherPassport)
		RemoveRing(OtherPassport,Relationship.Ring,Passport)
		exports.oxmysql:update_async("UPDATE relationships SET Status = ?, Ring = ? WHERE id = ?",{ Step,Selected.Ring,Relationship.id })
	else
		exports.oxmysql:insert_async("INSERT INTO relationships (Passport1,Passport2,Status,Ring) VALUES (?,?,?,?)",{ math.min(Passport,OtherPassport),math.max(Passport,OtherPassport),Step,Selected.Ring })
	end

	vRP.GenerateItem(Passport,Selected.Ring.."-"..OtherPassport,1,true)
	vRP.GenerateItem(OtherPassport,Selected.Ring.."-"..Passport,1,true)

	TriggerClientEvent("marriage:Accept",OtherSource,FullName)
	TriggerClientEvent("marriage:Accept",source,OtherFullName)

	if Step == "casamento" then
		TriggerClientEvent("Notify",-1,"Casamento","<b>"..FullName.."</b> e <b>"..OtherFullName.."</b> acabaram de se casar! 💍","verde",10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TERMINAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("terminar",function(source)
	local Passport = vRP.Passport(source)
	if not Passport or Busy[Passport] then
		return false
	end

	local Relationship = GetRelationship(Passport)
	if not Relationship then
		TriggerClientEvent("Notify",source,"Relacionamento","Você não está em um relacionamento.","amarelo",5000)
		return false
	end

	local PartnerName = vRP.FullName(Relationship.Partner) or "seu par"
	Busy[Passport] = true
	local Confirm = vRP.Request(source,"Relacionamento","Deseja terminar o "..Relationship.Status.." com <b>"..PartnerName.."</b>?")
	Busy[Passport] = nil
	if not Confirm then
		return false
	end

	exports.oxmysql:query_async("DELETE FROM relationships WHERE id = ?",{ Relationship.id })

	RemoveRing(Passport,Relationship.Ring,Relationship.Partner)
	RemoveRing(Relationship.Partner,Relationship.Ring,Passport)

	TriggerClientEvent("Notify",source,"Relacionamento","Você terminou com <b>"..PartnerName.."</b>.","amarelo",5000)

	local PartnerSource = vRP.Source(Relationship.Partner)
	if PartnerSource then
		TriggerClientEvent("Notify",PartnerSource,"Relacionamento","<b>"..vRP.FullName(Passport).."</b> terminou com você.","vermelho",8000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport)
	-- Anéis de relacionamentos terminados enquanto a pessoa estava offline
	local Removals = exports.oxmysql:query_async("SELECT * FROM relationships_removals WHERE Passport = ?",{ Passport })
	for _,v in ipairs(Removals or {}) do
		vRP.TakeItem(Passport,v.Item,1)
		exports.oxmysql:query_async("DELETE FROM relationships_removals WHERE id = ?",{ v.id })
	end

	if GetRelationship(Passport) then
		return
	end

	-- Casais do sistema antigo (só as alianças, sem registro) viram casamento
	local Inventory = vRP.Inventory(Passport) or {}
	for _,v in pairs(Inventory) do
		local Split = splitString(v.item)
		local Partner = parseInt(Split[2])
		if Legacy[Split[1]] and Partner > 0 and Partner ~= Passport and vRP.Identity(Partner) and not GetRelationship(Partner) then
			exports.oxmysql:insert_async("INSERT INTO relationships (Passport1,Passport2,Status,Ring) VALUES (?,?,?,?)",{ math.min(Passport,Partner),math.max(Passport,Partner),"casamento",Split[1] })
			break
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Relationship",GetRelationship)
