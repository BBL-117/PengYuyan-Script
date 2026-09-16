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
        Title = "JiaoseChuan",
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
    Title = "V1.00",
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
    Title = "Laoken",
    Icon = "square-chevron-right",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 2,
})

local COLOR_SCHEMES = {
    ["Fallen Purple"] = {
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromHex("2E1065")
            ),
            ColorSequenceKeypoint.new(
                0.3,
                Color3.fromHex("4C1D95")
            ),
            ColorSequenceKeypoint.new(
                0.6,
                Color3.fromHex("7C3AED")
            ),
            ColorSequenceKeypoint.new(
                1,
                Color3.fromHex("C084FC")
            )
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
        task.wait(0.000001)
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

local player = game:GetService("Players").LocalPlayer
local muscleEvent = player:WaitForChild("muscleEvent")
local RunService = game:GetService("RunService")
local heartbeatConnection = nil
local SendCount = 18

local function fireWeight()
    local char = player.Character
    if char then
        local weight = char:FindFirstChild("Weight")
        if weight then
            muscleEvent:FireServer("rep", weight)
        end
    end
end

local function startLoop()
    if heartbeatConnection then return end
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        for _ = 10, SendCount do
            fireWeight()
        end
    end)
end

local function stopLoop()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

local rebirthRemote = game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthRemote")
local rebirthRunning = false
local rebirthThread = nil

local function fireRebirth()
    rebirthRemote:InvokeServer("massRebirthRequest", "MAX")
end

local function startRebirthLoop()
    if rebirthRunning then return end
    rebirthRunning = true
    rebirthThread = task.spawn(function()
        while rebirthRunning and task.wait(0.000001) do
            fireRebirth()
        end
    end)
end

local function stopRebirthLoop()
    rebirthRunning = false
    if rebirthThread then
        task.cancel(rebirthThread)
        rebirthThread = nil
    end
end

local Tab = Window:Tab({
    Title = "功能",
    Icon = "sparkles",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "快速锻炼(只支持哑铃)",
    Desc = "This is very fast",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        if state then
            startLoop()
        else
            stopLoop()
        end
    end
})

local RebirthToggle = Tab:Toggle({
    Title = "快速重生(搭配游戏重生更快)",
    Desc = "Should be fast",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            startRebirthLoop()
        else
            stopRebirthLoop()
        end
    end
})