loadstring(game:HttpGet("https://pastefy.app/pDhoQmem/raw"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RepStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local GlobalCache = {Enabled = false, Size = 50, Data = {}, HitCount = 0}

local EasterEgg = {
    Enabled = false, Duration = 10, Type = "not.cc",
    Container = nil, ActiveAnimations = {}, CachedElements = {}, CacheSize = 200
}

local AuthorMessages = {
    "吃饭了吗？", "记得按时吃饭哦~", "今天也要开心呀", "照顾好自己", "多喝热水",
    "别熬夜太晚啦", "你是最棒的！", "加油，你可以的", "记得休息眼睛", "天气冷了多穿点",
    "今天过得怎么样？", "想你了~", "要对自己好一点", "记得吃早餐", "你真的很优秀",
    "累了就歇一歇", "保持微笑", "相信自己", "你值得被爱", "不要给自己太大压力",
    "每一天都是新的开始", "你做得很好", "记得运动一下", "心情要好哦", "我在陪着你",
    "要健康快乐地生活", "你是独一无二的", "困难总会过去的", "坚持就是胜利", "记得吃水果",
    "晚上早点睡", "不要太累了", "你真的很厉害", "保持好心情", "一切都会好起来的",
    "记得喝水", "你是最可爱的", "今天也要加油", "相信自己能做到", "你值得最好的",
    "累了就睡觉", "不要太在意别人的眼光", "做最真实的自己", "你的努力我都看到了",
    "记得给爸妈打电话", "珍惜身边的人", "生活很美好", "你是最特别的存在", "保持初心",
    "未来可期", "你比想象中更强大", "每一个今天都是礼物", "学会爱自己", "你很勇敢",
    "不要放弃梦想", "你让世界更美好", "记得深呼吸", "放松一下吧", "你是最棒的崽",
    "保持好奇心", "享受当下的美好", "你值得被温柔以待", "记得笑一笑", "你是最闪亮的星",
    "做自己喜欢的事", "不要被烦恼困扰", "你是最温暖的阳光", "记得感恩", "你是最甜的糖",
    "保持正能量", "你是最美的风景", "记得拥抱生活", "你是最可爱的小猫咪", "要幸福哦",
    "记得看星星", "你是最温柔的梦", "保持热爱", "你是最珍贵的宝藏", "记得听音乐",
    "你是最动听的旋律", "要一直开心下去", "记得散步", "你是最清新的风", "保持希望",
    "你是最明亮的月光", "记得写日记", "你是最温暖的家", "要勇敢追梦", "记得看日出",
    "你是最美丽的彩虹", "保持善良", "你是最治愈的良药", "记得和朋友聊天", "你是最贴心的存在",
    "要快乐每一天", "记得给自己买好吃的", "你是最幸福的模样", "保持自信", "你是最完美的你"
}

local function PreCacheHeartShape()
    if #EasterEgg.CachedElements > 0 then return end
    local heartPattern = {}
    for i = 1, 100 do
        local t = (i / 100) * math.pi * 2
        local x = 16 * math.sin(t)^3
        local y = -(13 * math.cos(t) - 5 * math.cos(2*t) - 2 * math.cos(3*t) - math.cos(4*t))
        table.insert(heartPattern, {x = x * 0.03 + 0.5, y = y * 0.03 + 0.4})
    end
    EasterEgg.CachedElements.HeartPattern = heartPattern
end
PreCacheHeartShape()

local function CreateNotCCFallingAnimation(duration)
    if EasterEgg.Container then EasterEgg.Container:Destroy() end
    local container = Instance.new("ScreenGui")
    container.Name = "NotCCEasterEgg"
    container.Parent = CoreGui
    container.DisplayOrder = 9998
    container.ResetOnSpawn = false
    EasterEgg.Container = container
    local elements = {}
    for i = 1, 60 do
        local label = Instance.new("TextLabel")
        label.Name = "NotCC_" .. i
        label.Text = "not.cc"
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(255, 182, 193)
        label.TextStrokeColor3 = Color3.fromRGB(255, 105, 180)
        label.TextStrokeTransparency = 0.5
        label.TextSize = math.random(14, 28)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 100, 0, 30)
        label.Position = UDim2.new(math.random(), 0, -0.1, 0)
        label.Rotation = math.random(-30, 30)
        label.Parent = container
        table.insert(elements, {
            label = label,
            speed = math.random(30, 80) / 1000,
            xOffset = math.random() * 0.02 - 0.01,
            swaySpeed = math.random(1, 3),
            swayAmp = math.random(10, 40),
            baseX = label.Position.X.Scale,
        })
    end
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        if not container or not container.Parent then
            if conn then conn:Disconnect() end
            return
        end
        for _, e in ipairs(elements) do
            if e.label and e.label.Parent then
                local currentY = e.label.Position.Y.Scale
                local newY = currentY + e.speed * dt * 60
                local sway = math.sin(tick() * e.swaySpeed) * e.swayAmp
                e.label.Position = UDim2.new(e.baseX + e.xOffset, sway, newY, 0)
                e.label.Rotation = e.label.Rotation + dt * 10
                e.label.TextTransparency = math.min(1, math.max(0, (newY - 0.8) * 5))
                if newY > 1.1 then
                    e.label.Position = UDim2.new(math.random(), 0, -0.1, 0)
                    e.baseX = e.label.Position.X.Scale
                    e.label.TextTransparency = 0
                end
            end
        end
    end)
    task.delay(2, function()
        if not container or not container.Parent then return end
        for _, pos in ipairs(EasterEgg.CachedElements.HeartPattern or {}) do
            local heartLabel = Instance.new("TextLabel")
            heartLabel.Text = "❤"
            heartLabel.Font = Enum.Font.GothamBold
            heartLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
            heartLabel.TextSize = math.random(16, 32)
            heartLabel.BackgroundTransparency = 1
            heartLabel.Size = UDim2.new(0, 40, 0, 40)
            heartLabel.Position = UDim2.new(pos.x, 0, pos.y, 0)
            heartLabel.Parent = container
            task.spawn(function()
                local startTime = tick()
                while heartLabel and heartLabel.Parent do
                    local elapsed = tick() - startTime
                    if elapsed > 3 then
                        heartLabel:Destroy()
                        break
                    end
                    local pulse = 0.7 + math.sin(elapsed * 4) * 0.3
                    heartLabel.TextTransparency = 1 - pulse
                    heartLabel.TextSize = 20 + math.sin(elapsed * 3) * 10
                    task.wait(0.05)
                end
            end)
        end
    end)
    task.delay(duration, function()
        if container then container:Destroy() end
        if conn then conn:Disconnect() end
        EasterEgg.Container = nil
    end)
end

local function CreateAuthorMessageAnimation(duration)
    if EasterEgg.Container then EasterEgg.Container:Destroy() end
    local container = Instance.new("ScreenGui")
    container.Name = "AuthorEasterEgg"
    container.Parent = CoreGui
    container.DisplayOrder = 9998
    container.ResetOnSpawn = false
    EasterEgg.Container = container
    local messages = {}
    local heartPattern = EasterEgg.CachedElements.HeartPattern or {}
    for i = 1, math.min(#AuthorMessages, #heartPattern) do
        table.insert(messages, {
            text = AuthorMessages[i],
            pos = heartPattern[i],
            delay = i * 0.03,
        })
    end
    local labels = {}
    for _, msg in ipairs(messages) do
        local label = Instance.new("TextLabel")
        label.Text = msg.text
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(255, 182, 193)
        label.TextStrokeColor3 = Color3.fromRGB(255, 105, 180)
        label.TextStrokeTransparency = 0.6
        label.TextSize = 12
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 0, 20)
        label.Position = UDim2.new(msg.pos.x, 0, msg.pos.y, 0)
        label.TextTransparency = 1
        label.Parent = container
        table.insert(labels, {label = label, delay = msg.delay, basePos = msg.pos})
    end
    local startTime = tick()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not container or not container.Parent then
            if conn then conn:Disconnect() end
            return
        end
        local elapsed = tick() - startTime
        for _, item in ipairs(labels) do
            if item.label and item.label.Parent then
                local itemElapsed = elapsed - item.delay
                if itemElapsed > 0 then
                    local fadeIn = math.min(1, itemElapsed * 3)
                    local pulse = 0.8 + math.sin(tick() * 2 + item.delay * 10) * 0.2
                    item.label.TextTransparency = 1 - fadeIn * pulse
                    local floatY = math.sin(tick() * 1.5 + item.delay * 20) * 0.01
                    item.label.Position = UDim2.new(item.basePos.x, 0, item.basePos.y + floatY, 0)
                end
            end
        end
    end)
    task.delay(duration, function()
        if container then container:Destroy() end
        if conn then conn:Disconnect() end
        EasterEgg.Container = nil
    end)
end

local UICache = {
    Enabled = false,
    PreloadDelay = 0.05,
    FadeInSpeed = 0.08,
    CachedPages = {},
    IsPreloading = false,
}

local function PreloadPageElements(page)
    if not page or UICache.CachedPages[page] then return end
    UICache.CachedPages[page] = true
    local pageFrame = page.Items and page.Items["Page"]
    if pageFrame and pageFrame.Instance then
        local wasVisible = pageFrame.Instance.Visible
        local oldParent = pageFrame.Instance.Parent
        pageFrame.Instance.Parent = CoreGui
        pageFrame.Instance.Visible = true
        RunService.RenderStepped:Wait()
        RunService.RenderStepped:Wait()
        pageFrame.Instance.Visible = wasVisible
        pageFrame.Instance.Parent = oldParent
    end
end

local function FadeInElements(parent, speed)
    speed = speed or UICache.FadeInSpeed
    local descendants = parent:GetDescendants()
    table.insert(descendants, parent)
    for _, obj in ipairs(descendants) do
        if obj:IsA("GuiObject") then
            obj.BackgroundTransparency = 1
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                obj.TextTransparency = 1
            end
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                obj.ImageTransparency = 1
            end
        end
    end
    task.spawn(function()
        local alpha = 0
        while alpha < 1 do
            alpha = math.min(1, alpha + speed)
            for _, obj in ipairs(descendants) do
                if obj and obj.Parent then
                    if obj:IsA("GuiObject") then
                        local targetTrans = 0
                        if obj:GetAttribute("OriginalTransparency") then
                            targetTrans = obj:GetAttribute("OriginalTransparency")
                        end
                        obj.BackgroundTransparency = targetTrans + (1 - alpha) * (1 - targetTrans)
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                            obj.TextTransparency = (1 - alpha)
                        end
                        if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                            obj.ImageTransparency = (1 - alpha) * 0.5
                        end
                    end
                end
            end
            task.wait(0.016)
        end
        for _, obj in ipairs(descendants) do
            if obj and obj.Parent then
                if obj:IsA("GuiObject") then
                    if obj:GetAttribute("OriginalTransparency") then
                        obj.BackgroundTransparency = obj:GetAttribute("OriginalTransparency")
                    end
                end
            end
        end
    end)
end

local GN_S = RepStorage.Events.GNX_S
local ZF_H = RepStorage.Events.ZFKLF__H
local GN_R = RepStorage.Events.GNX_R

local DoTweak_fn = nil
task.defer(function()
    for _, v in getgc(true) do
        if type(v) == "function" then
            local info = debug.getinfo(v)
            if info and info.name == "DoTweak" and info.numparams == 11 then
                DoTweak_fn = v; break
            end
        end
    end
end)

local RB_State, RF_State, AutoReload, DownCheck = false, false, false, false
local Debug_Rays, TargetMode, HitSoundSelection = false, "Near", "None"
local Origin_Radius, Hit_Radius = 25.00, 32.00
local Origin_Scans, Hit_Scans = 36, 36
local ScanRate = 20
local Last_Shot, Valid_Pair, Locked_Path = 0, nil, nil
local WB = {LastScan=0, Cached=false, Toggle=false, Threshold=3, Round=0}
local NoFallEnabled = false

local RB_LO = {
    Enabled = true, LongDistThreshold = 100, MaxDistThreshold = 1200,
    DynamicRadiusScale = true, RadiusScaleFactor = 0.25,
    MinRadiusClamp = 5, MaxRadiusClamp = 50, ExtraScanCount = 32,
    TargetHeightOffset = true, HeightOffsetAmount = 3.5,
    DistCompensation = true, CompensationFactor = 0.035,
    BulletDropComp = true, DropFactor = 0.012,
    VelocityEstimate = 1100, LastTargetDist = 0,
    CachedGunConfig = nil, PredictionEnabled = true, PredictionFactor = 0.25,
    DistanceTiers = {Near = 150, Mid = 400, Far = 700, Extreme = 1000},
}

local RB_UltraCache = {
    TargetPosHistory = {}, MaxHistorySize = 30,
    VelocityCache = {}, VelocitySmoothFactor = 0.7,
    ScanOffsetCache_Algo1 = {}, ScanOffsetCache_Algo2 = {},
    ScanCacheValid = false, LastScanParams = nil,
    WallbangCache = {}, WallbangCacheSize = 50, WallbangHitCount = 0,
    TargetPartCache = {}, TargetPartCacheTime = 0, TargetPartRefreshRate = 0.5,
    AllGunConfigs = {}, DistanceCache = {}, DistanceCacheHitCount = 0,
}

local function GetSmoothedVelocity(targetPart)
    if not targetPart then return Vector3.zero end
    local key = targetPart
    local rawVel = targetPart.AssemblyLinearVelocity
    local cached = RB_UltraCache.VelocityCache[key]
    if cached then
        return cached.Velocity * RB_UltraCache.VelocitySmoothFactor + rawVel * (1 - RB_UltraCache.VelocitySmoothFactor)
    else
        RB_UltraCache.VelocityCache[key] = {Velocity = rawVel, LastUpdate = tick()}
        return rawVel
    end
end

local function UpdateVelocityCache()
    local now = tick()
    for key, data in pairs(RB_UltraCache.VelocityCache) do
        if now - data.LastUpdate > 0.5 then
            if key and key.Parent then
                data.Velocity = key.AssemblyLinearVelocity
                data.LastUpdate = now
            else
                RB_UltraCache.VelocityCache[key] = nil
            end
        end
    end
end

local function RecordTargetPosition(target, position)
    if not target then return end
    local history = RB_UltraCache.TargetPosHistory[target]
    if not history then
        history = {}
        RB_UltraCache.TargetPosHistory[target] = history
    end
    table.insert(history, {Pos = position, Time = tick()})
    if #history > RB_UltraCache.MaxHistorySize then
        table.remove(history, 1)
    end
end

