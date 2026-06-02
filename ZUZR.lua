local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yisan886/Aero/refs/heads/main/ui.lua.txt"))()

WindUI:AddTheme({
    Name = "My Theme",
    Accent = Color3.fromHex("#18181b"),
    Background = Color3.fromHex("#101010"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
})

local Window = WindUI:CreateWindow({
    Title = "国内最强被诅咒之刃      ",
    Folder = "国内最强被诅咒之刃",
    SideBarWidth = 180,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/GHn9L9UJLf0XcVNyCpbG72D0rmNmBEWndPkh6CjJNya8GLnWzz1vImvt8wlJSBwv_2700x1519x1393696.jpeg",
    BackgroundImageTransparency = 0.5,
    OpenButton = {
        Title = "打开脚本",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.9,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#e7ff2f")
        ),
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
})

Window:Tag({
    Title = "V91.78",
    Color = Color3.fromHex("00CED1"),
    Radius = 2,
})

Window:Tag({
    Title = "老肯",
    Icon = "crown",
    Color = Color3.fromHex("FFD700"),
    Radius = 2,
})

local Lighting = game:GetService("Lighting")
local TweenServiceBlur = game:GetService("TweenService")

local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
end

task.spawn(function()
    local wasOpen = false
    while true do
        task.wait(0.1)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        local isOpen = mainFrame and mainFrame.Visible or false
        
        if isOpen ~= wasOpen then
            wasOpen = isOpen
            TweenServiceBlur:Create(blur, TweenInfo.new(0.3), {
                Size = isOpen and 20 or 0
            }):Play()
        end
    end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local hrp
__yisanbuy = false
__yisankill = false
__yisanloot = false
__optimizeGraphics = false
local entityFolder = workspace:WaitForChild("Entity")
local fxFolder = workspace:WaitForChild("FX")
local __yisanspeed = 16
local __yisanjump = 50

local __customDamage = 256
local __customAttackSpeed = 2

local hiddenBuildings = {}
local function hideBuildings(hide)
    local buildingParents = {
        workspace:FindFirstChild("Buildings"),
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("Environment"),
        workspace:FindFirstChild("Props"),
        workspace:FindFirstChild("Scenery"),
        workspace:FindFirstChild("Terrain"),
    }
    
    for _, parent in ipairs(buildingParents) do
        if parent then
            for _, obj in ipairs(parent:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
                    if hide then
                        if obj.Transparency ~= 1 then
                            hiddenBuildings[obj] = obj.Transparency
                            obj.Transparency = 1
                        end
                    else
                        if hiddenBuildings[obj] then
                            obj.Transparency = hiddenBuildings[obj]
                        end
                    end
                end
            end
        end
    end
end

local function watchNewBuildings()
    local buildingParents = {
        workspace:FindFirstChild("Buildings"),
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("Environment"),
        workspace:FindFirstChild("Props"),
        workspace:FindFirstChild("Scenery"),
    }
    
    for _, parent in ipairs(buildingParents) do
        if parent then
            parent.DescendantAdded:Connect(function(obj)
                if __optimizeGraphics and obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
                    if obj.Transparency ~= 1 then
                        hiddenBuildings[obj] = obj.Transparency
                        obj.Transparency = 1
                    end
                end
            end)
        end
    end
end

local function updateHrp()
    local char = player.Character
    if char then
        hrp = char:FindFirstChild("HumanoidRootPart")
    else
        hrp = nil
    end
end
player.CharacterAdded:Connect(updateHrp)
updateHrp()
watchNewBuildings()

local Tabs = {
    Main = Window:Tab({ Title = "功能", Icon = "swords",  Opened = true }),
    Settings = Window:Tab({ Title = "设置", Icon = "settings", Opened = true  })
}
Window:SelectTab(1)
local MainSec = Tabs.Main:Section({ Title = "功能" })

MainSec:Toggle({
    Title = "全图杀戮",
    Value = false,
    Callback = function(v) __yisankill = v end
})

MainSec:Toggle({
    Title = "自动收集",
    Value = false,
    Callback = function(v) __yisanloot = v end
})

MainSec:Toggle({
    Title = "自动售卖",
    Value = false,
    Callback = function(v) __yisanbuy = v end
})

local originalFogEnd = Lighting.FogEnd
local originalGlobalShadows = Lighting.GlobalShadows

MainSec:Toggle({
    Title = "自动165帧",
    Value = false,
    Callback = function(state)
        __optimizeGraphics = state
        if state then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1
            hideBuildings(true)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "自动165帧",
                Text = "已除雾阴影和隐藏建筑",
                Duration = 2
            })
        else
            Lighting.GlobalShadows = originalGlobalShadows
            Lighting.FogEnd = originalFogEnd
            hideBuildings(false)
            hiddenBuildings = {}
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "自动165帧",
                Text = "已恢复画质阴影建筑物）",
                Duration = 2
            })
        end
    end
})

