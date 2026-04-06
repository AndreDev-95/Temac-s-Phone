/* ============================================
   IPHONE STYLE PHONE - COMPLETE APP.JS
   All Apps Fully Functional
   ============================================ */

// ============================================
// STATE MANAGEMENT
// ============================================
const PhoneState = {
    isOpen: false,
    currentScreen: 'lock-screen',
    playerData: {},
    settings: {},
    controlCenterOpen: false,
    swipeStartY: null,
    brightness: 92,
    isUnlocking: false,
    faceIdEnabled: true,
    controlTiles: { wifi: true, bluetooth: true, airplane: false, cellular: false, rotation: true, focus: false, flashlight: false },
    // Data
    contacts: [],
    messages: [],
    conversations: {},
    chirps: [],
    chirperProfile: null,
    chirperComments: {},
    picturaPosts: [],
    picturaStories: [],
    flamerProfiles: [],
    flamerMatches: [],
    flamerProfile: null,
    flamerIndex: 0,
    gallery: [],
    notes: [],
    calls: [],
    emails: [],
    bankData: { cash: 0, bank: 0 },
    // Current states
    currentConversation: null,
    messageTyping: {},
    currentNote: null,
    currentCall: null,
    currentEmail: null,
    currentBankAction: null,
    // AppStore
    installedApps: [],
    storeApps: [],
    storeCategory: 'all',
    // Calculator
    calculator: {
        display: '0',
        history: '',
        operator: null,
        waitingForOperand: false,
        previousValue: null
    }
};

// ============================================
// SYSTEM APPS (Always visible)
// ============================================
const SystemApps = [
    { id: 'phone', name: 'Telefone', icon: 'fa-phone', color: 'phone-icon' },
    { id: 'messages', name: 'Mensagens', icon: 'fa-comment', color: 'messages-icon' },
    { id: 'contacts', name: 'Contatos', icon: 'fa-address-book', color: 'contacts-icon' },
    { id: 'camera', name: 'Câmera', icon: 'fa-camera', color: 'camera-icon' },
    { id: 'gallery', name: 'Fotos', icon: 'fa-images', color: 'gallery-icon' },
    { id: 'settings', name: 'Ajustes', icon: 'fa-cog', color: 'settings-icon' },
    { id: 'appstore', name: 'App Store', icon: 'fa-store', color: 'appstore-icon' }
];

// ============================================
// STORE APPS (Downloadable)
// ============================================
const StoreApps = {
    chirper: {
        id: 'chirper', name: 'Chirper', icon: 'fas fa-dove', color: 'chirper-icon',
        category: 'social', description: 'Compartilhe seus pensamentos com o mundo!',
        rating: 4.5, downloads: '10M+', size: '45 MB', developer: 'Chirper Inc.', price: 0
    },
    pictura: {
        id: 'pictura', name: 'Pictura', icon: 'fas fa-camera-retro', color: 'pictura-icon',
        category: 'social', description: 'Compartilhe fotos e stories com seus amigos.',
        rating: 4.7, downloads: '50M+', size: '120 MB', developer: 'Pictura Co.', price: 0
    },
    flamer: {
        id: 'flamer', name: 'Flamer', icon: 'fa-fire', color: 'flamer-icon',
        category: 'social', description: 'Encontre pessoas interessantes perto de voce.',
        rating: 4.2, downloads: '5M+', size: '80 MB', developer: 'Flamer Inc.', price: 0
    },
    bank: {
        id: 'bank', name: 'Maze Bank', icon: 'fa-university', color: 'bank-icon',
        category: 'finance', description: 'Gerencie suas finanças na palma da mão.',
        rating: 4.8, downloads: '100M+', size: '35 MB', developer: 'Maze Bank Corp.', price: 0
    },
    calculator: {
        id: 'calculator', name: 'Calculadora', icon: 'fa-calculator', color: 'calculator-icon',
        category: 'utilities', description: 'Calculadora científica completa.',
        rating: 4.6, downloads: '20M+', size: '5 MB', developer: 'LS Utils', price: 0
    },
    notes: {
        id: 'notes', name: 'Notas', icon: 'fa-sticky-note', color: 'notes-icon',
        category: 'utilities', description: 'Anote ideias e mantenha tudo organizado.',
        rating: 4.5, downloads: '15M+', size: '12 MB', developer: 'LS Utils', price: 0
    },
    weather: {
        id: 'weather', name: 'Clima', icon: 'fa-cloud-sun', color: 'weather-icon',
        category: 'utilities', description: 'Previsão do tempo em tempo real.',
        rating: 4.3, downloads: '8M+', size: '25 MB', developer: 'Weather Co.', price: 0
    },
    maps: {
        id: 'maps', name: 'Mapas', icon: 'fa-map-marked-alt', color: 'maps-icon',
        category: 'utilities', description: 'Navegação GPS em Los Santos.',
        rating: 4.7, downloads: '30M+', size: '150 MB', developer: 'LS Maps Co.', price: 0
    },
    email: {
        id: 'email', name: 'Email', icon: 'fa-envelope', color: 'email-icon',
        category: 'utilities', description: 'Envie e receba emails.',
        rating: 4.4, downloads: '25M+', size: '40 MB', developer: 'LS Mail Co.', price: 0
    },
    taxi: {
        id: 'taxi', name: 'LS Táxi', icon: 'fa-taxi', color: 'taxi-icon',
        category: 'services', description: 'Chame um táxi em qualquer lugar.',
        rating: 4.1, downloads: '2M+', size: '20 MB', developer: 'Downtown Cab Co.', price: 0
    },
    mechanic: {
        id: 'mechanic', name: 'LS Mechanic', icon: 'fa-wrench', color: 'mechanic-icon',
        category: 'services', description: 'Chame um mecânico para seu veículo.',
        rating: 4.0, downloads: '1M+', size: '15 MB', developer: 'LS Customs', price: 0
    },
    police: {
        id: 'police', name: 'LSPD', icon: 'fa-shield-alt', color: 'police-icon',
        category: 'services', description: 'Emergência 911 - Polícia.',
        rating: 4.9, downloads: '50M+', size: '10 MB', developer: 'LSPD Official', price: 0
    },
    ambulance: {
        id: 'ambulance', name: 'EMS', icon: 'fa-ambulance', color: 'ambulance-icon',
        category: 'services', description: 'Emergência médica - Ambulância.',
        rating: 4.9, downloads: '50M+', size: '10 MB', developer: 'LS Medical', price: 0
    },
    music: {
        id: 'music', name: 'Musica', icon: 'fa-music', color: 'music-icon',
        category: 'entertainment', description: 'Ouca suas musicas favoritas.',
        rating: 4.6, downloads: '40M+', size: '100 MB', developer: 'LS Music', price: 0
    },
    vidstream: {
        id: 'vidstream', name: 'VidStream', icon: 'fas fa-play-circle', color: 'vidstream-icon',
        category: 'entertainment', description: 'Assista videos e lives.',
        rating: 4.8, downloads: '100M+', size: '80 MB', developer: 'VidStream Co.', price: 0
    }
};

const AppCategories = [
    { id: 'all', name: 'Todos', icon: 'fa-th' },
    { id: 'social', name: 'Social', icon: 'fa-users' },
    { id: 'finance', name: 'Finanças', icon: 'fa-dollar-sign' },
    { id: 'utilities', name: 'Utilidades', icon: 'fa-tools' },
    { id: 'services', name: 'Serviços', icon: 'fa-concierge-bell' },
    { id: 'entertainment', name: 'Entretenimento', icon: 'fa-gamepad' }
];

// ============================================
// DYNAMIC APPS BUILDER
// ============================================
function getVisibleApps() {
    const apps = [...SystemApps];
    PhoneState.installedApps.forEach(appId => {
        const storeApp = StoreApps[appId];
        if (storeApp) {
            apps.push({
                id: storeApp.id,
                name: storeApp.name,
                icon: storeApp.icon,
                color: storeApp.color
            });
        }
    });
    return apps;
}

function applyWallpaperToScreens(wallpaperName) {
    const wallpaperClass = wallpaperName || 'wallpaper1';
    const homeWallpaper = document.getElementById('wallpaper');
    const lockWallpaper = document.getElementById('lock-wallpaper');
    if (homeWallpaper) homeWallpaper.className = 'wallpaper ' + wallpaperClass;
    if (lockWallpaper) lockWallpaper.className = 'lock-wallpaper wallpaper ' + wallpaperClass;
}

function updateBatteryDisplay() {
    const batteryLevel = 100;
    document.querySelectorAll('.battery span').forEach(el => {
        el.textContent = `${batteryLevel}%`;
    });
}

function pulseDynamicIsland(active = true) {
    const island = document.querySelector('.dynamic-island');
    if (!island) return;
    island.style.transition = 'all 0.25s ease';
    island.style.width = active ? '138px' : '129px';
    island.style.boxShadow = active
        ? 'inset 0 1px 1px rgba(255,255,255,0.06), 0 8px 22px rgba(0,0,0,0.52)'
        : 'inset 0 1px 1px rgba(255,255,255,0.06), 0 4px 12px rgba(0,0,0,0.45)';
    setTimeout(() => {
        island.style.width = '129px';
        island.style.boxShadow = 'inset 0 1px 1px rgba(255,255,255,0.06), 0 4px 12px rgba(0,0,0,0.45)';
    }, 900);
}

