-- Loading System
PhoneLoading = PhoneLoading or {}
PhoneLoading.active = false

function PhoneLoading:Start()
    if self.active then return end
    self.active = true
    if PhoneCore then PhoneCore:SetBusy(true) end
    SendNUIMessage({ type = 'phoneLoading', active = true })
end

function PhoneLoading:Stop()
    self.active = false
    if PhoneCore then PhoneCore:SetBusy(false) end
    SendNUIMessage({ type = 'phoneLoading', active = false })
end

function PhoneLoading:IsActive() return self.active end
