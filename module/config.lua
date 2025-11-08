-- ====================================================================
--                 CONFIGURATION MODULE (OPTIMIZED + SAFE)
-- ====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Config = {}

-- Constants
Config.FOLDER = "OptimizedAutoFish"
Config.FILE = string.format("%s/config_%d.json", Config.FOLDER, LocalPlayer.UserId)

-- Default settings
Config.Defaults = {
    AutoFish = false,
    AutoSell = false,
    AutoCatch = false,
    GPUSaver = false,
    BlatantMode = false,
    FishDelay = 0.9,
    CatchDelay = 0.2,
    SellDelay = 30,
    TeleportLocation = "Sisyphus Statue",
    AutoFavorite = false,
    FavoriteRarity = "Mythic"
}

-- Copy defaults to current
Config.Current = table.clone and table.clone(Config.Defaults) or {}
if not next(Config.Current) then
    for k, v in pairs(Config.Defaults) do
        Config.Current[k] = v
    end
end

-- Check if exploit functions exist
local function safeFunc(fn)
    return typeof(fn) == "function"
end

-- Ensure folder exists safely
function Config.ensureFolder()
    if not safeFunc(isfolder) or not safeFunc(makefolder) then
        warn("[Config] File system functions not supported in this executor.")
        return false
    end
    if not isfolder(Config.FOLDER) then
        pcall(makefolder, Config.FOLDER)
    end
    return isfolder(Config.FOLDER)
end

-- Save configuration
function Config.save()
    if not safeFunc(writefile) or not Config.ensureFolder() then
        warn("[Config] Save failed (missing file functions).")
        return false
    end
    local ok, err = pcall(function()
        local encoded = HttpService:JSONEncode(Config.Current)
        writefile(Config.FILE, encoded)
        print("[Config] Settings saved ✓")
    end)
    if not ok then warn("[Config] Save error:", err) end
    return ok
end

-- Load configuration
function Config.load()
    if not safeFunc(readfile) or not safeFunc(isfile) or not isfile(Config.FILE) then
        return false
    end
    local ok, result = pcall(function()
        local decoded = HttpService:JSONDecode(readfile(Config.FILE))
        for k, v in pairs(decoded) do
            if Config.Defaults[k] ~= nil then
                Config.Current[k] = v
            end
        end
        print("[Config] Settings loaded ✓")
    end)
    if not ok then warn("[Config] Load error:", result) end
    return ok
end

-- Get setting
function Config.get(key)
    return Config.Current[key]
end

-- Set setting
function Config.set(key, value)
    if Config.Defaults[key] == nil then
        warn("[Config] Unknown setting:", key)
        return false
    end
    Config.Current[key] = value
    Config.save()
    return true
end

return Configfunction Config.ensureFolder()
    if not isfolder or not makefolder then return false end
    if not isfolder(Config.FOLDER) then
        pcall(function() makefolder(Config.FOLDER) end)
    end
    return isfolder(Config.FOLDER)
end

-- Save configuration
function Config.save()
    if not writefile or not Config.ensureFolder() then return false end
    local success = pcall(function()
        writefile(Config.FILE, HttpService:JSONEncode(Config.Current))
        print("[Config] Settings saved!")
    end)
    return success
end

-- Load configuration
function Config.load()
    if not readfile or not isfile or not isfile(Config.FILE) then return false end
    local success = pcall(function()
        local data = HttpService:JSONDecode(readfile(Config.FILE))
        for k, v in pairs(data) do
            if Config.Defaults[k] ~= nil then 
                Config.Current[k] = v 
            end
        end
        print("[Config] Settings loaded!")
    end)
    return success
end

-- Get setting
function Config.get(key)
    return Config.Current[key]
end

-- Set setting
function Config.set(key, value)
    if Config.Defaults[key] == nil then return false end
    Config.Current[key] = value
    Config.save()
    return true
end

return Config