// ============================================
// INITIALIZATION
// ============================================
document.addEventListener('DOMContentLoaded', () => {
    initializeApps();
    initializeEventListeners();
    initializeWallpapers();
    updateTime();
    setInterval(updateTime, 1000);
});


function initializeApps() {
    const appGrid = document.getElementById('app-grid');
    if (!appGrid) return;
    appGrid.innerHTML = '';

    const apps = getVisibleApps();
    apps.forEach(app => {
        const appElement = document.createElement('div');
        appElement.className = 'app-item';
        appElement.dataset.app = app.id;
        appElement.innerHTML = `
            <div class="app-icon ${app.color}">
                <div class="ios-icon-gloss"></div>
                <i class="${app.icon.includes('fab') ? app.icon : 'fas ' + app.icon}"></i>
            </div>
            <span class="app-name">${app.name}</span>
        `;
        appElement.addEventListener('click', () => openApp(app.id));
        appGrid.appendChild(appElement);
    });
}



function initializeEventListeners() {
    const lockScreen = document.getElementById('lock-screen');
    if (lockScreen) {
        lockScreen.addEventListener('dblclick', () => {
            if (PhoneState.currentScreen === 'lock-screen') startFaceIDUnlock();
        });
        lockScreen.addEventListener('click', (e) => {
            if (e.target.closest('.lock-action')) return;
            if (PhoneState.currentScreen === 'lock-screen' && !PhoneState.isUnlocking) {
                pulseDynamicIsland(true);
            }
        });
    }

    initializeSwipeUnlock();

    document.querySelectorAll('.phone-tabs .tab').forEach(tab => {
        tab.addEventListener('click', (e) => switchPhoneTab(e.target.dataset.tab));
    });

    document.querySelectorAll('.key').forEach(key => {
        key.addEventListener('click', (e) => addDigit(e.currentTarget.dataset.num));
    });

    document.querySelectorAll('.dock-app').forEach(app => {
        app.addEventListener('click', () => openApp(app.dataset.app));
    });

    const homeSearchPill = document.getElementById('home-search-pill');
    if (homeSearchPill) {
        homeSearchPill.addEventListener('click', () => openApp('appstore'));
    }

    const controlCenter = document.getElementById('control-center');
    if (controlCenter) {
        controlCenter.addEventListener('click', (e) => {
            if (e.target === controlCenter) closeControlCenter();
        });
    }

    const tweetContent = document.getElementById('tweet-content');
    if (tweetContent) {
        tweetContent.addEventListener('input', (e) => {
            document.getElementById('tweet-chars').textContent = e.target.value.length;
        });
    }

    const messageInput = document.getElementById('message-input');
    if (messageInput) {
        messageInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendMessage();
        });
    }

    document.querySelectorAll('.search-bar input').forEach(input => {
        input.addEventListener('input', (e) => {
            const searchType = e.target.closest('.app-screen')?.id;
            if (searchType === 'contacts-app') filterContacts(e.target.value);
        });
    });
}



function initializeWallpapers() {
    const wallpaperGrid = document.getElementById('wallpaper-grid');
    if (!wallpaperGrid) return;
    
    const wallpapers = ['wallpaper1', 'wallpaper2', 'wallpaper3', 'wallpaper4', 
                        'wallpaper5', 'wallpaper6', 'wallpaper7', 'wallpaper8'];
    
    wallpaperGrid.innerHTML = '';
    wallpapers.forEach(wp => {
        const option = document.createElement('div');
        option.className = `wallpaper-option ${wp}`;
        if (PhoneState.settings.wallpaper === wp) option.classList.add('selected');
        option.addEventListener('click', () => selectWallpaper(wp));
        wallpaperGrid.appendChild(option);
    });
}

// ============================================
// NUI MESSAGE HANDLERS
// ============================================
window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch (data.type) {
        case 'openPhone':
            openPhone(data.playerData, data.time, data.settings);
            break;
        case 'closePhone':
            closePhone();
            break;
        case 'notification':
            showNotification(data.title, data.message, data.icon || 'phone');
            break;
        case 'messagesConversationData':
            PhoneState.currentConversation = data.number;
            PhoneState.conversations[data.number] = data.messages || [];
            if (PhoneState.currentScreen === 'messages-app' || PhoneState.currentScreen === 'message-conversation') {
                renderCurrentConversation();
            }
            break;
        case 'messagesTyping':
            PhoneState.messageTyping[data.number] = data.state === true;
            if (PhoneState.currentScreen === 'messages-app') renderMessages();
            break;
        case 'chirperProfileData':
            PhoneState.chirperProfile = data.profile || data || null;
            renderChirps();
            break;
        case 'chirperCommentsData':
            PhoneState.chirperComments[data.chirpId] = data.comments || [];
            showChirpComments(data.chirpId);
            break;
        case 'chirperTagData':
            PhoneState.chirps = data.chirps || [];
            renderChirps();
            break;
        case 'bankHistoryData':
            PhoneState.bankHistory = data.history || [];
            renderBank();
            break;
        case 'phoneLoading':
            document.body.classList.toggle('phone-busy', !!data.active);
            break;
        case 'receiveData':
            handleData(data.dataType, data.data);
            break;
        case 'incomingCall':
            showIncomingCall(data.caller);
            break;
        case 'callConnected':
            showActiveCall();
            break;
        case 'callEnded':
            endCallUI();
            break;
        case 'newMessage':
            handleNewMessage(data.message);
            break;
        case 'newChirp':
            handleNewChirp(data.chirp);
            break;
        case 'flamerMatch':
            handleFlamerMatch(data.match);
            break;
        case 'updateBalance':
            updateBalance(data.cash, data.bank);
            break;
        case 'notification':
            showNotification(data.title, data.message, data.icon);
            break;
        case 'serviceRequest':
            handleServiceRequest(data.service, data.caller);
            break;
        case 'updateInstalledApps':
            PhoneState.installedApps = data.apps || [];
            initializeApps();
            break;
    }
});

// ============================================
// PHONE OPEN/CLOSE
// ============================================

function openPhone(playerData, time, settings) {
    PhoneState.isOpen = true;
    PhoneState.playerData = playerData || {};
    PhoneState.settings = settings || {};

    document.getElementById('phone-container').classList.remove('hidden');

    const playerName = document.getElementById('player-name');
    const settingsName = document.getElementById('settings-player-name');
    const settingsPhone = document.getElementById('settings-phone-number');

    if (playerName) playerName.textContent = playerData?.name || 'Jogador';
    if (settingsName) settingsName.textContent = playerData?.name || 'Jogador';
    if (settingsPhone) settingsPhone.textContent = playerData?.phone || '000-0000';

    applyWallpaperToScreens(PhoneState.settings.wallpaper || 'wallpaper1');
    setBrightness(PhoneState.brightness || 92, false);
    closeControlCenter();
    resetFaceID();
    showScreen('lock-screen');

    if (PhoneState.faceIdEnabled !== false) {
        startFaceIDUnlock();
    }
}



function closePhone() {
    PhoneState.isOpen = false;
    document.getElementById('phone-container').classList.add('hidden');
    sendNUI('closePhone');
}


function unlockPhone() {
    if (PhoneState.isUnlocking) return;
    PhoneState.isUnlocking = true;

    const lock = document.getElementById('lock-screen');
    if (lock) {
        lock.classList.add('unlocking');
        setTimeout(() => lock.classList.remove('unlocking'), 450);
    }

    pulseDynamicIsland(true);
    setTimeout(() => {
        showScreen('home-screen');
        PhoneState.isUnlocking = false;
    }, 180);
}



// ============================================
// SCREEN NAVIGATION
// ============================================
function showScreen(screenId) {
    document.querySelectorAll('.screen').forEach(screen => screen.classList.remove('active'));
    const target = document.getElementById(screenId);
    if (target) {
        target.classList.add('active');
        PhoneState.currentScreen = screenId;
    }
}

function showApp(appId) {
    showScreen(appId);
}

function openApp(appId) {
    closeControlCenter();
    // Render app-specific content when opening
    if (appId === 'appstore') {
        renderAppStore();
    } else if (appId === 'chirper') {
        renderChirps();
    } else if (appId === 'pictura') {
        renderPictura();
    } else if (appId === 'contacts') {
        renderContacts();
    } else if (appId === 'notes') {
        renderNotes();
    }
    showScreen(appId + '-app');
}

function goHome() {
    closeControlCenter();
    showScreen('home-screen');
}


function pulseDynamicIsland(active = true) {
    const island = document.getElementById('dynamic-island');
    if (!island) return;
    island.classList.toggle('pulse', !!active);
    if (active) {
        clearTimeout(window.__temacIslandTimer);
        window.__temacIslandTimer = setTimeout(() => island.classList.remove('pulse'), 350);
    }
}

function openControlCenter() {
    const panel = document.getElementById('control-center');
    if (!panel) return;
    PhoneState.controlCenterOpen = true;
    panel.classList.add('active');
    pulseDynamicIsland(true);
}