local function PredictFromHistory(target, flightTime)
    local history = RB_UltraCache.TargetPosHistory[target]
    if not history or #history < 3 then return nil end
    local now = tick()
    local recent = {}
    for i = #history, math.max(1, #history - 5), -1 do
        local entry = history[i]
        if now - entry.Time < 1.0 then
            table.insert(recent, entry)
        end
    end
    if #recent < 2 then return nil end
    local oldest = recent[1]
    local newest = recent[#recent]
    local dt = newest.Time - oldest.Time
    if dt < 0.001 then return nil end
    local vel = (newest.Pos - oldest.Pos) / dt
    return newest.Pos + vel * flightTime
end

local function GetCachedTargetPart(character)
    local now = tick()
    if now - RB_UltraCache.TargetPartCacheTime < RB_UltraCache.TargetPartRefreshRate then
        local cached = RB_UltraCache.TargetPartCache[character]
        if cached and cached.Part and cached.Part.Parent then
            return cached.Part
        end
    end
    RB_UltraCache.TargetPartCacheTime = now
    local head = character:FindFirstChild("Head")
    local part = head or character:FindFirstChild("HumanoidRootPart")
    if part then
        RB_UltraCache.TargetPartCache[character] = {Part = part, Time = now}
    end
    return part
end

local function GetCachedDistance(posA, posB)
    local key = tostring(posA) .. tostring(posB)
    local cached = RB_UltraCache.DistanceCache[key]
    if cached and (tick() - cached.Time < 0.05) then
        RB_UltraCache.DistanceCacheHitCount = RB_UltraCache.DistanceCacheHitCount + 1
        return cached.Distance
    end
    local dist = (posA - posB).Magnitude
    RB_UltraCache.DistanceCache[key] = {Distance = dist, Time = tick()}
    local count = 0
    for _ in pairs(RB_UltraCache.DistanceCache) do count = count + 1 end
    if count > 100 then
        RB_UltraCache.DistanceCache = {}
    end
    return dist
end

local function CachedWallbang(origin, hit, distance)
    local key = math.floor(origin.X*10) .. math.floor(origin.Y*10) .. math.floor(origin.Z*10) ..
                 math.floor(hit.X*10) .. math.floor(hit.Y*10) .. math.floor(hit.Z*10)
    local cached = RB_UltraCache.WallbangCache[key]
    if cached and (tick() - cached.Time < 0.15) then
        RB_UltraCache.WallbangHitCount = RB_UltraCache.WallbangHitCount + 1
        return cached.Result
    end
    local result = CheckWallbang(origin, hit, distance)
    RB_UltraCache.WallbangCache[key] = {Result = result, Time = tick()}
    local count = 0
    for _ in pairs(RB_UltraCache.WallbangCache) do count = count + 1 end
    if count > RB_UltraCache.WallbangCacheSize then
        local oldest = nil
        local oldestTime = math.huge
        for k, v in pairs(RB_UltraCache.WallbangCache) do
            if v.Time < oldestTime then
                oldestTime = v.Time
                oldest = k
            end
        end
        if oldest then RB_UltraCache.WallbangCache[oldest] = nil end
    end
    return result
end

task.spawn(function()
    while true do
        task.wait(5)
        local now = tick()
        for key, data in pairs(RB_UltraCache.VelocityCache) do
            if not key or not key.Parent or (now - data.LastUpdate > 3) then
                RB_UltraCache.VelocityCache[key] = nil
            end
        end
        for target, history in pairs(RB_UltraCache.TargetPosHistory) do
            if not target or not target.Character then
                RB_UltraCache.TargetPosHistory[target] = nil
            else
                while #history > 0 and (now - history[1].Time > 3) do
                    table.remove(history, 1)
                end
            end
        end
        for key, data in pairs(RB_UltraCache.WallbangCache) do
            if now - data.Time > 2 then
                RB_UltraCache.WallbangCache[key] = nil
            end
        end
        for key, data in pairs(RB_UltraCache.DistanceCache) do
            if now - data.Time > 1 then
                RB_UltraCache.DistanceCache[key] = nil
            end
        end
        for char, data in pairs(RB_UltraCache.TargetPartCache) do
            if not char or not char.Parent then
                RB_UltraCache.TargetPartCache[char] = nil
            end
        end
    end
end)

local NR = {Enabled=false, Conns={}, OrigVals={}, Cache={}, RecoilVal=0}
local WV = {
    LightingModeEnabled=false, LightingMode="ShadowMap",
    WorldTimeEnabled=false, WorldTime=12,
    AmbientEnabled=false, AmbientColor=Color3.fromRGB(255,255,255), OutdoorAmbientColor=Color3.fromRGB(255,255,255),
    AtmosphereEnabled=false, AtmoColor=Color3.fromRGB(255,255,255), AtmoDecay=Color3.fromRGB(120,120,120),
    AtmoHaze=1, AtmoGlare=10, AtmoDensity=0.35, AtmoOffset=0,
    WeatherEnabled=false, WeatherType="Rain", WeatherColor=Color3.fromRGB(255,255,255), WeatherRate=600,
    SkyboxEnabled=false, SkyboxType="Black Storm",
    BGSoundEnabled=false, BGSoundTrack="Night", BGSoundVolume=25,
}
local WV_Lit = game:GetService("Lighting")
local WV_Atmo = WV_Lit:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", WV_Lit)
local WV_Sky = WV_Lit:FindFirstChildOfClass("Sky") or Instance.new("Sky", WV_Lit)
local WV_OrigSky = {Bk=WV_Sky.SkyboxBk,Dn=WV_Sky.SkyboxDn,Ft=WV_Sky.SkyboxFt,Lf=WV_Sky.SkyboxLf,Rt=WV_Sky.SkyboxRt,Up=WV_Sky.SkyboxUp}
local WV_Skyboxes = {
    ["Stormy"]={Up="18703232671",Bk="18703245834",Lf="18703237556",Dn="18703243349",Ft="18703240532",Rt="18703235430"},
    ["Blue Space"]={Up="15536117282",Bk="15536110634",Lf="15536114370",Dn="15536112543",Ft="15536116141",Rt="15536118762"},
    ["Pink"]={Up="12216108877",Bk="12216109205",Lf="12216110170",Dn="12216109875",Ft="12216109489",Rt="12216110471"},
    ["Black Storm"]={Up="15502511911",Bk="15502511288",Lf="15502507918",Dn="15502508460",Ft="15502510289",Rt="15502509398"},
    ["Realistic"]={Up="653719321",Bk="653719502",Lf="653719190",Dn="653718790",Ft="653719067",Rt="653718931"},
}
local WV_Sounds = {
    ["Windy Winter"]="rbxassetid://6046340391", ["Light Rain"]="rbxassetid://18862087062",
    ["Thunderstorm"]="rbxassetid://4305545740", ["Night"]="rbxassetid://179507208", ["Day"]="rbxassetid://6189453706",
}
local WV_BGSound = Instance.new("Sound", CoreGui); WV_BGSound.Looped=true
local WV_WeatherPart = Instance.new("Part")
WV_WeatherPart.Size=Vector3.new(40,40,85); WV_WeatherPart.Anchored=true
WV_WeatherPart.CanCollide=false; WV_WeatherPart.Transparency=1
local WV_Emitter = Instance.new("ParticleEmitter", WV_WeatherPart)
WV_Emitter.EmissionDirection=Enum.NormalId.Bottom
WV_Emitter.Orientation=Enum.ParticleOrientation.FacingCameraWorldUp

local SA = {
    Enabled=false, HitChance=100, WallCheck=true,
    TargetPart="Head", IsRandom=false,
    RandomParts={"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"},
    RandomIdx=1, RandomTimer=0,
    VisualizeEvent=nil, DamageEvent=nil,
    FOV_Visible=false, FOV_Radius=100, FOV_Sides=16,
    FOV_Color=Color3.fromRGB(255,0,0), FOV_PositionMode="Center",
    FOV_SpinEnabled=false, FOV_SpinSpeed=50,
    FOV_Rotation=0,
}

local SilkscreenFont = Font.new("rbxassetid://12187371840")
local CONFIG = {
    Rate_Active = 1/12, Rate_Idle = 1, ContentRate = 1/14,
    StrokeThickness = 0.8,
    DistOffset = Vector3.new(0, -5.5, 0),
    NameOffset = Vector3.new(0, 5, 0),
}

local NametagEnabled, DistanceEnabled, HealthEnabled = false, false, false
local LastVisualUpdate, LastContentUpdate = 0, 0
local InfStaminaEnabled, InfStaminaConnection = false, nil
local TR = {Enabled=false, Size=1, Color=Color3.fromRGB(255,255,255), Alpha=0}
local HitLogEnabled = false

local HeadMode, HandsModSelection = nil, nil
local OriginalNeckC0, OriginalNeckC1 = nil, nil
local HeadYaw, HeadRotSpeed, HeadYawTime = 0, 30, 0
local HeadCustomYaw = 0

local Invis_Enabled, Invis_Track, Invis_SavedCF = false, nil, nil
local Invis_Anim = Instance.new("Animation")
Invis_Anim.AnimationId = "rbxassetid://282574440"

local DS = {
    Enabled=false, Visualize=true, TPRate=60,
    X=8.5, Y=3, Z=8.5,
    LastTPTime=0, LastFFlagTime=0,
    CurrentOffset=Vector3.zero, Y_Toggle=false,
    AppliedOffset=Vector3.zero,
    Model=nil,
}

local LF = {
    Enabled=false, SpinSpeed=100, TimePosRatio=0.5,
    Track1=nil, Track2=nil, Angle=0,
    Anim1=Instance.new("Animation"),
    Anim2=Instance.new("Animation"),
}
LF.Anim1.AnimationId = "rbxassetid://215384594"
LF.Anim2.AnimationId = "rbxassetid://68339848"

local SafeChamsEnabled, SafeChamsLoop = false, nil
local SC = {APM_Enabled=false, APM_Loop=nil, AUS_Enabled=false, AUS_Loop=nil}

DS.Model = Instance.new("Model")
DS.Model.Name = "FakePosVisual"
do
    local outer = Instance.new("Part")
    outer.Name, outer.Shape = "Outer", Enum.PartType.Ball
    outer.Size = Vector3.new(1.5, 1.5, 1.5)
    outer.Color = Color3.fromRGB(150, 150, 150)
    outer.Transparency = 0.6
    outer.Material = Enum.Material.SmoothPlastic
    outer.Anchored = true
    outer.CanCollide, outer.CanQuery, outer.CanTouch = false, false, false
    outer.Parent = DS.Model
    local inner = Instance.new("Part")
    inner.Name, inner.Shape = "Inner", Enum.PartType.Ball
    inner.Size = Vector3.new(0.6, 0.6, 0.6)
    inner.Color = Color3.fromRGB(0, 255, 0)
    inner.Transparency = 0
    inner.Material = Enum.Material.Neon
    inner.Anchored = true
    inner.CanCollide, inner.CanQuery, inner.CanTouch = false, false, false
    inner.CFrame = outer.CFrame
    inner.Parent = DS.Model
    local weld = Instance.new("WeldConstraint")
    weld.Part0, weld.Part1, weld.Parent = outer, inner, outer
    DS.Model.PrimaryPart = outer
    local hl = Instance.new("Highlight")
    hl.FillTransparency = 1
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineTransparency = 0.2
    hl.Parent = DS.Model
end

local FF_S = {BodyEnabled=false, ToolEnabled=false, Color=Color3.fromRGB(255,255,255), LastSkin=0, BodyProps={}, ToolProps={}}
local TargetList, WhiteList = {}, {}

local HitSounds = {
    ["Skeet"] = "rbxassetid://5633695679",
    ["Neverlose"] = "rbxassetid://8726881116",
    ["Gamesense"] = "rbxassetid://4817809188",
}

local SpeedState, JumpState, SpeedValue, JumpValue = false, false, 33.5, 73
local CurrentHum = nil

local function NR_CacheWeapons()
    NR.Cache = {}
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "EquipTime") then
            table.insert(NR.Cache, v)
            if not NR.OrigVals[v] then
                NR.OrigVals[v] = {
                    Recoil=v.Recoil, CameraRecoilingEnabled=v.CameraRecoilingEnabled,
                    AngleX_Min=v.AngleX_Min, AngleX_Max=v.AngleX_Max,
                    AngleY_Min=v.AngleY_Min, AngleY_Max=v.AngleY_Max,
                    AngleZ_Min=v.AngleZ_Min, AngleZ_Max=v.AngleZ_Max,
                    Spread=v.Spread
                }
            end
        end
    end
end
local function NR_Apply()
    for _, w in ipairs(NR.Cache) do
        w.Recoil=NR.RecoilVal; w.CameraRecoilingEnabled=false
        w.AngleX_Min=0; w.AngleX_Max=0
        w.AngleY_Min=0; w.AngleY_Max=0
        w.AngleZ_Min=0; w.AngleZ_Max=0
        w.Spread=0
    end
end
local function NR_Reset()
    for w, val in pairs(NR.OrigVals) do
        w.Recoil=val.Recoil; w.CameraRecoilingEnabled=val.CameraRecoilingEnabled
        w.AngleX_Min=val.AngleX_Min; w.AngleX_Max=val.AngleX_Max
        w.AngleY_Min=val.AngleY_Min; w.AngleY_Max=val.AngleY_Max
        w.AngleZ_Min=val.AngleZ_Min; w.AngleZ_Max=val.AngleZ_Max
        w.Spread=val.Spread
    end
end
local function NR_OnChar(char)
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Tool") then task.delay(0.1, function() NR_CacheWeapons(); NR_Apply() end) end
    end
    table.insert(NR.Conns, char.ChildAdded:Connect(function(c)
        if c:IsA("Tool") then task.delay(0.1, function() NR_CacheWeapons(); NR_Apply() end) end
    end))
    local hum = char:WaitForChild("Humanoid", 2)
    if hum then
        table.insert(NR.Conns, hum.Died:Connect(function()
            if NR.Enabled then task.wait(1.5); NR_CacheWeapons(); NR_Apply() end
        end))
    end
end
local function NR_Enable()
    if NR.Enabled then return end; NR.Enabled = true
    NR_CacheWeapons(); NR_Apply()
    table.insert(NR.Conns, LocalPlayer.CharacterAdded:Connect(NR_OnChar))
    if LocalPlayer.Character then NR_OnChar(LocalPlayer.Character) end
end
local function NR_Disable()
    if not NR.Enabled then return end; NR.Enabled = false
    NR_Reset()
    for _, c in ipairs(NR.Conns) do c:Disconnect() end; NR.Conns = {}
end

local CL = {
    Enabled=false, DownCheck=false, TargetOnly=false, AutoPrediction=false,
    FOV=170, Power=1, Shake=0.2, Delay=0.1,
    TargetParts={"Torso","Left Arm","Right Arm","Left Leg","Right Leg"},
    CurrentTarget=nil, LockedPart=nil,
    LastSwitchTime=0, ScanTimer=0,
    CachedTool=nil, CachedVel=1100,
}

local MA = {
    Enabled=false, DownCheck=false, TargetOnly=false,
    ShowAnim=true, Distance=20,
    TargetPart="Random", LastHit=0, Loop=nil,
    Parts={"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"},
    Remote1=RepStorage:WaitForChild("Events"):WaitForChild("XMHH.2"),
    Remote2=RepStorage:WaitForChild("Events"):WaitForChild("XMHH2.2"),
}

local AC = {
    NeckC0 = CFrame.new(0, 0.4, 0.3),
    NeckC1 = CFrame.new(0, -0.1, 0.4) * CFrame.Angles(math.rad(90), math.rad(-180), 0),
    LShoulder = CFrame.new(-1, 0.5, 0, 0.020794034, -7.74860382e-07, -0.999783635, -0.98459357, 0.173654854, -0.0204781592, 0.173617214, 0.984806538, 0.00361025333),
    RShoulder = CFrame.new(1, 0.5, 0, 0.020793736, 1.07288361e-06, 0.999783933, 0.984594166, 0.173652649, -0.0204781592, -0.173615277, 0.984807134, 0.00360971689),
    Mag6D = CFrame.new(0.00922322646, 0.729015231, -1.10657895, 0.999783754, -6.51925802e-09, -0.0207949243, -0.0204789862, 0.173652411, -0.984594107, 0.00361109618, 0.984807014, 0.17361486),
    Tool6D = CFrame.new(0.00922359806, 0.729012489, -1.10657847, 0.999783754, -2.79396772e-09, -0.0207949281, -0.0204789862, 0.173653483, -0.984593868, 0.00361111294, 0.984806776, 0.173615932),
    AntiDown = Vector3.new(0.006237113382667303, -6, -0.18136750161647797),
    OpenHands = Vector3.new(0.006237113382667303, 6, 0.18136750161647797),
    HandsUp1 = Vector3.new(-4237.62255859375, 9848.9267578125, -2292.4501953125),
    HandsUp2 = Vector3.new(-4264.8974609375, 0.9520299434661865, -556.17333984375),
}

local MC = {AntiShift=false, ShiftDelay=0.05, SmoothCam=false, LerpSpeed=6, SmoothPos=nil}
local AMB = {Enabled=false, Color=Color3.fromRGB(190, 220, 255), Density=0.45, Brightness=0.15, Gui=nil}
local CAM_FOV = nil
local FPS_Lock = {Enabled=false, TargetFPS=120, QualityLevel=3, OriginalQuality=nil}
local CAM_FOV_Conn = nil

local MusicPlayer = {
    Enabled = false,
    CurrentTrack = 1,
    Volume = 0.5,
    Sound = nil,
    Playing = false,
    LoopMode = true,
}
local MusicTracks = {
    {Name = "唐人", ID = "rbxassetid://74173898692517"},
    {Name = "牵丝戏", ID = "rbxassetid://82736875196779"},
    {Name = "辞九门回忆", ID = "rbxassetid://75361870687357"},
    {Name = "雨爱", ID = "rbxassetid://79277371759525"},
    {Name = "武家坡", ID = "rbxassetid://88304207692432"},
    {Name = "海底", ID = "rbxassetid://117225633780122"},
    {Name = "错位时空", ID = "rbxassetid://83422989427201"},
    {Name = "精卫", ID = "rbxassetid://124044109756641"},
    {Name = "安和桥", ID = "rbxassetid://120145064597801"},
    {Name = "后继者", ID = "rbxassetid://118896961448948"},
    {Name = "会呼吸的痛", ID = "rbxassetid://96590819329722"},
    {Name = "青衣", ID = "rbxassetid://125615482496831"},
    {Name = "铡美案", ID = "rbxassetid://114476517052805"},
    {Name = "朋友的酒", ID = "rbxassetid://79122285852432"},
    {Name = "小幸运", ID = "rbxassetid://81381619096029"},
    {Name = "不得不爱", ID = "rbxassetid://116497979556639"},
    {Name = "求佛", ID = "rbxassetid://111568038897020"},
    {Name = "迷人的危险", ID = "rbxassetid://111027647468458"},
    {Name = "落泪", ID = "rbxassetid://100856301638837"},
    {Name = "鸟之诗", ID = "rbxassetid://113665010217108"},
    {Name = "wasted - Juice world", ID = "rbxassetid://82935019669756"},
    {Name = "BABYDOLL", ID = "rbxassetid://127012181396114"},
    {Name = "Billie Jean", ID = "rbxassetid://11619783114890"},
    {Name = "jump444", ID = "rbxassetid://94317888706988"},
    {Name = "福瑞圈配乐", ID = "rbxassetid://79375776740650"},
    {Name = "azure和两次同人服最后一人", ID = "rbxassetid://77715601943266"},
    {Name = "巴沙尔小曲", ID = "rbxassetid://81535246767668"},
    {Name = "砰砰砰砰", ID = "rbxassetid://90726723742680"},
    {Name = "Happy Place The Amazing digital circus", ID = "rbxassetid://126145473715817"},
    {Name = "One Hell of a Time [NEW REMIX] - Cuphead", ID = "rbxassetid://116062755624958"},
    {Name = "MYTH IN SLAUGHTER | Hoax chase theme", ID = "rbxassetid://14542084153756"},
    {Name = "The Amazing Digital Circus - Not Alone", ID = "rbxassetid://113949601134627"},
    {Name = "彼得格里芬", ID = "rbxassetid://125366684647890"},
    {Name = "帽子工厂（2）", ID = "rbxassetid://101591382397543"},
    {Name = "赵一鸣", ID = "rbxassetid://85373130121712"},
    {Name = "高阶萌妹成长指南", ID = "rbxassetid://127416115159040"},
}

local FLY = {
    Enabled = false, Active = false, Speed = 60,
    LastSafeCF = nil, AnimTrack = nil, SpeedLabel = nil,
    PM = nil, PC = nil,
    CurrentYaw = nil, OffTime = nil,
    Gui = nil, Btn = nil,
    RZDONL = nil, NextSend = 0,
    AnimObj = nil,
    AnimId = "rbxassetid://",
    Joints = {"Left Hip","Right Hip","Left Shoulder","Right Shoulder","Neck"},
    EvArgs = {"-r__r3"},
    MobileMode = false,
}
local function FlyRefreshBtn()
    if not FLY.Btn then return end
    if FLY.Active then
        FLY.Btn.Text = "开启"; FLY.Btn.BackgroundColor3 = Color3.fromRGB(30,165,60)
    else
        FLY.Btn.Text = "关闭"; FLY.Btn.BackgroundColor3 = Color3.fromRGB(185,45,45)
    end
end

local HitLog = { ActiveLogs = {} }
HitLog.THEME = {
    RowHeight = 13, PaddingY = 7, SidePadding = 16, FontSize = 10,
    Font = SilkscreenFont,
    Color_Bg = Color3.fromRGB(0, 0, 0),
    Color_Accent = Color3.fromRGB(0, 255, 0),
    Color_Secondary = Color3.fromRGB(200, 200, 200),
    BgTransparency = 0.5, Lifetime = 5.0, MaxLogs = 8,
    Position = UDim2.new(0, 20, 0, 70),
}

local BoxESP = { Boxes = {}, Conn = {} }
local espSets = {
    enabled = false, targetOnly = false, outline = true, inline = true,
    outCol = Color3.fromRGB(255,255,255), inCol = Color3.fromRGB(0,0,0),
    outAlpha = 0.5, inAlpha = 0.2, outSize = 0.1, inSize = 0.05,
}
local bodyParts = {
    "Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg",
    "UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand",
    "RightUpperArm","RightLowerArm","RightHand",
    "LeftUpperLeg","LeftLowerLeg","LeftFoot",
    "RightUpperLeg","RightLowerLeg","RightFoot",
}

local reloadConnections = {}
local PL_TargetSearch, PL_WhiteSearch = nil, nil
local lastTickHadGun = false
local ChangeMouseLockEvent = RepStorage:WaitForChild("Events2"):WaitForChild("ChangeMouseLock")
local function GetLocalRealPosition()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return Vector3.zero end
    return hrp.Position - DS.AppliedOffset
end

local function GetGunConfig(tool)
    if not tool then return nil end
    if RB_LO.CachedGunConfig and RB_LO.CachedGunConfig.Tool == tool then
        return RB_LO.CachedGunConfig.Config
    end
    local cfg = tool:FindFirstChild("Config")
    if cfg and cfg:IsA("ModuleScript") then
        local ok, gs = pcall(require, cfg)
        if ok and gs then
            RB_LO.CachedGunConfig = {Tool = tool, Config = gs, Time = tick()}
            return gs
        end
    end
    return nil
end

local function GetDynamicRadius(baseRadius, distance)
    if not RB_LO.DynamicRadiusScale then return baseRadius end
    if distance < RB_LO.DistanceTiers.Near then
        local scale = 1.2 + (RB_LO.DistanceTiers.Near - distance) / 200
        return math.min(baseRadius * scale, RB_LO.MaxRadiusClamp)
    end
    if distance < RB_LO.LongDistThreshold then return baseRadius end
    local scale = 1 - math.clamp((distance - RB_LO.LongDistThreshold) / 250, 0, RB_LO.RadiusScaleFactor)
    local newRadius = baseRadius * math.max(scale, 0.35)
    return math.clamp(newRadius, RB_LO.MinRadiusClamp, RB_LO.MaxRadiusClamp)
end

local function GetCompensatedPosition(basePos, targetPos, distance)
    if not RB_LO.DistCompensation then return basePos end
    if distance < 50 then return basePos end
    local dir = (targetPos - basePos).Unit
    local compensation = dir * (distance * RB_LO.CompensationFactor)
    return basePos + compensation
end

local function GetBulletDropCompensation(origin, hit, distance, gunConfig)
    if not RB_LO.BulletDropComp then return hit end
    if distance < 100 then return hit end
    local velocity = RB_LO.VelocityEstimate
    if gunConfig then
        if gunConfig.BulletSettings and gunConfig.BulletSettings.Velocity then
            velocity = gunConfig.BulletSettings.Velocity
        elseif gunConfig.Velocity then
            velocity = gunConfig.Velocity
        end
    end
    local flightTime = distance / velocity
    local drop = 0.5 * 196.2 * flightTime * flightTime * RB_LO.DropFactor
    return hit + Vector3.new(0, drop, 0)