-- ========== 神的伤害 (1000-1006) ==========
local damageLoop = nil
local function startDamageLoop()
    if damageLoop then return end
    damageLoop = task.spawn(function()
        while true do
            task.wait(0.5)
            local char = player.Character
            if not char then continue end
            local netMsg = char:FindFirstChild("NetMessage")
            if not netMsg then continue end
            local addBuff = netMsg:FindFirstChild("AddBuff")
            if not addBuff then continue end
            
            for id = 1000, 1006 do
                addBuff:FireServer(id, { __customDamage })
            end
        end
    end)
end

local function stopDamageLoop()
    if damageLoop then
        task.cancel(damageLoop)
        damageLoop = nil
    end
end

MainSec:Toggle({
    Title = "神的伤害",
    Value = false,
    Callback = function(state)
        if state then
            local char = player.Character
            if not char then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "错误",
                    Text = "角色未加载，无法启动自动刷新",
                    Duration = 2
                })
                return
            end
            local netMsg = char:FindFirstChild("NetMessage")
            if not netMsg or not netMsg:FindFirstChild("AddBuff") then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "错误",
                    Text = "未找到 AddBuff，可能游戏已更新",
                    Duration = 2
                })
                return
            end
            startDamageLoop()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "伤害加成",
                Text = "已开启自动刷新 (伤害值: " .. __customDamage .. "%)",
                Duration = 2
            })
        else
            stopDamageLoop()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "伤害加成",
                Text = "已停止自动刷新",
                Duration = 2
            })
        end
    end
})

MainSec:Input({
    Title = "伤害加成数值",
    Placeholder = "输入数字 (默认256)",
    Default = "256",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            __customDamage = math.floor(num)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "伤害设置",
                Text = "伤害加成已设为 " .. __customDamage .. "%",
                Duration = 2
            })
        else
            __customDamage = 256
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "伤害设置",
                Text = "无效输入，已重置为默认256",
                Duration = 2
            })
        end
    end
})

-- ========== 神的攻速 (1007-1050) 固定值 2 ==========
local attackSpeedLoop = nil
local function startAttackSpeedLoop()
    if attackSpeedLoop then return end
    attackSpeedLoop = task.spawn(function()
        while true do
            task.wait(0.5)
            local char = player.Character
            if not char then continue end
            local netMsg = char:FindFirstChild("NetMessage")
            if not netMsg then continue end
            local addBuff = netMsg:FindFirstChild("AddBuff")
            if not addBuff then continue end
            
            for id = 1007, 1050 do
                addBuff:FireServer(id, { __customAttackSpeed })
            end
        end
    end)
end

local function stopAttackSpeedLoop()
    if attackSpeedLoop then
        task.cancel(attackSpeedLoop)
        attackSpeedLoop = nil
    end
end

