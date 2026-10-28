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

	if not Passport or Active[Passport] or not Configuration then
		return false
	end

	if Configuration.Police and vRP.AmountService("Policia") < Configuration.Police then
		TriggerClientEvent("Notify",source,"Atenção","Contingente indisponível.","amarelo",5000)
		return false
	end

	local RequiredItem = true
	if Configuration.Need then
		RequiredItem = vRP.ConsultItem(Passport,Configuration.Need.Item,Configuration.Need.Amount)
		if not RequiredItem then
			TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>"..Configuration.Need.Amount.."x "..ItemName(Configuration.Need.Item).."</b>.","amarelo",5000)
			return false
		end
	end

	local CurrentTimer = os.time()
	local Type = type(Configuration.Cooldown)
	local Cooldown = Type == "table" and (Configuration.Cooldown[Number] or 0) or (Configuration.Cooldown or 0)
	if CurrentTimer < Cooldown then
		local Remaining = Cooldown - CurrentTimer
		if not Configuration.Explosion and Remaining >= ((Configuration.Delay or 3600) - 300) and (Type == "table" or (Type == "number" and (Configuration.Last or 1) == Number)) then
			TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(Remaining)..".","amarelo",5000)
		end

		return false
	else
		if Type == "table" then
			Configuration.Cooldown[Number] = os.time() + (Configuration.Delay or 3600)
		else
			Configuration.Last = Number
			Configuration.Cooldown = os.time() + (Configuration.Delay or 3600)
		end
	end

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
		Permission = "Policia",
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
				local consumeItem = RequiredItem and RequiredItem.Item or Configuration.Need.Item
				Consumed = vRP.TakeItem(Passport,consumeItem,Configuration.Need.Amount,false,(RequiredItem and RequiredItem.Slot))
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
end)