function closeControlCenter() {
    const panel = document.getElementById('control-center');
    if (!panel) return;
    PhoneState.controlCenterOpen = false;
    panel.classList.remove('active');
}

function toggleControlTile(tile) {
    const current = !!PhoneState.controlTiles[tile];
    PhoneState.controlTiles[tile] = !current;

    const map = {
        wifi: 'cc-wifi',
        bluetooth: 'cc-bluetooth',
        airplane: 'cc-airplane',
        cellular: 'cc-cellular',
        rotation: 'cc-rotation',
        focus: 'cc-focus',
        flashlight: 'cc-flashlight'
    };

    const el = document.getElementById(map[tile]);
    if (el) {
        el.classList.toggle('active', PhoneState.controlTiles[tile] && tile !== 'airplane' && tile !== 'flashlight');
        el.classList.toggle('warning', tile === 'airplane' && PhoneState.controlTiles[tile]);
        el.classList.toggle('utility', tile === 'flashlight' && PhoneState.controlTiles[tile]);
    }

    if (tile === 'flashlight') {
        showNotification('Lanterna', PhoneState.controlTiles[tile] ? 'Lanterna ativada.' : 'Lanterna desativada.', 'camera');
    }
    if (tile === 'focus') {
        showNotification('Foco', PhoneState.controlTiles[tile] ? 'Modo foco ativado.' : 'Modo foco desativado.', 'settings');
    }
}

function setBrightness(value, showToast = true) {
    PhoneState.brightness = Number(value);
    const normalized = Math.max(35, Math.min(100, PhoneState.brightness)) / 100;
    document.documentElement.style.setProperty('--phone-brightness', normalized.toFixed(2));
    document.body.classList.add('phone-dim');
    if (showToast) showNotification('Brilho', 'Brilho ajustado para ' + PhoneState.brightness + '%.', 'settings');
}

function initializeSwipeUnlock() {
    const lockScreen = document.getElementById('lock-screen');
    if (!lockScreen) return;

    const start = (clientY) => {
        PhoneState.swipeStartY = clientY;
    };

    const move = (clientY) => {
        if (PhoneState.swipeStartY === null) return;
        const delta = PhoneState.swipeStartY - clientY;
        if (delta > 65) {
            PhoneState.swipeStartY = null;
            resetFaceID();
            unlockPhone();
        }
    };

    lockScreen.addEventListener('touchstart', (e) => start(e.touches[0].clientY), { passive: true });
    lockScreen.addEventListener('touchmove', (e) => move(e.touches[0].clientY), { passive: true });
    lockScreen.addEventListener('mousedown', (e) => start(e.clientY));
    lockScreen.addEventListener('mousemove', (e) => {
        if (e.buttons === 1) move(e.clientY);
    });
    window.addEventListener('mouseup', () => { PhoneState.swipeStartY = null; });
}

function resetFaceID() {
    const overlay = document.getElementById('face-id-overlay');
    const text = document.getElementById('face-id-text');
    if (!overlay) return;
    overlay.classList.remove('active', 'scanning', 'success');
    if (text) text.textContent = 'Face ID';
    clearTimeout(window.__temacFaceIdTimer1);
    clearTimeout(window.__temacFaceIdTimer2);
    clearTimeout(window.__temacFaceIdTimer3);
}

function startFaceIDUnlock() {
    const overlay = document.getElementById('face-id-overlay');
    const text = document.getElementById('face-id-text');
    if (!overlay || PhoneState.currentScreen !== 'lock-screen') return;

    resetFaceID();
    overlay.classList.add('active');
    pulseDynamicIsland(true);

    window.__temacFaceIdTimer1 = setTimeout(() => {
        overlay.classList.add('scanning');
        if (text) text.textContent = 'Autenticando...';
    }, 120);

    window.__temacFaceIdTimer2 = setTimeout(() => {
        overlay.classList.remove('scanning');
        overlay.classList.add('success');
        if (text) text.textContent = 'Desbloqueado';
        pulseDynamicIsland(true);
    }, 1150);

    window.__temacFaceIdTimer3 = setTimeout(() => {
        resetFaceID();
        unlockPhone();
    }, 1650);
}

// ============================================
// TIME UPDATE
// ============================================
function updateTime() {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const timeString = `${hours}:${minutes}`;

    const phoneTime = document.getElementById('phone-time');
    const lockTime = document.getElementById('lock-time');
    if (phoneTime) phoneTime.textContent = timeString;
    if (lockTime) lockTime.textContent = timeString;

    const lockDate = document.getElementById('lock-date');
    if (lockDate) {
        const weekday = now.toLocaleDateString('pt-BR', { weekday: 'long' });
        const month = now.toLocaleDateString('pt-BR', { month: 'long' });
        const formattedWeekday = weekday.charAt(0).toUpperCase() + weekday.slice(1);
        const formattedMonth = month.charAt(0).toUpperCase() + month.slice(1);
        lockDate.textContent = `${formattedWeekday}, ${now.getDate()} de ${formattedMonth}`;
    }
}

// ============================================
// DATA HANDLERS
// ============================================
function handleData(type, data) {
    switch (type) {
        case 'playerData':
            PhoneState.playerData = { ...PhoneState.playerData, ...data };
            updatePlayerInfo();
            break;
        case 'contacts':
            PhoneState.contacts = data || [];
            renderContacts();
            break;
        case 'messages':
            PhoneState.messages = data || [];
            renderConversations();
            break;
        case 'chirper':
            PhoneState.chirps = data || [];
            renderChirps();
            break;
        case 'pictura':
            PhoneState.picturaPosts = data?.posts || [];
            PhoneState.picturaStories = data?.stories || [];
            renderPictura();
            break;
        case 'flamer':
            PhoneState.flamerProfile = data?.profile;
            PhoneState.flamerProfiles = data?.profiles || [];
            PhoneState.flamerMatches = data?.matches || [];
            PhoneState.flamerIndex = 0;
            renderFlamer();
            break;
        case 'gallery':
            PhoneState.gallery = data || [];
            renderGallery();
            break;
        case 'notes':
            PhoneState.notes = data || [];
            renderNotes();
            break;
        case 'calls':
            PhoneState.calls = data || [];
            renderCalls();
            break;
        case 'emails':
            PhoneState.emails = data || [];
            renderEmails();
            break;
        case 'bank':
            PhoneState.bankData = data || { cash: 0, bank: 0 };
            updateBankDisplay();
            break;
    }
}

function updatePlayerInfo() {
    const name = document.getElementById('settings-name');
    const phone = document.getElementById('settings-phone');
    if (name) name.textContent = PhoneState.playerData.name || 'Jogador';
    if (phone) phone.textContent = PhoneState.playerData.phone || '000-0000';
}

// ============================================
// PHONE APP - CALLS
// ============================================
function switchPhoneTab(tabName) {
    document.querySelectorAll('.phone-tabs .tab').forEach(tab => {
        tab.classList.toggle('active', tab.dataset.tab === tabName);
    });
    document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.toggle('active', content.id === tabName);
    });
}

function addDigit(num) {
    const display = document.getElementById('dial-number');
    if (display && display.value.length < 15) {
        display.value += num;
    }
}

function deleteDigit() {
    const display = document.getElementById('dial-number');
    if (display) display.value = display.value.slice(0, -1);
}

function makeCall() {
    const display = document.getElementById('dial-number');
    const number = display?.value;
    if (number) {
        sendNUI('makeCall', { number });
        display.value = '';
    }
}

function renderCalls() {
    const callList = document.getElementById('call-list');
    if (!callList) return;
    
    if (PhoneState.calls.length === 0) {
        callList.innerHTML = '<div class="empty-state"><i class="fas fa-phone"></i><p>Nenhuma chamada recente</p></div>';
        return;
    }
    
    callList.innerHTML = PhoneState.calls.map(call => {
        const isMissed = call.status === 'missed';
        const isOutgoing = call.caller === PhoneState.playerData.phone;
        return `
            <div class="call-item" onclick="callBack('${call.caller}')">
                <div class="avatar"><i class="fas fa-user"></i></div>
                <div class="call-info">
                    <div class="call-name ${isMissed ? 'missed' : ''}">${call.caller_name || call.caller}</div>
                    <div class="call-detail">
                        <i class="fas fa-phone${isOutgoing ? '-alt' : ''}"></i>
                        ${isMissed ? 'Perdida' : call.duration ? formatDuration(call.duration) : 'Chamada'}
                    </div>
                </div>
                <div class="call-time">${formatTime(call.created_at)}</div>
                <button class="call-action"><i class="fas fa-phone"></i></button>
            </div>
        `;
    }).join('');
}

function callBack(number) {
    const display = document.getElementById('dial-number');
    if (display) display.value = number;
    switchPhoneTab('keypad');
}

function showIncomingCall(caller) {
    PhoneState.currentCall = caller;
    const callerName = document.getElementById('caller-name');
    if (callerName) callerName.textContent = caller.callerName || caller.callerNumber;
    showScreen('incoming-call-screen');
}

function acceptCall() {
    sendNUI('answerCall', { callId: PhoneState.currentCall?.callId });
}

function declineCall() {
    sendNUI('declineCall', { callId: PhoneState.currentCall?.callId });
    PhoneState.currentCall = null;
    goHome();
}

