# Integração do Night_Capinhas com o lb-phone

Este documento explica todas as alterações necessárias para o sistema `Night_Capinhas` funcionar com o `lb-phone`.

> Este guia foi escrito para quem vai aplicar a integração manualmente. Faça uma cópia de segurança dos arquivos antes de começar. Não apague outras personalizações existentes no seu `lb-phone`.

## Como a integração funciona

O `Night_Capinhas` salva o nome do prop equipado nos dados do jogador. Por exemplo:

```text
bunnywish
```

Quando o jogador equipa uma capinha, esse nome é colocado no state bag `PhoneCase`. O state bag é uma informação sincronizada entre servidor e cliente.

O fluxo completo fica assim:

```text
Jogador equipa uma capinha
        ↓
Night_Capinhas salva a escolha
        ↓
State bag PhoneCase recebe o nome do prop
        ↓
lb-phone lê o PhoneCase ao criar o celular
        ↓
Servidor valida se o prop existe no catálogo
        ↓
lb-phone cria e anexa a capinha na mão do jogador
```

Se nenhuma capinha estiver equipada, o `lb-phone` continua usando normalmente o modelo definido em `Config.PhoneModel` ou o prop padrão `prop_amb_phone`.

## Antes de começar

Confirme os seguintes pontos:

- Os recursos precisam se chamar exatamente `Night_Capinhas` e `lb-phone`.
- Os props listados em `Config.Cases` precisam estar streamados no servidor.
- A versão do `Night_Capinhas` precisa possuir `Config.Attach` e `Config.PropAttach`.
- Faça backup dos cinco arquivos que serão modificados.
- Não substitua um arquivo inteiro se ele possuir outras modificações próprias; aplique somente os trechos indicados.

## O que a integração faz

- Usa no `lb-phone` o prop da capinha equipada.
- Atualiza o celular imediatamente ao equipar ou remover uma capinha.
- Restaura a capinha salva quando o jogador conecta.
- Mantém a criação server-side do prop protegida por validação.
- Usa a posição e a rotação configuradas no `Night_Capinhas`.
- Mantém a rotação original do `lb-phone` quando nenhuma capinha está equipada.

## Arquivos modificados

```text
Night_Capinhas/client/main.lua
Night_Capinhas/server/main.lua
lb-phone/client/custom/functions/animations.lua
lb-phone/server/custom/functions/entities.lua
lb-phone/fxmanifest.lua
```

---

## 1. Night_Capinhas/client/main.lua

Localize o export `PhoneProps` e substitua por:

```lua
exports("PhoneProps", function()
    return {
        -- Props considerados celulares padrão.
        defaults = DefaultPhones,

        -- Props cadastrados como capinhas válidas.
        cases = CaseProps,

        -- Posição e rotação usadas para anexar a capinha na mão.
        attach = {
            default = Config.Attach,
            props = Config.PropAttach
        }
    }
end)
```

Esse export fornece ao `lb-phone` a lista de capinhas permitidas e os offsets de posição e rotação.

---

## 2. Night_Capinhas/server/main.lua

Depois deste trecho:

```lua
for _, Case in ipairs(Config.Cases) do
    Cases[Case.prop] = Case
end
```

Adicione:

```lua
exports("IsPhoneCase", function(Model)
    -- O lb-phone envia o hash numérico quando cria o objeto no servidor.
    if type(Model) == "number" then
        for Prop in pairs(Cases) do
            if GetHashKey(Prop) == Model then
                return true
            end
        end

        return false
    end

    -- Também aceita o nome textual do prop para outras integrações.
    return type(Model) == "string" and Cases[Model] ~= nil
end)
```

Esse export permite que o servidor do `lb-phone` confirme se o modelo solicitado pertence ao catálogo de capinhas.

Antes do evento `Disconnect`, adicione:

```lua
AddEventHandler("Connect", function(Passport, Source)
    -- Recupera a capinha que ficou salva para este personagem.
    local Data = GetData(Passport)

    -- Replica a capinha para o cliente. Usa false quando não há capinha.
    Player(Source).state:set("PhoneCase", Data.equipped or false, true)
end)
```

O final do arquivo deve ficar parecido com:

```lua
AddEventHandler("Connect", function(Passport, Source)
    local Data = GetData(Passport)
    Player(Source).state:set("PhoneCase", Data.equipped or false, true)
end)

AddEventHandler("Disconnect", function(Passport)
    Busy[Passport] = nil
end)
```

---

