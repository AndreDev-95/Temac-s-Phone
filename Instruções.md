# Instruções - Temac Phone Chirper v1.1

## O que foi atualizado
- likes persistentes por `citizenid`
- rechirps persistentes por `citizenid`
- comentários por chirp
- replies com contexto do chirp original
- resumo de perfil no topo do feed
- feed sincronizado para todos os jogadores online após ações no Chirper

## Passos manuais
1. Substitui os ficheiros deste ZIP na tua resource do `temac-phone`.
2. Executa o bloco final do `install.sql` no teu MySQL/oxmysql para criar as novas tabelas do Chirper e adicionar a coluna `reply_to`.
3. Reinicia a resource.

## Nota
- Mantive o fluxo do teu projeto em `citizenid` + `oxmysql`.
- O feed agora recalcula likes, comentários e rechirps com base nas tabelas dedicadas.
- O botão de comentário usa resposta rápida por prompt na UI atual, sem exigir alteração do HTML base.