end

local function GetPredictedPosition(targetPart, distance, gunConfig)
    if not RB_LO.PredictionEnabled then return targetPart.Position end
    if not targetPart then return Vector3.zero end
    local velocity = RB_LO.VelocityEstimate
    if gunConfig then
        if gunConfig.BulletSettings and gunConfig.BulletSettings.Velocity then
            velocity = gunConfig.BulletSettings.Velocity
        elseif gunConfig.Velocity then
            velocity = gunConfig.Velocity
        end
    end
    local flightTime = distance / velocity
    local targetVel = targetPart.AssemblyLinearVelocity
    local predictionFactor = RB_LO.PredictionFactor
    if distance > RB_LO.DistanceTiers.Far then
        predictionFactor = predictionFactor * 1.3
    elseif distance > RB_LO.DistanceTiers.Mid then
        predictionFactor = predictionFactor * 1.15
    end
    local prediction = targetVel * flightTime * predictionFactor
    return targetPart.Position + prediction
end

local ScanVectors = {
    Vector3.new(1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 1, 0),
    -Vector3.new(1, 0, 0), -Vector3.new(0, 0, 1), -Vector3.new(0, 1, 0),
    Vector3.new(1, 1, 0)/math.sqrt(2), Vector3.new(1, 0, 1)/math.sqrt(2), Vector3.new(0, 1, 1)/math.sqrt(2),
    Vector3.new(-1, 1, 0)/math.sqrt(2), Vector3.new(-1, 0, 1)/math.sqrt(2),
    -Vector3.new(1, 0, 1)/math.sqrt(2), -Vector3.new(-1, 0, 1)/math.sqrt(2), -Vector3.new(0, -1, 1)/math.sqrt(2),
    Vector3.new(1, 1, 1)/math.sqrt(3), Vector3.new(-1, 1, 1)/math.sqrt(3), Vector3.new(1, 1, -1)/math.sqrt(3),
    -Vector3.new(1, 1, 1)/math.sqrt(3), -Vector3.new(1, -1, 1)/math.sqrt(3),
    Vector3.new(1,2,0)/math.sqrt(5), Vector3.new(-1,2,0)/math.sqrt(5), Vector3.new(1,0,2)/math.sqrt(5), Vector3.new(-1,0,2)/math.sqrt(5),
    -Vector3.new(-1,0,2)/math.sqrt(5), -Vector3.new(1,0,2)/math.sqrt(5),
    Vector3.new(2,1,0)/math.sqrt(5), Vector3.new(-2,1,0)/math.sqrt(5),
    Vector3.new(2,-1,0)/math.sqrt(5), Vector3.new(-2,-1,0)/math.sqrt(5),
    Vector3.new(0,2,1)/math.sqrt(5), Vector3.new(0,2,-1)/math.sqrt(5),
    Vector3.new(1,3,0)/math.sqrt(10), Vector3.new(-1,3,0)/math.sqrt(10),
    Vector3.new(3,1,0)/math.sqrt(10), Vector3.new(-3,1,0)/math.sqrt(10),
}

local function GetOffsets_Algo1(firePos, targetPos, offset)
    if not offset or offset <= 0 then return {firePos} end
    local offsets = {firePos}
    local cfOffset = CFrame.new(firePos, targetPos) * CFrame.Angles(0, 0, math.rad(math.random(1, 90)))
    for _, pos in ipairs(ScanVectors) do
        table.insert(offsets, cfOffset * (pos * offset))
    end
    return offsets
end

local function GetOffsets_Algo2(center, poleDir, radius, count)
    if not radius or radius <= 0 or count <= 0 then return {center} end
    local offsets = {center}
    local PHI = 0.6180339887
    local arb = math.abs(poleDir.X) < 0.9 and Vector3.new(1,0,0) or Vector3.new(0,1,0)
    local t1 = poleDir:Cross(arb).Unit
    local t2 = poleDir:Cross(t1).Unit
    for i = 0, count - 1 do
        local phi = i * PHI * 2 * math.pi
        local cosT = 1 - (i + 0.5) / count
        local sinT = math.sqrt(1 - cosT * cosT)
        local r = radius * (math.random()^(1/3))
        local dir = t1 * (sinT * math.cos(phi)) + t2 * (sinT * math.sin(phi)) + poleDir * cosT
        table.insert(offsets, center + dir * r)
    end
    return offsets
end

local DoRagebot_LastRun = 0

local function DoRagebot()
    if not RB_State then Valid_Pair=nil; Locked_Path=nil; return end
    local now = tick()
    if now - DoRagebot_LastRun < 0.008 then return end
    DoRagebot_LastRun = now
    if RB_LO.CachedGunConfig and (now - RB_LO.CachedGunConfig.Time > 10) then
        RB_LO.CachedGunConfig = nil
    end
    local target = GetTarget()
    if not target or not target.Character then Valid_Pair=nil; Locked_Path=nil; return end
    if Locked_Path and Locked_Path.Target ~= target then Locked_Path=nil end
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot or not tRoot then return end
    local myPos = GetLocalRealPosition()
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    local gunConfig = RB_LO.Enabled and GetGunConfig(tool) or nil
    local distance = (myPos - tRoot.Position).Magnitude
    RB_LO.LastTargetDist = distance
    if RB_LO.Enabled and not (distance <= RB_LO.MaxDistThreshold) then Valid_Pair=nil; return end
    local tPos = GetPredictedPosition(tRoot, distance, gunConfig)
    local historyPred = PredictFromHistory(target, distance / math.max(CL.CachedVel or RB_LO.VelocityEstimate, 100))
    if historyPred then
        tPos = tPos * 0.6 + historyPred * 0.4
    end
    RecordTargetPosition(target, tPos)
    UpdateVelocityCache()
    tPos = tPos + Vector3.new(0, GetHeightOffset(distance), 0)
    if Locked_Path then
        local dO = (myPos - Locked_Path.MyPos).Magnitude
        local dH = (tPos - Locked_Path.TPos).Magnitude
        local threshold = WB.Threshold
        if RB_LO.Enabled and distance > RB_LO.LongDistThreshold then
            threshold = WB.Threshold * 0.6
        end
        local inRange = (myPos - Locked_Path.AbsO).Magnitude <= Origin_Radius
                   and (tPos - Locked_Path.AbsH).Magnitude <= Hit_Radius
        if dO <= threshold and dH <= threshold and inRange then
            local checkFunc = (RB_LO.Enabled and distance > 200) and CheckWallbangOptimized or CheckWallbang
            if checkFunc(Locked_Path.AbsO, Locked_Path.AbsH, distance) then
                Valid_Pair = {Origin = Locked_Path.AbsO, Hit = Locked_Path.AbsH, Target = target}
                WB.Cached = true; return
            end
        end
        Locked_Path = nil
    end
    if tick() - WB.LastScan < 1/ScanRate then return end
    WB.LastScan = tick()
    WB.Round = WB.Round + 1
    local effOriginRadius, effHitRadius = Origin_Radius, Hit_Radius
    local effOriginScans, effHitScans = Origin_Scans, Hit_Scans
    if RB_LO.Enabled then
        effOriginRadius = GetDynamicRadius(Origin_Radius, distance)
        effHitRadius = GetDynamicRadius(Hit_Radius, distance)
        effOriginScans = GetOptimizedScanCount(Origin_Scans, distance)
        effHitScans = GetOptimizedScanCount(Hit_Scans, distance)
    end
    local newOrigin, newTarget
    if WB.Round % 2 == 0 then
        newOrigin = GetOffsets_Algo1(myPos, tPos, effOriginRadius)
        newTarget = GetOffsets_Algo1(tPos, myPos, effHitRadius)
    else
        local oPole = (tPos - myPos)
        if oPole.Magnitude < 0.001 then return end
        oPole = oPole.Unit
        local hPole = -oPole
        newOrigin = GetOffsets_Algo2(myPos, oPole, effOriginRadius, effOriginScans)
        newTarget = GetOffsets_Algo2(tPos, hPole, effHitRadius, effHitScans)
    end
    local bestPO, bestPH = nil, nil
    local checkFunc = (RB_LO.Enabled and distance > 200) and CheckWallbangOptimized or CheckWallbang
    for _, pO in ipairs(newOrigin) do
        for _, pH in ipairs(newTarget) do
            local compensatedPH = pH
            if RB_LO.Enabled then
                compensatedPH = GetCompensatedPosition(pH, pO, distance)
                compensatedPH = GetBulletDropCompensation(pO, compensatedPH, distance, gunConfig)
            end
            if checkFunc(pO, compensatedPH, distance) then
                bestPO = pO; bestPH = compensatedPH; break
            end
        end
        if bestPO then break end
    end
    if bestPO then
        Locked_Path = {AbsO = bestPO, AbsH = bestPH, Target = target, MyPos = myPos, TPos = tPos, _createTime = tick()}
        Valid_Pair = {Origin = bestPO, Hit = bestPH, Target = target}
        WB.Cached = false
    else
        Valid_Pair = nil
    end
end

RunService.Heartbeat:Connect(function()
    if RB_State then DoRagebot() end
    if not Valid_Pair then return end
    if not Valid_Pair.Target or not Valid_Pair.Origin or not Valid_Pair.Hit then
        Valid_Pair = nil; return
    end
    if not Valid_Pair.Target.Character then
        Valid_Pair = nil; Locked_Path = nil; return
    end
    local tHum = Valid_Pair.Target.Character:FindFirstChildOfClass("Humanoid")
    if tHum and tHum.Health <= 0 then
        Valid_Pair = nil; Locked_Path = nil; return
    end
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not (tool and tool:FindFirstChild("IsGun")) then return end
    local waitTime = 0.001
    if RF_State then
        local gn = tool.Name
        if not (gn:find("Beretta") or gn:find("TEC")) then
            local cfg = tool:FindFirstChild("Config")
            if cfg and cfg:IsA("ModuleScript") then
                local ok, gs = pcall(require, cfg)
                if ok and gs then waitTime = 1/(999 or 3) else waitTime = 0.001 end
            else waitTime = 0.001 end
        end
    end
    if tick() - Last_Shot < waitTime then return end
    local vals = tool:FindFirstChild("Values")
    local ammo = vals and vals:FindFirstChild("SERVER_Ammo")
    if not (ammo and ammo.Value > 0) then return end
    local part = Valid_Pair.Target.Character:FindFirstChild("Head") or Valid_Pair.Target.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end
    if RB_LO.Enabled and RB_LO.LastTargetDist > 200 then
        local currentDist = (Valid_Pair.Origin - Valid_Pair.Hit).Magnitude
        if not CheckWallbangOptimized(Valid_Pair.Origin, Valid_Pair.Hit, currentDist) then
            Valid_Pair = nil; Locked_Path = nil; return
        end
    end
    local key = "K"..math.random(1000,9999)
    local dir = (Valid_Pair.Hit - Valid_Pair.Origin).Unit
    if dir.Magnitude < 0.001 then return end
    GN_S:FireServer(tick(),key,tool,"FDS9I83",Valid_Pair.Origin,{dir},false)
    if TR.Enabled then task.spawn(CreateTracer, Valid_Pair.Origin, dir) end
    ZF_H:FireServer("🧈",tool,key,1,part,Valid_Pair.Hit,dir)
    if tool:FindFirstChild("Hitmarker") then tool.Hitmarker:Fire(part) end
    if HitLogEnabled then
        local dmg, mult = 17, 1.35
        local gunConfig = RB_LO.Enabled and GetGunConfig(tool) or nil
        if gunConfig then dmg = gunConfig.Damage or 17; mult = gunConfig.HeadshotMultiplier or 1.35
        elseif tool:FindFirstChild("Config") then
            local ok, c = pcall(require, tool.Config)
            if ok then dmg = c.Damage or 17; mult = c.HeadshotMultiplier or 1.35 end
        end
        local fd = (dmg * mult) - (math.floor((Valid_Pair.Origin - Valid_Pair.Hit).Magnitude/50)*2)
        local mp = GetLocalRealPosition()
        local tr = Valid_Pair.Target.Character:FindFirstChild("HumanoidRootPart")
        ProcessHitLog(Valid_Pair.Target.Name, tool.Name, math.floor(fd*100)/100, tr and math.floor((mp-tr.Position).Magnitude) or 0, WB.Cached)
    end
    Last_Shot = tick()
    if Locked_Path then
        local cacheAge = tick() - (Locked_Path._createTime or 0)
        if cacheAge > 2 then Locked_Path = nil end
    end
end)

RunService.Heartbeat:Connect(function()
    if not MC.AntiShift then return end
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    local hasGun = tool ~= nil and tool:FindFirstChild("IsGun") ~= nil
    if lastTickHadGun and not hasGun then
        task.delay(MC.ShiftDelay, function()
            firesignal(ChangeMouseLockEvent.Event)
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        end)
    end
    lastTickHadGun = hasGun
end)

RunService.Heartbeat:Connect(function()
    if not (NametagEnabled or DistanceEnabled or HealthEnabled) then return end
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local now = tick()
    if now - LastVisualUpdate >= ((myRoot.Velocity.Magnitude > (CONFIG.VelocityThreshold or 0.5)) and CONFIG.Rate_Active or CONFIG.Rate_Idle) then
        LastVisualUpdate = now
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local ch = player.Character
                local h = ch:FindFirstChildOfClass("Humanoid")
                local alive = h and h.Health > 0
                local show = alive and (not espSets.targetOnly or table.find(TargetList, player.Name) ~= nil)
                local tag = GetCustomTag(ch, "CAT_NameTag", CONFIG.NameOffset)
                if tag then
                    local showName = NametagEnabled and show
                    local showDist = DistanceEnabled and show
                    local scaledHP = h and math.ceil(h.Health * (100/115)) or 0
                    local showHP = HealthEnabled and show and scaledHP < 100
                    tag.Enabled = (showName or showDist)
                    local nameL = tag:FindFirstChild("L")
                    local distL = tag:FindFirstChild("DL")
                    if nameL then
                        nameL.Visible = showName
                        if showName then
                            if table.find(WhiteList, player.Name) ~= nil then nameL.TextColor3 = Color3.fromRGB(135,206,235)
                            elseif table.find(TargetList, player.Name) ~= nil then nameL.TextColor3 = Color3.fromRGB(255,0,0)
                            else nameL.TextColor3 = Color3.fromRGB(255,255,255) end
                        end
                    end
                    if distL then distL.Visible = showDist end
                end
                local hpTag = ch:FindFirstChild("CAT_HPTag")
                if hpTag then
                    local scaledHP = h and math.ceil(h.Health * (100/115)) or 0
                    local showHP = HealthEnabled and show and scaledHP < 100
                    hpTag.Enabled = showHP
                    if showHP then
                        local l = hpTag:FindFirstChild("L")
                        if l then l.Text = tostring(scaledHP) end
                    end
                end
                local ffTag = ch:FindFirstChild("CAT_FFTag")
                if ffTag then
                    local hasFF = ch:FindFirstChildOfClass("ForceField") ~= nil
                    ffTag.Enabled = (NametagEnabled or DistanceEnabled or HealthEnabled) and show and hasFF
                end
            end
        end
    end
    if now - LastContentUpdate >= CONFIG.ContentRate then
        LastContentUpdate = now
        local myPos = GetLocalRealPosition()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local tag = player.Character:FindFirstChild("CAT_NameTag")
                if tag and tag.Enabled then
                    local nameL = tag:FindFirstChild("L")
                    local distL = tag:FindFirstChild("DL")
                    local tr = player.Character:FindFirstChild("HumanoidRootPart")
                    if nameL and nameL.Visible then nameL.Text = player.Name end
                    if distL and distL.Visible and tr then
                        distL.Text = math.floor((myPos - tr.Position).Magnitude) .. "米"
                    end
                end
            end
        end
    end
end)

local function MonitorChar(c) if c then CurrentHum = c:WaitForChild("Humanoid",10) end end
MonitorChar(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(MonitorChar)

local originalFireServer
originalFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
    if NoFallEnabled and self.Name == "__RZDONL" then
        local cs = getcallingscript()
        if cs and cs:IsDescendantOf(game) then return nil end
    end
    return originalFireServer(self, ...)
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" and self == ZF_H then
        if HitSoundSelection ~= "None" and HitSounds[HitSoundSelection] then
            task.spawn(function()
                local s = Instance.new("Sound", Camera)
                s.SoundId = HitSounds[HitSoundSelection]
                s.Volume = 1
                s:Play()
                Debris:AddItem(s, 1)
            end)
        end
    end
    if method == "FireServer" and NoFallEnabled and self.Name == "__RZDONL" then
        local cs = getcallingscript()
        if cs and cs:IsDescendantOf(game) then return nil end
    end
    if (HeadMode or HandsModSelection) and method == "FireServer" and self.Name == "MOVZREP" then
        if args[1] and type(args[1]) == "table" and args[1][1] then
            pcall(function()
                if HandsModSelection == "Hands up" then
                    args[1][1][1] = AC.HandsUp1; args[1][1][2] = AC.HandsUp2
                elseif HandsModSelection == "Open hands" then
                    args[1][1][1] = AC.OpenHands; args[1][1][2] = AC.OpenHands
                end
                if HeadMode == "Hide head" then args[1][1][3] = AC.AntiDown end
            end)
        end
    end
    if not checkcaller() then
        if self == ZF_H and method == "FireServer" and args[1] ~= "🧈" then return nil end
        if self == GN_S and method == "FireServer" and TR.Enabled then
            if typeof(args[5]) == "Vector3" and typeof(args[6]) == "table" and args[6][1] then
                task.spawn(CreateTracer, args[5], args[6][1])
            end
        end
    end
    return oldNamecall(self, ...)
end)

local function GetCustomTag(char, tagName, offset)
    local tag = char:FindFirstChild(tagName)
    if not tag then
        local head = char:FindFirstChild("Head")
        local root = char:FindFirstChild("HumanoidRootPart")
        local adorn = head or root
        if not adorn then return nil end
        tag = Instance.new("BillboardGui")
        tag.Name = tagName
        tag.AlwaysOnTop = true
        tag.Size = UDim2.new(0, 200, 0, 36)
        tag.StudsOffset = Vector3.new(0, 0.6, 0)
        tag.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
        tag.Enabled = false
        local nameL = Instance.new("TextLabel")
        nameL.Name = "L"
        nameL.BackgroundTransparency = 1
        nameL.Size = UDim2.new(1, 0, 0.5, 0)
        nameL.Position = UDim2.new(0, 0, 0, 0)
        nameL.TextColor3 = Color3.new(1,1,1)
        nameL.FontFace = SilkscreenFont
        nameL.TextSize = 7
        nameL.TextXAlignment = Enum.TextXAlignment.Center
        local s1 = Instance.new("UIStroke")
        s1.Thickness = CONFIG.StrokeThickness
        s1.Color = Color3.new(0,0,0)
        s1.Parent = nameL
        nameL.Parent = tag
        local distL = Instance.new("TextLabel")
        distL.Name = "DL"
        distL.BackgroundTransparency = 1
        distL.Size = UDim2.new(1, 0, 0.5, 0)
        distL.Position = UDim2.new(0, 0, 0.5, 0)
        distL.TextColor3 = Color3.fromRGB(200, 200, 200)
        distL.FontFace = SilkscreenFont
        distL.TextSize = 7
        distL.TextXAlignment = Enum.TextXAlignment.Center
        local s2 = Instance.new("UIStroke")
        s2.Thickness = CONFIG.StrokeThickness
        s2.Color = Color3.new(0,0,0)
        s2.Parent = distL
        distL.Parent = tag
        local ffTag = Instance.new("BillboardGui")
        ffTag.Name = "CAT_FFTag"
        ffTag.AlwaysOnTop = true
        ffTag.Size = UDim2.new(0, 60, 0, 20)
        ffTag.StudsOffset = Vector3.new(2.5, 0, 0)
        ffTag.Enabled = false
        local ffL = Instance.new("TextLabel")
        ffL.Name = "L"
        ffL.BackgroundTransparency = 1
        ffL.Size = UDim2.new(1,0,1,0)
        ffL.Text = "FF"
        ffL.TextColor3 = Color3.new(1,1,1)
        ffL.FontFace = SilkscreenFont
        ffL.TextSize = 7
        ffL.TextXAlignment = Enum.TextXAlignment.Center
        local sFF = Instance.new("UIStroke")
        sFF.Thickness = CONFIG.StrokeThickness
        sFF.Color = Color3.new(0,0,0)
        sFF.Parent = ffL
        ffL.Parent = ffTag
        ffTag.Parent = char
        ffTag.Adornee = root
        local hpTag = Instance.new("BillboardGui")
        hpTag.Name = "CAT_HPTag"
        hpTag.AlwaysOnTop = true
        hpTag.Size = UDim2.new(0, 60, 0, 20)
        hpTag.StudsOffset = Vector3.new(-2.5, 0, 0)
        hpTag.Enabled = false
        local hpL = Instance.new("TextLabel")
        hpL.Name = "L"
        hpL.BackgroundTransparency = 1
        hpL.Size = UDim2.new(1,0,1,0)
        hpL.TextColor3 = Color3.new(1,1,1)
        hpL.FontFace = SilkscreenFont
        hpL.TextSize = 7
        hpL.TextXAlignment = Enum.TextXAlignment.Center
        local sHP = Instance.new("UIStroke")
        sHP.Thickness = CONFIG.StrokeThickness
        sHP.Color = Color3.new(0,0,0)
        sHP.Parent = hpL
        hpL.Parent = hpTag
        hpTag.Parent = char
        hpTag.Adornee = root
        tag.Parent = char
        tag.Adornee = adorn
    end
    return tag
