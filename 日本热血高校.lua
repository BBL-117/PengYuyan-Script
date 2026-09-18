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
        Title = "热血高校 老肯",
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

Window:Tag({ Title = "V1.00", Color = Color3.fromHex("00CED1"), Radius = 2 })
Window:Tag({ Title = "Yisan", Icon = "crown", Color = Color3.fromHex("FFD700"), Radius = 2 })
Window:Tag({ Title = "老肯", Icon = "square-chevron-right", Color = Color3.fromHex("#30ff6a"), Radius = 2 })

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
    local schemeData = COLOR_SCHEMES[colorScheme or "Fallen Purple"]
    glowEffect.Color = schemeData and schemeData[1] or COLOR_SCHEMES["Fallen Purple"][1]
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local DealDamageEvent = ReplicatedStorage:WaitForChild("DealDamageEvent")
local PunchStateEvent = ReplicatedStorage:WaitForChild("PunchStateEvent")

local KillTab = Window:Tab({
    Title = "击打功能",
    Icon = "sparkles",
    Locked = false,
})

local function getPlayerTeam(player)
    if not player then return "Unknown" end
    if player.Team then return player.Team.Name end
    local attr = player:GetAttribute("Team") or player:GetAttribute("Gang") or player:GetAttribute("Group")
    if attr then return tostring(attr) end
    if player.Character then
        local charAttr = player.Character:GetAttribute("Team") or player.Character:GetAttribute("Gang")
        if charAttr then return tostring(charAttr) end
        local teamVal = player.Character:FindFirstChild("Team") or player.Character:FindFirstChild("Gang")
        if teamVal and teamVal:IsA("ValueBase") then return tostring(teamVal.Value) end
    end
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local t = ls:FindFirstChild("Team") or ls:FindFirstChild("Gang") or ls:FindFirstChild("队伍") or ls:FindFirstChild("帮派")
        if t then return tostring(t.Value) end
    end
    return "Unknown"
end

local function isTeammate(player)
    if not player then return false end
    local myTeam = getPlayerTeam(LocalPlayer)
    if myTeam == "Unknown" or myTeam == "" then return false end
    return myTeam == getPlayerTeam(player)
end

local attackEnabled = false
local attackLoop = nil

KillTab:Toggle({
    Title = "范围杀戮",
    Desc = "老牛逼了",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        attackEnabled = state

        if not attackEnabled then
            if attackLoop then
                coroutine.close(attackLoop)
                attackLoop = nil
            end
            return
        end

        if attackLoop then
            coroutine.close(attackLoop)
            attackLoop = nil
        end

        attackLoop = coroutine.create(function()
            while attackEnabled do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Parent then
                        if not isTeammate(player) then
                            local char = player.Character
                            if char and char.Parent == workspace then
                                local humanoid = char:FindFirstChildOfClass("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    pcall(function()
                                        DealDamageEvent:FireServer(char)
                                    end)
                                end
                            end
                        end
                    end
                end

                for i = 1, 6 do
                    local spawnFolder = workspace:FindFirstChild("NPCSpawn" .. i)
                    if spawnFolder then
                        for _, hum in ipairs(spawnFolder:GetDescendants()) do
                            if hum:IsA("Humanoid") and hum.Health > 0 then
                                local model = hum.Parent
                                if model then
                                    pcall(function()
                                        DealDamageEvent:FireServer(model)
                                    end)
                                end
                            end
                        end
                    end
                end

                task.wait(0.1)
            end
        end)
        coroutine.resume(attackLoop)
    end
})

local fastPunchEnabled = false
local fastPunchLoop = nil
local animConnections = {}

local PUNCH_CPS = 20
local ANIM_MULTIPLIER = 2.5

local function clearAnimConnections()
    for _, c in ipairs(animConnections) do
        pcall(function() c:Disconnect() end)
    end
    animConnections = {}
end

local function bindAnimBoost(char)
    clearAnimConnections()
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end

    local function boost(track)
        if not fastPunchEnabled then return end
        pcall(function() track:AdjustSpeed(ANIM_MULTIPLIER) end)
    end

    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        boost(track)
    end
    local conn = animator.AnimationPlayed:Connect(boost)
    table.insert(animConnections, conn)
end

if LocalPlayer.Character then bindAnimBoost(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    bindAnimBoost(char)
end)

KillTab:Toggle({
    Title = "咏春",
    Desc = "开启之后自动成为叶问的传人",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        fastPunchEnabled = state

        if fastPunchEnabled then
            bindAnimBoost(LocalPlayer.Character)

            if fastPunchLoop then coroutine.close(fastPunchLoop); fastPunchLoop = nil end
            fastPunchLoop = coroutine.create(function()
                while fastPunchEnabled do
                    pcall(function()
                        PunchStateEvent:FireServer(true)
                    end)
                    task.wait(1 / PUNCH_CPS)
                end
            end)
            coroutine.resume(fastPunchLoop)
        else
            if fastPunchLoop then coroutine.close(fastPunchLoop); fastPunchLoop = nil end
            pcall(function() PunchStateEvent:FireServer(false) end)

            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        pcall(function() track:AdjustSpeed(1) end)
                    end
                end
            end
            clearAnimConnections()
        end
    end
})

game:BindToClose(function()
    pcall(function() PunchStateEvent:FireServer(false) end)
    clearAnimConnections()
end)

task.spawn(function()
    RunService.Heartbeat:Wait()
end)