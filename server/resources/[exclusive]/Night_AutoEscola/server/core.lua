-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Server = {}
Tunnel.bindInterface("Night_AutoEscola", Server)
-- NOTA: os itens (laudo_teorico/carta_conducao) estão registados em vrp/config/Item.lua
-- (shared_script que carrega com o vRP antes de todos os recursos - evita purga/"Deletado").
-----------------------------------------------------------------------------------------------------------------------------------------
-- SESSÕES DE EXAME PRÁTICO
-----------------------------------------------------------------------------------------------------------------------------------------
local ExameSessoes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function Notify(source, kind, message)
    Functions.Notify(source, kind, message)
end

local function DataHoje()
    return os.date("%d/%m/%Y")
end

local function DataMaisAnos(Anos)
    local T = os.date("*t")
    return string.format("%02d/%02d/%04d", T.day, T.month, T.year + Anos)
end

local function DiasFaltam(Ts)
    return math.ceil((Ts - os.time()) / 86400)
end

-- Converte Identity.Daily "DD-MM-YYYY-X" para "DD/MM/YYYY" (inline para evitar dependência de functions.lua)
local function GetNascimento(Passport)
    local Identity = vRP.Identity and vRP.Identity(Passport) or nil
    if not Identity or not Identity.Daily then return "N/D" end
    local P = {}
    for v in Identity.Daily:gmatch("[^%-]+") do P[#P+1] = v end
    if #P >= 3 then return P[1] .. "/" .. P[2] .. "/" .. P[3] end
    return "N/D"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORES DA INTERFACE
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.GetColors()
    return {
        primaryColor   = "29,78,216",
        secondaryColor = "15,23,42",
        thirdyColor    = "59,130,246",
    }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUS COMPLETO DO JOGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.GetStatus()
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then
        return { cnh = {}, hasLaudo = false, pontos = pontosConfig.inicial, suspensa = false, atestadoValido = false,
                 pais = pais, moeda = L.moeda, localeNum = L.localeNum, pontosMax = pontosConfig.maximo, nomePais = L.nomePais }
    end

    local CNH          = Functions.GetCNH(Passport)
    local Pontos       = Functions.GetPontos(Passport)
    local Validade     = Functions.GetValidade(Passport)
    local Cooldowns    = Functions.GetCooldowns(Passport)
    local AtestadoTs   = Functions.GetAtestadoTs(Passport)
    local AtestadoValido = AtestadoTs and os.time() < AtestadoTs or false
    local HasLaudo     = Functions.HasItem(Passport, blip_provas.item)

    -- Constrói info detalhada de cada categoria
    local CategoriasInfo = {}
    -- Ordem de exibição
    local Ordem = { "A", "B", "C", "D" }
    for _, Key in ipairs(Ordem) do
        local Cat = config[Key]
        if Cat then
            local TemCNH   = CNH[Key] and true or false
            local Prereq   = Cat.prerequisito
            local PrereqOk = not Prereq or (CNH[Prereq] and true or false)
            local CoolRestante = Functions.GetCooldownRestante(Passport, Key)
            local ValidadeStr  = Validade[Key]
            local Expirada     = TemCNH and ValidadeStr and Functions.IsExpirada(ValidadeStr) or false

            CategoriasInfo[#CategoriasInfo + 1] = {
                key          = Key,
                label        = Cat.label,
                valor        = Cat.valor,
                img          = Cat.img,
                temCNH       = TemCNH,
                prerequisito = Prereq,
                prerequisitoOk = PrereqOk,
                cooldownSeg  = CoolRestante,
                validade     = ValidadeStr,
                expirada     = Expirada,
            }
        end
    end

    return {
        cnh           = CNH,
        hasLaudo      = HasLaudo,
        pontos        = Pontos,
        suspensa      = Pontos >= pontosConfig.maximo,
        validade      = Validade,
        atestadoValido = AtestadoValido,
        atestadoExpira = AtestadoTs and os.date("%d/%m/%Y", AtestadoTs) or nil,
        categoriasInfo = CategoriasInfo,
        -- Dados de idioma/moeda para a interface
        pais          = pais,
        moeda         = L.moeda,
        localeNum     = L.localeNum,
        pontosMax     = pontosConfig.maximo,
        nomePais      = L.nomePais,
    }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATESTADO MÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.ObterAtestado()
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then return { ok = false, msg = "Sem identificação." } end

    if Functions.AtestadoValido(Passport) then
        local Ts = Functions.GetAtestadoTs(Passport)
        return { ok = false, msg = L.laudoJaValido(os.date("%d/%m/%Y", Ts)) }
    end

    if not Functions.PayExam(Passport, blip_provas.medicoCusto) then
        return { ok = false, msg = L.saldoInsuficiente("médico", blip_provas.medicoCusto) }
    end

    local ValidadeTs = os.time() + (blip_provas.medicoValidadeDias * 86400)
    Functions.SetAtestado(Passport, ValidadeTs)

    local DataExp = os.date("%d/%m/%Y", ValidadeTs)
    Notify(source, "verde", L.laudoEmitido(DataExp))
    return { ok = true, expira = DataExp }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXAME MÉDICO - iniciar (devolve perguntas baralhadas; NÃO cobra ainda)
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.IniciarExameMedico()
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then return { ok = false, msg = "Sem identificação." } end

    if Functions.AtestadoValido(Passport) then
        local Ts = Functions.GetAtestadoTs(Passport)
        return { ok = false, msg = L.laudoJaValido(os.date("%d/%m/%Y", Ts)) }
    end

    -- Baralhar e selecionar subconjunto
    local Pool = {}
    for _, Q in ipairs(perguntasMedico.questions) do Pool[#Pool + 1] = Q end
    for I = #Pool, 2, -1 do
        local J = math.random(I)
        Pool[I], Pool[J] = Pool[J], Pool[I]
    end
    local Total = math.min(perguntasMedico.enviar, #Pool)
    local Selected = {}
    for I = 1, Total do Selected[I] = Pool[I] end

    return {
        ok             = true,
        perguntas      = Selected,
        totalPerguntas = Total,
        maxErros       = perguntasMedico.maxErros,
        custo          = blip_provas.medicoCusto,
    }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXAME MÉDICO - concluir (valida, cobra e emite o atestado em caso de aprovação)
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.ConcluirExameMedico(Acertos)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then return { ok = false } end

    if Functions.AtestadoValido(Passport) then
        return { ok = false, msg = "Já tens um atestado médico válido." }
    end

    local Total    = math.min(perguntasMedico.enviar, #perguntasMedico.questions)
    local MaxErros = perguntasMedico.maxErros
    local Corretos = parseInt(Acertos) or 0
    local Erros    = Total - Corretos

    if Erros > MaxErros then
        Notify(source, "vermelho", string.format("Reprovado no exame médico! %d/%d certas (máx %d erros). Tenta novamente.", Corretos, Total, MaxErros))
        return { ok = false, msg = string.format("Reprovado! %d/%d certas. Máx %d erro(s).", Corretos, Total, MaxErros) }
    end

    -- Aprovado: cobra a taxa e emite o atestado
    if not Functions.PayExam(Passport, blip_provas.medicoCusto) then
        return { ok = false, msg = L.saldoInsuficiente("médico", blip_provas.medicoCusto) }
    end

    local ValidadeTs = os.time() + (blip_provas.medicoValidadeDias * 86400)
    Functions.SetAtestado(Passport, ValidadeTs)

    local DataExp = os.date("%d/%m/%Y", ValidadeTs)
    Notify(source, "verde", L.laudoEmitido(DataExp))
    return { ok = true, expira = DataExp }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAGAR EXAME (validações + shuffle server-side)
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.PagarExame(Category)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then return { ok = false, msg = "Sem identificação." } end

    Category = tostring(Category or ""):upper()
    local Cat = config[Category]
    if not Cat then return { ok = false, msg = "Categoria inválida." } end

    -- MODO DEV: 3 perguntas de teste, sem pagamento/atestado/cooldown
    if examRules.dev then
        return {
            ok             = true,
            perguntas      = perguntasDev,
            categoria      = Category,
            totalPerguntas = #perguntasDev,
            maxErros       = #perguntasDev,  -- impossível reprovar
        }
    end

    -- Carta suspensa?
    if Functions.CartaSuspensa(Passport) then
        return { ok = false, msg = L.cartaSuspensa }
    end

    if Functions.HasCNH(Passport, Category) then
        local Val = Functions.GetValidade(Passport)
        if not Val[Category] or not Functions.IsExpirada(Val[Category]) then
            return { ok = false, msg = "Já tens a categoria " .. Category .. " ativa." }
        end
        return { ok = false, msg = "A categoria " .. Category .. " está expirada. Usa o botão Renovar." }
    end

    if not Functions.AtestadoValido(Passport) then
        return { ok = false, msg = L.semAtestado }
    end

    if Cat.prerequisito and not Functions.HasCNH(Passport, Cat.prerequisito) then
        return { ok = false, msg = L.semPrerequisito(Cat.prerequisito, Category) }
    end

    local CoolRestante = Functions.GetCooldownRestante(Passport, Category)
    if CoolRestante > 0 then
        return { ok = false, msg = L.emCooldown(DiasFaltam(os.time() + CoolRestante)) }
    end

    if Functions.HasItem(Passport, blip_provas.item) then
        return { ok = false, msg = L.jaTemLaudo }
    end

    if not Functions.PayExam(Passport, parseInt(Cat.valor)) then
        return { ok = false, msg = L.saldoInsuficiente(Category, Cat.valor) }
    end

    -- Shuffle server-side usando perguntas do país configurado
    local QPool = perguntas[pais] or perguntas.PT
    local Total = math.min(QPool.totalPerguntas, #QPool.questions)
    local Pool  = {}
    for _, Q in ipairs(QPool.questions) do Pool[#Pool + 1] = Q end
    for I = #Pool, 2, -1 do
        local J = math.random(I)
        Pool[I], Pool[J] = Pool[J], Pool[I]
    end
    local Selected = {}
    for I = 1, Total do Selected[I] = Pool[I] end

    return {
        ok             = true,
        perguntas      = Selected,
        categoria      = Category,
        totalPerguntas = Total,
        maxErros       = QPool.maxErros,
    }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONCLUIR EXAME TEÓRICO
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.ConferirTeorico(Acertos, Category)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then return { ok = false } end

    Category = tostring(Category or ""):upper()
    if not config[Category] then return { ok = false, msg = "Categoria inválida." } end

    local QPool    = perguntas[pais] or perguntas.PT
    local Total    = QPool.totalPerguntas
    local MaxErros = QPool.maxErros
    if examRules.dev then
        Total    = #perguntasDev
        MaxErros = #perguntasDev
    end
    local Corretos = parseInt(Acertos) or 0
    local Erros    = Total - Corretos

    if Erros > MaxErros then
        local CooldownEnd = os.time() + examRules.teorico.cooldownSeg
        Functions.SetCooldown(Passport, Category, CooldownEnd)
        local DataCD = os.date("%d/%m/%Y", CooldownEnd)
        Notify(source, "vermelho", L.reprovadoTeorico(Corretos, Total, Erros, MaxErros, DataCD))
        return {
            ok  = false,
            msg = L.reprovadoTeorico(Corretos, Total, Erros, MaxErros, DataCD),
        }
    end

    Functions.GiveItem(Passport, blip_provas.item, 1)
    Notify(source, "verde", L.aprovadoTeorico(Corretos, Total))
    return { ok = true, acertos = Corretos, total = Total }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR EXAME PRÁTICO (regista sessão)
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.IniciarExame(Category)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then return { ok = false } end

    Category = tostring(Category or ""):upper()
    if not config[Category] then return { ok = false } end

    if not Functions.HasItem(Passport, blip_provas.item) then
        return { ok = false, msg = "Precisas do certificado teórico para realizar o exame prático." }
    end

    ExameSessoes[source] = {
        category           = Category,
        inicio             = os.time(),
        manobrasConcluidas = false,
        inicioCirculacao   = nil,
    }
    return { ok = true }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONCLUIR FASE DE MANOBRAS
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.ConferirManobras(Category)
    local source = source
    local Sessao = ExameSessoes[source]
    if not Sessao or Sessao.category ~= tostring(Category or ""):upper() then
        return { ok = false, msg = "Sessão de manobras inválida." }
    end

    -- Verificar tempo mínimo na fase de manobras (anti-cheat)
    local Elapsed = os.time() - Sessao.inicio
    if Elapsed < 30 then
        return { ok = false, msg = "Manobras concluídas demasiado rápido." }
    end

    Sessao.manobrasConcluidas = true
    Sessao.inicioCirculacao   = os.time()
    return { ok = true }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONCLUIR EXAME PRÁTICO (circulação)
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.ConferirPratico(Category, Erros)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then return { ok = false } end

    Category = tostring(Category or ""):upper()
    local Cat = config[Category]
    if not Cat then return { ok = false, msg = "Categoria inválida." } end

    local Sessao = ExameSessoes[source]
    ExameSessoes[source] = nil

    if not Sessao or Sessao.category ~= Category then
        Notify(source, "vermelho", "Sessão de exame inválida.")
        return { ok = false, msg = "Sessão inválida." }
    end

    if not Sessao.manobrasConcluidas then
        return { ok = false, msg = "A fase de manobras não foi concluída." }
    end

    -- Tempo mínimo na circulação (anti-cheat)
    local TempoMinimo = parseInt(Cat.tempoMinimo) or 60
    local Elapsed     = os.time() - (Sessao.inicioCirculacao or Sessao.inicio)
    if Elapsed < TempoMinimo then
        return { ok = false, msg = "Exame de condução concluído rápido demais." }
    end

    -- Consumir certificado teórico
    if not Functions.TakeItem(Passport, blip_provas.item, 1) then
        return { ok = false, msg = "Certificado teórico não encontrado." }
    end

    local MaxErros = parseInt(Cat.maxErros) or 3
    local ErrosNum = parseInt(Erros) or 0

    if ErrosNum > MaxErros then
        local CooldownEnd = os.time() + examRules.pratico.cooldownSeg
        Functions.SetCooldown(Passport, Category, CooldownEnd)
        local DataCD = os.date("%d/%m/%Y", CooldownEnd)
        Notify(source, "vermelho", L.reprovadoPratico(ErrosNum, MaxErros, DataCD))
        return { ok = false, msg = L.reprovadoPratico(ErrosNum, MaxErros, DataCD) }
    end

    local CNH     = Functions.GetCNH(Passport)
    CNH[Category] = true
    Functions.SaveCNH(Passport, CNH)

    local ValidadeAnos = Cat.validadeAnos or 10
    local ValidadeStr  = DataMaisAnos(ValidadeAnos)
    Functions.SetValidade(Passport, Category, ValidadeStr)

    if not Functions.HasItem(Passport, blip_provas.itemFinal) then
        Functions.GiveItem(Passport, blip_provas.itemFinal, 1)
    end

    Notify(source, "verde", L.aprovadoPratico(Category, ValidadeStr))
    return { ok = true, validade = ValidadeStr }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENOVAR CARTA DE CONDUÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.RenovarCarta(Category)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Passport then return { ok = false } end

    Category = tostring(Category or ""):upper()
    local Cat = config[Category]
    if not Cat then return { ok = false, msg = "Categoria inválida." } end

    if not Functions.HasCNH(Passport, Category) then
        return { ok = false, msg = "Não tens a categoria " .. Category .. "." }
    end

    if not Functions.AtestadoValido(Passport) then
        return { ok = false, msg = "Precisas de um atestado médico válido para renovar a carta." }
    end

    -- Taxa de renovação (40% do preço original)
    local Taxa = math.floor(parseInt(Cat.valor) * 0.4)
    if not Functions.PayExam(Passport, Taxa) then
        return { ok = false, msg = "Saldo insuficiente. Taxa de renovação: R$" .. Taxa .. "." }
    end

    local ValidadeAnos = Cat.validadeAnos or 10
    local ValidadeStr  = DataMaisAnos(ValidadeAnos)
    Functions.SetValidade(Passport, Category, ValidadeStr)

    Notify(source, "verde", "Categoria " .. Category .. " renovada até " .. ValidadeStr .. "!")
    return { ok = true, validade = ValidadeStr }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR CARTA DE CONDUÇÃO (item no inventário)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Nota: a base dispara TriggerEvent(Event, source, Passport) - recebemos ambos como argumentos
AddEventHandler("Night_AutoEscola:UsarCarta", function(source, Passport)
    if not source or source <= 0 then return end
    Passport = Passport or Functions.Passport(source)
    if not Passport then return end

    local Categorias = Functions.GetCNH(Passport)
    local Validade   = Functions.GetValidade(Passport)
    local Pontos     = Functions.GetPontos(Passport)
    local Emissao    = DataHoje()
    local Dia, Mes, Ano = Emissao:match("(%d+)/(%d+)/(%d+)")
    local ValidadeGlobal = Dia and (Dia .. "/" .. Mes .. "/" .. tostring(tonumber(Ano) + 10)) or nil

    TriggerClientEvent("Night_AutoEscola:AbrirCarta", source, {
        nome           = Functions.FullName(Passport),
        passaporte     = Passport,
        nascimento     = GetNascimento(Passport),
        categorias     = Categorias,
        validade       = ValidadeGlobal,
        validadePorCat = Validade,
        pontos         = Pontos,
        emissao        = Emissao,
        foto           = Functions.GetAvatar(Passport),
        pais           = pais,
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------
-- /cnh - ver a própria carta
RegisterCommand(comandos.verMinhaCnh.cmd, function(source)
    if source <= 0 then return end
    local Passport = Functions.Passport(source)
    if not Passport then return end
    TriggerClientEvent("Night_AutoEscola:MostrarCNH", source, Functions.GetCNH(Passport), "A minha Carta de Condução", pais)
end, false)

-- Função auxiliar: monta dados completos de um jogador para a polícia
local function BuildPoliciaData(TargetId, TargetPassport)
    local AtestadoTs = Functions.GetAtestadoTs(TargetPassport)
    local Pontos     = Functions.GetPontos(TargetPassport)
    local Validade   = Functions.GetValidade(TargetPassport)

    return {
        ok             = true,
        nome           = Functions.FullName(TargetPassport),
        passaporte     = TargetPassport,
        targetId       = TargetId,
        cnh            = Functions.GetCNH(TargetPassport),
        pontos         = Pontos,
        suspensa       = Pontos >= pontosConfig.maximo,
        validade       = Validade,
        validadePorCat = Validade,
        atestadoValido = AtestadoTs and os.time() < AtestadoTs or false,
        atestadoExpira = AtestadoTs and os.date("%d/%m/%Y", AtestadoTs) or nil,
        nascimento     = GetNascimento(TargetPassport),
        emissao        = DataHoje(),
        foto           = Functions.GetAvatar(TargetPassport),
        pais           = pais,
    }
end

-- Consulta completa via Tunnel (chamado pelo NUI callback polConsultar)
function Server.ConsultarCNH(TargetId)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaConsultarCnh.perms) then
        return { ok = false, msg = "Sem permissão." }
    end
    TargetId = parseInt(TargetId)
    if not TargetId or TargetId <= 0 then return { ok = false, msg = "ID inválido." } end
    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then return { ok = false, msg = "Jogador não encontrado." } end
    return BuildPoliciaData(TargetId, TargetPassport)
end

-- Remover pontos via NUI
function Server.PolRemoverPontos(TargetId, Qty)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaRemoverPontos.perms) then
        return { ok = false, msg = "Sem permissão." }
    end
    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then return { ok = false, msg = "Jogador não encontrado." } end
    Qty = math.max(1, parseInt(Qty))
    local Novos = Functions.RemovePontos(TargetPassport, Qty)
    local TargetSrc = vRP.Source(TargetPassport)
    if TargetSrc then
        Notify(TargetSrc, "amarelo", string.format("Foi perdoado %d ponto(s). Total: %d/%d.", Qty, Novos, pontosConfig.maximo))
    end
    return { ok = true, pontos = Novos, suspensa = Novos >= pontosConfig.maximo }
end

-- Remover categoria via NUI
function Server.PolRemoverCategoria(TargetId, Cat)
    local source   = source
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaRemoverCnh.perms) then
        return { ok = false, msg = "Sem permissão." }
    end
    Cat = tostring(Cat or ""):upper()
    if not config[Cat] then return { ok = false, msg = "Categoria inválida." } end
    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then return { ok = false, msg = "Jogador não encontrado." } end
    local CNH = Functions.GetCNH(TargetPassport)
    if not CNH[Cat] then return { ok = false, msg = "O jogador não tem a categoria " .. Cat .. "." } end
    CNH[Cat] = nil
    Functions.SaveCNH(TargetPassport, CNH)
    local TargetSrc = vRP.Source(TargetPassport)
    if TargetSrc then
        Notify(TargetSrc, "vermelho", "A tua categoria " .. Cat .. " foi removida por autoridade policial.")
    end
    return { ok = true, cnh = CNH }
end

-- /vcnh [passaporte] - abre painel policial com dados do jogador
RegisterCommand(comandos.policiaConsultarCnh.cmd, function(source, args)
    if source <= 0 then return end
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaConsultarCnh.perms) then
        Notify(source, "vermelho", "Sem permissão.")
        return
    end

    local TargetId = parseInt(args[1])

    if not TargetId or TargetId <= 0 then
        -- Abre o painel sem dados (polícia pesquisa dentro)
        TriggerClientEvent("Night_AutoEscola:AbrirPainel", source, { ok = false })
        return
    end

    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then
        Notify(source, "vermelho", "Jogador não encontrado.")
        TriggerClientEvent("Night_AutoEscola:AbrirPainel", source, { ok = false, msg = "Jogador não encontrado." })
        return
    end

    TriggerClientEvent("Night_AutoEscola:AbrirPainel", source, BuildPoliciaData(TargetId, TargetPassport))
end, false)

-- /rcnh [passaporte] [categoria] - polícia remove categoria
RegisterCommand(comandos.policiaRemoverCnh.cmd, function(source, args)
    if source <= 0 then return end
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaRemoverCnh.perms) then
        Notify(source, "vermelho", "Sem permissão.")
        return
    end

    local TargetId = parseInt(args[1])
    local Category = args[2] and tostring(args[2]):upper()
    if not TargetId or not Category then
        Notify(source, "amarelo", "Usa: /" .. comandos.policiaRemoverCnh.cmd .. " [passaporte] [categoria]")
        return
    end

    if not config[Category] then
        Notify(source, "vermelho", "Categoria inválida.")
        return
    end

    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then
        Notify(source, "vermelho", "Jogador não encontrado.")
        return
    end

    local CNH = Functions.GetCNH(TargetPassport)
    if not CNH[Category] then
        Notify(source, "vermelho", "O jogador não tem a categoria " .. Category .. ".")
        return
    end

    CNH[Category] = nil
    Functions.SaveCNH(TargetPassport, CNH)
    Notify(source, "verde", "Categoria " .. Category .. " removida com sucesso.")
    local TargetSrc = vRP.Source(TargetPassport)
    if TargetSrc then
        Notify(TargetSrc, "vermelho", "A tua categoria " .. Category .. " foi removida por autoridade policial.")
    end
end, false)

-- /acnh [passaporte] [categoria] - admin adiciona categoria
RegisterCommand(comandos.policiaAddCnh.cmd, function(source, args)
    if source <= 0 then return end
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaAddCnh.perms) then
        Notify(source, "vermelho", "Sem permissão.")
        return
    end

    local TargetId = parseInt(args[1])
    local Category = args[2] and tostring(args[2]):upper()
    if not TargetId or not Category then
        Notify(source, "amarelo", "Usa: /" .. comandos.policiaAddCnh.cmd .. " [passaporte] [categoria]")
        return
    end

    if not config[Category] then
        Notify(source, "vermelho", "Categoria inválida.")
        return
    end

    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then
        Notify(source, "vermelho", "Jogador não encontrado.")
        return
    end

    local CNH = Functions.GetCNH(TargetPassport)
    if CNH[Category] then
        Notify(source, "vermelho", "O jogador já tem a categoria " .. Category .. ".")
        return
    end

    CNH[Category] = true
    Functions.SaveCNH(TargetPassport, CNH)

    local ValidadeAnos = config[Category].validadeAnos or 10
    local ValidadeStr  = DataMaisAnos(ValidadeAnos)
    Functions.SetValidade(TargetPassport, Category, ValidadeStr)
    Notify(source, "verde", "Categoria " .. Category .. " adicionada com sucesso.")
    
    local TargetSrc = vRP.Source(TargetPassport)
    if TargetSrc then
        Notify(TargetSrc, "verde", "Você recebeu a categoria " .. Category .. " na sua CNH.")
    end
end, false)

-- /rpontos [passaporte] [quantidade] - polícia remove pontos
RegisterCommand(comandos.policiaRemoverPontos.cmd, function(source, args)
    if source <= 0 then return end
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaRemoverPontos.perms) then
        Notify(source, "vermelho", "Sem permissão.")
        return
    end

    local TargetId = parseInt(args[1])
    local Qty      = parseInt(args[2])
    if not TargetId or Qty <= 0 then
        Notify(source, "amarelo", "Usa: /" .. comandos.policiaRemoverPontos.cmd .. " [passaporte] [pontos]")
        return
    end

    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then
        Notify(source, "vermelho", "Jogador não encontrado.")
        return
    end

    local NovosP = Functions.RemovePontos(TargetPassport, Qty)
    local TargetName = Functions.FullName(TargetPassport)
    Notify(source, "verde", TargetName .. " ficou com " .. NovosP .. " ponto(s).")
    local TargetSrc = vRP.Source(TargetPassport)
    if TargetSrc then
        Notify(TargetSrc, "amarelo", string.format("Foi perdoado %d ponto(s). Total: %d/%d.", Qty, NovosP, pontosConfig.maximo))
    end
end, false)

-- /apontos [passaporte] [quantidade] - admin adiciona pontos
RegisterCommand(comandos.policiaAddPontos.cmd, function(source, args)
    if source <= 0 then return end
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaAddPontos.perms) then
        Notify(source, "vermelho", "Sem permissão.")
        return
    end

    local TargetId = parseInt(args[1])
    local Qty      = parseInt(args[2])
    if not TargetId or Qty <= 0 then
        Notify(source, "amarelo", "Usa: /" .. comandos.policiaAddPontos.cmd .. " [passaporte] [pontos]")
        return
    end

    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then
        Notify(source, "vermelho", "Jogador não encontrado.")
        return
    end

    local NovosP = Functions.AddPontos(TargetPassport, Qty)
    Notify(source, "verde", Functions.FullName(TargetPassport) .. " tem agora " .. NovosP .. " ponto(s).")
    local TargetSrc = vRP.Source(TargetPassport)
    if TargetSrc then
        Notify(TargetSrc, "verde", L.pontosAdicionados(Qty, NovosP))
    end
end, false)

-- /rcooldown [passaporte] [categoria] - admin reseta cooldown de uma categoria
RegisterCommand(comandos.resetCooldown.cmd, function(source, args)
    if source <= 0 then return end
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.resetCooldown.perms) then
        Notify(source, "vermelho", "Sem permissão.")
        return
    end

    local TargetId = parseInt(args[1])
    local Category = args[2] and tostring(args[2]):upper()

    if not TargetId or not Category then
        Notify(source, "amarelo", "Usa: /" .. comandos.resetCooldown.cmd .. " [passaporte] [categoria]")
        return
    end

    if not config[Category] then
        Notify(source, "vermelho", "Categoria inválida. Disponíveis: A, B, C, D")
        return
    end

    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then
        Notify(source, "vermelho", "Jogador não encontrado.")
        return
    end

    local Cooldowns = Functions.GetCooldowns(TargetPassport)
    Cooldowns[Category] = nil
    vRP.Query("playerdata/SetData", {
        Passport    = TargetPassport,
        Name        = "autoescola_cooldown",
        Information = json.encode(Cooldowns),
    })

    local Name = Functions.FullName(TargetPassport)
    Notify(source, "verde", L.cooldownReset(Category, Name))
    local TargetSrc = vRP.Source(TargetPassport)
    if TargetSrc then
        Notify(TargetSrc, "verde", L.cooldownNotificado(Category))
    end
end, false)