end

local function clearReloadConnections()
    for _, c in pairs(reloadConnections) do c:Disconnect() end
    reloadConnections = {}
end

local function setupTool(tool)
    if not (tool and tool:FindFirstChild("IsGun") and AutoReload) then return end
    local vals = tool:FindFirstChild("Values")
    if not vals then return end
    local sa, ssa = vals:FindFirstChild("SERVER_Ammo"), vals:FindFirstChild("SERVER_StoredAmmo")
    local function reload()
        if AutoReload and ssa and ssa.Value ~= 0 and sa and sa.Value <= 1 then
            GN_R:FireServer(tick(),"KLWE89U0",tool)
        end
    end
    local function checkAndReload()
        if not AutoReload then return end
        if sa and ssa and sa.Value <= 1 and ssa.Value > 0 then
            GN_R:FireServer(tick(),"KLWE89U0",tool)
        end
    end
    if ssa then table.insert(reloadConnections, ssa:GetPropertyChangedSignal("Value"):Connect(reload)) end
    if sa then
        table.insert(reloadConnections, sa:GetPropertyChangedSignal("Value"):Connect(reload))
        table.insert(reloadConnections, RunService.Heartbeat:Connect(checkAndReload))
    end
end

local function AutoReloadSetup()
    clearReloadConnections()
    if not AutoReload then return end
    if LocalPlayer.Character then
        setupTool(LocalPlayer.Character:FindFirstChildOfClass("Tool"))
        table.insert(reloadConnections, LocalPlayer.Character.ChildAdded:Connect(function(o)
            if o:IsA("Tool") then setupTool(o) end
        end))
    end
    table.insert(reloadConnections, LocalPlayer.CharacterAdded:Connect(function(c)
        repeat task.wait() until c and c.Parent
        clearReloadConnections()
        setupTool(c:FindFirstChildOfClass("Tool"))
        table.insert(reloadConnections, c.ChildAdded:Connect(function(o)
            if o:IsA("Tool") then setupTool(o) end
        end))
    end))
end

local function ShouldLock()
    if not CL.Enabled then return false end
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool or not tool:FindFirstChild("IsGun") then return false end
    local vals = tool:FindFirstChild("Values")
    return vals and vals:FindFirstChild("AimDown") and vals.AimDown.Value == true
end

local function IsVisible(origin, tPart)
    if not tPart or not tPart.Parent then return false end
    local p = RaycastParams.new()
    p.FilterType = Enum.RaycastFilterType.Exclude
    p.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local r = workspace:Raycast(origin, tPart.Position - origin, p)
    return not r or (r.Instance and r.Instance:IsDescendantOf(tPart.Parent))
end

local function GetVisibleParts(origin, char)
    if not char then return {} end
    local vis = {}
    for _, name in ipairs(CL.TargetParts) do
        local p = char:FindFirstChild(name)
        if p and IsVisible(origin, p) then table.insert(vis, p) end
    end
    if #vis > 0 then return vis end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return hrp and {hrp} or {}
end

