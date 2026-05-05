-- PlayerInitializer Server Script
-- Letak: ServerScriptService
-- Berfungsi: Initialize player stats ketika join game

local Players = game:GetService("Players")
local PlayerStats = require(game.ServerStorage.Modules.PlayerStats)
local Currency = require(game.ServerStorage.Modules.Currency)
local Combat = require(game.ServerStorage.Modules.Combat)

-- Dictionary untuk simpan player data
local playerData = {}

-- Constant untuk starting values
local STARTING_GOLD = 500
local STARTING_ROBUX = 0

-- ===== PLAYER JOINED =====
Players.PlayerAdded:Connect(function(player)
    print("[PlayerInitializer] " .. player.Name .. " joined the game!")
    
    -- Create stats object
    local stats = PlayerStats.new(player)
    
    -- Create currency object
    local currency = Currency.new(player)
    
    -- Create combat system
    local combat = Combat.new(stats)
    
    -- Store semua data dalam dictionary
    playerData[player.UserId] = {
        player = player,
        stats = stats,
        currency = currency,
        combat = combat,
        joinTime = tick(),
    }
    
    -- Give starting currency
    currency:add("gold", STARTING_GOLD)
    currency:add("robux", STARTING_ROBUX)
    
    -- Print player info
    print("[PlayerInitializer] Stats created for " .. player.Name)
    print("  - Level: " .. stats.level)
    print("  - Max Health: " .. stats.maxHealth)
    print("  - Starting Gold: " .. STARTING_GOLD)
    
    -- Wait for character to load
    if player.Character then
        onCharacterLoaded(player, playerData[player.UserId])
    end
    
    -- Handle character respawn
    player.CharacterAdded:Connect(function(character)
        onCharacterLoaded(player, playerData[player.UserId])
    end)
end)

-- ===== CHARACTER LOADED =====
function onCharacterLoaded(player, data)
    print("[PlayerInitializer] " .. player.Name .. "'s character loaded!")
    
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Set humanoid max health dari stats
    humanoid.MaxHealth = data.stats.maxHealth
    humanoid.Health = data.stats.maxHealth
    
    -- Update character reference
    data.stats.character = character
    
    -- Handle humanoid death
    humanoid.Died:Connect(function()
        onCharacterDied(player, data)
    end)
end

-- ===== CHARACTER DIED =====
function onCharacterDied(player, data)
    print("[PlayerInitializer] " .. player.Name .. " died!")
    
    -- Reset health untuk next life
    data.stats.currentHealth = data.stats.maxHealth
    
    -- TODO: Add respawn timer, penalty logic
end

-- ===== PLAYER LEAVING =====
Players.PlayerRemoving:Connect(function(player)
    print("[PlayerInitializer] " .. player.Name .. " left the game!")
    
    -- TODO: Save player data to database
    
    -- Remove from dictionary
    playerData[player.UserId] = nil
end)

-- ===== GET PLAYER DATA (for other scripts) =====
function getPlayerData(player)
    return playerData[player.UserId]
end

-- ===== GET PLAYER DATA BY USER ID =====
function getPlayerDataByUserId(userId)
    return playerData[userId]
end

-- ===== TEST COMMANDS (optional - remove in production) =====
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        local data = playerData[player.UserId]
        if not data then return end
        
        -- Test command: /stats
        if message == "/stats" then
            local summary = data.stats:getStatsSummary()
            print("\n=== " .. player.Name .. "'s Stats ===")
            print("Level: " .. summary.level)
            print("EXP: " .. summary.experience .. "/" .. summary.experienceToLevel)
            print("Health: " .. summary.currentHealth .. "/" .. summary.maxHealth)
            print("Strength: " .. summary.strength)
            print("Agility: " .. summary.agility)
            print("Defense: " .. summary.defense)
            print("Skill Points: " .. summary.skillPoints)
            print("Max Attack Damage: " .. string.format("%.1f", summary.maxAttackDamage))
            print("Attack Speed: " .. string.format("%.2f", summary.attackSpeed))
            print("Damage Reduction: " .. string.format("%.1f%%", summary.damageReduction * 100))
            print("Gold: " .. data.currency:getBalance("gold"))
            print("Robux: " .. data.currency:getBalance("robux"))
            print("========================\n")
        end
        
        -- Test command: /addexp [amount]
        if string.sub(message, 1, 7) == "/addexp" then
            local amount = tonumber(string.sub(message, 9))
            if amount then
                data.stats:addExperience(amount)
                print(player.Name .. " gained " .. amount .. " experience!")
            end
        end
        
        -- Test command: /addgold [amount]
        if string.sub(message, 1, 8) == "/addgold" then
            local amount = tonumber(string.sub(message, 10))
            if amount then
                data.currency:add("gold", amount)
                print(player.Name .. " gained " .. amount .. " gold!")
            end
        end
        
        -- Test command: /upgrade [stat] [points]
        if string.sub(message, 1, 8) == "/upgrade" then
            local args = string.split(message, " ")
            if args[2] and args[3] then
                local stat = args[2]
                local points = tonumber(args[3])
                if points then
                    local success, message = data.stats:upgradeStat(stat, points)
                    print(message)
                end
            end
        end
    end)
end)

-- Export functions untuk script lain
return {
    getPlayerData = getPlayerData,
    getPlayerDataByUserId = getPlayerDataByUserId,
    playerData = playerData,
}
