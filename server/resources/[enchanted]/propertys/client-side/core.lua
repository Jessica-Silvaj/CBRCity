-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("propertys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Init = {}
local Blips = {}
local OwnedBlips = {}
local GeneralBlipsVisible = false
local Objects = {}
local Inside = false
local Opened = false
local Policed = false
local Stealing = false
local Interior = false
local HoverFy = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer.state:set("Propertys",false,false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	RemoveIpl("propertys_shells")

	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			if not Inside then
				for Name,OtherCoords in next,Propertys do
					if #(Coords - OtherCoords) < 1.0 then
						TimeDistance = 1

						if not HoverFy then
							TriggerEvent("hoverfy:Show",{ Key = "E", Title = "Pressione", Legend = "para acessar" })
							HoverFy = Name
						end

						if IsControlJustPressed(1,38) then
							local Dynamic = exports.dynamic
							local Consult = vSERVER.Propertys(Name)

							if Consult then
								if Consult == "Nothing" then
									for Line,v in next,Informations do
										local Managed = ManagedHouses[Name]
										if not Managed or Managed.Interior == Line then
											local Price = Managed and Managed.Price or v.Price
											Dynamic:AddMenu(Line,"Informações sobre o interior.",Line,nil,v.Image)
											Dynamic:AddButton("Credenciais","Máximo <yellow>1</yellow> proprietário e <yellow>3</yellow> adicionais.","","",Line,false)
											Dynamic:AddButton("Visitar","Visitar o interior.","propertys:Visit",Name.."-"..Line,Line,false)

											if Price then
												Dynamic:AddButton("Comprar com Dinheiro","Custo de <yellow>"..Currency..Dotted(Price).."</yellow>.","propertys:Buy",Name.."-"..Line.."-Dollar",Line,true)
											end

											if v.Gemstone and not Managed then
												Dynamic:AddButton("Comprar com Diamantes","Custo de <yellow>"..Dotted(v.Gemstone).."</yellow>.","propertys:Buy",Name.."-"..Line.."-Gemstone",Line,true)
											end
									end
									end

									Dynamic:Open()
								elseif Name == "Hotel" then
									if Consult == Name then
										Interior = Name
										TriggerEvent("propertys:Enter",Name,false)
									end
								elseif not Consult.Owner then
									Interior = Consult.Interior

									if Consult.Key then
										Dynamic:AddButton("Entrar","Adentrar a propriedade.","propertys:Enter",Name,false,false)
										Dynamic:AddButton("Fechadura","Trancar/Destrancar a propriedade.","propertys:Lock",Name,false,true)
									elseif not Consult.Lock then
										Dynamic:AddButton("Entrar","Adentrar a propriedade.","propertys:Enter",Name,false,false)
									else
										Dynamic:AddButton("Invadir","Forçar a fechadura.","propertys:Robbery",Name,false,true)
									end

									Dynamic:Open()
								else
									Interior = Consult.Interior

									Dynamic:AddButton("Entrar","Adentrar a propriedade.","propertys:Enter",Name,false,false)
									Dynamic:AddButton("Cartões","Comprar um novo cartão de acesso.","propertys:Item",Name,false,true)
									Dynamic:AddButton("Fechadura","Trancar/Destrancar a propriedade.","propertys:Lock",Name,false,true)
									Dynamic:AddButton("Credenciais","Reconfigurar os cartões de acesso.","propertys:Credentials",Name,false,true)
									Dynamic:AddButton("Garagem","Adicionar/Reajustar a garagem.","garages:Propertys",Name,false,true)
									Dynamic:AddButton("Vender","Se desfazer da propriedade.","propertys:Sell",Name,false,true)
									Dynamic:AddButton("Transferência","Mudar proprietário.","propertys:Transfer",Name,false,true)
									Dynamic:AddButton("Hipoteca",Consult.Tax,"","",false,false)

									local Display = false
									local InteriorData = Informations[Interior]
									local Valuation = InteriorData and InteriorData.Gemstone or 0
									for Line,v in next,Informations do
										if v.Gemstone and v.Gemstone > Valuation then
											if not Display then
												Dynamic:AddMenu("Interior","Trocar interior da propriedade.<br><yellow>O peso do Baú permanece o mesmo.</yellow>","interior")
												Display = true
											end

											Dynamic:AddButton(Line,"Custo de <yellow>"..Dotted(v.Gemstone - Valuation).." diamantes</yellow>.","propertys:Interior",Name.."-"..Line,"interior",true)
										end
									end

									Dynamic:Open()
								end
							elseif Name ~= "Hotel" then
								Dynamic:AddButton("Invadir","Forçar a fechadura.","propertys:Robbery",Name,false,true)
								Dynamic:Open()
							end
						end
					elseif HoverFy and HoverFy == Name then
						TriggerEvent("hoverfy:Hide")
						HoverFy = false
					end
				end
			elseif Inside then
				local PropertyCoords = Propertys[Inside]
				local InternalData = Interior and Internal[Interior]
				if PropertyCoords and InternalData then
					SetPlayerBlipPositionThisFrame(PropertyCoords.x,PropertyCoords.y)

					if Coords.z < (InternalData.Exit.z - 25.0) then
						SetEntityCoordsNoOffset(Ped,InternalData.Exit)
					end

					if Stealing and Policed and Policed <= GetGameTimer() then
						local Pid = PlayerId()
						if GetPedMovementClipset(Ped) ~= -1155413492 or IsPedSprinting(Ped) or MumbleIsPlayerTalking(Pid) then
							vSERVER.Police(PropertyCoords,Coords,Inside)
							Policed = GetGameTimer() + 15000
						end
					end

					for Line,v in next,InternalData do
						if #(Coords - v) <= 1.0 and IsControlJustPressed(1,38) then
							if Line == "Exit" then
								LocalPlayer.state:set("Propertys",false,false)
								SetEntityCoordsNoOffset(Ped,PropertyCoords)
								RemoveIpl("propertys_shells")
								vSERVER.Toggle(Inside,"Exit")
								Interior = false
								Stealing = false
								Policed = false
								Inside = false
							elseif Line == "Vault" and not Stealing and vSERVER.Permission(Inside) then
								Opened = Line
								vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)

								TriggerEvent("inventory:Open",{
									Type = "Chest",
									Resource = "propertys",
									Right = "Propriedade"
								})
							end
						end
					end

					TimeDistance = 1
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:ENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Enter")
AddEventHandler("propertys:Enter",function(Name,Theft)
	if Theft then
		Stealing = true
		Interior = Theft
		Policed = GetGameTimer() + 15000
		TriggerEvent("player:Residual","Resquício de Línter")
	end

	if HoverFy then
		TriggerEvent("hoverfy:Hide")
		HoverFy = false
	end

	DoScreenFadeOut(0)
	SetEntityVisible(Ped,false)
	SetEntityInvincible(Ped,true)
	FreezeEntityPosition(Ped,true)

	Inside = Name
	local Ped = PlayerPedId()
	TriggerEvent("dynamic:Close")
	RequestIpl("propertys_shells")
	TriggerEvent("hud:Active",false)
	Objects = vSERVER.Toggle(Inside,"Enter")
	LocalPlayer.state:set("Propertys",true,false)
	SetEntityCoordsNoOffset(Ped,Internal[Interior].Exit)

	SetTimeout(5000,function()
		TriggerEvent("hud:Active",true)
		FreezeEntityPosition(Ped,false)
		SetEntityInvincible(Ped,false)
		SetEntityVisible(Ped,true)
		DoScreenFadeIn(2500)
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:VISIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Visit")
AddEventHandler("propertys:Visit",function(Name)
	Name = splitString(Name)
	if HoverFy then
		TriggerEvent("hoverfy:Hide")
		HoverFy = false
	end

	DoScreenFadeOut(0)
	SetEntityVisible(Ped,false)
	SetEntityInvincible(Ped,true)
	FreezeEntityPosition(Ped,true)

	Inside = Name[1]
	Interior = Name[2]
	local Ped = PlayerPedId()
	TriggerEvent("dynamic:Close")
	RequestIpl("propertys_shells")
	TriggerEvent("hud:Active",false)
	Objects = {}
	LocalPlayer.state:set("Propertys",true,false)
	SetEntityCoordsNoOffset(Ped,Internal[Interior].Exit)

	SetTimeout(5000,function()
		TriggerEvent("hud:Active",true)
		FreezeEntityPosition(Ped,false)
		SetEntityInvincible(Ped,false)
		SetEntityVisible(Ped,true)
		DoScreenFadeIn(2500)
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,Secondary,PrimaryWeight,SecondaryWeight,PrimarySlots = vSERVER.Mount(Inside,Opened)
	if Primary then
		Callback({
			Primary = {
				Data = Primary,
				MaxWeight = PrimaryWeight,
				Slots = PrimarySlots or Theme.inventory.slots.default
			},
			Secondary = {
				Data = Secondary,
				MaxWeight = SecondaryWeight,
				Slots = math.max(CountTable(Secondary),100)
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	if not Opened then
		return false
	end

	Opened = false
	vRP.Destroy()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	vSERVER.Take(Data.Slot,Data.Amount,Data.Target,Inside,Opened)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	vSERVER.Store(Data.Item,Data.Slot,Data.Amount,Data.Target,Inside,Opened)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	vSERVER.Update(Data.Slot,Data.Target,Data.Amount,Inside,Opened)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local function RefreshGeneralBlips()
    for _,Blip in pairs(Blips) do
        if DoesBlipExist(Blip) then RemoveBlip(Blip) end
    end
    Blips = {}
    if not GeneralBlipsVisible then return end
    local Markers = vSERVER.Markers()
    for Name,Coords in pairs(Propertys) do
        if Name ~= "Hotel" and not OwnedBlips[Name] then
            local Blip = AddBlipForCoord(Coords.x,Coords.y,Coords.z)
            Blips[Name] = Blip
            SetBlipScale(Blip,0.5)
            SetBlipSprite(Blip,374)
            SetBlipAsShortRange(Blip,true)
            SetBlipColour(Blip,Markers[Name] and 35 or 43)
        end
    end
end

RegisterNetEvent("propertys:OwnedBlips")
AddEventHandler("propertys:OwnedBlips",function(Properties)
	for _,Blip in pairs(OwnedBlips) do
		if DoesBlipExist(Blip) then
			RemoveBlip(Blip)
		end
	end
	OwnedBlips = {}

	for _,Name in ipairs(Properties or {}) do
		local Coords = Propertys[Name]
		if Name ~= "Hotel" and Coords and not OwnedBlips[Name] then
			local Blip = AddBlipForCoord(Coords.x,Coords.y,Coords.z)
			OwnedBlips[Name] = Blip
			SetBlipSprite(Blip,40)
			SetBlipColour(Blip,2)
			SetBlipScale(Blip,0.65)
			SetBlipAsShortRange(Blip,false)
			SetBlipPriority(Blip,8)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Minha casa - "..Name)
			EndTextCommandSetBlipName(Blip)
		end
	end
	RefreshGeneralBlips()
end)

CreateThread(function()
	while not LocalPlayer.state.Passport do
		Wait(1000)
	end
	TriggerEvent("propertys:OwnedBlips",vSERVER.OwnedProperties())
end)

AddEventHandler("onResourceStop",function(Resource)
	if Resource == GetCurrentResourceName() then
		for _,Blip in pairs(OwnedBlips) do
			if DoesBlipExist(Blip) then
				RemoveBlip(Blip)
			end
		end
	end
end)

RegisterNetEvent("propertys:Blips")
AddEventHandler("propertys:Blips",function()
    GeneralBlipsVisible = not GeneralBlipsVisible
    RefreshGeneralBlips()
    TriggerEvent("Notify","Propriedades",GeneralBlipsVisible and "Marcacoes ativadas." or "Marcacoes desativadas.","default",10000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEANDMANAGEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateAndManageObject(Selected,Data,Coords,Theft)
	if not Selected or not Data or not Data.Coords then
		return false
	end

	local CurrentEntity = Init[Selected]
	local Distance = Data.Distance or 100.0
	local ObjCoords = vec3(Data.Coords[1],Data.Coords[2],Data.Coords[3])
	if #(Coords - ObjCoords) > Distance then
		if CurrentEntity and DoesEntityExist(CurrentEntity) then
			DestroyObject(Selected,Data)
		end

		return false
	end

	if CurrentEntity and DoesEntityExist(CurrentEntity) then
		return false
	end

	if not LoadModel(Data.Object) then
		return false
	end

	local Options = nil
	local ModelHash = GetHashKey(Data.Object)
	local Entity = CreateObjectNoOffset(ModelHash,ObjCoords.x,ObjCoords.y,ObjCoords.z,false,false,false)
	if not Entity or not DoesEntityExist(Entity) then
		return false
	end

	SetEntityHeading(Entity,Data.Coords[4] or 0.0)
	SetEntityAsMissionEntity(Entity,true,true)
	DecorSetBool(Entity,"CREATIVE_CODE",true)
	FreezeEntityPosition(Entity,true)
	SetEntityLodDist(Entity,1000)
	Init[Selected] = Entity

	if Theft then
		if not RobberyBlock[Data.Object] and RobberyItens[Data.Object] then
			Options = {
				{
					event = "propertys:RobberyItem",
					label = "Roubar",
					tunnel = "proserver",
					service = Inside.."-"..Selected.."-"..Data.Object
				}
			}
		end
	else
		if Wardrobes[Data.Object] then
			Options = {
				{
					event = "propertys:Wardrobes",
					label = "Armário",
					tunnel = "products",
					service = {
						Name = Inside,
						Selected = Selected,
						Hash = Data.Object
					}
				},{
					event = "skinshop:Open",
					label = "Customizar",
					tunnel = "client"
				},{
					event = "inventory:StoreObjects",
					label = "Guardar",
					tunnel = "server",
					service = "Wardrobe:"..Inside..":"..Selected
				}
			}
		elseif Chests[Data.Object] then
			Options = {
				{
					event = "propertys:Chests",
					label = "Abrir",
					tunnel = "products",
					service = Selected.."-"..Data.Object
				},{
					event = "inventory:StoreObjects",
					label = "Guardar",
					tunnel = "server",
					service = "Vault:"..Inside..":"..Selected
				}
			}
		elseif Frames[Data.Object] then
			Options = {
				{
					event = "propertys:Frame",
					label = "Imagem",
					tunnel = "server",
					service = Inside.."-"..Selected
				},{
					event = "propertys:FrameAdjust",
					label = "Ajustar",
					tunnel = "products",
					service = Selected
				},{
					event = "propertys:FrameClear",
					label = "Remover imagem",
					tunnel = "server",
					service = Inside.."-"..Selected
				},{
					event = "inventory:StoreObjects",
					label = "Guardar",
					tunnel = "server"
				}
			}
		else
			Options = {
				{
					event = "inventory:StoreObjects",
					label = "Guardar",
					tunnel = "server"
				}
			}
		end
	end

	if Options then
		exports.target:AddCode(Selected,{
			Entity = Entity,
			Model = ModelHash,
			options = Options,
			Distance = 1.75
		})
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESTROYOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function DestroyObject(Selected)
	if not Selected then
		return false
	end

	local Entity = Init[Selected]
	if Entity and DoesEntityExist(Entity) then
		DeleteEntity(Entity)
	end

	if Objects[Selected] then
		exports.target:RemCode(Selected)
		Objects[Selected] = nil
	end

	Init[Selected] = nil
	DestroyPicture(Selected)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICTURES
-----------------------------------------------------------------------------------------------------------------------------------------
local PictureLoad = 25.0
local PictureUnload = 30.0
local PictureLimit = 8
local PictureSide = 1024

local Pictures = {}
local PictureActive = {}
local PicturePool = {}
local PictureTxd = CreateRuntimeTxd("propertys_frames")
local PictureCount = 0
local Adjusting = false

local function Encode(Value)
	return (tostring(Value):gsub("[^%w%-%._~]",function(Char) return string.format("%%%02X",string.byte(Char)) end))
end

local function PictureAdjust(Selected,Data)
	if Adjusting and Adjusting.Selected == Selected then
		return Adjusting.Adjust
	end

	return Data.Adjust or {}
end

local function AdjustKey(Adjust)
	return (Adjust.Zoom or 1).."|"..(Adjust.X or 0).."|"..(Adjust.Y or 0).."|"..(Adjust.Fit and 1 or 0)
end

-- O DUI segue a proporção do quadro para a imagem não ser esticada ao ser desenhada.
local function PictureSize(Entity,Config)
	local Min,Max = GetModelDimensions(GetEntityModel(Entity))
	local Width = math.max(Max.x - Min.x - Config.Left - Config.Right,0.01)
	local Height = math.max(Max.z - Min.z - Config.Top - Config.Bottom,0.01)
	local Scale = PictureSide / math.max(Width,Height)

	return math.max(math.floor(Width * Scale / 4) * 4,64),math.max(math.floor(Height * Scale / 4) * 4,64)
end

-- Cada textura de DUI fica presa na TXD, então os DUIs são reaproveitados em vez de recriados.
local function PictureAcquire(Entity,Config,Url,Adjust)
	local Width,Height = PictureSize(Entity,Config)
	local Size = Width.."x"..Height
	local Pool = PicturePool[Size]
	local Slot = Pool and table.remove(Pool)

	if Slot then
		SendDuiMessage(Slot.Dui,json.encode({ Url = Url, Adjust = Adjust }))
	else
		PictureCount = PictureCount + 1
		Slot = { Size = Size, Txn = "frame_"..PictureCount }
		Slot.Dui = CreateDui(("nui://propertys/html/frame.html?url=%s&zoom=%s&x=%s&y=%s&fit=%s"):format(Encode(Url),Adjust.Zoom or 1,Adjust.X or 0,Adjust.Y or 0,Adjust.Fit and 1 or 0),Width,Height)
		CreateRuntimeTextureFromDuiHandle(PictureTxd,Slot.Txn,GetDuiHandle(Slot.Dui))
	end

	return Slot
end

function DestroyPicture(Selected)
	local Picture = Pictures[Selected]
	if Picture then
		SendDuiMessage(Picture.Slot.Dui,json.encode({ Clear = true }))
		PicturePool[Picture.Slot.Size] = PicturePool[Picture.Slot.Size] or {}
		table.insert(PicturePool[Picture.Slot.Size],Picture.Slot)
		Pictures[Selected] = nil
	end
end

local function PictureSync(Selected,Data)
	local Picture = Pictures[Selected]
	if Picture then
		local Adjust = PictureAdjust(Selected,Data)
		local Key = AdjustKey(Adjust)
		if Picture.Key ~= Key then
			Picture.Key = Key
			SendDuiMessage(Picture.Slot.Dui,json.encode({ Adjust = Adjust }))
		end
	end
end

local function PictureCorners(Entity,Config,Side)
	local Min,Max = GetModelDimensions(GetEntityModel(Entity))
	local Y = (Side > 0 and Max.y or Min.y) + Config.Depth * Side
	local X1,X2 = Min.x + Config.Left,Max.x - Config.Right
	local Z1,Z2 = Min.z + Config.Bottom,Max.z - Config.Top

	return {
		GetOffsetFromEntityInWorldCoords(Entity,X1,Y,Z2),
		GetOffsetFromEntityInWorldCoords(Entity,X2,Y,Z2),
		GetOffsetFromEntityInWorldCoords(Entity,X2,Y,Z1),
		GetOffsetFromEntityInWorldCoords(Entity,X1,Y,Z1)
	}
end

local function DrawQuad(C,Txn,Mirror)
	local L,R = Mirror and 1.0 or 0.0,Mirror and 0.0 or 1.0

	DrawSpritePoly(C[1].x,C[1].y,C[1].z,C[2].x,C[2].y,C[2].z,C[3].x,C[3].y,C[3].z,255,255,255,255,"propertys_frames",Txn,L,0.0,1.0,R,0.0,1.0,R,1.0,1.0)
	DrawSpritePoly(C[1].x,C[1].y,C[1].z,C[3].x,C[3].y,C[3].z,C[4].x,C[4].y,C[4].z,255,255,255,255,"propertys_frames",Txn,L,0.0,1.0,R,1.0,1.0,L,1.0,1.0)
	DrawSpritePoly(C[3].x,C[3].y,C[3].z,C[2].x,C[2].y,C[2].z,C[1].x,C[1].y,C[1].z,255,255,255,255,"propertys_frames",Txn,R,1.0,1.0,R,0.0,1.0,L,0.0,1.0)
	DrawSpritePoly(C[4].x,C[4].y,C[4].z,C[3].x,C[3].y,C[3].z,C[1].x,C[1].y,C[1].z,255,255,255,255,"propertys_frames",Txn,L,1.0,1.0,R,1.0,1.0,L,0.0,1.0)
end

-- Varredura lenta: escolhe os quadros mais próximos e calcula a geometria fora do loop de desenho.
CreateThread(function()
	while true do
		local Active = {}

		if Inside and Inside ~= "Hotel" then
			local Coords = GetEntityCoords(PlayerPedId())
			local Candidates = {}

			for Selected,Entity in pairs(Init) do
				local Data = Objects[Selected]
				local Config = Data and Frames[Data.Object]
				if Config and Data.Image and DoesEntityExist(Entity) then
					local Distance = #(Coords - GetEntityCoords(Entity))
					if Distance <= (Pictures[Selected] and PictureUnload or PictureLoad) then
						Candidates[#Candidates + 1] = { Selected = Selected, Entity = Entity, Data = Data, Config = Config, Distance = Distance }
					end
				end
			end

			table.sort(Candidates,function(A,B) return A.Distance < B.Distance end)

			local Keep = {}
			for Index = 1,math.min(#Candidates,PictureLimit) do
				Keep[Candidates[Index].Selected] = Candidates[Index].Data.Image
			end

			for Selected,Picture in pairs(Pictures) do
				if Keep[Selected] ~= Picture.Url then
					DestroyPicture(Selected)
				end
			end

			for Index = 1,math.min(#Candidates,PictureLimit) do
				local Item = Candidates[Index]
				local Picture = Pictures[Item.Selected]

				if not Picture then
					local Adjust = PictureAdjust(Item.Selected,Item.Data)
					Picture = { Selected = Item.Selected, Url = Item.Data.Image, Key = AdjustKey(Adjust) }
					Picture.Slot = PictureAcquire(Item.Entity,Item.Config,Picture.Url,Adjust)
					Pictures[Item.Selected] = Picture
				else
					PictureSync(Item.Selected,Item.Data)
				end

				Picture.Front = PictureCorners(Item.Entity,Item.Config,1)
				Picture.Back = PictureCorners(Item.Entity,Item.Config,-1)
				Picture.Center = (Picture.Front[1] + Picture.Back[3]) * 0.5
				Picture.Normal = Picture.Front[1] - Picture.Back[1]
				Active[#Active + 1] = Picture
			end
		elseif next(Pictures) then
			for Selected in pairs(Pictures) do
				DestroyPicture(Selected)
			end
		end

		PictureActive = Active
		Wait(250)
	end
end)

-- Desenho: só o lado do quadro voltado para a câmera.
CreateThread(function()
	while true do
		if #PictureActive > 0 then
			local Camera = GetFinalRenderedCamCoord()

			for _,Picture in ipairs(PictureActive) do
				if Pictures[Picture.Selected] == Picture then
					local View,Normal = Camera - Picture.Center,Picture.Normal
					if View.x * Normal.x + View.y * Normal.y + View.z * Normal.z >= 0 then
						DrawQuad(Picture.Front,Picture.Slot.Txn,true)
					else
						DrawQuad(Picture.Back,Picture.Slot.Txn,false)
					end
				end
			end

			Wait(0)
		else
			Wait(250)
		end
	end
end)

AddEventHandler("onResourceStop",function(Resource)
	if Resource == GetCurrentResourceName() then
		for _,Picture in pairs(Pictures) do
			DestroyDui(Picture.Slot.Dui)
		end

		for _,Pool in pairs(PicturePool) do
			for _,Slot in ipairs(Pool) do
				DestroyDui(Slot.Dui)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Inside and Inside ~= "Hotel" then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			for Selected,Data in pairs(Objects) do
				CreateAndManageObject(Selected,Data,Coords,Stealing)
			end
		elseif next(Init) then
			for Selected in pairs(Init) do
				DestroyObject(Selected)
			end

			Objects = {}
			Init = {}
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:FRAMEADJUST
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("propertys:FrameAdjust",function(Selected)
	local Data = Objects[Selected]
	if Adjusting or Stealing or not Inside or not Data or not vSERVER.Permission(Inside) then
		return false
	end

	if not Data.Image then
		TriggerEvent("Notify","Quadro","Aplique uma imagem antes de ajustar.","amarelo",5000)
		return false
	end

	local Saved = Data.Adjust or {}
	local Adjust = { Zoom = Saved.Zoom or 1.0, X = Saved.X or 0, Y = Saved.Y or 0, Fit = Saved.Fit or false }
	local Property = Inside
	Adjusting = { Selected = Selected, Adjust = Adjust }

	CreateThread(function()
		local Idle = 60000
		local Timeout = GetGameTimer() + Idle

		while Adjusting do
			DisableAllControlActions(0)
			EnableControlAction(0,1,true)
			EnableControlAction(0,2,true)

			BeginTextCommandDisplayHelp("STRING")
			AddTextComponentSubstringPlayerName("~INPUT_CELLPHONE_UP~~INPUT_CELLPHONE_DOWN~~INPUT_CELLPHONE_LEFT~~INPUT_CELLPHONE_RIGHT~ mover  ~INPUT_SCRIPTED_FLY_ZUP~~INPUT_SCRIPTED_FLY_ZDOWN~ zoom  ~INPUT_SPRINT~ preciso~n~~INPUT_DETONATE~ preencher  ~INPUT_RELOAD~ resetar~n~~INPUT_FRONTEND_RDOWN~ salvar  ~INPUT_CELLPHONE_CANCEL~ cancelar")
			EndTextCommandDisplayHelp(0,false,false,-1)

			-- Velocidade por segundo, para não depender do FPS de quem está ajustando.
			local Delta = GetFrameTime() * (IsDisabledControlPressed(0,21) and 0.25 or 1.0)
			local Move,Scale = 30.0 * Delta,0.75 * Delta
			local Changed = false

			if IsDisabledControlPressed(0,172) then Adjust.Y = math.max(Adjust.Y - Move,-50) Changed = true end
			if IsDisabledControlPressed(0,173) then Adjust.Y = math.min(Adjust.Y + Move,50) Changed = true end
			if IsDisabledControlPressed(0,174) then Adjust.X = math.max(Adjust.X - Move,-50) Changed = true end
			if IsDisabledControlPressed(0,175) then Adjust.X = math.min(Adjust.X + Move,50) Changed = true end
			if IsDisabledControlPressed(0,10) then Adjust.Zoom = math.min(Adjust.Zoom + Scale,3.0) Changed = true end
			if IsDisabledControlPressed(0,11) then Adjust.Zoom = math.max(Adjust.Zoom - Scale,0.5) Changed = true end
			if IsDisabledControlJustPressed(0,47) then Adjust.Fit = not Adjust.Fit Changed = true end
			if IsDisabledControlJustPressed(0,45) then Adjust.Zoom,Adjust.X,Adjust.Y,Adjust.Fit = 1.0,0,0,false Changed = true end

			if Changed then
				Timeout = GetGameTimer() + Idle
			end

			if Inside ~= Property or not Objects[Selected] then
				Adjusting = false
			elseif IsDisabledControlJustPressed(0,191) then
				TriggerServerEvent("propertys:FrameAdjust",Property.."-"..Selected,Adjust)
				Adjusting = false
			elseif IsDisabledControlJustPressed(0,177) or IsDisabledControlJustPressed(0,200) then
				Adjusting = false
			elseif GetGameTimer() > Timeout then
				Adjusting = false
				TriggerEvent("Notify","Quadro","Ajuste cancelado por inatividade.","amarelo",5000)
			end

			if Objects[Selected] then
				PictureSync(Selected,Objects[Selected])
			end

			Wait(0)
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:ADICIONAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Adicionar",function(Selected,Data)
	if not Selected or not Data then
		return false
	end

	Objects[Selected] = Data
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Remover",function(Selected)
	DestroyObject(Selected)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:WARDROBES
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("propertys:Wardrobes",function(Data)
	if not Stealing then
		exports.dynamic:AddButton("Guardar","Salvar vestimentas do corpo.","propertys:Clothes:Save",Data.Name.."-"..Data.Selected.."-"..Data.Hash,false,true)

		local Clothes = vSERVER.Clothes(Data.Name,Data.Selected)
		for _,Name in pairs(Clothes) do
			exports.dynamic:AddMenu(Name,"Informações da vestimenta.",Name)
			exports.dynamic:AddButton("Aplicar","Vestir-se com as vestimentas.","propertys:Clothes:Apply",Data.Name.."-"..Data.Selected.."-"..Name,Name,true)
			exports.dynamic:AddButton("Remover","Deletar a vestimenta do armário.","propertys:Clothes:Delete",Data.Name.."-"..Data.Selected.."-"..Name,Name,true,true)
		end

		exports.dynamic:Open()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("propertys:Chests",function(Selected)
	if not Stealing and Inside and vSERVER.Permission(Inside) then
		Opened = Selected
		vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)

		TriggerEvent("inventory:Open",{
			Type = "Chest",
			Resource = "propertys",
			Right = "Propriedade"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:DYNAMIC
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("propertys:Dynamic",function()
	if not next(Objects) or Stealing or not Inside or not vSERVER.Permission(Inside) then
		return false
	end

	exports.dynamic:AddMenu("Propriedade","Controle completo de seus móveis.","propertys")

	for Selected,Data in pairs(Objects) do
		local Suffix = ""
		if Wardrobes[Data.Object] then
			Suffix = "-Wardrobe"
		elseif Chests[Data.Object] then
			Suffix = "-Vault"
		end

		exports.dynamic:AddButton(exports.vrp:ItemName(Data.Item),"Clique para remover o objeto.","propertys:DynamicButton",Suffix ~= "" and (Selected..Suffix) or Selected,"propertys",false,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:DYNAMICBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("propertys:DynamicButton",function(Data)
	if not Data or Stealing or not Inside then
		return false
	end

	local Event = nil
	local Mode = SplitTwo(Data)
	local Selected = SplitOne(Data)

	if Mode and (Mode == "Wardrobe" or Mode == "Vault") then
		Event = Mode..":"..Inside..":"..Selected

		TriggerEvent("dynamic:Close")
	end

	TriggerServerEvent("inventory:StoreObjects",Selected,Event)
end)

RegisterNetEvent("propertys:managedSync",function(Entries)
    ApplyManagedHouses(Entries)
    TriggerEvent("propertys:OwnedBlips",vSERVER.OwnedProperties())
end)
CreateThread(function() TriggerServerEvent("propertys:managedLoad") end)
