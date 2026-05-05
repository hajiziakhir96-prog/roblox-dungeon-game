-- Currency Module
-- Manages in-game currency (gold) and Robux (premium currency)

local Currency = {}

-- Currency types
local CURRENCY_TYPES = {
    gold = {
        name = "Gold",
        premium = false,
        symbol = "G",
    },
    robux = {
        name = "Robux",
        premium = true,
        symbol = "R$",
    },
}

-- Initialize player currency
function Currency.new(player)
    local currency = setmetatable({}, { __index = Currency })
    currency.player = player
    currency.balances = {
        gold = 0,
        robux = 0,
    }
    
    return currency
end

-- Add currency
function Currency:add(currencyType, amount)
    if not self.balances[currencyType] then
        return false, "Currency type tidak dikenali!"
    end
    
    self.balances[currencyType] = self.balances[currencyType] + amount
    return true, amount
end

-- Remove currency (spend)
function Currency:remove(currencyType, amount)
    if not self.balances[currencyType] then
        return false, "Currency type tidak dikenali!"
    end
    
    if self.balances[currencyType] < amount then
        return false, "Tidak cukup " .. CURRENCY_TYPES[currencyType].name .. "!"
    end
    
    self.balances[currencyType] = self.balances[currencyType] - amount
    return true
end

-- Get balance
function Currency:getBalance(currencyType)
    return self.balances[currencyType] or 0
end

-- Get all balances
function Currency:getAllBalances()
    return {
        gold = self.balances.gold,
        robux = self.balances.robux,
    }
end

-- Format currency for display
function Currency:formatCurrency(currencyType, amount)
    local symbol = CURRENCY_TYPES[currencyType].symbol
    return symbol .. " " .. string.format("%,d", amount)
end

return Currency
