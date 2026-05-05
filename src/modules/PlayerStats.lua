-- PlayerStats Module
-- Manages player statistics, experience, leveling, dan skill points

local PlayerStats = {}

-- Default stat configuration
local DEFAULT_STATS = {
    level = 1,
    experience = 0,
    experienceToLevel = 100,
    skillPoints = 0,
    
    -- Combat Stats
    maxHealth = 100,
    currentHealth = 100,
    strength = 5,      -- Damage multiplier
    agility = 5,       -- Attack speed
    defense = 5,       -- Damage reduction
    
    -- Equipment
    equippedWeapon = nil,
    weaponDamage = 10,
}

-- Initialize player stats
function PlayerStats.new(player)
    local stats = setmetatable({}, { __index = PlayerStats })
    stats.player = player
    stats.character = player.Character
    
    -- Copy default stats
    for key, value in pairs(DEFAULT_STATS) do
        stats[key] = value
    end
    
    -- Reset health to max
    stats.currentHealth = stats.maxHealth
    
    return stats
end

-- Get player's total damage (strength based)
function PlayerStats:getMaxAttackDamage()
    local baseDamage = self.weaponDamage
    local strengthBonus = self.strength * 1.5
    return baseDamage + strengthBonus
end

-- Get attack speed (agility based)
function PlayerStats:getAttackSpeed()
    local baseSpeed = 1.0
    local agilityBonus = (self.agility - 5) * 0.02  -- 5% per agility point above 5
    return baseSpeed + agilityBonus
end

-- Get damage reduction percentage (defense based)
function PlayerStats:getDamageReduction()
    local baseReduction = 0.1  -- 10% base reduction
    local defenseBonus = (self.defense - 5) * 0.02  -- 2% per defense point above 5
    return math.min(baseReduction + defenseBonus, 0.8)  -- Max 80% reduction
end

-- Add experience
function PlayerStats:addExperience(amount)
    self.experience = self.experience + amount
    
    -- Check for level up
    while self.experience >= self.experienceToLevel do
        self:levelUp()
    end
    
    return self.experience
end

-- Level up the player
function PlayerStats:levelUp()
    self.level = self.level + 1
    self.experience = self.experience - self.experienceToLevel
    self.experienceToLevel = math.floor(self.experienceToLevel * 1.1)  -- 10% more exp needed
    self.skillPoints = self.skillPoints + 1
    self.maxHealth = self.maxHealth + 10
    self.currentHealth = self.maxHealth
    
    print(self.player.Name .. " leveled up to " .. self.level .. "! Skill Points: " .. self.skillPoints)
    return self.level
end

-- Upgrade stat dengan skill point
function PlayerStats:upgradeStat(statName, points)
    if self.skillPoints < points then
        return false, "Tidak cukup skill points!"
    end
    
    if statName == "strength" then
        self.strength = self.strength + points
        self.skillPoints = self.skillPoints - points
        return true, "Strength upgraded to " .. self.strength
        
    elseif statName == "agility" then
        self.agility = self.agility + points
        self.skillPoints = self.skillPoints - points
        return true, "Agility upgraded to " .. self.agility
        
    elseif statName == "defense" then
        self.defense = self.defense + points
        self.skillPoints = self.skillPoints - points
        return true, "Defense upgraded to " .. self.defense
    else
        return false, "Stat tidak dikenali!"
    end
end

-- Take damage (dengan defense reduction)
function PlayerStats:takeDamage(damage)
    local reduction = self:getDamageReduction()
    local actualDamage = damage * (1 - reduction)
    self.currentHealth = self.currentHealth - actualDamage
    
    if self.currentHealth <= 0 then
        self.currentHealth = 0
        self:onDeath()
    end
    
    return actualDamage
end

-- Heal player
function PlayerStats:heal(amount)
    self.currentHealth = math.min(self.currentHealth + amount, self.maxHealth)
    return self.currentHealth
end

-- Handle player death
function PlayerStats:onDeath()
    print(self.player.Name .. " died!")
    -- TODO: Respawn logic, death penalties, etc
end

-- Get all stats summary
function PlayerStats:getStatsSummary()
    return {
        level = self.level,
        experience = self.experience,
        experienceToLevel = self.experienceToLevel,
        skillPoints = self.skillPoints,
        currentHealth = self.currentHealth,
        maxHealth = self.maxHealth,
        strength = self.strength,
        agility = self.agility,
        defense = self.defense,
        maxAttackDamage = self:getMaxAttackDamage(),
        attackSpeed = self:getAttackSpeed(),
        damageReduction = self:getDamageReduction(),
    }
end

return PlayerStats
