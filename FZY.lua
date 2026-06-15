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

local RB_State, RF_State, AutoReload, DownCheck = false, false, false, false
local Debug_Rays, TargetMode, HitSoundSelection = false, "Near", "None"
local Origin_Radius, Hit_Radius = 25.00, 32.00
local Origin_Scans, Hit_Scans = 36, 36
local ScanRate = 20
local Last_Shot, Valid_Pair, Locked_Path = 0, nil, nil
local WB = { LastScan = 0, Cached = false, Toggle = false, Threshold = 3, Round = 0 }
local NoFallEnabled = false

local RB_LO = {
    Enabled = true, LongDistThreshold = 100, MaxDistThreshold = 1200,
    DynamicRadiusScale = true, RadiusScaleFactor = 0.25, MinRadiusClamp = 5, MaxRadiusClamp = 50,
    ExtraScanCount = 32, TargetHeightOffset = true, HeightOffsetAmount = 3.5,
    DistCompensation = true, CompensationFactor = 0.035, BulletDropComp = true,
    DropFactor = 0.012, VelocityEstimate = 1100, LastTargetDist = 0, CachedGunConfig = nil,
    PredictionEnabled = true, PredictionFactor = 0.25,
    DistanceTiers = { Near = 150, Mid = 400, Far = 700, Extreme = 1000 },
}

local NR = { Enabled = false, Conns = {}, OrigVals = {}, Cache = {}, RecoilVal = 0 }
local WV = {
    LightingModeEnabled = false, LightingMode = "ShadowMap",
    WorldTimeEnabled = false, WorldTime = 12,
    AmbientEnabled = false, AmbientColor = Color3.fromRGB(255,255,255), OutdoorAmbientColor = Color3.fromRGB(255,255,255),
    AtmosphereEnabled = false, AtmoColor = Color3.fromRGB(255,255,255), AtmoDecay = Color3.fromRGB(120,120,120),
    AtmoHaze = 1, AtmoGlare = 10, AtmoDensity = 0.35, AtmoOffset = 0,
    WeatherEnabled = false, WeatherType = "Rain", WeatherColor = Color3.fromRGB(255,255,255), WeatherRate = 600,
    SkyboxEnabled = false, SkyboxType = "Black Storm",
    BGSoundEnabled = false, BGSoundTrack = "Night", BGSoundVolume = 25,
}
local WV_Lit = game:GetService("Lighting")
local WV_Atmo = WV_Lit:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", WV_Lit)
local WV_Sky = WV_Lit:FindFirstChildOfClass("Sky") or Instance.new("Sky", WV_Lit)
local WV_Skyboxes = {
    ["Stormy"] = { Up = "18703232671", Bk = "18703245834", Lf = "18703237556", Dn = "18703243349", Ft = "18703240532", Rt = "18703235430" },
    ["Blue Space"] = { Up = "15536117282", Bk = "15536110634", Lf = "15536114370", Dn = "15536112543", Ft = "15536116141", Rt = "15536118762" },
    ["Pink"] = { Up = "12216108877", Bk = "12216109205", Lf = "12216110170", Dn = "12216109875", Ft = "12216109489", Rt = "12216110471" },
    ["Black Storm"] = { Up = "15502511911", Bk = "15502511288", Lf = "15502507918", Dn = "15502508460", Ft = "15502510289", Rt = "15502509398" },
    ["Realistic"] = { Up = "653719321", Bk = "653719502", Lf = "653719190", Dn = "653718790", Ft = "653719067", Rt = "653718931" },
}
local WV_Sounds = {
    ["Windy Winter"] = "rbxassetid://6046340391", ["Light Rain"] = "rbxassetid://18862087062",
    ["Thunderstorm"] = "rbxassetid://4305545740", ["Night"] = "rbxassetid://179507208", ["Day"] = "rbxassetid://6189453706",
}
local WV_BGSound = Instance.new("Sound", CoreGui); WV_BGSound.Looped = true
local WV_WeatherPart = Instance.new("Part"); WV_WeatherPart.Size = Vector3.new(40,40,85); WV_WeatherPart.Anchored = true
WV_WeatherPart.CanCollide = false; WV_WeatherPart.Transparency = 1
local WV_Emitter = Instance.new("ParticleEmitter", WV_WeatherPart)
WV_Emitter.EmissionDirection = Enum.NormalId.Bottom
WV_Emitter.Orientation = Enum.ParticleOrientation.FacingCameraWorldUp

local SA = {
    Enabled = false, HitChance = 100, WallCheck = true, TargetPart = "Head", IsRandom = false,
    RandomParts = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
    RandomIdx = 1, RandomTimer = 0, VisualizeEvent = nil, DamageEvent = nil,
    FOV_Visible = false, FOV_Radius = 100, FOV_Sides = 16, FOV_Color = Color3.fromRGB(255,0,0),
    FOV_PositionMode = "Center", FOV_SpinEnabled = false, FOV_SpinSpeed = 50, FOV_Rotation = 0,
}

