local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yisan886/Aero/refs/heads/main/ui.lua.txt"))()

WindUI:AddTheme({
    Name = "Fallen Aero",
    Accent = Color3.fromHex("#7C3AED"),
    Background = Color3.fromHex("#09090B"),
    Outline = Color3.fromHex("#4C1D95"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#71717A"),
    Button = Color3.fromHex("#1E1B4B"),
    Icon = Color3.fromHex("#A78BFA"),
})

local Window = WindUI:CreateWindow({
    Title = "Aero      ",
    Folder = "Aero",
    SideBarWidth = 180,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/alHcHts2JjSlmMRKjQeDXFipKS5LjNhrKrkN8TxbH7HgPmXA1QbuEYZh3Hwnb9F5_1536x1024x1945789.png",
    BackgroundImageTransparency = 0.35,
    OpenButton = {
        Title = "虚空肌肉(作者自用版)",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.9,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("6D28D9")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("A855F7"))
        }),
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
})

Window:Tag({
    Title = "V1.03",
    Color = Color3.fromHex("00CED1"),
    Radius = 2,
})

Window:Tag({
    Title = "Yisan",
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
    ["Fallen Purple"] = {
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("2E1065")),
            ColorSequenceKeypoint.new(0.3, Color3.fromHex("4C1D95")),
            ColorSequenceKeypoint.new(0.6, Color3.fromHex("7C3AED")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("C084FC"))
        }),
        "waves"
    }
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
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Transparency = 0.15
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
    local outerGlow = Instance.new("UIStroke")
    outerGlow.Name = "OuterGlow"
    outerGlow.Thickness = 8
    outerGlow.Transparency = 0.85
    outerGlow.Color = Color3.fromHex("7C3AED")
    outerGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    outerGlow.Parent = mainFrame
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

local rainbowStroke = createRainbowBorder(Window, "Fallen Purple")
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

local Tab = Window:Tab({
    Title = "功能",
    Icon = "sparkles",
    Locked = false,
})

local crystalLoopValue = false
local crystalLoopThread = nil

local function startCrystalLoop()
    if crystalLoopThread then return end
    crystalLoopValue = true
    crystalLoopThread = task.spawn(function()
        while crystalLoopValue do
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote")
                remote:InvokeServer("openCrystal", "True Space Crystal")
            end)
            task.wait(0.000001)
        end
        crystalLoopThread = nil
    end)
end

local function stopCrystalLoop()
    crystalLoopValue = false
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
                local args = { "rebirthRequest", 999999999999999 }
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

Tab:Toggle({
    Title = "自动锻炼(只支持哑铃)",
    Desc = "ZidongDuanlian",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            startExercise()
        else
            stopExercise()
        end
    end
})

Tab:Toggle({
    Title = "自动重生",
    Desc = "ZidongChuongSheng",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            startRebirth()
        else
            stopRebirth()
        end
    end
})

Tab:Toggle({
    Title = "快速抽蛋(只支持1.2k绿宝石的宠物水晶)",
    Desc = "KuaiShuChoDan",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            startCrystalLoop()
        else
            stopCrystalLoop()
        end
    end
})

Tab:Toggle({
    Title = "自动进化",
    Desc = "ZidongJinhua",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            startEvolve()
        else
            stopEvolve()
        end
    end
})

Tab:Toggle({
    Title = "原地复活",
    Desc = "YudiFuHuo",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            startRevive()
        else
            stopRevive()
        end
    end
})

Tab:Button({
    Title = "删除显示",
    Desc = "",
    Callback = function()
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
    end,
})

Tab:Button({
    Title = "删除没用的东西",
    Desc = "",
    Callback = function()
        pcall(function()
            local character = player.Character
            if not character then return end
            for _, item in ipairs(character:GetChildren()) do
                if item.Name == "sweatPart" or item.Name == "airPart" then
                    item:Destroy()
                end
            end
        end)
    end,
})

local propertyTab = Window:Tab({
    Title = "属性值计算",
    Icon = "sparkles",
    Locked = false,
})

local playerCards = {}
local loopCounter = 0

