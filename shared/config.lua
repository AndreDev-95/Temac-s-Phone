--[[
    SHARED CONFIG
    Configurações globais do celular
]]

Config = {}

-- ============================================
-- FRAMEWORK
-- ============================================
Config.Framework = 'auto' -- 'auto', 'esx', 'qbcore', 'vrp', 'standalone'

-- ============================================
-- GENERAL
-- ============================================
Config.OpenKey = 'K'
Config.PhoneModel = 'iphone15'
Config.DefaultWallpaper = 'wallpaper1'
Config.Locale = 'pt'

-- Phone Item
Config.RequireItem = false
Config.PhoneItem = 'phone'

-- ============================================
-- NOTIFICATIONS
-- ============================================
Config.Notifications = {
    enabled = true,
    sound = true,
    vibration = true,
    duration = 3000
}

-- ============================================
-- APPS - SYSTEM (Always installed)
-- ============================================
Config.SystemApps = {
    phone       = { name = 'Telefone',     icon = 'fa-phone',         color = 'phone-icon' },
    messages    = { name = 'Mensagens',    icon = 'fa-comment',       color = 'messages-icon' },
    contacts    = { name = 'Contatos',     icon = 'fa-address-book',  color = 'contacts-icon' },
    camera      = { name = 'Câmera',       icon = 'fa-camera',        color = 'camera-icon' },
    gallery     = { name = 'Fotos',        icon = 'fa-images',        color = 'gallery-icon' },
    settings    = { name = 'Ajustes',      icon = 'fa-cog',           color = 'settings-icon' },
    appstore    = { name = 'App Store',    icon = 'fa-store',         color = 'appstore-icon' }
}

-- ============================================
-- APPS - DOWNLOADABLE (AppStore)
-- ============================================
Config.StoreApps = {
    -- Social Media
    chirper = {
        name = 'Chirper',
        icon = 'fas fa-dove',
        color = 'chirper-icon',
        category = 'social',
        description = 'Compartilhe seus pensamentos com o mundo! Poste chirps, curta e rechirpe.',
        rating = 4.5,
        downloads = '10M+',
        size = '45 MB',
        developer = 'Chirper Inc.',
        price = 0
    },
    pictura = {
        name = 'Pictura',
        icon = 'fas fa-camera-retro',
        color = 'pictura-icon',
        category = 'social',
        description = 'Compartilhe fotos e stories com seus amigos. Explore o mundo visualmente.',
        rating = 4.7,
        downloads = '50M+',
        size = '120 MB',
        developer = 'Pictura Co.',
        price = 0
    },
    flamer = {
        name = 'Flamer',
        icon = 'fa-fire',
        color = 'flamer-icon',
        category = 'social',
        description = 'Encontre pessoas interessantes perto de voce. De match e converse!',
        rating = 4.2,
        downloads = '5M+',
        size = '80 MB',
        developer = 'Flamer Inc.',
        price = 0
    },
    
    -- Finance
    bank = {
        name = 'Maze Bank',
        icon = 'fa-university',
        color = 'bank-icon',
        category = 'finance',
        description = 'Gerencie suas finanças. Transferências, depósitos e saques na palma da mão.',
        rating = 4.8,
        downloads = '100M+',
        size = '35 MB',
        developer = 'Maze Bank Corp.',
        price = 0
    },
    
    -- Utilities
    calculator = {
        name = 'Calculadora',
        icon = 'fa-calculator',
        color = 'calculator-icon',
        category = 'utilities',
        description = 'Calculadora científica completa para todas as suas necessidades.',
        rating = 4.6,
        downloads = '20M+',
        size = '5 MB',
        developer = 'LS Utils',
        price = 0
    },
    notes = {
        name = 'Notas',
        icon = 'fa-sticky-note',
        color = 'notes-icon',
        category = 'utilities',
        description = 'Anote ideias, faça listas e mantenha tudo organizado.',
        rating = 4.5,
        downloads = '15M+',
        size = '12 MB',
        developer = 'LS Utils',
        price = 0
    },
    weather = {
        name = 'Clima',
        icon = 'fa-cloud-sun',
        color = 'weather-icon',
        category = 'utilities',
        description = 'Previsão do tempo em tempo real para Los Santos.',
        rating = 4.3,
        downloads = '8M+',
        size = '25 MB',
        developer = 'Weather Co.',
        price = 0
    },
    maps = {
        name = 'Mapas',
        icon = 'fa-map-marked-alt',
        color = 'maps-icon',
        category = 'utilities',
        description = 'Navegação GPS e pontos de interesse em Los Santos.',
        rating = 4.7,
        downloads = '30M+',
        size = '150 MB',
        developer = 'LS Utils',
        price = 0
    },
    email = {
        name = 'Email',
        icon = 'fa-envelope',
        color = 'email-icon',
        category = 'utilities',
        description = 'Envie e receba emails de forma rápida e segura.',
        rating = 4.4,
        downloads = '25M+',
        size = '40 MB',
        developer = 'LS Utils',
        price = 0
    },
    
    -- Services
    taxi = {
        name = 'LS Táxi',
        icon = 'fa-taxi',
        color = 'taxi-icon',
        category = 'services',
        description = 'Chame um táxi em qualquer lugar de Los Santos.',
        rating = 4.1,
        downloads = '2M+',
        size = '20 MB',
        developer = 'Downtown Cab Co.',
        price = 0
    },
    mechanic = {
        name = 'LS Mechanic',
        icon = 'fa-wrench',
        color = 'mechanic-icon',
        category = 'services',
        description = 'Chame um mecânico para consertar seu veículo.',
        rating = 4.0,
        downloads = '1M+',
        size = '15 MB',
        developer = 'LS Customs',
        price = 0
    },
    police = {
        name = 'LSPD',
        icon = 'fa-shield-alt',
        color = 'police-icon',
        category = 'services',
        description = 'Emergência 911 - Contato direto com a polícia.',
        rating = 4.9,
        downloads = '50M+',
        size = '10 MB',
        developer = 'LSPD Official',
        price = 0
    },
    ambulance = {
        name = 'EMS',
        icon = 'fa-ambulance',
        color = 'ambulance-icon',
        category = 'services',
        description = 'Emergência médica - Chame uma ambulância.',
        rating = 4.9,
        downloads = '50M+',
        size = '10 MB',
        developer = 'LS Medical',
        price = 0
    },
    
    -- Entertainment
    music = {
        name = 'Musica',
        icon = 'fa-music',
        color = 'music-icon',
        category = 'entertainment',
        description = 'Ouca suas musicas favoritas em qualquer lugar.',
        rating = 4.6,
        downloads = '40M+',
        size = '100 MB',
        developer = 'LS Music',
        price = 0
    },
    vidstream = {
        name = 'VidStream',
        icon = 'fas fa-play-circle',
        color = 'vidstream-icon',
        category = 'entertainment',
        description = 'Assista videos, lives e muito mais.',
        rating = 4.8,
        downloads = '100M+',
        size = '80 MB',
        developer = 'VidStream Co.',
        price = 0
    }
}