local function StartMeleeLoop()
    if MA.Loop then return end
    local WCDs = {["Fists"]=.05,["Knuckledusters"]=.05,["Nunchucks"]=0.05,["Shiv"]=.05,["Chainsaw"]=2.5}
    MA.Loop = task.spawn(function()
        while MA.Enabled do
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool and char:FindFirstChild("HumanoidRootPart") then
                local cd = 0.5
                if WCDs[tool.Name] then cd = WCDs[tool.Name]
                else
                    local cfg = tool:FindFirstChild("Config")
                    if cfg and cfg:IsA("ModuleScript") then
                        pcall(function()
                            local m = require(cfg)
                            if m.Mains and m.Mains.S1 then cd = (m.Mains.S1.SwingWait or 0.2)+(m.Mains.S1.SwingTime or 0.1)+0.05 end
                        end)
                    end
                end
                if tick()-MA.LastHit >= cd then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            if not table.find(WhiteList,p.Name) and (not MA.TargetOnly or table.find(TargetList,p.Name)) then
                                local tChar = p.Character
                                local myPos = GetLocalRealPosition()
                                local dist = (myPos - tChar.HumanoidRootPart.Position).Magnitude
                                local hum = tChar:FindFirstChildOfClass("Humanoid")
                                if dist <= MA.Distance and hum and hum.Health > (MA.DownCheck and 15 or 0) then
                                    local res = MA.Remote1:InvokeServer("🍞",tick(),tool,"43TRFWX","Normal",tick(),true)
                                    if MA.ShowAnim then pcall(function() char.Humanoid.Animator:LoadAnimation(tool.AnimsFolder.Slash1):Play(0.1,1,1.3) end) end
                                    task.wait(0.2)
                                    local hitPart = MA.TargetPart=="Random" and tChar:FindFirstChild(MA.Parts[math.random(1,#MA.Parts)]) or tChar:FindFirstChild(MA.TargetPart)
                                    if hitPart then
                                        local handle = tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle") or char:FindFirstChild("Left Arm")
                                        local a = {"🍞",tick(),tool,"2389ZFX34",res,true,handle,hitPart,tChar,myPos,hitPart.Position}
                                        if tool.Name=="Chainsaw" then for i=1,15 do MA.Remote2:FireServer(unpack(a)) end else MA.Remote2:FireServer(unpack(a)) end
                                        MA.LastHit = tick(); break
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait()
        end
        MA.Loop = nil
    end)
end

local function StartAutoPickUpMoney()
    if SC.APM_Loop then return end
    SC.APM_Loop = task.spawn(function()
        local event = RepStorage:FindFirstChild("Events") and RepStorage.Events:FindFirstChild("CZDPZUS")
        local filter = Workspace:FindFirstChild("Filter")
        while SC.APM_Enabled do
            local didPickup = false
            if event and filter then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bread = filter:FindFirstChild("SpawnedBread")
                    if bread then
                        for _, item in ipairs(bread:GetChildren()) do
                            if (hrp.Position - item.Position).Magnitude < 5 then
                                pcall(function() event:FireServer(item) end)
                                task.wait(1.1)
                                didPickup = true
                                break
                            end
                        end
                    end
                end
            end
            if not didPickup then task.wait(0.1) end
        end
        SC.APM_Loop = nil
    end)
end

local old
old = hookmetamethod(game, "__newindex", function(t, k, v)
    if FLY.Active then
        local lp = Players.LocalPlayer
        local stats = RepStorage:FindFirstChild("CharStats")
        local pStats = stats and stats:FindFirstChild(lp.Name)
        local rt = pStats and pStats:FindFirstChild("RagdollTime")
        if rt then
            if (t == rt:FindFirstChild("RagdollSwitch") or t == rt:FindFirstChild("RagdollSwitch2") or t == rt:FindFirstChild("SRagdolled")) and k == "Value" then
                return old(t, k, false)
            end
            if t == rt and k == "Value" then
                return old(t, k, 0)
            end
            if t == rt:FindFirstChild("RagdollTime2") and k == "MaxValue" then
                return old(t, k, 0)
            end
        end
        if t == pStats and t:FindFirstChild("NoRagdoll") and k == "Value" then
            return old(t, k, true)
        end
    end
    return old(t, k, v)
end)

local function StartAutoUnlockSafe()
    if SC.AUS_Loop then return end
    SC.AUS_Loop = task.spawn(function()
        while SC.AUS_Enabled do
            local processed = false
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            if hrp and hum then
                local map = Workspace:FindFirstChild("Map")
                local bredMakurz = map and map:FindFirstChild("BredMakurz")
                if bredMakurz then
                    local closestSafe, minDist = nil, 12
                    for _, obj in ipairs(bredMakurz:GetChildren()) do
                        if string.find(string.lower(obj.Name), "safe") then
                            local vals = obj:FindFirstChild("Values")
                            local broken = vals and vals:FindFirstChild("Broken")
                            if broken and broken.Value == false then
                                local part = obj:IsA("Model") and obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") or obj
                                if part and part:IsA("BasePart") then
                                    local dist = (hrp.Position - part.Position).Magnitude
                                    if dist <= minDist then
                                        minDist = dist; closestSafe = obj
                                    end
                                end
                            end
                        end
                    end
                    if closestSafe then
                        processed = true
                        local lockpick = char:FindFirstChild("Lockpick")
                        if not lockpick then
                            local bp = LocalPlayer.Backpack:FindFirstChild("Lockpick")
                            if bp then hum:EquipTool(bp); lockpick = bp; task.wait(0.25) end
                        end
                        if lockpick then
                            local remote = lockpick:FindFirstChild("Remote")
                            if remote then
                                local token = nil
                                for attempt = 1, 8 do
                                    pcall(function()
                                        token = remote:InvokeServer("S", closestSafe, "s")
                                    end)
                                    if token then break end
                                    task.wait(0.15)
                                end
                                if token then
                                    task.spawn(function()
                                        pcall(function() remote:InvokeServer("D", closestSafe, "s", token) end)
                                    end)
                                    task.spawn(function()
                                        pcall(function() remote:InvokeServer("C") end)
                                    end)
                                    task.wait(0.8)
                                    local vals2 = closestSafe:FindFirstChild("Values")
                                    local broken2 = vals2 and vals2:FindFirstChild("Broken")
                                    if broken2 and not broken2.Value then
                                        pcall(function() remote:InvokeServer("D", closestSafe, "s", token) end)
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end
            end
            if not processed then task.wait(0.1) end
        end
        SC.AUS_Loop = nil
    end)
end

local function StartSafeChams()
    if SafeChamsLoop then return end
    SafeChamsLoop = task.spawn(function()
        while SafeChamsEnabled do
            local map = Workspace:FindFirstChild("Map")
            local bredMakurz = map and map:FindFirstChild("BredMakurz")
            if bredMakurz then
                for _, obj in ipairs(bredMakurz:GetChildren()) do
                    if string.find(string.lower(obj.Name), "safe") then
                        local vals = obj:FindFirstChild("Values")
                        local broken = vals and vals:FindFirstChild("Broken")
                        if broken then
                            local hl = obj:FindFirstChild("SafeHighlight")
                            if broken.Value == false then
                                if not hl then
                                    hl = Instance.new("Highlight")
                                    hl.Name = "SafeHighlight"
                                    hl.FillColor = Color3.fromRGB(0, 255, 0)
                                    hl.FillTransparency = 0.5
                                    hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                                    hl.Parent = obj
                                end
                            else
                                if hl then hl:Destroy() end
                            end
                        end
                    end
                end
            end
            task.wait(1)
        end
        local map = Workspace:FindFirstChild("Map")
        local bredMakurz = map and map:FindFirstChild("BredMakurz")
        if bredMakurz then
            for _, obj in ipairs(bredMakurz:GetChildren()) do
                local hl = obj:FindFirstChild("SafeHighlight")
                if hl then hl:Destroy() end
            end
        end
        SafeChamsLoop = nil
    end)
end

local function clearBoxes(p)
    if BoxESP.Boxes[p] then
        for _, b in pairs(BoxESP.Boxes[p]) do b:Destroy() end
        BoxESP.Boxes[p] = nil
    end
end

local function createAdorn(class, part, name, z, color, alpha, size)
    local a = Instance.new(class)
    a.Name = name
    a.Adornee = part
    a.AlwaysOnTop = true
    a.ZIndex = z
    a.Color3 = color
    a.Transparency = alpha
    a.Parent = CoreGui
    if class == "BoxHandleAdornment" then
        a.Size = size
    else
        a.Height = size.Y
        a.Radius = size.X
        a.CFrame = CFrame.Angles(math.rad(90),0,0)
    end
    return a
end

local function updatePlayerBoxes(p)
    if not p or not espSets.enabled then clearBoxes(p); return end
    if espSets.targetOnly and not table.find(TargetList,p.Name) then clearBoxes(p); return end
    local char = p.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") then return end
    clearBoxes(p)
    BoxESP.Boxes[p] = {}
    for _, pn in pairs(bodyParts) do
        local obj = char:FindFirstChild(pn)
        if obj and obj:IsA("BasePart") then
            if obj.Name == "Head" then
                local s = (obj.Size.X/2)*0.6
                if espSets.outline then
                    table.insert(BoxESP.Boxes[p], createAdorn("CylinderHandleAdornment",obj,"out",-1,espSets.outCol,espSets.outAlpha,Vector2.new(s+espSets.outSize,obj.Size.Z+espSets.outSize)))
                end
                if espSets.inline then
                    table.insert(BoxESP.Boxes[p], createAdorn("CylinderHandleAdornment",obj,"in",1,espSets.inCol,espSets.inAlpha,Vector2.new(s+espSets.inSize,obj.Size.Z+espSets.inSize)))
                end
            else
                if espSets.outline then
                    table.insert(BoxESP.Boxes[p], createAdorn("BoxHandleAdornment",obj,"out",-1,espSets.outCol,espSets.outAlpha,obj.Size+Vector3.new(espSets.outSize,espSets.outSize,espSets.outSize)))
                end
                if espSets.inline then
                    table.insert(BoxESP.Boxes[p], createAdorn("BoxHandleAdornment",obj,"in",1,espSets.inCol,espSets.inAlpha,obj.Size+Vector3.new(espSets.inSize,espSets.inSize,espSets.inSize)))
                end
            end
        end
    end
end

local function refreshAllESP()
    for _, p in pairs(Players:GetPlayers()) do updatePlayerBoxes(p) end
end

local function VisualizeRay(o, t, col)
    if not Debug_Rays then return end
    local d = (t-o).Magnitude
    if d < 0.1 then return end
    local rp = Instance.new("Part")
    rp.Anchored = true
    rp.CanCollide = false
    rp.Material = Enum.Material.Neon
    rp.Color = col
    rp.Size = Vector3.new(0.05,0.05,d)
    rp.CFrame = CFrame.lookAt(o,t) * CFrame.new(0,0,-d/2)
    rp.Parent = Workspace
    Debris:AddItem(rp,1)
end

local function CheckWallbang(p1, p2)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local d = (p2-p1).Magnitude
    local r = Workspace:Raycast(p1,(p2-p1).Unit*d,params)
    local ok = not r or (r.Position-p2).Magnitude <= 24
    if Debug_Rays then VisualizeRay(p1, ok and p2 or (r and r.Position or p2), ok and Color3.new(0,1,0) or Color3.new(1,0,0)) end
    return ok
end

local GetTarget_LastRun = 0
local GetTarget_LastTarget = nil

local function GetTarget()
    local now = tick()
    if now - GetTarget_LastRun < 0.05 then return GetTarget_LastTarget end
    GetTarget_LastRun = now
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, metric = nil, math.huge
    local ml = UIS:GetMouseLocation()
    local sc = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local myPos = GetLocalRealPosition()
    local tool = char:FindFirstChildOfClass("Tool")
    local gunConfig = RB_LO.Enabled and GetGunConfig(tool) or nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not table.find(WhiteList,p.Name) and not (TargetMode == "Lock" and #TargetList > 0 and not table.find(TargetList,p.Name)) then
                local pr = p.Character:FindFirstChild("HumanoidRootPart")
                local ph = p.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and ph.Health > (DownCheck and 15 or 0) and not p.Character:FindFirstChildOfClass("ForceField") then
                    local dist = (myPos-pr.Position).Magnitude
                    local skipTarget = false
                    if RB_LO.Enabled and not (dist <= RB_LO.MaxDistThreshold) then skipTarget = true end
                    local effectiveDist = dist
                    if RB_LO.Enabled and RB_LO.PredictionEnabled then
                        local predictedPos = GetPredictedPosition(pr, dist, gunConfig)
                        effectiveDist = (myPos - predictedPos).Magnitude
                    end
                    if not skipTarget and (TargetMode == "Near" or TargetMode == "Lock") then
                        local d = effectiveDist
                        if RB_LO.Enabled then
                            if dist > RB_LO.DistanceTiers.Extreme then d = d * 2.0
                            elseif dist > RB_LO.DistanceTiers.Far then d = d * 1.6
                            elseif dist > RB_LO.DistanceTiers.Mid then d = d * 1.3
                            elseif dist > RB_LO.LongDistThreshold then d = d * 1.1 end
                        end
                        if d < metric then metric = d; best = p; RB_LO.LastTargetDist = dist end
                    elseif not skipTarget then
                        local sp, on = Camera:WorldToViewportPoint(pr.Position)
                        if on then
                            local d2 = ((TargetMode == "Mouse" and ml or sc) - Vector2.new(sp.X, sp.Y)).Magnitude
                            if RB_LO.Enabled then
                                if dist > RB_LO.DistanceTiers.Extreme then d2 = d2 * 1.8
                                elseif dist > RB_LO.DistanceTiers.Far then d2 = d2 * 1.4
                                elseif dist > RB_LO.DistanceTiers.Mid then d2 = d2 * 1.2
                                elseif dist > RB_LO.LongDistThreshold then d2 = d2 * 1.1 end
                            end
                            if d2 < metric then metric = d2; best = p; RB_LO.LastTargetDist = dist end
                        end
                    end
                end
            end
        end
    end
    GetTarget_LastTarget = best
    return best
end

local function ApplyBodyFF()
    local char = LocalPlayer.Character
    if not char then return end
    for _, p in ipairs(char:GetChildren()) do
        if IsBodyPart(p) then p.Material = Enum.Material.ForceField; p.Color = FF_S.Color end
    end
end
local function RestoreBody()
    for p, props in pairs(FF_S.BodyProps) do
        if p and p.Parent then p.Material = props.Material; p.Color = props.Color end
    end
    FF_S.BodyProps = {}
end
local function ApplyToolFF()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then
        for _, p in ipairs(tool:GetDescendants()) do
            if p:IsA("BasePart") then p.Material = Enum.Material.ForceField; p.Color = FF_S.Color end
        end
    end
end
local function RestoreTool()
    for p, props in pairs(FF_S.ToolProps) do
        if p and p.Parent then p.Material = props.Material; p.Color = props.Color end
    end
    FF_S.ToolProps = {}
end

local function GetAllPlayerNames()
    local n = {}
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(n, p.Name) end end
    return n
end

FLY.AnimObj = Instance.new("Animation")
FLY.AnimObj.AnimationId = FLY.AnimId

local function FlyGetInputDir()
    if not FLY.PM then
        local ok, r = pcall(function()
            return require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
        end)
        if ok then FLY.PM = r end
    end
    if FLY.PM and not FLY.PC then FLY.PC = FLY.PM:GetControls() end
    if not FLY.PC then return Vector3.zero end
    local mv = FLY.PC:GetMoveVector()
    local fwd = Camera.CFrame.LookVector
    local rgt = Camera.CFrame.RightVector
    local dir = rgt * mv.X + fwd * -mv.Z
    return dir.Magnitude > 0 and dir.Unit or Vector3.zero
end

local function FlyPlayAnim()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if FLY.AnimTrack and FLY.AnimTrack.IsPlaying then return end
    local anim = hum:FindFirstChildOfClass("Animator") or hum
    pcall(function()
        FLY.AnimTrack = anim:LoadAnimation(FLY.AnimObj)
        FLY.AnimTrack.Priority = Enum.AnimationPriority.Action4
        FLY.AnimTrack.Looped = true
        FLY.AnimTrack:Play()
    end)
end

local function FlyStopAnim()
    if FLY.AnimTrack then
        pcall(function() FLY.AnimTrack:Stop(0.3) end)
        FLY.AnimTrack = nil
    end
end

local function FlyOn()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return end
    FLY.Active = true
    FLY.LastSafeCF = nil
    FlyPlayAnim()
    FlyRefreshBtn()
end

local function FlyOff()
    FLY.Active = false
    FLY.LastSafeCF = nil
    FLY.CurrentYaw = nil
    FLY.OffTime = os.clock()
    FlyStopAnim()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    FlyRefreshBtn()
end

local function FlyCreateUI()
    if FLY.Gui then FLY.Gui:Destroy(); FLY.Gui = nil; FLY.Btn = nil end
    FLY.Gui = Instance.new("ScreenGui")
    FLY.Gui.Name = "FlyHUD"
    FLY.Gui.ResetOnSpawn = false
    FLY.Gui.IgnoreGuiInset = true
    FLY.Gui.DisplayOrder = 99
    FLY.Gui.Parent = CoreGui
    local frame = Instance.new("Frame", FLY.Gui)
    frame.Size = UDim2.new(0, 140, 0, 78)
    frame.Position = UDim2.new(1, -160, 1, -110)
    frame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    frame.BackgroundTransparency = 0.08
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(55, 55, 55)
    stroke.Thickness = 1
    stroke.Transparency = 0.2
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -16, 0, 20)
    title.Position = UDim2.new(0, 8, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "飞行"
    title.TextColor3 = Color3.fromRGB(160, 160, 160)
    title.TextSize = 12
    title.Font = Enum.Font.GothamMedium
    title.TextXAlignment = Enum.TextXAlignment.Left
    local speedLabel = Instance.new("TextLabel", frame)
    speedLabel.Size = UDim2.new(1, -16, 0, 16)
    speedLabel.Position = UDim2.new(0, 8, 0, 26)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "速度  " .. FLY.Speed
    speedLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    speedLabel.TextSize = 10
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    FLY.SpeedLabel = speedLabel
    local div = Instance.new("Frame", frame)
    div.Size = UDim2.new(1, -16, 0, 1)
    div.Position = UDim2.new(0, 8, 0, 46)
    div.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    div.BorderSizePixel = 0
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -16, 0, 22)
    btn.Position = UDim2.new(0, 8, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(185, 45, 45)
    btn.BorderSizePixel = 0
    btn.Text = "关闭"
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    FLY.Btn = btn
    btn.MouseButton1Click:Connect(function()
        if FLY.Active then FlyOff() else FlyOn() end
    end)
    FlyRefreshBtn()
end

local function FlyDestroyUI()
    if FLY.Gui then FLY.Gui:Destroy(); FLY.Gui = nil; FLY.Btn = nil end
    FLY.SpeedLabel = nil
end

RunService.Heartbeat:Connect(function()
    if FLY.Active then
        local char2 = LocalPlayer.Character
        local torso2 = char2 and (char2:FindFirstChild("Torso") or char2:FindFirstChild("UpperTorso"))
        if torso2 then
            for _, jn in ipairs(FLY.Joints) do
                local j = torso2:FindFirstChild(jn)
                if j and j:IsA("Motor6D") and not j.Enabled then j.Enabled = true end
            end
        end
    end
    if FLY.Active then
        local lp = Players.LocalPlayer
        local stats = RepStorage:FindFirstChild("CharStats")
        local pStats = stats and stats:FindFirstChild(lp.Name)
        local rt = pStats and pStats:FindFirstChild("RagdollTime")
        if rt then
            local s = rt:FindFirstChild("RagdollSwitch")
            local s2 = rt:FindFirstChild("RagdollSwitch2")
            local sr = rt:FindFirstChild("SRagdolled")
            local rt2 = rt:FindFirstChild("RagdollTime2")
            local nr = pStats and pStats:FindFirstChild("NoRagdoll")
            if s then s.Value = false end
            if s2 then s2.Value = false end
            if sr then sr.Value = false end
            if rt then rt.Value = 0 end
            if rt2 then rt2.MaxValue = 0 end
            if nr then nr.Value = true end
        end
    end
    if FLY.Active then
        local canSend = true
        local char = LocalPlayer.Character
        if char then
            local torso = char:FindFirstChild("Torso")
            local collider = torso and torso:FindFirstChild("TorsoCollider")
            if collider and collider.CanCollide == true then canSend = false end
        end
        if canSend then
            if not FLY.RZDONL then
                pcall(function()
                    FLY.RZDONL = RepStorage.Events:WaitForChild("__RZDONL", 1)
                end)
            end
            local now = os.clock()
            if FLY.RZDONL and now >= FLY.NextSend then
                pcall(function() FLY.RZDONL:FireServer(table.unpack(FLY.EvArgs)) end)
                FLY.NextSend = now + 0.05
            end
        end
    end
    if not FLY.Active then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.AssemblyLinearVelocity = FlyGetInputDir() * FLY.Speed
    if FLY.SpeedLabel then
        FLY.SpeedLabel.Text = "spd  " .. FLY.Speed
    end
end)

do
    local ok1, ok2 = pcall(function()
        SA.VisualizeEvent = RepStorage:WaitForChild("Events2",5):WaitForChild("Visualize",5)
    end), pcall(function()
        SA.DamageEvent = ZF_H
    end)
    if SA.VisualizeEvent then
        SA.VisualizeEvent.Event:Connect(function(_, key, _, Gun, _, StartPos, BulletsPerShot)
            if not SA.Enabled then return end
            if math.random(1,100) > SA.HitChance then return end
            local myTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if not myTool or Gun ~= myTool then return end
            local partName = SA.TargetPart
            local center
            if SA.FOV_PositionMode == "Mouse" then
                center = UIS:GetMouseLocation()
            else
                center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            end
            local target, shortestDist = nil, SA.FOV_Radius
            for _, v in ipairs(Players:GetPlayers()) do
                if v == LocalPlayer or not v.Character then continue end
                local h = v.Character:FindFirstChildOfClass("Humanoid")
                if not h or h.Health <= 0 then continue end
                if v.Character:FindFirstChildOfClass("ForceField") then continue end
                local part = v.Character:FindFirstChild(partName)
                if not part then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if not onScreen then continue end
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < shortestDist then
                    if SA.WallCheck then
                        local ignore = {Camera, LocalPlayer.Character, v.Character}
                        if #Camera:GetPartsObscuringTarget({part.Position}, ignore) > 0 then continue end
                    end
                    target = v; shortestDist = dist
                end
            end
            if not target or not target.Character then return end
            local hitPart = target.Character:FindFirstChild(partName)
            if not hitPart then return end
            local hitPos = hitPart.Position
            local lookVec = (hitPos - StartPos).Unit
            task.wait(0.005)
            for i = 1, #BulletsPerShot do
                SA.DamageEvent:FireServer("🧈", Gun, key, i, hitPart, hitPos, lookVec)
            end
            if Gun:FindFirstChild("Hitmarker") then Gun.Hitmarker:Fire(hitPart) end
        end)
    end
end

RunService.Heartbeat:Connect(function(dt)
    if not SA.Enabled or not SA.IsRandom then return end
    SA.RandomTimer = SA.RandomTimer + dt
    if SA.RandomTimer >= 0.1 then
        SA.RandomTimer = 0
        SA.RandomIdx = (SA.RandomIdx % #SA.RandomParts) + 1
        SA.TargetPart = SA.RandomParts[SA.RandomIdx]
    end
end)

do
    local FOV_Lines = {}
    local FOV_Rotation = 0
    local function ClearLines()
        for _, line in pairs(FOV_Lines) do if line then line:Remove() end end
        FOV_Lines = {}
    end
    RunService.RenderStepped:Connect(function(dt)
        if not SA.FOV_Visible then ClearLines(); return end
        local center
        if SA.FOV_PositionMode == "Mouse" then
            center = UIS:GetMouseLocation()
        else
            center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
        local sides = SA.FOV_Sides
        local radius = SA.FOV_Radius
        if SA.FOV_SpinEnabled then
            FOV_Rotation = FOV_Rotation + (SA.FOV_SpinSpeed * dt)
        end
        local base_rad = math.rad(FOV_Rotation)
        if #FOV_Lines ~= sides then
            ClearLines()
            for i = 1, sides do
                local l = Drawing.new("Line")
                l.Visible = true
                FOV_Lines[i] = l
            end
        end
        local verts = {}
        for i = 1, sides do
            local angle = base_rad + math.rad((i-1) * (360/sides))
            verts[i] = center + Vector2.new(math.cos(angle)*radius, math.sin(angle)*radius)
        end
        for i = 1, sides do
            local line = FOV_Lines[i]
            if line then
                line.Visible = true
                line.From = verts[i]
                line.To = verts[i+1] or verts[1]
                line.Thickness = 1.5
                line.Color = SA.FOV_Color
                line.Transparency = 1
            end
        end
    end)
end

RunService.RenderStepped:Connect(function()
    if WV.WorldTimeEnabled then WV_Lit.ClockTime = WV.WorldTime end
    if WV.AmbientEnabled then
        WV_Lit.Ambient = WV.AmbientColor
        WV_Lit.OutdoorAmbient = WV.OutdoorAmbientColor
    end
    if WV.LightingModeEnabled then
        pcall(function() WV_Lit.Technology = Enum.Technology[WV.LightingMode] end)
    end
    if WV.AtmosphereEnabled then
        local currentAtmo = WV_Lit:FindFirstChildOfClass("Atmosphere")
        if not currentAtmo then
            currentAtmo = WV_Atmo
            currentAtmo.Parent = WV_Lit
        end
        currentAtmo.Color = WV.AtmoColor
        currentAtmo.Decay = WV.AtmoDecay
        currentAtmo.Density = WV.AtmoDensity
        currentAtmo.Haze = WV.AtmoHaze
        currentAtmo.Glare = WV.AtmoGlare
        currentAtmo.Offset = WV.AtmoOffset
    else
        local currentAtmo = WV_Lit:FindFirstChildOfClass("Atmosphere")
        if currentAtmo and currentAtmo == WV_Atmo then
            currentAtmo.Parent = nil
        elseif currentAtmo then
            currentAtmo.Density = 0
        end
    end
    if WV.SkyboxEnabled then
        local currentSky = WV_Lit:FindFirstChildOfClass("Sky")
        if not currentSky then
            currentSky = WV_Sky
            currentSky.Parent = WV_Lit
        end
        local ids = WV_Skyboxes[WV.SkyboxType]
        if ids then
            currentSky.SkyboxBk = "rbxassetid://" .. ids.Bk
            currentSky.SkyboxDn = "rbxassetid://" .. ids.Dn
            currentSky.SkyboxFt = "rbxassetid://" .. ids.Ft
            currentSky.SkyboxLf = "rbxassetid://" .. ids.Lf
            currentSky.SkyboxRt = "rbxassetid://" .. ids.Rt
            currentSky.SkyboxUp = "rbxassetid://" .. ids.Up
        end
    else
        if WV_Sky.Parent == WV_Lit then WV_Sky.Parent = nil end
    end
    if WV.WeatherEnabled and WV_WeatherPart.Parent then
        WV_WeatherPart.CFrame = Camera.CFrame + Vector3.new(0,25,0)
    end
end)

local function ApplyFPSLock()
    if not FPS_Lock.Enabled then return end
    local ql = FPS_Lock.QualityLevel
    local qualityEnum = (ql <= 1) and Enum.QualityLevel.Low
        or (ql == 2) and Enum.QualityLevel.Medium
        or (ql == 3) and Enum.QualityLevel.High
        or Enum.QualityLevel.Max
    pcall(function()
        local settings = UserSettings():GetService("UserGameSettings")
        settings.SavedQualityLevel = qualityEnum
    end)
    if setfpscap then
        pcall(setfpscap, FPS_Lock.TargetFPS)
    end
end

local function RestoreFPS()
    if FPS_Lock.OriginalQuality then
        pcall(function()
            local settings = UserSettings():GetService("UserGameSettings")
            settings.SavedQualityLevel = FPS_Lock.OriginalQuality
        end)
    end
    if setfpscap then
        pcall(setfpscap, 1e9)
    end
end

local function CreateMusicSound()
    if MusicPlayer.Sound then
        pcall(function() MusicPlayer.Sound:Stop(); MusicPlayer.Sound:Destroy() end)
        MusicPlayer.Sound = nil
    end
    local track = MusicTracks[MusicPlayer.CurrentTrack]
    if not track then return end
    local s = Instance.new("Sound")
    s.SoundId = track.ID
    s.Volume = MusicPlayer.Volume
    s.Looped = MusicPlayer.LoopMode
    s.Parent = workspace
    s.Name = "CatMusicPlayer"
    s.Stopped:Connect(function()
        if MusicPlayer.Enabled and MusicPlayer.Playing and not MusicPlayer.LoopMode then
            task.wait(1)
            local nextIdx = (MusicPlayer.CurrentTrack % #MusicTracks) + 1
            SwitchTrack(nextIdx)
        end
    end)
    s.Ended:Connect(function()
        if MusicPlayer.Enabled and MusicPlayer.Playing and MusicPlayer.LoopMode then
            task.wait(0.5)
            pcall(function() s.TimePosition = 0; s:Play() end)
        end
    end)
    MusicPlayer.Sound = s
end

local function PlayMusic()
    if not MusicPlayer.Sound then CreateMusicSound() end
    if MusicPlayer.Sound then
        pcall(function()
            MusicPlayer.Sound.Volume = MusicPlayer.Volume
            MusicPlayer.Sound:Play()
            MusicPlayer.Playing = true
        end)
    end
end

local function StopMusic()
    if MusicPlayer.Sound then
        pcall(function() MusicPlayer.Sound:Stop() end)
        MusicPlayer.Playing = false
    end
end

local function SwitchTrack(idx)
    MusicPlayer.CurrentTrack = idx
    StopMusic()
    CreateMusicSound()
    if MusicPlayer.Enabled then PlayMusic() end
end

local function onCharacterAdded()
    FF_S.BodyProps, FF_S.ToolProps = {}, {}
    OriginalNeckC0, OriginalNeckC1 = nil, nil
    Invis_Track, Invis_SavedCF = nil, nil
    LF.Track1, LF.Track2, LF.Angle = nil, nil, 0
    FLY.Active = false
    FLY.LastSafeCF = nil
    FLY.PM = nil
    FLY.PC = nil
    FLY.AnimTrack = nil
    FlyRefreshBtn()
end
if LocalPlayer.Character then task.spawn(onCharacterAdded) end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

local function OnToolEquipped(tool)
    task.spawn(function()
        task.wait(0.15)
        if not FF_S.ToolEnabled then return end
        if not tool or not tool.Parent then return end
        for _, p in ipairs(tool:GetDescendants()) do
            if p:IsA("BasePart") then
                if not FF_S.ToolProps[p] then
                    FF_S.ToolProps[p] = {Material=p.Material, Color=p.Color}
                end
                p.Material = Enum.Material.ForceField
                p.Color = FF_S.Color
            end
        end
    end)
end
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") then OnToolEquipped(obj) end
    end)
end)
if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") then OnToolEquipped(obj) end
    end)
end

RunService:BindToRenderStep("InvisFix", 199, function()
    if not Invis_Enabled or DS.Enabled or LF.Enabled then
        Invis_SavedCF = nil
        return
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and Invis_SavedCF then
        hrp.CFrame = Invis_SavedCF
        Invis_SavedCF = nil
    end
    if Invis_Track then
        pcall(function() Invis_Track:Stop() end)
    end
    if char then
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") and (p.Name=="Head" or p.Name=="Torso" or p.Name:match("Arm") or p.Name:match("Leg")) then
                if p.Transparency ~= 0.5 then p.Transparency = 0.5 end
            end
        end
    end
end)

RunService:BindToRenderStep("LuanFeiAnimFix", 199, function()
    if LF.Enabled and not Invis_Enabled then
        if LF.Track1 then pcall(function() LF.Track1:Stop(0) end) end
        if LF.Track2 then pcall(function() LF.Track2:Stop(0) end) end
    end
end)

RunService:UnbindFromRenderStep("SmoothMovementCamera")
RunService:BindToRenderStep("SmoothMovementCamera", Enum.RenderPriority.Camera.Value+1, function(dt)
    if not MC.SmoothCam or not Camera then MC.SmoothPos=nil return end
    local cf = Camera.CFrame
    local pos = cf.Position
    if not MC.SmoothPos then MC.SmoothPos=pos
    else MC.SmoothPos=MC.SmoothPos:Lerp(pos, math.clamp(dt*MC.LerpSpeed,0,1)) end
    Camera.CFrame = CFrame.new(MC.SmoothPos, MC.SmoothPos+cf.LookVector)
end)

local function DoSkinUpdate()
    local now = tick()
    if now - FF_S.LastSkin < 1 then return end
    FF_S.LastSkin = now
    if FF_S.BodyEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetChildren()) do
                if IsBodyPart(p) then
                    if not FF_S.BodyProps[p] then
                        FF_S.BodyProps[p] = {Material=p.Material, Color=p.Color}
                        p.Material = Enum.Material.ForceField; p.Color = FF_S.Color
                    elseif p.Material ~= Enum.Material.ForceField then
                        p.Material = Enum.Material.ForceField; p.Color = FF_S.Color
                    end
                end
            end
        end
    end
    if FF_S.ToolEnabled then
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in ipairs(tool:GetDescendants()) do
                if p:IsA("BasePart") then
                    if not FF_S.ToolProps[p] then
                        FF_S.ToolProps[p] = {Material=p.Material, Color=p.Color}
                    end
                    p.Material = Enum.Material.ForceField
                    p.Color = FF_S.Color
                end
            end
        end
    end
end

local function DoDesyncLogic()
    if not DS.Enabled or Invis_Enabled then
        DS.AppliedOffset = Vector3.zero
        if not DS.Enabled and DS.Model.Parent then DS.Model.Parent=nil end
        return
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ragebotActive = false
    if RB_State and Valid_Pair and Valid_Pair.Target and Valid_Pair.Target.Character then
        local th = Valid_Pair.Target.Character:FindFirstChild("HumanoidRootPart")
        local tu = Valid_Pair.Target.Character:FindFirstChildOfClass("Humanoid")
        if th and tu and tu.Health > 0 then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("IsGun") then ragebotActive = true end
        end
    end
    if ragebotActive then
        if DS.Model.Parent then DS.Model.Parent=nil end
        DS.AppliedOffset = Vector3.zero; return
    end
    local clk = os.clock()
    local interval = DS.TPRate > 0 and (1/DS.TPRate) or 0
    if clk - DS.LastTPTime >= interval then
        DS.LastTPTime = clk
        DS.Y_Toggle = not DS.Y_Toggle
        local yOff = DS.Y_Toggle and (math.random(0,DS.Y*10)/10) or 0
        local tOff = Vector3.new((math.random()-0.5)*2*DS.X, yOff, (math.random()-0.5)*2*DS.Z)
        local p = RaycastParams.new()
        p.FilterDescendantsInstances = {char, DS.Model, Camera}
        p.FilterType = Enum.RaycastFilterType.Exclude
        local rr = workspace:Raycast(hrp.Position, tOff, p)
        if rr then DS.CurrentOffset = (rr.Position + rr.Normal*1.5) - hrp.Position
        else DS.CurrentOffset = tOff end
    end
    if DS.Visualize then
        if DS.Model.Parent ~= workspace.Terrain then DS.Model.Parent = workspace.Terrain end
        DS.Model:PivotTo(CFrame.new(hrp.Position + DS.CurrentOffset))
    else
        if DS.Model.Parent then DS.Model.Parent = nil end
    end
    DS.AppliedOffset = DS.CurrentOffset
end

local function DoLuanFeiLogic()
    if not LF.Enabled or Invis_Enabled then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local animator = hum:FindFirstChildOfClass("Animator") or hum
    if not LF.Track1 then
        pcall(function()
            LF.Track1 = animator:LoadAnimation(LF.Anim1)
            LF.Track1.Priority = Enum.AnimationPriority.Action4
        end)
    end
    if not LF.Track2 then
        pcall(function()
            LF.Track2 = animator:LoadAnimation(LF.Anim2)
            LF.Track2.Priority = Enum.AnimationPriority.Action4
            LF.Track2.Looped = true
        end)
    end
    if LF.Track1 then
        pcall(function()
            if not LF.Track1.IsPlaying then LF.Track1:Play() end
            LF.Track1:AdjustSpeed(0)
            LF.Track1.TimePosition = (LF.Track1.Length > 0 and LF.TimePosRatio * LF.Track1.Length) or LF.TimePosRatio
        end)
    end
    if LF.Track2 then
        pcall(function()
            if not LF.Track2.IsPlaying then LF.Track2:Play() end
            LF.Track2:AdjustSpeed(1)
        end)
    end
    LF.Angle = LF.Angle + LF.SpinSpeed
end

local function ApplySpoofs()
    local now = tick()
    if (DS.Enabled or LF.Enabled) and now - DS.LastFFlagTime >= 1 then
        DS.LastFFlagTime = now
        pcall(setfflag, "S2PhysicsSenderRate", "99999999")
    end
    DoDesyncLogic()
    DoLuanFeiLogic()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local spoofed = false
    local realCF = hrp.CFrame
    local newCF = realCF
    if DS.Enabled and DS.AppliedOffset ~= Vector3.zero then
        newCF = newCF + DS.AppliedOffset
        spoofed = true
    end
    if LF.Enabled and not Invis_Enabled then
        local smoothRotation = CFrame.Angles(math.rad(LF.Angle), math.rad(LF.Angle * 1.5), math.rad(LF.Angle * 0.8))
        newCF = newCF * smoothRotation
        spoofed = true
    end
    if spoofed then
        hrp.CFrame = newCF
        RunService:BindToRenderStep("RestoreSpoofCFrame", 199, function()
            if char and hrp and hrp.Parent then hrp.CFrame = realCF end
            if DS.Enabled then DS.AppliedOffset = Vector3.zero end
            RunService:UnbindFromRenderStep("RestoreSpoofCFrame")
        end)
    end
end

local function DoInvisible()
    if not Invis_Enabled or DS.Enabled or LF.Enabled then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum and hum.Health > 0) then return end
    if not Invis_Track then
        local anim = hum:FindFirstChildOfClass("Animator") or hum
        pcall(function()
            Invis_Track = anim:LoadAnimation(Invis_Anim)
            Invis_Track.Priority = Enum.AnimationPriority.Action
        end)
    end
    if Invis_Track then
        pcall(function()
            if not Invis_Track.IsPlaying then Invis_Track:Play() end
            Invis_Track:AdjustSpeed(0)
            Invis_Track.TimePosition = 0.3
        end)
    end
    Invis_SavedCF = hrp.CFrame
    hrp.CFrame = Invis_SavedCF + Vector3.new(0, -2, 0)
end

RunService.Heartbeat:Connect(function()
    DoSkinUpdate()
    ApplySpoofs()
    DoInvisible()
end)

RunService:BindToRenderStep("CAM_FOV_Enforce", Enum.RenderPriority.Camera.Value+2, function()
    if CAM_FOV then Camera.FieldOfView = CAM_FOV end
    if AMB.Enabled then
        local cc = Camera:FindFirstChild("CATColorCorr")
        if not cc then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "CATColorCorr"
            cc.Parent = Camera
        end
        cc.TintColor = AMB.Color
        cc.Brightness = AMB.Brightness
        cc.Contrast = AMB.Density * 0.3
        cc.Saturation = -(AMB.Density * 0.5)
        cc.Enabled = true
    else
        local cc = Camera:FindFirstChild("CATColorCorr")
        if cc then cc.Enabled = false end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if not HeadMode and not HandsModSelection then return end
    local char = LocalPlayer.Character
    if not (char and char.Parent) then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local head = char:FindFirstChild("Head")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if HeadMode then
        local neck = (head and head:FindFirstChild("Neck")) or (torso and torso:FindFirstChild("Neck"))
        if HeadMode == "Hide head" and neck then
            if not OriginalNeckC0 then OriginalNeckC0 = neck.C0; OriginalNeckC1 = neck.C1 end
            neck.C0 = AC.NeckC0
            neck.C1 = AC.NeckC1
        elseif (HeadMode == "Yaw head" or HeadMode == "Custom") and hrp then
            if not DoTweak_fn then
                for _, v in getgc(true) do
                    if type(v) == "function" then
                        local info = debug.getinfo(v)
                        if info and info.name == "DoTweak" and info.numparams == 11 then
                            DoTweak_fn = v; break
                        end
                    end
                end
            end
            if DoTweak_fn then
                local angle
                if HeadMode == "Yaw head" then
                    HeadYawTime = HeadYawTime + dt
                    angle = math.sin(HeadYawTime * HeadRotSpeed) * math.rad(HeadYaw)
                else
                    angle = math.rad(HeadCustomYaw)
                end
                local neckRot = CFrame.Angles(angle, 0, 0)
                pcall(DoTweak_fn,
                    char,
                    hrp.Position + Vector3.new(0, 10, 0),
                    hrp.Position,
                    neckRot.LookVector,
                    true, false, true, true, true,
                    9e9, true
                )
            end
        end
    end
    if HandsModSelection and torso then
        local tool = char:FindFirstChildOfClass("Tool")
        if HandsModSelection == "Hands up" and tool then
            local lS = torso:FindFirstChild("Left Shoulder")
            local rS = torso:FindFirstChild("Right Shoulder")
            if lS then lS.C0 = AC.LShoulder end
            if rS then rS.C0 = AC.RShoulder end
            for _, v in ipairs(tool:GetDescendants()) do
                if v.Name == "Mag6D_Torso" and v:IsA("Motor6D") then v.C0 = AC.Mag6D end
                if v.Name == "Tool6D_Torso" and v:IsA("Motor6D") then v.C0 = AC.Tool6D end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if SpeedState and hum.WalkSpeed ~= SpeedValue then hum.WalkSpeed = SpeedValue end
        if JumpState then
            if not hum.UseJumpPower then hum.UseJumpPower = true end
            if hum.JumpPower ~= JumpValue then hum.JumpPower = JumpValue end
        end
    end
    if not ShouldLock() then CL.CurrentTarget = nil; CL.LockedPart = nil; return end
    local origin = Camera.CFrame.Position
    CL.ScanTimer = CL.ScanTimer + dt
    if CL.ScanTimer > 0.1 then
        CL.ScanTimer = 0
        local best, bDist, b3D = nil, CL.FOV, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not table.find(WhiteList,p.Name) and (not CL.TargetOnly or table.find(TargetList,p.Name)) then
                    local ph = p.Character:FindFirstChild("Humanoid")
                    local pr = p.Character:FindFirstChild("HumanoidRootPart")
                    if ph and ph.Health > (CL.DownCheck and 15 or 0) and pr then
                        local sp, on = Camera:WorldToViewportPoint(pr.Position)
                        local sd = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        local d3 = (pr.Position - origin).Magnitude
                        if d3 < 15 then
                            if d3 < b3D and IsVisible(origin, pr) then b3D = d3; best = p.Character; bDist = 0 end
                        elseif on and sd < bDist and IsVisible(origin, pr) then bDist = sd; best = p.Character end
                    end
                end
            end
        end
        CL.CurrentTarget = best
    end
    if CL.CurrentTarget then
        if tick() - CL.LastSwitchTime >= CL.Delay then
            local vp = GetVisibleParts(origin, CL.CurrentTarget)
            if #vp > 0 then
                CL.LockedPart = vp[math.random(1,#vp)]
                CL.LastSwitchTime = tick()
            else
                CL.LockedPart = nil
            end
        end
        if CL.LockedPart then
            local jit = Vector3.new((math.random()-0.5)*CL.Shake, (math.random()-0.5)*CL.Shake, (math.random()-0.5)*CL.Shake)
            local tPos = CL.LockedPart.Position
            if CL.AutoPrediction then
                local ctool = char and char:FindFirstChildOfClass("Tool")
                if ctool ~= CL.CachedTool then
                    CL.CachedTool = ctool; CL.CachedVel = 1100
                    if ctool and ctool:FindFirstChild("Config") then
                        pcall(function()
                            local cfg = require(ctool.Config)
                            if cfg.BulletSettings and cfg.BulletSettings.Velocity then CL.CachedVel = cfg.BulletSettings.Velocity
                            elseif cfg.Velocity then CL.CachedVel = cfg.Velocity end
                        end)
                    end
                end
                tPos = tPos + (CL.LockedPart.AssemblyLinearVelocity * ((tPos - origin).Magnitude / CL.CachedVel))
            end
            Camera.CFrame = CFrame.lookAt(origin, origin + Camera.CFrame.LookVector:Lerp((tPos + jit - origin).Unit, CL.Power))
        end
    end
end)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Obsidian = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Obsidian.Options
Obsidian.ForceCheckbox = false
Obsidian.ShowToggleFrameInKeybinds = true

local hotkeyValues = {"LeftAlt","LeftShift","RightShift","LeftControl","RightControl","Q","E","R","F","X","C","V","鼠标右键","鼠标左键","鼠标中键"}
local hotkeyMap = {
    ["LeftAlt"]=Enum.KeyCode.LeftAlt, ["LeftShift"]=Enum.KeyCode.LeftShift,
    ["RightShift"]=Enum.KeyCode.RightShift, ["LeftControl"]=Enum.KeyCode.LeftControl,
    ["RightControl"]=Enum.KeyCode.RightControl, ["Q"]=Enum.KeyCode.Q, ["E"]=Enum.KeyCode.E,
    ["R"]=Enum.KeyCode.R, ["F"]=Enum.KeyCode.F, ["X"]=Enum.KeyCode.X, ["C"]=Enum.KeyCode.C,
    ["V"]=Enum.KeyCode.V, ["鼠标右键"]=Enum.UserInputType.MouseButton2,
    ["鼠标左键"]=Enum.UserInputType.MouseButton1, ["鼠标中键"]=Enum.UserInputType.MouseButton3,
}
local function getHotkeyName(k) for n,v in pairs(hotkeyMap) do if v==k then return n end end return "鼠标右键" end

local colorPresets = {"白色","红色","绿色","蓝色","黄色","青色","紫色","橙色","黑色"}
local colorValues = {
    ["白色"]=Color3.fromRGB(255,255,255),["红色"]=Color3.fromRGB(255,0,0),
    ["绿色"]=Color3.fromRGB(0,255,0),["蓝色"]=Color3.fromRGB(0,0,255),
    ["黄色"]=Color3.fromRGB(255,255,0),["青色"]=Color3.fromRGB(0,255,255),
    ["紫色"]=Color3.fromRGB(128,0,128),["橙色"]=Color3.fromRGB(255,165,0),
    ["黑色"]=Color3.fromRGB(0,0,0),
}
local function CreateColorDropdown(group, name, currentColor, callback, tooltip)
    local curName = "白色"
    for cname, col in pairs(colorValues) do
        if col.R == currentColor.R and col.G == currentColor.G and col.B == currentColor.B then
            curName = cname
            break
        end
    end
    group:AddDropdown("Color_" .. name, {
        Text = name,
        Values = colorPresets,
        Default = curName,
        Tooltip = tooltip or "",
        Callback = function(Value)
            if callback then callback(colorValues[Value]) end
        end
    })
end

local winTitle = "<font color='#FF69B4'>N</font><font color='#FF85C1'>E</font><font color='#FFA0D0'>R</font><font color='#87CEEB'>X</font> <font color='#00BFFF'>S</font><font color='#1E90FF'>C</font><font color='#4169E1'>R</font><font color='#0000CD'>I</font><font color='#00008B'>P</font><font color='#000080'>T</font>"
local winFooter = "not.cc | 作者：微醺"

local Window = Obsidian:CreateWindow({
    Title = winTitle,
    Footer = winFooter,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Combat = Window:AddTab("战斗", "crosshair"),
    Ragebot = Window:AddTab("Ragebot", "skull"),
    Visuals = Window:AddTab("视觉", "eye"),
    Player = Window:AddTab("玩家", "user"),
    Antis = Window:AddTab("反制", "shield"),
    Misc = Window:AddTab("杂项", "wrench"),
    PlayerList = Window:AddTab("玩家列表", "list"),
    Performance = Window:AddTab("性能", "activity"),
    Music = Window:AddTab("音乐", "music"),
    ["UI Settings"] = Window:AddTab("设置", "settings"),
}

local CombatGroup_CL = Tabs.Combat:AddLeftGroupbox("镜头锁定", "target")
CombatGroup_CL:AddToggle("CL.Enabled", {
    Text = "启用镜头锁定",
    Default = false,
    Callback = function(v) CL.Enabled = v end
})
CombatGroup_CL:AddKeyPicker("CL.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["CL.Enabled"] then Options["CL.Enabled"](v) end end
})
CombatGroup_CL:AddToggle("CL.TargetOnly", {
    Text = "仅目标",
    Default = false,
    Callback = function(v) CL.TargetOnly = v end
})
CombatGroup_CL:AddToggle("CL.AutoPrediction", {
    Text = "自动预判",
    Default = false,
    Callback = function(v) CL.AutoPrediction = v end
})
CombatGroup_CL:AddToggle("CL.DownCheck", {
    Text = "倒地检测",
    Default = false,
    Callback = function(v) CL.DownCheck = v end
})
CombatGroup_CL:AddSlider("CL.FOV", {
    Text = "视野范围",
    Default = 170,
    Min = 10,
    Max = 800,
    Rounding = 0,
    Callback = function(v) CL.FOV = v end
})
CombatGroup_CL:AddSlider("CL.Power", {
    Text = "强度",
    Default = 1,
    Min = 0.1,
    Max = 1,
    Rounding = 1,
    Callback = function(v) CL.Power = v end
})
CombatGroup_CL:AddSlider("CL.Shake", {
    Text = "抖动",
    Default = 0.2,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(v) CL.Shake = v end
})
CombatGroup_CL:AddSlider("CL.Delay", {
    Text = "切换延迟",
    Default = 0.1,
    Min = 0.1,
    Max = 1,
    Rounding = 1,
    Callback = function(v) CL.Delay = v end
})
CombatGroup_CL:AddDropdown("CL.TargetParts", {
    Text = "目标部位",
    Values = {"头部","躯干","左臂","右臂","左腿","右腿"},
    Multi = true,
    Default = {"头部","躯干","左臂","右臂","左腿","右腿"},
    Callback = function(v)
        local map = {["头部"]="Head",["躯干"]="Torso",["左臂"]="Left Arm",["右臂"]="Right Arm",["左腿"]="Left Leg",["右腿"]="Right Leg"}
        local t = {}
        for _, name in ipairs(v) do table.insert(t, map[name] or name) end
        CL.TargetParts = t
    end
})

local CombatGroup_SA = Tabs.Combat:AddLeftGroupbox("静默瞄准", "target")
CombatGroup_SA:AddToggle("SA.Enabled", {
    Text = "启用静默瞄准",
    Default = false,
    Callback = function(v) SA.Enabled = v end
})
CombatGroup_SA:AddKeyPicker("SA.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["SA.Enabled"] then Options["SA.Enabled"](v) end end
})
CombatGroup_SA:AddDropdown("SA.TargetPart", {
    Text = "目标部位",
    Values = {"随机","头部","躯干","左臂","右臂","左腿","右腿"},
    Default = "头部",
    Callback = function(v)
        local map = {["随机"]="Random",["头部"]="Head",["躯干"]="Torso",["左臂"]="Left Arm",["右臂"]="Right Arm",["左腿"]="Left Leg",["右腿"]="Right Leg"}
        local mapped = map[v] or "Head"
        if mapped == "Random" then
            SA.IsRandom = true
            SA.RandomIdx = 1
            SA.RandomTimer = 0
            SA.TargetPart = SA.RandomParts[1]
        else
            SA.IsRandom = false
            SA.TargetPart = mapped
        end
    end
})
CombatGroup_SA:AddSlider("SA.HitChance", {
    Text = "命中几率",
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Callback = function(v) SA.HitChance = v end
})
CombatGroup_SA:AddToggle("SA.WallCheck", {
    Text = "穿墙检测",
    Default = true,
    Callback = function(v) SA.WallCheck = v end
})
CombatGroup_SA:AddToggle("SA.FOV_Visible", {
    Text = "绘制视野",
    Default = false,
    Callback = function(v) SA.FOV_Visible = v end
})
CombatGroup_SA:AddKeyPicker("SA.FOV_Visible_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["SA.FOV_Visible"] then Options["SA.FOV_Visible"](v) end end
})
CreateColorDropdown(CombatGroup_SA, "SA.FOV_Color", Color3.fromRGB(255,0,0), function(v) SA.FOV_Color = v end)
CombatGroup_SA:AddDropdown("SA.FOV_PositionMode", {
    Text = "位置",
    Values = {"中心","鼠标"},
    Default = "中心",
    Callback = function(v) SA.FOV_PositionMode = (v == "中心") and "Center" or "Mouse" end
})
CombatGroup_SA:AddSlider("SA.FOV_Radius", {
    Text = "半径",
    Default = 100,
    Min = 10,
    Max = 600,
    Rounding = 0,
    Suffix = "px",
    Callback = function(v) SA.FOV_Radius = v end
})
CombatGroup_SA:AddSlider("SA.FOV_Sides", {
    Text = "边数",
    Default = 16,
    Min = 3,
    Max = 32,
    Rounding = 0,
    Callback = function(v) SA.FOV_Sides = math.floor(v) end
})
CombatGroup_SA:AddToggle("SA.FOV_SpinEnabled", {
    Text = "旋转",
    Default = false,
    Callback = function(v) SA.FOV_SpinEnabled = v end
})
CombatGroup_SA:AddSlider("SA.FOV_SpinSpeed", {
    Text = "旋转速度",
    Default = 50,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Callback = function(v) SA.FOV_SpinSpeed = v end
})

local CombatGroup_MA = Tabs.Combat:AddLeftGroupbox("近战光环", "target")
CombatGroup_MA:AddToggle("MA.Enabled", {
    Text = "启用近战光环",
    Default = false,
    Callback = function(v) MA.Enabled = v; if v then StartMeleeLoop() end end
})
CombatGroup_MA:AddKeyPicker("MA.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["MA.Enabled"] then Options["MA.Enabled"](v) end end
})
CombatGroup_MA:AddToggle("MA.TargetOnly", {
    Text = "仅目标",
    Default = false,
    Callback = function(v) MA.TargetOnly = v end
})
CombatGroup_MA:AddToggle("MA.DownCheck", {
    Text = "倒地检测",
    Default = false,
    Callback = function(v) MA.DownCheck = v end
})
CombatGroup_MA:AddSlider("MA.Distance", {
    Text = "距离",
    Default = 20,
    Min = 5,
    Max = 25,
    Rounding = 0,
    Suffix = " 单位",
    Callback = function(v) MA.Distance = v end
})
CombatGroup_MA:AddToggle("MA.ShowAnim", {
    Text = "显示动画",
    Default = true,
    Callback = function(v) MA.ShowAnim = v end
})
CombatGroup_MA:AddDropdown("MA.TargetPart", {
    Text = "目标部位",
    Values = {"随机","头部","躯干","左臂","右臂","左腿","右腿"},
    Default = "随机",
    Callback = function(v)
        local map = {["随机"]="Random",["头部"]="Head",["躯干"]="Torso",["左臂"]="Left Arm",["右臂"]="Right Arm",["左腿"]="Left Leg",["右腿"]="Right Leg"}
        MA.TargetPart = map[v] or "Random"
    end
})

