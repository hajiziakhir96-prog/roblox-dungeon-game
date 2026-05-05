-- DungeonLayout Script
-- Letak: ServerScriptService
-- Berfungsi: Auto-generate dungeon layout (floor, walls, spawn points, boss door)

local Workspace = game:GetService("Workspace")

-- ===== DUNGEON CONFIGURATION =====
local DUNGEON_CONFIG = {
    -- Lobby settings
    lobby = {
        floorSize = Vector3.new(50, 1, 50),
        floorPosition = Vector3.new(0, 0, 0),
        floorColor = Color3.fromRGB(200, 200, 200),
        entranceSize = Vector3.new(5, 5, 2),
        entrancePosition = Vector3.new(0, 2.5, 30),
        entranceColor = Color3.fromRGB(50, 50, 50),
    },
    
    -- Dungeon settings
    dungeon = {
        floorSize = Vector3.new(120, 1, 150),
        floorPosition = Vector3.new(0, 0, 105),
        floorColor = Color3.fromRGB(80, 80, 90),
        
        -- Walls
        walls = {
            -- Front wall
            {size = Vector3.new(120, 10, 2), position = Vector3.new(0, 5, 30), color = Color3.fromRGB(60, 60, 70)},
            -- Back wall
            {size = Vector3.new(120, 10, 2), position = Vector3.new(0, 5, 180), color = Color3.fromRGB(60, 60, 70)},
            -- Left wall
            {size = Vector3.new(2, 10, 150), position = Vector3.new(-60, 5, 105), color = Color3.fromRGB(60, 60, 70)},
            -- Right wall
            {size = Vector3.new(2, 10, 150), position = Vector3.new(60, 5, 105), color = Color3.fromRGB(60, 60, 70)},
        },
        
        -- Pillars (obstacles)
        pillars = {
            {position = Vector3.new(-30, 5, 70), size = Vector3.new(3, 10, 3)},
            {position = Vector3.new(30, 5, 70), size = Vector3.new(3, 10, 3)},
            {position = Vector3.new(-20, 5, 105), size = Vector3.new(3, 10, 3)},
            {position = Vector3.new(20, 5, 105), size = Vector3.new(3, 10, 3)},
            {position = Vector3.new(0, 5, 140), size = Vector3.new(3, 10, 3)},
        },
    },
    
    -- Monster spawn points
    monsterSpawnPoints = {
        {position = Vector3.new(-35, 2, 70), name = "MonsterSpawnPoint1"},
        {position = Vector3.new(35, 2, 70), name = "MonsterSpawnPoint2"},
        {position = Vector3.new(-40, 2, 105), name = "MonsterSpawnPoint3"},
        {position = Vector3.new(40, 2, 105), name = "MonsterSpawnPoint4"},
        {position = Vector3.new(0, 2, 150), name = "MonsterSpawnPoint5"},
    },
    
    -- Boss door
    bossDoor = {
        size = Vector3.new(8, 12, 2),
        position = Vector3.new(0, 6, 179),
        color = Color3.fromRGB(150, 0, 0),
    },
    
    -- Player spawn location
    playerSpawn = {
        position = Vector3.new(0, 1.5, -5),
    },
}

-- ===== HELPER FUNCTION: Create Part =====
local function createPart(name, size, position, color, canCollide, transparency)
    local part = Instance.new("Part")
    part.Name = name
    part.Shape = Enum.PartType.Block
    part.Size = size
    part.Position = position
    part.Color = color
    part.CanCollide = canCollide ~= false  -- Default: true
    part.Transparency = transparency or 0
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
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
        true
    )
    lobbyFloor.Parent = lobby
    
    -- Dungeon entrance
    local entrance = createPart(
        "DungeonEntrance",
        DUNGEON_CONFIG.lobby.entranceSize,
        DUNGEON_CONFIG.lobby.entrancePosition,
        DUNGEON_CONFIG.lobby.entranceColor,
        true
    )
    entrance.Parent = lobby
    
    -- Player spawn location
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Name = "PlayerSpawnLocation"
    spawnLocation.Size = Vector3.new(6, 1, 6)
    spawnLocation.Position = DUNGEON_CONFIG.playerSpawn.position
    spawnLocation.Color = Color3.fromRGB(0, 255, 0)
    spawnLocation.CanCollide = true
    spawnLocation.TopSurface = Enum.SurfaceType.Smooth
    spawnLocation.BottomSurface = Enum.SurfaceType.Smooth
    spawnLocation.Duration = 0
    spawnLocation.Parent = lobby
    
    print("[DungeonLayout] ✓ Lobby created!")
    return lobby
end

