fx_version 'cerulean'
game 'gta5'

author 'Emergent Labs'
description 'iPhone Style Phone - Full Featured Modular Architecture'
version '2.0.0'

lua54 'yes'

-- ============================================
-- SHARED (Load First)
-- ============================================
shared_scripts {
    'shared/config.lua',
    'shared/functions.lua',
    'shared/locales.lua'
}

-- ============================================
-- CLIENT SCRIPTS
-- ============================================
client_scripts {
    -- Core
    'client/core/error.lua',
    'client/core/state.lua',
    'client/core/optimization.lua',
    'client/core/loading.lua',
    'client/core/actions.lua',
    'client/core/queue.lua',
    'client/core/events.lua',
    'client/core/lifecycle.lua',
    'client/core/notify.lua',
    'client/core/sync.lua',
    'client/core/session.lua',
    'client/core/preload.lua',
    'client/core/permissions.lua',
    'client/main.lua',
    'client/framework.lua',
    'client/nui.lua',
    -- Apps
    'client/apps/phone.lua',
    'client/apps/contacts.lua',
    'client/apps/messages.lua',
    'client/apps/chirper.lua',
    'client/apps/pictura.lua',
    'client/apps/flamer.lua',
    'client/apps/bank.lua',
    'client/apps/camera.lua',
    'client/apps/gallery.lua',
    'client/apps/services.lua',
    'client/apps/settings.lua',
    'client/apps/notes.lua',
    'client/apps/email.lua',
    'client/apps/calculator.lua',
    'client/apps/weather.lua',
    'client/apps/maps.lua',
    'client/apps/appstore.lua'
}

-- ============================================
-- SERVER SCRIPTS
-- ============================================
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/framework.lua',
    'server/database.lua',
    -- Apps
    'server/apps/phone.lua',
    'server/apps/contacts.lua',
    'server/apps/messages.lua',
    'server/apps/chirper.lua',
    'server/apps/pictura.lua',
    'server/apps/flamer.lua',
    'server/apps/bank.lua',
    'server/apps/services.lua',
    'server/apps/gallery.lua',
    'server/apps/notes.lua',
    'server/apps/email.lua',
    'server/apps/appstore.lua'
}

-- ============================================
-- NUI (User Interface)
-- ============================================
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*.*'
}

dependencies {
    '/server:5181'
}