function showActiveCall() {
    const name = document.getElementById('active-caller-name');
    if (name) name.textContent = PhoneState.currentCall?.callerName || 'Desconhecido';
    
    let seconds = 0;
    const timer = setInterval(() => {
        if (!PhoneState.currentCall) {
            clearInterval(timer);
            return;
        }
        seconds++;
        const timerEl = document.getElementById('call-timer');
        if (timerEl) timerEl.textContent = formatDuration(seconds);
    }, 1000);
    
    showScreen('active-call-screen');
}

function endCall() {
    sendNUI('endCall', { callId: PhoneState.currentCall?.callId });
    endCallUI();
}

function endCallUI() {
    PhoneState.currentCall = null;
    goHome();
}

// ============================================
// CONTACTS APP
// ============================================
function renderContacts() {
    const lists = ['contacts-list', 'phone-contacts-list'];
    
    lists.forEach(listId => {
        const list = document.getElementById(listId);
        if (!list) return;
        
        if (PhoneState.contacts.length === 0) {
            list.innerHTML = '<div class="empty-state"><i class="fas fa-address-book"></i><p>Nenhum contato</p></div>';
            return;
        }
        
        list.innerHTML = PhoneState.contacts.map(contact => `
            <div class="contact-item" onclick="selectContact('${contact.id}', '${contact.name}', '${contact.number}')">
                <div class="avatar" style="background: hsl(${hashCode(contact.name) % 360}, 70%, 50%)">
                    ${contact.avatar ? `<img src="${contact.avatar}">` : `<span>${contact.name.charAt(0).toUpperCase()}</span>`}
                </div>
                <div class="contact-info">
                    <div class="contact-name">${contact.name}</div>
                    <div class="contact-number">${contact.number}</div>
                </div>
                ${contact.favorite ? '<i class="fas fa-star" style="color: var(--ios-yellow)"></i>' : ''}
            </div>
        `).join('');
    });
}

function showAddContact() {
    document.getElementById('contact-name').value = '';
    document.getElementById('contact-number').value = '';
    showModal('add-contact-modal');
}

function saveContact() {
    const name = document.getElementById('contact-name')?.value;
    const number = document.getElementById('contact-number')?.value;
    
    if (name && number) {
        sendNUI('addContact', { name, number });
        hideModal('add-contact-modal');
    }
}

function deleteContact(id) {
    sendNUI('deleteContact', { id });
}

function selectContact(id, name, number) {
    const display = document.getElementById('dial-number');
    if (display) display.value = number;
    showApp('phone-app');
    switchPhoneTab('keypad');
}

function filterContacts(query) {
    const items = document.querySelectorAll('#contacts-list .contact-item');
    items.forEach(item => {
        const name = item.querySelector('.contact-name')?.textContent.toLowerCase() || '';
        item.style.display = name.includes(query.toLowerCase()) ? 'flex' : 'none';
    });
}

// ============================================
// MESSAGES APP
// ============================================
function renderConversations() {
    const list = document.getElementById('conversations-list');
    if (!list) return;

    const conversations = {};
    PhoneState.messages.forEach(msg => {
        const otherId = msg.sender === PhoneState.playerData.phone ? msg.receiver : msg.sender;
        if (!otherId) return;

        if (!conversations[otherId]) {
            conversations[otherId] = {
                id: otherId,
                name: msg.sender === PhoneState.playerData.phone ? (msg.receiver_name || otherId) : (msg.sender_name || otherId),
                lastMessage: msg.message,
                time: msg.created_at,
                unread: 0
            };
        }

        if (!msg.is_read && msg.receiver === PhoneState.playerData.phone) {
            conversations[otherId].unread += 1;
        }
    });

    const convArray = Object.values(conversations).sort((a, b) => new Date(b.time || 0) - new Date(a.time || 0));

    if (convArray.length === 0) {
        list.innerHTML = '<div class="empty-state"><i class="fas fa-comment"></i><p>Nenhuma mensagem</p></div>';
        return;
    }

    list.innerHTML = convArray.map(conv => `
        <div class="conversation-item" onclick="openConversation('${conv.id}', ${JSON.stringify(String(conv.name || conv.id))})">
            <div class="avatar" style="background: hsl(${hashCode(conv.name || conv.id) % 360}, 70%, 50%)">
                <span>${String(conv.name || conv.id).charAt(0).toUpperCase()}</span>
            </div>
            <div class="conversation-info">
                <div class="conversation-name">${conv.name || conv.id}</div>
                <div class="conversation-preview">${truncate(conv.lastMessage || '', 30)}</div>
            </div>
            <div class="conversation-time">${formatTime(conv.time)}</div>
            ${conv.unread ? `<div class="unread-dot">${conv.unread > 9 ? '9+' : conv.unread}</div>` : ''}
        </div>
    `).join('');
}

function renderCurrentConversation() {
    const container = document.getElementById('messages-container');
    if (!container || !PhoneState.currentConversation) return;

    const msgs = PhoneState.conversations[PhoneState.currentConversation]
        || PhoneState.messages
            .filter(m => m.sender === PhoneState.currentConversation || m.receiver === PhoneState.currentConversation)
            .sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0));

    container.innerHTML = msgs.map(msg => `
        <div class="message-bubble ${msg.sender === PhoneState.playerData.phone ? 'sent' : 'received'}">
            ${msg.message}
        </div>
    `).join('');

    container.scrollTop = container.scrollHeight;
}

function openConversation(id, name) {
    PhoneState.currentConversation = id;
    const nameEl = document.getElementById('conversation-name');
    if (nameEl) nameEl.textContent = name || id;

    showScreen('message-conversation');
    renderCurrentConversation();

    sendNUI('openConversation', { number: id });
    sendNUI('markAsRead', { number: id });
}

function showNewMessage() {
    PhoneState.currentConversation = prompt('Digite o número:');
    if (PhoneState.currentConversation) {
        const nameEl = document.getElementById('conversation-name');
        if (nameEl) nameEl.textContent = PhoneState.currentConversation;
        const container = document.getElementById('messages-container');
        if (container) container.innerHTML = '';
        showScreen('message-conversation');
    }
}

function sendMessage() {
    const input = document.getElementById('message-input');
    const message = input?.value.trim();

    if (message && PhoneState.currentConversation) {
        sendNUI('sendMessage', { to: PhoneState.currentConversation, message });
        sendNUI('messagesTyping', { number: PhoneState.currentConversation, state: false });
        input.value = '';
    }
}

function handleNewMessage(msg) {
    if (!msg) return;

    const exists = msg.id && PhoneState.messages.some(existing => existing.id === msg.id);
    if (!exists) {
        PhoneState.messages.unshift(msg);
    }

    const otherId = msg.sender === PhoneState.playerData.phone ? msg.receiver : msg.sender;
    if (otherId) {
        if (!PhoneState.conversations[otherId]) PhoneState.conversations[otherId] = [];
        const inConversation = msg.id && PhoneState.conversations[otherId].some(existing => existing.id === msg.id);
        if (!inConversation) {
            PhoneState.conversations[otherId].push(msg);
            PhoneState.conversations[otherId].sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0));
        }
    }

    renderConversations();

    if (PhoneState.currentConversation === otherId) {
        renderCurrentConversation();
    }

    if (msg.sender !== PhoneState.playerData.phone) {
        showNotification('Mensagem', msg.message, 'messages');
    }
}