## 3. lb-phone/client/custom/functions/animations.lua

Depois desta linha:

```lua
local textureVariation
```

Adicione:

```lua
local function GetPhoneModel()
    -- Lê a capinha sincronizada pelo servidor do Night_Capinhas.
    local phoneCase = LocalPlayer.state.PhoneCase

    -- Sem capinha ou sem o recurso iniciado: mantém o celular normal.
    if type(phoneCase) ~= "string" or GetResourceState("Night_Capinhas") ~= "started" then
        return phoneModel, nil
    end

    -- pcall evita quebrar o lb-phone se o export não estiver disponível.
    local success, props = pcall(function()
        return exports["Night_Capinhas"]:PhoneProps()
    end)

    -- Confirma que o prop recebido realmente pertence ao catálogo.
    if not success
        or type(props) ~= "table"
        or type(props.cases) ~= "table"
        or not props.cases[phoneCase]
    then
        return phoneModel, nil
    end

    local caseModel = GetHashKey(phoneCase)

    -- Evita tentar criar um modelo inexistente ou que não foi streamado.
    if not IsModelValid(caseModel) then
        return phoneModel, nil
    end

    -- Procura primeiro um ajuste específico para a capinha.
    -- Quando não existe, utiliza o Config.Attach padrão.
    local attach = props.attach and props.attach.default or nil
    local customAttach = props.attach
        and props.attach.props
        and props.attach.props[phoneCase]
        or nil

    -- Retorna o modelo da capinha e a transformação que será usada na mão.
    return caseModel, {
        pos = customAttach and customAttach.pos or attach and attach.pos,
        rot = customAttach and customAttach.rot or attach and attach.rot
    }
end
```

### Alterações dentro de CreatePhone

Dentro da função `CreatePhone()`, depois de:

```lua
local playerPed = PlayerPedId()
local coords = GetEntityCoords(playerPed, false)
```

Adicione:

```lua
local objectModel, caseAttach = GetPhoneModel()

-- Estes valores continuam sendo usados pelo celular normal do lb-phone.
local objectOffset = offset
local objectRotation = rotation

-- Uma capinha usa os valores de Config.Attach/Config.PropAttach.
if caseAttach then
    local casePos = caseAttach.pos or { 0.0, 0.0, 0.0 }
    local caseRot = caseAttach.rot or { 0.0, 0.0, 0.0 }

    objectOffset = vector3(casePos[1], casePos[2], casePos[3])
    objectRotation = vector3(caseRot[1], caseRot[2], caseRot[3])
end
```

Nas duas verificações de modelo da função, troque:

```lua
IsModelValid(phoneModel)
```

Por:

```lua
IsModelValid(objectModel)
```

Troque:

```lua
local netId = AwaitCallback("createPhoneObject", phoneModel)
```

Por:

```lua
local netId = AwaitCallback("createPhoneObject", objectModel)
```

No modo de criação client-side, troque:

```lua
LoadModel(phoneModel)
phone = CreateObject(phoneModel, coords.x, coords.y, coords.z, true, true, true)
```

Por:

```lua
LoadModel(objectModel)
phone = CreateObject(objectModel, coords.x, coords.y, coords.z, true, true, true)
```

Substitua o `AttachEntityToEntity` da função por:

```lua
AttachEntityToEntity(
    phone,
    playerPed,
    GetPedBoneIndex(playerPed, 28422),
    objectOffset.x,
    objectOffset.y,
    objectOffset.z,
    objectRotation.x,
    objectRotation.y,
    objectRotation.z,
    false,
    false,
    false,
    false,
    2,
    true
)
```

Troque o descarregamento do modelo:

```lua
SetModelAsNoLongerNeeded(phoneModel)
```

Por:

```lua
SetModelAsNoLongerNeeded(objectModel)
```

### Atualização imediata da capinha

Logo depois da função `DeletePhone()`, adicione:

```lua
AddStateBagChangeHandler("PhoneCase", nil, function(bagName)
    -- Descobre qual jogador teve o state bag alterado.
    local player = GetPlayerFromStateBagName(bagName)

    -- Ignora outros jogadores e celulares que ainda não foram criados.
    if player ~= PlayerId() or not DoesEntityExist(phone) then
        return
    end

    CreateThread(function()
        -- Aguarda um frame para LocalPlayer.state receber o valor mais recente.
        Wait(0)

        -- Remove o prop antigo e cria imediatamente o novo.
        DeletePhone()
        CreatePhone()
    end)
end)
```

---