local CombatGroup_Movement = Tabs.Combat:AddLeftGroupbox("移动", "activity")
CombatGroup_Movement:AddToggle("SpeedState", {
    Text = "步行速度",
    Default = false,
    Callback = function(v) SpeedState = v end
})
CombatGroup_Movement:AddKeyPicker("SpeedState_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["SpeedState"] then Options["SpeedState"](v) end end
})
CombatGroup_Movement:AddSlider("SpeedValue", {
    Text = "速度数值",
    Default = 33.5,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(v) SpeedValue = v end
})
CombatGroup_Movement:AddToggle("JumpState", {
    Text = "跳跃力度",
    Default = false,
    Callback = function(v) JumpState = v end
})
CombatGroup_Movement:AddKeyPicker("JumpState_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["JumpState"] then Options["JumpState"](v) end end
})
CombatGroup_Movement:AddSlider("JumpValue", {
    Text = "跳跃数值",
    Default = 73,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(v) JumpValue = v end
})
CombatGroup_Movement:AddToggle("NoFallEnabled", {
    Text = "无坠落",
    Default = false,
    Callback = function(v) NoFallEnabled = v end
})
CombatGroup_Movement:AddKeyPicker("NoFallEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["NoFallEnabled"] then Options["NoFallEnabled"](v) end end
})
CombatGroup_Movement:AddToggle("FLY.Enabled", {
    Text = "飞行",
    Default = false,
    Callback = function(v)
        FLY.Enabled = v
        if FLY.MobileMode then
            if v then FlyCreateUI(); FlyOn() else FlyOff(); FlyDestroyUI() end
        else
            if v then FlyOn() else FlyOff() end
        end
    end
})
CombatGroup_Movement:AddKeyPicker("FLY.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["FLY.Enabled"] then Options["FLY.Enabled"](v) end end
})
CombatGroup_Movement:AddSlider("FLY.Speed", {
    Text = "飞行速度",
    Default = 60,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Callback = function(v) FLY.Speed = v end
})
CombatGroup_Movement:AddToggle("FLY.MobileMode", {
    Text = "移动端模式",
    Default = false,
    Callback = function(v) FLY.MobileMode = v end
})
CombatGroup_Movement:AddToggle("InfStaminaEnabled", {
    Text = "无限体力",
    Default = false,
    Callback = function(v) InfStaminaEnabled = v end
})
CombatGroup_Movement:AddKeyPicker("InfStaminaEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["InfStaminaEnabled"] then Options["InfStaminaEnabled"](v) end end
})

