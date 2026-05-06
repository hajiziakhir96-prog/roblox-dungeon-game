-- MonsterSpawner V2 Script
-- Letak: ServerScriptService
-- Berfungsi: Spawn dan manage 20 monsters dalam dungeon dengan AI behavior

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local PlayerInitializer = require(game.ServerStorage.Modules.PlayerInitializer or game.ServerScriptService.PlayerInitializer)

local Monster = require(game.ServerStorage.Modules.Monster)
local Combat = require(game.ServerStorage.Modules.Combat)

-- ===== SPAWNER CONFIGURATION =====
local SPAWNER_CONFIG = {
    maxMonstersPerSpawn = 1,        -- 1 monster per spawn point
    spawnInterval = 2,              -- Spawn new monster every 2 seconds
    monsterDetectionRange = 40,     -- Chase player within 40 studs
    monsterWalkSpeed = 16,          -- Monster movement speed
    patrolSpeed = 10,               -- Patrol speed
    monsterModel = nil,             -- Will use generic humanoid model
}

-- Monster tracking
local activeMonsters = {}
local monsterInstances = {}  -- Store Roblox instances
local spawnPointIndex = 1

-- Get all spawn points
local function getSpawnPoints()
    local spawnFolder = Workspace:FindFirstChild("Dungeon") and Workspace.Dungeon:FindFirstChild("MonsterSpawnPoints")
    if not spawnFolder then
        print("[MonsterSpawner] ERROR: MonsterSpawnPoints folder not found!")
        return {}
    end
    
    local spawnPoints = {}
    for _, spawnPart in pairs(spawnFolder:GetChildren()) do
        table.insert(spawnPoints, spawnPart)
    end
    
    return spawnPoints
end

-- ===== CREATE MONSTER HUMANOID MODEL =====
local function createMonsterModel(position, monsterType)
    local model = Instance.new("Model")
    model.Name = "Monster_" .. monsterType
    
    -- Body part
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Shape = Enum.PartType.Ball
    head.Size = Vector3.new(2, 2, 2)
    head.Position = position + Vector3.new(0, 1, 0)
    head.CanCollide = true
    head.Parent = model
    
    -- Torso
    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Shape = Enum.PartType.Block
    torso.Size = Vector3.new(2, 3, 1)
    torso.Position = position + Vector3.new(0, 2.5, 0)
    torso.CanCollide = true
    torso.Parent = model
    
    -- Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = model
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    
    -- Color based on monster type
    local color = Color3.fromRGB(0, 255, 0)  -- Green = Goblin
    if monsterType == "orc" then
        color = Color3.fromRGB(128, 128, 128)  -- Gray
    elseif monsterType == "troll" then
        color = Color3.fromRGB(139, 69, 19)  -- Brown
    end
    
    head.Color = color
    torso.Color = color
    
    model:SetPrimaryPartCFrame(CFrame.new(position))
    model.Parent = Workspace
    
    return model
end

