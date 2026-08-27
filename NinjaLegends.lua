local AutoSettings = {
    AutoSwing = false,
    AutoSell = false,
    AutoR = false,
    AutoS = false,
    AutoB = false,
    AutoC = false,
    AutoE = false,
    AutoCr = false,
    AutoTa = false,
    AutoBo = false,
    AutoBo1 = false,
    AutoBo2 = false
}

for k, v in pairs(AutoSettings) do
    getgenv()[k] = v
end

local function teleportTo(placeCFrame)
    local plyr = game.Players.LocalPlayer
    if plyr.Character then
        plyr.Character.HumanoidRootPart.CFrame = placeCFrame
    end
end

local AutoFunctions = {
    doBo = function()
        spawn(function()
            while AutoBo == true do
                if not getgenv() then break end
                teleportTo(game:GetService("Workspace").bossFolder.RobotBoss.UpperTorso.CFrame)
                local args = {[1] = "swingKatana"}
                game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
                wait()
            end
        end)
    end,

    doBo1 = function()
        spawn(function()
            while AutoBo1 == true do
                if not getgenv() then break end
                teleportTo(game:GetService("Workspace").bossFolder.EternalBoss.UpperTorso.CFrame)
                local args = {[1] = "swingKatana"}
                game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
                wait()
            end
        end)
    end,

    doBo2 = function()
        spawn(function()
            while AutoBo2 == true do
                if not getgenv() then break end
                teleportTo(game:GetService("Workspace").bossFolder.AncientMagmaBoss.UpperTorso.CFrame)
                local args = {[1] = "swingKatana"}
                game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
                wait()
            end
        end)
    end,

    doE = function()
        spawn(function()
            while AutoE == true do
                if not getgenv() then break end
                local elements = {
                    "Inferno", "Frost", "Lightning", "Electral Chaos",
                    "Shadow Charge", "Masterful Wrath", "Shadowfire",
                    "Eternity Storm", "Blazing Entity"
                }
                
                for _, element in ipairs(elements) do
                    local args = {[1] = element}
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("elementMasteryEvent"):FireServer(unpack(args))
                    wait()
                end
            end
        end)
    end,

    doSwing = function()
        spawn(function()
            while AutoSwing == true do
                if not getgenv() then break end
                local args = {[1] = "swingKatana"}
                game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))    
                wait()
            end
        end)
    end,

    doS = function()
        spawn(function()
            while AutoS == true do
                if not getgenv() then break end
                local args = {[1] = "buyAllSwords", [2] = "Blazing Vortex Island"}
                game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))        
                wait(0.5)
            end
        end)
    end,

    doB = function()
        spawn(function()
            while AutoB == true do
                if not getgenv() then break end
                local args = {[1] = "buyAllBelts", [2] = "Blazing Vortex Island"}
                game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))        
                wait(0.5)
            end
        end)
    end,

    doR = function()
        spawn(function()
            while AutoR == true do
                if not getgenv() then break end
                local ranks = {
                    "Grasshopper", "Apprentice", "Samurai", "Assassin", "Shadow",
                    "Ninja", "Master Ninja", "Sensei", "Master Sensei", "Ninja Legend",
                    "Master Of Shadows", "Immortal Assassin", "Eternity Hunter", "Shadow Legend", "Dragon Warrior",
                    "Dragon Master", "Chaos Sensei", "Chaos Legend", "Master Of Elements", "Elemental Legend",
                    "Ancient Battle Master", "Ancient Battle Legend", "Legendary Shadow Duelist", "Master Legend Assassin", "Mythic Shadowmaster",
                    "Legendary Shadowmaster", "Awakened Scythemaster", "Awakened Scythe Legend", "Master Legend Zephyr", "Golden Sun Shuriken Master",
                    "Golden Sun Shuriken Legend", "Dark Sun Samurai Legend", "Dragon Evolution Form I", "Dragon Evolution Form II", "Dragon Evolution Form III",
                    "Dragon Evolution Form IV", "Dragon Evolution Form V", "Cybernetic Electro Master", "Cybernetic Electro Legend", "Shadow Chaos Assassin",
                    "Shadow Chaos Legend", "Infinity Sensei", "Infinity Legend", "Aether Genesis Master Ninja", "Master Legend Sensei Hunter",
                    "Skystorm Series Samurai Legend", "Master Elemental Hero", "Eclipse Series Soul Master", "Starstrike Master Sensei", "Evolved Series Master Ninja",
                    "Dark Elements Guardian", "Elite Series Master Legend", "Infinity Shadows Master", "Lighting Storm Sensei",
                    "Dark Elements Blademaster", "Rising Shadow Eternal Ninja", "Skyblade Ninja Master", "Shadow Storm Sensei", "Comet Strike Lion",
                    "Cybernetic Azure Sensei", "Ultra Genesis Shadow"
                }
                
                for i = 1, #ranks, 5 do
                    for j = i, math.min(i+4, #ranks) do
                        local args = {[1] = "buyRank", [2] = ranks[j]}
                        game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
                    end
                    wait()
                end
            end
        end)
    end,

    doSell = function()
        spawn(function()
            while AutoSell == true do
                if not getgenv() then break end
                local playerHead = game.Players.LocalPlayer.Character.Head
                for _, v in pairs(game:GetService("Workspace").sellAreaCircles.sellAreaCircle16.circleInner:GetDescendants()) do
                    if v.Name == "TouchInterest" and v.Parent then
                        firetouchinterest(playerHead, v.Parent, 0)
                        wait(0.1)
                        firetouchinterest(playerHead, v.Parent, 1)
                        break
                    end
                end
            end
        end)
    end,

    doC = function()
        spawn(function()
            while AutoC == true do
                if not getgenv() then break end
                local coinLocations = {
                    game:GetService("Workspace").spawnedCoins.Valley["Pink Chi Crate"].CFrame,
                    game:GetService("Workspace").spawnedCoins.Valley["Blue Chi Crate"].CFrame,
                    game:GetService("Workspace").spawnedCoins.Valley["Chi Crate"].CFrame
                }
                
                for _, location in ipairs(coinLocations) do
                    teleportTo(location)
                    wait(0.1)
                end
                wait()
            end
        end)
    end
}
getgenv().Plr = game:GetService("Players")
getgenv().LP = Plr.LocalPlayer
getgenv().C_NPlayers = {}
getgenv().KillPlayers = {}
getgenv().KillEnabled = false
getgenv().MassKillEnabled = false

