local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local Confirmed = false

local gradientColors = {
    "rgb(255, 230, 235)",
    "rgb(255, 210, 220)",
    "rgb(255, 190, 205)",
    "rgb(255, 170, 190)",
    "rgb(255, 150, 175)",
    "rgb(245, 140, 180)",
    "rgb(235, 130, 185)",
    "rgb(225, 120, 190)",
    "rgb(215, 110, 195)",
    "rgb(205, 100, 200)"
}

local username = game.Players.LocalPlayer.Name
local coloredUsername = ""
for i = 1, #username do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. username:sub(i, i) .. '</font>'
end

local version = "v1.2.4"
local coloredVersion = ""
for i = 1, #version do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredVersion = coloredVersion .. '<font color="' .. gradientColors[colorIndex] .. '">' .. version:sub(i, i) .. '</font>'
end

WindUI:Popup({
    Title = '<font color="' .. gradientColors[1] .. '">塔</font><font color="' .. gradientColors[5] .. '">菲</font>',
    IconThemed = true,
    Content = "尊敬的用户 " .. coloredUsername .. " \n您使用的 <font color='" .. gradientColors[1] .. "'>塔</font><font color='" .. gradientColors[5] .. "'>菲</font> 当前版本型号是: " .. coloredVersion .. "\n现已支持99999个服务器！",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                Confirmed = true
                createUI()
            end,
            Variant = "Primary",
        }
    }
})