-- ===== CREATE DUNGEON =====
local function createDungeon()
    print("[DungeonLayout] Creating Dungeon...")
    
    local dungeon = Instance.new("Folder")
    dungeon.Name = "Dungeon"
    dungeon.Parent = Workspace
    
    -- Dungeon floor
    local dungeonFloor = createPart(
        "DungeonFloor",
        DUNGEON_CONFIG.dungeon.floorSize,
        DUNGEON_CONFIG.dungeon.floorPosition,
        DUNGEON_CONFIG.dungeon.floorColor,
        true
    )
    dungeonFloor.Parent = dungeon
    
    -- Create walls
    for i, wallConfig in ipairs(DUNGEON_CONFIG.dungeon.walls) do
        local wall = createPart(
            "DungeonWall" .. i,
            wallConfig.size,
            wallConfig.position,
            wallConfig.color,
            true
        )
        wall.Parent = dungeon
    end
    
    -- Create pillars (obstacles)
    for i, pillarConfig in ipairs(DUNGEON_CONFIG.dungeon.pillars) do
        local pillar = createPart(
            "Pillar" .. i,
            pillarConfig.size,
            pillarConfig.position,
            Color3.fromRGB(100, 100, 100),
            true
        )
        pillar.Parent = dungeon
    end
    
    -- Create boss door
    local bossDoor = createPart(
        "BossDoor",
        DUNGEON_CONFIG.bossDoor.size,
        DUNGEON_CONFIG.bossDoor.position,
        DUNGEON_CONFIG.bossDoor.color,
        true
    )
    bossDoor.Parent = dungeon
    
    -- Add BrickColor for visibility
    bossDoor.Material = Enum.Material.Neon
    
    print("[DungeonLayout] ✓ Dungeon created with " .. #DUNGEON_CONFIG.dungeon.walls .. " walls and " .. #DUNGEON_CONFIG.dungeon.pillars .. " pillars!")
    return dungeon
end

-- ===== CREATE MONSTER SPAWN POINTS =====
local function createMonsterSpawnPoints()
    print("[DungeonLayout] Creating Monster Spawn Points...")
    
    local spawnPointsFolder = Instance.new("Folder")
    spawnPointsFolder.Name = "MonsterSpawnPoints"
    spawnPointsFolder.Parent = Workspace.Dungeon
    
    for i, spawnConfig in ipairs(DUNGEON_CONFIG.monsterSpawnPoints) do
        local spawnPoint = createPart(
            spawnConfig.name,
            Vector3.new(8, 0.5, 8),
            spawnConfig.position,
            Color3.fromRGB(100, 200, 255),  -- Light blue
            false,  -- Can't collide
            0.3  -- Slight transparency
        )
        spawnPoint.Parent = spawnPointsFolder
        spawnPoint.CanQuery = false
    end
    
    print("[DungeonLayout] ✓ Created " .. #DUNGEON_CONFIG.monsterSpawnPoints .. " monster spawn points!")
end

-- ===== CREATE LIGHTING =====
local function createLighting()
    print("[DungeonLayout] Setting up lighting...")
    
    local lighting = game:GetService("Lighting")
    
    -- Ambient lighting (overall brightness)
    lighting.Ambient = Color3.fromRGB(200, 200, 200)
    lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    
    -- Create a light source
    local sunlight = Instance.new("Part")
    sunlight.Name = "Sunlight"
    sunlight.CanCollide = false
    sunlight.CanQuery = false
    sunlight.Transparency = 1
    sunlight.Position = Vector3.new(0, 50, 100)
    sunlight.Parent = Workspace
    
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 2
    pointLight.Range = 100
    pointLight.Color = Color3.fromRGB(255, 255, 200)
    pointLight.Parent = sunlight
    
    print("[DungeonLayout] ✓ Lighting configured!")
end

-- ===== MAIN EXECUTION =====
local function main()
    print("\n" .. string.rep("=", 50))
    print("[DungeonLayout] Starting dungeon generation...")
    print(string.rep("=", 50) .. "\n")
    
    -- Create all parts
    createLobby()
    createDungeon()
    createMonsterSpawnPoints()
    createLighting()
    
    print("\n" .. string.rep("=", 50))
    print("[DungeonLayout] ✓ DUNGEON LAYOUT COMPLETE!")
    print(string.rep("=", 50) .. "\n")
    
    print("Dungeon Overview:")
    print("  📍 Lobby: 50x50 studs (bright & safe)")
    print("  🏰 Dungeon: 120x150 studs (dark & dangerous)")
    print("  👹 Monster Spawn Points: " .. #DUNGEON_CONFIG.monsterSpawnPoints)
    print("  🚪 Boss Door: At dungeon end (RED DOOR)")
    print("  💡 Light: Ambient + Point light source")
    print("\n")
end

-- Run on script start
main()