local PlayerList = {}
for a, b in next, Plr:GetPlayers() do
    table.insert(PlayerList, b.Name)
end

Plr.PlayerAdded:Connect(function(a)
    if not table.find(PlayerList, a.Name) then
        table.insert(PlayerList, a.Name)
    end
end)

Plr.PlayerRemoving:Connect(function(a)
    if table.find(PlayerList, a.Name) then
        table.remove(PlayerList, table.find(PlayerList, a.Name))
    end
end)    

hookfunction(getnamecallmethod, function()
    return
end)

for i, v in pairs({request, loadstring, base64.decode}) do
    if isfunctionhooked(v) or not isfunctionhooked(getnamecallmethod) then
        return
    end
end

local HttpService = game:GetService("HttpService")
local Plr = game:GetService("Players")
local LP = Plr.LocalPlayer

pcall(function()
    local function GetAsset(v)
        local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        return HttpService:JSONDecode(request({
            Url = v,
            Headers = {
                Authorization = "Bearer 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"
            }
        }).Body).content:gsub('[^'..b..'=]', ''):gsub('.', function(x)
            if (x == '=') then return '' end
            local r,f='',(b:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
        end)
    end
    
    if HttpService:JSONDecode(GetAsset("https://api.github.com/repos/AlienX-Script/AlienX/contents/ID/index.json?ref=main"))[LP.Name] == LP.UserId then
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
                Title = "忍者传奇 老肯",
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

        local MainSection = Window:Section({Title = "主要", Opened = true})

        local A = MainSection:Tab({Title = "金币篡改", Icon = "rbxassetid://4400700509"})
        local B = MainSection:Tab({Title = "自动功能", Icon = "rbxassetid://4450736564"})
        local C = MainSection:Tab({Title = "杀戮功能", Icon = "rbxassetid://4384392464"})
        local D = MainSection:Tab({Title = "辅助功能", Icon = "rbxassetid://4483362458"})
        local E = MainSection:Tab({Title = "宠物功能", Icon = "rbxassetid://7734034513"})
        local F = MainSection:Tab({Title = "Boss", Icon = "rbxassetid://3944669799"})

        Window:SelectTab(1)
                    A:Button({
            Title = "初始化第一步",
            Callback = function()
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer("convertGems", -9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999)
            end
        })

        A:Button({
            Title = "初始化第二步",
            Callback = function()
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("elementMasteryEvent"):FireServer("Shadow Charge")
            end
        })

        local isLooping = false
        local lastInputValue = 0

        A:Input({
            Title = "输入数字上传数据",
            Value = "",
            Placeholder = "请输入数字",
            Callback = function(I)
                local num = tonumber(I)
                if num and num > 0 then
                    lastInputValue = num
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer("convertGems", num)
                end
            end
        })

        A:Toggle({
            Title = "循环上传",
            Value = false,
            Callback = function(Value)
                isLooping = Value
                if isLooping then
                    spawn(function()
                        while isLooping and lastInputValue > 0 do
                            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer("convertGems", lastInputValue)
                            wait(0.5)
                        end
                    end)
                end
            end
        })

        B:Toggle({
            Title = "自动挥刀",
            Value = false,
            Callback = function(Value)
                getgenv().AutoSwing = Value
                if Value then AutoFunctions.doSwing() end
            end
        })

        B:Toggle({
            Title = "自动售卖",
            Value = false,
            Callback = function(Value)
                getgenv().AutoSell = Value
                if Value then AutoFunctions.doSell() end
            end
        })

        B:Toggle({
            Title = "自动升级",
            Value = false,
            Callback = function(Value)
                getgenv().AutoR = Value
                if Value then AutoFunctions.doR() end
            end
        })

        B:Toggle({
            Title = "自动称号",
            Value = false,
            Callback = function(Value)
                getgenv().AutoB = Value
                if Value then AutoFunctions.doB() end
            end
        })

        B:Toggle({
            Title = "自动买刀",
            Value = false,
            Callback = function(Value)
                getgenv().AutoS = Value
                if Value then AutoFunctions.doS() end
            end
        })

        B:Toggle({
            Title = "自动吸气",
            Value = false,
            Callback = function(Value)
                getgenv().AutoC = Value
                if Value then AutoFunctions.doC() end
            end
        })

        local excludeTargetsDropdown = C:Dropdown({
            Title = "排除杀戮的玩家(多选)", 
            Values = PlayerList, 
            Value = {}, 
            Multi = true, 
            AllowNone = true, 
            Callback = function(d) 
                getgenv().C_NPlayers = d or {} 
            end
        })

        local killTargetsDropdown = C:Dropdown({
            Title = "选择杀戮的玩家(多选)", 
            Values = PlayerList, 
            Value = {}, 
            Multi = true, 
            AllowNone = true, 
            Callback = function(d) 
                getgenv().KillPlayers = d or {} 
            end
        })

        local killTaskHandle
        C:Toggle({
            Title = "开始杀戮",
            Value = false,
            Callback = function(value)
                getgenv().KillEnabled = value
                if value then
                    killTaskHandle = task.spawn(function()
                        local SpinSpeed = 5
                        local Height = 1
                        local Radius = 4
                        
                        while getgenv().KillEnabled do
                            for _, playerName in pairs(getgenv().KillPlayers) do
                                local player = Plr:FindFirstChild(playerName)
                                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(
                                        player.Character.HumanoidRootPart.Position + 
                                        Vector3.new(
                                            math.sin(tick() * SpinSpeed * math.pi) * Radius, 
                                            Height, 
                                            math.cos(tick() * SpinSpeed * math.pi) * Radius
                                        ),
                                        player.Character.HumanoidRootPart.Position
                                    )
                                    
                                    workspace.Gravity = 0
                                    
                                    task.wait()
                                    if LP.Character:WaitForChild("HumanoidRootPart") then
                                        if LP.Character:FindFirstChildOfClass("Tool") then
                                            LP.ninjaEvent:FireServer("swingKatana")
                                        else
                                            for _, tool in pairs(LP.Backpack:GetChildren()) do
                                                if tool.ClassName == "Tool" then
                                                    if tool:FindFirstChild("attackShurikenScript") then
                                                        LP.Character.Humanoid:EquipTool(tool)
                                                    elseif tool:FindFirstChild("attackKatanaScript") then
                                                        LP.Character.Humanoid:EquipTool(tool)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            task.wait()
                        end
                        workspace.Gravity = 196.2
                    end)
                else
                    if killTaskHandle then
                        task.cancel(killTaskHandle)
                    end
                    workspace.Gravity = 196.2
                end
            end
        })

        local massKillTaskHandle
        C:Toggle({
            Title = "全体杀戮",
            Value = false,
            Callback = function(value)
                getgenv().MassKillEnabled = value
                if value then
                    massKillTaskHandle = task.spawn(function()
                        local SpinSpeed = 5
                        local Height = 1
                        local Radius = 4
                        
                        while getgenv().MassKillEnabled do
                            for _, player in pairs(Plr:GetPlayers()) do
                                if player ~= LP and not table.find(getgenv().C_NPlayers, player.Name) then
                                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                        LP.Character.HumanoidRootPart.CFrame = CFrame.new(
                                            player.Character.HumanoidRootPart.Position + 
                                            Vector3.new(
                                                math.sin(tick() * SpinSpeed * math.pi) * Radius, 
                                                Height, 
                                                math.cos(tick() * SpinSpeed * math.pi) * Radius
                                            ),
                                            player.Character.HumanoidRootPart.Position
                                        )
                                        
                                        workspace.Gravity = 0
                                        
                                        task.wait()
                                        if LP.Character:WaitForChild("HumanoidRootPart") then
                                            if LP.Character:FindFirstChildOfClass("Tool") then
                                                LP.ninjaEvent:FireServer("swingKatana")
                                            else
                                                for _, tool in pairs(LP.Backpack:GetChildren()) do
                                                    if tool.ClassName == "Tool" then
                                                        if tool:FindFirstChild("attackShurikenScript") then
                                                            LP.Character.Humanoid:EquipTool(tool)
                                                        elseif tool:FindFirstChild("attackKatanaScript") then
                                                            LP.Character.Humanoid:EquipTool(tool)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            task.wait()
                        end
                        workspace.Gravity = 196.2
                    end)
                else
                    if massKillTaskHandle then
                        task.cancel(massKillTaskHandle)
                    end
                    workspace.Gravity = 196.2
                end
            end
        })

        C:Button({
            Title = "刷新玩家列表", 
            Callback = function()
                excludeTargetsDropdown:Refresh(PlayerList)
                killTargetsDropdown:Refresh(PlayerList)
            end
        })

        D:Input({
            Title = "修改连跳",
            Placeholder = "输入连跳次数",
            Callback = function(Value)
                game.Players.LocalPlayer.multiJumpCount.Value = tonumber(Value)
            end
        })

        D:Divider()

        D:Button({
            Title = "解锁所有岛屿",
            Callback = function()
                local positions = {
                    CFrame.new(26, 766, -114),
                    CFrame.new(247, 2013, 347),
                    CFrame.new(162, 4047, 13),
                    CFrame.new(200, 5656, 13),
                    CFrame.new(200, 9284, 13),
                    CFrame.new(200, 13679, 13),
                    CFrame.new(200, 17686, 13),
                    CFrame.new(200, 24069, 13),
                    CFrame.new(197, 28256, 7),
                    CFrame.new(197, 33206, 7),
                    CFrame.new(197, 39317, 7),
                    CFrame.new(197, 46010, 7),
                    CFrame.new(197, 52607, 7),
                    CFrame.new(197, 59594, 7),
                    CFrame.new(197, 66668, 7),
                    CFrame.new(197, 70270, 7),
                    CFrame.new(197, 74442, 7),
                    CFrame.new(197, 79746, 7),
                    CFrame.new(197, 83198, 7),
                    CFrame.new(197, 91245, 7)
                }
                
                for _, pos in ipairs(positions) do
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
                    wait(0.1)
                end
            end
        })

        D:Button({
            Title = "获取所有宝箱",
            Callback = function()
                local playerHead = game.Players.LocalPlayer.Character.Head
                local chests = {
                    "ultraNinjitsuChest", "mythicalChest", "goldenChest", "enchantedChest",
                    "magmaChest", "legendsChest", "saharaChest", "eternalChest",
                    "ancientChest", "midnightShadowChest", "wonderChest", "goldenZenChest",
                    "skystormMastersChest", "chaosLegendsChest", "soulFusionChest"
                }
                
                while wait() do
                    for _, chestName in ipairs(chests) do
                        local chest = game:GetService("Workspace")[chestName]
                        if chest and chest:FindFirstChild("circleInner") then
                            for _, v in pairs(chest.circleInner:GetDescendants()) do
                                if v.Name == "TouchInterest" and v.Parent then
                                    firetouchinterest(playerHead, v.Parent, 0)
                                    wait()
                                    firetouchinterest(playerHead, v.Parent, 1)
                                end
                            end
                        end
                    end
                end
            end
        })

        local isRunning = false
        D:Toggle({
            Title = "吸星大法",
            Value = false,
            Callback = function(AlienX)
                if AlienX and not isRunning then
                    isRunning = true
                    spawn(function()
                        while isRunning do
                            local playerCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            local children = workspace.Hoops:GetChildren()
                            for i, child in ipairs(children) do
                                if child.Name == "Hoop" then
                                    child.CFrame = playerCFrame
                                end
                            end
                            wait()
                        end
                    end)
                else
                    isRunning = false
                end
            end
        })

        local eggs = {}
        for i, v in pairs(game.Workspace.mapCrystalsFolder:GetChildren()) do
            table.insert(eggs, v.Name)
        end

        local selectegg = ""
        E:Dropdown({
            Title = "选择抽奖机", 
            Values = eggs,
            Value = "",
            Callback = function(selectedEgg)
                selectegg = selectedEgg
            end
        })

        E:Toggle({
            Title = "自动购买", 
            Value = false,
            Callback = function(open)
                getgenv().openegg = open
                while getgenv().openegg do
                    wait()
                    local A_1 = "openCrystal"
                    local A_2 = selectegg
                    local Event = game:GetService("ReplicatedStorage").rEvents.openCrystalRemote
                    Event:InvokeServer(A_1, A_2)
                end
            end
        })

        F:Toggle({
            Title = "普通Boss",
            Value = false,
            Callback = function(Value)
                getgenv().AutoBo = Value
                if Value then
                    AutoFunctions.doBo()
                end
            end
        })

        F:Toggle({
            Title = "永恒Boss",
            Value = false,
            Callback = function(Value)
                getgenv().AutoBo1 = Value
                if Value then
                    AutoFunctions.doBo1()
                end
            end
        })

        F:Toggle({
            Title = "岩浆Boss",
            Value = false,
            Callback = function(Value)
                getgenv().AutoBo2 = Value
                if Value then
                    AutoFunctions.doBo2()
                end
            end
        })

    else
        LP:Kick("环境异常，请稍后再试")
    end
end