## 4. lb-phone/server/custom/functions/entities.lua

Corrija o nome do prop padrão.

Troque:

```lua
[`prop_amp_phone`] = true,
```

Por:

```lua
[`prop_amb_phone`] = true,
```

Depois da tabela `allowedModels`, adicione:

```lua
local function IsAllowedPhoneModel(model)
    -- Primeiro permite os modelos já cadastrados pelo próprio lb-phone.
    if allowedModels[model] then
        return true
    end

    -- Não aceita modelos externos se o sistema de capinhas estiver desligado.
    if GetResourceState("Night_Capinhas") ~= "started" then
        return false
    end

    -- Pergunta ao Night_Capinhas se o modelo pertence ao catálogo.
    local success, isPhoneCase = pcall(function()
        return exports["Night_Capinhas"]:IsPhoneCase(model)
    end)

    -- Só autoriza quando o export executa corretamente e retorna true.
    return success and isPhoneCase == true
end
```

No callback `createPhoneObject`, troque:

```lua
if not allowedModels[model] then
```

Por:

```lua
if not IsAllowedPhoneModel(model) then
```

No evento `phone:failedControl`, troque:

```lua
if entityModel and allowedModels[entityModel] then
```

Por:

```lua
if entityModel and IsAllowedPhoneModel(entityModel) then
```

---

## 5. lb-phone/fxmanifest.lua

Depois de:

```lua
dependency "oxmysql"
```

Adicione:

```lua
dependency "Night_Capinhas"
```

Isso garante que o `Night_Capinhas` esteja iniciado antes do `lb-phone`.

Sem essa dependência, o LB poderia iniciar primeiro e tentar consultar exports que ainda não estão disponíveis.

---

## Configuração de posição e rotação

As capinhas usam os valores encontrados em `Night_Capinhas/config.lua`:

```lua
Config.Attach = {
    bone = 28422,
    pos = { 0.0, 0.0, 0.0 },
    rot = { 0.0, 0.0, 0.0 }
}
```

É possível configurar uma capinha individualmente em `Config.PropAttach`:

```lua
Config.PropAttach = {
    ["bunnywish"] = {
        pos = { 0.012, 0.003, -0.045 },
        rot = { 0.0, 0.0, 0.0 }
    }
}
```

Caso outro modelo fique desalinhado, adicione o nome dele em `Config.PropAttach` e ajuste `pos` e `rot`.

---

## Instalação e reinício

Confirme que os nomes das pastas são exatamente:

```text
Night_Capinhas
lb-phone
```

Depois de substituir os arquivos ou aplicar as alterações, execute no console do servidor:

```cfg
restart Night_Capinhas
restart lb-phone
```

Também é possível reiniciar o servidor por completo.

## Teste recomendado

1. Entre no servidor.
2. Abra a loja de capinhas.
3. Equipe uma capinha.
4. Abra o `lb-phone` e confira o prop na mão.
5. Remova a capinha e confirme que o prop padrão voltou.
6. Reconecte ao servidor e confirme que a capinha equipada foi restaurada.

## Problemas comuns

### O celular continua usando o modelo padrão

- Confirme que `Night_Capinhas` está iniciado.
- Confira se o nome do recurso não foi alterado.
- Verifique se a capinha está presente em `Config.Cases`.
- Confira se o prop foi instalado e streamado corretamente.

### O servidor mostra que o modelo não é permitido

O servidor não encontrou o prop no catálogo. Confirme se o mesmo nome usado no arquivo do prop está cadastrado em `Config.Cases`.

### A capinha aparece invertida ou fora da mão

Adicione um ajuste individual em `Config.PropAttach`. Exemplo:

```lua
Config.PropAttach = {
    ["nome_do_prop"] = {
        pos = { 0.0, 0.0, 0.0 },
        rot = { 0.0, 0.0, 0.0 }
    }
}
```

Os três valores de `pos` controlam os eixos X, Y e Z. Os três valores de `rot` controlam a rotação X, Y e Z em graus. Faça alterações pequenas, reinicie os recursos e teste novamente.

### A capinha só aparece depois de abrir novamente o telefone

Confira se o `AddStateBagChangeHandler("PhoneCase", ...)` foi colocado depois da função `DeletePhone()`. Esse trecho é responsável por recriar o objeto imediatamente.

### A capinha não volta depois de reconectar

Confira se o evento `Connect` foi adicionado ao `Night_Capinhas/server/main.lua` e se a base utiliza os parâmetros `Passport, Source` nessa ordem.