local CombatGroup_Rage = Tabs.Combat:AddRightGroupbox("Ragebot", "skull")
CombatGroup_Rage:AddToggle("RB_State", {
    Text = "启用暴力",
    Default = false,
    Callback = function(v) RB_State = v end
})
CombatGroup_Rage:AddKeyPicker("RB_State_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["RB_State"] then Options["RB_State"](v) end end
})
CombatGroup_Rage:AddToggle("RF_State", {
    Text = "快速射击",
    Default = false,
    Callback = function(v) RF_State = v end
})
CombatGroup_Rage:AddKeyPicker("RF_State_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["RF_State"] then Options["RF_State"](v) end end
})
CombatGroup_Rage:AddToggle("AutoReload", {
    Text = "自动换弹",
    Default = false,
    Callback = function(v) AutoReload = v; if v then AutoReloadSetup() else clearReloadConnections() end end
})
CombatGroup_Rage:AddKeyPicker("AutoReload_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["AutoReload"] then Options["AutoReload"](v) end end
})
CombatGroup_Rage:AddToggle("DownCheck", {
    Text = "倒地检测",
    Default = false,
    Callback = function(v) DownCheck = v end
})
CombatGroup_Rage:AddKeyPicker("DownCheck_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["DownCheck"] then Options["DownCheck"](v) end end
})
CombatGroup_Rage:AddSlider("WB.Threshold", {
    Text = "最大缓存",
    Default = 0.5,
    Min = 0.1,
    Max = 25,
    Rounding = 2,
    Callback = function(v) WB.Threshold = v end
})
CombatGroup_Rage:AddSlider("Origin_Radius", {
    Text = "原点半径",
    Default = 18.50,
    Min = 0.1,
    Max = 20,
    Rounding = 2,
    Callback = function(v) Origin_Radius = v end
})
CombatGroup_Rage:AddSlider("Origin_Scans", {
    Text = "原点扫描",
    Default = 24,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(v) Origin_Scans = math.floor(v) end
})
CombatGroup_Rage:AddSlider("ScanRate", {
    Text = "扫描速率",
    Default = 14,
    Min = 1,
    Max = 60,
    Rounding = 0,
    Callback = function(v) ScanRate = math.floor(v) end
})
CombatGroup_Rage:AddSlider("Hit_Radius", {
    Text = "命中半径",
    Default = 23.50,
    Min = 0.1,
    Max = 25,
    Rounding = 2,
    Callback = function(v) Hit_Radius = v end
})
CombatGroup_Rage:AddSlider("Hit_Scans", {
    Text = "命中扫描",
    Default = 24,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(v) Hit_Scans = math.floor(v) end
})
CombatGroup_Rage:AddDropdown("TargetMode", {
    Text = "目标模式",
    Values = {"最近","鼠标","中心","锁定"},
    Default = "最近",
    Callback = function(v)
        local map = {["最近"]="Near",["鼠标"]="Mouse",["中心"]="Center",["锁定"]="Lock"}
        TargetMode = map[v] or "Near"
    end
})
CombatGroup_Rage:AddDropdown("HitSoundSelection", {
    Text = "命中音效",
    Values = {"无","Skeet","Neverlose","Gamesense"},
    Default = "无",
    Callback = function(v)
        local map = {["无"]="None",["Skeet"]="Skeet",["Neverlose"]="Neverlose",["Gamesense"]="Gamesense"}
        HitSoundSelection = map[v] or "None"
    end
})
CombatGroup_Rage:AddToggle("RB_LO.Enabled", {
    Text = "启用远距离优化",
    Default = true,
    Callback = function(v) RB_LO.Enabled = v end
})
CombatGroup_Rage:AddKeyPicker("RB_LO.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["RB_LO.Enabled"] then Options["RB_LO.Enabled"](v) end end
})
CombatGroup_Rage:AddSlider("RB_LO.LongDistThreshold", {
    Text = "远距离阈值",
    Default = 150,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Callback = function(v) RB_LO.LongDistThreshold = v end
})
CombatGroup_Rage:AddSlider("RB_LO.MaxDistThreshold", {
    Text = "最大有效距离",
    Default = 800,
    Min = 300,
    Max = 1500,
    Rounding = 0,
    Callback = function(v) RB_LO.MaxDistThreshold = v end
})
CombatGroup_Rage:AddToggle("RB_LO.DynamicRadiusScale", {
    Text = "动态半径缩放",
    Default = true,
    Callback = function(v) RB_LO.DynamicRadiusScale = v end
})
CombatGroup_Rage:AddToggle("RB_LO.PredictionEnabled", {
    Text = "目标预测",
    Default = true,
    Callback = function(v) RB_LO.PredictionEnabled = v end
})
CombatGroup_Rage:AddToggle("RB_LO.BulletDropComp", {
    Text = "子弹下坠补偿",
    Default = true,
    Callback = function(v) RB_LO.BulletDropComp = v end
})
CombatGroup_Rage:AddToggle("RB_LO.DistCompensation", {
    Text = "距离补偿",
    Default = true,
    Callback = function(v) RB_LO.DistCompensation = v end
})