local function formatNum(num)
    if type(num) ~= "number" then return "0" end
    if num == 0 then return "0" end
    if num < 0 then return "-" .. formatNum(-num) end
    if num < 1 then
        return string.format("%.2f", num)
    end
    if num < 1000 then
        return tostring(math.floor(num))
    end
    local units = {
        {name = "k", val = 1e3},
        {name = "M", val = 1e6},
        {name = "B", val = 1e9},
        {name = "T", val = 1e12},
        {name = "Qa", val = 1e15},
        {name = "Qi", val = 1e18},
        {name = "Sx", val = 1e21},
        {name = "Sp", val = 1e24},
        {name = "Oc", val = 1e27},
        {name = "No", val = 1e30},
        {name = "Dc", val = 1e33},
        {name = "UD", val = 1e36},
        {name = "DD", val = 1e39},
        {name = "TD", val = 1e42},
        {name = "QaD", val = 1e45},
        {name = "QiD", val = 1e48},
        {name = "SxD", val = 1e51},
        {name = "SpD", val = 1e54},
        {name = "OcD", val = 1e57},
        {name = "NcD", val = 1e60},
    }
    for i = #units, 1, -1 do
        if num >= units[i].val then
            local result = num / units[i].val
            local rounded = math.floor(result + 0.5)
            if math.abs(result - rounded) < 0.001 then
                return tostring(rounded) .. units[i].name
            else
                return string.format("%.1f", result) .. units[i].name
            end
        end
    end
    return tostring(math.floor(num))
end

local function updatePlayerCard(player)
    local userId = player.UserId
    local cardData = playerCards[userId]
    if not cardData then return end

    local para = cardData.paragraph
    if not para or not para.Parent then
        if para and para.Destroy then
            pcall(para.Destroy, para)
        end
        para = propertyTab:Paragraph({
            Title = player.DisplayName .. " (" .. player.Name .. ")",
            Desc = "加载中..."
        })
        cardData.paragraph = para
        cardData.lastStrength = nil
        cardData.lastRebirths = nil
        cardData.lastTime = nil
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        para:SetDesc("玩家数据未加载")
        return
    end

    local strength = leaderstats:FindFirstChild("Strength")
    local rebirths = leaderstats:FindFirstChild("Rebirths")
    if not strength or not rebirths then
        para:SetDesc("缺少属性 (Strength/Rebirths)")
        return
    end

    local currentTime = tick()
    local deltaTime = currentTime - (cardData.lastTime or currentTime)
    local currentStrength = strength.Value
    local currentRebirths = rebirths.Value

    local strengthPerSec = 0
    local rebirthPerSec = 0
    if cardData.lastStrength and deltaTime > 0.01 then
        strengthPerSec = (currentStrength - cardData.lastStrength) / deltaTime
        rebirthPerSec = (currentRebirths - cardData.lastRebirths) / deltaTime
    end

    local desc = string.format(
        "昵称：%s\n名字：%s\n力量：%s\n重生：%s\n力量速率：%s/秒\n重生速率：%s/秒\n刷新时间：%s",
        player.DisplayName,
        player.Name,
        formatNum(currentStrength),
        formatNum(currentRebirths),
        formatNum(strengthPerSec),
        formatNum(rebirthPerSec),
        os.date("%H:%M:%S")
    )
    para:SetDesc(desc)

    cardData.lastStrength = currentStrength
    cardData.lastRebirths = currentRebirths
    cardData.lastTime = currentTime
end

local function refreshAllPlayers()
    local currentPlayers = Players:GetPlayers()
    local currentIds = {}
    for _, p in ipairs(currentPlayers) do
        currentIds[p.UserId] = true
    end

    for userId, cardData in pairs(playerCards) do
        if not currentIds[userId] then
            if cardData.paragraph and cardData.paragraph.Destroy then
                pcall(cardData.paragraph.Destroy, cardData.paragraph)
            end
            playerCards[userId] = nil
        end
    end

    for _, player in ipairs(currentPlayers) do
        local userId = player.UserId
        if not playerCards[userId] then
            local newPara = propertyTab:Paragraph({
                Title = player.DisplayName .. " (" .. player.Name .. ")",
                Desc = "加载中..."
            })
            playerCards[userId] = {
                paragraph = newPara,
                lastStrength = nil,
                lastRebirths = nil,
                lastTime = nil
            }
        end
        updatePlayerCard(player)
    end

    loopCounter = loopCounter + 1
    if loopCounter % 10 == 0 then
        print("循环仍在运行，已执行 " .. loopCounter .. " 次")
    end
end

while task.wait(0.5) do
    local success, err = pcall(refreshAllPlayers)
    if not success then
        print("刷新出错:", err)
    end
end