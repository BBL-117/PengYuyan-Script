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
        Title = "Open Script",
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

local Tab = Window:Tab({
    Title = "示例",
    Icon = "sparkles",
    Locked = false,
})

local Community = Tab:Section({
    Title = "Aero Discord",
    IconName = "message-circle"
})

Community:Image({
    Image = "https://raw.githubusercontent.com/yisanll/yisani/main/ChatGPT%20Image%202026%E5%B9%B45%E6%9C%8830%E6%97%A5%2015_35_25.png",
    AspectRatio = "1:1"
})

Community:Paragraph({
    Title = "💬 Aero Discord",
    Desc = [[
Official Aero Community

⚡ Script Updates
🎧 Support
🔔 Announcements
👥 Community Chat
]]
})

Community:Button({
    Title = "📋 Copy Discord Link",
    Icon = "copy",
    Callback = function()
        setclipboard("https://discord.gg/c3VC35PPxz")
        WindUI:Notify({
            Title = "Discord",
            Content = "Link copied",
            Duration = 3
        })
    end
})

local inputText = ""

local Input = Tab:Input({
    Title = "事件代码",
    Desc = "输入要循环执行的 Lua事件",
    Placeholder = "请输入事件",
    Value = "",
    Callback = function(text)
        inputText = text
    end
})

local speedInputValue = "1"

local SpeedInput = Tab:Input({
    Title = "循环速度",
    Desc = "(输入数字1就是1秒1次),没有限制的服务器太快会卡死卡死都不要找我",
    Placeholder = "请输入数字",
    Value = "1",
    Callback = function(text)
        speedInputValue = text
    end
})

local running = false
local loopThread = nil

local Toggle = Tab:Toggle({
    Title = "开关",
    Desc = "开启后循环执行上方输入框中的事件",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            if running then return end
            running = true
            loopThread = coroutine.create(function()
                while running do
                    local speedStr = speedInputValue or "1"
                    local speedNum = tonumber(speedStr)
                    if speedNum == nil or speedNum < 0 then
                        speedNum = 1
                    end
                    local interval
                    if speedNum == 0 then
                        interval = 0
                    else
                        interval = 1 / speedNum
                    end

                    if interval == 0 then
                        while running do
                            if inputText and inputText ~= "" then
                                pcall(function()
                                    loadstring(inputText)()
                                end)
                            end
                        end
                    else
                        if inputText and inputText ~= "" then
                            pcall(function()
                                loadstring(inputText)()
                            end)
                        end
                        task.wait(interval)
                    end
                end
            end)
            coroutine.resume(loopThread)
        else
            running = false
            loopThread = nil
        end
    end
})