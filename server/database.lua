--[[
    SERVER DATABASE
    Inicialização do banco de dados
]]

-- ============================================
-- CREATE TABLES
-- ============================================
Citizen.CreateThread(function()
    Wait(2000)
    
    if not Config.Database.useOxMySQL then
        print('[PHONE] Database disabled')
        return
    end
    
    local prefix = Config.Database.prefix
    
    -- Contacts
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[contacts (
            id INT AUTO_INCREMENT PRIMARY KEY,
            owner VARCHAR(50) NOT NULL,
            name VARCHAR(100) NOT NULL,
            number VARCHAR(20) NOT NULL,
            avatar TEXT,
            favorite BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_owner (owner)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    -- Messages
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[messages (
            id INT AUTO_INCREMENT PRIMARY KEY,
            sender VARCHAR(50) NOT NULL,
            receiver VARCHAR(50) NOT NULL,
            message TEXT NOT NULL,
            is_read BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_sender (sender),
            INDEX idx_receiver (receiver)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    -- Calls
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[calls (
            id INT AUTO_INCREMENT PRIMARY KEY,
            caller VARCHAR(50) NOT NULL,
            receiver VARCHAR(50) NOT NULL,
            duration INT DEFAULT 0,
            status VARCHAR(20) DEFAULT 'missed',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_caller (caller)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    -- Chirper
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[chirper (
            id INT AUTO_INCREMENT PRIMARY KEY,
            author VARCHAR(50) NOT NULL,
            author_name VARCHAR(100),
            content TEXT NOT NULL,
            image TEXT,
            likes INT DEFAULT 0,
            rechirps INT DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_author (author)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[chirper_likes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            chirp_id INT NOT NULL,
            user_id VARCHAR(50) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_like (chirp_id, user_id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    -- Chirper migrations / compatibility with older schemas
    MySQL.query('ALTER TABLE ' .. prefix .. 'chirper ADD COLUMN IF NOT EXISTS rechirps INT DEFAULT 0')
    MySQL.query('ALTER TABLE ' .. prefix .. 'chirper_likes ADD COLUMN IF NOT EXISTS chirp_id INT NULL')
    MySQL.query('UPDATE ' .. prefix .. 'chirper SET rechirps = retweets WHERE rechirps = 0 AND retweets IS NOT NULL')
    MySQL.query('UPDATE ' .. prefix .. 'chirper_likes SET chirp_id = tweet_id WHERE chirp_id IS NULL AND tweet_id IS NOT NULL')
    
    -- Pictura
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[pictura (
            id INT AUTO_INCREMENT PRIMARY KEY,
            author VARCHAR(50) NOT NULL,
            author_name VARCHAR(100),
            image TEXT NOT NULL,
            caption TEXT,
            likes INT DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_author (author)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[pictura_stories (
            id INT AUTO_INCREMENT PRIMARY KEY,
            author VARCHAR(50) NOT NULL,
            image TEXT NOT NULL,
            views INT DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[pictura_follows (
            id INT AUTO_INCREMENT PRIMARY KEY,
            follower VARCHAR(50) NOT NULL,
            following VARCHAR(50) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_follow (follower, following)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    -- Flamer
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[flamer_profiles (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user_id VARCHAR(50) NOT NULL UNIQUE,
            name VARCHAR(100),
            age INT,
            bio TEXT,
            photos TEXT,
            looking_for VARCHAR(20) DEFAULT 'everyone',
            active BOOLEAN DEFAULT TRUE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[flamer_swipes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            swiper VARCHAR(50) NOT NULL,
            swiped VARCHAR(50) NOT NULL,
            direction VARCHAR(10) NOT NULL,
            super_like BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_swipe (swiper, swiped)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[flamer_matches (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user1 VARCHAR(50) NOT NULL,
            user2 VARCHAR(50) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[flamer_messages (
            id INT AUTO_INCREMENT PRIMARY KEY,
            match_id INT NOT NULL,
            sender VARCHAR(50) NOT NULL,
            message TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    -- Gallery
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[gallery (
            id INT AUTO_INCREMENT PRIMARY KEY,
            owner VARCHAR(50) NOT NULL,
            url TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_owner (owner)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    -- Notes
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[notes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            owner VARCHAR(50) NOT NULL,
            title VARCHAR(200),
            content TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX idx_owner (owner)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    -- Emails
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[emails (
            id INT AUTO_INCREMENT PRIMARY KEY,
            sender VARCHAR(100) NOT NULL,
            receiver VARCHAR(100) NOT NULL,
            subject VARCHAR(200),
            body TEXT,
            is_read BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    -- Installed Apps (AppStore)
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS ]] .. prefix .. [[installed_apps (
            id INT AUTO_INCREMENT PRIMARY KEY,
            owner VARCHAR(50) NOT NULL,
            app_id VARCHAR(50) NOT NULL,
            installed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_app (owner, app_id),
            INDEX idx_owner (owner)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    print('[PHONE] Database tables initialized')
end)
