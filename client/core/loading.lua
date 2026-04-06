-- Loading System

PhoneLoading = {}
PhoneLoading.active = false

function PhoneLoading:Start()
    if self.active then return end
    self.active = true

    if PhoneCore then
        PhoneCore:SetBusy(true)
    end
end

function PhoneLoading:Stop()
    self.active = false

    if PhoneCore then
        PhoneCore:SetBusy(false)
    end
end

function PhoneLoading:IsActive()
    return self.active
end
