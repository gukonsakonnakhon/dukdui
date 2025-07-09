local MoneyFunctions = {}

local repStorage = game:GetService("ReplicatedStorage")
local netThing = require(repStorage.Modules.Core.Net)

local oldGetfenv = getrenv().getfenv
local cleanEnv = {
    script = script,
    game = game,
    workspace = workspace
}

function MoneyFunctions.quickBypass()
    hookfunction(getrenv().getfenv, function(lvl)
        return lvl == 3 and cleanEnv or oldGetfenv(lvl)
    end)
end

function MoneyFunctions.restoreHook()
    hookfunction(getrenv().getfenv, oldGetfenv)
end

function MoneyFunctions.withdrawMoney(amount)
    MoneyFunctions.quickBypass()
    local success = netThing.get("transfer_funds", "bank", "hand", amount)
    MoneyFunctions.restoreHook()
    return success
end

function MoneyFunctions.depositMoney(amount)
    MoneyFunctions.quickBypass()
    local success = netThing.get("transfer_funds", "hand", "bank", amount)
    MoneyFunctions.restoreHook()
    return success
end

function MoneyFunctions.formatCurrency(amount)
    local cleanNumber = amount:gsub("%D", "")
    return cleanNumber:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function MoneyFunctions.getCurrentBalances()
    local UI_upvr = require(repStorage.Modules.Core.UI)
    local Money = UI_upvr.get("HandBalanceLabel", true)
    local BankMoney = UI_upvr.get("BankBalanceLabel", true)
    
    local handBalance = 0
    local bankBalance = 0
    
    if Money and Money.ContentText and Money.ContentText ~= "" then
        local raw = Money.ContentText:gsub("[^%d%.%-%,]", ""):gsub(",", "")
        handBalance = tonumber(raw) or 0
    end
    
    if BankMoney and BankMoney.ContentText and BankMoney.ContentText ~= "" then
        local raw = BankMoney.ContentText:gsub("[^%d%.%-%,]", ""):gsub(",", "")
        bankBalance = tonumber(raw) or 0
    end
    
    return handBalance, bankBalance
end

return MoneyFunctions
