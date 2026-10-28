# Spectrem Director — CBR CITY

Instalação do pacote 2.9.0.7, com interface em português do Brasil e acesso restrito à administração.

## Como abrir

- `/director`: abre ou fecha o painel principal.
- `/tutorial`: abre o tutorial guiado.
- `/camera`: abre os controles de câmera, somente para administradores.
- `/cenas`: abre o reprodutor de cenas.
- `/diretoradmin`: abre a administração das permissões por ferramenta.

Os atalhos padrão F5/F6 foram deixados sem tecla na configuração. A abertura é por comando.

## Permissões

O grupo **Admin do vRP** recebe acesso pela integração `spectrem_vrp_bridge`. A permissão também está disponível para `group.admin` do servidor. Jogadores comuns não têm acesso público à câmera ou ao painel.

A integração verifica mudanças de grupo a cada cinco segundos e remove o acesso quando o personagem sai ou perde a permissão. O comando de console `spectrem_acesso` verifica o acesso dos jogadores conectados sem mostrar identificadores pessoais.

## Interface e integrações

- Idioma padrão: `pt-br`, incluindo o pacote de tradução servido pela interface.
- Cores principais: verde da CBR CITY.
- Editor de aparência: nativo do Director; não exige instalar outro criador de personagem.
- Integração de animações: `WC_EMOTES_V8`.
- Banco: tabelas criadas e atualizadas automaticamente pelo Director usando o oxmysql existente.

Os arquivos protegidos do pacote e sua autorização original foram preservados. Modelos, nomes técnicos de animações e nomes próprios podem manter seus identificadores originais.

## Inicialização

A ordem já está registrada no `server.cfg`, após os resources da base:

    ensure spectrem_vrp_bridge
    ensure spectrem_director

As permissões ACE e `sv_enableNetEventReassembly` também estão no arquivo. Não é necessário importar manualmente o SQL de emergência do pacote.

## Conferência no jogo

Entre com um personagem do grupo Admin, use `/director` e confira os menus em português. Teste uma câmera, uma animação e uma cena salva. Uma conta comum deve receber a mensagem de acesso negado.

O servidor confirmou a inicialização do recurso e a preparação das tabelas. A validação visual e das ferramentas nativas deve ser feita dentro do FiveM.
