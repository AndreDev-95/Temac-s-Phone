-- Core State Manager

PhoneCore = {}
PhoneCore.isBusy = false

function PhoneCore:SetBusy(state)
    self.isBusy = state
end

function PhoneCore:IsBusy()
    return self.isBusy
end

function PhoneCore:CanOpen()
    return not self.isBusy
end