// ============================================
// CHIRPER APP
// ============================================
function renderChirps() {
    const feed = document.getElementById('chirps-feed');
    if (!feed) return;

    const profile = PhoneState.chirperProfile || { total_chirps: 0, total_likes: 0, total_comments: 0, total_rechirps: 0 };

    if (PhoneState.chirps.length === 0) {
        feed.innerHTML = `
            <div class="chirper-profile-card">
                <strong>Seu Chirper</strong>
                <div class="info-row"><span>Posts</span><span>${profile.total_chirps || 0}</span></div>
                <div class="info-row"><span>Likes</span><span>${profile.total_likes || 0}</span></div>
                <div class="info-row"><span>Comentários</span><span>${profile.total_comments || 0}</span></div>
                <div class="info-row"><span>Rechirps</span><span>${profile.total_rechirps || 0}</span></div>
            </div>
            <div class="empty-state"><i class="fas fa-dove"></i><p>Nenhum chirp ainda</p></div>`;
        return;
    }

    feed.innerHTML = `
        <div class="chirper-profile-card">
            <strong>Seu Chirper</strong>
            <div class="info-row"><span>Posts</span><span>${profile.total_chirps || 0}</span></div>
            <div class="info-row"><span>Likes</span><span>${profile.total_likes || 0}</span></div>
            <div class="info-row"><span>Comentários</span><span>${profile.total_comments || 0}</span></div>
            <div class="info-row"><span>Rechirps</span><span>${profile.total_rechirps || 0}</span></div>
        </div>
        ${PhoneState.chirps.map(chirp => `
        <div class="chirp-item" data-id="${chirp.id}">
            <div class="avatar" style="background: hsl(${hashCode(chirp.author_name || '') % 360}, 70%, 50%)">
                <span>${(chirp.author_name || 'A').charAt(0).toUpperCase()}</span>
            </div>
            <div class="chirp-content">
                <div class="chirp-header">
                    <span class="chirp-author">${chirp.author_name || 'Anonimo'}</span>
                    ${chirp.verified ? '<i class="fas fa-check-circle chirp-verified"></i>' : ''}
                    <span class="chirp-handle">@${(chirp.author || '').substring(0, 8)}</span>
                    <span class="chirp-time">· ${formatTime(chirp.created_at)}</span>
                </div>
                ${chirp.reply_to ? `
                    <div class="chirp-reply-context" style="padding:8px 10px;border-radius:12px;background:var(--bg-tertiary);margin-bottom:8px;font-size:12px;opacity:.9;">
                        Respondendo a <strong>${chirp.original_author_name || chirp.original_author || 'post'}</strong><br>
                        <span>${escapeHtml((chirp.original_content || '').slice(0, 90))}${(chirp.original_content || '').length > 90 ? '…' : ''}</span>
                    </div>` : ''}
                <div class="chirp-text">${formatChirpText(chirp.content)}</div>
                ${chirp.image ? `<div class="chirp-image"><img src="${chirp.image}" alt=""></div>` : ''}
                <div class="chirp-actions">
                    <button class="chirp-action" onclick="commentChirp(${chirp.id})"><i class="far fa-comment"></i> ${chirp.comments || 0}</button>
                    <button class="chirp-action ${chirp.user_rechirped ? 'rechirped' : ''}" onclick="rechirp(${chirp.id})">
                        <i class="fas fa-retweet"></i> ${chirp.rechirps || 0}
                    </button>
                    <button class="chirp-action ${chirp.user_liked ? 'liked' : ''}" onclick="likeChirp(${chirp.id})">
                        <i class="${chirp.user_liked ? 'fas' : 'far'} fa-heart"></i> ${chirp.likes || 0}
                    </button>
                    <button class="chirp-action" onclick="copyChirpLink(${chirp.id})"><i class="fas fa-share"></i></button>
                </div>
            </div>
        </div>
    `).join('')}`;
}

