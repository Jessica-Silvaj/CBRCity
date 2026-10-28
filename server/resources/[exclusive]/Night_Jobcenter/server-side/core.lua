-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("Night_Jobcenter",Creative)
vCLIENT = Tunnel.getInterface("Night_Jobcenter")
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBCENTER:OPENJOBCENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Jobcenter:OpenJobCenter", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local ConsultItem = vRP.ConsultItem(Passport, NeedItem, 1)
        if ConsultItem then
            TriggerClientEvent("Night_Jobcenter:Open", source, Config)
        else
            TriggerClientEvent("Notify", source, "Atenção", "Você não possui a Carteira de Trabalho.", "amarelo", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBCENTER:STARTJOB
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Jobcenter:StartJob", function(Work)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Work == "Sair" then
			TriggerClientEvent("dynamic:Close", source)

			if vRP.Request(source, "Central de Empregos", "Deseja se demitir do seu emprego atual pagando uma taxa de <b>$"..parseInt(PriceNewWork).."</b>?") then
				if vRP.PaymentFull(Passport, PriceNewWork) then
					Player(source)["state"]["Job"] = nil
                    TriggerClientEvent("Notify", source, "Sucesso", "Você saiu do seu emprego atual.", "verde", 5000)
				else
					TriggerClientEvent("Notify", source, "Aviso", "Dinheiro insuficiente para pagar a taxa de demissão.", "amarelo", 5000)
				end
			end
		else
            local jobName = Work
            for k,v in pairs(Config.Jobs) do
                if v.rank == Work then
                    jobName = v.name
                end
            end

			if vRP.Request(source, "Central de Empregos", "Deseja assinar a carteira no emprego de "..jobName.."?") then
				Player(source)["state"]["Job"] = Work

				TriggerClientEvent("Night_Jobcenter:GPS", source, Work)
				TriggerClientEvent("Notify", source, "Sucesso", "Carteira assinada! Local do serviço marcado em seu GPS.", "verde", 5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBCENTER:FINDJOB
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Jobcenter:FindJob", function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("dynamic:Close", source)

        local currentJob = Player(source)["state"]["Job"]
        if currentJob then
		    TriggerClientEvent("Night_Jobcenter:GPS", source, currentJob)
		    TriggerClientEvent("Notify", source, "Sucesso", "Local do serviço marcado em seu GPS.", "verde", 5000)
        else
            TriggerClientEvent("Notify", source, "Atenção", "Você não tem nenhum emprego assinado no momento.", "amarelo", 5000)
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBCENTER:SOLICITAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Night_Jobcenter:Solicitar")
AddEventHandler("Night_Jobcenter:Solicitar", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.Request(source, "Central de Empregos", "Deseja retirar sua Carteira de Trabalho por R$"..parseInt(PriceWallet).."?") then
			vRP.GenerateItem(Passport, "trabalho", 1, true)
        end
    end
end)