function createUI()
    local Window = WindUI:CreateWindow({
        Title = '塔菲',
        Icon = "heart",
        IconThemed = true,
        Author = "伊散",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(580, 440),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "96257754578409",
        BackgroundImageTransparency = 0.5,
        User = {
            Enabled = true,
            Callback = function()
                WindUI:Notify({
                    Title = "点击了自己",
                    Content = "没什么", 
                    Duration = 1,
                    Icon = "96257754578409"
                })
            end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText)
                print("搜索内容:", searchText)
            end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                {
                    Type = "Button", 
                    Text = "塔菲",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })

Window:EditOpenButton({
    Title = "塔菲",
    Icon = "rbxassetid://96257754578409",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
    Draggable = true,
})

Window:Tag({
        Title = "极速传奇",
        Color = Color3.fromHex("#00ffff") 
    })

Window:EditOpenButton({
    Title = "塔菲",
    Icon = "heart",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
    Draggable = true,
})

spawn(function()
    while true do
        for hue = 0, 1, 0.01 do  
            local color = Color3.fromHSV(hue, 0.8, 1)  
            Window:EditOpenButton({
                Color = ColorSequence.new(color)
            })
            wait(0.04)  
        end
    end
end)

local LockSection = Window:Section({
    Title = "公告",
    Opened = true,
})

local infoTab = Window:Tab({Title = "通知", Icon = "layout-grid", Locked = false})

local LockSection = Window:Section({
    Title = "主功能",
    Opened = true,
})

local function AddTab(section, title, icon)
    return section:Tab({Title = title, Icon = icon})
end

local A = AddTab(LockSection, "主要", "rbxassetid://7734068321")  
local B = AddTab(LockSection, "卡宠", "rbxassetid://7734068321")  
local C = AddTab(LockSection, "宝石", "rbxassetid://7734068321")  
local D = AddTab(LockSection, "比赛", "rbxassetid://7734068321")  
local E = AddTab(LockSection, "传送", "rbxassetid://7734068321")  
local F = AddTab(LockSection, "重生", "rbxassetid://7734068321")  
local G = AddTab(LockSection, "修改", "rbxassetid://7734068321")  
local H = AddTab(LockSection, "宠物蛋", "rbxassetid://7734068321")  
local I = AddTab(LockSection, "卡宠说明", "rbxassetid://7734068321")  
local J = AddTab(LockSection, "画质+通用", "rbxassetid://7734068321")

local infoSection = infoTab:Section({Title = "详情", Opened = true})

infoSection:Paragraph({
    Title = "关于",
    Desc = "国内第一极速传奇\n免费最佳",
    ThumbnailSize = 190,
})

local extraSection = A:Section({Title = "额外", Opened = true})

extraSection:Button({
    Title = "收集全部宝箱",
    Callback = function()
        for _, v in pairs(game.ReplicatedStorage.chestRewards:GetChildren()) do
            game.ReplicatedStorage.rEvents.checkChestRemote:InvokeServer(v.Name)
        end
    end
})

extraSection:Button({
    Title = "解锁全部通行证",
    Callback = function()
        for i, v in ipairs(game:GetService("ReplicatedStorage").gamepassIds:GetChildren()) do
            v.Parent = game.Players.LocalPlayer.ownedGamepasses
        end
    end
})

extraSection:Toggle({
    Title = "吸全部环",
    Default = false,
    Callback = function(state)
        getgenv().HoopEnabled = state
        
        if state then
            spawn(function()
                while getgenv().HoopEnabled and task.wait() do
                    pcall(function()
                        local character = game.Players.LocalPlayer.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local hrp = character.HumanoidRootPart
                            for _, hoop in ipairs(workspace.Hoops:GetChildren()) do
                                if hoop.Name == "Hoop" then
                                    hoop.CFrame = hrp.CFrame
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

local cardPetSection1 = B:Section({Title = "卡宠模式1", Opened = true})

local Interstellar = {
    area = "City",
    getorb = false
}

local areaOptions = {"City","Snow City","Magma City","Desert","Space", "Legends Highway", "Speed Jungle"}
local areaDisplayNames = {"城市","雪城","熔岩城","沙漠","太空","传奇公路","丛林"}
cardPetSection1:Dropdown({
    Title = "选择地区",
    Values = areaDisplayNames,
    Value = "城市",
    Callback = function(Value)
        Interstellar.area = areaOptions[table.find(areaDisplayNames, Value)]
    end
})

cardPetSection1:Paragraph({
    Title = "优化版说明",
    Desc = "请先选择地区否则获球地方将默认城市\n建议用经验球卡宠\n最稳定的一个喵",
    ThumbnailSize = 190,
})

local function checkMaxLevel()
local player = game.Players.LocalPlayer
Interstellar.isMaxLevel = player:GetAttribute("IsMaxLevel") == true
end

game:GetService("RunService").Heartbeat:Connect(function()
checkMaxLevel()
end)

cardPetSection1:Toggle({
    Title = "紫球",
    Default = false,
    Callback = function(state)
        Interstellar.getorb = state
        if state then
            spawn(function()
                while Interstellar.getorb do
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Ethereal Orb", Interstellar.area)
                    wait(0.001)
                end
            end)
        end
    end
})

cardPetSection1:Toggle({
    Title = "红球",
    Default = false,
    Callback = function(state)
        Interstellar.getorb = state
        if state then
            spawn(function()
                while Interstellar.getorb do
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                    wait(0.001)
                end
            end)
        end
    end
})

cardPetSection1:Toggle({
    Title = "蓝球",
    Default = false,
    Callback = function(state)
        Interstellar.getorb = state
        if state then
            spawn(function()
                while Interstellar.getorb do
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                    wait(0.001)
                end
            end)
        end
    end
})

cardPetSection1:Toggle({
    Title = "橙球",
    Default = false,
    Callback = function(state)
        Interstellar.getorb = state
        if state then
            spawn(function()
                while Interstellar.getorb do
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", Interstellar.area)
                    wait(0.001)
                end
            end)
        end
    end
})

cardPetSection1:Toggle({
    Title = "经验球",
    Default = false,
    Callback = function(state)
        Interstellar.getorb = state
        if state then
            spawn(function()
                while Interstellar.getorb do
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", Interstellar.area)
                    wait(0.001)
                end
            end)
        end
    end
})

local cardPetSection2 = B:Section({Title = "自定义-卡宠模式2", Opened = true})

local Interstellar2 = {
    area = "City",
    orbType = "Yellow Orb",
    rateEnabled = false,
    multiplier = 1,
    validAreas = {"City","Snow City","Magma City","Legends Highway","Speed Jungle","Desert","Space"},
    currentArea = "City",
    isMaxLevel = false
}

local function updateCurrentArea()
    Interstellar2.currentArea = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:GetAttribute("CurrentArea") or "City"
end

local function checkMaxLevel2()
    local player = game.Players.LocalPlayer
    Interstellar2.isMaxLevel = player:GetAttribute("IsMaxLevel") == true
end

game:GetService("RunService").Heartbeat:Connect(function()
    updateCurrentArea()
    checkMaxLevel2()
end)

local areaDisplayNames = {"城市", "雪城", "熔岩城", "沙漠", "太空", "传奇公路", "丛林"}
local areaOptions = {"City", "Snow City", "Magma City", "Desert", "Space", "Legends Highway", "Speed Jungle"}
local orbDisplayNames = {"紫球", "红球", "蓝球", "橙球", "经验球"}
local orbTypes = {"Ethereal Orb", "Red Orb", "Blue Orb", "Orange Orb", "Yellow Orb"}

cardPetSection2:Dropdown({
    Title = "选择地区",
    Values = areaDisplayNames,
    Value = "城市",
    Callback = function(Value)
        local idx = table.find(areaDisplayNames, Value)
        if idx then
            Interstellar2.area = areaOptions[idx]
        else
            Interstellar2.area = "City"
        end
    end
})

cardPetSection2:Dropdown({
    Title = "选择球类型",
    Values = orbDisplayNames,
    Value = "经验球",
    Callback = function(Value)
        local idx = table.find(orbDisplayNames, Value)
        if idx then
            Interstellar2.orbType = orbTypes[idx]
        else
            Interstellar2.orbType = "Yellow Orb"
        end
    end
})

cardPetSection2:Paragraph({
    Title = "卡宠倍率",
    Desc = "不完全优化\n请先选择地区否则获球地方将默认城市\n倍率过高可能会卡",
    ThumbnailSize = 190,
})

cardPetSection2:Input({
    Title = "输入倍率",
    Desc = "默认1",
    Callback = function(value)
        Interstellar2.multiplier = math.clamp(tonumber(value) or 1, 1, 10000)
    end
})

cardPetSection2:Toggle({
    Title = "卡宠速度总开关",
    Default = false,
    Callback = function(state)
        Interstellar2.rateEnabled = state
        if state then
            spawn(function()
                local e = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e2 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e3 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e4 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e5 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e6 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e7 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e8 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e9 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                local e10 = game:GetService("ReplicatedStorage").rEvents.orbEvent
                while Interstellar2.rateEnabled do
                    if Interstellar2.isMaxLevel then
                        Interstellar2.rateEnabled = false
                        break
                    end
                    local total = 1 * Interstellar2.multiplier
                    for i = 1, total do
                        e:FireServer("collectOrb", Interstellar2.orbType, Interstellar2.area)
                        e2:FireServer("collectOrb", Interstellar2.orbType, Interstellar2.area)
                    end
                    task.wait(0.00001)
                end
            end)
        end
    end
})

local gemSection = C:Section({Title = "宝石模式", Opened = true})

gemSection:Paragraph({
    Title = "宝石模式说明",
    Desc = "卡宠后效果显著\n建议在卡宠状态下使用",
    ThumbnailSize = 190,
})

gemSection:Toggle({
    Title = "城市宝石",
    Default = false,
    Callback = function(state)
        getgenv().sbsA = state
        if state then
            spawn(function()
                while getgenv().sbsA do
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                    wait()
                end
            end)
        end
    end
})

gemSection:Toggle({
    Title = "雪城宝石",
    Default = false,
    Callback = function(state)
        getgenv().sbsB = state
        if state then
            spawn(function()
                while getgenv().sbsB do
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Snow City")
                    wait()
                end
            end)
        end
    end
})

gemSection:Toggle({
    Title = "熔岩城宝石",
    Default = false,
    Callback = function(state)
        getgenv().sbsC = state
        if state then
            spawn(function()
                while getgenv().sbsC do
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                    wait()
                end
            end)
        end
    end
})

gemSection:Toggle({
    Title = "传奇公路宝石",
    Default = false,
    Callback = function(state)
        getgenv().sbsD = state
        if state then
            spawn(function()
                while getgenv().sbsD do
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                    wait()
                end
            end)
        end
    end
})

gemSection:Toggle({
    Title = "丛林宝石",
    Default = false,
    Callback = function(state)
        getgenv().sbsE = state
        if state then
            spawn(function()
                while getgenv().sbsE do
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "Speed Jungle")
                    wait()
                end
            end)
        end
    end
})

local raceSection = D:Section({Title = "比赛", Opened = true})

local Maps = {}
for _,v in pairs(game.workspace.raceMaps:GetChildren()) do
    table.insert(Maps, v.Name)
end

local selectedMap = ""

raceSection:Toggle({
    Title = "自动比赛",
    Default = false,
    Callback = function(state)
        autoRace = state
        if state then
            spawn(function()
                while autoRace do
                    game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace")
                    wait()
                end
            end)
        end
    end
})

raceSection:Dropdown({
    Title = "比赛终点传送",
    Values = Maps,
    Value = "",
    Callback = function(value)
        selectedMap = value
    end
})

raceSection:Button({
    Title = "点击传送",
    Callback = function()
        if selectedMap and game.workspace.raceMaps:FindFirstChild(selectedMap) then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = game.workspace.raceMaps[selectedMap].finishPart.CFrame
            end
        end
    end
})

raceSection:Toggle({
    Title = "自动比赛胜利(传送)",
    Default = false,
    Callback = function(state)
        Interstellar.mainexe = state
        if Interstellar.mainexe then
            if game.PlaceId == 3101667897 then
                while Interstellar.mainexe do
                    game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace")
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.raceMaps.Grassland.finishPart.CFrame
                    task.wait(0.1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.raceMaps.Magma.finishPart.CFrame
                    task.wait(0.1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.raceMaps.Desert.finishPart.CFrame
                    task.wait(0.3)
                end
            elseif game.PlaceId == 3276265788 then
                while Interstellar.mainexe do
                    game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace")
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.raceMaps.Speedway.finishPart.CFrame
                    task.wait(0.2)
                end
            elseif game.PlaceId == 3232996272 then
                while Interstellar.mainexe do
                    game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace")
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.raceMaps.Starway.finishPart.CFrame
                    task.wait(0.2)
                end
            end
        end
    end
})

local teleportSection = E:Section({Title = "传送点", Opened = true})

teleportSection:Button({
    Title = "城市",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2002.0133056640625, 1.2624330520629883, 985.2265625)
    end
})

teleportSection:Button({
    Title = "雪城",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9675.25, 59.63568115234375, 3783.50146484375)
    end
})

teleportSection:Button({
    Title = "熔岩城",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11052.4189453125, 217.59571838378906, 4898.76416015625)
    end
})

teleportSection:Button({
    Title = "传奇公路",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13095.255859375, 217.59567260742188, 5905.240234375)
    end
})

teleportSection:Button({
    Title = "丛林",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-15267.9,399.0,5575.7)
    end
})

local rebirthSection1 = F:Section({Title = "模式1", Opened = true})

rebirthSection1:Toggle({
    Title = "自动重生",
    Default = false,
    Callback = function(state)
        Interstellar.mainexe = state
        if Interstellar.mainexe then
            spawn(function()
                while Interstellar.mainexe do
                    pcall(function()
                        game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
                    end)
                    wait()
                end
            end)
        end
    end
})

local rebirthSection2 = F:Section({Title = "模式2", Opened = true})

rebirthSection2:Input({
    Title = "自定义重生次数",
    Desc = "次数",
    Callback = function(value)
        Interstellar.birth = tonumber(value) or 0
    end
})

rebirthSection2:Toggle({
    Title = "重生到指定的重生次数",
    Default = false,
    Callback = function(state)
        Interstellar.autobirth = state
        if Interstellar.autobirth then
            spawn(function()
                local player = game:GetService("Players").LocalPlayer
                local targetRebirths = Interstellar.birth
                while Interstellar.autobirth do
                    if player.leaderstats.Rebirths.Value >= targetRebirths then
                        Interstellar.autobirth = false
                        break
                    else
                        local success = pcall(function()
                            game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
                        end)
                        if not success then warn("重生请求失败") end
                    end
                    wait(0.1)
                end
            end)
        end
    end
})

local modifySection = G:Section({Title = "美化", Opened = true})

modifySection:Input({
    Title = "修改经验值",
    Placeholder = "输入数值",
    Callback = function(value)
        if value and value ~= "" and tonumber(value) then
            game:GetService("Players").LocalPlayer.exp.Value = tonumber(value)
        end
    end
})

modifySection:Input({
    Title = "修改等级",
    Placeholder = "输入数值",
    Callback = function(value)
        if value and value ~= "" and tonumber(value) then
            game:GetService("Players").LocalPlayer.level.Value = tonumber(value)
        end
    end
})

modifySection:Input({
    Title = "修改比赛数",
    Placeholder = "输入数值",
    Callback = function(value)
        if value and value ~= "" and tonumber(value) then
            game:GetService("Players").LocalPlayer.leaderstats.Races.Value = tonumber(value)
        end
    end
})

modifySection:Input({
    Title = "修改环数",
    Placeholder = "输入数值",
    Callback = function(value)
        if value and value ~= "" and tonumber(value) then
            game:GetService("Players").LocalPlayer.leaderstats.Hoops.Value = tonumber(value)
        end
    end
})

modifySection:Input({
    Title = "修改重生",
    Placeholder = "输入数值",
    Callback = function(value)
        if value and value ~= "" and tonumber(value) then
            game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value = tonumber(value)
        end
    end
})

modifySection:Input({
    Title = "修改步数",
    Placeholder = "输入数值",
    Callback = function(value)
        if value and value ~= "" and tonumber(value) then
            game:GetService("Players").LocalPlayer.leaderstats.Steps.Value = tonumber(value)
        end
    end
})

modifySection:Input({
    Title = "修改宝石",
    Placeholder = "输入数值",
    Callback = function(value)
        if value and value ~= "" and tonumber(value) then
            game:GetService("Players").LocalPlayer.Gems.Value = tonumber(value)
        end
    end
})

local petShopSection = H:Section({Title = "购买模式", Opened = true})

local petOptions = {"Swift Samurai", "Hyperblast", "Flaming Hedgehog", "Rainbow Steps", "Electro Golem"}
local petDisplayNames = {
    ["Swift Samurai"] = "斯威夫特武士",
    ["Hyperblast"] = "金色尾巴", 
    ["Flaming Hedgehog"] = "火焰刺猬",
    ["Rainbow Steps"] = "彩虹尾巴",
    ["Electro Golem"] = "电光雷宠-太空宠物"
}
local displayOptions = {}
for _, engName in ipairs(petOptions) do
    table.insert(displayOptions, engName .. "（" .. petDisplayNames[engName] .. "）")
end

local BuyPetShop = ""

petShopSection:Paragraph({
    Title = "关于直接购买宠物",
    Desc = "你得保证你有充足的宝石\n因为购买一个宠物就值0.4亿左右\n否则购买失败",
    ThumbnailSize = 200,
})

petShopSection:Dropdown({
    Title = "选择购买的宠物",
    Values = displayOptions,
    Value = "",
    Callback = function(Value)
        BuyPetShop = Value:match("^(.-)（")
    end
})

petShopSection:Button({
    Title = "购买",
    Callback = function()
        if not BuyPetShop then return end
        local pet = game:GetService("ReplicatedStorage").cPetShopFolder:FindFirstChild(BuyPetShop)
        if pet then
            game:GetService("ReplicatedStorage").cPetShopRemote:InvokeServer(pet)
        end
    end
})

petShopSection:Toggle({
    Title = "自动购买",
    Default = false,
    Callback = function(state)
        Interstellar.petshop = state
        if Interstellar.petshop and BuyPetShop then
            spawn(function()
                while Interstellar.petshop do
                    pcall(function()
                        local pet = game:GetService("ReplicatedStorage").cPetShopFolder:FindFirstChild(BuyPetShop)
                        if pet then
                            game:GetService("ReplicatedStorage").cPetShopRemote:InvokeServer(pet)
                        end
                    end)
                    wait(0.5)
                end
            end)
        end
    end
})

local evolveSection = H:Section({Title = "进化", Opened = true})

local function getRandomOwnedPet()
    local ownedPets = game.Players.LocalPlayer:FindFirstChild("ownedPets")
    if not ownedPets then return end
    local pets = ownedPets:GetChildren()
    return #pets > 0 and pets[math.random(#pets)] or nil
end

evolveSection:Button({
    Title = "进化一次",
    Callback = function()
        local randomPet = getRandomOwnedPet()
        if randomPet then
            game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer("evolvePet", randomPet.Name)
        end
    end
})

evolveSection:Toggle({
    Title = "自动进化",
    Default = false,
    Callback = function(state)
        Interstellar.evolvepet = state
        if Interstellar.evolvepet then
            spawn(function()
                while Interstellar.evolvepet do
                    pcall(function()
                        local randomPet = getRandomOwnedPet()
                        if randomPet then
                            game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer("evolvePet", randomPet.Name)
                        end
                    end)
                    wait(0.1)
                end
            end)
        end
    end
})

local infoSection = I:Section({Title = "卡宠重生次数", Opened = true})

infoSection:Paragraph({
    Title = "适合卡宠的重生次数",
    Desc = "末尾有个奇数9的都行\n有钱的买个无限等级挂机\n建议用经验球刷\n\n重生：9\n重生：19\n重生：29\n重生：39\n重生：49\n重生：59\n重生：69\n重生：79\n重生：89\n重生：99\n重生：109-199\n重生：209-299\n重生：309-399\n重生：409-599\n重生：609-699\n重生：709-799\n重生：809-899\n重生：909-999\n\n后续也就那样",
    ThumbnailSize = 190,
})

WindUI:Notify({
    Title = "塔菲",
    Content = "反挂机已开启",
    Duration = 3,
})

WindUI:Notify({
    Title = "塔菲",
    Content = "极速传奇",
    Duration = 3,
})

print("Anti Afk On")
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function() 
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame); 
    wait(1); 
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) 
end)

end