function formatChirpText(text) {
    if (!text) return '';
    text = escapeHtml(text);
    text = text.replace(/#(\w+)/g, '<span style="color: var(--chirper-blue)">#$1</span>');
    text = text.replace(/@(\w+)/g, '<span style="color: var(--chirper-blue)">@$1</span>');
    return text.replace(/\n/g, '<br>');
}

function escapeHtml(text) {
    return String(text || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

function showNewChirp() {
    const content = document.getElementById('chirp-content');
    const chars = document.getElementById('chirp-chars');
    if (content) content.value = '';
    if (chars) chars.textContent = '0';
    showModal('new-chirp-modal');
}

function postChirp(replyTo = null) {
    const content = document.getElementById('chirp-content')?.value.trim();
    if (content) {
        sendNUI('postChirp', { content, replyTo });
        hideModal('new-chirp-modal');
    }
}

function likeChirp(chirpId) {
    sendNUI('likeChirp', { chirpId });
    const chirp = PhoneState.chirps.find(t => t.id === chirpId);
    if (chirp) {
        chirp.user_liked = !chirp.user_liked;
        chirp.likes = (chirp.likes || 0) + (chirp.user_liked ? 1 : -1);
        renderChirps();
    }
}

function rechirp(chirpId) {
    sendNUI('rechirp', { chirpId });
    const chirp = PhoneState.chirps.find(t => t.id === chirpId);
    if (chirp) {
        chirp.user_rechirped = !chirp.user_rechirped;
        chirp.rechirps = Math.max(0, (chirp.rechirps || 0) + (chirp.user_rechirped ? 1 : -1));
        renderChirps();
    }
}

function handleNewChirp(chirp) {
    const existingIndex = PhoneState.chirps.findIndex(item => item.id === chirp.id);
    if (existingIndex >= 0) {
        PhoneState.chirps[existingIndex] = { ...PhoneState.chirps[existingIndex], ...chirp };
    } else {
        PhoneState.chirps.unshift(chirp);
    }
    renderChirps();
}

function commentChirp(chirpId) {
    const text = window.prompt('Responder a este chirp:');
    if (text && text.trim()) {
        sendNUI('commentChirp', { chirpId, content: text.trim() });
        const chirp = PhoneState.chirps.find(t => t.id === chirpId);
        if (chirp) {
            chirp.comments = (chirp.comments || 0) + 1;
            renderChirps();
        }
    }
}

function showChirpComments(chirpId) {
    const comments = PhoneState.chirperComments[chirpId] || [];
    if (!comments.length) return;
    const output = comments
        .slice(-8)
        .map(comment => `${comment.author_name || 'Anónimo'}: ${comment.content}`)
        .join('\n');
    showNotification('Comentários', output.substring(0, 180), 'chirper');
}

function copyChirpLink(chirpId) {
    const link = `chirper://${chirpId}`;
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(link).catch(() => {});
    }
    showNotification('Chirper', `Link copiado: ${link}`, 'chirper');
}

// ============================================
// PICTURA APP
// ============================================
function renderPictura() {
    renderPicturaStories();
    renderPicturaFeed();
}

function renderPicturaStories() {
    const bar = document.getElementById('stories-bar');
    if (!bar) return;
    
    let html = `
        <div class="story your-story" onclick="postStory()">
            <div class="story-avatar" style="background:var(--bg-tertiary)">
                <i class="fas fa-plus" style="color:var(--ios-blue)"></i>
            </div>
            <span>Seu story</span>
        </div>
    `;
    
    PhoneState.picturaStories.forEach((story, i) => {
        html += `
            <div class="story" onclick="viewStory(${i})">
                <div class="story-ring">
                    <div class="story-avatar" style="background: hsl(${hashCode(story.author) % 360}, 70%, 50%)">
                        <span>${(story.author || 'A').charAt(0).toUpperCase()}</span>
                    </div>
                </div>
                <span>${(story.author || '').substring(0, 8)}</span>
            </div>
        `;
    });
    
    bar.innerHTML = html;
}

function renderPicturaFeed() {
    const feed = document.getElementById('pictura-feed');
    if (!feed) return;
    
    if (PhoneState.picturaPosts.length === 0) {
        feed.innerHTML = '<div class="empty-state"><i class="fas fa-camera-retro"></i><p>Nenhuma publicacao</p></div>';
        return;
    }
    
    feed.innerHTML = PhoneState.picturaPosts.map(post => `
        <div class="ig-post" data-id="${post.id}">
            <div class="ig-post-header">
                <div class="avatar" style="background: hsl(${hashCode(post.author_name || '') % 360}, 70%, 50%)">
                    <span>${(post.author_name || 'A').charAt(0).toUpperCase()}</span>
                </div>
                <span class="username">${post.author_name || post.author?.substring(0, 10) || 'Anonimo'}</span>
                <button onclick="showPostOptions(${post.id})"><i class="fas fa-ellipsis-h"></i></button>
            </div>
            <div class="ig-post-image">
                ${post.image ? `<img src="${post.image}" alt="">` : '<i class="fas fa-image"></i>'}
            </div>
            <div class="ig-post-actions">
                <button onclick="likePictura(${post.id})"><i class="${post.liked ? 'fas' : 'far'} fa-heart" style="${post.liked ? 'color:var(--ios-red)' : ''}"></i></button>
                <button><i class="far fa-comment"></i></button>
                <button><i class="far fa-paper-plane"></i></button>
                <button class="bookmark"><i class="far fa-bookmark"></i></button>
            </div>
            <div class="ig-post-likes">${post.likes || 0} curtidas</div>
            <div class="ig-post-caption">
                <span class="username">${post.author_name || 'Anonimo'}</span>
                ${post.caption || ''}
            </div>
            <div class="ig-post-time">${formatTime(post.created_at)}</div>
        </div>
    `).join('');
}

function showNewPost() {
    showModal('new-post-modal');
}

function postPictura() {
    const caption = document.getElementById('post-caption')?.value;
    sendNUI('postPictura', { image: '', caption });
    hideModal('new-post-modal');
}

function likePictura(postId) {
    sendNUI('likePictura', { postId });
    const post = PhoneState.picturaPosts.find(p => p.id === postId);
    if (post) {
        post.liked = !post.liked;
        post.likes = (post.likes || 0) + (post.liked ? 1 : -1);
        renderPicturaFeed();
    }
}

function postStory() {
    sendNUI('postStory', { image: '' });
    showNotification('Pictura', 'Story publicado!', 'pictura');
}

function viewStory(index) {
    showNotification('Story', 'Visualizando story...', 'pictura');
}

// ============================================
// FLAMER APP
// ============================================
function renderFlamer() {
    renderFlamerCards();
    renderFlamerMatches();
}

function renderFlamerCards() {
    const container = document.getElementById('flamer-cards');
    if (!container) return;
    
    if (PhoneState.flamerProfiles.length === 0 || PhoneState.flamerIndex >= PhoneState.flamerProfiles.length) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-heart-broken" style="color:var(--flamer-pink)"></i>
                <p>${PhoneState.flamerProfiles.length === 0 ? 'Ninguem por perto' : 'Voce viu todos!'}</p>
            </div>
        `;
        return;
    }
    
    const profile = PhoneState.flamerProfiles[PhoneState.flamerIndex];
    let photos = [];
    try { photos = JSON.parse(profile.photos || '[]'); } catch (e) { photos = []; }
    
    container.innerHTML = `
        <div class="flamer-card" data-id="${profile.user_id}">
            ${photos[0] ? `<img src="${photos[0]}" alt="">` : 
            `<div style="width:100%;height:100%;background:linear-gradient(135deg,var(--flamer-orange),var(--flamer-pink));display:flex;align-items:center;justify-content:center">
                <i class="fas fa-user" style="font-size:80px;color:white;opacity:0.5"></i>
            </div>`}
            <div class="flamer-card-info">
                <span class="flamer-card-name">${profile.name || 'Anonimo'}</span>
                <span class="flamer-card-age">${profile.age || '?'}</span>
                <div class="flamer-card-bio">${profile.bio || ''}</div>
            </div>
        </div>
    `;
}

function swipeFlamer(direction) {
    if (PhoneState.flamerIndex >= PhoneState.flamerProfiles.length) return;
    
    const profile = PhoneState.flamerProfiles[PhoneState.flamerIndex];
    sendNUI('swipeFlamer', { profileId: profile.user_id, direction });
    
    PhoneState.flamerIndex++;
    renderFlamerCards();
}

function superLike() {
    if (PhoneState.flamerIndex >= PhoneState.flamerProfiles.length) return;
    
    const profile = PhoneState.flamerProfiles[PhoneState.flamerIndex];
    sendNUI('superLike', { profileId: profile.user_id });
    
    showNotification('Flamer', 'Super Like enviado!', 'flamer');
    PhoneState.flamerIndex++;
    renderFlamerCards();
}

function showFlamerProfile() {
    if (PhoneState.flamerProfile) {
        const bio = document.getElementById('flamer-bio');
        const age = document.getElementById('flamer-age');
        if (bio) bio.value = PhoneState.flamerProfile.bio || '';
        if (age) age.value = PhoneState.flamerProfile.age || '';
    }
    showScreen('flamer-profile');
}

function saveFlamerProfile() {
    const profile = {
        name: PhoneState.playerData.name,
        bio: document.getElementById('flamer-bio')?.value || '',
        age: parseInt(document.getElementById('flamer-age')?.value) || null,
        photos: []
    };
    sendNUI('updateFlamerProfile', profile);
    showNotification('Flamer', 'Perfil atualizado!', 'flamer');
    showApp('flamer-app');
}

function showFlamerMatches() {
    renderFlamerMatches();
    showScreen('flamer-matches');
}

function renderFlamerMatches() {
    const grid = document.getElementById('matches-grid');
    if (!grid) return;
    
    if (PhoneState.flamerMatches.length === 0) {
        grid.innerHTML = '<div class="empty-state"><i class="fas fa-heart"></i><p>Nenhum match ainda</p></div>';
        return;
    }
    
    grid.innerHTML = PhoneState.flamerMatches.map(match => {
        let photos = [];
        try { photos = JSON.parse(match.photos || '[]'); } catch (e) { photos = []; }
        return `
            <div class="match-item" onclick="openFlamerChat(${match.id})">
                <div class="match-avatar">
                    ${photos[0] ? `<img src="${photos[0]}" alt="">` : 
                    `<div style="width:100%;height:100%;background:var(--flamer-pink);display:flex;align-items:center;justify-content:center">
                        <i class="fas fa-user" style="color:white"></i>
                    </div>`}
                </div>
                <div class="match-name">${match.name || 'Match'}</div>
            </div>
        `;
    }).join('');
}

function handleFlamerMatch(match) {
    PhoneState.flamerMatches.push(match);
    showNotification("Match!", `Voce e ${match.name || 'alguem'} curtiram um ao outro!`, 'flamer');
}

function openFlamerChat(matchId) {
    showNotification('Chat', 'Abrindo conversa...', 'flamer');
}

// ============================================
// BANK APP
// ============================================
function updateBankDisplay() {
    const bankBalance = document.getElementById('bank-balance');
    const cashBalance = document.getElementById('cash-balance');
    if (bankBalance) bankBalance.textContent = formatMoney(PhoneState.bankData.bank);
    if (cashBalance) cashBalance.textContent = formatMoney(PhoneState.bankData.cash);
}

function updateBalance(cash, bank) {
    PhoneState.bankData.cash = cash;
    PhoneState.bankData.bank = bank;
    updateBankDisplay();
}

function showBankAction(action) {
    PhoneState.currentBankAction = action;
    const titles = { deposit: 'Depositar', withdraw: 'Sacar', transfer: 'Transferir' };
    
    const title = document.getElementById('bank-action-title');
    const transferGroup = document.getElementById('transfer-to-group');
    const amount = document.getElementById('bank-amount');
    const transferTo = document.getElementById('transfer-to');
    
    if (title) title.textContent = titles[action];
    if (transferGroup) transferGroup.style.display = action === 'transfer' ? 'block' : 'none';
    if (amount) amount.value = '';
    if (transferTo) transferTo.value = '';
    
    showModal('bank-action-modal');
}

function executeBankAction() {
    const amount = parseInt(document.getElementById('bank-amount')?.value);
    if (!amount || amount <= 0) return;
    
    switch (PhoneState.currentBankAction) {
        case 'deposit':
            sendNUI('bankDeposit', { amount });
            break;
        case 'withdraw':
            sendNUI('bankWithdraw', { amount });
            break;
        case 'transfer':
            const to = document.getElementById('transfer-to')?.value;
            if (to) sendNUI('bankTransfer', { to, amount });
            break;
    }
    
    hideModal('bank-action-modal');
}

function showBankHistory() {
    showNotification('Banco', 'Histórico em breve!', 'bank');
}

// ============================================
// CAMERA & GALLERY APP
// ============================================
function takePhoto() {
    sendNUI('takePhoto', {});
}

function renderGallery() {
    const grid = document.getElementById('gallery-grid');
    if (!grid) return;
    
    if (PhoneState.gallery.length === 0) {
        grid.innerHTML = '<div class="empty-state"><i class="fas fa-images"></i><p>Nenhuma foto</p></div>';
        return;
    }
    
    grid.innerHTML = PhoneState.gallery.map(photo => `
        <div class="gallery-item" onclick="viewPhoto('${photo.url}')">
            <img src="${photo.url}" alt="">
        </div>
    `).join('');
}

function viewPhoto(url) {
    // Full screen photo view
    showNotification('Foto', 'Visualizando...', 'gallery');
}

// ============================================
// NOTES APP
// ============================================
function renderNotes() {
    const list = document.getElementById('notes-list');
    if (!list) return;
    
    if (PhoneState.notes.length === 0) {
        list.innerHTML = '<div class="empty-state"><i class="fas fa-sticky-note"></i><p>Nenhuma nota</p></div>';
        return;
    }
    
    list.innerHTML = PhoneState.notes.map(note => `
        <div class="note-item" onclick="openNote(${note.id})">
            <div class="note-title">${note.title || 'Sem título'}</div>
            <div class="note-preview">${truncate(note.content || '', 50)}</div>
            <div class="note-date">${formatTime(note.updated_at)}</div>
        </div>
    `).join('');
}

function showNewNote() {
    PhoneState.currentNote = null;
    const title = document.getElementById('note-title');
    const content = document.getElementById('note-content');
    if (title) title.value = '';
    if (content) content.value = '';
    showScreen('note-editor');
}

function openNote(id) {
    const note = PhoneState.notes.find(n => n.id === id);
    if (note) {
        PhoneState.currentNote = id;
        const title = document.getElementById('note-title');
        const content = document.getElementById('note-content');
        if (title) title.value = note.title || '';
        if (content) content.value = note.content || '';
        showScreen('note-editor');
    }
}

function saveNote() {
    const title = document.getElementById('note-title')?.value;
    const content = document.getElementById('note-content')?.value;
    
    sendNUI('saveNote', { id: PhoneState.currentNote, title, content });
    showNotification('Notas', 'Nota salva!', 'notes');
    showApp('notes-app');
}

function deleteNote(id) {
    sendNUI('deleteNote', { id });
}

// ============================================
// EMAIL APP
// ============================================
function renderEmails() {
    const list = document.getElementById('email-list');
    if (!list) return;
    
    if (PhoneState.emails.length === 0) {
        list.innerHTML = '<div class="empty-state"><i class="fas fa-envelope"></i><p>Nenhum email</p></div>';
        return;
    }
    
    list.innerHTML = PhoneState.emails.map(email => `
        <div class="email-item" onclick="openEmail(${email.id})">
            ${!email.is_read ? '<div class="email-unread"></div>' : ''}
            <div class="email-content">
                <div class="email-sender">${email.sender}</div>
                <div class="email-subject">${email.subject || 'Sem assunto'}</div>
                <div class="email-preview">${truncate(email.body || '', 40)}</div>
            </div>
            <div class="email-time">${formatTime(email.created_at)}</div>
        </div>
    `).join('');
}

function showNewEmail() {
    showNotification('Email', 'Novo email em breve!', 'email');
}

function openEmail(id) {
    showNotification('Email', 'Visualizando email...', 'email');
}

// ============================================
// CALCULATOR APP
// ============================================
function calcDigit(digit) {
    const calc = PhoneState.calculator;
    if (calc.waitingForOperand) {
        calc.display = digit;
        calc.waitingForOperand = false;
    } else {
        calc.display = calc.display === '0' ? digit : calc.display + digit;
    }
    updateCalcDisplay();
}

function calcDecimal() {
    const calc = PhoneState.calculator;
    if (calc.waitingForOperand) {
        calc.display = '0.';
        calc.waitingForOperand = false;
    } else if (!calc.display.includes('.')) {
        calc.display += '.';
    }
    updateCalcDisplay();
}

function calcOperator(op) {
    const calc = PhoneState.calculator;
    const inputValue = parseFloat(calc.display);
    
    if (calc.previousValue === null) {
        calc.previousValue = inputValue;
    } else if (calc.operator) {
        const result = calculate(calc.previousValue, inputValue, calc.operator);
        calc.display = String(result);
        calc.previousValue = result;
    }
    
    calc.waitingForOperand = true;
    calc.operator = op;
    calc.history = `${calc.previousValue} ${getOperatorSymbol(op)}`;
    updateCalcDisplay();
}

function calcEquals() {
    const calc = PhoneState.calculator;
    const inputValue = parseFloat(calc.display);
    
    if (calc.operator && calc.previousValue !== null) {
        const result = calculate(calc.previousValue, inputValue, calc.operator);
        calc.history = `${calc.previousValue} ${getOperatorSymbol(calc.operator)} ${inputValue} =`;
        calc.display = String(result);
        calc.previousValue = null;
        calc.operator = null;
        calc.waitingForOperand = true;
    }
    updateCalcDisplay();
}

function calcClear() {
    PhoneState.calculator = {
        display: '0', history: '', operator: null,
        waitingForOperand: false, previousValue: null
    };
    updateCalcDisplay();
}

function calcToggleSign() {
    const calc = PhoneState.calculator;
    calc.display = String(parseFloat(calc.display) * -1);
    updateCalcDisplay();
}

function calcPercent() {
    const calc = PhoneState.calculator;
    calc.display = String(parseFloat(calc.display) / 100);
    updateCalcDisplay();
}

function calculate(a, b, op) {
    switch (op) {
        case '+': return a + b;
        case '-': return a - b;
        case '*': return a * b;
        case '/': return b !== 0 ? a / b : 0;
        default: return b;
    }
}

function getOperatorSymbol(op) {
    return { '+': '+', '-': '−', '*': '×', '/': '÷' }[op] || op;
}

function updateCalcDisplay() {
    const result = document.getElementById('calc-result');
    const history = document.getElementById('calc-history');
    if (result) result.textContent = PhoneState.calculator.display;
    if (history) history.textContent = PhoneState.calculator.history;
}

// ============================================
// MAPS APP
// ============================================
const presetLocations = {
    hospital: { x: 340.0, y: -1396.0 },
    police: { x: 425.0, y: -980.0 },
    garage: { x: -285.0, y: -886.0 },
    bank: { x: 150.0, y: -1040.0 }
};

function setWaypoint(type) {
    const loc = presetLocations[type];
    if (loc) {
        sendNUI('setWaypoint', loc);
        showNotification('GPS', 'Waypoint definido!', 'maps');
    }
}

function searchLocation() {
    const query = document.getElementById('maps-search')?.value;
    if (query) {
        showNotification('GPS', `Buscando: ${query}`, 'maps');
    }
}

// ============================================
// SERVICES APP
// ============================================
function callService(service) {
    sendNUI('call' + service.charAt(0).toUpperCase() + service.slice(1), {});
    showNotification(service.charAt(0).toUpperCase() + service.slice(1), 'Serviço chamado!', service);
}

function callEmergency(type) {
    const message = document.getElementById('emergency-message')?.value || 'Emergência';
    sendNUI('callPolice', { message });
    const msgEl = document.getElementById('emergency-message');
    if (msgEl) msgEl.value = '';
    showNotification('911', 'Polícia notificada!', 'police');
}

function handleServiceRequest(service, caller) {
    showNotification(`📍 ${service.toUpperCase()}`, `${caller.caller} precisa de ajuda!`, service);
}

// ============================================
// SETTINGS APP
// ============================================
function toggleSetting(setting) {
    const toggle = document.getElementById(setting + '-toggle');
    if (!toggle) return;
    
    const isActive = toggle.classList.toggle('active');
    const settings = {};
    settings[setting] = isActive;
    sendNUI('updateSettings', settings);
    
    if (setting === 'darkMode') {
        document.body.classList.toggle('dark-mode', isActive);
    }
}

function showWallpapers() {
    initializeWallpapers();
    showScreen('wallpaper-screen');
}

function selectWallpaper(wp) {
    document.querySelectorAll('.wallpaper-option').forEach(opt => opt.classList.remove('selected'));
    document.querySelector(`.wallpaper-option.${wp}`)?.classList.add('selected');
    
    const wallpaper = document.getElementById('wallpaper');
    if (wallpaper) wallpaper.className = 'wallpaper ' + wp;
    
    PhoneState.settings.wallpaper = wp;
    sendNUI('updateSettings', { wallpaper: wp });
}

// ============================================
// WEATHER APP
// ============================================
function updateWeather() {
    // Weather is static for now, could integrate with game weather
}

// ============================================
// MUSIC APP
// ============================================
function togglePlayPause() {
    const btn = document.getElementById('play-pause-btn');
    if (!btn) return;
    const icon = btn.querySelector('i');
    if (icon.classList.contains('fa-play')) {
        icon.classList.remove('fa-play');
        icon.classList.add('fa-pause');
    } else {
        icon.classList.remove('fa-pause');
        icon.classList.add('fa-play');
    }
}

// ============================================
// APPSTORE APP
// ============================================
function renderAppStore() {
    renderStoreCategories();
    renderStoreApps();
}

function renderStoreCategories() {
    const container = document.getElementById('store-categories');
    if (!container) return;
    
    container.innerHTML = AppCategories.map(cat => `
        <button class="store-category-btn ${PhoneState.storeCategory === cat.id ? 'active' : ''}" 
                onclick="filterStoreCategory('${cat.id}')">
            <i class="fas ${cat.icon}"></i>
            <span>${cat.name}</span>
        </button>
    `).join('');
}

function renderStoreApps() {
    const container = document.getElementById('store-apps-list');
    if (!container) return;
    
    const apps = Object.values(StoreApps).filter(app => {
        if (PhoneState.storeCategory === 'all') return true;
        return app.category === PhoneState.storeCategory;
    });
    
    if (apps.length === 0) {
        container.innerHTML = '<div class="empty-state"><i class="fas fa-store"></i><p>Nenhum app nesta categoria</p></div>';
        return;
    }
    
    container.innerHTML = apps.map(app => {
        const isInstalled = PhoneState.installedApps.includes(app.id);
        const isInstalling = PhoneState._installingApp === app.id;
        return `
            <div class="store-app-item" onclick="showAppDetail('${app.id}')">
                <div class="app-icon ${app.color}">
                    <i class="${app.icon.includes('fab') ? app.icon : 'fas ' + app.icon}"></i>
                </div>
                <div class="store-app-info">
                    <div class="store-app-name">${app.name}</div>
                    <div class="store-app-category">${getCategoryName(app.category)}</div>
                    <div class="store-app-rating">
                        ${renderStars(app.rating)} ${app.rating}
                    </div>
                </div>
                <div class="store-app-action">
                    ${isInstalling ? '<div class="store-installing"><div class="store-progress-ring"></div></div>' : 
                      isInstalled ? `<button class="store-open-btn" onclick="event.stopPropagation(); openApp('${app.id}')">ABRIR</button>` :
                      `<button class="store-get-btn" onclick="event.stopPropagation(); installStoreApp('${app.id}')">OBTER</button>`}
                </div>
            </div>
        `;
    }).join('');
}

function filterStoreCategory(category) {
    PhoneState.storeCategory = category;
    renderStoreCategories();
    renderStoreApps();
}

function searchStoreApps(query) {
    const container = document.getElementById('store-apps-list');
    if (!container || !query) {
        renderStoreApps();
        return;
    }
    
    const apps = Object.values(StoreApps).filter(app => 
        app.name.toLowerCase().includes(query.toLowerCase()) ||
        app.description.toLowerCase().includes(query.toLowerCase())
    );
    
    if (apps.length === 0) {
        container.innerHTML = '<div class="empty-state"><i class="fas fa-search"></i><p>Nenhum resultado</p></div>';
        return;
    }
    
    container.innerHTML = apps.map(app => {
        const isInstalled = PhoneState.installedApps.includes(app.id);
        return `
            <div class="store-app-item" onclick="showAppDetail('${app.id}')">
                <div class="app-icon ${app.color}">
                    <i class="${app.icon.includes('fab') ? app.icon : 'fas ' + app.icon}"></i>
                </div>
                <div class="store-app-info">
                    <div class="store-app-name">${app.name}</div>
                    <div class="store-app-category">${getCategoryName(app.category)}</div>
                </div>
                <div class="store-app-action">
                    ${isInstalled ? `<button class="store-open-btn" onclick="event.stopPropagation(); openApp('${app.id}')">ABRIR</button>` :
                      `<button class="store-get-btn" onclick="event.stopPropagation(); installStoreApp('${app.id}')">OBTER</button>`}
                </div>
            </div>
        `;
    }).join('');
}

function showAppDetail(appId) {
    const app = StoreApps[appId];
    if (!app) return;
    
    const isInstalled = PhoneState.installedApps.includes(appId);
    const detail = document.getElementById('app-detail-content');
    if (!detail) return;
    
    detail.innerHTML = `
        <div class="app-detail-header-section">
            <div class="app-icon app-detail-icon ${app.color}">
                <i class="${app.icon.includes('fab') ? app.icon : 'fas ' + app.icon}"></i>
            </div>
            <div class="app-detail-title">
                <h2>${app.name}</h2>
                <p>${app.developer}</p>
            </div>
            <div class="app-detail-action">
                ${isInstalled ? 
                    `<button class="store-uninstall-btn" onclick="uninstallStoreApp('${appId}')">REMOVER</button>` :
                    `<button class="store-get-btn large" onclick="installStoreApp('${appId}')">OBTER</button>`}
            </div>
        </div>
        <div class="app-detail-stats">
            <div class="stat">
                <div class="stat-value">${app.rating}</div>
                <div class="stat-label">${renderStars(app.rating)}</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat">
                <div class="stat-value">${app.downloads}</div>
                <div class="stat-label">Downloads</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat">
                <div class="stat-value">${app.size}</div>
                <div class="stat-label">Tamanho</div>
            </div>
        </div>
        <div class="app-detail-section">
            <h3>Sobre este app</h3>
            <p>${app.description}</p>
        </div>
        <div class="app-detail-section">
            <h3>Informacoes</h3>
            <div class="info-row"><span>Categoria</span><span>${getCategoryName(app.category)}</span></div>
            <div class="info-row"><span>Desenvolvedor</span><span>${app.developer}</span></div>
            <div class="info-row"><span>Tamanho</span><span>${app.size}</span></div>
            <div class="info-row"><span>Preco</span><span>${app.price === 0 ? 'Gratis' : '$' + app.price}</span></div>
        </div>
    `;
    
    showScreen('appstore-detail');
}

function installStoreApp(appId) {
    if (PhoneState.installedApps.includes(appId)) return;
    
    PhoneState._installingApp = appId;
    renderStoreApps();
    
    // Simulate download animation then install optimistically
    setTimeout(() => {
        PhoneState._installingApp = null;
        
        // Optimistic install (works in both browser and FiveM)
        if (!PhoneState.installedApps.includes(appId)) {
            PhoneState.installedApps.push(appId);
        }
        initializeApps();
        renderStoreApps();
        const app = StoreApps[appId];
        showNotification('App Store', `${app ? app.name : appId} instalado!`, 'appstore');
        
        // Notify server (best effort)
        try {
            fetch(`https://${GetParentResourceName()}/installApp`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ appId })
            }).catch(() => {});
        } catch(e) {}
    }, 1500);
}

