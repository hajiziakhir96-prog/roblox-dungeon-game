-- DungeonLayout V3 Script (GREEN LOBBY + TELEPORT)
-- Letak: ServerScriptService
-- Berfungsi: Green hill lobby dengan teleport ke dungeon

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- ===== DUNGEON CONFIGURATION V3 =====
local DUNGEON_CONFIG = {
    -- GREEN LOBBY (outdoor hill style)
    lobby = {
        -- Main green hill floor
        floorSize = Vector3.new(100, 3, 100),
        floorPosition = Vector3.new(0, -1, 0),
        floorColor = Color3.fromRGB(34, 139, 34),  -- Forest green
        
        -- Decorative green walls (hill slopes)
        hillWalls = {
            {size = Vector3.new(100, 15, 5), position = Vector3.new(0, 5, -50), color = Color3.fromRGB(34, 139, 34)},  -- Front
            {size = Vector3.new(100, 15, 5), position = Vector3.new(0, 5, 50), color = Color3.fromRGB(34, 139, 34)},   -- Back
            {size = Vector3.new(5, 15, 100), position = Vector3.new(-50, 5, 0), color = Color3.fromRGB(34, 139, 34)}, -- Left
            {size = Vector3.new(5, 15, 100), position = Vector3.new(50, 5, 0), color = Color3.fromRGB(34, 139, 34)},  -- Right
        },
        
        -- Teleport pad (CENTER)
        teleportPad = {
            size = Vector3.new(20, 0.5, 20),
            position = Vector3.new(0, 2, 0),
            color = Color3.fromRGB(0, 255, 255),  -- Cyan glow
            destinationDungeon = Vector3.new(0, 2, 90),  -- Dungeon floor entrance
        },
        
        -- Decorative trees (simple cubes for now)
        trees = {
            {position = Vector3.new(-30, 3, -30), size = Vector3.new(3, 8, 3), color = Color3.fromRGB(139, 69, 19)},  -- Brown trunk
            {position = Vector3.new(30, 3, -30), size = Vector3.new(3, 8, 3), color = Color3.fromRGB(139, 69, 19)},
            {position = Vector3.new(-30, 3, 30), size = Vector3.new(3, 8, 3), color = Color3.fromRGB(139, 69, 19)},
            {position = Vector3.new(30, 3, 30), size = Vector3.new(3, 8, 3), color = Color3.fromRGB(139, 69, 19)},
        },
        
        -- Sky dome background (visual only)
        skyColor = Color3.fromRGB(135, 206, 235),  -- Sky blue
    },
    
    -- Cave dungeon settings
    dungeon = {
        -- Main floor
        floorSize = Vector3.new(200, 2, 200),
        floorPosition = Vector3.new(0, -1, 150),
        floorColor = Color3.fromRGB(60, 50, 40),  -- Dark brown (rocky)
        
        -- Ceiling
        ceilingSize = Vector3.new(200, 2, 200),
        ceilingPosition = Vector3.new(0, 30, 150),
        ceilingColor = Color3.fromRGB(50, 45, 35),  -- Dark rocky
    },
    
    -- Cave walls (irregular)
    caveWalls = {
        -- Left side walls
        {size = Vector3.new(2, 30, 200), position = Vector3.new(-100, 15, 150), color = Color3.fromRGB(55, 50, 45)},
        {size = Vector3.new(2, 30, 200), position = Vector3.new(-95, 15, 150), color = Color3.fromRGB(50, 45, 40)},
        
        -- Right side walls
        {size = Vector3.new(2, 30, 200), position = Vector3.new(100, 15, 150), color = Color3.fromRGB(55, 50, 45)},
        {size = Vector3.new(2, 30, 200), position = Vector3.new(95, 15, 150), color = Color3.fromRGB(50, 45, 40)},
        
        -- Front wall (entrance area)
        {size = Vector3.new(200, 30, 2), position = Vector3.new(0, 15, 50), color = Color3.fromRGB(55, 50, 45)},
        
        -- Back wall (near boss)
        {size = Vector3.new(200, 30, 2), position = Vector3.new(0, 15, 250), color = Color3.fromRGB(55, 50, 45)},
    },
    
    -- Large pillars/rock formations
    pillars = {
        {position = Vector3.new(-60, 10, 80), size = Vector3.new(15, 20, 15)},
        {position = Vector3.new(60, 10, 80), size = Vector3.new(15, 20, 15)},
        {position = Vector3.new(-70, 10, 130), size = Vector3.new(12, 20, 12)},
        {position = Vector3.new(70, 10, 130), size = Vector3.new(12, 20, 12)},
        {position = Vector3.new(0, 10, 100), size = Vector3.new(15, 20, 15)},
        {position = Vector3.new(-50, 10, 150), size = Vector3.new(10, 20, 10)},
        {position = Vector3.new(50, 10, 150), size = Vector3.new(10, 20, 10)},
        {position = Vector3.new(-70, 10, 180), size = Vector3.new(12, 20, 12)},
        {position = Vector3.new(70, 10, 180), size = Vector3.new(12, 20, 12)},
        {position = Vector3.new(0, 10, 200), size = Vector3.new(15, 20, 15)},
    },
    
    -- Monster spawn points (20 locations)
    monsterSpawnPoints = {
        -- Chamber 1 (left side)
        {position = Vector3.new(-70, 2, 70), name = "MonsterSpawnPoint1"},
        {position = Vector3.new(-50, 2, 75), name = "MonsterSpawnPoint2"},
        {position = Vector3.new(-75, 2, 90), name = "MonsterSpawnPoint3"},
        {position = Vector3.new(-55, 2, 100), name = "MonsterSpawnPoint4"},
        
        -- Chamber 2 (right side)
        {position = Vector3.new(70, 2, 70), name = "MonsterSpawnPoint5"},
        {position = Vector3.new(50, 2, 75), name = "MonsterSpawnPoint6"},
        {position = Vector3.new(75, 2, 90), name = "MonsterSpawnPoint7"},
        {position = Vector3.new(55, 2, 100), name = "MonsterSpawnPoint8"},
        
        -- Chamber 3 (center front)
        {position = Vector3.new(-30, 2, 80), name = "MonsterSpawnPoint9"},
        {position = Vector3.new(0, 2, 75), name = "MonsterSpawnPoint10"},
        {position = Vector3.new(30, 2, 80), name = "MonsterSpawnPoint11"},
        
        -- Chamber 4 (center middle)
        {position = Vector3.new(-50, 2, 140), name = "MonsterSpawnPoint12"},
        {position = Vector3.new(0, 2, 145), name = "MonsterSpawnPoint13"},
        {position = Vector3.new(50, 2, 140), name = "MonsterSpawnPoint14"},
        
        -- Chamber 5 (left back)
        {position = Vector3.new(-75, 2, 170), name = "MonsterSpawnPoint15"},
        {position = Vector3.new(-60, 2, 190), name = "MonsterSpawnPoint16"},
        
        -- Chamber 6 (right back)
        {position = Vector3.new(75, 2, 170), name = "MonsterSpawnPoint17"},
        {position = Vector3.new(60, 2, 190), name = "MonsterSpawnPoint18"},
        
        -- Chamber 7 (near boss)
        {position = Vector3.new(-30, 2, 220), name = "MonsterSpawnPoint19"},
        {position = Vector3.new(30, 2, 220), name = "MonsterSpawnPoint20"},
    },
    
    -- Torch positions (authentic cave lighting)
    torches = {
        -- Cave torches
        {position = Vector3.new(-80, 10, 70)},
        {position = Vector3.new(80, 10, 70)},
        {position = Vector3.new(-80, 10, 120)},
        {position = Vector3.new(0, 10, 120)},
        {position = Vector3.new(80, 10, 120)},
        {position = Vector3.new(-80, 10, 170)},
        {position = Vector3.new(0, 10, 170)},
        {position = Vector3.new(80, 10, 170)},
        {position = Vector3.new(-40, 10, 220)},
        {position = Vector3.new(40, 10, 220)},
    },
    
    -- Boss area
    bossArea = {
        doorSize = Vector3.new(15, 15, 2),
        doorPosition = Vector3.new(0, 7.5, 245),
        doorColor = Color3.fromRGB(180, 0, 0),
        platformSize = Vector3.new(60, 2, 40),
        platformPosition = Vector3.new(0, 0, 270),
        platformColor = Color3.fromRGB(80, 30, 30),
    },
    
    -- Player spawn
    playerSpawn = {
        position = Vector3.new(0, 2, -20),
    },
}

