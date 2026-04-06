-- ============================================
-- IPHONE STYLE PHONE - DATABASE INSTALLATION
-- Execute este arquivo no seu banco de dados
-- ============================================

-- Tabela de Contatos
CREATE TABLE IF NOT EXISTS `phone_contacts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `owner` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `number` VARCHAR(20) NOT NULL,
    `avatar` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Mensagens
CREATE TABLE IF NOT EXISTS `phone_messages` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sender` VARCHAR(50) NOT NULL,
    `receiver` VARCHAR(50) NOT NULL,
    `message` TEXT NOT NULL,
    `is_read` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_sender` (`sender`),
    INDEX `idx_receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Chirps
CREATE TABLE IF NOT EXISTS `phone_chirper` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `author` VARCHAR(50) NOT NULL,
    `author_name` VARCHAR(100),
    `author_avatar` TEXT,
    `content` TEXT NOT NULL,
    `image` TEXT,
    `likes` INT DEFAULT 0,
    `rechirps` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_author` (`author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Likes do Chirper
CREATE TABLE IF NOT EXISTS `phone_chirper_likes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `chirp_id` INT NOT NULL,
    `user_id` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_like` (`chirp_id`, `user_id`),
    FOREIGN KEY (`chirp_id`) REFERENCES `phone_chirper`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Posts do Pictura
CREATE TABLE IF NOT EXISTS `phone_pictura` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `author` VARCHAR(50) NOT NULL,
    `author_name` VARCHAR(100),
    `author_avatar` TEXT,
    `image` TEXT NOT NULL,
    `caption` TEXT,
    `filters` TEXT,
    `likes` INT DEFAULT 0,
    `comments` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_author` (`author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Seguidores do Pictura
CREATE TABLE IF NOT EXISTS `phone_pictura_follows` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `follower` VARCHAR(50) NOT NULL,
    `following` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_follow` (`follower`, `following`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Stories do Pictura
CREATE TABLE IF NOT EXISTS `phone_pictura_stories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `author` VARCHAR(50) NOT NULL,
    `image` TEXT NOT NULL,
    `views` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_author` (`author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Perfis do Flamer
CREATE TABLE IF NOT EXISTS `phone_flamer_profiles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(100),
    `age` INT,
    `bio` TEXT,
    `photos` TEXT,
    `looking_for` VARCHAR(20) DEFAULT 'everyone',
    `active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Swipes do Flamer
CREATE TABLE IF NOT EXISTS `phone_flamer_swipes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `swiper` VARCHAR(50) NOT NULL,
    `swiped` VARCHAR(50) NOT NULL,
    `direction` VARCHAR(10) NOT NULL,
    `super_like` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_swipe` (`swiper`, `swiped`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Matches do Flamer
CREATE TABLE IF NOT EXISTS `phone_flamer_matches` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user1` VARCHAR(50) NOT NULL,
    `user2` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_user1` (`user1`),
    INDEX `idx_user2` (`user2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Mensagens do Flamer
CREATE TABLE IF NOT EXISTS `phone_flamer_messages` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `match_id` INT NOT NULL,
    `sender` VARCHAR(50) NOT NULL,
    `message` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`match_id`) REFERENCES `phone_flamer_matches`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Galeria
CREATE TABLE IF NOT EXISTS `phone_gallery` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `owner` VARCHAR(50) NOT NULL,
    `url` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Notas
CREATE TABLE IF NOT EXISTS `phone_notes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `owner` VARCHAR(50) NOT NULL,
    `title` VARCHAR(200),
    `content` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Chamadas
CREATE TABLE IF NOT EXISTS `phone_calls` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `caller` VARCHAR(50) NOT NULL,
    `receiver` VARCHAR(50) NOT NULL,
    `duration` INT DEFAULT 0,
    `status` VARCHAR(20) DEFAULT 'missed',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_caller` (`caller`),
    INDEX `idx_receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Emails
CREATE TABLE IF NOT EXISTS `phone_emails` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sender` VARCHAR(100) NOT NULL,
    `receiver` VARCHAR(100) NOT NULL,
    `subject` VARCHAR(200),
    `body` TEXT,
    `is_read` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Apps Instalados (AppStore)
CREATE TABLE IF NOT EXISTS `phone_installed_apps` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `owner` VARCHAR(50) NOT NULL,
    `app_id` VARCHAR(50) NOT NULL,
    `installed_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_app` (`owner`, `app_id`),
    INDEX `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Compatibilidade: o app Chirper utiliza as colunas `rechirps` e `chirp_id`.


-- ============================================
-- Messages v1.1 (compatibilidade / upgrade)
-- ============================================
ALTER TABLE `phone_messages`
    ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Índices recomendados para bases já existentes (execute apenas se ainda não existirem):
-- CREATE INDEX `idx_sender_receiver` ON `phone_messages` (`sender`, `receiver`);
-- CREATE INDEX `idx_receiver_read` ON `phone_messages` (`receiver`, `is_read`);

-- ============================================
-- Chirper Upgrade (comentários + rechirps + replies)
-- ============================================
ALTER TABLE `phone_chirper`
    ADD COLUMN IF NOT EXISTS `verified` TINYINT(1) DEFAULT 0,
    ADD COLUMN IF NOT EXISTS `reply_to` INT NULL;

CREATE TABLE IF NOT EXISTS `phone_chirper_comments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `chirp_id` INT NOT NULL,
    `author` VARCHAR(50) NOT NULL,
    `author_name` VARCHAR(100),
    `author_avatar` TEXT,
    `content` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_chirp_comments` (`chirp_id`),
    CONSTRAINT `fk_phone_chirper_comments_chirp`
        FOREIGN KEY (`chirp_id`) REFERENCES `phone_chirper`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_chirper_rechirps` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `chirp_id` INT NOT NULL,
    `user_id` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_rechirp` (`chirp_id`, `user_id`),
    CONSTRAINT `fk_phone_chirper_rechirps_chirp`
        FOREIGN KEY (`chirp_id`) REFERENCES `phone_chirper`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