function uninstallStoreApp(appId) {
    // Optimistic uninstall
    PhoneState.installedApps = PhoneState.installedApps.filter(id => id !== appId);
    initializeApps();
    renderStoreApps();
    showAppDetail(appId);
    showNotification('App Store', 'App removido!', 'appstore');
    
    // Notify server (best effort)
    try {
        fetch(`https://${GetParentResourceName()}/uninstallApp`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ appId })
        }).catch(() => {});
    } catch(e) {}
}

function getCategoryName(catId) {
    const cat = AppCategories.find(c => c.id === catId);
    return cat ? cat.name : catId;
}

function renderStars(rating) {
    const full = Math.floor(rating);
    const half = rating % 1 >= 0.5 ? 1 : 0;
    const empty = 5 - full - half;
    let html = '';
    for (let i = 0; i < full; i++) html += '<i class="fas fa-star"></i>';
    if (half) html += '<i class="fas fa-star-half-alt"></i>';
    for (let i = 0; i < empty; i++) html += '<i class="far fa-star"></i>';
    return html;
}

function openAppFromStore(appId) {
    showScreen('home-screen');
    setTimeout(() => openApp(appId), 300);
}

function toggleFlashlightAction(event) {
    event.stopPropagation();
    pulseDynamicIsland(true);
    showNotification('Lanterna', 'Atalho visual do iPhone ativado.', 'phone');
}

