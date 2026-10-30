-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
-- Last: Utilizado apenas em roubos globais e exclusivos para indicar a última ocorrência.
--        Valor padrão: 1

-- Delay: Tempo de espera antes de permitir um novo roubo, usado apenas se diferente do padrão.
--        Valor padrão: 3600 segundos

-- Timer: Duração total do roubo, utilizado somente quando o tempo for diferente do padrão.
--        Valor padrão: 30 segundos

-- Wanted: Duração do estado de procurado após o roubo, aplicado somente se for diferente do padrão.
--        Valor padrão: 60 segundos

-- Cooldown: Define o tipo de cooldown do roubo.
--           Se for uma tabela, o roubo terá múltiplos cooldowns (multiplicador).
--           Se for um timestamp (os.time()), o cooldown será único.

-- Percentage: Probabilidade, em milésimos, de chamar a polícia durante o roubo.

-- Police: Quantidade mínima de policiais em serviço necessária para iniciar o roubo.
--         Utilizado somente quando essa restrição for necessária.

-- Explosion: Flag que indica se o roubo envolve explosões.
--            Utilizado somente quando aplicável.

-- Residual: Tipo de resíduo deixado após o roubo, usado apenas se diferente do padrão.
--           Valor padrão: "Resquício de Línter"

-- Need: Item(s) obrigatório(s) que o jogador deve possuir para iniciar o roubo.
--       Utilizado apenas quando houver essa exigência.
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = {
	Hennery = {
		Police = 7,
		Delay = 300,
		Timer = 15,
		Wanted = 120,
		Cooldown = 0,
		Last = nil,
		Percentage = 0,
		Explosion = false,
		Residual = "Resíduo ao Galinheiro",
		Name = "Roubo ao Açougue",
		Need = { Amount = 1, Item = "card04", Consume = true },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 525, Max = 575, Chance = 100 }
			}
		},
		Animation = {
			Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			Name = "machinic_loop_mechandplayer"
		}
	},
	Butcher = {
		Police = 7,
		Delay = 300,
		Timer = 15,
		Wanted = 120,
		Cooldown = 0,
		Last = nil,
		Percentage = 0,
		Explosion = false,
		Residual = "Resíduo de Arrombamento",
		Name = "Roubo ao Açougue",
		Need = { Amount = 1, Item = "card04", Consume = true },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 525, Max = 575, Chance = 100 }
			}
		},
		Animation = {
			Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			Name = "machinic_loop_mechandplayer"
		}
	},
	CentralBank = {
		Police = 10,
		Delay = 300,
		Timer = 15,
		Wanted = 120,
		Cooldown = 0,
		Last = nil,
		Percentage = 0,
		Explosion = false,
		Residual = "Resíduo de Hack Digital",
		Name = "Roubo ao Banco Fleeca",
		Need = { Amount = 1, Item = "card05", Consume = true },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 625, Max = 675, Chance = 100 }
			}
		},
		Animation = {
			Dict = "anim@heists@prison_heiststation@cop_reactions",
			Name = "cop_b_idle"
		}
	},
	FleecaBank = {
		Police = 5,
		Delay = 300,
		Timer = 15,
		Wanted = 120,
		Cooldown = 0,
		Last = nil,
		Percentage = 0,
		Explosion = false,
		Residual = "Resíduo de Hack Digital",
		Name = "Roubo ao Banco Fleeca",
		Need = { Amount = 1, Item = "card03", Consume = true },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 425, Max = 475, Chance = 100 }
			}
		},
		Animation = {
			Dict = "anim@heists@prison_heiststation@cop_reactions",
			Name = "cop_b_idle"
		}
	},
	Ammunation = {
		Police = 3,
		Delay = 300,
		Timer = 15,
		Wanted = 120,
		Cooldown = 0,
		Last = nil,
		Percentage = 0,
		Explosion = false,
		Residual = "Resíduo de Arrombamento",
		Name = "Roubo a Ammunation",
		Need = { Amount = 1, Item = "card02", Consume = true },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 325, Max = 375, Chance = 100 }
			}
		},
		Animation = {
			Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			Name = "machinic_loop_mechandplayer"
		}
	},
	Department = {
		Police = 3,
		Delay = 300,
		Timer = 15,
		Wanted = 120,
		Cooldown = 0,
		Last = nil,
		Percentage = 0,
		Explosion = false,
		Residual = "Resíduo de Arrombamento",
		Name = "Roubo a Departamento",
		Need = { Amount = 1, Item = "card01", Consume = true },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 325, Max = 375, Chance = 100 }
			}
		},
		Animation = {
			Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			Name = "machinic_loop_mechandplayer"
		}
	},
	Register = {
		Police = 2,
		Delay = 300,
		Timer = 15,
		Wanted = 120,
		Cooldown = 0,
		Last = nil,
		Percentage = 300,
		Explosion = false,
		Residual = "Resíduo de Arrombamento",
		Name = "Roubo a Registradora",
		Need = { Amount = 1, Item = "lockpick", Consume = true },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 325, Max = 375, Chance = 100 }
			}
		},
		Animation = {
			Dict = "oddjobs@shop_robbery@rob_till",
			Name = "loop"
		}
	},
	Container = {
		Police = 2,
		Delay = 300,
		Wanted = 120,
		Cooldown = 0,
		Last = nil,
		Percentage = 300,
		Explosion = false,
		Residual = "Resíduo de Arrombamento",
		Name = "Roubo a Container",
		Need = { Amount = 1, Item = "WEAPON_CROWBAR", Consume = false },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 325, Max = 375, Chance = 100 }
			}
		},
		Animation = {
			Dict = "missheistfbi3b_ig7",
			Name = "lift_fibagent_loop"
		}
	},
	-- Carro-forte: o roubo é no próprio veículo (stockade.lua); aqui ficam só os valores editáveis no painel.
	-- Delay = espera para começar outro carro-forte, Timer = duração de cada compartimento, pagamento por compartimento.
	Stockade = {
		Police = 10,
		Delay = 3600,
		Timer = 20,
		Wanted = 60,
		Cooldown = 0,
		Name = "Roubo a Carro Forte",
		Need = { Amount = 1, Item = "WEAPON_CROWBAR", Consume = false },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 7225, Max = 7225, Chance = 100 }
			}
		}
	},
	Eletronic = {
		Police = 2,
		Delay = 300,
		Wanted = 600,
		Cooldown = 0,
		Last = nil,
		Percentage = 300,
		Explosion = true,
		Residual = "Resíduo de Explosivo",
		Name = "Caixa Eletrônico",
		Need = { Amount = 1, Item = "c4", Consume = true },
		Payment = {
			List = {
				{ Item = "dirtydollar", Min = 325, Max = 375, Chance = 100 }
			}
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ROBBERYACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------

-- Persistent management settings. Runtime cooldowns remain in Config.
local function ApplyManagementRobberies(Entries)
    local Removed = {}
    for Mode,Entry in pairs(Entries or {}) do
        local Setting = Config[Mode]
        if Entry.Deleted == true then
            Config[Mode] = nil
            Removed[Mode] = true
        elseif Setting then
            Setting.Enabled = Entry.Enabled ~= false
            for _,Key in ipairs({ "Police","Delay","Timer","Wanted" }) do
                if type(Entry[Key]) == "number" then Setting[Key] = Entry[Key] end
            end
            local Payment = Setting.Payment and Setting.Payment.List and Setting.Payment.List[1]
            if Payment then Payment.Min,Payment.Max = Entry.Min or Payment.Min,Entry.Max or Payment.Max end
            -- Item exigido escolhido no painel ("" = nenhum)
            -- vários itens separados por vírgula: o jogador precisa de todos
            if type(Entry.NeedItem) == "string" then
                Setting.Need = Entry.NeedItem ~= "" and { Item = Entry.NeedItem,Amount = Entry.NeedAmount or 1,Consume = Entry.NeedConsume == true } or nil
            end
        end
    end
    -- Tipos excluídos pelo painel: os clientes removem os pontos "Roubar"
    GlobalState.RobberyRemoved = Removed
end
local RawManagementRobberies = LoadResourceFile("Night_Management","data/robberies.json")
if RawManagementRobberies then
    local Ok,Entries = pcall(json.decode,RawManagementRobberies)
    if Ok and type(Entries) == "table" then ApplyManagementRobberies(Entries) end
end
AddEventHandler("Night_Management:robberiesChanged",ApplyManagementRobberies)

-- Pontos de roubo: data/robbery_points.json do painel gestor substitui a lista do shared
local function DefaultRobberyPoints()
    local List = {}
    for Number,v in pairs(Robbery) do
        List[#List + 1] = { id = Number,Mode = v.Mode,X = v.Coords.x,Y = v.Coords.y,Z = v.Coords.z }
    end
    return List
end
local function ApplyRobberyPoints(Points)
    local Result = {}
    for _,Point in pairs(type(Points) == "table" and next(Points) and Points or DefaultRobberyPoints()) do
        Result[tostring(Point.id)] = { Mode = Point.Mode,X = Point.X,Y = Point.Y,Z = Point.Z }
    end
    GlobalState.RobberyPoints = Result
end
local RawRobberyPoints = LoadResourceFile("Night_Management","data/robbery_points.json")
local OkPoints,RobberyPoints = pcall(json.decode,RawRobberyPoints or "{}")
ApplyRobberyPoints(OkPoints and RobberyPoints or nil)
AddEventHandler("Night_Management:robberyPointsChanged",ApplyRobberyPoints)
exports("ManagementRobberyPoints",function()
    local List = {}
    for Id,Point in pairs(GlobalState.RobberyPoints or {}) do
        List[#List + 1] = { id = tonumber(Id),Mode = Point.Mode,X = Point.X,Y = Point.Y,Z = Point.Z }
    end
    table.sort(List,function(a,b) return a.id < b.id end)
    return List
end)
exports("ManagementRobberies",function()
    local List = {}
    for Mode,Entry in pairs(Config) do
        local Payment = Entry.Payment and Entry.Payment.List and Entry.Payment.List[1] or {}
        List[#List + 1] = { id = Mode,Name = Entry.Name,Enabled = Entry.Enabled ~= false,
            Police = Entry.Police or 0,Delay = Entry.Delay or 3600,Timer = Entry.Timer or 30,
            Wanted = Entry.Wanted or 60,Min = Payment.Min or 0,Max = Payment.Max or 0,
            Item = Payment.Item,Explosion = Entry.Explosion == true ,
            NeedItem = Entry.Need and Entry.Need.Item or "",NeedAmount = Entry.Need and Entry.Need.Amount or 1,
            NeedConsume = Entry.Need and Entry.Need.Consume == true or false }
    end
    table.sort(List,function(a,b) return a.id < b.id end)
    return List
end)

AddEventHandler("inventory:RobberyActive",function(Mode,Number)
	local Configuration = Config[Mode]
	if Configuration then
		if type(Configuration.Cooldown) == "table" then
			Configuration.Cooldown[Number] = os.time()
		else
			if Configuration.Last and Configuration.Last == Number then
				Configuration.Cooldown = os.time()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Robbery")
AddEventHandler("inventory:Robbery",function(Number,Mode)
	local source = source
	local Configuration = Config[Mode]
	local Passport = vRP.Passport(source)

	-- Eletronic e Stockade só guardam as configurações do painel; o roubo em si é do c4 / stockade.lua
	if not Passport or not Configuration or Mode == "Eletronic" or Mode == "Stockade" then
		return false
	end

	if Configuration.Enabled == false then
		TriggerClientEvent("Notify",source,"Atenção","Este roubo está desativado.","amarelo",5000)
		return false
	end

	if Active[Passport] then
		TriggerClientEvent("Notify",source,"Atenção","Você já está roubando.","amarelo",5000)
		return false
	end

	if Configuration.Police and vRP.AmountService("PoliciaCBR") < Configuration.Police then
		TriggerClientEvent("Notify",source,"Atenção","Contingente indisponível.","amarelo",5000)
		return false
	end

	local RequiredItem = true
	if Configuration.Need then
		RequiredItem = NeedConsult(source,Passport,Configuration.Need)
		if not RequiredItem then
			return false
		end
	end

	local CurrentTimer = os.time()
	local Type = type(Configuration.Cooldown)
	local Cooldown = Type == "table" and (Configuration.Cooldown[Number] or 0) or (Configuration.Cooldown or 0)
	if CurrentTimer < Cooldown then
		-- avisa sempre: sem isso, outra registradora/ATM em espera parecia não funcionar
		local Remaining = Cooldown - CurrentTimer
		TriggerClientEvent("Notify",source,"Atenção","Roubos deste tipo em espera. Aguarde "..CompleteTimers(Remaining)..".","amarelo",5000)

		return false
	else
		if Type == "table" then
			Configuration.Cooldown[Number] = os.time() + (Configuration.Delay or 3600)
		else
			Configuration.Last = Number
			Configuration.Cooldown = os.time() + (Configuration.Delay or 3600)
		end
	end

	Configuration = json.decode(json.encode(Configuration))
	Player(source).state.Buttons = true
	Robberys[Passport] = { Mode = Mode, Number = Number }
	Active[Passport] = CurrentTimer + (Configuration.Timer or 30)
	TriggerClientEvent("Progress",source,"Roubando",(Configuration.Timer or 30) * 1000)
	TriggerClientEvent("player:Residual",source,Configuration.Residual or "Resquício de Línter")

	if Configuration.Explosion then
		vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

		SetTimeout(5000,function()
			vRPC.Destroy(source)
		end)
	elseif Configuration.Animation then
		vRPC.playAnim(source,false,{Configuration.Animation.Dict,Configuration.Animation.Name},true)
	end

	exports["vrp"]:CallPolice({
		Source = source,
		Passport = Passport,
		Permission = "PoliciaCBR",
		Name = Configuration.Name,
		Percentage = Configuration.Percentage,
		Wanted = Configuration.Wanted or 60,
		Code = 31,
		Color = 22
	})

	CreateThread(function()
		while Active[Passport] and os.time() < Active[Passport] do
			Wait(100)
		end

		vRPC.Destroy(source)
		Robberys[Passport] = nil
		Player(source).state.Buttons = false

		if Active[Passport] then
			Active[Passport] = nil

			local Consumed = true
			if Configuration.Need and Configuration.Need.Consume then
				Consumed = NeedTake(Passport,Configuration.Need,RequiredItem)
			end

			if (not Configuration.Need) or (RequiredItem and Consumed) then
				if not Configuration.Explosion and Configuration.Payment and Configuration.Payment.List and next(Configuration.Payment.List) then
					for _,PaymentItem in ipairs(Configuration.Payment.List) do
						if not PaymentItem.Chance or math.random(1,100) <= PaymentItem.Chance then
							local Amount = math.random(PaymentItem.Min,PaymentItem.Max)
							vRP.GenerateItem(Passport,PaymentItem.Item,Amount,true)
						end
					end
				end
			end
		end
	end)
end)-----------------------------------------------------------------------------------------------------------------------------------------
-- NEEDITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
-- Need.Item aceita vários itens separados por vírgula; todos são exigidos
function NeedItems(Need)
	local Items = {}
	for Item in tostring(Need and Need.Item or ""):gmatch("[^,%s]+") do
		Items[#Items + 1] = Item
	end
	return Items
end

function NeedMissing(source,Need)
	local Names = {}
	for _,Item in ipairs(NeedItems(Need)) do
		Names[#Names + 1] = (Need.Amount or 1).."x "..exports.vrp:ItemName(Item)
	end
	TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>"..table.concat(Names," + ").."</b>.","amarelo",5000)
end

-- retorna a lista de itens encontrados (com slot) ou false avisando o que falta
function NeedConsult(source,Passport,Need)
	local Found = {}
	for _,Item in ipairs(NeedItems(Need)) do
		local Consult = vRP.ConsultItem(Passport,Item,Need.Amount or 1)
		if not Consult then
			NeedMissing(source,Need)
			return false
		end
		Found[#Found + 1] = Consult
	end
	return Found
end

function NeedTake(Passport,Need,Found)
	for _,Consult in ipairs(Found or {}) do
		if not vRP.TakeItem(Passport,Consult.Item,Need.Amount or 1,false,Consult.Slot) then
			return false
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYSETTINGS
-----------------------------------------------------------------------------------------------------------------------------------------
-- Configuração atual (já com o painel gestor) de um tipo de roubo, usada pelo stockade.lua
function RobberySettings(Mode)
	return Config[Mode]
end
