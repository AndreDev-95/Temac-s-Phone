# Instruções - Temac Phone Messages v1.1

## O que foi atualizado
- persistência correta das mensagens usando o número do personagem (`charinfo.phone`)
- ownership/contacts continuam ligados ao `citizenid`
- envio em tempo real para emissor e recetor
- conversa dedicada sincronizada com o servidor
- mensagens offline continuam disponíveis ao reabrir o telefone
- marcação de lidas ao abrir a conversa

## Passos manuais
1. Substitui os ficheiros deste ZIP na tua resource do `temac-phone`.
2. Executa o bloco final do `install.sql` no teu MySQL/oxmysql para aplicar o upgrade de `phone_messages`.
3. Reinicia a resource.

## Nota
O código foi ajustado para o fluxo que confirmaste:
- framework/Qbox via QBCore bridge
- identificador principal: `citizenid`
- mensagens roteadas pelo número de telefone do `charinfo.phone`
