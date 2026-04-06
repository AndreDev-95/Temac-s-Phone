-- Core State Manager
PhoneCore = PhoneCore or {}
PhoneCore.isBusy = false
PhoneCore.currentApp = nil

function PhoneCore:SetBusy(state) self.isBusy = state end
function PhoneCore:IsBusy() return self.isBusy end
function PhoneCore:CanOpen() return not self.isBusy end
function PhoneCore:SetCurrentApp(app) self.currentApp = app end
function PhoneCore:GetCurrentApp() return self.currentApp end