function openQuickCamera(event) {
    event.stopPropagation();
    pulseDynamicIsland(true);
    openApp('camera');
}
// ============================================
// NOTIFICATIONS
// ============================================
function showNotification(title, message, icon) {
    const toast = document.getElementById('notification-toast');
    if (!toast) return;
    
    const titleEl = toast.querySelector('.notification-title');
    const messageEl = toast.querySelector('.notification-message');
    const iconEl = toast.querySelector('.notification-icon i');
    
    if (titleEl) titleEl.textContent = title;
    if (messageEl) messageEl.textContent = message;
    
    const iconMap = {
        chirper: 'fas fa-dove', pictura: 'fas fa-camera-retro',
        flamer: 'fas fa-fire', messages: 'fas fa-comment',
        phone: 'fas fa-phone', bank: 'fas fa-university',
        taxi: 'fas fa-taxi', mechanic: 'fas fa-wrench',
        police: 'fas fa-shield-alt', ambulance: 'fas fa-ambulance',
        notes: 'fas fa-sticky-note', gallery: 'fas fa-images',
        email: 'fas fa-envelope', maps: 'fas fa-map-marked-alt'
    };
    
    if (iconEl) iconEl.className = iconMap[icon] || 'fas fa-bell';
    
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3000);
}

// ============================================
// MODAL HELPERS
// ============================================
function showModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) modal.classList.add('active');
}

function hideModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) modal.classList.remove('active');
}

// ============================================
// UTILITY FUNCTIONS
// ============================================
function sendNUI(action, data = {}) {
    fetch(`https://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    }).catch(() => {});
}

function GetParentResourceName() {
    return window.GetParentResourceName ? window.GetParentResourceName() : 'fivem-phone';
}

function formatTime(timestamp) {
    if (!timestamp) return '';
    const date = new Date(timestamp);
    const now = new Date();
    const diff = now - date;
    
    if (diff < 60000) return 'Agora';
    if (diff < 3600000) return Math.floor(diff / 60000) + 'm';
    if (diff < 86400000) return Math.floor(diff / 3600000) + 'h';
    if (diff < 604800000) return Math.floor(diff / 86400000) + 'd';
    return date.toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit' });
}

function formatDuration(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
}

function formatMoney(amount) {
    return '$' + (amount || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function truncate(str, maxLen) {
    if (!str) return '';
    return str.length <= maxLen ? str : str.substring(0, maxLen) + '...';
}

function hashCode(str) {
    let hash = 0;
    for (let i = 0; i < (str || '').length; i++) {
        hash = str.charCodeAt(i) + ((hash << 5) - hash);
    }
    return Math.abs(hash);
}

// ============================================
// KEYBOARD SHORTCUTS
// ============================================
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && PhoneState.isOpen) {
        if (PhoneState.controlCenterOpen) {
            closeControlCenter();
            return;
        }
        closePhone();
    }
});

// ============================================
// DEV MODE - Auto open for browser testing
// ============================================
// Uncomment to test in browser:
// setTimeout(() => {
//     openPhone(
//         { name: 'Teste', phone: '555-1234', identifier: 'test123' },
//         '12:00',
//         { wallpaper: 'wallpaper1', darkMode: false }
//     );
//     // Add sample data
//     handleData('contacts', [
//         { id: 1, name: 'João', number: '555-0001' },
//         { id: 2, name: 'Maria', number: '555-0002' }
//     ]);
//     handleData('tweets', [
//         { id: 1, author: 'test', author_name: 'Teste', content: 'Olá mundo! #FiveM', likes: 10, retweets: 2 }
//     ]);
// }, 500);


// UX polish helpers injected by Temac build
const __temacOriginalRenderMessages = typeof renderMessages === 'function' ? renderMessages : null;
renderMessages = function() {
    if (__temacOriginalRenderMessages) __temacOriginalRenderMessages();
    const input = document.getElementById('message-input');
    if (input && PhoneState.currentConversation && PhoneState.messageTyping[PhoneState.currentConversation]) {
        input.placeholder = 'A escrever...';
    } else if (input) {
        input.placeholder = 'iMessage';
    }
};

const __temacOriginalRenderBank = typeof renderBank === 'function' ? renderBank : null;
renderBank = function() {
    if (__temacOriginalRenderBank) __temacOriginalRenderBank();
    const app = document.getElementById('bank-app');
    if (!app) return;
    let wrap = app.querySelector('.temac-bank-history');
    if (!wrap) {
        wrap = document.createElement('div');
        wrap.className = 'temac-bank-history';
        app.querySelector('.app-content')?.appendChild(wrap);
    }
    const rows = (PhoneState.bankHistory || []).map(row => `<div class="temac-bank-row"><span>${row.title}</span><strong>$${row.amount}</strong></div>`).join('');
    wrap.innerHTML = `<div class="section-title">Resumo</div>${rows}`;
};
