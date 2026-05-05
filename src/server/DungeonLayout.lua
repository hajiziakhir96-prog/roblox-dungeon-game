-- DungeonLayout V2 Script (IMPROVED)
-- Letak: ServerScriptService
-- Berfungsi: Create detailed cave dungeon dengan 20+ monster spawn points dan torch lighting

local Workspace = game:GetService("Workspace")

-- ===== DUNGEON CONFIGURATION V2 =====
local DUNGEON_CONFIG = {
    -- Lobby settings
    lobby = {
        floorSize = Vector3.new(60, 1, 60),
        floorPosition = Vector3.new(0, 0, 0),
        floorColor = Color3.fromRGB(150, 150, 150),
        entranceSize = Vector3.new(10, 8, 2),
        entrancePosition = Vector3.new(0, 4, 35),
        entranceColor = Color3.fromRGB(40, 40, 40),
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
        
        -- Front wall
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
        position = Vector3.new(0, 1.5, -10),
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
    part.Anchored = true  -- IMPORTANT: Prevent falling
    part.Material = material or Enum.Material.Brick
    part.Parent = Workspace
    
    return part
end

-- ===== CREATE LOBBY =====
local function createLobby()
    print("[DungeonLayout] Creating Lobby...")
    
    local lobby = Instance.new("Folder")
    lobby.Name = "Lobby"
    lobby.Parent = Workspace
    
    -- Lobby floor
    local lobbyFloor = createPart(
        "LobbyFloor",
        DUNGEON_CONFIG.lobby.floorSize,
        DUNGEON_CONFIG.lobby.floorPosition,
        DUNGEON_CONFIG.lobby.floorColor,
        true,
        0,
        Enum.Material.Brick
    )
    lobbyFloor.Parent = lobby
    
    -- Lobby walls (simple)
    local lobbyWalls = {
        {size = Vector3.new(60, 15, 2), position = Vector3.new(0, 7.5, -30), color = Color3.fromRGB(100, 100, 100)},
        {size = Vector3.new(60, 15, 2), position = Vector3.new(0, 7.5, 30), color = Color3.fromRGB(100, 100, 100)},
        {size = Vector3.new(2, 15, 60), position = Vector3.new(-30, 7.5, 0), color = Color3.fromRGB(100, 100, 100)},
        {size = Vector3.new(2, 15, 60), position = Vector3.new(30, 7.5, 0), color = Color3.fromRGB(100, 100, 100)},
    }
    
    for i, wallConfig in ipairs(lobbyWalls) do
        local wall = createPart(
            "LobbyWall" .. i,
            wallConfig.size,
            wallConfig.position,
            wallConfig.color,
            true
        )
        wall.Parent = lobby
    end
    
    -- Dungeon entrance
    local entrance = createPart(
        "DungeonEntrance",
        DUNGEON_CONFIG.lobby.entranceSize,
        DUNGEON_CONFIG.lobby.entrancePosition,
        DUNGEON_CONFIG.lobby.entranceColor,
        true,
        0,
        Enum.Material.SmoothPlastic
    )
    entrance.Parent = lobby
    
    -- Player spawn location
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Name = "PlayerSpawnLocation"
    spawnLocation.Size = Vector3.new(8, 1, 8)
    spawnLocation.Position = DUNGEON_CONFIG.playerSpawn.position
    spawnLocation.Color = Color3.fromRGB(0, 200, 0)
    spawnLocation.CanCollide = true
    spawnLocation.TopSurface = Enum.SurfaceType.Smooth
    spawnLocation.BottomSurface = Enum.SurfaceType.Smooth
    spawnLocation.Anchored = true
    spawnLocation.Duration = 0
    spawnLocation.Parent = lobby
    
    print("[DungeonLayout] ✓ Lobby created!")
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
            Color3.fromRGB(100, 180, 255),  -- Light blue
            false,
            0.5,  -- Transparency
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
    torchesFolder.Parent = Workspace.Dungeon
    
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
            Color3.fromRGB(255, 150, 0),  -- Orange
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
    print("[DungeonLayout] Setting up cave lighting...")
    
    local lighting = game:GetService("Lighting")
    
    -- Dark ambient (cave atmosphere)
    lighting.Ambient = Color3.fromRGB(100, 90, 80)
    lighting.OutdoorAmbient = Color3.fromRGB(100, 90, 80)
    lighting.Brightness = 0.5  -- Dark cave
    
    -- Fog untuk cave effect
    lighting.FogColor = Color3.fromRGB(60, 50, 40)
    lighting.FogStart = 0
    lighting.FogEnd = 500
    
    -- Remove default sun (cave has no sun)
    for _, light in pairs(lighting:GetChildren()) do
        if light:IsA("Light") then
            light:Destroy()
        end
    end
    
    print("[DungeonLayout] ✓ Cave lighting configured!")
end

-- ===== MAIN EXECUTION =====
local function main()
    print("\n" .. string.rep("=", 60))
    print("[DungeonLayout V2] Starting advanced dungeon generation...")
    print(string.rep("=", 60) .. "\n")
    
    -- Create all parts
    createLobby()
    createDungeon()
    createMonsterSpawnPoints()
    createTorches()
    createBossArea()
    createLighting()
    
    print("\n" .. string.rep("=", 60))
    print("[DungeonLayout V2] ✓✓✓ DUNGEON FULLY CREATED! ✓✓✓")
    print(string.rep("=", 60) .. "\n")
    
    print("📊 DUNGEON OVERVIEW:")
    print("  🏠 Lobby: 60x60 studs (bright & safe)")
    print("  🏔️ Cave Dungeon: 200x200 studs (dark & atmospheric)")
    print("  🧟 Monster Spawn Points: 20 (distributed across chambers)")
    print("  🔥 Torches: 10 (with realistic flame lighting)")
    print("  👹 Boss Area: Separate chamber (red glowing door)")
    print("  🌫️ Atmosphere: Dark fog, torch lighting, cave acoustics")
    print("  ✓ All parts ANCHORED (no falling)")
    print("\n")
end

-- Run on script start
main()