local CL = {
    Enabled = false, DownCheck = false, TargetOnly = false, AutoPrediction = false,
    FOV = 170, Power = 1, Shake = 0.2, Delay = 0.1,
    TargetParts = { "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
    CurrentTarget = nil, LockedPart = nil, LastSwitchTime = 0, ScanTimer = 0,
    CachedTool = nil, CachedVel = 1100,
}

local MA = {
    Enabled = false, DownCheck = false, TargetOnly = false,
    ShowAnim = true, Distance = 20, TargetPart = "Random", LastHit = 0, Loop = nil,
    Parts = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
    Remote1 = RepStorage:WaitForChild("Events"):WaitForChild("XMHH.2"),
    Remote2 = RepStorage:WaitForChild("Events"):WaitForChild("XMHH2.2"),
}

local TR = { Enabled = false, Size = 1, Color = Color3.fromRGB(255,255,255), Alpha = 0 }
local HitLogEnabled = false
local HitLog = { ActiveLogs = {}, THEME = {
    RowHeight = 13, PaddingY = 7, SidePadding = 16, FontSize = 10,
    Font = Font.new("rbxassetid://12187371840"),
    Color_Bg = Color3.fromRGB(0,0,0), Color_Accent = Color3.fromRGB(0,255,0), Color_Secondary = Color3.fromRGB(200,200,200),
    BgTransparency = 0.5, Lifetime = 5.0, MaxLogs = 8, Position = UDim2.new(0,20,0,70),
} }

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

local SpeedState, JumpState, SpeedValue, JumpValue = false, false, 33.5, 73
local InfStaminaEnabled, InfStaminaConnection = false, nil
local HeadMode, HandsModSelection = nil, nil
local OriginalNeckC0, OriginalNeckC1 = nil, nil
local DoTweak_fn = nil
local HeadYaw, HeadRotSpeed, HeadYawTime = 0, 30, 0
local HeadCustomYaw = 0
local Invis_Enabled, Invis_Track, Invis_SavedCF = false, nil, nil
local Invis_Anim = Instance.new("Animation"); Invis_Anim.AnimationId = "rbxassetid://282574440"
local DS = {
    Enabled = false, Visualize = true, TPRate = 60, X = 8.5, Y = 3, Z = 8.5,
    LastTPTime = 0, LastFFlagTime = 0, CurrentOffset = Vector3.zero, Y_Toggle = false,
    AppliedOffset = Vector3.zero, Model = nil,
}
local LF = {
    Enabled = false, SpinSpeed = 100, TimePosRatio = 0.5, Track1 = nil, Track2 = nil, Angle = 0,
    Anim1 = Instance.new("Animation"), Anim2 = Instance.new("Animation"),
}
LF.Anim1.AnimationId = "rbxassetid://215384594"
LF.Anim2.AnimationId = "rbxassetid://68339848"
local FF_S = { BodyEnabled = false, ToolEnabled = false, Color = Color3.fromRGB(255,255,255), LastSkin = 0, BodyProps = {}, ToolProps = {} }
local TargetList, WhiteList = {}, {}
local SC = { APM_Enabled = false, APM_Loop = nil, AUS_Enabled = false, AUS_Loop = nil }
local SafeChamsEnabled, SafeChamsLoop = false, nil
local MC = { AntiShift = false, ShiftDelay = 0.05, SmoothCam = false, LerpSpeed = 6, SmoothPos = nil }
local AMB = { Enabled = false, Color = Color3.fromRGB(190,220,255), Density = 0.45, Brightness = 0.15, Gui = nil }
local CAM_FOV = nil
local CAM_FOV_Conn = nil
local PL_TargetSearch, PL_WhiteSearch = nil, nil
local lastTickHadGun = false
local ChangeMouseLockEvent = RepStorage:WaitForChild("Events2"):WaitForChild("ChangeMouseLock")
local HitSounds = {
    ["Skeet"] = "rbxassetid://5633695679",
    ["Neverlose"] = "rbxassetid://8726881116",
    ["Gamesense"] = "rbxassetid://4817809188",
}
local FLY = {
    Enabled = false, Active = false, Speed = 60, LastSafeCF = nil, AnimTrack = nil, SpeedLabel = nil,
    PM = nil, PC = nil, CurrentYaw = nil, OffTime = nil, Gui = nil, Btn = nil,
    RZDONL = nil, NextSend = 0, AnimObj = Instance.new("Animation"),
    Joints = {"Left Hip","Right Hip","Left Shoulder","Right Shoulder","Neck"},
    EvArgs = {"-r__r3"}, MobileMode = false,
}
FLY.AnimObj.AnimationId = "rbxassetid://"
local function FlyRefreshBtn() end
local function GetLocalRealPosition()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return Vector3.zero end
    return hrp.Position - DS.AppliedOffset
end

local function IsBodyPart(p)
    return p:IsA("BasePart") and (p.Name=="Head" or p.Name=="Torso" or p.Name=="Left Arm" or p.Name=="Right Arm" or p.Name=="Left Leg" or p.Name=="Right Leg")
end

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
                                local dist  = (myPos - tChar.HumanoidRootPart.Position).Magnitude
                                local hum   = tChar:FindFirstChildOfClass("Humanoid")
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
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChild("Humanoid")
            if hrp and hum then
                local map        = Workspace:FindFirstChild("Map")
                local bredMakurz = map and map:FindFirstChild("BredMakurz")
                if bredMakurz then
                    local closestSafe, minDist = nil, 12
                    for _, obj in ipairs(bredMakurz:GetChildren()) do
                        if string.find(string.lower(obj.Name), "safe") then
                            local vals   = obj:FindFirstChild("Values")
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
                                    local vals2   = closestSafe:FindFirstChild("Values")
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

local function clearBoxes(p) if BoxESP.Boxes[p] then for _,b in pairs(BoxESP.Boxes[p]) do b:Destroy() end BoxESP.Boxes[p]=nil end end
local function createAdorn(class, part, name, z, color, alpha, size)
    local a = Instance.new(class)
    a.Name=name; a.Adornee=part; a.AlwaysOnTop=true; a.ZIndex=z; a.Color3=color; a.Transparency=alpha; a.Parent=CoreGui
    if class=="BoxHandleAdornment" then a.Size=size else a.Height=size.Y; a.Radius=size.X; a.CFrame=CFrame.Angles(math.rad(90),0,0) end
    return a
end

local function updatePlayerBoxes(p)
    if not p or not espSets.enabled then clearBoxes(p) return end
    if espSets.targetOnly and not table.find(TargetList,p.Name) then clearBoxes(p) return end
    local char = p.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") then return end
    clearBoxes(p); BoxESP.Boxes[p]={}
    for _, pn in pairs(bodyParts) do
        local obj = char:FindFirstChild(pn)
        if obj and obj:IsA("BasePart") then
            if obj.Name=="Head" then
                local s=(obj.Size.X/2)*0.6
                if espSets.outline then table.insert(BoxESP.Boxes[p], createAdorn("CylinderHandleAdornment",obj,"out",-1,espSets.outCol,espSets.outAlpha,Vector2.new(s+espSets.outSize,obj.Size.Z+espSets.outSize))) end
                if espSets.inline  then table.insert(BoxESP.Boxes[p], createAdorn("CylinderHandleAdornment",obj,"in", 1,espSets.inCol, espSets.inAlpha, Vector2.new(s+espSets.inSize, obj.Size.Z+espSets.inSize)))  end
            else
                if espSets.outline then table.insert(BoxESP.Boxes[p], createAdorn("BoxHandleAdornment",obj,"out",-1,espSets.outCol,espSets.outAlpha,obj.Size+Vector3.new(espSets.outSize,espSets.outSize,espSets.outSize))) end
                if espSets.inline  then table.insert(BoxESP.Boxes[p], createAdorn("BoxHandleAdornment",obj,"in", 1,espSets.inCol, espSets.inAlpha, obj.Size+Vector3.new(espSets.inSize, espSets.inSize, espSets.inSize)))  end
            end
        end
    end
end
local function refreshAllESP() for _,p in pairs(Players:GetPlayers()) do updatePlayerBoxes(p) end end
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
        local nameL = Instance.new("TextLabel"); nameL.Name = "L"
        nameL.BackgroundTransparency = 1
        nameL.Size = UDim2.new(1, 0, 0.5, 0)
        nameL.Position = UDim2.new(0, 0, 0, 0)
        nameL.TextColor3 = Color3.new(1,1,1)
        nameL.FontFace = Font.new("rbxassetid://12187371840")
        nameL.TextSize = 7
        nameL.TextXAlignment = Enum.TextXAlignment.Center
        local s1 = Instance.new("UIStroke"); s1.Thickness = 0.8; s1.Color = Color3.new(0,0,0); s1.Parent = nameL
        nameL.Parent = tag
        local distL = Instance.new("TextLabel"); distL.Name = "DL"
        distL.BackgroundTransparency = 1
        distL.Size = UDim2.new(1, 0, 0.5, 0)
        distL.Position = UDim2.new(0, 0, 0.5, 0)
        distL.TextColor3 = Color3.fromRGB(200, 200, 200)
        distL.FontFace = Font.new("rbxassetid://12187371840")
        distL.TextSize = 7
        distL.TextXAlignment = Enum.TextXAlignment.Center
        local s2 = Instance.new("UIStroke"); s2.Thickness = 0.8; s2.Color = Color3.new(0,0,0); s2.Parent = distL
        distL.Parent = tag
        local ffTag = Instance.new("BillboardGui")
        ffTag.Name = "CAT_FFTag"
        ffTag.AlwaysOnTop = true
        ffTag.Size = UDim2.new(0, 60, 0, 20)
        ffTag.StudsOffset = Vector3.new(2.5, 0, 0)
        ffTag.Enabled = false
        local ffL = Instance.new("TextLabel"); ffL.Name = "L"
        ffL.BackgroundTransparency = 1
        ffL.Size = UDim2.new(1,0,1,0)
        ffL.Text = "FF"
        ffL.TextColor3 = Color3.new(1,1,1)
        ffL.FontFace = Font.new("rbxassetid://12187371840")
        ffL.TextSize = 7
        ffL.TextXAlignment = Enum.TextXAlignment.Center
        local sFF = Instance.new("UIStroke"); sFF.Thickness = 0.8; sFF.Color = Color3.new(0,0,0); sFF.Parent = ffL
        ffL.Parent = ffTag
        ffTag.Parent = char
        ffTag.Adornee = root
        local hpTag = Instance.new("BillboardGui")
        hpTag.Name = "CAT_HPTag"
        hpTag.AlwaysOnTop = true
        hpTag.Size = UDim2.new(0, 60, 0, 20)
        hpTag.StudsOffset = Vector3.new(-2.5, 0, 0)
        hpTag.Enabled = false
        local hpL = Instance.new("TextLabel"); hpL.Name = "L"
        hpL.BackgroundTransparency = 1
        hpL.Size = UDim2.new(1,0,1,0)
        hpL.TextColor3 = Color3.new(1,1,1)
        hpL.FontFace = Font.new("rbxassetid://12187371840")
        hpL.TextSize = 7
        hpL.TextXAlignment = Enum.TextXAlignment.Center
        local sHP = Instance.new("UIStroke"); sHP.Thickness = 0.8; sHP.Color = Color3.new(0,0,0); sHP.Parent = hpL
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
local reloadConnections = {}
local function setupTool(tool)
    if not (tool and tool:FindFirstChild("IsGun") and AutoReload) then return end
    local vals = tool:FindFirstChild("Values"); if not vals then return end
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
        table.insert(reloadConnections, game:GetService("RunService").Heartbeat:Connect(checkAndReload))
    end
end
local function AutoReloadSetup()
    clearReloadConnections(); if not AutoReload then return end
    if LocalPlayer.Character then
        setupTool(LocalPlayer.Character:FindFirstChildOfClass("Tool"))
        table.insert(reloadConnections, LocalPlayer.Character.ChildAdded:Connect(function(o) if o:IsA("Tool") then setupTool(o) end end))
    end
    table.insert(reloadConnections, LocalPlayer.CharacterAdded:Connect(function(c)
        repeat task.wait() until c and c.Parent
        clearReloadConnections(); setupTool(c:FindFirstChildOfClass("Tool"))
        table.insert(reloadConnections, c.ChildAdded:Connect(function(o) if o:IsA("Tool") then setupTool(o) end end))
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

local function CreateTracer(origin, dir)
    if not TR.Enabled then return end
    local a0 = Instance.new("Attachment", Workspace.Terrain); a0.Position = origin
    local a1 = Instance.new("Attachment", Workspace.Terrain); a1.Position = origin + dir.Unit*1000
    local beam = Instance.new("Beam", Workspace.Terrain)
    beam.Texture = "rbxassetid://446111271"
    beam.Width0, beam.Width1 = TR.Size, TR.Size
    beam.Color = ColorSequence.new(TR.Color)
    beam.Transparency = NumberSequence.new(TR.Alpha)
    beam.Attachment0, beam.Attachment1 = a0, a1
    beam.FaceCamera, beam.LightEmission = true, 1
    Debris:AddItem(a0,4); Debris:AddItem(a1,4); Debris:AddItem(beam,4)
end

local function InitHitLog()
    if HitLog.Gui then return end
    HitLog.Gui = Instance.new("ScreenGui")
    HitLog.Gui.Name = "CatHitLog"
    HitLog.Gui.ResetOnSpawn = false
    HitLog.Gui.IgnoreGuiInset = true
    HitLog.Gui.Enabled = false
    HitLog.Gui.Parent = CoreGui
    local c = Instance.new("Frame")
    c.Name, c.Position = "LogContainer", HitLog.THEME.Position
    c.Size = UDim2.new(0, 500, 0, 800)
    c.BackgroundTransparency = 1
    c.Parent = HitLog.Gui
    HitLog.Container = c
end

local function RecalculateLogPositions()
    for i, frame in ipairs(HitLog.ActiveLogs) do
        local y = (i-1)*(HitLog.THEME.RowHeight + HitLog.THEME.PaddingY)
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,y)}):Play()
    end