task.spawn(function()
    task.wait(1)
    local RageGroup_Silent = Tabs.Ragebot:AddLeftGroupbox("静默自瞄 (勿用)", "target")
    RageGroup_Silent:AddToggle("SilentAimToggle", {
        Text = "启用静默自瞄",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Silent:AddDropdown("SilentAimMode", {
        Text = "模式",
        Values = {"自动", "热键"},
        Default = "自动",
        Callback = function(v) end
    })
    RageGroup_Silent:AddDropdown("SilentAimHoldKey", {
        Text = "热键",
        Values = hotkeyValues,
        Default = "鼠标右键",
        Callback = function(v) end
    })
    RageGroup_Silent:AddDropdown("SilentAimToggleKeyDropdown", {
        Text = "快捷键",
        Values = {"None","LeftAlt","LeftShift","RightShift","LeftControl","RightControl","Q","E","R","F","X","C","V"},
        Default = "None",
        Callback = function(v) end
    })
    RageGroup_Silent:AddToggle("WallbangToggleRage", {
        Text = "穿墙",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Silent:AddToggle("DynamicMissToggle", {
        Text = "动态未命中",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Silent:AddSlider("BaseHitChanceSlider", {
        Text = "基础命中率",
        Default = 100,
        Min = 1,
        Max = 100,
        Rounding = 0,
        Suffix = "%",
        Callback = function(v) end
    })

    local RageGroup_Aimlock = Tabs.Ragebot:AddLeftGroupbox("自瞄锁", "crosshair")
    RageGroup_Aimlock:AddToggle("AimlockToggle", {
        Text = "启用自瞄锁",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Aimlock:AddDropdown("AimlockMode", {
        Text = "模式",
        Values = {"自动", "热键"},
        Default = "自动",
        Callback = function(v) end
    })
    RageGroup_Aimlock:AddDropdown("AimlockHotkey", {
        Text = "热键",
        Values = hotkeyValues,
        Default = "鼠标右键",
        Callback = function(v) end
    })
    RageGroup_Aimlock:AddDropdown("AimlockToggleKeyDropdown", {
        Text = "快捷键",
        Values = {"None","LeftAlt","LeftShift","RightShift","LeftControl","RightControl","Q","E","R","F","X","C","V"},
        Default = "None",
        Callback = function(v) end
    })
    RageGroup_Aimlock:AddDropdown("AimlockMethodDropdown", {
        Text = "方法",
        Values = {"Raw Mouse","Camera Lerp"},
        Default = "Raw Mouse",
        Callback = function(v) end
    })
    RageGroup_Aimlock:AddSlider("AimlockFovSlider", {
        Text = "FOV",
        Default = 150,
        Min = 10,
        Max = 1000,
        Rounding = 0,
        Callback = function(v) end
    })
    RageGroup_Aimlock:AddSlider("AimSmoothnessSlider", {
        Text = "平滑度",
        Default = 2,
        Min = 1,
        Max = 10,
        Rounding = 0,
        Callback = function(v) end
    })
    RageGroup_Aimlock:AddSlider("AimJitterSlider", {
        Text = "抖动",
        Default = 10,
        Min = 0,
        Max = 50,
        Rounding = 0,
        Suffix = "%",
        Callback = function(v) end
    })
    RageGroup_Aimlock:AddToggle("FlickBotToggle", {
        Text = "Flick Bot",
        Default = false,
        Callback = function(v) end
    })

    local RageGroup_Target = Tabs.Ragebot:AddLeftGroupbox("瞄准设置", "target")
    RageGroup_Target:AddDropdown("TargetPartDropdownRage", {
        Text = "目标部位",
        Values = {"Head","UpperTorso","LowerTorso","Random Part"},
        Default = "Head",
        Callback = function(v) end
    })
    RageGroup_Target:AddToggle("RandomPartToggle", {
        Text = "随机部位",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Target:AddToggle("FullFov360Toggle", {
        Text = "360度FOV",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Target:AddToggle("AimWallCheckToggleRage", {
        Text = "墙壁检测",
        Default = true,
        Callback = function(v) end
    })
    RageGroup_Target:AddToggle("TeamCheckToggleRage", {
        Text = "团队检查",
        Default = true,
        Callback = function(v) end
    })
    RageGroup_Target:AddToggle("ShowFovCircleToggleRage", {
        Text = "显示FOV圈",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Target:AddSlider("FovSizeSliderRage", {
        Text = "FOV大小",
        Default = 150,
        Min = 50,
        Max = 1000,
        Rounding = 0,
        Callback = function(v) end
    })

    local RageGroup_Weapon = Tabs.Ragebot:AddRightGroupbox("武器修改", "swords")
    RageGroup_Weapon:AddToggle("RapidFireToggle", {
        Text = "快速射击",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Weapon:AddSlider("RapidFireDelaySlider", {
        Text = "延迟(ms)",
        Default = 50,
        Min = 1,
        Max = 500,
        Rounding = 0,
        Callback = function(v) end
    })
    RageGroup_Weapon:AddToggle("RapidFireAutoClickToggle", {
        Text = "快速射击时自动连点",
        Default = true,
        Callback = function(v) end
    })
    RageGroup_Weapon:AddToggle("InstantReloadToggle", {
        Text = "瞬间换弹 (未修复)",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Weapon:AddToggle("InstaEquipToggle", {
        Text = "瞬间装备 (未修复)",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Weapon:AddToggle("AutoClickerToggle", {
        Text = "自动连点",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_Weapon:AddSlider("AutoClickDelaySlider", {
        Text = "延迟(ms)",
        Default = 50,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Callback = function(v) end
    })

    local RageGroup_RCS = Tabs.Ragebot:AddRightGroupbox("后坐力控制", "activity")
    RageGroup_RCS:AddToggle("RcsToggle", {
        Text = "启用 RCS",
        Default = false,
        Callback = function(v) end
    })
    RageGroup_RCS:AddSlider("RcsStrengthSlider", {
        Text = "强度",
        Default = 50,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Suffix = "%",
        Callback = function(v) end
    })
    RageGroup_RCS:AddSlider("RcsDelaySlider", {
        Text = "延迟(ms)",
        Default = 0,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Callback = function(v) end
    })
end)

local VisGroup_ESP = Tabs.Visuals:AddLeftGroupbox("玩家 ESP", "eye")
VisGroup_ESP:AddToggle("NametagEnabled", {
    Text = "名牌",
    Default = false,
    Callback = function(v) NametagEnabled = v end
})
VisGroup_ESP:AddKeyPicker("NametagEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["NametagEnabled"] then Options["NametagEnabled"](v) end end
})
VisGroup_ESP:AddToggle("DistanceEnabled", {
    Text = "距离",
    Default = false,
    Callback = function(v) DistanceEnabled = v end
})
VisGroup_ESP:AddKeyPicker("DistanceEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["DistanceEnabled"] then Options["DistanceEnabled"](v) end end
})
VisGroup_ESP:AddToggle("HealthEnabled", {
    Text = "生命值",
    Default = false,
    Callback = function(v) HealthEnabled = v end
})
VisGroup_ESP:AddKeyPicker("HealthEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["HealthEnabled"] then Options["HealthEnabled"](v) end end
})
VisGroup_ESP:AddToggle("SafeChamsEnabled", {
    Text = "保险箱高亮",
    Default = false,
    Callback = function(v) SafeChamsEnabled = v; if v then StartSafeChams() end end
})
VisGroup_ESP:AddKeyPicker("SafeChamsEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["SafeChamsEnabled"] then Options["SafeChamsEnabled"](v) end end
})
VisGroup_ESP:AddToggle("espSets.enabled", {
    Text = "高亮",
    Default = false,
    Callback = function(v) espSets.enabled = v end
})
VisGroup_ESP:AddKeyPicker("espSets.enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["espSets.enabled"] then Options["espSets.enabled"](v) end end
})
CreateColorDropdown(VisGroup_ESP, "espSets.outCol", Color3.fromRGB(255,255,255), function(v) espSets.outCol = v end)
CreateColorDropdown(VisGroup_ESP, "espSets.inCol", Color3.fromRGB(0,0,0), function(v) espSets.inCol = v end)
VisGroup_ESP:AddToggle("espSets.targetOnly", {
    Text = "仅目标",
    Default = false,
    Callback = function(v) espSets.targetOnly = v end
})
VisGroup_ESP:AddToggle("espSets.outline", {
    Text = "轮廓",
    Default = true,
    Callback = function(v) espSets.outline = v end
})
VisGroup_ESP:AddToggle("espSets.inline", {
    Text = "内部填充",
    Default = true,
    Callback = function(v) espSets.inline = v end
})
VisGroup_ESP:AddSlider("espSets.outSize", {
    Text = "轮廓大小",
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Callback = function(v) espSets.outSize = v end
})
VisGroup_ESP:AddSlider("espSets.inSize", {
    Text = "内部填充大小",
    Default = 0.05,
    Min = 0.01,
    Max = 0.5,
    Rounding = 2,
    Callback = function(v) espSets.inSize = v end
})
VisGroup_ESP:AddToggle("TR.Enabled", {
    Text = "弹道追踪",
    Default = false,
    Callback = function(v) TR.Enabled = v end
})
VisGroup_ESP:AddKeyPicker("TR.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["TR.Enabled"] then Options["TR.Enabled"](v) end end
})
CreateColorDropdown(VisGroup_ESP, "TR.Color", Color3.fromRGB(255,255,255), function(v) TR.Color = v end)
VisGroup_ESP:AddSlider("TR.Size", {
    Text = "追踪大小",
    Default = 1,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Callback = function(v) TR.Size = v end
})
VisGroup_ESP:AddToggle("HitLogEnabled", {
    Text = "命中日志",
    Default = false,
    Callback = function(v) HitLogEnabled = v; if HitLog.Gui then HitLog.Gui.Enabled = v end end
})
VisGroup_ESP:AddKeyPicker("HitLogEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["HitLogEnabled"] then Options["HitLogEnabled"](v) end end
})

local VisGroup_World = Tabs.Visuals:AddRightGroupbox("世界视觉", "globe")
VisGroup_World:AddToggle("WV.LightingModeEnabled", {
    Text = "光照模式",
    Default = false,
    Callback = function(v) WV.LightingModeEnabled = v end
})
VisGroup_World:AddDropdown("WV.LightingMode", {
    Text = "技术",
    Values = {"兼容","阴影贴图","体素","未来"},
    Default = "阴影贴图",
    Callback = function(v)
        local map = {["兼容"]="Compatible",["阴影贴图"]="ShadowMap",["体素"]="Voxel",["未来"]="Future"}
        WV.LightingMode = map[v] or "ShadowMap"
    end
})
VisGroup_World:AddToggle("WV.WorldTimeEnabled", {
    Text = "世界时间",
    Default = false,
    Callback = function(v) WV.WorldTimeEnabled = v end
})
VisGroup_World:AddSlider("WV.WorldTime", {
    Text = "时间",
    Default = 12,
    Min = 0,
    Max = 24,
    Rounding = 1,
    Callback = function(v) WV.WorldTime = v end
})
VisGroup_World:AddToggle("WV.AmbientEnabled", {
    Text = "自定义环境光",
    Default = false,
    Callback = function(v) WV.AmbientEnabled = v end
})
CreateColorDropdown(VisGroup_World, "WV.AmbientColor", Color3.fromRGB(255,255,255), function(v) WV.AmbientColor = v end)
CreateColorDropdown(VisGroup_World, "WV.OutdoorAmbientColor", Color3.fromRGB(255,255,255), function(v) WV.OutdoorAmbientColor = v end)
VisGroup_World:AddToggle("WV.SkyboxEnabled", {
    Text = "自定义天空盒",
    Default = false,
    Callback = function(v) WV.SkyboxEnabled = v end
})
VisGroup_World:AddDropdown("WV.SkyboxType", {
    Text = "天空盒主题",
    Values = {"黑色风暴","蓝色太空","写实","暴风雨","粉色"},
    Default = "黑色风暴",
    Callback = function(v)
        local map = {["黑色风暴"]="Black Storm",["蓝色太空"]="Blue Space",["写实"]="Realistic",["暴风雨"]="Stormy",["粉色"]="Pink"}
        WV.SkyboxType = map[v] or "Black Storm"
    end
})
VisGroup_World:AddToggle("WV.WeatherEnabled", {
    Text = "天气",
    Default = false,
    Callback = function(v) WV.WeatherEnabled = v; WV_WeatherPart.Parent = v and Workspace or nil end
})
CreateColorDropdown(VisGroup_World, "WV.WeatherColor", Color3.fromRGB(255,255,255), function(v) WV.WeatherColor = v; WV_Emitter.Color=ColorSequence.new(v) end)
VisGroup_World:AddDropdown("WV.WeatherType", {
    Text = "天气类型",
    Values = {"雨","雪"},
    Default = "雨",
    Callback = function(v)
        WV.WeatherType = v == "雨" and "Rain" or "Snow"
        if v=="雨" then WV_Emitter.Texture="rbxassetid://1822883048"; WV_Emitter.Speed=NumberRange.new(60); WV_Emitter.Size=NumberSequence.new(10)
        else WV_Emitter.Texture="http://www.roblox.com/asset/?id=99851851"; WV_Emitter.Speed=NumberRange.new(30); WV_Emitter.Size=NumberSequence.new(0.35) end
    end
})
VisGroup_World:AddSlider("WV.WeatherRate", {
    Text = "天气速率",
    Default = 600,
    Min = 100,
    Max = 2000,
    Rounding = 0,
    Callback = function(v) WV_Emitter.Rate = v end
})
VisGroup_World:AddToggle("WV.AtmosphereEnabled", {
    Text = "大气",
    Default = false,
    Callback = function(v) WV.AtmosphereEnabled = v end
})
CreateColorDropdown(VisGroup_World, "WV.AtmoColor", Color3.fromRGB(255,255,255), function(v) WV.AtmoColor = v end)
CreateColorDropdown(VisGroup_World, "WV.AtmoDecay", Color3.fromRGB(120,120,120), function(v) WV.AtmoDecay = v end)
VisGroup_World:AddSlider("WV.AtmoDensity", {
    Text = "密度",
    Default = 0.35,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v) WV.AtmoDensity = v end
})
VisGroup_World:AddSlider("WV.AtmoHaze", {
    Text = "雾霾",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(v) WV.AtmoHaze = v end
})
VisGroup_World:AddSlider("WV.AtmoGlare", {
    Text = "眩光",
    Default = 10,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(v) WV.AtmoGlare = v end
})
VisGroup_World:AddToggle("WV.BGSound", {
    Text = "背景噪音",
    Default = false,
    Callback = function(v) if v then WV_BGSound:Play() else WV_BGSound:Stop() end end
})
VisGroup_World:AddDropdown("WV.BGSoundTrack", {
    Text = "音轨",
    Values = {"冬日寒风","雷暴","小雨","夜晚","白天"},
    Default = "夜晚",
    Callback = function(v)
        local map = {["冬日寒风"]="Windy Winter",["雷暴"]="Thunderstorm",["小雨"]="Light Rain",["夜晚"]="Night",["白天"]="Day"}
        local track = map[v] or "Night"
        WV_BGSound.SoundId = WV_Sounds[track]
        if WV_BGSound.IsPlaying then WV_BGSound:Stop(); WV_BGSound:Play() end
    end
})
VisGroup_World:AddSlider("WV.BGVolume", {
    Text = "音量",
    Default = 25,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(v) WV_BGSound.Volume = v/100 end
})

local VisGroup_Skin = Tabs.Visuals:AddLeftGroupbox("皮肤", "palette")
VisGroup_Skin:AddToggle("FF_S.BodyEnabled", {
    Text = "力场身体",
    Default = false,
    Callback = function(v) FF_S.BodyEnabled = v end
})
VisGroup_Skin:AddKeyPicker("FF_S.BodyEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["FF_S.BodyEnabled"] then Options["FF_S.BodyEnabled"](v) end end
})
CreateColorDropdown(VisGroup_Skin, "FF_S.Color", Color3.fromRGB(255,255,255), function(v) FF_S.Color = v end)
VisGroup_Skin:AddToggle("FF_S.ToolEnabled", {
    Text = "力场工具",
    Default = false,
    Callback = function(v) FF_S.ToolEnabled = v end
})
VisGroup_Skin:AddKeyPicker("FF_S.ToolEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["FF_S.ToolEnabled"] then Options["FF_S.ToolEnabled"](v) end end
})
VisGroup_Skin:AddToggle("AMB.Enabled", {
    Text = "环境",
    Default = false,
    Callback = function(v) AMB.Enabled = v end
})
CreateColorDropdown(VisGroup_Skin, "AMB.Color", Color3.fromRGB(190,220,255), function(v) AMB.Color = v end)
VisGroup_Skin:AddSlider("AMB.Density", {
    Text = "雾密度",
    Default = 0.45,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v) AMB.Density = v end
})
VisGroup_Skin:AddSlider("AMB.Brightness", {
    Text = "亮度",
    Default = 0.15,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Callback = function(v) AMB.Brightness = v end
})
VisGroup_Skin:AddSlider("CAM_FOV", {
    Text = "视野范围",
    Default = 70,
    Min = 50,
    Max = 180,
    Rounding = 0,
    Callback = function(v) CAM_FOV = math.floor(v); Camera.FieldOfView = CAM_FOV end
})
VisGroup_Skin:AddSlider("LocalPlayer.CameraMaxZoomDistance", {
    Text = "相机距离",
    Default = 10,
    Min = 1,
    Max = 40,
    Rounding = 0,
    Callback = function(v) LocalPlayer.CameraMaxZoomDistance = v end
})

local PlayerGroup = Tabs.Player:AddLeftGroupbox("移动", "activity")
PlayerGroup:AddToggle("SpeedState", {
    Text = "步行速度",
    Default = false,
    Callback = function(v) SpeedState = v end
})
PlayerGroup:AddKeyPicker("SpeedState_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["SpeedState"] then Options["SpeedState"](v) end end
})
PlayerGroup:AddSlider("SpeedValue", {
    Text = "速度数值",
    Default = 33.5,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(v) SpeedValue = v end
})
PlayerGroup:AddToggle("JumpState", {
    Text = "跳跃力度",
    Default = false,
    Callback = function(v) JumpState = v end
})
PlayerGroup:AddKeyPicker("JumpState_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["JumpState"] then Options["JumpState"](v) end end
})
PlayerGroup:AddSlider("JumpValue", {
    Text = "跳跃数值",
    Default = 73,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(v) JumpValue = v end
})
PlayerGroup:AddToggle("NoFallEnabled", {
    Text = "无坠落",
    Default = false,
    Callback = function(v) NoFallEnabled = v end
})
PlayerGroup:AddKeyPicker("NoFallEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["NoFallEnabled"] then Options["NoFallEnabled"](v) end end
})
PlayerGroup:AddToggle("FLY.Enabled", {
    Text = "飞行",
    Default = false,
    Callback = function(v) FLY.Enabled = v; if v then FlyOn() else FlyOff() end end
})
PlayerGroup:AddKeyPicker("FLY.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["FLY.Enabled"] then Options["FLY.Enabled"](v) end end
})
PlayerGroup:AddSlider("FLY.Speed", {
    Text = "飞行速度",
    Default = 60,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Callback = function(v) FLY.Speed = v end
})
PlayerGroup:AddToggle("FLY.MobileMode", {
    Text = "移动端模式",
    Default = false,
    Callback = function(v) FLY.MobileMode = v end
})
PlayerGroup:AddToggle("InfStaminaEnabled", {
    Text = "无限体力",
    Default = false,
    Callback = function(v) InfStaminaEnabled = v end
})
PlayerGroup:AddKeyPicker("InfStaminaEnabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["InfStaminaEnabled"] then Options["InfStaminaEnabled"](v) end end
})

local AntisGroup = Tabs.Antis:AddLeftGroupbox("反制", "shield")
AntisGroup:AddDropdown("HeadMode", {
    Text = "头部模式",
    Values = {"隐藏头部","偏航头部","自定义"},
    Default = "隐藏头部",
    Callback = function(v)
        local map = {["隐藏头部"]="Hide head",["偏航头部"]="Yaw head",["自定义"]="Custom"}
        local mapped = map[v]
        HeadMode = mapped
    end
})
AntisGroup:AddSlider("HeadCustomYaw", {
    Text = "自定义偏航",
    Default = 30,
    Min = -90,
    Max = 90,
    Rounding = 1,
    Callback = function(v) HeadCustomYaw = v end
})
AntisGroup:AddSlider("HeadRotSpeed", {
    Text = "旋转速度",
    Default = 30,
    Min = -50,
    Max = 50,
    Rounding = 1,
    Callback = function(v) HeadRotSpeed = v end
})
AntisGroup:AddDropdown("HandsModSelection", {
    Text = "手部模式",
    Values = {"举手","张开双手"},
    Default = "举手",
    Callback = function(v)
        HandsModSelection = (v == "举手") and "Hands up" or "Open hands"
    end
})
AntisGroup:AddToggle("LF.Enabled", {
    Text = "乱飞",
    Default = false,
    Callback = function(v) LF.Enabled = v end
})
AntisGroup:AddKeyPicker("LF.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["LF.Enabled"] then Options["LF.Enabled"](v) end end
})
AntisGroup:AddToggle("Invis_Enabled", {
    Text = "隐身",
    Default = false,
    Callback = function(v) Invis_Enabled = v end
})
AntisGroup:AddKeyPicker("Invis_Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["Invis_Enabled"] then Options["Invis_Enabled"](v) end end
})
AntisGroup:AddToggle("DS.Enabled", {
    Text = "速度不同步",
    Default = false,
    Callback = function(v) DS.Enabled = v end
})
AntisGroup:AddKeyPicker("DS.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["DS.Enabled"] then Options["DS.Enabled"](v) end end
})
AntisGroup:AddToggle("DS.Visualize", {
    Text = "可视化",
    Default = true,
    Callback = function(v) DS.Visualize = v end
})
AntisGroup:AddSlider("DS.TPRate", {
    Text = "TP速率",
    Default = 60,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Callback = function(v) DS.TPRate = v end
})
AntisGroup:AddSlider("DS.X", {
    Text = "X偏移",
    Default = 8.5,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Callback = function(v) DS.X = v end
})
AntisGroup:AddSlider("DS.Y", {
    Text = "Y偏移",
    Default = 3,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Callback = function(v) DS.Y = v end
})
AntisGroup:AddSlider("DS.Z", {
    Text = "Z偏移",
    Default = 8.5,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Callback = function(v) DS.Z = v end
})

local MiscGroup = Tabs.Misc:AddLeftGroupbox("杂项", "wrench")
MiscGroup:AddToggle("MC.AntiShift", {
    Text = "反自动Shift锁定",
    Default = false,
    Callback = function(v) MC.AntiShift = v end
})
MiscGroup:AddKeyPicker("MC.AntiShift_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["MC.AntiShift"] then Options["MC.AntiShift"](v) end end
})
MiscGroup:AddSlider("MC.ShiftDelay", {
    Text = "延迟",
    Default = 0.05,
    Min = 0.01,
    Max = 0.5,
    Rounding = 2,
    Callback = function(v) MC.ShiftDelay = v end
})
MiscGroup:AddToggle("SC.APM_Enabled", {
    Text = "自动拾取金钱",
    Default = false,
    Callback = function(v) SC.APM_Enabled = v; if v then StartAutoPickUpMoney() end end
})
MiscGroup:AddKeyPicker("SC.APM_Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["SC.APM_Enabled"] then Options["SC.APM_Enabled"](v) end end
})
MiscGroup:AddToggle("SC.AUS_Enabled", {
    Text = "自动解锁保险箱",
    Default = false,
    Callback = function(v) SC.AUS_Enabled = v; if v then StartAutoUnlockSafe() end end
})
MiscGroup:AddKeyPicker("SC.AUS_Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["SC.AUS_Enabled"] then Options["SC.AUS_Enabled"](v) end end
})
MiscGroup:AddToggle("MC.SmoothCam", {
    Text = "平滑相机",
    Default = false,
    Callback = function(v) MC.SmoothCam = v end
})
MiscGroup:AddKeyPicker("MC.SmoothCam_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["MC.SmoothCam"] then Options["MC.SmoothCam"](v) end end
})
MiscGroup:AddSlider("MC.LerpSpeed", {
    Text = "平滑速度",
    Default = 6,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(v) MC.LerpSpeed = v end
})

local PlayerListGroup = Tabs.PlayerList:AddLeftGroupbox("目标列表", "list")
PL_TargetSearch = PlayerListGroup:AddSearchBox("PL_TargetSearch", {
    Text = "目标",
    Placeholder = "搜索玩家...",
    Callback = function(v) TargetList = v end
})
PlayerListGroup:AddButton({
    Text = "清除目标",
    Func = function() TargetList = {}; PL_TargetSearch:SetText("") end
})

local PlayerListGroup2 = Tabs.PlayerList:AddRightGroupbox("白名单", "shield")
PL_WhiteSearch = PlayerListGroup2:AddSearchBox("PL_WhiteSearch", {
    Text = "白名单",
    Placeholder = "搜索玩家...",
    Callback = function(v) WhiteList = v end
})
PlayerListGroup2:AddButton({
    Text = "清除白名单",
    Func = function() WhiteList = {}; PL_WhiteSearch:SetText("") end
})

local PerformanceGroup = Tabs.Performance:AddLeftGroupbox("FPS 锁定", "activity")
PerformanceGroup:AddToggle("FPS_Lock.Enabled", {
    Text = "启用 FPS 锁定",
    Default = false,
    Callback = function(v) FPS_Lock.Enabled = v; if v then ApplyFPSLock() else RestoreFPS() end end
})
PerformanceGroup:AddKeyPicker("FPS_Lock.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["FPS_Lock.Enabled"] then Options["FPS_Lock.Enabled"](v) end end
})
PerformanceGroup:AddDropdown("FPS_Lock.TargetFPS", {
    Text = "目标 FPS",
    Values = {"90","120","144","165","240"},
    Default = "120",
    Callback = function(v) FPS_Lock.TargetFPS = tonumber(v); if FPS_Lock.Enabled then ApplyFPSLock() end end
})
PerformanceGroup:AddDropdown("FPS_Lock.QualityLevel", {
    Text = "画质等级",
    Values = {"低","中","高","极高"},
    Default = "中",
    Callback = function(v)
        local qMap = {["低"]=1,["中"]=2,["高"]=3,["极高"]=4}
        FPS_Lock.QualityLevel = qMap[v] or 2
        if FPS_Lock.Enabled then ApplyFPSLock() end
    end
})

local MusicGroup = Tabs.Music:AddLeftGroupbox("音乐播放器", "music")
MusicGroup:AddToggle("MusicPlayer.Enabled", {
    Text = "启用音乐",
    Default = false,
    Callback = function(v) MusicPlayer.Enabled = v; if v then CreateMusicSound(); PlayMusic() else StopMusic() end end
})
MusicGroup:AddKeyPicker("MusicPlayer.Enabled_KB", {
    Text = "快捷键",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function(v) if Options["MusicPlayer.Enabled"] then Options["MusicPlayer.Enabled"](v) end end
})
MusicGroup:AddToggle("MusicPlayer.LoopMode", {
    Text = "循环播放",
    Default = true,
    Callback = function(v) MusicPlayer.LoopMode = v; if MusicPlayer.Sound then pcall(function() MusicPlayer.Sound.Looped = v end) end end
})
local trackNames = {}
for _, t in ipairs(MusicTracks) do table.insert(trackNames, t.Name) end
MusicGroup:AddSearchBox("MusicPlayer.CurrentTrack", {
    Text = "选择歌曲",
    Placeholder = "搜索歌曲...",
    Callback = function(v)
        for i, t in ipairs(MusicTracks) do
            if t.Name == v then SwitchTrack(i); break end
        end
    end
})
MusicGroup:AddSlider("MusicPlayer.Volume", {
    Text = "音量",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v) MusicPlayer.Volume = v; if MusicPlayer.Sound then pcall(function() MusicPlayer.Sound.Volume = v end) end end
})
MusicGroup:AddButton({
    Text = "播放/暂停",
    Func = function() if MusicPlayer.Playing then StopMusic() else PlayMusic() end end
})
MusicGroup:AddButton({
    Text = "下一首",
    Func = function() local next = (MusicPlayer.CurrentTrack % #MusicTracks) + 1; SwitchTrack(next) end
})
MusicGroup:AddButton({
    Text = "上一首",
    Func = function() local prev = MusicPlayer.CurrentTrack - 1; if prev < 1 then prev = #MusicTracks end; SwitchTrack(prev) end
})

local UISettingsGroup = Tabs["UI Settings"]:AddLeftGroupbox("菜单", "wrench")
UISettingsGroup:AddToggle("KeybindFrame.Visible", {
    Text = "打开快捷键菜单",
    Default = false,
    Callback = function(v) Obsidian.KeybindFrame.Visible = v end
})
UISettingsGroup:AddToggle("ShowCustomCursor", {
    Text = "自定义光标",
    Default = true,
    Callback = function(v) Obsidian.ShowCustomCursor = v end
})
UISettingsGroup:AddDropdown("NotifySide", {
    Text = "通知位置",
    Values = {"左","右"},
    Default = "右",
    Callback = function(v) Obsidian:SetNotifySide(v) end
})
UISettingsGroup:AddDropdown("DPIScale", {
    Text = "DPI缩放",
    Values = {"50%","75%","100%","125%","150%","175%","200%"},
    Default = "100%",
    Callback = function(v) v = v:gsub("%%",""); Obsidian:SetDPIScale(tonumber(v)) end
})
UISettingsGroup:AddDivider()
UISettingsGroup:AddLabel("菜单热键")
UISettingsGroup:AddKeyPicker("MenuKeybind", {
    Text = "菜单热键",
    Default = "RightShift",
    NoUI = true
})
UISettingsGroup:AddButton({
    Text = "卸载脚本",
    Func = function() Obsidian:Unload() end
})
Obsidian.ToggleKeybind = Options.MenuKeybind

task.spawn(function()
    task.wait(0.5)
    pcall(function()
        ThemeManager:SetLibrary(Obsidian)
        SaveManager:SetLibrary(Obsidian)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
        ThemeManager:SetFolder(winTitle)
        SaveManager:SetFolder(winTitle)
        SaveManager:SetSubFolder("BloxStrike")
        SaveManager:BuildConfigSection(Tabs["UI Settings"])
        ThemeManager:ApplyToTab(Tabs["UI Settings"])
        SaveManager:LoadAutoloadConfig()
    end)
end)

Obsidian:OnUnload(function()
    print("UI 已卸载")
end)