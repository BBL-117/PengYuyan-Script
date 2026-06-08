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
    Title = "破碎之刃      ",
    Folder = "破碎之刃",
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
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

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

local waypoints = {
    { Vector3.new(795.87, 77.91, -207.31), 0.8 },
    { Vector3.new(455.59, 51.35, -123.67), 0.1 },
    { Vector3.new(51.52, 57.98, -150.84), 0.8 },
    { Vector3.new(-771.72, 56.90, -749.92), 0.8 },
    { Vector3.new(-837.12, 67.05, -1037.43), 0.8 },
    { Vector3.new(-1413.94, 54.71, -532.62), 0.1 },
    { Vector3.new(-1681.71, 59.83, -249.28), 0.8 },
    { Vector3.new(-2008.83, 135.56, -324.35), 0.8 },
    { Vector3.new(-2012.36, 51.80, -285.98), 0.8 },
    { Vector3.new(-2202.50, 48.66, -912.20), 0.1 },
    { Vector3.new(-2383.39, 48.66, -1505.60), 0.1 },
    { Vector3.new(-2529.16, 48.66, -1966.42), 0.1 },
    { Vector3.new(-2856.74, 341.33, -2033.35), 2 },
    { Vector3.new(-3134.84, 52.51, -2445.33), 2 },
    { Vector3.new(-2687.70, 282.06, -2967.69), 2 },
    { Vector3.new(-2360.55, 54.47, -2406.16), 2 },
}

local autoEnabled = false
local currentTask = nil

local function teleportTo(pos)
    local player = Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function startAutoBoss()
    if currentTask then task.cancel(currentTask) end
    currentTask = task.spawn(function()
        while autoEnabled do
            for _, wp in ipairs(waypoints) do
                if not autoEnabled then break end
                teleportTo(wp[1])
                task.wait(wp[2])
            end
        end
    end)
end

MainSec:Toggle({
    Title = "自动刷boss",
    Value = false,
    Callback = function(state)
        autoEnabled = state
        if state then
            startAutoBoss()
        else
            if currentTask then
                task.cancel(currentTask)
                currentTask = nil
            end
        end
    end
})