MainSec:Toggle({
    Title = "神的攻速",
    Value = false,
    Callback = function(state)
        if state then
            local char = player.Character
            if not char then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "错误",
                    Text = "角色未加载，无法启动自动刷新",
                    Duration = 2
                })
                return
            end
            local netMsg = char:FindFirstChild("NetMessage")
            if not netMsg or not netMsg:FindFirstChild("AddBuff") then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "错误",
                    Text = "未找到 AddBuff，可能游戏已更新",
                    Duration = 2
                })
                return
            end
            startAttackSpeedLoop()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "攻速加成",
                Text = "已开启自动刷新 (攻速值: " .. __customAttackSpeed .. "%)",
                Duration = 2
            })
        else
            stopAttackSpeedLoop()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "攻速加成",
                Text = "已停止自动刷新",
                Duration = 2
            })
        end
    end
})

-- ========== 神的测试 (1051-3000) 手动点击，数值 1 ==========
local function sendTestBuff()
    local char = player.Character
    if not char then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "错误",
            Text = "角色未加载，无法发送测试",
            Duration = 2
        })
        return
    end
    local netMsg = char:FindFirstChild("NetMessage")
    if not netMsg then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "错误",
            Text = "未找到 NetMessage",
            Duration = 2
        })
        return
    end
    local addBuff = netMsg:FindFirstChild("AddBuff")
    if not addBuff then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "错误",
            Text = "未找到 AddBuff，可能游戏已更新",
            Duration = 2
        })
        return
    end
    
    task.spawn(function()
        local count = 0
        for id = 1051, 3000 do
            addBuff:FireServer(id, { 1 })   -- 数值固定为 1
            count = count + 1
            if count % 10 == 0 then
                task.wait()
            end
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "神的测试",
            Text = "已发送 1051-3000 的 buff，数值 1",
            Duration = 3
        })
    end)
end

MainSec:Button({
    Title = "神的测试",
    Callback = function()
        sendTestBuff()
    end
})

-- ========== 移动速度设置 ==========
local speedSec = Tabs.Settings:Section({ Title = "移动速度" })
speedSec:Slider({
    Title = "移动速度",
    Step = 1,
    Value = {Min = 16, Max = 500, Default = 16},
    Callback = function(v) __yisanspeed = v end
})

speedSec:Slider({
    Title = "跳跃高度",
    Step = 1,
    Value = {Min = 50, Max = 200, Default = 50},
    Callback = function(v)
        __yisanjump = v
        if player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end
    end
})

RunService.Heartbeat:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = __yisanspeed
            hum.JumpPower = __yisanjump
        end
    end
end)

-- ========== 全图杀戮相关 ==========
local netFolder, setState, triggerSkill
local function bindNetSkill(char)
    netFolder = char:WaitForChild("NetMessage")
    setState = netFolder:WaitForChild("SetState")
    triggerSkill = netFolder:WaitForChild("TrigerSkill")
end
if player.Character then bindNetSkill(player.Character) end
player.CharacterAdded:Connect(bindNetSkill)

local swordFolder = ReplicatedStorage:WaitForChild("Model"):WaitForChild("Item"):WaitForChild("Weapon"):WaitForChild("Sword")
local staffFolder = ReplicatedStorage:WaitForChild("Model"):WaitForChild("Item"):WaitForChild("Weapon"):WaitForChild("Staff")
local currentSkillID = 101

task.spawn(function()
    while true do
        pcall(function()
            local weaponName = player.PlayerGui.EquipPanel.Main.EquipInfo.Main.Page.PlayerEquip.Equipment_Slot.Slot2.Weapon.ItemInfo.ItemName.Text
            if swordFolder:FindFirstChild(weaponName) then currentSkillID = 101
            elseif staffFolder:FindFirstChild(weaponName) then currentSkillID = 103
            end
        end)
        task.wait(1)
    end
end)

local MAX_BATCH = 100
local MIN_BATCH = 1
local MAX_FRAME_ATTACKS = 12
local MIN_FRAME_ATTACKS = 1

local currentBatch = 38
local currentFrameAttacks = 6
local frameTimeHistory = {}
local HISTORY_LEN = 8
local adjustCounter = 0
local TARGET_FRAME_TIME_IDEAL = 1 / 45
local TARGET_FRAME_TIME_STRESS = 1 / 28

