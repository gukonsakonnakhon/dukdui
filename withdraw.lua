return function(amount)
    local result = nil
    local completed = false
    
    task.spawn(function()
        local repStorage = game:GetService("ReplicatedStorage")
        local netThing = require(repStorage.Modules.Core.Net)
        result = netThing.get("transfer_funds", "bank", "hand", amount)
        completed = true
    end)
    
    repeat task.wait() until completed
    return result
end
