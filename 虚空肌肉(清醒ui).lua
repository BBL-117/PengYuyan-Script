local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/hun/main/jmlibrary1.lua"))()     
local win = ui:new("虚空肌肉")

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

local function startRevive() reviveEnabled = true end
local function stopRevive() reviveEnabled = false end

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
            task.wait(0.0000001)
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
                local args = { "rebirthRequest", 5000000000000000 }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthRemote"):InvokeServer(unpack(args))
            end)
            task.wait(0.000001)
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
            for i = 0.01, 9999999999 do
                if not crystalLoopValue then break end
                pcall(function()
                    Remote:InvokeServer("openCrystal", "Hydra Crystal")
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

local teleportRunning = false
local teleportThread = nil
local teleportTarget = CFrame.new(5212.50, 312.70, 10240.90)

local function startTeleport()
    if teleportThread then return end
    teleportRunning = true
    teleportThread = task.spawn(function()
        while teleportRunning do
            pcall(function()
                local char = player.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = teleportTarget
                    end
                end
            end)
            task.wait(0.1)
        end
        teleportThread = nil
    end)
end

local function stopTeleport()
    teleportRunning = false
end

local killRunning = false
local killThread = nil

local function startKill()
    if killThread then return end
    killRunning = true
    killThread = task.spawn(function()
        local LocalPlayer = player
        while killRunning do
            local character = LocalPlayer.Character
            local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
            local muscleEvent = LocalPlayer:FindFirstChild("muscleEvent")

            if not (character and root and muscleEvent) then
                task.wait(1.2)
                continue
            end

            local targets = Players:GetPlayers()
            for _, targetPlayer in ipairs(targets) do
                if not killRunning then break end
                if targetPlayer == LocalPlayer then continue end

                local targetChar = targetPlayer.Character
                if not targetChar then continue end
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
                if not targetRoot then continue end

                root.CFrame = targetRoot.CFrame + Vector3.new(0, 2.5, 0)
                task.wait()
                if not killRunning then break end
                muscleEvent:FireServer("punch", "rightHand")
                task.wait(1.2)
            end

            task.wait(1.2)
        end
        killThread = nil
    end)
end

local function stopKill()
    killRunning = false
end

local tabExercise = win:Tab("『锻炼功能』", '87437251671184')
local exerciseSection = tabExercise:section("『牛逼』", true)

exerciseSection:Toggle("自动锻炼", "只支持哑铃", false, function(Value)
    if Value then startExercise() else stopExercise() end
end)

exerciseSection:Toggle("自动重生", "", false, function(Value)
    if Value then startRebirth() else stopRebirth() end
end)

exerciseSection:Toggle("原地复活", "", false, function(Value)
    if Value then startRevive() else stopRevive() end
end)

exerciseSection:Toggle("删除显示", "点击开启执行一次", false, function(Value)
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
                if frame then frame:Destroy() end
            end
        end)
    end
end)

exerciseSection:Toggle("删除没用的东西", "点击开启执行一次", false, function(Value)
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

local tabPet = win:Tab("『抽蛋功能』", '87437251671185')
local petSection = tabPet:section("『牛逼』", true)

petSection:Toggle("快速抽蛋", "只支持1.2k绿宝石的宠物水晶", false, function(Value)
    if Value then startCrystalLoop() else stopCrystalLoop() end
end)

petSection:Toggle("自动进化", "", false, function(Value)
    if Value then startEvolve() else stopEvolve() end
end)

petSection:Toggle("传送宠物蛋", "持续传送至 (5212.50, 312.70, 10240.90)", false, function(Value)
    if Value then startTeleport() else stopTeleport() end
end)

local tabKill = win:Tab("『杀戮功能』", '87437251671186')
local killSection = tabKill:section("『牛逼』", true)

killSection:Toggle("传送攻击", "传送至目标上方并出拳", false, function(Value)
    if Value then
        startKill()
    else
        stopKill()
    end
end)
