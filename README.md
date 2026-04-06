# FiveM Phone - iPhone 15

Script de celular estilo iPhone 15 para FiveM com todas as funcionalidades e aplicativos.

## Funcionalidades

### Apps do Sistema (Sempre Disponiveis)
- **Telefone** - Ligacoes, contatos, teclado numerico
- **Mensagens** - SMS entre jogadores
- **Contatos** - Gerenciamento de contatos
- **Camera** - Fotos (requer screenshot-basic)
- **Fotos** - Galeria de imagens
- **Ajustes** - Configuracoes (modo escuro, wallpaper)
- **App Store** - Loja para baixar apps

### Apps da Loja (Desabilitados por padrao)
- **Twitter** - Rede social com tweets, likes, retweets
- **Instagram** - Feed de fotos, stories, likes, follows
- **Tinder** - App de relacionamentos com swipe, matches, mensagens
- **Maze Bank** - App bancario com deposito, saque, transferencia
- **Calculadora** - Calculadora estilo iOS
- **Notas** - Bloco de notas
- **Clima** - Tempo integrado com o clima do jogo
- **Mapas** - GPS com waypoints predefinidos
- **Email** - Sistema de emails
- **LS Taxi** - Chamar taxi
- **LS Mechanic** - Chamar mecanico
- **LSPD** - Emergencia policial 911
- **EMS** - Emergencia medica
- **Musica** - Player de musica
- **YouTube** - App de videos

## Compatibilidade

| Framework | Status |
|-----------|--------|
| ESX Legacy | Compativel |
| QBCore | Compativel |
| vRP | Compativel |
| Standalone | Compativel |

## Instalacao

1. Copie a pasta `fivem-phone` para a pasta `resources` do seu servidor
2. Execute o arquivo `install.sql` no seu banco de dados MySQL
3. Configure o `shared/config.lua` com sua framework
4. Adicione `ensure fivem-phone` ao `server.cfg`

## Configuracao

Edite `shared/config.lua`:

```lua
Config.Framework = 'auto' -- 'esx', 'qbcore', 'vrp', 'standalone'
Config.OpenKey = 'F1'     -- Tecla para abrir o celular
```

## Dependencias

- **oxmysql** - Queries ao banco de dados
- **screenshot-basic** (opcional) - Para funcao de camera

## Arquitetura

```
fivem-phone/
├── fxmanifest.lua       -- Manifest do resource
├── install.sql          -- Schema do banco
├── shared/              -- Configs compartilhados
│   ├── config.lua       -- Configuracoes globais
│   ├── functions.lua    -- Funcoes utilitarias
│   └── locales.lua      -- Traducoes
├── client/              -- Client-side Lua
│   ├── main.lua         -- Controle principal
│   ├── framework.lua    -- Bridge ESX/QBCore/vRP
│   ├── nui.lua          -- NUI Callbacks
│   └── apps/            -- Modulos por app
├── server/              -- Server-side Lua
│   ├── main.lua         -- Controle principal
│   ├── framework.lua    -- Bridge de framework
│   ├── database.lua     -- Init do banco
│   └── apps/            -- Modulos por app
└── html/                -- Interface NUI
    ├── index.html       -- Layout principal
    ├── css/style.css    -- Estilos
    ├── js/app.js        -- Logica JavaScript
    └── preview*.html    -- Arquivos de teste
```

## Banco de Dados

Tabelas criadas automaticamente:
- `phone_contacts` - Contatos
- `phone_messages` - Mensagens SMS
- `phone_calls` - Historico de chamadas
- `phone_twitter` - Tweets
- `phone_twitter_likes` - Likes do Twitter
- `phone_instagram` - Posts do Instagram
- `phone_instagram_stories` - Stories
- `phone_instagram_follows` - Seguidores
- `phone_tinder_profiles` - Perfis do Tinder
- `phone_tinder_swipes` - Swipes
- `phone_tinder_matches` - Matches
- `phone_tinder_messages` - Mensagens do Tinder
- `phone_gallery` - Galeria de fotos
- `phone_notes` - Notas
- `phone_emails` - Emails
- `phone_installed_apps` - Apps instalados (AppStore)

## AppStore

Os apps vem **desabilitados por padrao**. O jogador precisa abrir a App Store e baixar cada app individualmente. Os apps instalados sao salvos no banco de dados e persistem entre sessoes.

## Licenca

Projeto desenvolvido para uso em servidores FiveM.

## Atualizações

### Beta
- Corrigido o app Chirper/Twitter.
- Ajustado o carregamento inicial para enviar os dados no canal correto (`chirper`).
- Corrigidas incompatibilidades entre banco e código (`chirp_id` / `tweet_id`, `rechirps` / `retweets`).
- Corrigido o evento NUI de rechirp e o recebimento de novos chirps na interface.

- Beta: visual do celular refinado para um estilo iPhone mais realista (lockscreen com atalhos, dock glassmorphism, Dynamic Island aprimorada, busca na home e wallpaper aplicado também na tela de bloqueio).

- Beta: adicionados ícones com acabamento no padrão iOS 18, Central de Controle com atalhos e sliders, e desbloqueio por swipe mais próximo do iPhone real.

### Commit
```bash
feat(lockscreen): adiciona animação Face ID estilo iPhone

- adiciona overlay visual do Face ID na lockscreen
- adiciona animação de scan e confirmação de desbloqueio
- inicia autenticação automática ao abrir o celular
- mantém swipe up como fallback manual
```

- Beta: adicionada animação de Face ID na lockscreen, com scan automático e confirmação visual antes de abrir a home.


## Atualizações recentes

### Core
- Anti-spam de abertura
- State manager
- Loading manager
- Action guard
- Queue system
- Event bus
- Lifecycle manager
- Error handler
- Notification manager
- Sync system
- Session memory
- Preload
- Permissions

### Messages
- Base de conversas em tempo real
- Typing state
- Abertura dedicada de conversa
- Integração com lifecycle/loading

### Chirper
- Perfil básico
- Pesquisa por hashtag/texto
- Feed filtrado

### Bank
- Overview rápido
- Resumo inicial dentro do app

### UI
- Busy state visual
- Melhorias de UX em mensagens e banco

- Beta: Messages v1.1 com persistência por número de telefone, entrega offline via banco, sync em tempo real para emissor/recetor e conversa dedicada atualizada ao vivo.
