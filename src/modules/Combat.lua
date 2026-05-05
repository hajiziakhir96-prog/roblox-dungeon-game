-- Combat Module
-- Manages player attacks, damage calculation, and combat mechanics

local Combat = {}

-- Combat configuration
local COMBAT_CONFIG = {
    minDamageVariation = 0.8,  -- 80% of base damage
    maxDamageVariation = 1.2,  -- 120% of base damage
    criticalChance = 0.15,      -- 15% crit chance
    criticalMultiplier = 1.5,   -- 1.5x damage on crit
    comboWindow = 0.5,          -- 0.5 second window for combos
}

-- Initialize combat system for a player
function Combat.new(playerStats)
    local combat = setmetatable({}, { __index = Combat })
    combat.playerStats = playerStats
    combat.lastAttackTime = 0
    combat.comboCounter = 0
    
    return combat
end

-- Calculate damage from attack
function Combat:calculateDamage()
    local baseDamage = self.playerStats:getMaxAttackDamage()
    
    -- Random damage variation
    local variation = math.random(COMBAT_CONFIG.minDamageVariation * 100, COMBAT_CONFIG.maxDamageVariation * 100) / 100
    local damage = baseDamage * variation
    
    -- Check for critical hit
    if math.random() < COMBAT_CONFIG.criticalChance then
        damage = damage * COMBAT_CONFIG.criticalMultiplier
        return damage, true  -- true = critical hit
    end
    
    return damage, false
end

-- Perform an attack
function Combat:attack(targetStats)
    local currentTime = tick()
    local timeSinceLastAttack = currentTime - self.lastAttackTime
    local attackSpeed = self.playerStats:getAttackSpeed()
    local attackCooldown = 1 / attackSpeed  -- Faster agility = shorter cooldown
    
    -- Check if attack is ready
    if timeSinceLastAttack < attackCooldown then
        return false, "Attack on cooldown! " .. string.format("%.2f", attackCooldown - timeSinceLastAttack) .. "s remaining"
    end
    
    -- Calculate damage
    local damage, isCritical = self:calculateDamage()
    
    -- Apply damage to target
    local actualDamage = targetStats:takeDamage(damage)
    
    -- Update attack tracking
    self.lastAttackTime = currentTime
    self.comboCounter = self.comboCounter + 1
    
    -- Reset combo if too much time has passed
    if self.comboCounter > 1 and timeSinceLastAttack > COMBAT_CONFIG.comboWindow then
        self.comboCounter = 1
    end
    
    local damageText = string.format("%.1f", actualDamage)
    local criticalText = isCritical and " (CRITICAL!)" or ""
    
    return true, damageText .. criticalText, self.comboCounter
end

-- Get combo multiplier
function Combat:getComboMultiplier()
    return 1 + (self.comboCounter - 1) * 0.25  -- +25% per combo hit
end

-- Reset combo counter
function Combat:resetCombo()
    self.comboCounter = 0
end

return Combat