-- ===== HELPER FUNCTION: Create Part =====
local function createPart(name, size, position, color, canCollide, transparency, material)
    local part = Instance.new("Part")
    part.Name = name
    part.Shape = Enum.PartType.Block
    part.Size = size
    part.Position = position
    part.Color = color
    part.CanCollide = canCollide ~= false
    part.Transparency = transparency or 0
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Anchored = true
    part.Material = material or Enum.Material.Brick
    part.Parent = Workspace
    
    return part
end

-- ===== CREATE GREEN LOBBY =====
local function createLobby()
    print("[DungeonLayout] Creating Green Lobby...")
    
    local lobby = Instance.new("Folder")
    lobby.Name = "Lobby"
    lobby.Parent = Workspace
    
    -- Green hill floor
    local lobbyFloor = createPart(
        "LobbyFloor",
        DUNGEON_CONFIG.lobby.floorSize,
        DUNGEON_CONFIG.lobby.floorPosition,
        DUNGEON_CONFIG.lobby.floorColor,
        true,
        0,
        Enum.Material.Grass
    )
    lobbyFloor.Parent = lobby
    
    -- Green hill walls
    for i, wallConfig in ipairs(DUNGEON_CONFIG.lobby.hillWalls) do
        local wall = createPart(
            "HillWall" .. i,
            wallConfig.size,
            wallConfig.position,
            wallConfig.color,
            true,
            0,
            Enum.Material.Grass
        )
        wall.Parent = lobby
    end
    
    -- Decorative trees (trunks)
    for i, treeConfig in ipairs(DUNGEON_CONFIG.lobby.trees) do
        local trunk = createPart(
            "Tree" .. i .. "_Trunk",
            treeConfig.size,
            treeConfig.position,
            treeConfig.color,
            true,
            0,
            Enum.Material.Wood
        )
        trunk.Parent = lobby
        
        -- Tree foliage (sphere-like)
        local foliage = createPart(
            "Tree" .. i .. "_Foliage",
            Vector3.new(8, 8, 8),
            treeConfig.position + Vector3.new(0, 8, 0),
            Color3.fromRGB(34, 139, 34),
            false,
            0,
            Enum.Material.Grass
        )
        foliage.Parent = lobby
    end
    
    -- Teleport pad (GLOWING CENTER)
    local teleportPad = createPart(
        "TeleportPad",
        DUNGEON_CONFIG.lobby.teleportPad.size,
        DUNGEON_CONFIG.lobby.teleportPad.position,
        DUNGEON_CONFIG.lobby.teleportPad.color,
        false,
        0.2,
        Enum.Material.Neon
    )
    teleportPad.Parent = lobby
    teleportPad.CanQuery = false
    
    -- Add PointLight to teleport pad
    local padLight = Instance.new("PointLight")
    padLight.Brightness = 3
    padLight.Range = 30
    padLight.Color = Color3.fromRGB(0, 255, 255)
    padLight.Parent = teleportPad
    
    -- Teleport pad touch detection
    local touchConnection
    touchConnection = teleportPad.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = Players:GetPlayerFromCharacter(character)
        
        if player and character:FindFirstChildOfClass("Humanoid") then
            -- Teleport player to dungeon
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(DUNGEON_CONFIG.lobby.teleportPad.destinationDungeon + Vector3.new(0, 3, 0))
                print("[DungeonLayout] " .. player.Name .. " teleported to Dungeon!")
            end
        end
    end)
    
    -- Player spawn location
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Name = "PlayerSpawnLocation"
    spawnLocation.Size = Vector3.new(10, 1, 10)
    spawnLocation.Position = DUNGEON_CONFIG.playerSpawn.position
    spawnLocation.Color = Color3.fromRGB(0, 255, 0)
    spawnLocation.CanCollide = true
    spawnLocation.TopSurface = Enum.SurfaceType.Smooth
    spawnLocation.BottomSurface = Enum.SurfaceType.Smooth
    spawnLocation.Anchored = true
    spawnLocation.Duration = 0
    spawnLocation.Parent = lobby
    
    print("[DungeonLayout] ✓ Green Lobby created with Teleport Pad!")
    return lobby
