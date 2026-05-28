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
    Title = "拳击测试版      ",
    Folder = "拳击测试版",
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
    Title = "老肯制作",
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
}

local function createRainbowBorder()
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end
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
    glowEffect.Color = COLOR_SCHEMES["彩虹颜色"][1]
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    game:GetService("RunService").Heartbeat:Connect(function()
        if glowEffect then
            glowEffect.Rotation = (tick() * 50) % 360
        end
    end)
end
createRainbowBorder()

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local blur = Lighting:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", Lighting)
blur.Size = 0
task.spawn(function()
    local wasOpen = false
    while true do
        task.wait(0.1)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        local isOpen = mainFrame and mainFrame.Visible or false
        if isOpen ~= wasOpen then
            wasOpen = isOpen
            TweenService:Create(blur, TweenInfo.new(0.3), { Size = isOpen and 20 or 0 }):Play()
        end
    end
end)

local Tabs = {
    Main = Window:Tab({ Title = "功能", Icon = "swords", Opened = true }),
}
Window:SelectTab(1)
local MainSec = Tabs.Main:Section({ Title = "功能" })

local isEnabled = false
local remote = game:GetService("ReplicatedStorage").CombatRemotesRemotes.Guard4Event

task.spawn(function()
    while true do
        if isEnabled then
            remote:FireServer("blockStart")
        end
        task.wait(1)
    end
end)

MainSec:Toggle({
    Title = "自动防御",
    Value = false,
    Callback = function(state)
        isEnabled = state
    end
})