-- ============================================
-- APPSTORE CATEGORIES
-- ============================================
Config.AppCategories = {
    { id = 'all',           name = 'Todos',         icon = 'fa-th' },
    { id = 'social',        name = 'Redes Sociais', icon = 'fa-users' },
    { id = 'finance',       name = 'Finanças',      icon = 'fa-dollar-sign' },
    { id = 'utilities',     name = 'Utilidades',    icon = 'fa-tools' },
    { id = 'services',      name = 'Serviços',      icon = 'fa-concierge-bell' },
    { id = 'entertainment', name = 'Entretenimento', icon = 'fa-gamepad' }
}

-- ============================================
-- CHIRPER CONFIG
-- ============================================
Config.Chirper = {
    maxChirps = 50,
    maxCharacters = 280,
    enableImages = true,
    enableHashtags = true,
    enableMentions = true,
    enableRechirps = true,
    enableLikes = true,
    verifiedAccounts = {
        'weazel_news',
        'lspd_official',
        'ls_governo'
    }
}

-- ============================================
-- PICTURA CONFIG
-- ============================================
Config.Pictura = {
    maxPosts = 30,
    enableStories = true,
    storyDuration = 24,
    enableReels = true,
    enableDMs = true
}

-- ============================================
-- FLAMER CONFIG
-- ============================================
Config.Flamer = {
    matchRadius = 100.0,
    maxProfiles = 20,
    superLikesPerDay = 3,
    enableChat = true,
    showDistance = true,
    maxPhotos = 6,
    maxBioLength = 500
}

-- ============================================
-- BANK CONFIG
-- ============================================
Config.Bank = {
    enableTransfers = true,
    enableDeposit = true,
    enableWithdraw = true,
    enableHistory = true,
    maxTransferAmount = 1000000,
    transferFee = 0
}

-- ============================================
-- SERVICES CONFIG
-- ============================================
Config.Services = {
    taxi = {
        basePrice = 50,
        pricePerKm = 5,
        jobName = 'taxi'
    },
    mechanic = {
        repairPrice = 500,
        jobName = 'mechanic'
    },
    police = {
        emergencyNumber = '911',
        jobName = 'police'
    },
    ambulance = {
        callPrice = 0,
        jobName = 'ambulance'
    }
}

-- ============================================
-- DATABASE CONFIG
-- ============================================
Config.Database = {
    useOxMySQL = true,
    prefix = 'phone_'
}