end

-- ===== CREATE DUNGEON (CAVE) =====
local function createDungeon()
    print("[DungeonLayout] Creating Cave Dungeon...")
    
    local dungeon = Instance.new("Folder")
    dungeon.Name = "Dungeon"
    dungeon.Parent = Workspace
    
    -- Cave floor
    local dungeonFloor = createPart(
        "CaveFloor",
        DUNGEON_CONFIG.dungeon.floorSize,
        DUNGEON_CONFIG.dungeon.floorPosition,
        DUNGEON_CONFIG.dungeon.floorColor,
        true,
        0,
        Enum.Material.Brick
    )
    dungeonFloor.Parent = dungeon
    
    -- Cave ceiling
    local ceilingFloor = createPart(
        "CaveCeiling",
        DUNGEON_CONFIG.dungeon.ceilingSize,
        DUNGEON_CONFIG.dungeon.ceilingPosition,
        DUNGEON_CONFIG.dungeon.ceilingColor,
        true,
        0,
        Enum.Material.Brick
    )
    ceilingFloor.Parent = dungeon
    
    -- Create cave walls
    for i, wallConfig in ipairs(DUNGEON_CONFIG.caveWalls) do
        local wall = createPart(
            "CaveWall" .. i,
            wallConfig.size,
            wallConfig.position,
            wallConfig.color,
            true,
            0,
            Enum.Material.Brick
        )
        wall.Parent = dungeon
    end
    
    -- Create large pillars/rock formations
    for i, pillarConfig in ipairs(DUNGEON_CONFIG.pillars) do
        local pillar = createPart(
            "RockFormation" .. i,
            pillarConfig.size,
            pillarConfig.position,
            Color3.fromRGB(70, 60, 50),
            true,
            0,
            Enum.Material.Brick
        )
        pillar.Parent = dungeon
    end
    
    print("[DungeonLayout] ✓ Cave dungeon created!")
    return dungeon
