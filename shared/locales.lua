--[[
    SHARED LOCALES
    Traduções do celular
]]

Locales = {}

Locales['pt'] = {
    -- General
    phone = 'Telefone',
    close = 'Fechar',
    back = 'Voltar',
    save = 'Salvar',
    cancel = 'Cancelar',
    confirm = 'Confirmar',
    delete = 'Excluir',
    search = 'Buscar',
    send = 'Enviar',
    loading = 'Carregando...',
    error = 'Erro',
    success = 'Sucesso',
    
    -- Phone
    favorites = 'Favoritos',
    recent = 'Recentes',
    contacts = 'Contatos',
    keypad = 'Teclado',
    calling = 'Chamando...',
    incoming_call = 'Chamada recebida',
    call_ended = 'Chamada encerrada',
    missed_call = 'Chamada perdida',
    no_phone = 'Você não tem um celular!',
    
    -- Messages
    messages = 'Mensagens',
    new_message = 'Nova Mensagem',
    no_messages = 'Nenhuma mensagem',
    type_message = 'Digite uma mensagem',
    message_sent = 'Mensagem enviada',
    
    -- Contacts
    add_contact = 'Adicionar Contato',
    contact_name = 'Nome',
    contact_number = 'Número',
    contact_added = 'Contato adicionado!',
    no_contacts = 'Nenhum contato',
    
    -- Chirper
    chirper = 'Chirper',
    whats_happening = 'O que está acontecendo?',
    tweet = 'Tweetar',
    no_tweets = 'Nenhum tweet ainda',
    for_you = 'Para você',
    following = 'Seguindo',
    
    -- Pictura
    pictura = 'Pictura',
    new_post = 'Nova Publicação',
    your_story = 'Seu story',
    no_posts = 'Nenhuma publicação',
    likes = 'curtidas',
    
    -- Flamer
    flamer = 'Flamer',
    its_a_match = "It's a Match!",
    no_profiles = 'Ninguém por perto',
    about_me = 'Sobre mim',
    matches = 'Matches',
    
    -- Bank
    bank = 'Banco',
    balance = 'Saldo Disponível',
    deposit = 'Depositar',
    withdraw = 'Sacar',
    transfer = 'Transferir',
    history = 'Histórico',
    wallet = 'Carteira',
    insufficient_funds = 'Saldo insuficiente!',
    transfer_success = 'Transferência realizada!',
    
    -- Services
    taxi = 'Táxi',
    mechanic = 'Mecânico',
    police = 'LSPD',
    ambulance = 'EMS',
    service_called = 'Serviço chamado!',
    emergency = 'Emergência',
    
    -- Camera
    camera = 'Câmera',
    gallery = 'Fotos',
    photo_saved = 'Foto salva!',
    
    -- Settings
    settings = 'Ajustes',
    airplane_mode = 'Modo Avião',
    wifi = 'Wi-Fi',
    bluetooth = 'Bluetooth',
    notifications = 'Notificações',
    dark_mode = 'Modo Escuro',
    wallpaper = 'Papel de Parede',
    
    -- Notes
    notes = 'Notas',
    new_note = 'Nova Nota',
    no_notes = 'Nenhuma nota',
    
    -- Weather
    weather = 'Clima',
    sunny = 'Ensolarado',
    cloudy = 'Nublado',
    rainy = 'Chuvoso'
}

Locales['en'] = {
    phone = 'Phone',
    close = 'Close',
    back = 'Back',
    save = 'Save',
    cancel = 'Cancel',
    -- Add more English translations...
}

-- Get translation
function _U(key, ...)
    local locale = Config.Locale or 'pt'
    if Locales[locale] and Locales[locale][key] then
        return string.format(Locales[locale][key], ...)
    end
    return key
end

-- Export
_G._U = _U
_G.Locales = Locales