-- ===== SPAWN MONSTER AT LOCATION =====
local function spawnMonster(spawnPoint)
    local monsterTypes = {"goblin", "goblin", "goblin", "orc", "orc", "troll"}  -- Weighted distribution
    local randomType = monsterTypes[math.random(#monsterTypes)]
    
    -- Create monster stats
    local monsterStats = Monster.new(randomType)
    
    -- Create combat system for monster
    local monsterCombat = Combat.new(monsterStats)
    
    -- Create physical model
    local monsterModel = createMonsterModel(spawnPoint.Position, randomType)
    
    -- Store monster data
    local monsterData = {
        stats = monsterStats,
        combat = monsterCombat,
        model = monsterModel,
        humanoid = monsterModel:FindFirstChildOfClass("Humanoid"),
        targetPlayer = nil,
        lastAttackTime = 0,
        patrolDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit,
        patrolTimer = 0,
        isAlive = true,
    }
    
    -- Update humanoid health
    monsterData.humanoid.MaxHealth = monsterStats.maxHealth
    monsterData.humanoid.Health = monsterStats.maxHealth
    
    -- Handle monster death
    monsterData.humanoid.Died:Connect(function()
        onMonsterDeath(monsterData, spawnPoint)
    end)
    
    table.insert(activeMonsters, monsterData)
    table.insert(monsterInstances, monsterModel)
    
    print("[MonsterSpawner] " .. randomType:upper() .. " spawned at " .. spawnPoint.Name .. " (Total: " .. #activeMonsters .. "/20)")
    
    return monsterData
end

-- ===== HANDLE MONSTER DEATH =====
local function onMonsterDeath(monsterData, spawnPoint)
    print("[MonsterSpawner] Monster " .. monsterData.stats.type .. " died!")
    
    -- Give loot to nearby players
    local players = Players:GetPlayers()
    if #players > 0 then
        local player = players[1]  -- Give loot to first player for now
        local playerData = PlayerInitializer.getPlayerData(player)
        
        if playerData then
            -- Add experience
            playerData.stats:addExperience(monsterData.stats.experienceReward)
            
            -- Add gold (random 10-30)
            local goldDrop = math.random(10, 30)
            playerData.currency:add("gold", goldDrop)
            
            print("[MonsterSpawner] " .. player.Name .. " gained " .. monsterData.stats.experienceReward .. " XP and " .. goldDrop .. " gold!")
        end
    end
    
    -- Remove monster
    for i, monster in ipairs(activeMonsters) do
        if monster == monsterData then
            table.remove(activeMonsters, i)
            break
        end
    end
    
    -- Destroy model
    monsterData.model:Destroy()
    
    -- Respawn after delay
    task.wait(3)
    spawnMonster(spawnPoint)
end

-- ===== MONSTER AI BEHAVIOR =====
local function updateMonsterAI(monsterData)
    if not monsterData.isAlive or not monsterData.model.Parent then return end
    
    local monsterPosition = monsterData.model:GetPrimaryPartCFrame().Position
    local playersNearby = {}
    
    -- Check for nearby players
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local playerPos = player.Character:GetPrimaryPartCFrame().Position
            local distance = (monsterPosition - playerPos).Magnitude
            
            if distance < SPAWNER_CONFIG.monsterDetectionRange then
                table.insert(playersNearby, {player = player, distance = distance})
            end
        end
    end
    
    -- Sort by distance
    table.sort(playersNearby, function(a, b) return a.distance < b.distance end)
    
    if #playersNearby > 0 then
        -- Chase nearest player
        local target = playersNearby[1].player
        monsterData.targetPlayer = target
        
        if target.Character then
            local targetPos = target.Character:GetPrimaryPartCFrame().Position
            local direction = (targetPos - monsterPosition).Unit
            
            -- Move towards player
            monsterData.model:MoveTo(monsterPosition + direction * SPAWNER_CONFIG.monsterWalkSpeed * 0.016)
            
            -- Try to attack
            local distanceToPlayer = (targetPos - monsterPosition).Magnitude
            if distanceToPlayer < 5 then  -- Attack range
                local playerData = PlayerInitializer.getPlayerData(target)
                if playerData and (tick() - monsterData.lastAttackTime) > 1 then
                    -- Monster attacks player
                    local damage, isCrit = monsterData.combat:calculateDamage()
                    playerData.stats:takeDamage(damage)
                    monsterData.lastAttackTime = tick()
                    print("[MonsterSpawner] Monster attacks " .. target.Name .. " for " .. string.format("%.1f", damage) .. " damage!")
                end
            end
        end
    else
        -- Patrol behavior
        monsterData.patrolTimer = monsterData.patrolTimer + 0.016
        
        if monsterData.patrolTimer > 3 then
            -- Change patrol direction randomly
            monsterData.patrolDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
            monsterData.patrolTimer = 0
        end
        
        -- Move in patrol direction
        monsterData.model:MoveTo(monsterPosition + monsterData.patrolDirection * SPAWNER_CONFIG.patrolSpeed * 0.016)
        monsterData.targetPlayer = nil
    end
end

-- ===== MAIN SPAWN LOOP =====
local function main()
    print("\n" .. string.rep("=", 60))
    print("[MonsterSpawner] Initializing monster spawner...")
    print(string.rep("=", 60) .. "\n")
    
    local spawnPoints = getSpawnPoints()
    
    if #spawnPoints == 0 then
        print("[MonsterSpawner] ERROR: No spawn points found! Check DungeonLayout.")
        return
    end
    
    print("[MonsterSpawner] Found " .. #spawnPoints .. " spawn points")
    
    -- Initial spawn - 1 monster per spawn point
    for i, spawnPoint in ipairs(spawnPoints) do
        task.wait(0.1)
        spawnMonster(spawnPoint)
    end
    
    print("\n[MonsterSpawner] ✓ All monsters spawned! (" .. #activeMonsters .. "/20)\n")
    
    -- AI Update loop (60 FPS)
    game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
        for _, monsterData in ipairs(activeMonsters) do
            updateMonsterAI(monsterData)
        end
    end)
end

-- Start spawner
main()

-- Return module for other scripts
return {
    activeMonsters = activeMonsters,
    monsterInstances = monsterInstances,
}