end

-- ===== CREATE MONSTER SPAWN POINTS =====
local function createMonsterSpawnPoints()
    print("[DungeonLayout] Creating 20 Monster Spawn Points...")
    
    local spawnPointsFolder = Instance.new("Folder")
    spawnPointsFolder.Name = "MonsterSpawnPoints"
    spawnPointsFolder.Parent = Workspace.Dungeon
    
    for i, spawnConfig in ipairs(DUNGEON_CONFIG.monsterSpawnPoints) do
        local spawnPoint = createPart(
            spawnConfig.name,
            Vector3.new(6, 0.3, 6),
            spawnConfig.position,
            Color3.fromRGB(100, 180, 255),
            false,
            0.5,
            Enum.Material.Neon
        )
        spawnPoint.Parent = spawnPointsFolder
        spawnPoint.CanQuery = false
    end
    
    print("[DungeonLayout] ✓ Created " .. #DUNGEON_CONFIG.monsterSpawnPoints .. " monster spawn points!")
end

-- ===== CREATE TORCHES =====
local function createTorches()
    print("[DungeonLayout] Creating Torches...")
    
    local torchesFolder = Instance.new("Folder")
    torchesFolder.Name = "Torches"
    torchesFolder.Parent = Workspace
    
    for i, torchConfig in ipairs(DUNGEON_CONFIG.torches) do
        -- Torch pole (dark wood)
        local torch = createPart(
            "Torch" .. i .. "_Pole",
            Vector3.new(1, 8, 1),
            Vector3.new(torchConfig.position.X, 4, torchConfig.position.Z),
            Color3.fromRGB(40, 30, 20),
            true,
            0,
            Enum.Material.Wood
        )
        torch.Parent = torchesFolder
        
        -- Torch flame (bright orange)
        local flame = createPart(
            "Torch" .. i .. "_Flame",
            Vector3.new(2, 3, 2),
            Vector3.new(torchConfig.position.X, torchConfig.position.Y, torchConfig.position.Z),
            Color3.fromRGB(255, 150, 0),
            false,
            0.2,
            Enum.Material.Neon
        )
        flame.Parent = torchesFolder
        flame.CanQuery = false
        
        -- Light source dari torch
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 2
        pointLight.Range = 40
        pointLight.Color = Color3.fromRGB(255, 150, 0)
        pointLight.Parent = flame
    end
    
    print("[DungeonLayout] ✓ Created " .. #DUNGEON_CONFIG.torches .. " torches with lighting!")
end

-- ===== CREATE BOSS AREA =====
local function createBossArea()
    print("[DungeonLayout] Creating Boss Area...")
    
    local bossFolder = Instance.new("Folder")
    bossFolder.Name = "BossArea"
    bossFolder.Parent = Workspace.Dungeon
    
    -- Boss door
    local bossDoor = createPart(
        "BossDoor",
        DUNGEON_CONFIG.bossArea.doorSize,
        DUNGEON_CONFIG.bossArea.doorPosition,
        DUNGEON_CONFIG.bossArea.doorColor,
        true,
        0,
        Enum.Material.Neon
    )
    bossDoor.Parent = bossFolder
    
    -- Boss platform
    local bossPlatform = createPart(
        "BossPlatform",
        DUNGEON_CONFIG.bossArea.platformSize,
        DUNGEON_CONFIG.bossArea.platformPosition,
        DUNGEON_CONFIG.bossArea.platformColor,
        true,
        0,
        Enum.Material.Brick
    )
    bossPlatform.Parent = bossFolder
    
    -- Boss spawn point
    local bossSpawn = createPart(
        "BossSpawnPoint",
        Vector3.new(10, 0.5, 10),
        Vector3.new(0, 2, 270),
        Color3.fromRGB(255, 0, 0),
        false,
        0.3,
        Enum.Material.Neon
    )
    bossSpawn.Parent = bossFolder
    bossSpawn.CanQuery = false
    
    print("[DungeonLayout] ✓ Boss area created!")
end

-- ===== CREATE LIGHTING =====
local function createLighting()
    print("[DungeonLayout] Setting up dynamic lighting...")
    
    local lighting = game:GetService("Lighting")
    
    -- Bright outdoor lighting for lobby
    lighting.Ambient = Color3.fromRGB(200, 200, 200)
    lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    lighting.Brightness = 1.5
    
    -- Sky color
    lighting.FogColor = Color3.fromRGB(135, 206, 235)  -- Sky blue
    lighting.FogEnd = 2000
    
    -- Remove default sun
    for _, light in pairs(lighting:GetChildren()) do
        if light:IsA("Light") then
            light:Destroy()
        end
    end
    
    print("[DungeonLayout] ✓ Outdoor lighting configured!")
end

-- ===== MAIN EXECUTION =====
local function main()
    print("\n" .. string.rep("=", 60))
    print("[DungeonLayout V3] Starting dungeon with GREEN LOBBY...")
    print(string.rep("=", 60) .. "\n")
    
    createLobby()
    createDungeon()
    createMonsterSpawnPoints()
    createTorches()
    createBossArea()
    createLighting()
    
    print("\n" .. string.rep("=", 60))
    print("[DungeonLayout V3] ✓ COMPLETE! GREEN LOBBY READY!")
    print(string.rep("=", 60) .. "\n")
    
    print("📊 DUNGEON OVERVIEW:")
    print("  🏜️ Lobby: 100x100 studs (GREEN HILL with trees)")
    print("  🚸 Teleport Pad: Cyan glow in center (TOUCH TO ENTER)")
    print("  🏔️ Cave Dungeon: 200x200 studs (dark & atmospheric)")
    print("  👹 Monster Spawn Points: 20 (distributed)")
    print("  🔥 Torches: 10 (cave lighting)")
    print("  🚪 Boss Area: Red glowing door")
    print("  " .. string.char(226, 156, 132) .. " All parts ANCHORED (stable)")
    print("\n")
end

main()