end

local function AnimateRemoveLog(frame)
    if not frame then return end
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    TweenService:Create(frame, info, {Position = frame.Position - UDim2.new(0,0,0,15), BackgroundTransparency = 1}):Play()
    local lbl = frame:FindFirstChild("Content")
    if lbl then TweenService:Create(lbl, info, {TextTransparency = 1}):Play() end
    task.delay(0.5, function() if frame then frame:Destroy() end end)
end

local function AddLogEntry(text)
    if not HitLogEnabled or not HitLog.Container then return end
    if #HitLog.ActiveLogs >= HitLog.THEME.MaxLogs then
        AnimateRemoveLog(table.remove(HitLog.ActiveLogs, 1))
        RecalculateLogPositions()
    end
    local bg = Instance.new("Frame")
    bg.AutomaticSize = Enum.AutomaticSize.X
    bg.Size = UDim2.new(0, 0, 0, HitLog.THEME.RowHeight)
    bg.BackgroundColor3 = HitLog.THEME.Color_Bg
    bg.BackgroundTransparency = 1
    bg.Parent = HitLog.Container
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(Color3.new(1,1,1))
    grad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.20, HitLog.THEME.BgTransparency),
        NumberSequenceKeypoint.new(0.80, HitLog.THEME.BgTransparency), NumberSequenceKeypoint.new(1.00, 1.00),
    }
    grad.Parent = bg
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft  = UDim.new(0, HitLog.THEME.SidePadding)
    pad.PaddingRight = UDim.new(0, HitLog.THEME.SidePadding)
    pad.Parent = bg
    local lbl = Instance.new("TextLabel")
    lbl.Name = "Content"; lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Size = UDim2.new(0,0,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = HitLog.THEME.Color_Secondary
    lbl.TextSize = HitLog.THEME.FontSize; lbl.FontFace = HitLog.THEME.Font
    lbl.RichText = true; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTransparency = 1; lbl.Parent = bg
    table.insert(HitLog.ActiveLogs, bg)
    local ty = (#HitLog.ActiveLogs-1)*(HitLog.THEME.RowHeight+HitLog.THEME.PaddingY)
    bg.Position = UDim2.new(0,-25,0,ty)
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    TweenService:Create(bg,  info, {Position = UDim2.new(0,0,0,ty), BackgroundTransparency = 0}):Play()
    TweenService:Create(lbl, info, {TextTransparency = 0}):Play()
    task.delay(HitLog.THEME.Lifetime, function()
        if not bg or not bg.Parent then return end
        local idx = table.find(HitLog.ActiveLogs, bg)
        if idx then table.remove(HitLog.ActiveLogs, idx); AnimateRemoveLog(bg); RecalculateLogPositions() end
        for i = #HitLog.ActiveLogs, 1, -1 do
            if not HitLog.ActiveLogs[i] or not HitLog.ActiveLogs[i].Parent then
                table.remove(HitLog.ActiveLogs, i)
            end
        end
    end)
end

local function ProcessHitLog(tName, toolName, dmg, dist, cached)
    local s = string.format("rgb(%d,%d,%d)", 200,200,200)
    local g = string.format("rgb(%d,%d,%d)", 0,255,0)
    local ct = cached and string.format(' <font color="%s">缓存命中</font>', g) or ""
    AddLogEntry(string.format(
        '<font color="%s">命中 </font><font color="%s">%s </font><font color="%s">使用 </font>'..
        '<font color="%s">%s </font><font color="%s">爆头造成 </font>'..
        '<font color="%s">%s </font><font color="%s">伤害 </font><font color="%s">%sm</font>%s',
        s,g,tName,s,g,toolName,s,g,tostring(dmg),s,g,dist,ct))
end

InitHitLog()

local function ApplyBodyFF()
    local char=LocalPlayer.Character; if not char then return end
    for _,p in ipairs(char:GetChildren()) do
        if IsBodyPart(p) then p.Material=Enum.Material.ForceField; p.Color=FF_S.Color end
    end
end
local function RestoreBody()
    for p,props in pairs(FF_S.BodyProps) do if p and p.Parent then p.Material=props.Material; p.Color=props.Color end end
    FF_S.BodyProps={}
end
local function ApplyToolFF()
    local char=LocalPlayer.Character
    local tool=char and char:FindFirstChildOfClass("Tool")
    if tool then for _,p in ipairs(tool:GetDescendants()) do if p:IsA("BasePart") then p.Material=Enum.Material.ForceField; p.Color=FF_S.Color end end end
end
local function RestoreTool()
    for p,props in pairs(FF_S.ToolProps) do if p and p.Parent then p.Material=props.Material; p.Color=props.Color end end
    FF_S.ToolProps={}
end

local ScanVectors = {
    Vector3.new(1,0,0), Vector3.new(0,0,1), Vector3.new(0,1,0),
    -Vector3.new(1,0,0), -Vector3.new(0,0,1), -Vector3.new(0,1,0),
    Vector3.new(1,1,0)/math.sqrt(2), Vector3.new(1,0,1)/math.sqrt(2), Vector3.new(0,1,1)/math.sqrt(2),
    Vector3.new(-1,1,0)/math.sqrt(2), Vector3.new(-1,0,1)/math.sqrt(2),
    -Vector3.new(1,0,1)/math.sqrt(2), -Vector3.new(-1,0,1)/math.sqrt(2), -Vector3.new(0,-1,1)/math.sqrt(2),
    Vector3.new(1,1,1)/math.sqrt(3), Vector3.new(-1,1,1)/math.sqrt(3), Vector3.new(1,1,-1)/math.sqrt(3),
    -Vector3.new(1,1,1)/math.sqrt(3), -Vector3.new(1,-1,1)/math.sqrt(3),
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
    local cfOffset = CFrame.new(firePos, targetPos) * CFrame.Angles(0, 0, math.rad(math.random(1,90)))
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
local function GetTarget()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, metric = nil, math.huge
    local ml = UIS:GetMouseLocation()
    local sc = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local myPos = GetLocalRealPosition()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not table.find(WhiteList, p.Name) and not (TargetMode == "Lock" and #TargetList > 0 and not table.find(TargetList, p.Name)) then
                local pr = p.Character:FindFirstChild("HumanoidRootPart")
                local ph = p.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and ph.Health > (DownCheck and 15 or 0) and not p.Character:FindFirstChildOfClass("ForceField") then
                    local dist = (myPos - pr.Position).Magnitude
                    if TargetMode == "Near" or TargetMode == "Lock" then
                        if dist < metric then metric = dist; best = p end
                    else
                        local sp, on = Camera:WorldToViewportPoint(pr.Position)
                        if on then
                            local d2 = ((TargetMode == "Mouse" and ml or sc) - Vector2.new(sp.X, sp.Y)).Magnitude
                            if d2 < metric then metric = d2; best = p end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function GetGunConfig(tool) return nil end
local function GetDynamicRadius(baseRadius, distance) return baseRadius end
local function GetCompensatedPosition(basePos, targetPos, distance) return basePos end
local function GetBulletDropCompensation(origin, hit, distance, gunConfig) return hit end
local function GetPredictedPosition(targetPart, distance, gunConfig) return targetPart.Position end
local function GetOptimizedScanCount(baseCount, distance) return baseCount end
local function IsValidDistance(distance) return distance <= RB_LO.MaxDistThreshold end
local function GetHeightOffset(distance) return RB_LO.HeightOffsetAmount end
local function CheckWallbangOptimized(p1, p2, distance) return CheckWallbang(p1, p2) end

local function CheckWallbang(p1, p2)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local d = (p2 - p1).Magnitude
    local r = Workspace:Raycast(p1, (p2 - p1).Unit * d, params)
    local ok = not r or (r.Position - p2).Magnitude <= 24
    if Debug_Rays then
        local col = ok and Color3.new(0,1,0) or Color3.new(1,0,0)
        local rp = Instance.new("Part")
        rp.Anchored = true; rp.CanCollide = false; rp.Material = Enum.Material.Neon; rp.Color = col
        rp.Size = Vector3.new(0.05,0.05,d)
        rp.CFrame = CFrame.lookAt(p1, p2) * CFrame.new(0,0,-d/2)
        rp.Parent = Workspace
        Debris:AddItem(rp,1)
    end
    return ok
end

local function DoRagebot()
    if not RB_State then Valid_Pair = nil; Locked_Path = nil; return end
    local target = GetTarget()
    if not target or not target.Character then Valid_Pair = nil; Locked_Path = nil; return end
    if Locked_Path and Locked_Path.Target ~= target then Locked_Path = nil end
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot or not tRoot then return end
    local myPos = GetLocalRealPosition()
    local distance = (myPos - tRoot.Position).Magnitude
    RB_LO.LastTargetDist = distance
    if RB_LO.Enabled and not IsValidDistance(distance) then Valid_Pair = nil; return end
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    local gunConfig = RB_LO.Enabled and GetGunConfig(tool) or nil
    local tPos = GetPredictedPosition(tRoot, distance, gunConfig)
    tPos = tPos + Vector3.new(0, GetHeightOffset(distance), 0)
    if Locked_Path then
        local dO = (myPos - Locked_Path.MyPos).Magnitude
        local dH = (tPos - Locked_Path.TPos).Magnitude
        local threshold = WB.Threshold
        if RB_LO.Enabled and distance > RB_LO.LongDistThreshold then threshold = WB.Threshold * 0.6 end
        local inRange = (myPos - Locked_Path.AbsO).Magnitude <= Origin_Radius and (tPos - Locked_Path.AbsH).Magnitude <= Hit_Radius
        if dO <= threshold and dH <= threshold and inRange then
            local checkFunc = (RB_LO.Enabled and distance > 200) and CheckWallbangOptimized or CheckWallbang
            if checkFunc(Locked_Path.AbsO, Locked_Path.AbsH, distance) then
                Valid_Pair = { Origin = Locked_Path.AbsO, Hit = Locked_Path.AbsH, Target = target }
                WB.Cached = true
                return
            end
        end
        Locked_Path = nil
    end
    if tick() - WB.LastScan < 1 / ScanRate then return end
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
        local oPole = (tPos - myPos).Unit
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
                bestPO, bestPH = pO, compensatedPH
                break
            end
        end
        if bestPO then break end
    end
    if bestPO then
        Locked_Path = { AbsO = bestPO, AbsH = bestPH, Target = target, MyPos = myPos, TPos = tPos, _createTime = tick() }
        Valid_Pair = { Origin = bestPO, Hit = bestPH, Target = target }
        WB.Cached = false
    else
        Valid_Pair = nil
    end
end

local function FlyGetInputDir()
    if not FLY.PM then
        local ok, r = pcall(function()
            return require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
        end)
        if ok then FLY.PM = r end
    end
    if FLY.PM and not FLY.PC then FLY.PC = FLY.PM:GetControls() end
    if not FLY.PC then return Vector3.zero end
    local mv  = FLY.PC:GetMoveVector()
    local fwd = Camera.CFrame.LookVector
    local rgt = Camera.CFrame.RightVector
    local dir = rgt * mv.X + fwd * -mv.Z
    return dir.Magnitude > 0 and dir.Unit or Vector3.zero
end

local function FlyPlayAnim()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if FLY.AnimTrack and FLY.AnimTrack.IsPlaying then return end
    local anim = hum:FindFirstChildOfClass("Animator") or hum
    pcall(function()
        FLY.AnimTrack = anim:LoadAnimation(FLY.AnimObj)
        FLY.AnimTrack.Priority = Enum.AnimationPriority.Action4
        FLY.AnimTrack.Looped   = true
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
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return end
    FLY.Active = true
    FLY.LastSafeCF = nil
    FlyPlayAnim()
    FlyRefreshBtn()
end

local function FlyOff()
    FLY.Active     = false
    FLY.LastSafeCF = nil
    FLY.CurrentYaw = nil
    FLY.OffTime    = os.clock()
    FlyStopAnim()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    if hrp then
        hrp.AssemblyLinearVelocity  = Vector3.zero
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

FlyRefreshBtn = function()
    if not FLY.Btn then return end
    if FLY.Active then
        FLY.Btn.Text = "开启"; FLY.Btn.BackgroundColor3 = Color3.fromRGB(30,165,60)
    else
        FLY.Btn.Text = "关闭"; FLY.Btn.BackgroundColor3 = Color3.fromRGB(185,45,45)
    end
end

local function GetAllPlayerNames()
    local n = {}
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(n, p.Name) end end
    return n
end
local Window = WindUI:CreateWindow({
    Title = "not.cc 综合辅助",
    Folder = "not_cc",
    SideBarWidth = 180,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/GHn9L9UJLf0XcVNyCpbG72D0rmNmBEWndPkh6CjJNya8GLnWzz1vImvt8wlJSBwv_2700x1519x1393696.jpeg",
    BackgroundImageTransparency = 0.5,
    OpenButton = {
        Title = "打开菜单",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.9,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
    Topbar = { Height = 44, ButtonsType = "Mac" },
})
Window:Tag({ Title = "V91.78", Color = Color3.fromHex("00CED1"), Radius = 2 })
Window:Tag({ Title = "伊散", Icon = "crown", Color = Color3.fromHex("FFD700"), Radius = 2 })

local blur = game:GetService("Lighting"):FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", game:GetService("Lighting"))
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
    Combat = Window:Tab({ Title = "战斗", Icon = "sword", Opened = true }),
    Visuals = Window:Tab({ Title = "视觉", Icon = "eye" }),
    Player = Window:Tab({ Title = "玩家", Icon = "user" }),
    Antis = Window:Tab({ Title = "反制", Icon = "shield" }),
    Misc = Window:Tab({ Title = "杂项", Icon = "gear" }),
    Lists = Window:Tab({ Title = "列表", Icon = "list" }),
    Settings = Window:Tab({ Title = "设置", Icon = "sliders" }),
}
Window:SelectTab(1)

local combatSec = Tabs.Combat:Section("暴力模式", "auto")
combatSec:Toggle("启用暴力", RB_State, function(v) RB_State = v end):AddKeybind("暴力开关", Enum.KeyCode.RightShift, "Toggle")
combatSec:Toggle("快速射击", RF_State, function(v) RF_State = v end)
combatSec:Toggle("自动换弹", AutoReload, function(v) AutoReload = v; if v then AutoReloadSetup() else clearReloadConnections() end end)
combatSec:Toggle("倒地检测", DownCheck, function(v) DownCheck = v end)
combatSec:Slider("最大缓存", 0.1, 25, WB.Threshold, function(v) WB.Threshold = v end)
combatSec:Slider("原点半径", 0.1, 20, Origin_Radius, function(v) Origin_Radius = v end)
combatSec:Slider("原点扫描", 1, 50, Origin_Scans, function(v) Origin_Scans = math.floor(v) end)
combatSec:Slider("扫描速率", 1, 60, ScanRate, function(v) ScanRate = math.floor(v) end)
combatSec:Slider("命中半径", 0.1, 25, Hit_Radius, function(v) Hit_Radius = v end)
combatSec:Slider("命中扫描", 1, 50, Hit_Scans, function(v) Hit_Scans = math.floor(v) end)
combatSec:Dropdown("目标模式", { "最近", "鼠标", "中心", "锁定" }, "最近", function(v)
    local modeMap = { ["最近"] = "Near", ["鼠标"] = "Mouse", ["中心"] = "Center", ["锁定"] = "Lock" }
    TargetMode = modeMap[v]
end)
combatSec:Dropdown("命中音效", { "无", "Skeet", "Neverlose", "Gamesense" }, "无", function(v)
    local soundMap = { ["无"] = "None", ["Skeet"] = "Skeet", ["Neverlose"] = "Neverlose", ["Gamesense"] = "Gamesense" }
    HitSoundSelection = soundMap[v]
end)

local ldSec = Tabs.Combat:Section("远距离优化", "auto")
ldSec:Toggle("启用优化", RB_LO.Enabled, function(v) RB_LO.Enabled = v end)
ldSec:Slider("远距离阈值", 50, 300, RB_LO.LongDistThreshold, function(v) RB_LO.LongDistThreshold = v end)
ldSec:Slider("最大有效距离", 300, 1500, RB_LO.MaxDistThreshold, function(v) RB_LO.MaxDistThreshold = v end)
ldSec:Toggle("动态半径缩放", RB_LO.DynamicRadiusScale, function(v) RB_LO.DynamicRadiusScale = v end)
ldSec:Toggle("目标预测", RB_LO.PredictionEnabled, function(v) RB_LO.PredictionEnabled = v end)
ldSec:Toggle("子弹下坠补偿", RB_LO.BulletDropComp, function(v) RB_LO.BulletDropComp = v end)
ldSec:Toggle("距离补偿", RB_LO.DistCompensation, function(v) RB_LO.DistCompensation = v end)

local saSec = Tabs.Combat:Section("静默瞄准", "auto")
saSec:Toggle("启用静默瞄准", SA.Enabled, function(v) SA.Enabled = v end):AddKeybind("静默开关", Enum.KeyCode.LeftControl, "Toggle")
saSec:Dropdown("目标部位", { "随机", "头部", "躯干", "左臂", "右臂", "左腿", "右腿" }, "头部", function(v)
    local partMap = { ["随机"] = "Random", ["头部"] = "Head", ["躯干"] = "Torso", ["左臂"] = "Left Arm", ["右臂"] = "Right Arm", ["左腿"] = "Left Leg", ["右腿"] = "Right Leg" }
    local mapped = partMap[v]
    if mapped == "Random" then SA.IsRandom = true else SA.IsRandom = false; SA.TargetPart = mapped end
end)
saSec:Slider("命中几率", 0, 100, SA.HitChance, function(v) SA.HitChance = v end)
saSec:Toggle("穿墙检测", SA.WallCheck, function(v) SA.WallCheck = v end)
saSec:Toggle("绘制视野", SA.FOV_Visible, function(v) SA.FOV_Visible = v end)
saSec:Colorpicker("视野颜色", SA.FOV_Color, function(v) SA.FOV_Color = v end)
saSec:Dropdown("视野位置", { "中心", "鼠标" }, "中心", function(v)
    SA.FOV_PositionMode = v == "中心" and "Center" or "Mouse"
end)
saSec:Slider("视野半径", 10, 600, SA.FOV_Radius, function(v) SA.FOV_Radius = v end)
saSec:Slider("边数", 3, 32, SA.FOV_Sides, function(v) SA.FOV_Sides = math.floor(v) end)
saSec:Toggle("旋转视野", SA.FOV_SpinEnabled, function(v) SA.FOV_SpinEnabled = v end)
saSec:Slider("旋转速度", 0, 500, SA.FOV_SpinSpeed, function(v) SA.FOV_SpinSpeed = v end)

local clSec = Tabs.Combat:Section("镜头锁定", "auto")
clSec:Toggle("启用镜头锁定", CL.Enabled, function(v) CL.Enabled = v end):AddKeybind("锁定开关", Enum.KeyCode.LeftAlt, "Toggle")
clSec:Toggle("仅目标", CL.TargetOnly, function(v) CL.TargetOnly = v end)
clSec:Toggle("自动预判", CL.AutoPrediction, function(v) CL.AutoPrediction = v end)
clSec:Toggle("倒地检测", CL.DownCheck, function(v) CL.DownCheck = v end)
clSec:Slider("视野范围", 10, 800, CL.FOV, function(v) CL.FOV = v end)
clSec:Slider("强度", 0.1, 1, CL.Power, 0.1, function(v) CL.Power = v end)
clSec:Slider("抖动强度", 0, 1, CL.Shake, 0.1, function(v) CL.Shake = v end)
clSec:Slider("切换延迟", 0.1, 1, CL.Delay, 0.1, function(v) CL.Delay = v end)
clSec:Dropdown("锁定部位", { "头部", "躯干", "左臂", "右臂", "左腿", "右腿" }, { "头部", "躯干" }, true, function(v)
    local partMap = { ["头部"] = "Head", ["躯干"] = "Torso", ["左臂"] = "Left Arm", ["右臂"] = "Right Arm", ["左腿"] = "Left Leg", ["右腿"] = "Right Leg" }
    local mapped = {}
    for _, name in ipairs(v) do table.insert(mapped, partMap[name]) end
    CL.TargetParts = mapped
end)
clSec:Toggle("无后坐力", NR.Enabled, function(v) if v then NR_Enable() else NR_Disable() end end):AddKeybind("无后坐力开关", Enum.KeyCode.X, "Toggle")
clSec:Slider("后坐力值", 0, 1, NR.RecoilVal, 0.1, function(v) NR.RecoilVal = v; if NR.Enabled then NR_Apply() end end)

local meleeSec = Tabs.Combat:Section("近战光环", "auto")
meleeSec:Toggle("启用近战光环", MA.Enabled, function(v) MA.Enabled = v; if v then StartMeleeLoop() end end):AddKeybind("光环开关", Enum.KeyCode.F, "Toggle")
meleeSec:Toggle("仅目标", MA.TargetOnly, function(v) MA.TargetOnly = v end)
meleeSec:Toggle("倒地检测", MA.DownCheck, function(v) MA.DownCheck = v end)
meleeSec:Slider("距离", 5, 25, MA.Distance, function(v) MA.Distance = v end)
meleeSec:Toggle("显示动画", MA.ShowAnim, function(v) MA.ShowAnim = v end)
meleeSec:Dropdown("目标部位", { "随机", "头部", "躯干", "左臂", "右臂", "左腿", "右腿" }, "随机", function(v)
    local partMap = { ["随机"] = "Random", ["头部"] = "Head", ["躯干"] = "Torso", ["左臂"] = "Left Arm", ["右臂"] = "Right Arm", ["左腿"] = "Left Leg", ["右腿"] = "Right Leg" }
    MA.TargetPart = partMap[v]
end)

local visSec = Tabs.Visuals:Section("皮肤", "auto")
local ffBody = visSec:Toggle("力场身体", FF_S.BodyEnabled, function(v)
    FF_S.BodyEnabled = v
    if v then
        local char = LocalPlayer.Character
        if char then for _, p in ipairs(char:GetChildren()) do if IsBodyPart(p) and not FF_S.BodyProps[p] then FF_S.BodyProps[p] = { Material = p.Material, Color = p.Color } end end end
        task.delay(0.1, function() if FF_S.BodyEnabled then ApplyBodyFF() end end)
    else RestoreBody() end
end):AddKeybind("身体力场开关", Enum.KeyCode.G, "Toggle")
ffBody:Colorpicker("力场颜色", FF_S.Color, function(c) FF_S.Color = c; if FF_S.BodyEnabled then ApplyBodyFF() end end)
visSec:Toggle("力场工具", FF_S.ToolEnabled, function(v)
    FF_S.ToolEnabled = v
    if v then
        local char = LocalPlayer.Character; local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then for _, p in ipairs(tool:GetDescendants()) do if p:IsA("BasePart") and not FF_S.ToolProps[p] then FF_S.ToolProps[p] = { Material = p.Material, Color = p.Color } end end end
        task.delay(0.1, function() if FF_S.ToolEnabled then ApplyToolFF() end end)
    else RestoreTool() end
end):AddKeybind("工具力场开关", Enum.KeyCode.H, "Toggle")

local tracerSec = Tabs.Visuals:Section("弹道追踪", "auto")
local tracer = tracerSec:Toggle("启用追踪", TR.Enabled, function(v) TR.Enabled = v end):AddKeybind("追踪开关", Enum.KeyCode.T, "Toggle")
tracer:Colorpicker("追踪颜色", TR.Color, function(c, a) TR.Color = c; TR.Alpha = a end)
tracerSec:Slider("追踪大小", 0.1, 10, TR.Size, 0.1, function(v) TR.Size = v end)

local hitlogSec = Tabs.Visuals:Section("命中日志", "auto")
hitlogSec:Toggle("启用命中日志", HitLogEnabled, function(v) HitLogEnabled = v; if HitLog.Gui then HitLog.Gui.Enabled = v end end):AddKeybind("日志开关", Enum.KeyCode.J, "Toggle")

local espSec = Tabs.Visuals:Section("ESP", "auto")
espSec:Toggle("名牌", NametagEnabled, function(v) NametagEnabled = v end):AddKeybind("名牌开关", Enum.KeyCode.N, "Toggle")
espSec:Toggle("距离", DistanceEnabled, function(v) DistanceEnabled = v end)
espSec:Toggle("生命值", HealthEnabled, function(v) HealthEnabled = v end)
espSec:Toggle("保险箱高亮", SafeChamsEnabled, function(v) SafeChamsEnabled = v; if v then StartSafeChams() end end)
local cham = espSec:Toggle("高亮", espSets.enabled, function(v)
    espSets.enabled = v
    if not v then
        if BoxESP.Conn.M then BoxESP.Conn.M:Disconnect() end
        for _, c in pairs(BoxESP.Conn) do if typeof(c) == "RBXScriptConnection" then c:Disconnect() end end
        for p in pairs(BoxESP.Boxes) do clearBoxes(p) end
        BoxESP = { Boxes = {}, Conn = {} }
    else
        local function s(p)
            if p == LocalPlayer then return end
            BoxESP.Conn[p] = p.CharacterAdded:Connect(function() task.wait(0.5); updatePlayerBoxes(p) end)
            if p.Character then updatePlayerBoxes(p) end
        end
        for _, p in pairs(Players:GetPlayers()) do s(p) end
        BoxESP.Conn.M = Players.PlayerAdded:Connect(s)
    end
end):AddKeybind("高亮开关", Enum.KeyCode.B, "Toggle")
cham:Colorpicker("轮廓颜色", espSets.outCol, function(c, a) espSets.outCol = c; espSets.outAlpha = a; if espSets.enabled then refreshAllESP() end end)
espSec:Toggle("仅目标", espSets.targetOnly, function(v) espSets.targetOnly = v; if espSets.enabled then refreshAllESP() end end)
espSec:Toggle("轮廓", espSets.outline, function(v) espSets.outline = v end)
local inline = espSec:Toggle("内部填充", espSets.inline, function(v) espSets.inline = v end)
inline:Colorpicker("内部颜色", espSets.inCol, function(c, a) espSets.inCol = c; espSets.inAlpha = a; if espSets.enabled then refreshAllESP() end end)
espSec:Slider("轮廓大小", 0.01, 1, espSets.outSize, 0.01, function(v) espSets.outSize = v end)
espSec:Slider("内部填充大小", 0.01, 0.5, espSets.inSize, 0.01, function(v) espSets.inSize = v end)

local worldSec = Tabs.Visuals:Section("世界视觉", "auto")
worldSec:Toggle("光照模式", WV.LightingModeEnabled, function(v) WV.LightingModeEnabled = v end)
worldSec:Dropdown("技术", { "兼容", "阴影贴图", "体素", "未来" }, "阴影贴图", function(v)
    local techMap = { ["兼容"] = "Compatible", ["阴影贴图"] = "ShadowMap", ["体素"] = "Voxel", ["未来"] = "Future" }
    WV.LightingMode = techMap[v]
end)
worldSec:Toggle("世界时间", WV.WorldTimeEnabled, function(v) WV.WorldTimeEnabled = v end)
worldSec:Slider("时间", 0, 24, WV.WorldTime, 0.1, function(v) WV.WorldTime = v end)
worldSec:Toggle("自定义环境光", WV.AmbientEnabled, function(v) WV.AmbientEnabled = v end)
worldSec:Colorpicker("室内光", WV.AmbientColor, function(v) WV.AmbientColor = v end)
worldSec:Colorpicker("室外光", WV.OutdoorAmbientColor, function(v) WV.OutdoorAmbientColor = v end)
worldSec:Slider("视野范围", 50, 180, 70, function(v) CAM_FOV = math.floor(v); Camera.FieldOfView = CAM_FOV; if not CAM_FOV_Conn then CAM_FOV_Conn = Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function() if CAM_FOV then Camera.FieldOfView = CAM_FOV end end) end end)
worldSec:Slider("相机距离", 1, 40, 10, function(v) LocalPlayer.CameraMaxZoomDistance = v; pcall(function() game:GetService("StarterPlayer").CameraMaxZoomDistance = v end) end)
worldSec:Toggle("自定义天空盒", WV.SkyboxEnabled, function(v) WV.SkyboxEnabled = v end)
worldSec:Dropdown("天空盒主题", { "黑色风暴", "蓝色太空", "写实", "暴风雨", "粉色" }, "黑色风暴", function(v)
    local skyMap = { ["黑色风暴"] = "Black Storm", ["蓝色太空"] = "Blue Space", ["写实"] = "Realistic", ["暴风雨"] = "Stormy", ["粉色"] = "Pink" }
    WV.SkyboxType = skyMap[v]
end)
local wx = worldSec:Toggle("天气", WV.WeatherEnabled, function(v) WV.WeatherEnabled = v; WV_WeatherPart.Parent = v and Workspace or nil end)
wx:Colorpicker("天气颜色", WV.WeatherColor, function(v) WV.WeatherColor = v; WV_Emitter.Color = ColorSequence.new(v) end)
worldSec:Dropdown("天气类型", { "雨", "雪" }, "雨", function(v)
    WV.WeatherType = v == "雨" and "Rain" or "Snow"
    if v == "雨" then WV_Emitter.Texture = "rbxassetid://1822883048"; WV_Emitter.Speed = NumberRange.new(60); WV_Emitter.Size = NumberSequence.new(10)
    else WV_Emitter.Texture = "http://www.roblox.com/asset/?id=99851851"; WV_Emitter.Speed = NumberRange.new(30); WV_Emitter.Size = NumberSequence.new(0.35) end
end)
worldSec:Slider("天气速率", 100, 2000, WV.WeatherRate, 1, function(v) WV_Emitter.Rate = v end)
local atmo = worldSec:Toggle("大气", WV.AtmosphereEnabled, function(v) WV.AtmosphereEnabled = v end)
atmo:Colorpicker("颜色", WV.AtmoColor, function(v) WV.AtmoColor = v end)
atmo:Colorpicker("衰减", WV.AtmoDecay, function(v) WV.AtmoDecay = v end)
worldSec:Slider("密度", 0, 1, WV.AtmoDensity, 0.01, function(v) WV.AtmoDensity = v end)
worldSec:Slider("雾霾", 0, 10, WV.AtmoHaze, 0.1, function(v) WV.AtmoHaze = v end)
worldSec:Slider("眩光", 0, 10, WV.AtmoGlare, 0.1, function(v) WV.AtmoGlare = v end)
worldSec:Toggle("背景噪音", WV.BGSoundEnabled, function(v) if v then WV_BGSound:Play() else WV_BGSound:Stop() end end)
worldSec:Dropdown("音轨", { "冬日寒风", "雷暴", "小雨", "夜晚", "白天" }, "夜晚", function(v)
    local soundMap = { ["冬日寒风"] = "Windy Winter", ["雷暴"] = "Thunderstorm", ["小雨"] = "Light Rain", ["夜晚"] = "Night", ["白天"] = "Day" }
    WV_BGSound.SoundId = WV_Sounds[soundMap[v]]
    if WV_BGSound.IsPlaying then WV_BGSound:Stop(); WV_BGSound:Play() end
end)
worldSec:Slider("音量", 0, 100, WV.BGSoundVolume, 1, function(v) WV_BGSound.Volume = v / 100; WV.BGSoundVolume = v end)
local playerSec = Tabs.Player:Section("移动", "auto")
playerSec:Toggle("步行速度", SpeedState, function(v) SpeedState = v end):AddKeybind("加速开关", Enum.KeyCode.Q, "Toggle")
playerSec:Slider("步行速度值", 1, 100, SpeedValue, 0.1, function(v) SpeedValue = v end)
playerSec:Toggle("跳跃力度", JumpState, function(v) JumpState = v end)
playerSec:Slider("跳跃力度值", 1, 100, JumpValue, 0.1, function(v) JumpValue = v end)
playerSec:Toggle("无坠落", NoFallEnabled, function(v) NoFallEnabled = v end)
local fly = playerSec:Toggle("飞行", FLY.Enabled, function(v)
    FLY.Enabled = v
    if FLY.MobileMode then
        if v then FlyCreateUI(); FlyOn() else FlyOff(); FlyDestroyUI() end
    else
        if v then FlyOn() else FlyOff() end
    end
end):AddKeybind("飞行开关", Enum.KeyCode.F, "Toggle")
playerSec:Slider("飞行速度", 1, 100, FLY.Speed, function(v) FLY.Speed = v end)
playerSec:Toggle("移动端模式", FLY.MobileMode, function(v) FLY.MobileMode = v end)
playerSec:Toggle("无限体力", InfStaminaEnabled, function(v)
    InfStaminaEnabled = v
    if InfStaminaConnection then InfStaminaConnection:Disconnect(); InfStaminaConnection = nil end
    if v then
        local ok = pcall(function()
            local tgt = getupvalue(getrenv()._G.S_Take, 2)
            local old
            old = hookfunction(tgt, function(v1, ...) if InfStaminaEnabled then v1 = 0 end return old(v1, ...) end)
        end)
        if not ok then
            local tbs = {}
            local function collect() tbs = {}; for _, v in pairs(getgc(true)) do if type(v) == "table" and rawget(v, "S") then tbs[#tbs+1] = v end end end
            pcall(collect)
            InfStaminaConnection = RunService.RenderStepped:Connect(function()
                if InfStaminaEnabled then
                    if tick() % 5 < 0.1 then pcall(collect) end
                    for _, t in ipairs(tbs) do pcall(function() t.S = 100 end) end
                    local c = LocalPlayer.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
                    if h then h:SetAttribute("ZSPRN_M", true) end
                end
            end)
        end
    else
        local c = LocalPlayer.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then h:SetAttribute("ZSPRN_M", nil) end
    end
end):AddKeybind("无限体力开关", Enum.KeyCode.R, "Toggle")

local antiSec = Tabs.Antis:Section("反击打", "auto")
antiSec:Dropdown("头部模式", { "隐藏头部", "偏航头部", "自定义" }, nil, function(v)
    local headMap = { ["隐藏头部"] = "Hide head", ["偏航头部"] = "Yaw head", ["自定义"] = "Custom" }
    local mapped = headMap[v]
    if not mapped and OriginalNeckC0 then
        local ch = LocalPlayer.Character
        if ch then
            local hd = ch:FindFirstChild("Head")
            local ts = ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
            local nk = (hd and hd:FindFirstChild("Neck")) or (ts and ts:FindFirstChild("Neck"))
            if nk then nk.C0 = OriginalNeckC0; nk.C1 = OriginalNeckC1 end
        end
        OriginalNeckC0, OriginalNeckC1 = nil, nil
    end
    HeadYawTime = 0
    HeadMode = mapped
end)
antiSec:Slider("自定义偏航", -90, 90, HeadCustomYaw, 0.1, function(v) HeadYaw = v; HeadCustomYaw = v end)
antiSec:Slider("旋转速度", -50, 50, HeadRotSpeed, 0.1, function(v) HeadRotSpeed = v end)
antiSec:Dropdown("手部模式", { "举手", "张开双手" }, nil, function(v)
    HandsModSelection = v == "举手" and "Hands up" or "Open hands"
end)
antiSec:Toggle("乱飞", LF.Enabled, function(v)
    LF.Enabled = v
    if not v then
        if LF.Track1 then pcall(function() LF.Track1:Stop(0) end); LF.Track1 = nil end
        if LF.Track2 then pcall(function() LF.Track2:Stop(0) end); LF.Track2 = nil end
        LF.Angle = 0
    end
end):AddKeybind("乱飞开关", Enum.KeyCode.K, "Toggle")
antiSec:Toggle("隐身", Invis_Enabled, function(v)
    Invis_Enabled = v
    if not v then
        if Invis_Track then pcall(function() Invis_Track:Stop() end); Invis_Track = nil end
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") and p.Transparency == 0.5 then p.Transparency = 0 end
            end
        end
    end
end):AddKeybind("隐身开关", Enum.KeyCode.I, "Toggle")

local desyncSec = Tabs.Antis:Section("速度不同步", "auto")
desyncSec:Toggle("启用", DS.Enabled, function(v) DS.Enabled = v end):AddKeybind("反同步开关", Enum.KeyCode.L, "Toggle")
desyncSec:Toggle("可视化", DS.Visualize, function(v) DS.Visualize = v end)
desyncSec:Slider("TP速率", 1, 100, DS.TPRate, function(v) DS.TPRate = v end)
desyncSec:Slider("X偏移", 1, 20, DS.X, 0.1, function(v) DS.X = v end)
desyncSec:Slider("Y偏移", 1, 20, DS.Y, 0.1, function(v) DS.Y = v end)
desyncSec:Slider("Z偏移", 1, 20, DS.Z, 0.1, function(v) DS.Z = v end)

local miscSec = Tabs.Misc:Section("Shift锁定", "auto")
miscSec:Toggle("反自动Shift锁定", MC.AntiShift, function(v) MC.AntiShift = v end):AddKeybind("反Shift开关", Enum.KeyCode.U, "Toggle")
miscSec:Slider("延迟", 0.01, 0.5, MC.ShiftDelay, 0.01, function(v) MC.ShiftDelay = v end)

local farmSec = Tabs.Misc:Section("刷资源", "auto")
farmSec:Toggle("自动拾取金钱", SC.APM_Enabled, function(v) SC.APM_Enabled = v; if v then StartAutoPickUpMoney() end end):AddKeybind("自动拾取开关", Enum.KeyCode.P, "Toggle")
farmSec:Toggle("自动解锁保险箱", SC.AUS_Enabled, function(v) SC.AUS_Enabled = v; if v then StartAutoUnlockSafe() end end):AddKeybind("解锁保险箱开关", Enum.KeyCode.O, "Toggle")

local camMiscSec = Tabs.Misc:Section("相机", "auto")
camMiscSec:Toggle("平滑相机", MC.SmoothCam, function(v) MC.SmoothCam = v; if not v then MC.SmoothPos = nil end end)
camMiscSec:Slider("平滑速度", 1, 10, MC.LerpSpeed, function(v) MC.LerpSpeed = v end)

local listSec = Tabs.Lists:Section("目标列表", "auto")
PL_TargetSearch = listSec:MultiDropdown("目标", {}, function(v) TargetList = v; if espSets.enabled and espSets.targetOnly then refreshAllESP() end end)
listSec:Button("清除目标", function() TargetList = {}; pcall(function() PL_TargetSearch:Set({}) end); if espSets.enabled and espSets.targetOnly then refreshAllESP() end end)
local whiteSec = Tabs.Lists:Section("白名单", "auto")
PL_WhiteSearch = whiteSec:MultiDropdown("白名单", {}, function(v) WhiteList = v end)
whiteSec:Button("清除白名单", function() WhiteList = {}; pcall(function() PL_WhiteSearch:Set({}) end) end)

local setSec = Tabs.Settings:Section("UI 设置", "auto")
setSec:Toggle("水印", true, function(v) end)
setSec:Toggle("按键列表", true, function(v) end)
setSec:Slider("淡入淡出时间", 0, 1, 0.3, 0.01, function(v) end)
setSec:Slider("补间时间", 0, 1, 0.2, 0.01, function(v) end)
setSec:Dropdown("DPI", { "50%", "70%", "80%", "90%", "100%", "110%", "120%" }, "80%", function(v)
    if getgenv().d2 then getgenv().d2.Scale = tonumber(v:match("%d+")) / 100 end
end)
setSec:Dropdown("补间样式", { "Linear", "Quad", "Quart", "Back", "Bounce", "Circular", "Cubic", "Elastic", "Exponential", "Sine", "Quint" }, "Cubic", function(v) end)
setSec:Dropdown("补间方向", { "In", "Out", "InOut" }, "Out", function(v) end)
setSec:Button("卸载脚本", function() end)
setSec:Keybind("菜单按键绑定", Enum.KeyCode.RightControl, "Toggle", function(v) end)

Window:Open()

local lastTickHadGun = false
RunService.Heartbeat:Connect(function()
    if not MC.AntiShift then return end
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    local hasGun = tool ~= nil and tool:FindFirstChild("IsGun") ~= nil
    if lastTickHadGun and not hasGun then
        task.delay(MC.ShiftDelay, function() firesignal(ChangeMouseLockEvent.Event); UIS.MouseBehavior = Enum.MouseBehavior.Default end)
    end
    lastTickHadGun = hasGun
end)

local NametagEnabled, DistanceEnabled, HealthEnabled = false, false, false
local LastVisualUpdate, LastContentUpdate = 0, 0
local CONFIG = {
    Rate_Active = 1/12, Rate_Idle = 1, ContentRate = 1/14,
    StrokeThickness = 0.8, DistOffset = Vector3.new(0, -5.5, 0), NameOffset = Vector3.new(0, 5, 0),
}
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
                local ch = player.Character; local h = ch:FindFirstChildOfClass("Humanoid")
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

local function onCharacterAdded(c) if c then CurrentHum = c:WaitForChild("Humanoid",10) end end
onCharacterAdded(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

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
                local s = Instance.new("Sound", Camera); s.SoundId = HitSounds[HitSoundSelection]; s.Volume = 1; s:Play()
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
                    args[1][1][1] = Vector3.new(-4237.62255859375, 9848.9267578125, -2292.4501953125)
                    args[1][1][2] = Vector3.new(-4264.8974609375, 0.9520299434661865, -556.17333984375)
                elseif HandsModSelection == "Open hands" then
                    args[1][1][1] = Vector3.new(0.006237113382667303, 6, 0.18136750161647797)
                    args[1][1][2] = Vector3.new(0.006237113382667303, 6, 0.18136750161647797)
                end
                if HeadMode == "Hide head" then args[1][1][3] = Vector3.new(0.006237113382667303, -6, -0.18136750161647797) end
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

RunService.Heartbeat:Connect(function()
    DoRagebot()
end)

Players.PlayerAdded:Connect(function(p)
    if PL_TargetSearch then PL_TargetSearch:Add(p.Name) end
    if PL_WhiteSearch then PL_WhiteSearch:Add(p.Name) end
end)
Players.PlayerRemoving:Connect(function(p)
    if PL_TargetSearch then PL_TargetSearch:Remove(p.Name) end
    if PL_WhiteSearch then PL_WhiteSearch:Remove(p.Name) end
    clearBoxes(p)
end)