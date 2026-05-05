-- Monster Module
-- Manages monster spawning, behavior, and properties

local Monster = {}

-- Monster types and their properties
local MONSTER_TYPES = {
    goblin = {
        name = "Goblin",
        level = 1,
        maxHealth = 30,
        strength = 2,
        agility = 4,
        defense = 1,
        experienceReward = 50,
        lootDropChance = 0.3,
    },
    orc = {
        name = "Orc",
        level = 3,
        maxHealth = 60,
        strength = 5,
        agility = 2,
        defense = 3,
        experienceReward = 150,
        lootDropChance = 0.5,
    },
    troll = {
        name = "Troll",
        level = 5,
        maxHealth = 100,
        strength = 7,
        agility = 1,
        defense = 5,
        experienceReward = 300,
        lootDropChance = 0.7,
    },
}

-- Create new monster
function Monster.new(monsterType)
    monsterType = monsterType or "goblin"
    local config = MONSTER_TYPES[monsterType]
    
    if not config then
        error("Monster type '" .. monsterType .. "' tidak dikenali!")
    end
    
    local monster = setmetatable({}, { __index = Monster })
    monster.type = monsterType
    monster.name = config.name
    monster.level = config.level
    monster.maxHealth = config.maxHealth
    monster.currentHealth = config.maxHealth
    monster.strength = config.strength
    monster.agility = config.agility
    monster.defense = config.defense
    monster.experienceReward = config.experienceReward
    monster.lootDropChance = config.lootDropChance
    monster.isAlive = true
    
    return monster
end

-- Get monster's max attack damage
function Monster:getMaxAttackDamage()
    local baseDamage = 5
    local strengthBonus = self.strength * 1.5
    return baseDamage + strengthBonus
end

-- Get monster's attack speed
function Monster:getAttackSpeed()
    local baseSpeed = 0.5
    local agilityBonus = (self.agility - 5) * 0.05
    return baseSpeed + agilityBonus
end

-- Get damage reduction
function Monster:getDamageReduction()
    local baseReduction = 0.05
    local defenseBonus = (self.defense - 5) * 0.03
    return math.min(baseReduction + defenseBonus, 0.5)
end

-- Take damage
function Monster:takeDamage(damage)
    local reduction = self:getDamageReduction()
    local actualDamage = damage * (1 - reduction)
    self.currentHealth = self.currentHealth - actualDamage
    
    if self.currentHealth <= 0 then
        self.currentHealth = 0
        self.isAlive = false
    end
    
    return actualDamage
end

-- Get monster info
function Monster:getInfo()
    return {
        type = self.type,
        name = self.name,
        level = self.level,
        currentHealth = self.currentHealth,
        maxHealth = self.maxHealth,
        isAlive = self.isAlive,
        strength = self.strength,
        agility = self.agility,
        defense = self.defense,
    }
end

return Monster
