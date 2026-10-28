# Importação de produção para desenvolvimento — 28/10/2026

As mudanças abaixo foram aplicadas em `D:\CBRCity` e no MySQL local. Produção foi acessada somente para leitura.

## Aplicado

- **Props:** cadastro “Tela aero”, ID 2, modelo `vw_prop_vw_cinema_tv_01`, posição (-215.496719, -1345.471802, 31.919300), heading 269.269424.
- **Spectrem Director:** seis regras ACE adicionadas ao `server/server.cfg` para `group.admin`, `group.spectrem_vrp` e `resource.spectrem_vrp_bridge`.
- **Portas:** cinco portas da Bennys na tabela `doors`, IDs 3 a 7.
- **Mecânicas:** dez pontos da Bennys, IDs 15 a 23 e 25, substituindo os 14 pontos padrão de `lscustoms`. Foi confirmado que os pontos locais removidos eram idênticos ao SQL original do projeto.
- **Grupo:** Families, ID local 69. Os outros 48 grupos permaneceram intactos; nenhum membro de grupo foi importado.
- **Migração:** `database/Atualizacao_producao_2026-10-28.sql` permite aplicar os cadastros após o SQL inicial em outra instalação. Neste desenvolvimento, a importação já foi executada com verificações adicionais e transação.

## Preservado

- As 23 alterações locais preexistentes restantes, incluindo melhorias de ATMs, roubos, casas e a correção de `kq_jobcontracts`. A única alteração local preexistente atualizada nesta importação foi `data/props.json`, que recebeu o novo prop.
- Os 309 arquivos que existem somente no desenvolvimento, incluindo fontes de interfaces e os módulos novos do painel.
- Credenciais, conexões, chaves, limites e identificação do desenvolvimento. A única mudança no `server.cfg` foram as seis regras ACE.
- Agendamentos locais de expiração de benefícios em `crons/config.json` e a URL local do upload do telefone.
- Contas, personagens, inventários, saldos, veículos de jogadores, membros de grupos e teleportes pessoais não foram importados.

## Verificação

- Inventário completo de 17.925 entradas de arquivos em produção, sem erros de listagem ao final.
- Comparação por conteúdo das 2.285 entradas de scripts/configurações dos recursos. `Utils.lua` e `utils.lua` de produção têm conteúdo idêntico; a grafia local foi mantida.
- Demais diferenças de código correspondem às melhorias locais preservadas ou a dados de execução/ambiente mantidos localmente.
- Importação SQL em transação, com guarda contra alterações concorrentes e verificação antes do COMMIT. Coordenadas FLOAT usam tolerância de 0,001 para respeitar a precisão do MySQL.
- Segunda consulta independente confirmou 27 tabelas: `doors=5`, `lscustoms=10`, `groups=49`. As outras 24 tabelas de configuração permaneceram iguais ao backup.
- JSON de props conferido contra produção, sintaxe JavaScript da interface e verificação de whitespace do Git aprovadas.

## Limites

Foram baixadas 3.493 entradas para comparação de conteúdo, incluindo todos os scripts/configurações. O FTP apresentou timeouts recorrentes nas portas de dados e não ofereceu checksum. Parte dos mapas, modelos e imagens foi conferida por caminho/tamanho, sem comparação integral dos bytes. Nenhuma diferença de tamanho foi identificada nesses binários; eles foram mantidos localmente.

Não houve reinicialização nem validação visual dentro do FiveM. Reinicie o servidor de desenvolvimento para carregar os novos cadastros e permissões.

## Backup e reversão

Arquivo: `backup-antes-importacao-producao-2026-10-28.zip`.

- `archive/files/`: arquivos locais anteriores à importação.
- `archive/database/local-catalogs.json`: snapshot anterior das 27 tabelas consultadas.
- `archive/database/rollback-guarded.sql`: reversão das três tabelas alteradas, com guarda de estado e transação.
- `archive/database/verification.json`: resultado da conferência posterior.
- `archive/audit/`: inventário e resultados da comparação dos arquivos.
- `archive/manifest.json`: hashes SHA-256 dos arquivos do backup.

O backup inclui a configuração local do servidor e deve permanecer em armazenamento privado.
