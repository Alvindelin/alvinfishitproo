-- ====================================================================
--                 FISHING MODULE (SUPER BLATANT)
-- ====================================================================

local Fishing = {}
Fishing.isActive = false
Fishing.isFishing = false
Fishing.useBlatantMode = true -- default true biar langsung mode brutal

local Network = require(script.Parent.network)

-- super fast cast
local function castRod()
    pcall(function()
        local Events = Network.Events
        for i = 1, 3 do
            task.spawn(function()
                Events.equip:FireServer(1)
                task.wait()
                Events.charge:InvokeServer(1755848498.4834)
                Events.minigame:InvokeServer(1.2854545116425, 1)
            end)
        end
        print("[Fishing] Cast (super fast)")
    end)
end

-- super fast reel
local function reelIn()
    pcall(function()
        local Events = Network.Events
        for i = 1, 8 do
            task.spawn(function()
                Events.fishing:FireServer()
            end)
        end
        print("[Fishing] Reel (spam)")
    end)
end

-- extreme blatant loop
local function blatantLoop(config)
    while Fishing.isActive do
        if not Fishing.isFishing then
            Fishing.isFishing = true

            castRod()
            task.wait(config.FishDelay or 0.05)
            reelIn()
            task.wait(config.CatchDelay or 0.05)

            Fishing.isFishing = false
        else
            task.wait()
        end
    end
end

function Fishing.start(config, blatantMode)
    if Fishing.isActive then return end

    Fishing.isActive = true
    Fishing.useBlatantMode = blatantMode or true

    print("[Fishing] Started (Super Blatant Mode)")

    task.spawn(function()
        blatantLoop(config or {FishDelay = 0.05, CatchDelay = 0.05})
    end)
end

function Fishing.stop()
    Fishing.isActive = false
    Fishing.isFishing = false
    pcall(function()
        Network.Events.unequip:FireServer()
    end)
    print("[Fishing] Stopped")
end

return Fishing
