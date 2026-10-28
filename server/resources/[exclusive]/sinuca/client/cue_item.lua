-----------------------------------------------------------------------------------------------------------------------------------------
-- TACO DE SINUCA (item "pooltablecue" da loja de diamantes)
-- Usar o item coloca o taco na mão; usar de novo guarda. Necessário para jogar em mesas sem suporte de tacos (casas).
-----------------------------------------------------------------------------------------------------------------------------------------
local CueModel = GetHashKey("prop_pool_cue")

local function HoldingCue()
	local Ped = PlayerPedId()
	local Object = GetClosestObjectOfType(GetEntityCoords(Ped),3.0,CueModel,false,false,false)
	return Object ~= 0 and DoesEntityExist(Object) and IsEntityAttachedToEntity(Object,Ped)
end

-- A sinuca cria o prop do taco sem carregar o modelo antes; longe de um suporte de tacos
-- (ex.: dentro de casa) o modelo não está carregado e o taco não aparece.
local function LoadCue()
	if HasModelLoaded(CueModel) then
		return true
	end

	RequestModel(CueModel)
	local Timeout = GetGameTimer() + 5000
	while not HasModelLoaded(CueModel) and GetGameTimer() < Timeout do
		Wait(10)
	end

	return HasModelLoaded(CueModel)
end

RegisterNetEvent("sinuca:cueItem")
AddEventHandler("sinuca:cueItem",function()
	if HoldingCue() then
		TriggerEvent("sinuca:removeCue")
		TriggerEvent("Notify","Sinuca","Você guardou o taco.","default",3000)
	else
		if not LoadCue() then
			TriggerEvent("Notify","Sinuca","Não foi possível carregar o taco. Tente novamente.","vermelho",5000)
			return
		end
		TriggerEvent("sinuca:takeCue")
		TriggerEvent("Notify","Sinuca","Taco na mão. Chegue perto da mesa e aperte <b>E</b>.","verde",5000)
	end
end)
