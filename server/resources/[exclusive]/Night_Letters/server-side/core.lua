-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("night_letters/AddLetter", "INSERT INTO night_letters (sender_id, receiver_id, subject, message, date, timestamp) VALUES (@sender_id, @receiver_id, @subject, @message, @date, @timestamp)")
vRP.Prepare("night_letters/GetReceived", "SELECT * FROM night_letters WHERE receiver_id = @Passport AND deleted_receiver = 0 ORDER BY id DESC")
vRP.Prepare("night_letters/GetSent", "SELECT * FROM night_letters WHERE sender_id = @Passport AND deleted_sender = 0 ORDER BY id DESC")
vRP.Prepare("night_letters/DeleteReceived", "UPDATE night_letters SET deleted_receiver = 1 WHERE id = @id AND receiver_id = @Passport")
vRP.Prepare("night_letters/DeleteSent", "UPDATE night_letters SET deleted_sender = 1 WHERE id = @id AND sender_id = @Passport")
vRP.Prepare("night_letters/DeleteAll", "DELETE FROM night_letters")
vRP.Prepare("night_letters/GetLetter", "SELECT * FROM night_letters WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITIALIZE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    if not Config.disableAutoCleaner then
        local currentDay = os.date("*t").wday
        if currentDay == Config.letterResetDay then
            vRP.Query("night_letters/DeleteAll")
            Println("Limpando todas as cartas (Dia de limpeza)")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Night.sendRomanticMail(data)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local targetPassport = tonumber(data.passaport)
    local subject = data.subject
    local message = data.message

    if not targetPassport or not subject or not message then return end

    -- Check if target exists
    local targetSource = vRP.Source(targetPassport)
    local targetIdentity = vRP.Identity(targetPassport)
    
    if not targetIdentity then
        TriggerClientEvent("Notify", source, "Erro", "Passaporte não encontrado.", "vermelho", 5000)
        return { success = false }
    end

    -- Check price
    if Config.letterPrice and Config.letterPrice > 0 then
        if not vRP.PaymentFull(Passport, Config.letterPrice) then
            TriggerClientEvent("Notify", source, "Erro", "Dinheiro insuficiente.", "vermelho", 5000)
            return { success = false }
        end
    end

    local date = os.date("%d/%m/%Y")
    local timestamp = os.time()
    vRP.Query("night_letters/AddLetter", {
        sender_id = Passport,
        receiver_id = targetPassport,
        subject = subject,
        message = message,
        date = date,
        timestamp = timestamp
    })

    TriggerClientEvent("Notify", source, "Sucesso", "Carta enviada com sucesso para "..targetIdentity.Name.." "..targetIdentity.Lastname..".", "verde", 5000)
    
    if targetSource then
        TriggerClientEvent("Notify", targetSource, "Atenção", "Você recebeu um novo correio romântico.", "amarelo", 5000)
        if Config.showLetterOverlay then
            -- Optional: Show overlay to target
            Client.showOverlay(targetSource)
        end
    end

    return { success = true }
end

function Night.getLetters()
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local received = vRP.Query("night_letters/GetReceived", { Passport = Passport })
    local sent = vRP.Query("night_letters/GetSent", { Passport = Passport })

    local formattedReceived = {}
    for _, letter in ipairs(received) do
        local senderIdentity = vRP.Identity(letter.sender_id)
        table.insert(formattedReceived, {
            subject = letter.subject,
            date = letter.date,
            sender = {
                name = senderIdentity and (senderIdentity.Name.." "..senderIdentity.Lastname) or "Desconhecido",
                id = letter.sender_id
            },
            letterIndex = letter.id,
            message = letter.message
        })
    end

    local formattedSent = {}
    for _, letter in ipairs(sent) do
        local receiverIdentity = vRP.Identity(letter.receiver_id)
        table.insert(formattedSent, {
            subject = letter.subject,
            date = letter.date,
            sender = {
                name = receiverIdentity and (receiverIdentity.Name.." "..receiverIdentity.Lastname) or "Desconhecido",
                id = letter.receiver_id
            },
            letterIndex = letter.id,
            message = letter.message
        })
    end

    return { received = formattedReceived, sent = formattedSent }
end

function Night.deleteLetter(data)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local letterId = data.index
    if not letterId then return end

    vRP.Query("night_letters/DeleteReceived", { id = letterId, Passport = Passport })
    vRP.Query("night_letters/DeleteSent", { id = letterId, Passport = Passport })

    return true
end

function Night.getLastLetter()
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local letters = vRP.Query("night_letters/GetReceived", { Passport = Passport })
    if letters and letters[1] then
        local lastLetter = letters[1]
        local timeout = Config.lastLetterTimeout or 1
        local currentTime = os.time()
        local letterTimestamp = tonumber(lastLetter.timestamp) or 0
        
        -- Se não houver timestamp (0), permitimos abrir para compatibilidade, 
        -- caso contrário verificamos o timeout.
        if letterTimestamp == 0 or (currentTime - letterTimestamp) <= (timeout * 60) then
            local senderIdentity = vRP.Identity(lastLetter.sender_id)
            return {
                subject = lastLetter.subject,
                date = lastLetter.date,
                sender = {
                    name = senderIdentity and (senderIdentity.Name.." "..senderIdentity.Lastname) or "Desconhecido",
                    id = lastLetter.sender_id
                },
                letterIndex = lastLetter.id,
                message = lastLetter.message
            }
        end
    end

    return false
end

function Night.openPanel()
    local source = source
    local letters = Night.getLetters()
    return letters
end
