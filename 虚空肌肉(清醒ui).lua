local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/hun/main/jmlibrary1.lua"))()     
local win = ui:new("虚空肌肉")

local UITab1 = win:Tab("『通用』", '87437251671184')
local about = UITab1:section("『通用』", true)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local reviveEnabled = false
local deathPosition = nil

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if reviveEnabled then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                deathPosition = root.Position
            end
        end
    end)
end

player.CharacterAdded:Connect(function(character)
    if reviveEnabled and deathPosition then
        task.wait(0.1)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        humanoidRootPart.CFrame = CFrame.new(deathPosition)
    end
    onCharacterAdded(character)
end)

if player.Character then
    onCharacterAdded(player.Character)
end

local function startRevive()
    reviveEnabled = true
end

local function stopRevive()
    reviveEnabled = false
end

local exerciseRunning = false
local exerciseThread = nil

local function startExercise()
    if exerciseThread then return end
    exerciseRunning = true
    exerciseThread = task.spawn(function()
        while exerciseRunning do
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local weight = player.Character and player.Character:WaitForChild("Weight", 1)
                if weight then
                    local args = { "rep", weight }
                    player:WaitForChild("muscleEvent"):FireServer(unpack(args))
                end
            end)
            task.wait(0.00001)
        end
        exerciseThread = nil
    end)
end

local function stopExercise()
    exerciseRunning = false
end

local rebirthRunning = false
local rebirthThread = nil

local function startRebirth()
    if rebirthThread then return end
    rebirthRunning = true
    rebirthThread = task.spawn(function()
        while rebirthRunning do
            pcall(function()
                local args = { "rebirthRequest", 9999999999999 }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthRemote"):InvokeServer(unpack(args))
            end)
            task.wait(0.00001)
        end
        rebirthThread = nil
    end)
end

local function stopRebirth()
    rebirthRunning = false
end

local crystalLoopValue = false
local crystalLoopThread = nil

local function startCrystalLoop()
    if crystalLoopThread then return end
    crystalLoopValue = true
    crystalLoopThread = task.spawn(function()
        local Remote = game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote")
        while crystalLoopValue do
            task.wait(0.0000001)
            for i = 0.1, 990000000 do
                if not crystalLoopValue then break end
                pcall(function()
                    Remote:InvokeServer("openCrystal", "Eltrax Crystal")
                end)
            end
        end
        crystalLoopThread = nil
    end)
end

local function stopCrystalLoop()
    crystalLoopValue = false
end

local evolveRunning = false
local evolveThread = nil

local function startEvolve()
    if evolveThread then return end
    evolveRunning = true
    evolveThread = task.spawn(function()
        while evolveRunning do
            pcall(function()
                local args = { "evolveAll" }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("petEvolveEvent"):FireServer(unpack(args))
            end)
            task.wait(0.001)
        end
        evolveThread = nil
    end)
end

local function stopEvolve()
    evolveRunning = false
end

about:Toggle("自动锻炼", "只支持哑铃", false, function(Value)
    if Value then
        startExercise()
    else
        stopExercise()
    end
end)

about:Toggle("自动重生", "", false, function(Value)
    if Value then
        startRebirth()
    else
        stopRebirth()
    end
end)

about:Toggle("快速抽蛋", "只支持50k绿宝石的宠物水晶", false, function(Value)
    if Value then
        startCrystalLoop()
    else
        stopCrystalLoop()
    end
end)

about:Toggle("自动进化", "", false, function(Value)
    if Value then
        startEvolve()
    else
        stopEvolve()
    end
end)

about:Toggle("原地复活", "", false, function(Value)
    if Value then
        startRevive()
    else
        stopRevive()
    end
end)

about:Toggle("删除显示", "点击开启执行一次", false, function(Value)
    if Value then
        pcall(function()
            local character = player.Character
            if not character then return end
            for _, item in ipairs(character:GetDescendants()) do
                if item:IsA("ParticleEmitter") or item:IsA("Trail") or item:IsA("Beam") then
                    item:Destroy()
                end
            end
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            for _, name in ipairs({ "strengthFrame", "durabilityFrame", "agilityFrame" }) do
                local frame = ReplicatedStorage:FindFirstChild(name)
                if frame then
                    frame:Destroy()
                end
            end
        end)
    end
end)

about:Toggle("删除没用的东西", "点击开启执行一次", false, function(Value)
    if Value then
        pcall(function()
            local character = player.Character
            if not character then return end
            for _, item in ipairs(character:GetChildren()) do
                if item.Name == "sweatPart" or item.Name == "airPart" then
                    item:Destroy()
                end
            end
        end)
    end
end)