local cachedEntities = {}
local function updateEntityCache()
    cachedEntities = entityFolder:GetChildren()
end
entityFolder.ChildAdded:Connect(updateEntityCache)
entityFolder.ChildRemoved:Connect(updateEntityCache)
updateEntityCache()

local function getAverageFrameTime()
    local sum = 0
    for _, t in ipairs(frameTimeHistory) do
        sum = sum + t
    end
    return sum / #frameTimeHistory
end

local function addFrameTime(dt)
    table.insert(frameTimeHistory, dt)
    if #frameTimeHistory > HISTORY_LEN then
        table.remove(frameTimeHistory, 1)
    end
end

RunService.Heartbeat:Connect(function(deltaTime)
    if not __yisankill then return end
    if not triggerSkill or not setState then return end
    if #cachedEntities == 0 then return end
    
    addFrameTime(deltaTime)
    adjustCounter = adjustCounter + 1
    
    if adjustCounter >= 3 then
        adjustCounter = 0
        local avgDT = getAverageFrameTime()
        
        if avgDT > TARGET_FRAME_TIME_STRESS then
            currentBatch = math.max(MIN_BATCH, currentBatch - 6)
            currentFrameAttacks = math.max(MIN_FRAME_ATTACKS, currentFrameAttacks - 1)
        elseif avgDT > TARGET_FRAME_TIME_IDEAL then
            currentBatch = math.max(MIN_BATCH, currentBatch - 2)
            currentFrameAttacks = math.max(MIN_FRAME_ATTACKS, currentFrameAttacks - 0.5)
        else
            currentBatch = math.min(MAX_BATCH, currentBatch + 5)
            currentFrameAttacks = math.min(MAX_FRAME_ATTACKS, currentFrameAttacks + 1.5)
        end
        
        currentBatch = math.floor(currentBatch)
        currentFrameAttacks = math.floor(currentFrameAttacks)
        
        currentBatch = math.max(MIN_BATCH, math.floor(currentBatch * 0.65))
        currentFrameAttacks = math.max(MIN_FRAME_ATTACKS, math.floor(currentFrameAttacks * 0.65))
        
        currentBatch = math.max(MIN_BATCH, math.floor(currentBatch * 0.85))
        currentFrameAttacks = math.max(MIN_FRAME_ATTACKS, math.floor(currentFrameAttacks * 0.85))
        
        local entityCount = #cachedEntities
        if entityCount > 0 then
            local maxUsefulFrameAttacks = math.floor(35 / entityCount) + 1
            currentFrameAttacks = math.min(currentFrameAttacks, maxUsefulFrameAttacks)
        end
    end
    
    if setState then setState:FireServer("action", true) end
    
    for _ = 1, currentFrameAttacks do
        for _, entity in ipairs(cachedEntities) do
            local root = entity:FindFirstChild("HumanoidRootPart") or entity.PrimaryPart
            if root then
                triggerSkill:FireServer(currentSkillID, "Enter", root.CFrame, currentBatch)
            end
        end
    end
    
    if setState then setState:FireServer("action", false) end
end)

-- ========== 自动收集 ==========
task.spawn(function()
    while true do
        if __yisanloot then
            if hrp then
                for _, fx in ipairs(fxFolder:GetChildren()) do
                    pcall(function()
                        if fx:IsA("BasePart") then 
                            fx.CFrame = hrp.CFrame
                        elseif fx:IsA("Model") and fx.PrimaryPart then 
                            fx:SetPrimaryPartCFrame(hrp.CFrame)
                        end
                    end)
                end
            end
        end
        task.wait(0.5)
    end
end)

-- ========== 自动售卖 ==========
local sellRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RemoteEvent")
local payload = table.create(100)
for i = 1, 100 do payload[i] = i end

task.spawn(function()
    while true do
        if __yisanbuy then
            if setState then
                setState:FireServer("action", true)
                task.wait(0.05)
                setState:FireServer("action", false)
                sellRemote:FireServer(539767613, payload)
            end
            task.wait(2)
        else
            task.wait(1)
        end
    end
end)
