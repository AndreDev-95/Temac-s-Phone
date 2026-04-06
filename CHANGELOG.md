# Temac Phone - Changelog

## Beta

### feat(core)
- proteção contra spam ao abrir o celular
- sistema de estado global (PhoneCore)
- sistema de loading global com busy state
- proteção de ações (action guard)
- fila de ações (queue system)
- sistema de eventos (event bus)
- lifecycle de apps
- tratamento global de erros
- notificações globais
- sincronização client-server
- memória temporária de sessão
- preload de apps
- permissões por app

### feat(messages)
- base de conversas em tempo real
- abertura de conversa dedicada
- typing state entre jogadores
- envio com notificação e integração com lifecycle

### feat(chirper)
- perfil básico de utilizador
- pesquisa por hashtag/texto
- retorno de feed filtrado para a UI

### feat(bank)
- overview rápido do saldo
- histórico/resumo inicial no app
- atualização de balance ao abrir overview

### style(ui)
- tratamento visual de estado busy
- resumo bancário na interface
- placeholders e comportamento mais próximo de iPhone

### feat(messages-v1.1)
- persistência ajustada para Qbox usando `citizenid` + número do `charinfo.phone`
- envio sincronizado para emissor e recetor sem duplicar mensagens na UI
- conversa dedicada agora recarrega do servidor e marca lidas ao abrir
- entrega offline mantida por DB ao reabrir o telefone
- queries otimizadas para unread e histórico recente
