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
    Title = "Aero跑路改良版      ",
    Folder = "Aero跑路改良版",
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

Window:Tag({
    Title = "老肯",
    Icon = "square-chevron-right",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 2,
})

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("EE82EE"))
    }), "palette"},

    ["绿黄渐变"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("30FF6A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("a8ff00")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("e7ff2f"))
    }), "waves"},
}

local borderAnimation
local animationSpeed = 5

local function createRainbowBorder(window, colorScheme)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end

    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then existingStroke:Destroy() end

    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end

    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame

    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    local schemeData = COLOR_SCHEMES[colorScheme or "彩虹颜色"]
    glowEffect.Color = schemeData and schemeData[1] or COLOR_SCHEMES["彩虹颜色"][1]
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke

    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end

    return game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then return end
        glowEffect.Rotation = (tick() * speed * 10) % 360
    end)
end

local rainbowStroke = createRainbowBorder(Window, "彩虹颜色")
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

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
local entityFolder = workspace:WaitForChild("Entity")
local fxFolder = workspace:WaitForChild("FX")
local __yisanspeed = 16

local Tabs = {
    Main = Window:Tab({ Title = "功能", Icon = "swords",  Opened = true }),
    Settings = Window:Tab({ Title = "设置", Icon = "settings", Opened = true  })
}
Window:SelectTab(1)
local MainSec = Tabs.Main:Section({ Title = "功能" })

MainSec:Toggle({
    Title = "超极速杀戮 (最快)",
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

local speedSec = Tabs.Settings:Section({ Title = "移动速度" })
speedSec:Slider({
    Title = "移动速度",
    Step = 1,
    Value = {Min = 16, Max = 500, Default = 16},
    Callback = function(v) __yisanspeed = v end
})

RunService.Heartbeat:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = __yisanspeed end
    end
end)

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

-- ========== 超极速杀戮（每帧每个敌人攻击16次，≈960次/秒，兼顾性能） ==========
local ATTACKS_PER_FRAME = 16   -- 60帧 × 16 = 960次/秒/敌人，接近1000且不易卡顿

RunService.Heartbeat:Connect(function()
    if not __yisankill then return end
    if not setState or not triggerSkill then return end
    
    local entities = entityFolder:GetChildren()
    if #entities == 0 then return end
    
    -- 移除pcall以减少性能开销
    for i = 1, ATTACKS_PER_FRAME do
        for _, entity in ipairs(entities) do
            local root = entity:FindFirstChild("HumanoidRootPart") or entity.PrimaryPart
            if root then
                setState:FireServer("action", true)
                triggerSkill:FireServer(currentSkillID, "Enter", root.CFrame, 1)
                setState:FireServer("action", false)
            end
        end
    end
end)
-- ========================================================================

task.spawn(function()
    while true do
        if __yisanloot and hrp then
            for _, fx in ipairs(fxFolder:GetChildren()) do
                if fx:IsA("BasePart") then fx.CFrame = hrp.CFrame
                elseif fx:IsA("Model") and fx.PrimaryPart then fx:SetPrimaryPartCFrame(hrp.CFrame) end
            end
        end
        task.wait(2)
    end
end)

local sellRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RemoteEvent")
local payload = table.create(100)
for i = 1, 100 do payload[i] = i end

task.spawn(function()
    while true do
        if __yisanbuy and setState then
            setState:FireServer("action", true)
            task.wait(0.05)
            setState:FireServer("action", false)
            sellRemote:FireServer(539767613, payload)
            task.wait(30)
        else
            task.wait(1)
        end
    end
end)