-- /rcooldowns [passaporte] - admin reseta TODOS os cooldowns do jogador
RegisterCommand(comandos.resetAllCooldowns.cmd, function(source, args)
    if source <= 0 then return end
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.resetAllCooldowns.perms) then
        Notify(source, "vermelho", "Sem permissão.")
        return
    end

    local TargetId = parseInt(args[1])
    if not TargetId or TargetId <= 0 then
        Notify(source, "amarelo", "Usa: /" .. comandos.resetAllCooldowns.cmd .. " [passaporte]")
        return
    end

    local TargetPassport = Functions.TargetPassport(TargetId)
    if not TargetPassport then
        Notify(source, "vermelho", "Jogador não encontrado.")
        return
    end

    vRP.Query("playerdata/SetData", {
        Passport    = TargetPassport,
        Name        = "autoescola_cooldown",
        Information = json.encode({}),
    })

    local Name = Functions.FullName(TargetPassport)
    Notify(source, "verde", L.cooldownsReset(Name))
    local TargetSrc = vRP.Source(TargetPassport)
    if TargetSrc then
        Notify(TargetSrc, "verde", L.cooldownsNotificado)
    end
end, false)

-- Lista de jogadores online para o painel policial
function Server.GetJogadoresOnline()
    local source   = source
    local Passport = Functions.Passport(source)
    if not Functions.HasAnyPermission(Passport, comandos.policiaConsultarCnh.perms) then
        return { ok = false }
    end

    local Lista = {}
    for P, Src in pairs(vRP.Players()) do
        if Src ~= source then
            Lista[#Lista + 1] = {
                source     = Src,
                nome       = Functions.FullName(P),
                passaporte = P,
            }
        end
    end

    table.sort(Lista, function(A, B) return A.source < B.source end)
    return { ok = true, jogadores = Lista }
end

-- Verificar se o jogador tem permissão de admin (usado pelos comandos client-side)
function Server.CheckAdminPerm()
    local source   = source
    local Passport = Functions.Passport(source)
    return Functions.HasAnyPermission(Passport, comandos.gravarRota.perms)
end

-- Limpar sessão ao desconectar
AddEventHandler("playerDropped", function()
    ExameSessoes[source] = nil
end)

function Server.SetDimension(mode)
    local source = source
    if mode then
        exports.vrp:Bucket(source, "Enter", source)
    else
        exports.vrp:Bucket(source, "Exit", 0)
    end
end
