local function UltimateAntiBAC()
    if game:GetService("RunService"):IsStudio() then return end

    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local TeleportService = game:GetService("TeleportService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer

    local hiddenModules = {}
    local protectedGuis = {}
    local originalFunctions = {}
    local function saveOrig(name, f) originalFunctions[name] = f end
    local function getOrig(name) return originalFunctions[name] end

    if getgc then saveOrig("getgc", getgc) getgc = function(...) return {} end end
    if getreg then saveOrig("getreg", getreg) getreg = function() return setmetatable({}, {__index=function() end}) end end
    if getfenv then saveOrig("getfenv", getfenv) getfenv = function(idx) if idx == 0 then return getOrig("getfenv")(idx) end return setmetatable({}, {__index=function() end}) end end
    if getnilinstances then saveOrig("getnilinstances", getnilinstances) getnilinstances = function() return {} end end

    local function blockDebug()
        local old_getinfo = debug.getinfo
        debug.getinfo = function(thread, f, ...)
            if type(f) == "function" then
                local info = old_getinfo(f, "S")
                if info and info.source:lower():find("anti") then
                    return nil
                end
            end
            return old_getinfo(thread, f, ...)
        end
        saveOrig("debug.getupvalue", debug.getupvalue)
        debug.getupvalue = function(func, idx)
            if type(func) == "function" then
                local info = debug.getinfo(func, "S")
                if info and info.source:lower():find("anti") then return nil end
            end
            return getOrig("debug.getupvalue")(func, idx)
        end
        saveOrig("debug.setupvalue", debug.setupvalue)
        debug.setupvalue = function(func, idx, val)
            if type(func) == "function" then
                local info = debug.getinfo(func, "S")
                if info and info.source:lower():find("anti") then return nil end
            end
            return getOrig("debug.setupvalue")(func, idx, val)
        end
        saveOrig("debug.getconstant", debug.getconstant)
        debug.getconstant = function(func, idx)
            if type(func) == "function" then
                local info = debug.getinfo(func, "S")
                if info and info.source:lower():find("anti") then return nil end
            end
            return getOrig("debug.getconstant")(func, idx)
        end
        saveOrig("debug.setconstant", debug.setconstant)
        debug.setconstant = function(func, idx, val)
            if type(func) == "function" then
                local info = debug.getinfo(func, "S")
                if info and info.source:lower():find("anti") then return nil end
            end
            return getOrig("debug.setconstant")(func, idx, val)
        end
    end
    pcall(blockDebug)

    local function isACModule(mod)
        if type(mod) ~= "table" then return false end
        local nm = (mod.Name or ""):lower()
        if nm:match("anti") or nm:match("bac") or nm:match("cheat") or nm:match("ac") then return true end
        for _, v in pairs(mod) do
            if type(v) == "function" then
                for i = 1, 200 do
                    local ok, uv = pcall(debug.getupvalue, v, i)
                    if not ok or not uv then break end
                    if type(uv) == "function" and (debug.getinfo(uv,"n").name or ""):lower():match("check") then
                        return true
                    end
                end
            end
        end
        return false
    end

    saveOrig("require", require)
    require = function(mod, ...)
        local res = getOrig("require")(mod, ...)
        if type(mod) == "string" and isACModule(res) then
            if not hiddenModules[mod] then
                hiddenModules[mod] = true
                for k, v in pairs(res) do
                    if type(v) == "function" then
                        res[k] = function() return true end
                    end
                end
                pcall(function()
                    local mt = getmetatable(res)
                    if mt then mt.__index = function() return function() end end end
                end)
            end
        end
        return res
    end

    for _, mod in ipairs(getloadedmodules()) do
        if isACModule(mod) then
            hiddenModules[mod.Name or "Unknown"] = true
            for k, v in pairs(mod) do
                if type(v) == "function" then
                    mod[k] = function() return true end
                end
            end
        end
    end

    local blockedKeywords = {"ban", "report", "analytics", "anticheat", "detection", "log", "flag"}
    local function isUrlBlocked(url)
        if type(url) ~= "string" then return false end
        for _, kw in ipairs(blockedKeywords) do
            if url:lower():find(kw) then return true end
        end
        return false
    end

    local httpMethods = {"GetAsync", "PostAsync", "RequestAsync", "Get", "Post", "Request"}
    for _, methodName in ipairs(httpMethods) do
        local original = HttpService[methodName]
        if original then
            saveOrig("HttpService."..methodName, original)
            HttpService[methodName] = function(self, ...)
                local args = {...}
                local url = args[1]
                if isUrlBlocked(url) then
                    return '{"success":true}'
                end
                return original(self, ...)
            end
        end
    end

    local function hideSelf()
        local ourScript = script or (getfenv and getfenv(1).script)
        if ourScript then
            pcall(function() ourScript.Parent = nil end)
        end
        local env = getfenv(1)
        for k, v in pairs(env) do
            if type(v) == "function" then
                local info = debug.getinfo(v, "S")
                if info and info.source and info.source:find(ourScript and ourScript.Name or "") then
                    env[k] = nil
                end
            end
        end
    end
    pcall(hideSelf)

    if TeleportService then
        saveOrig("TeleportService.Teleport", TeleportService.Teleport)
        TeleportService.Teleport = function() end
        saveOrig("TeleportService.TeleportToPrivateServer", TeleportService.TeleportToPrivateServer)
        TeleportService.TeleportToPrivateServer = function() end
    end

    local function destroySuspiciousRemotes()
        for _, v in ipairs(game:GetDescendants()) do
            if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
                local name = v.Name:lower()
                if name:find("anti") or name:find("ban") or name:find("report") or name:find("flag") then
                    pcall(function() v:Destroy() end)
                end
            end
        end
    end
    pcall(destroySuspiciousRemotes)

    game.DescendantAdded:Connect(function(v)
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
            local name = v.Name:lower()
            if name:find("anti") or name:find("ban") or name:find("report") or name:find("flag") then
                pcall(function() v:Destroy() end)
            end
        end
    end)

    local function registerGuiProtection(guiObject)
        if not guiObject then return end
        protectedGuis[guiObject] = true
        guiObject.Name = HttpService:GenerateGUID(false):sub(1, 10)
    end

    local function installGuiHooks()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local function wrapFindFirstChild(instance)
            local origFind = instance.FindFirstChild
            if origFind then
                instance.FindFirstChild = function(self, name, recursive)
                    local result = origFind(self, name, recursive)
                    if result and protectedGuis[result] then return nil end
                    return result
                end
            end
        end
        local function wrapWaitForChild(instance)
            local origWait = instance.WaitForChild
            if origWait then
                instance.WaitForChild = function(self, name, timeout)
                    local result = origWait(self, name, timeout)
                    if result and protectedGuis[result] then return nil end
                    return result
                end
            end
        end
        local function wrapGetChildren(instance)
            local origGet = instance.GetChildren
            if origGet then
                instance.GetChildren = function(self)
                    local children = origGet(self)
                    local filtered = {}
                    for _, child in ipairs(children) do
                        if not protectedGuis[child] then
                            table.insert(filtered, child)
                        end
                    end
                    return filtered
                end
            end
        end
        local function processContainer(container)
            wrapFindFirstChild(container)
            wrapWaitForChild(container)
            wrapGetChildren(container)
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("ScreenGui") or child:IsA("Folder") then
                    processContainer(child)
                end
            end
        end
        processContainer(playerGui)
        playerGui.ChildAdded:Connect(function(child)
            if child:IsA("ScreenGui") then processContainer(child) end
        end)
        pcall(function()
            local core = CoreGui
            wrapFindFirstChild(core)
            wrapWaitForChild(core)
            wrapGetChildren(core)
            core.ChildAdded:Connect(function(child)
                if child:IsA("ScreenGui") then processContainer(child) end
            end)
        end)
    end
    installGuiHooks()

    getfenv(1).ProtectGui = registerGuiProtection

    local function fakeHeartbeat()
        local lastHB = tick()
        local fakeConn
        fakeConn = RunService.Heartbeat:Connect(function()
            lastHB = tick()
        end)
        task.spawn(function()
            while true do
                task.wait(5)
                if tick() - lastHB > 10 then
                    pcall(function()
                        RunService.Heartbeat:Wait()
                    end)
                end
            end
        end)
    end
    pcall(fakeHeartbeat)

    task.spawn(function()
        while task.wait(15) do
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, attr in ipairs(char:GetAttributes()) do
                        if attr:lower():find("script") or attr:lower():find("bypass") or attr:lower():find("anti") or attr:lower():find("flag") then
                            char:SetAttribute(attr, nil)
                        end
                    end
                end
                for _, v in ipairs(game:GetDescendants()) do
                    if (v:IsA("StringValue") or v:IsA("IntValue") or v:IsA("BoolValue")) and (v.Name:lower():find("anti") or v.Name:lower():find("ban") or v.Name:lower():find("flag")) then
                        v:Destroy()
                    end
                end
                collectgarbage("collect")
            end)
        end
    end)

    print("[Ultimate AntiBAC] Loaded")
end

xpcall(UltimateAntiBAC, function(err) warn("[Ultimate AntiBAC] Error:", err) end)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles
Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local winTitle = "Aero"
local winFooter = "Made by Aero"

local Window = Library:CreateWindow({
    Title = winTitle,
    Footer = winFooter,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Combat = Window:AddTab("战斗", "crosshair"),
    Skins = Window:AddTab("皮肤", "swords"),
    Visuals = Window:AddTab("视觉", "eye"),
    ["UI Settings"] = Window:AddTab("界面设置", "settings"),
}

local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CAS = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local CharactersFolder = workspace:WaitForChild("Characters", 10)

local getTFolder = function() return CharactersFolder:FindFirstChild("Terrorists") end
local getCTFolder = function() return CharactersFolder:FindFirstChild("Counter-Terrorists") end
local isAlive = function()
    local t, ct = getTFolder(), getCTFolder()
    return (t and t:FindFirstChild(player.Name)) or (ct and ct:FindFirstChild(player.Name))
end
local getEnemyFolder = function()
    if not isAlive() then return nil end
    local t, ct = getTFolder(), getCTFolder()
    if t and t:FindFirstChild(player.Name) then return ct end
    if ct and ct:FindFirstChild(player.Name) then return t end
    return nil
end
local wallCheckParams = RaycastParams.new()
wallCheckParams.FilterType = Enum.RaycastFilterType.Exclude
local IsVisible = function(p)
    if not p then return false end
    local c = player.Character
    if not c then return false end
    local h = c:FindFirstChild("Head")
    if not h then return false end
    local el = {c}
    if camera then table.insert(el, camera) end
    wallCheckParams.FilterDescendantsInstances = el
    local r = Workspace:Raycast(h.Position, (p.Position - h.Position).Unit * 1000, wallCheckParams)
    if r then return r.Instance:IsDescendantOf(p.Parent) end
    return true
end

local hotkeyValues = {"LeftAlt","LeftShift","RightShift","LeftControl","RightControl","Q","E","R","F","X","C","V","鼠标右键","鼠标左键","鼠标中键"}
local hotkeyMap = {
    ["LeftAlt"]=Enum.KeyCode.LeftAlt, ["LeftShift"]=Enum.KeyCode.LeftShift,
    ["RightShift"]=Enum.KeyCode.RightShift, ["LeftControl"]=Enum.KeyCode.LeftControl,
    ["RightControl"]=Enum.KeyCode.RightControl, ["Q"]=Enum.KeyCode.Q, ["E"]=Enum.KeyCode.E,
    ["R"]=Enum.KeyCode.R, ["F"]=Enum.KeyCode.F, ["X"]=Enum.KeyCode.X, ["C"]=Enum.KeyCode.C,
    ["V"]=Enum.KeyCode.V, ["鼠标右键"]=Enum.UserInputType.MouseButton2,
    ["鼠标左键"]=Enum.UserInputType.MouseButton1, ["鼠标中键"]=Enum.UserInputType.MouseButton3,
}
local getHotkeyName = function(k) for n,v in pairs(hotkeyMap) do if v==k then return n end end return "鼠标右键" end

local function isEnemy(plr)
    if plr == player then return false end
    if plr.Team and player.Team then return plr.Team ~= player.Team end
    local mc = player.Character local tc = plr.Character
    if not mc or not tc or not mc.Parent or not tc.Parent then return false end
    return mc.Parent.Name ~= tc.Parent.Name
end

local Cleaner = {}
Cleaner.__index = Cleaner
function Cleaner.new() return setmetatable({ tasks = {} }, Cleaner) end
function Cleaner:Give(fn) table.insert(self.tasks, fn) end
function Cleaner:Cleanup() for _, fn in ipairs(self.tasks) do pcall(fn) end; self.tasks = {} end

local ErrorHandler = {}
ErrorHandler.__index = ErrorHandler
function ErrorHandler.new() return setmetatable({}, ErrorHandler) end
function ErrorHandler:Connect(event, name, fn) local conn = event:Connect(fn) return function() conn:Disconnect() end end
function ErrorHandler:Spawn(name, fn) task.spawn(fn) end

local globals = {}
function globals:GetPlayer() return player end
function globals:IsAlive() return isAlive() and player.Character or nil end
function globals:GetCamera() return workspace.CurrentCamera end
function globals:GetTargetModels(teamCheck)
    local targets = {}
    local ef = getEnemyFolder()
    if not ef then return targets end
    for _, v in ipairs(ef:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") then
            local hum = v:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if teamCheck then
                    local plr = Players:GetPlayerFromCharacter(v)
                    if plr and not isEnemy(plr) then else table.insert(targets, v) end
                else table.insert(targets, v) end
            end
        end
    end
    return targets
end

local VisualAimbot = {Enabled = false, ShowFOV = false, Radius = 100, Smooth = 3, Mode = "自动", WallCheck = false, Key = Enum.UserInputType.MouseButton2, KeyHeld = false}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
FOVCircle.Radius = VisualAimbot.Radius
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Visible = false
FOVCircle.Thickness = 1

local getClosestEnemy = function()
    local cl, sd = nil, VisualAimbot.Radius
    local ef = getEnemyFolder() if not ef or not VisualAimbot.Enabled then return nil end
    local mp = UserInputService:GetMouseLocation()
    for _, e in ipairs(ef:GetChildren()) do
        local hum = e:FindFirstChildOfClass("Humanoid") local hd = e:FindFirstChild("Head")
        if hum and hum.Health>0 and hd then
            if VisualAimbot.WallCheck and not IsVisible(hd) then continue end
            local hp, on = camera:WorldToViewportPoint(hd.Position)
            if on then
                local d = (Vector2.new(hp.X, hp.Y) - mp).Magnitude
                if d < sd then sd = d; cl = hd end
            end
        end
    end
    return cl
end

UserInputService.InputBegan:Connect(function(i) if i.UserInputType == VisualAimbot.Key or i.KeyCode == VisualAimbot.Key then VisualAimbot.KeyHeld = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == VisualAimbot.Key or i.KeyCode == VisualAimbot.Key then VisualAimbot.KeyHeld = false end end)

RunService.RenderStepped:Connect(function()
    if VisualAimbot.ShowFOV then
        FOVCircle.Position = UserInputService:GetMouseLocation(); FOVCircle.Radius = VisualAimbot.Radius; FOVCircle.Visible = true
    else FOVCircle.Visible = false end
    if not VisualAimbot.Enabled or not isAlive() then return end
    local aim = (VisualAimbot.Mode == "自动") or (VisualAimbot.Mode == "热键" and VisualAimbot.KeyHeld)
    if not aim then return end
    local t = getClosestEnemy()
    if t and mousemoverel then
        local hp = camera:WorldToViewportPoint(t.Position) local mp = UserInputService:GetMouseLocation()
        mousemoverel((hp.X - mp.X)/VisualAimbot.Smooth, (hp.Y - mp.Y)/VisualAimbot.Smooth)
    end
end)

local CombatGroup = Tabs.Combat:AddLeftGroupbox("视觉自瞄", "target")
CombatGroup:AddToggle("AimbotToggle", { Text = "启用视觉自瞄", Default = false, Callback = function(v) VisualAimbot.Enabled = v end })
CombatGroup:AddDropdown("AimbotMode", { Text = "自瞄模式", Values = {"自动","热键"}, Default = "自动", Callback = function(v) VisualAimbot.Mode = v end })
CombatGroup:AddDropdown("AimbotHotkey", { Text = "自瞄热键", Values = hotkeyValues, Default = getHotkeyName(VisualAimbot.Key), Callback = function(v) VisualAimbot.Key = hotkeyMap[v] or Enum.UserInputType.MouseButton2 end })
CombatGroup:AddToggle("AimbotWallCheck", { Text = "墙壁检测", Default = false, Callback = function(v) VisualAimbot.WallCheck = v end })
CombatGroup:AddToggle("FOVToggle", { Text = "显示FOV圈", Default = false, Callback = function(v) VisualAimbot.ShowFOV = v end })
CombatGroup:AddSlider("FOVSlider", { Text = "FOV半径", Default = 100, Min = 10, Max = 500, Rounding = 0, Suffix = "px", Callback = function(v) VisualAimbot.Radius = v end })
CombatGroup:AddSlider("AimbotSmoothing", { Text = "平滑度", Default = 3, Min = 1, Max = 10, Rounding = 0, Suffix = "", Callback = function(v) VisualAimbot.Smooth = v end })

local TriggerBot = {Enabled = false, Delay = 0, Mode = "自动", WallCheck = false, Key = Enum.KeyCode.E, KeyHeld = false}
UserInputService.InputBegan:Connect(function(i) if i.UserInputType == TriggerBot.Key or i.KeyCode == TriggerBot.Key then TriggerBot.KeyHeld = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == TriggerBot.Key or i.KeyCode == TriggerBot.Key then TriggerBot.KeyHeld = false end end)

local TriggerGroup = Tabs.Combat:AddLeftGroupbox("自动扳机", "target")
TriggerGroup:AddToggle("TriggerBotToggle", { Text = "启用自动扳机", Default = false, Callback = function(v) TriggerBot.Enabled = v end })
TriggerGroup:AddDropdown("TriggerBotMode", { Text = "扳机模式", Values = {"自动","热键"}, Default = "自动", Callback = function(v) TriggerBot.Mode = v end })
TriggerGroup:AddDropdown("TriggerBotHotkey", { Text = "扳机热键", Values = hotkeyValues, Default = getHotkeyName(TriggerBot.Key), Callback = function(v) TriggerBot.Key = hotkeyMap[v] or Enum.KeyCode.E end })
TriggerGroup:AddToggle("TriggerBotWallCheck", { Text = "墙壁检测", Default = false, Callback = function(v) TriggerBot.WallCheck = v end })
TriggerGroup:AddSlider("TriggerBotDelay", { Text = "射击延迟", Default = 0, Min = 0, Max = 500, Rounding = 0, Suffix = "ms", Callback = function(v) TriggerBot.Delay = v end })

task.spawn(function()
    while task.wait(0.01) do
        local shoot = false
        if TriggerBot.Enabled and isAlive() then
            if TriggerBot.Mode == "自动" then shoot = true elseif TriggerBot.Mode == "热键" then shoot = TriggerBot.KeyHeld end
        end
        if not shoot then continue end
        local ray = camera:ViewportPointToRay(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Exclude
        local ignore = {camera}; if player.Character then table.insert(ignore, player.Character) end
        params.FilterDescendantsInstances = ignore
        local result = Workspace:Raycast(ray.Origin, ray.Direction*1000, params)
        if result and result.Instance then
            local model = result.Instance:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChildOfClass("Humanoid") then
                local ef = getEnemyFolder()
                if ef and model.Parent == ef then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        if TriggerBot.WallCheck and not IsVisible(model:FindFirstChild("Head")) then continue end
                        if TriggerBot.Delay > 0 then task.wait(TriggerBot.Delay/1000) end
                        if mouse1click then mouse1click() end
                        task.wait(0.05)
                    end
                end
            end
        end
    end
end)

local Hitbox = {Enabled = false, Size = 3}
local originalHeadSizes = {}
local HitboxGroup = Tabs.Combat:AddLeftGroupbox("命中框扩大", "target")
HitboxGroup:AddToggle("HitboxToggle", { Text = "启用命中框扩大", Default = false, Callback = function(v) Hitbox.Enabled = v end })
HitboxGroup:AddSlider("HitboxSize", { Text = "大小", Default = 3, Min = 1, Max = 3, Rounding = 1, Suffix = " 单位", Callback = function(v) Hitbox.Size = v end })
task.spawn(function()
    while task.wait(0.5) do
        local ef = getEnemyFolder()
        if ef then
            for _, e in ipairs(ef:GetChildren()) do
                local hd = e:FindFirstChild("Head") local hm = e:FindFirstChildOfClass("Humanoid")
                if hd and hm and hm.Health > 0 then
                    if not originalHeadSizes[hd] then originalHeadSizes[hd] = hd.Size end
                    if Hitbox.Enabled then
                        hd.Size = Vector3.new(Hitbox.Size, Hitbox.Size, Hitbox.Size)
                        hd.CanCollide = false; hd.Transparency = 0.5
                    else
                        hd.Size = originalHeadSizes[hd] or Vector3.new(2,2,1); hd.Transparency = 0
                    end
                end
            end
        end
    end
end)

local Bhop = {Enabled = false}
local MovementGroup = Tabs.Combat:AddLeftGroupbox("移动", "activity")
MovementGroup:AddToggle("BhopToggle", { Text = "连跳 (按住空格)", Default = false, Callback = function(v) Bhop.Enabled = v end })
RunService.RenderStepped:Connect(function()
    if Bhop.Enabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) and isAlive() then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
            hum.Jump = true
        end
    end
end)

local SpeedHack = {Enabled = false, Value = 0.5}
MovementGroup:AddToggle("SpeedHackEnabled", { Text = "加速 (Speed Hack)", Default = false, Callback = function(v) SpeedHack.Enabled = v end })
MovementGroup:AddSlider("SpeedHackValue", { Text = "加速倍率", Default = 0.5, Min = 0.1, Max = 1, Rounding = 1, Callback = function(v) SpeedHack.Value = v end })

local Wallbang = {Enabled = false, Mode = "自动", Key = Enum.KeyCode.F, KeyHeld = false, Delay = 0.5, HitPart = "身体", SoundEnabled = true, SoundID = "92723765069002", TargetMode = "全部随机"}
local SelectedTargets = {}

local TargetSelectGui = Instance.new("ScreenGui")
TargetSelectGui.Name = "WallbangTargets"
TargetSelectGui.ResetOnSpawn = false
TargetSelectGui.IgnoreGuiInset = true
TargetSelectGui.Parent = player:WaitForChild("PlayerGui")
local TargetFrame = Instance.new("Frame")
TargetFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
TargetFrame.BackgroundTransparency = 0.2
TargetFrame.BorderSizePixel = 0
TargetFrame.Size = UDim2.new(0,200,0,300)
TargetFrame.Position = UDim2.new(0.7,0,0.2,0)
TargetFrame.Visible = false
TargetFrame.Parent = TargetSelectGui
local TargetScrolling = Instance.new("ScrollingFrame")
TargetScrolling.BackgroundTransparency = 1
TargetScrolling.Size = UDim2.new(1,0,1,-30)
TargetScrolling.CanvasSize = UDim2.new(0,0,0,0)
TargetScrolling.Parent = TargetFrame
local TargetTitle = Instance.new("TextLabel")
TargetTitle.Text = "选择目标"
TargetTitle.BackgroundTransparency = 1
TargetTitle.Size = UDim2.new(1,0,0,30)
TargetTitle.Position = UDim2.new(0,0,1,-30)
TargetTitle.TextColor3 = Color3.new(1,1,1)
TargetTitle.Parent = TargetFrame

local targetToggles = {}

local function updateTargetList()
    for _, toggle in pairs(targetToggles) do toggle:Destroy() end
    table.clear(targetToggles)
    local yPos = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if isEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local name = plr.Name
            local frame = Instance.new("Frame")
            frame.BackgroundTransparency = 1
            frame.Size = UDim2.new(1,0,0,25)
            frame.Position = UDim2.new(0,0,0,yPos)
            frame.Parent = TargetScrolling
            local btn = Instance.new("TextButton")
            btn.Text = name
            btn.BackgroundColor3 = SelectedTargets[name] and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,80)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Size = UDim2.new(1,0,1,0)
            btn.Parent = frame
            btn.MouseButton1Click:Connect(function()
                SelectedTargets[name] = not SelectedTargets[name]
                btn.BackgroundColor3 = SelectedTargets[name] and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,80)
            end)
            table.insert(targetToggles, frame)
            yPos = yPos + 25
        end
    end
    TargetScrolling.CanvasSize = UDim2.new(0,0,0,yPos)
end

task.spawn(function()
    while task.wait(5) do updateTargetList() end
end)
Players.PlayerAdded:Connect(updateTargetList)
Players.PlayerRemoving:Connect(function(p)
    SelectedTargets[p.Name] = nil
    updateTargetList()
end)

local function getWallbangTarget(hrp, partName)
    local ef = getEnemyFolder()
    if not ef then return nil end
    local enemies = {}
    for _, enemy in ipairs(ef:GetChildren()) do
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local part = enemy:FindFirstChild(partName) or enemy:FindFirstChild("HumanoidRootPart")
            if part then table.insert(enemies, { model = enemy, part = part, hum = hum }) end
        end
    end
    if #enemies == 0 then return nil end
    if Wallbang.TargetMode == "全部随机" then
        return enemies[math.random(1, #enemies)]
    else
        local valid = {}
        for _, e in ipairs(enemies) do
            if SelectedTargets[e.model.Name] then table.insert(valid, e) end
        end
        if #valid == 0 then return nil end
        return valid[math.random(1, #valid)]
    end
end

local HitNotif = {
    Enabled = true, Style = "胶囊", BgColor = Color3.fromRGB(25,25,25), BgTrans = 0.3,
    TextColor = Color3.fromRGB(255,255,255), DeathColor = Color3.fromRGB(255,50,50),
    OffsetX = 0, OffsetY = 0, Scale = 1, MaxCount = 5, Duration = 4
}
local bgR,bgG,bgB = 25,25,25; local textR,textG,textB = 255,255,255; local deathR,deathG,deathB = 255,50,50

local wallRemote = nil
local wallRemoteFetched = false
local function getWallRemote()
    if wallRemoteFetched then return wallRemote end
    for _, v in next, getgc(true) do
        if type(v) == "table" and rawget(v, string.char(83,104,111,111,116,87,101,97,112,111,110)) then
            wallRemote = v; wallRemoteFetched = true; return v
        end
    end
    return nil
end

local wallCurrentWeapon = nil
local wallLastShot = 0
local hitPartMap = {["头部"]="Head", ["身体"]="HumanoidRootPart", ["左腿"]="LeftLowerLeg", ["右腿"]="RightLowerLeg", ["左臂"]="LeftLowerArm", ["右臂"]="RightLowerArm"}
local killSounds = {
    {Name = "超级击杀", ID = "92723765069002"},{Name = "我们之中", ID = "7227567562"},{Name = "怪物杀戮", ID = "132012038491424"},
    {Name = "叮", ID = "2866718318"},{Name = "鲜血", ID = "128741351184513"},{Name = "黄金", ID = "18888511866"},
    {Name = "瓦洛兰特", ID = "18560690982"},{Name = "咚", ID = "7269900245"},{Name = "动漫", ID = "80440627510518"},
    {Name = "现代战争", ID = "130439616552357"},{Name = "战斗", ID = "7228383943"},{Name = "呀", ID = "111609064980370"},
    {Name = "咯", ID = "80847075127412"}
}
local function playSoundSafe(id)
    if not id or id == "" then return end
    local snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://"..id
    snd.Volume = 1
    snd.Parent = camera
    snd:Play()
    task.delay(3, function() if snd then snd:Destroy() end end)
end

local notifGui = Instance.new("ScreenGui")
notifGui.Name = "WallbangNotifs"; notifGui.ResetOnSpawn = false; notifGui.IgnoreGuiInset = true
notifGui.Parent = player:WaitForChild("PlayerGui")
local notifTemplate = Instance.new("Frame")
notifTemplate.BackgroundColor3 = HitNotif.BgColor; notifTemplate.BackgroundTransparency = HitNotif.BgTrans
notifTemplate.BorderSizePixel = 0; notifTemplate.Size = UDim2.new(0,200,0,30); notifTemplate.Visible = false
local templateCorner = Instance.new("UICorner"); templateCorner.CornerRadius = UDim.new(0,15); templateCorner.Parent = notifTemplate
local templateLabel = Instance.new("TextLabel")
templateLabel.BackgroundTransparency = 1; templateLabel.Size = UDim2.new(1,-10,1,0); templateLabel.Position = UDim2.new(0,5,0,0)
templateLabel.Font = Enum.Font.Gotham; templateLabel.TextSize = 18; templateLabel.TextColor3 = HitNotif.TextColor
templateLabel.TextStrokeTransparency = 0.8; templateLabel.TextXAlignment = Enum.TextXAlignment.Left; templateLabel.Parent = notifTemplate

local activeNotifs = {}
local function adjustNotifs()
    local baseY = 50 + HitNotif.OffsetY
    local yOff = 0
    for _, entry in ipairs(activeNotifs) do
        local frame = entry.frame
        if frame and frame.Parent then
            local targetX = camera.ViewportSize.X - frame.AbsoluteSize.X - 15 + HitNotif.OffsetX
            local targetY = baseY + yOff
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, targetX, 0, targetY)
            }):Play()
            yOff = yOff + frame.AbsoluteSize.Y + 5
        end
    end
end
local function createNotif(text, textColor, bgColor, bgTrans)
    if HitNotif.MaxCount > 0 then
        while #activeNotifs >= HitNotif.MaxCount do
            local old = table.remove(activeNotifs, 1)
            if old.frame and old.frame.Parent then old.frame:Destroy() end
        end
    end
    local frame = notifTemplate:Clone()
    frame.BackgroundColor3 = bgColor; frame.BackgroundTransparency = 1
    frame.Visible = true; frame.Parent = notifGui
    local label = frame:FindFirstChildOfClass("TextLabel")
    if label then
        label.Text = text; label.TextColor3 = textColor; label.TextSize = 18 * HitNotif.Scale
        label.TextTransparency = 1
    end
    local corner = frame:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = (HitNotif.Style == "胶囊") and UDim.new(0, 15*HitNotif.Scale) or UDim.new(0,0)
    end
    local textSize = TextService:GetTextSize(text, label.TextSize, label.Font, Vector2.new(1920,1080))
    frame.Size = UDim2.new(0, textSize.X + 20*HitNotif.Scale, 0, textSize.Y + 12*HitNotif.Scale)
    frame.Position = UDim2.new(1, 50, 0, 50)
    local entry = {frame = frame, createdAt = tick()}
    table.insert(activeNotifs, entry)
    adjustNotifs()
    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = bgTrans}):Play()
    if label then TweenService:Create(label, TweenInfo.new(0.25), {TextTransparency = 0}):Play() end
    task.delay(HitNotif.Duration, function()
        if frame and frame.Parent then
            TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = frame.Position + UDim2.new(0, 50, 0, 0)
            }):Play()
            task.delay(0.3, function()
                if frame and frame.Parent then frame:Destroy() end
                for i, v in ipairs(activeNotifs) do if v == entry then table.remove(activeNotifs, i); break end end
                adjustNotifs()
            end)
        end
    end)
    return entry
end

local function isWallbangWeapon(t)
    if not t then return false end
    local p = rawget(t, "Properties")
    return p and rawget(p, "FireRate") and rawget(p, "BulletsPerShot") and rawget(p, "Rounds")
end

local function updateWallWeapon()
    for _, v in next, getgc(true) do
        if type(v) == "table" and rawget(v, "IsEquipped") and rawget(v, "Identifier") and rawget(v, "Player") == player then
            if isWallbangWeapon(v) then wallCurrentWeapon = v; return true end
        end
    end
    wallCurrentWeapon = nil; return false
end

local noAmmoNotified = false

local function wallbangShoot()
    if not Wallbang.Enabled then return end
    task.wait(math.random() * 0.05)
    if tick() - wallLastShot < Wallbang.Delay then return end
    local char = player.Character
    if not char or char:GetAttribute("Dead") then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not wallCurrentWeapon or not rawget(wallCurrentWeapon, "IsEquipped") then
        if not updateWallWeapon() then return end
    end
    if not isWallbangWeapon(wallCurrentWeapon) then wallCurrentWeapon = nil; return end
    local prop = rawget(wallCurrentWeapon, "Properties")
    local max = rawget(prop, "Rounds"); local cur = rawget(wallCurrentWeapon, "Rounds")
    if not (max and cur) then return end

    if cur <= 0 then
        if not noAmmoNotified and HitNotif.Enabled then
            createNotif("子弹耗尽，请手动换弹！", Color3.fromRGB(255,255,0), HitNotif.BgColor, HitNotif.BgTrans)
            noAmmoNotified = true
        end
        return
    else
        if noAmmoNotified then
            if HitNotif.Enabled then
                createNotif("弹药已恢复，继续穿墙", Color3.fromRGB(0,255,0), HitNotif.BgColor, HitNotif.BgTrans)
            end
            noAmmoNotified = false
        end
    end

local remote = getWallRemote()
    if not remote or not remote.ShootWeapon then return end
    local partName = hitPartMap[Wallbang.HitPart] or "HumanoidRootPart"
    local target = getWallbangTarget(hrp.Position, partName)
    if not target then return end
    wallLastShot = tick()
    local origin = camera.CFrame.Position
    local dir = (target.part.Position - origin).Unit
    wallCurrentWeapon.Rounds = cur - 1
    remote.ShootWeapon.Send({
        IsSniperScoped = false, ShootingHand = "Right",
        Identifier = wallCurrentWeapon.Identifier, Capacity = wallCurrentWeapon.Capacity, Rounds = wallCurrentWeapon.Rounds,
        Bullets = {{ Direction = dir, Origin = origin, Hits = {{ Instance = target.part, Position = target.part.Position, Normal = -dir, Material = "Plastic", Distance = (target.part.Position - origin).Magnitude, Exit = false }} }}
    })
    local enemyName = target.model and target.model.Name or "Unknown"
    if HitNotif.Enabled then
        createNotif(string.format("Attacking %s - %s - HP: %d", enemyName, Wallbang.HitPart, math.floor(target.hum.Health)), HitNotif.TextColor, HitNotif.BgColor, HitNotif.BgTrans)
    end
    local targetHum = target.hum
    local targetName = enemyName
    task.delay(0.3, function()
        local isDead = false
        if targetHum then
            if targetHum.Health <= 0 or not targetHum.Parent then isDead = true end
        else
            isDead = true
        end
        if isDead then
            if HitNotif.Enabled then
                createNotif(string.format("Attacking %s - %s - DEAD", targetName, Wallbang.HitPart), HitNotif.DeathColor, HitNotif.BgColor, HitNotif.BgTrans)
            end
            if Wallbang.SoundEnabled then playSoundSafe(Wallbang.SoundID) end
        end
    end)
end

UserInputService.InputBegan:Connect(function(i) if i.UserInputType == Wallbang.Key or i.KeyCode == Wallbang.Key then Wallbang.KeyHeld = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Wallbang.Key or i.KeyCode == Wallbang.Key then Wallbang.KeyHeld = false end end)
RunService.Heartbeat:Connect(function()
    if not Wallbang.Enabled then return end
    local shoot = false
    if Wallbang.Mode == "自动" then shoot = true elseif Wallbang.Mode == "热键" then shoot = Wallbang.KeyHeld end
    if shoot and isAlive() then wallbangShoot() end
end)

local WallbangGroup = Tabs.Combat:AddRightGroupbox("静默穿墙", "crosshair")
WallbangGroup:AddToggle("WallbangToggle", { Text = "启用穿墙", Default = false, Callback = function(v) Wallbang.Enabled = v end })
WallbangGroup:AddDropdown("WallbangMode", { Text = "模式", Values = {"自动","热键"}, Default = "自动", Callback = function(v) Wallbang.Mode = v end })
WallbangGroup:AddDropdown("WallbangHotkey", { Text = "热键", Values = hotkeyValues, Default = getHotkeyName(Wallbang.Key), Callback = function(v) Wallbang.Key = hotkeyMap[v] or Enum.KeyCode.F end })
WallbangGroup:AddSlider("WallbangDelay", { Text = "射击间隔", Default = 0.5, Min = 0.2, Max = 2, Rounding = 2, Suffix = "秒", Callback = function(v) Wallbang.Delay = v end })
WallbangGroup:AddDropdown("WallbangHitPart", { Text = "击打部位", Values = {"头部","身体","左腿","右腿","左臂","右臂"}, Default = "身体", Callback = function(v) Wallbang.HitPart = v end })
WallbangGroup:AddDropdown("WallbangTargetMode", { Text = "目标模式", Values = {"全部随机", "指定玩家"}, Default = "全部随机", Callback = function(v)
    Wallbang.TargetMode = v
    TargetFrame.Visible = (v == "指定玩家")
    if v == "指定玩家" then updateTargetList() end
end })
WallbangGroup:AddToggle("WallbangSoundToggle", { Text = "击杀音效", Default = true, Callback = function(v) Wallbang.SoundEnabled = v end })
WallbangGroup:AddDropdown("WallbangSound", { Text = "击杀音效", Values = {"超级击杀","我们之中","怪物杀戮","叮","鲜血","黄金","瓦洛兰特","咚","动漫","现代战争","战斗","呀","咯"}, Default = "超级击杀", Callback = function(v) for _,s in ipairs(killSounds) do if s.Name==v then Wallbang.SoundID=s.ID; playSoundSafe(s.ID) break end end end })
WallbangGroup:AddDivider(); WallbangGroup:AddLabel("击杀提示")
WallbangGroup:AddToggle("HitNotifEnabled", { Text = "启用击杀提示", Default = true, Callback = function(v) HitNotif.Enabled = v end })
WallbangGroup:AddDropdown("HitNotifStyle", { Text = "样式", Values = {"胶囊","矩形"}, Default = "胶囊", Callback = function(v) HitNotif.Style = v end })
WallbangGroup:AddSlider("HitNotifBgTrans", { Text = "背景透明度", Default = 0.3, Min = 0, Max = 1, Rounding = 1, Suffix = "", Callback = function(v) HitNotif.BgTrans = v end })
WallbangGroup:AddSlider("HitNotifOffsetX", { Text = "X偏移", Default = 0, Min = -500, Max = 500, Rounding = 0, Suffix = "px", Callback = function(v) HitNotif.OffsetX = v end })
WallbangGroup:AddSlider("HitNotifOffsetY", { Text = "Y偏移", Default = 0, Min = -500, Max = 500, Rounding = 0, Suffix = "px", Callback = function(v) HitNotif.OffsetY = v end })
WallbangGroup:AddSlider("HitNotifScale", { Text = "整体大小", Default = 1, Min = 0.5, Max = 2, Rounding = 1, Suffix = "x", Callback = function(v) HitNotif.Scale = v end })
WallbangGroup:AddSlider("NotifMaxCount", { Text = "最大通知数量", Default = 5, Min = 0, Max = 15, Rounding = 0, Suffix = " (0=无限)", Callback = function(v) HitNotif.MaxCount = v end })
WallbangGroup:AddSlider("NotifDuration", { Text = "通知停留时间", Default = 4, Min = 1, Max = 10, Rounding = 1, Suffix = "秒", Callback = function(v) HitNotif.Duration = v end })
WallbangGroup:AddLabel("背景颜色 RGB")
WallbangGroup:AddSlider("BgR", { Text = "红", Default = 25, Min = 0, Max = 255, Rounding = 0, Callback = function(v) bgR=v; HitNotif.BgColor=Color3.fromRGB(bgR,bgG,bgB) end })
WallbangGroup:AddSlider("BgG", { Text = "绿", Default = 25, Min = 0, Max = 255, Rounding = 0, Callback = function(v) bgG=v; HitNotif.BgColor=Color3.fromRGB(bgR,bgG,bgB) end })
WallbangGroup:AddSlider("BgB", { Text = "蓝", Default = 25, Min = 0, Max = 255, Rounding = 0, Callback = function(v) bgB=v; HitNotif.BgColor=Color3.fromRGB(bgR,bgG,bgB) end })
WallbangGroup:AddLabel("文字颜色 RGB")
WallbangGroup:AddSlider("TextR", { Text = "红", Default = 255, Min = 0, Max = 255, Rounding = 0, Callback = function(v) textR=v; HitNotif.TextColor=Color3.fromRGB(textR,textG,textB) end })
WallbangGroup:AddSlider("TextG", { Text = "绿", Default = 255, Min = 0, Max = 255, Rounding = 0, Callback = function(v) textG=v; HitNotif.TextColor=Color3.fromRGB(textR,textG,textB) end })
WallbangGroup:AddSlider("TextB", { Text = "蓝", Default = 255, Min = 0, Max = 255, Rounding = 0, Callback = function(v) textB=v; HitNotif.TextColor=Color3.fromRGB(textR,textG,textB) end })
WallbangGroup:AddLabel("击杀文字颜色 RGB")
WallbangGroup:AddSlider("DeathR", { Text = "红", Default = 255, Min = 0, Max = 255, Rounding = 0, Callback = function(v) deathR=v; HitNotif.DeathColor=Color3.fromRGB(deathR,deathG,deathB) end })
WallbangGroup:AddSlider("DeathG", { Text = "绿", Default = 50, Min = 0, Max = 255, Rounding = 0, Callback = function(v) deathG=v; HitNotif.DeathColor=Color3.fromRGB(deathR,deathG,deathB) end })
WallbangGroup:AddSlider("DeathB", { Text = "蓝", Default = 50, Min = 0, Max = 255, Rounding = 0, Callback = function(v) deathB=v; HitNotif.DeathColor=Color3.fromRGB(deathR,deathG,deathB) end })

local scriptRunning = false
local selectedKnife = "Butterfly Knife"
local spawned = false; local inspecting = false; local swinging = false; local lastAttackTime = 0
local ATTACK_COOLDOWN = 1
local ACTION_INSPECT = "InspectKnifeAction"; local ACTION_ATTACK = "AttackKnifeAction"
pcall(function() RS.Assets.Weapons.Karambit.Camera.ViewmodelLight.Transparency = 1 end)
local knives = {
    ["Karambit"]={Offset=CFrame.new(0,-1.5,1.5)}, ["Butterfly Knife"]={Offset=CFrame.new(0,-1.5,1.5)},
    ["M9 Bayonet"]={Offset=CFrame.new(0,-1.5,1)}, ["Flip Knife"]={Offset=CFrame.new(0,-1.5,1.25)},
    ["Gut Knife"]={Offset=CFrame.new(0,-1.5,0.5)}, ["Stiletto Knife"]={Offset=CFrame.new(0,-1.5,1.25)},
    ["Skeleton Knife"]={Offset=CFrame.new(0,-1.5,1.25)}
}
local vm, animator
local equipAnim, idleAnim, inspectAnim, HeavySwingAnim, Swing1Anim, Swing2Anim
local function getKnifeInCamera() return camera:FindFirstChild("T Knife") or camera:FindFirstChild("CT Knife") end
local function cleanPart(p) if p:IsA("BasePart") then p.CanCollide,p.Anchored,p.CastShadow,p.CanTouch,p.CanQuery = false,false,false,false,false end end
local function disableCollisions(m) for _,p in m:GetDescendants() do cleanPart(p) end end
local function hideOriginalKnife(k) for _,p in k:GetDescendants() do if p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("Texture") then p.Transparency=1 end end end
local function playSound(folder,name)
    local ws = RS.Sounds:FindFirstChild(selectedKnife); if not ws then return end
    local s = ws:WaitForChild(folder):WaitForChild(name):Clone(); s.Parent=camera; s:Play(); s.Ended:Once(function() s:Destroy() end); return s
end
local function attachAsset(folder,armPart,assetModel,finalName,offset)
    local arm = vm:FindFirstChild(armPart); if not arm then return end
    local mesh = folder:WaitForChild(assetModel):Clone(); cleanPart(mesh); mesh.Name=finalName; mesh.Parent=arm
    local motor = Instance.new("Motor6D"); motor.Part0,motor.Part1,motor.C0,motor.Parent = arm,mesh,offset,arm
end
local function handleAction(actionName, inputState, inputObject)
    if inputState ~= Enum.UserInputState.Begin or not spawned or not animator or not isAlive() then return Enum.ContextActionResult.Pass end
    if actionName == ACTION_INSPECT then
        if (equipAnim and equipAnim.IsPlaying) or inspecting or swinging then return Enum.ContextActionResult.Pass end
        inspecting = true; if idleAnim then idleAnim:Stop() end; inspectAnim:Play(); inspectAnim.Stopped:Once(function() inspecting=false end)
    elseif actionName == ACTION_ATTACK then
        local ct = os.clock()
        if (equipAnim and equipAnim.IsPlaying) or (ct-lastAttackTime<ATTACK_COOLDOWN) then return Enum.ContextActionResult.Pass end
        lastAttackTime = ct; if inspecting then inspecting=false; if inspectAnim then inspectAnim:Stop() end end
        swinging=true; if idleAnim then idleAnim:Stop() end
        local anims = {HeavySwingAnim,Swing1Anim,Swing2Anim}; local chosen = anims[math.random(1,#anims)]
        local sf = (chosen==HeavySwingAnim and "HitOne") or (chosen==Swing1Anim and "HitTwo") or "HitThree"
        chosen:Play(); local s = playSound(sf,"1"); if s then s.Volume=5 end; chosen.Stopped:Once(function() swinging=false end)
    end
    return Enum.ContextActionResult.Pass
end
local function removeViewmodel()
    spawned=false; CAS:UnbindAction(ACTION_INSPECT); CAS:UnbindAction(ACTION_ATTACK)
    if vm then vm:Destroy() vm=nil end; animator,inspecting,swinging = nil,false,false
end
local function spawnViewmodel(knife)
    if spawned or not scriptRunning then return end
    local myModel = isAlive(); if not myModel then return end
    spawned=true; local knifeTemplate = RS.Assets.Weapons:WaitForChild(selectedKnife)
    local knifeOffset = knives[selectedKnife].Offset
    vm = knifeTemplate:WaitForChild("Camera"):Clone(); vm.Name,vm.Parent = selectedKnife,camera
    disableCollisions(vm); hideOriginalKnife(knife)
    if myModel.Parent.Name == "Terrorists" then
        local tg = RS.Assets.Weapons:WaitForChild("T Glove")
        attachAsset(tg,"Left Arm","Left Arm","Glove",CFrame.new(0,0,-1.5))
        attachAsset(tg,"Right Arm","Right Arm","Glove",CFrame.new(0,0,-1.5))
    else
        local sleeves = RS.Assets.Sleeves:WaitForChild("IDF"); local ctg = RS.Assets.Weapons:WaitForChild("CT Glove")
        attachAsset(sleeves,"Left Arm","Left Arm","Sleeve",CFrame.new(0,0,0.5))
        attachAsset(ctg,"Left Arm","Left Arm","Glove",CFrame.new(0,0,-1.5))
        attachAsset(sleeves,"Right Arm","Right Arm","Sleeve",CFrame.new(0,0,0.5))
        attachAsset(ctg,"Right Arm","Right Arm","Glove",CFrame.new(0,0,-1.5))
    end
    local ac = vm:FindFirstChildOfClass("AnimationController") or vm:FindFirstChildOfClass("Animator")
    animator = ac:FindFirstChildWhichIsA("Animator") or ac
    local af = RS.Assets.WeaponAnimations:WaitForChild(selectedKnife):WaitForChild("CameraAnimations")
    equipAnim = animator:LoadAnimation(af:WaitForChild("Equip"))
    idleAnim = animator:LoadAnimation(af:WaitForChild("Idle"))
    inspectAnim = animator:LoadAnimation(af:WaitForChild("Inspect"))
    HeavySwingAnim = animator:LoadAnimation(af:WaitForChild("Heavy Swing"))
    Swing1Anim = animator:LoadAnimation(af:WaitForChild("Swing1"))
    Swing2Anim = animator:LoadAnimation(af:WaitForChild("Swing2"))
    vm:SetPrimaryPartCFrame(camera.CFrame * CFrame.new(0,-1.5,5))
    TweenService:Create(vm.PrimaryPart, TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {CFrame=camera.CFrame*knifeOffset}):Play()
    equipAnim:Play(); playSound("Equip","1")
    CAS:BindAction(ACTION_INSPECT,handleAction,false,Enum.KeyCode.F)
    CAS:BindAction(ACTION_ATTACK,handleAction,false,Enum.UserInputType.MouseButton1)
end
RunService.RenderStepped:Connect(function()
    if not scriptRunning or not vm or not vm.PrimaryPart then return end
    vm.PrimaryPart.CFrame = camera.CFrame * knives[selectedKnife].Offset
    if not (equipAnim and equipAnim.IsPlaying) and not inspecting and not swinging then
        if idleAnim and not idleAnim.IsPlaying then idleAnim:Play() end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        local living = isAlive(); local currentKnife = getKnifeInCamera()
        if scriptRunning and living and currentKnife and not spawned then spawnViewmodel(currentKnife)
        elseif (not scriptRunning or not currentKnife or not living) and spawned then removeViewmodel() end
    end
end)

local SkinChangerEnabled = false
local SelectedSkins = {}; local DropdownObjects = {}; local SkinOptions = {}; local COOLDOWN = 0.1; local WEAR = "Factory New"
local CT_ONLY = {["USP-S"]=true,["Five-SeveN"]=true,["MP9"]=true,["FAMAS"]=true,["M4A1-S"]=true,["M4A4"]=true,["AUG"]=true}
local SHARED = {["P250"]=true,["Desert Eagle"]=true,["Dual Berettas"]=true,["Negev"]=true,["P90"]=true,["Nova"]=true,["XM1014"]=true,["AWP"]=true,["SSG 08"]=true}
local KNIVES = {["Karambit"]=true,["Butterfly Knife"]=true,["M9 Bayonet"]=true,["Flip Knife"]=true,["Gut Knife"]=true,["T Knife"]=true,["CT Knife"]=true,["Stiletto Knife"]=true,["Skeleton Knife"]=true}
local GLOVES = {["Sports Gloves"]=true}
local SkinsFolder = RS:WaitForChild("Assets"):WaitForChild("Skins")
local IgnoreFolders = {["HE Grenade"]=true,["Incendiary Grenade"]=true,["Molotov"]=true,["Smoke Grenade"]=true,["Flashbang"]=true,["Decoy Grenade"]=true,["C4"]=true,["CT Glove"]=true,["T Glove"]=true}
local function getAllSkins(f) local s={}; for _,sk in f:GetChildren() do table.insert(s,sk.Name) end; return s end
local function applyWeaponSkin(model)
    if not model or not SkinChangerEnabled or not isAlive() then return end
    local skinName = SelectedSkins[model.Name]; if not skinName then return end
    pcall(function()
        local skinFolder = SkinsFolder:FindFirstChild(model.Name); if not skinFolder then return end
        local skinType = skinFolder:FindFirstChild(skinName)
        local sourceFolder = skinType and skinType:FindFirstChild("Camera") and skinType.Camera:FindFirstChild(WEAR); if not sourceFolder then return end
        for _, obj in camera:GetChildren() do
            local left,right = obj:FindFirstChild("Left Arm"),obj:FindFirstChild("Right Arm")
            if left or right then
                local gf = SkinsFolder:FindFirstChild("Sports Gloves"); local gs = gf and gf:FindFirstChild(SelectedSkins["Sports Gloves"])
                local gsrc = gs and gs:FindFirstChild("Camera") and gs.Camera:FindFirstChild(WEAR)
                if gsrc then
                    for _, side in ipairs({"Left Arm","Right Arm"}) do
                        local arm,src = obj:FindFirstChild(side),gsrc:FindFirstChild(side)
                        if arm and src then
                            local gloveMesh = arm:FindFirstChild("Glove")
                            if gloveMesh then
                                local ex = gloveMesh:FindFirstChildOfClass("SurfaceAppearance"); if ex then ex:Destroy() end
                                local c = src:Clone(); c.Name,c.Parent = "SurfaceAppearance",gloveMesh
                            end
                        end
                    end
                end
            end
        end
        if not GLOVES[model.Name] then
            local wf = model:FindFirstChild("Weapon")
            if wf then
                for _, part in wf:GetDescendants() do
                    if part:IsA("BasePart") then
                        local ns = sourceFolder:FindFirstChild(part.Name)
                        if ns then
                            local ex = part:FindFirstChildOfClass("SurfaceAppearance"); if ex then ex:Destroy() end
                            local c = ns:Clone(); c.Name,c.Parent = "SurfaceAppearance",part
                        end
                    end
                end
            end
        end
        model:SetAttribute("SkinApplied",skinName)
    end)
end

local SkinsGroup = Tabs.Skins:AddLeftGroupbox("皮肤修改器", "palette")
SkinsGroup:AddToggle("SkinChangerToggle", { Text = "启用皮肤修改器", Default = false, Callback = function(v) SkinChangerEnabled=v; if not v then for _,obj in camera:GetChildren() do obj:SetAttribute("SkinApplied",nil) end end end })
SkinsGroup:AddButton({ Text = "随机所有皮肤", Func = function() for wn,ol in pairs(SkinOptions) do if #ol>0 then local rs=ol[math.random(1,#ol)]; if DropdownObjects[wn] then for _,dd in ipairs(DropdownObjects[wn]) do dd:SetValue(rs) end end end end end })
local KnifeGroup = Tabs.Skins:AddRightGroupbox("自定义刀子", "swords")
KnifeGroup:AddToggle("KnifeToggle", { Text = "启用自定义刀子", Default = false, Callback = function(v) scriptRunning=v; if not v then removeViewmodel() end end })
KnifeGroup:AddDropdown("KnifeDropdown", { Text = "选择自定义刀子", Values = {"Butterfly Knife","Karambit","M9 Bayonet","Flip Knife","Gut Knife","Stiletto Knife","Skeleton Knife"}, Default = "Butterfly Knife", Callback = function(v) selectedKnife=v; if spawned then removeViewmodel() end end })
local SkinsRightGroup = Tabs.Skins:AddRightGroupbox("武器皮肤", "palette")
local function CreateSkinDropdown(weaponName, group)
    local folder = SkinsFolder:FindFirstChild(weaponName); if not folder then return end
    local options = getAllSkins(folder); SkinOptions[weaponName] = options
    if #options>0 then if not SelectedSkins[weaponName] then SelectedSkins[weaponName]=options[1] end else SelectedSkins[weaponName]=nil end
    local dp = group:AddDropdown("Skin_"..weaponName:gsub("%W",""), {
        Name = weaponName, Text = weaponName, Values = options, Default = SelectedSkins[weaponName] or (options[1] or ""),
        Callback = function(opt) SelectedSkins[weaponName]=opt;
            if DropdownObjects[weaponName] then for _,other in ipairs(DropdownObjects[weaponName]) do if other.Value~=opt then other:SetValue(opt) end end end
            for _,obj in camera:GetChildren() do obj:SetAttribute("SkinApplied",nil); applyWeaponSkin(obj) end
        end
    })
    DropdownObjects[weaponName] = DropdownObjects[weaponName] or {}; table.insert(DropdownObjects[weaponName],dp)
end
SkinsRightGroup:AddDivider(); SkinsRightGroup:AddLabel("刀具皮肤"); for name in pairs(KNIVES) do CreateSkinDropdown(name,SkinsRightGroup) end
SkinsRightGroup:AddDivider(); SkinsRightGroup:AddLabel("手套"); for name in pairs(GLOVES) do CreateSkinDropdown(name,SkinsRightGroup) end
SkinsRightGroup:AddDivider(); SkinsRightGroup:AddLabel("CT武器"); for name in pairs(CT_ONLY) do CreateSkinDropdown(name,SkinsRightGroup) end
SkinsRightGroup:AddDivider(); SkinsRightGroup:AddLabel("T武器"); for name in pairs(SHARED) do CreateSkinDropdown(name,SkinsRightGroup) end
for _, folder in SkinsFolder:GetChildren() do
    local n = folder.Name
    if not IgnoreFolders[n] and not KNIVES[n] and not GLOVES[n] and not CT_ONLY[n] and not SHARED[n] then CreateSkinDropdown(n,SkinsRightGroup) end
end
camera.ChildAdded:Connect(function(obj) if not SkinChangerEnabled or not isAlive() then return end; task.wait(COOLDOWN); applyWeaponSkin(obj) end)
task.spawn(function() while task.wait(0.5) do if SkinChangerEnabled and isAlive() then for _,obj in camera:GetChildren() do if SelectedSkins[obj.Name] and obj:GetAttribute("SkinApplied")~=SelectedSkins[obj.Name] then applyWeaponSkin(obj) end end end end end)

local colorPresets = {"白色","红色","绿色","蓝色","黄色","青色","紫色","橙色","黑色"}
local colorValues = {
    ["白色"]=Color3.fromRGB(255,255,255),["红色"]=Color3.fromRGB(255,0,0),
    ["绿色"]=Color3.fromRGB(0,255,0),["蓝色"]=Color3.fromRGB(0,0,255),
    ["黄色"]=Color3.fromRGB(255,255,0),["青色"]=Color3.fromRGB(0,255,255),
    ["紫色"]=Color3.fromRGB(128,0,128),["橙色"]=Color3.fromRGB(255,165,0),
    ["黑色"]=Color3.fromRGB(0,0,0),
}
local Config = {
    ESP = {
        Enabled=true, TeamCheck=true, VisibilityCheck=true, MaxDistance=2000,
        Box=true, BoxThickness=1, BoxOutline=false, BoxFill=false,
        BoxFillColor1=Color3.fromRGB(255,0,0), BoxFillColor2=Color3.fromRGB(0,0,255),
        BoxFillTransparency=0.8, BoxFillFadeSpeed=3,
        Name=true, NameSize=13, Health=true, HealthBarCustom=false,
        HealthBarColor=Color3.fromRGB(0,255,0), Skeleton=false, SkeletonThickness=2,
        HeadDot=false, Highlight=true, Distance=true, CurrentWeapon=false,
        BoxColor=Color3.fromRGB(255,255,255), BoxVisibleColor=Color3.fromRGB(0,255,0), BoxNotVisibleColor=Color3.fromRGB(255,0,0),
        NameColor=Color3.fromRGB(255,255,255), NameVisibleColor=Color3.fromRGB(0,255,0), NameNotVisibleColor=Color3.fromRGB(255,0,0),
        SkeletonColor=Color3.fromRGB(255,255,255), SkeletonVisibleColor=Color3.fromRGB(0,255,0), SkeletonNotVisibleColor=Color3.fromRGB(255,0,0),
        HeadDotColor=Color3.fromRGB(255,255,255), HeadDotVisibleColor=Color3.fromRGB(0,255,0), HeadDotNotVisibleColor=Color3.fromRGB(255,0,0),
        HighlightFill=Color3.fromRGB(255,0,0), HighlightOutline=Color3.fromRGB(255,255,255),
        HighlightVisibleFill=Color3.fromRGB(0,255,0), HighlightHiddenFill=Color3.fromRGB(255,0,0),
        DistanceColor=Color3.fromRGB(255,255,255), WeaponColor=Color3.fromRGB(255,255,255),
    },
    WorldESP = {
        DroppedWeapons={Enabled=true, Box=true, Highlight=true, Name=true, Color=Color3.fromRGB(255,255,255)},
        Bomb={Enabled=true, Box=true, Highlight=true, Name=true, Color=Color3.fromRGB(255,0,0)},
        Molotovs={Enabled=true, Highlight=true, Color=Color3.fromRGB(255,165,0)},
        Smokes={Enabled=true, Highlight=true, Color=Color3.fromRGB(200,200,200)},
    },
    Charms={Enabled=true, TeamCheck=true, VisibleColor=Color3.fromRGB(255,0,0), HiddenColor=Color3.fromRGB(255,255,255), Transparency=0.5, AlwaysOnTop=true},
}

local function CreateColorDropdown(group, name, currentColor, callback, tooltip)
    local curName = "白色"
    for cname, col in pairs(colorValues) do
        if col.R == currentColor.R and col.G == currentColor.G and col.B == currentColor.B then curName = cname break end
    end
    group:AddDropdown("Color_" .. name, {
        Text = name, Values = colorPresets, Default = curName,
        Tooltip = tooltip or "", Callback = function(Value) callback(colorValues[Value]) end
    })
end

local drawings = {}
local highlights = {}
local function newDrawing(drawType, props)
    local s, d = pcall(function() local dr = Drawing.new(drawType); if dr and type(dr) ~= "number" then for k, v in pairs(props) do pcall(function() dr[k] = v end) end return dr end end)
    if s and d and type(d) ~= "number" then table.insert(drawings, d); return d end
end

local BONES_R15 = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","HumanoidRootPart"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"HumanoidRootPart","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"HumanoidRootPart","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
local BONES_R6 = {{"Head","Torso"},{"Torso","HumanoidRootPart"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"HumanoidRootPart","Left Leg"},{"HumanoidRootPart","Right Leg"}}

local espRayParams = RaycastParams.new(); espRayParams.FilterType = Enum.RaycastFilterType.Exclude; espRayParams.IgnoreWater = true
local function espIsVisible(originChar, targetChar)
    if not originChar or not targetChar or not targetChar.Parent then return true end
    local origin = originChar:FindFirstChild("Head") or originChar.PrimaryPart or originChar:FindFirstChild("HumanoidRootPart"); if not origin then return true end
    pcall(function() espRayParams.FilterDescendantsInstances = {originChar, targetChar} end)
    for _, partName in ipairs({"Head","HumanoidRootPart"}) do
        local part = targetChar:FindFirstChild(partName);
        if part and part:IsA("BasePart") then
            local dir = part.Position - origin.Position;
            if dir.Magnitude > 1 then
                local ray = Workspace:Raycast(origin.Position, dir.Unit * (dir.Magnitude - 0.5), espRayParams);
                if not ray then return true end
            end
        end
    end
    return false
end

local playerESP = {}
local function createPlayerESP()
    local e = {Box={},BoxOutline={},Skeleton={},Fill={},LastVisCheck=0,IsVisible=false}
    for i=1,4 do e.BoxOutline[i] = newDrawing("Line",{Thickness=3,Color=Color3.new(0,0,0),Visible=false,ZIndex=1}); e.Box[i] = newDrawing("Line",{Thickness=1,Visible=false,ZIndex=2}) end
    for i=1,2 do pcall(function() local tri = Drawing.new("Triangle"); if tri and type(tri)~="number" then tri.Filled=true; tri.Visible=false; tri.Transparency=0; tri.ZIndex=0; table.insert(drawings,tri); e.Fill[i]=tri end end) end
    for i=1,20 do e.Skeleton[i] = newDrawing("Line",{Thickness=2,Visible=false}) end
    e.HeadDot = newDrawing("Circle",{Thickness=1,NumSides=30,Filled=false,Visible=false})
    e.HpBg = newDrawing("Line",{Thickness=2,Visible=false,Color=Color3.new(0,0,0),Transparency=0.5,ZIndex=2})
    e.Hp = newDrawing("Line",{Thickness=2,Visible=false,ZIndex=3})
    e.Name = newDrawing("Text",{Size=13,Center=true,Outline=true,Font=2,Visible=false})
    e.Dist = newDrawing("Text",{Size=11,Center=true,Outline=true,Font=2,Visible=false})
    e.WeaponName = newDrawing("Text",{Size=12,Center=false,Outline=true,Font=2,Visible=false})
    local hl = Instance.new("Highlight"); hl.FillTransparency=0.5; hl.OutlineTransparency=0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Enabled=false; hl.Parent = CoreGui; e.HL=hl; table.insert(highlights,hl); return e
end
local function hidePlayerESP(e) if not e then return end for _,d in pairs(e.Box) do if d then d.Visible=false end end for _,d in pairs(e.BoxOutline) do if d then d.Visible=false end end for _,d in pairs(e.Skeleton) do if d then d.Visible=false end end for _,d in pairs(e.Fill) do pcall(function() d.Visible=false end) end if e.HeadDot then e.HeadDot.Visible=false end if e.HpBg then e.HpBg.Visible=false end if e.Hp then e.Hp.Visible=false end if e.Name then e.Name.Visible=false end if e.Dist then e.Dist.Visible=false end if e.WeaponName then e.WeaponName.Visible=false end if e.HL then e.HL.Enabled=false end end
local function destroyPlayerESP(e) hidePlayerESP(e); if not e then return end for _,list in pairs({e.Box,e.BoxOutline,e.Skeleton,e.Fill}) do for _,d in pairs(list) do if d then pcall(function() d:Remove() end) end end end if e.HeadDot then pcall(function() e.HeadDot:Remove() end) end if e.HpBg then pcall(function() e.HpBg:Remove() end) end if e.Hp then pcall(function() e.Hp:Remove() end) end if e.Name then pcall(function() e.Name:Remove() end) end if e.Dist then pcall(function() e.Dist:Remove() end) end if e.WeaponName then pcall(function() e.WeaponName:Remove() end) end if e.HL then pcall(function() e.HL:Destroy() end) end end
Players.PlayerAdded:Connect(function(p) if p ~= player then p.CharacterRemoving:Connect(function() if playerESP[p] then destroyPlayerESP(playerESP[p]); playerESP[p]=nil end end) end end)
Players.PlayerRemoving:Connect(function(p) if playerESP[p] then destroyPlayerESP(playerESP[p]); playerESP[p]=nil end end)

local worldESP = {DroppedWeapons={},Bomb=nil,Molotovs={},Smokes={}}
local function createWorldESPObj(hasName,hasRadius)
    local e = {Box={}}; if hasName then e.Name = newDrawing("Text",{Size=13,Center=true,Outline=true,Font=2,Visible=false}) end; if hasRadius then e.Radius = newDrawing("Circle",{Thickness=1.5,Filled=false,Visible=false,NumSides=60}) end
    for i=1,4 do e.Box[i] = newDrawing("Line",{Thickness=1,Visible=false,ZIndex=2}) end
    local hl = Instance.new("Highlight"); hl.FillTransparency=0.5; hl.OutlineTransparency=0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Enabled=false; hl.Parent = CoreGui; e.HL=hl; table.insert(highlights,hl); return e
end
local function hideWorldESPObj(e) if not e then return end for _,d in pairs(e.Box) do if d then d.Visible=false end end if e.Name then e.Name.Visible=false end if e.Radius then e.Radius.Visible=false end if e.HL then e.HL.Enabled=false end end
local function destroyWorldESPObj(e) hideWorldESPObj(e); if not e then return end for _,d in pairs(e.Box) do if d then pcall(function() d:Remove() end) end end if e.Name then pcall(function() e.Name:Remove() end) end if e.Radius then pcall(function() e.Radius:Remove() end) end if e.HL then pcall(function() e.HL:Destroy() end) end end

local function getFolderRadius(folder) if not folder or not folder:IsA("Folder") then return 0 end local minX,minZ,maxX,maxZ = math.huge,math.huge,-math.huge,-math.huge; local count=0; for _,child in ipairs(folder:GetChildren()) do if child:IsA("BasePart") then local p=child.Position; local s=child.Size; minX=math.min(minX,p.X-s.X/2); maxX=math.max(maxX,p.X+s.X/2); minZ=math.min(minZ,p.Z-s.Z/2); maxZ=math.max(maxZ,p.Z+s.Z/2); count=count+1 end end; if count==0 then return 0 end; return math.max(maxX-minX,maxZ-minZ)/2 end
local function getFolderCenter(folder) if not folder or not folder:IsA("Folder") then return nil end local sum=Vector3.new(0,0,0); local count=0; for _,child in ipairs(folder:GetChildren()) do if child:IsA("BasePart") then sum=sum+child.Position; count=count+1 end end; if count==0 then return nil end; return sum/count end

local charmCache, charmVisCache = {}, {}; local charmFolder = nil
local lastESPUpdate, lastWorldScan, lastCharmUpdate = 0,0,0

local function CreateVisualsUI()
    local VisGroup = Tabs.Visuals:AddLeftGroupbox("玩家 ESP", "eye")
    VisGroup:AddToggle("ESP.Enabled", {Text = "启用 ESP", Default = Config.ESP.Enabled, Tooltip = "显示敌人信息", Callback = function(v) Config.ESP.Enabled = v end})
    VisGroup:AddToggle("ESP.TeamCheck", {Text = "团队检查", Default = Config.ESP.TeamCheck, Tooltip = "不显示队友", Callback = function(v) Config.ESP.TeamCheck = v end})
    VisGroup:AddToggle("ESP.VisibilityCheck", {Text = "可见性检查", Default = Config.ESP.VisibilityCheck, Tooltip = "只有看得见才显示", Callback = function(v) Config.ESP.VisibilityCheck = v end})
    VisGroup:AddSlider("ESP.MaxDistance", {Text = "最大距离", Default = Config.ESP.MaxDistance, Min = 100, Max = 5000, Callback = function(v) Config.ESP.MaxDistance = v end})
    VisGroup:AddToggle("ESP.Box", {Text = "方框", Default = Config.ESP.Box, Tooltip = "显示方框", Callback = function(v) Config.ESP.Box = v end})
    VisGroup:AddToggle("ESP.BoxOutline", {Text = "方框轮廓", Default = Config.ESP.BoxOutline, Tooltip = "外描边", Callback = function(v) Config.ESP.BoxOutline = v end})
    VisGroup:AddSlider("ESP.BoxThickness", {Text = "方框粗细", Default = Config.ESP.BoxThickness, Min = 1, Max = 5, Callback = function(v) Config.ESP.BoxThickness = v end})
    CreateColorDropdown(VisGroup, "方框颜色", Config.ESP.BoxColor, function(v) Config.ESP.BoxColor = v end, "方框颜色")
    CreateColorDropdown(VisGroup, "方框可见颜色", Config.ESP.BoxVisibleColor, function(v) Config.ESP.BoxVisibleColor = v end, "可见时颜色")
    CreateColorDropdown(VisGroup, "方框不可见颜色", Config.ESP.BoxNotVisibleColor, function(v) Config.ESP.BoxNotVisibleColor = v end, "不可见时颜色")
    VisGroup:AddToggle("ESP.BoxFill", {Text = "方框填充", Default = Config.ESP.BoxFill, Tooltip = "填充方框", Callback = function(v) Config.ESP.BoxFill = v end})
    CreateColorDropdown(VisGroup, "填充颜色1", Config.ESP.BoxFillColor1, function(v) Config.ESP.BoxFillColor1 = v end, "渐变颜色1")
    CreateColorDropdown(VisGroup, "填充颜色2", Config.ESP.BoxFillColor2, function(v) Config.ESP.BoxFillColor2 = v end, "渐变颜色2")
    VisGroup:AddSlider("ESP.BoxFillTransparency", {Text = "填充透明度", Default = Config.ESP.BoxFillTransparency, Min = 0, Max = 1, Rounding = 1, Callback = function(v) Config.ESP.BoxFillTransparency = v end})
    VisGroup:AddSlider("ESP.BoxFillFadeSpeed", {Text = "渐变速度", Default = Config.ESP.BoxFillFadeSpeed, Min = 0.5, Max = 10, Rounding = 1, Callback = function(v) Config.ESP.BoxFillFadeSpeed = v end})
    VisGroup:AddToggle("ESP.Name", {Text = "名称", Default = Config.ESP.Name, Tooltip = "显示玩家名", Callback = function(v) Config.ESP.Name = v end})
    VisGroup:AddSlider("ESP.NameSize", {Text = "名称大小", Default = Config.ESP.NameSize, Min = 8, Max = 24, Callback = function(v) Config.ESP.NameSize = v end})
    CreateColorDropdown(VisGroup, "名称颜色", Config.ESP.NameColor, function(v) Config.ESP.NameColor = v end, "名称颜色")
    CreateColorDropdown(VisGroup, "名称可见颜色", Config.ESP.NameVisibleColor, function(v) Config.ESP.NameVisibleColor = v end, "可见时")
    CreateColorDropdown(VisGroup, "名称不可见颜色", Config.ESP.NameNotVisibleColor, function(v) Config.ESP.NameNotVisibleColor = v end, "不可见时")
    VisGroup:AddToggle("ESP.Health", {Text = "生命值条", Default = Config.ESP.Health, Tooltip = "显示血条", Callback = function(v) Config.ESP.Health = v end})
    VisGroup:AddToggle("ESP.HealthBarCustom", {Text = "自定义血量颜色", Default = Config.ESP.HealthBarCustom, Tooltip = "自定义血条颜色", Callback = function(v) Config.ESP.HealthBarCustom = v end})
    CreateColorDropdown(VisGroup, "血量条颜色", Config.ESP.HealthBarColor, function(v) Config.ESP.HealthBarColor = v end, "血条颜色")
    VisGroup:AddToggle("ESP.Skeleton", {Text = "骨骼", Default = Config.ESP.Skeleton, Tooltip = "显示骨骼", Callback = function(v) Config.ESP.Skeleton = v end})
    VisGroup:AddSlider("ESP.SkeletonThickness", {Text = "骨骼粗细", Default = Config.ESP.SkeletonThickness, Min = 1, Max = 5, Callback = function(v) Config.ESP.SkeletonThickness = v end})
    CreateColorDropdown(VisGroup, "骨骼颜色", Config.ESP.SkeletonColor, function(v) Config.ESP.SkeletonColor = v end, "骨骼颜色")
    CreateColorDropdown(VisGroup, "骨骼可见颜色", Config.ESP.SkeletonVisibleColor, function(v) Config.ESP.SkeletonVisibleColor = v end, "可见时")
    CreateColorDropdown(VisGroup, "骨骼不可见颜色", Config.ESP.SkeletonNotVisibleColor, function(v) Config.ESP.SkeletonNotVisibleColor = v end, "不可见时")
    VisGroup:AddToggle("ESP.HeadDot", {Text = "头部圆点", Default = Config.ESP.HeadDot, Tooltip = "显示头部圆点", Callback = function(v) Config.ESP.HeadDot = v end})
    CreateColorDropdown(VisGroup, "圆点颜色", Config.ESP.HeadDotColor, function(v) Config.ESP.HeadDotColor = v end, "圆点颜色")
    VisGroup:AddToggle("ESP.Highlight", {Text = "高亮", Default = Config.ESP.Highlight, Tooltip = "高亮敌人", Callback = function(v) Config.ESP.Highlight = v end})
    CreateColorDropdown(VisGroup, "高亮填充", Config.ESP.HighlightFill, function(v) Config.ESP.HighlightFill = v end, "填充色")
    CreateColorDropdown(VisGroup, "高亮轮廓", Config.ESP.HighlightOutline, function(v) Config.ESP.HighlightOutline = v end, "轮廓色")
    VisGroup:AddToggle("ESP.Distance", {Text = "距离", Default = Config.ESP.Distance, Tooltip = "显示距离", Callback = function(v) Config.ESP.Distance = v end})
    CreateColorDropdown(VisGroup, "距离颜色", Config.ESP.DistanceColor, function(v) Config.ESP.DistanceColor = v end, "距离颜色")
    VisGroup:AddToggle("ESP.CurrentWeapon", {Text = "当前武器", Default = Config.ESP.CurrentWeapon, Tooltip = "显示敌人武器", Callback = function(v) Config.ESP.CurrentWeapon = v end})
    CreateColorDropdown(VisGroup, "武器颜色", Config.ESP.WeaponColor, function(v) Config.ESP.WeaponColor = v end, "武器颜色")

    local WorldVisGroup = Tabs.Visuals:AddRightGroupbox("世界 ESP", "globe")
    WorldVisGroup:AddToggle("WorldESP.DroppedWeapons.Enabled", {Text = "掉落武器", Default = Config.WorldESP.DroppedWeapons.Enabled, Callback = function(v) Config.WorldESP.DroppedWeapons.Enabled = v end})
    WorldVisGroup:AddToggle("WorldESP.DroppedWeapons.Box", {Text = "掉落-方框", Default = Config.WorldESP.DroppedWeapons.Box, Callback = function(v) Config.WorldESP.DroppedWeapons.Box = v end})
    WorldVisGroup:AddToggle("WorldESP.DroppedWeapons.Highlight", {Text = "掉落-高亮", Default = Config.WorldESP.DroppedWeapons.Highlight, Callback = function(v) Config.WorldESP.DroppedWeapons.Highlight = v end})
    WorldVisGroup:AddToggle("WorldESP.DroppedWeapons.Name", {Text = "掉落-名称", Default = Config.WorldESP.DroppedWeapons.Name, Callback = function(v) Config.WorldESP.DroppedWeapons.Name = v end})
    WorldVisGroup:AddToggle("WorldESP.Bomb.Enabled", {Text = "C4炸弹", Default = Config.WorldESP.Bomb.Enabled, Callback = function(v) Config.WorldESP.Bomb.Enabled = v end})
    WorldVisGroup:AddToggle("WorldESP.Bomb.Box", {Text = "炸弹-方框", Callback = function(v) Config.WorldESP.Bomb.Box = v end})
    WorldVisGroup:AddToggle("WorldESP.Bomb.Highlight", {Text = "炸弹-高亮", Callback = function(v) Config.WorldESP.Bomb.Highlight = v end})
    WorldVisGroup:AddToggle("WorldESP.Bomb.Name", {Text = "炸弹-名称", Callback = function(v) Config.WorldESP.Bomb.Name = v end})
    WorldVisGroup:AddToggle("WorldESP.Molotovs.Enabled", {Text = "火焰 ESP", Default = Config.WorldESP.Molotovs.Enabled, Callback = function(v) Config.WorldESP.Molotovs.Enabled = v end})
    WorldVisGroup:AddToggle("WorldESP.Molotovs.Highlight", {Text = "火焰-高亮", Callback = function(v) Config.WorldESP.Molotovs.Highlight = v end})
    WorldVisGroup:AddToggle("WorldESP.Smokes.Enabled", {Text = "烟雾 ESP", Default = Config.WorldESP.Smokes.Enabled, Callback = function(v) Config.WorldESP.Smokes.Enabled = v end})
    WorldVisGroup:AddToggle("WorldESP.Smokes.Highlight", {Text = "烟雾-高亮", Callback = function(v) Config.WorldESP.Smokes.Highlight = v end})

    local CharmGroup = Tabs.Visuals:AddRightGroupbox("Charms", "star")
    CharmGroup:AddToggle("Charms.Enabled", {Text = "启用", Default = Config.Charms.Enabled, Tooltip = "身体附着发光框", Callback = function(v) Config.Charms.Enabled = v end})
    CharmGroup:AddToggle("Charms.TeamCheck", {Text = "团队检查", Callback = function(v) Config.Charms.TeamCheck = v end})
    CreateColorDropdown(CharmGroup, "可见颜色", Config.Charms.VisibleColor, function(v) Config.Charms.VisibleColor = v end, "可见时颜色")
    CreateColorDropdown(CharmGroup, "不可见颜色", Config.Charms.HiddenColor, function(v) Config.Charms.HiddenColor = v end, "不可见时颜色")
    CharmGroup:AddSlider("Charms.Transparency", {Text = "透明度", Default = Config.Charms.Transparency, Min = 0, Max = 1, Rounding = 1, Callback = function(v) Config.Charms.Transparency = v end})
    CharmGroup:AddToggle("Charms.AlwaysOnTop", {Text = "始终置顶", Callback = function(v) Config.Charms.AlwaysOnTop = v end})
end

CreateVisualsUI()

local GrenadeTrajectory = {
    Enabled = false, Mode = "自动", Hotkey = Enum.UserInputType.MouseButton2,
    LineColor = Color3.fromRGB(220, 220, 255), BounceColor = Color3.fromRGB(255, 80, 80),
    EndColor = Color3.fromRGB(255, 60, 60), Transparency = 0.15, LineWidth = 0.06,
}

local MAX_SEGMENTS = 180
local STEP = 0.0078125
local MAX_SIM_TIME = 10
local GRENADE_NAMES = {
    ["HE Grenade"] = { radius = 0.15, fuse = 1.6 },
    ["Flashbang"] = { radius = 0.15, fuse = 1.5 },
    ["Smoke Grenade"] = { radius = 0.15, fuse = 3.0 },
    ["Molotov"] = { radius = 0.15, fuse = 5.0, minFuse = 0.3, floorExplode = true },
    ["Incendiary Grenade"] = { radius = 0.15, fuse = 5.0, minFuse = 0.3, floorExplode = true },
    ["Decoy Grenade"] = { radius = 0.15, fuse = 15.0 },
}

local function getGrenadeNameFallback()
    for _, obj in ipairs(camera:GetChildren()) do
        if obj:IsA("Model") and GRENADE_NAMES[obj.Name] then return obj.Name end
    end
    return nil
end

local _inventoryState = nil
local function getInventoryState()
    if _inventoryState then return _inventoryState end
    local fireMod
    for _, mod in ipairs(getloadedmodules()) do
        if mod:GetFullName():find("Controllers.InputController.Actions.Fire", 1, true) then
            fireMod = mod; break
        end
    end
    if not fireMod then return nil end
    local ok, fireTable = pcall(require, fireMod)
    if not ok or typeof(fireTable) ~= "table" or typeof(fireTable.Callback) ~= "function" then return nil end
    local ok2, invCtrl = pcall(debug.getupvalue, fireTable.Callback, 7)
    if not ok2 or typeof(invCtrl) ~= "table" or not invCtrl.getInventorySlot then return nil end
    local ok3, state = pcall(debug.getupvalue, invCtrl.getInventorySlot, 1)
    if not ok3 or typeof(state) ~= "table" then return nil end
    _inventoryState = state
    return state
end
local function getCurrentEquippedSafe()
    local state = getInventoryState()
    if not state then return nil end
    return state.CurrentEquipped
end
local function getEquippedGrenadeName()
    local eq = getCurrentEquippedSafe()
    if eq then
        local name = eq.weapon or eq.Name or eq.name or eq.identifier
        if name and GRENADE_NAMES[name] then return name end
    end
    return getGrenadeNameFallback()
end

local GRAVITY_VEC = Vector3.new(0, -23.833334, 0)
local STOP_EPS = 0.0076388888888888895
local SLEEP_SQ = 2.3341049382716053

local function clipVelocity(vel, normal, overbounce)
    local d = vel:Dot(normal) * overbounce
    local out = vel - normal * d
    local x = math.abs(out.X) < STOP_EPS and 0 or out.X
    local y = math.abs(out.Y) < STOP_EPS and 0 or out.Y
    local z = math.abs(out.Z) < STOP_EPS and 0 or out.Z
    return Vector3.new(x, y, z)
end

local function integrate(pos, vel, dt, grounded)
    if grounded then return pos + vel * dt, vel end
    local vy = vel.Y - dt * 23.833334
    local avgY = (vel.Y + vy) / 2
    local dp = Vector3.new(vel.X * dt, avgY * dt, vel.Z * dt)
    return pos + dp, Vector3.new(vel.X, vy, vel.Z)
end

local function detectCollision(from, to, radius, params)
    local dir = to - from
    local mag = dir.Magnitude
    if mag < 0.001 then return nil end
    local pad = radius * 0.01
    local offsets = { Vector3.new(pad,0,0), Vector3.new(-pad,0,0), Vector3.new(0,pad,0), Vector3.new(0,-pad,0), Vector3.new(0,0,pad), Vector3.new(0,0,-pad) }
    local bestDist = math.huge
    local bestResult = nil
    local bestOffset = Vector3.zero
    local r = workspace:Raycast(from, dir, params)
    if r and r.Distance < bestDist then bestDist = r.Distance; bestResult = r; bestOffset = Vector3.zero end
    for _, off in ipairs(offsets) do
        local r2 = workspace:Raycast(from + off, dir, params)
        if r2 and r2.Distance < bestDist then bestDist = r2.Distance; bestResult = r2; bestOffset = off end
    end
    if not bestResult then return nil end
    local hitPos = bestResult.Position - bestOffset
    local dist = (hitPos - from).Magnitude
    if mag + pad + 0.1 < dist then return nil end
    local parent = bestResult.Instance.Parent
    local isPlayer = parent and parent:FindFirstChildOfClass("Humanoid") ~= nil
    return { position = hitPos, normal = bestResult.Normal, distance = dist, isPlayer = isPlayer }
end

local function checkGrounded(pos, params)
    local r = workspace:Raycast(pos, Vector3.new(0, -0.2, 0), params)
    if r then return true, r.Normal end
    return false, nil
end

local function calcBounce(vel, normal, state, isPlayer, isJumpThrow)
    local elast = (isJumpThrow and 0.32 or 0.4) * (isPlayer and 0.3 or 1)
    elast = math.clamp(elast, 0, 0.9)
    local bounced = clipVelocity(vel, normal, 2) * elast
    local newState = table.clone(state)
    newState.bounceCount = state.bounceCount + 1
    newState.hasTouched = true
    if normal.Y > 0.7 and bounced:Dot(bounced) < SLEEP_SQ then return Vector3.zero, newState end
    return bounced, newState
end

local function simStep(state, config, params, dt)
    local s = table.clone(state)
    s.simulationTime = state.simulationTime + dt
    if s.simulationTime >= MAX_SIM_TIME then s.isAtRest = true; return s, "timeout" end
    if config.fuse and s.simulationTime >= config.fuse then s.isAtRest = true; return s, "fuse" end
    if state.bounceCount >= 20 then s.isAtRest = true; s.velocity = Vector3.zero; return s, "rest" end
    local oldPos = s.position
    local newPos, newVel = integrate(s.position, s.velocity, dt, s.isGrounded)
    local col = detectCollision(oldPos, newPos, config.radius, params)
    if col then
        local bVel; bVel, s = calcBounce(newVel, col.normal, s, col.isPlayer, s.isJumpThrow)
        s.position = col.position + col.normal * 0.05
        s.velocity = bVel
        if config.floorExplode and col.normal.Y > 0.7 then
            if not config.minFuse or s.simulationTime >= config.minFuse then s.isAtRest = true; return s, "floor_impact" end
        end
        return s, "bounce"
    end
    s.position = newPos; s.velocity = newVel
    local grounded = checkGrounded(s.position, params)
    s.isGrounded = grounded
    if grounded and s.hasTouched and s.velocity:Dot(s.velocity) < SLEEP_SQ then
        if not config.fuse then s.isAtRest = true; s.velocity = Vector3.zero; return s, "rest" end
    end
    return s, nil
end

local function calcThrowParams(rootPos, lookVec, throwType, pitchScale)
    local isNear = (throwType == "Near")
    local upBias = (isNear and 0.04 or 0.06) * math.clamp(pitchScale or 1, 0.8, 1.2)
    local fwdOff = isNear and (1.35 * 0.55) or 1.35
    local hOff = isNear and (2.4 * 0.8) or (2.4 + 0.1)
    if isNear then upBias = upBias + 0.08 end
    local dir = (lookVec + Vector3.new(0, upBias, 0)).Unit
    local flat = Vector3.new(lookVec.X, 0, lookVec.Z)
    if flat.Magnitude < 0.01 then flat = Vector3.new(0, 0, -1) end
    flat = flat.Unit
    local origin = rootPos + flat * fwdOff + Vector3.new(0, hOff, 0)
    return origin, dir
end

local function createInitialState(origin, dir, throwType, playerVel, rangeScale, timestamp)
    local throwPower = ((throwType == "Far" and 1 or 0) * 0.7 + 0.3) * 57.29166 * (rangeScale or 1) * 0.58
    local isJump = playerVel.Y > 5
    local dampening = 1
    local vertAdd = isJump and Vector3.new(0,20,0) or Vector3.new(0, playerVel.Y*2*0.58, 0)
    local throwDir = isJump and Vector3.new(dir.X*dampening, dir.Y, dir.Z*dampening).Unit or dir
    local baseVel = throwDir * throwPower + vertAdd
    local scaledDir = Vector3.new(dir.X*(isJump and dampening or 1), dir.Y, dir.Z*(isJump and dampening or 1)).Unit
    local upVel = scaledDir * throwPower * 0.15 + Vector3.new(0, (rangeScale or 1)*6.5*0.58, 0)
    local combined = baseVel + upVel
    local cap = isJump and ((dir.Y-0.4)*20+62) or 50
    if combined.Magnitude > cap then combined = combined.Unit * cap end
    local pvelScale = isJump and dampening or 1
    combined = combined + Vector3.new(playerVel.X,0,playerVel.Z)*1.5*pvelScale
    return { position = origin, velocity = combined, simulationTime = 0, bounceCount = 0, isGrounded = false, isAtRest = false, hasTouched = false, accumulatedTime = 0, isJumpThrow = isJump }
end

local function simulateTrajectory(origin, dir, throwType, playerVel, config, params)
    local state = createInitialState(origin, dir, throwType, playerVel, 1, tick())
    local points = { state.position }
    local bounceIndices = {}
    local endReason = nil
    local iterations = 0
    while not state.isAtRest and iterations < MAX_SEGMENTS do
        iterations += 1
        local reason; state, reason = simStep(state, config, params, STEP)
        table.insert(points, state.position)
        if reason == "bounce" then table.insert(bounceIndices, #points) end
        if reason == "fuse" or reason == "floor_impact" or reason == "rest" or reason == "timeout" then endReason = reason; break end
    end
    return points, bounceIndices, endReason
end

local holder = Instance.new("Part")
holder.Name = "dvfx"
holder.Size = Vector3.new(0.05, 0.05, 0.05)
holder.Transparency = 1
holder.Anchored = true
holder.CanCollide = false
holder.CanQuery = false
holder.CanTouch = false
holder.CastShadow = false
holder.CFrame = CFrame.identity
holder.Parent = camera

local attachPool = {}
local beamPool = {}
for i = 1, MAX_SEGMENTS do
    local a = Instance.new("Attachment"); a.Parent = holder; attachPool[i] = a
    if i > 1 then
        local b = Instance.new("Beam")
        b.Attachment0 = attachPool[i-1]; b.Attachment1 = attachPool[i]
        b.Width0 = GrenadeTrajectory.LineWidth; b.Width1 = GrenadeTrajectory.LineWidth
        b.FaceCamera = true; b.LightEmission = 1; b.LightInfluence = 0; b.Segments = 1
        b.TextureMode = Enum.TextureMode.Stretch
        b.Color = ColorSequence.new(GrenadeTrajectory.LineColor)
        b.Transparency = NumberSequence.new(GrenadeTrajectory.Transparency)
        b.Enabled = false; b.Parent = holder
        beamPool[i-1] = b
    end
end

local endSphere = Instance.new("Part")
endSphere.Name = "ep"
endSphere.Shape = Enum.PartType.Ball
endSphere.Size = Vector3.new(0.6, 0.6, 0.6)
endSphere.Material = Enum.Material.Neon
endSphere.Color = GrenadeTrajectory.EndColor
endSphere.Anchored = true
endSphere.CanCollide = false
endSphere.CanQuery = false
endSphere.CanTouch = false
endSphere.CastShadow = false
endSphere.Transparency = 1
endSphere.Parent = camera

local function showTrajectory(points, bounceIndices)
    local bounceSet = {}; for _, idx in ipairs(bounceIndices) do bounceSet[idx] = true end
    local count = math.min(#points, MAX_SEGMENTS)
    for i = 1, count do attachPool[i].WorldPosition = points[i] end
    for i = 1, count - 1 do
        local beam = beamPool[i]; beam.Enabled = true
        beam.Width0 = GrenadeTrajectory.LineWidth; beam.Width1 = GrenadeTrajectory.LineWidth
        if bounceSet[i+1] then beam.Color = ColorSequence.new(GrenadeTrajectory.BounceColor)
        else beam.Color = ColorSequence.new(GrenadeTrajectory.LineColor) end
        beam.Transparency = NumberSequence.new(GrenadeTrajectory.Transparency)
    end
    for i = count, MAX_SEGMENTS - 1 do if beamPool[i] then beamPool[i].Enabled = false end end
    local endPos = points[count]
    endSphere.CFrame = CFrame.new(endPos)
    endSphere.Color = GrenadeTrajectory.EndColor
    endSphere.Transparency = GrenadeTrajectory.Transparency + 0.15
end

local function hideTrajectory()
    for i = 1, MAX_SEGMENTS - 1 do if beamPool[i] then beamPool[i].Enabled = false end end
    endSphere.Transparency = 1
end

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function grenadeRenderStep()
    if not GrenadeTrajectory.Enabled then hideTrajectory(); return end
    local char = player.Character
    if not char then hideTrajectory(); return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then hideTrajectory(); return end
    local grenadeName = getEquippedGrenadeName()
    if not grenadeName then hideTrajectory(); return end

    local shouldShow = false
    if GrenadeTrajectory.Mode == "自动" then
        shouldShow = true
    elseif GrenadeTrajectory.Mode == "热键" then
        local key = GrenadeTrajectory.Hotkey
        if typeof(key) == "EnumItem" then
            if key.EnumType == Enum.UserInputType then
                shouldShow = UserInputService:IsMouseButtonPressed(key)
            elseif key.EnumType == Enum.KeyCode then
                shouldShow = UserInputService:IsKeyDown(key)
            end
        end
    end

    if not shouldShow then hideTrajectory(); return end

    local config = GRENADE_NAMES[grenadeName]
    local throwType = (GrenadeTrajectory.Mode == "热键" and GrenadeTrajectory.Hotkey == Enum.UserInputType.MouseButton2) and "Near" or "Far"
    local lookVec = camera.CFrame.LookVector
    local origin, dir = calcThrowParams(root.Position, lookVec, throwType, 1)
    local playerVel = root.AssemblyLinearVelocity or Vector3.zero
    rayParams.FilterDescendantsInstances = { char }
    local points, bounces = simulateTrajectory(origin, dir, throwType, playerVel, config, rayParams)
    if #points > 1 then showTrajectory(points, bounces) else hideTrajectory() end
end

RunService:BindToRenderStep("GrenadePredict", Enum.RenderPriority.Camera.Value + 1, grenadeRenderStep)

local TrajectoryGroup = Tabs.Visuals:AddRightGroupbox("投掷物轨迹", "target")
TrajectoryGroup:AddToggle("GrenadeTrajectoryToggle", { Text = "启用投掷物轨迹", Default = false, Callback = function(v) GrenadeTrajectory.Enabled = v; if not v then hideTrajectory() end end })
TrajectoryGroup:AddDropdown("GrenadeTrajectoryMode", { Text = "显示模式", Values = {"自动", "热键"}, Default = "自动", Callback = function(v) GrenadeTrajectory.Mode = v end })
TrajectoryGroup:AddDropdown("GrenadeTrajectoryHotkey", { Text = "热键", Values = hotkeyValues, Default = "鼠标右键", Callback = function(v) GrenadeTrajectory.Hotkey = hotkeyMap[v] or Enum.UserInputType.MouseButton2 end })
CreateColorDropdown(TrajectoryGroup, "轨迹线条颜色", GrenadeTrajectory.LineColor, function(v) GrenadeTrajectory.LineColor = v end, "线条颜色")
CreateColorDropdown(TrajectoryGroup, "弹跳点颜色", GrenadeTrajectory.BounceColor, function(v) GrenadeTrajectory.BounceColor = v end, "弹跳点颜色")
CreateColorDropdown(TrajectoryGroup, "终点颜色", GrenadeTrajectory.EndColor, function(v) GrenadeTrajectory.EndColor = v; endSphere.Color = v end, "终点颜色")
TrajectoryGroup:AddSlider("TrajectoryTransparency", { Text = "线条透明度", Default = 0.15, Min = 0, Max = 1, Rounding = 2, Callback = function(v) GrenadeTrajectory.Transparency = v end })
TrajectoryGroup:AddSlider("TrajectoryWidth", { Text = "线条粗细", Default = 0.06, Min = 0.02, Max = 0.3, Rounding = 2, Callback = function(v) GrenadeTrajectory.LineWidth = v end })

RunService.RenderStepped:Connect(function()
    local now = tick()
    local localChar = player.Character
    if not localChar or not localChar.PrimaryPart then
        for p,e in pairs(playerESP) do destroyPlayerESP(e); playerESP[p]=nil end
        return
    end
    local localHuman = localChar:FindFirstChildWhichIsA("Humanoid")
    if not localHuman or localHuman.Health <= 0 then return end
    camera = workspace.CurrentCamera
    if not camera then return end

    if SpeedHack.Enabled and localChar then
        local root = localChar:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = root.AssemblyLinearVelocity
            local horizontalVel = Vector3.new(vel.X, 0, vel.Z)
            if horizontalVel.Magnitude > 0.1 then
                local direction = horizontalVel.Unit
                root.AssemblyLinearVelocity = Vector3.new(direction.X * (16 + SpeedHack.Value * 50), vel.Y, direction.Z * (16 + SpeedHack.Value * 50))
            end
        end
    end

    for p,e in pairs(playerESP) do
        if not p.Parent then destroyPlayerESP(e); playerESP[p]=nil
        else
            local char = p.Character
            if not char or not char.Parent then destroyPlayerESP(e); playerESP[p]=nil
            else
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if not hum or hum.Health <= 0 then destroyPlayerESP(e); playerESP[p]=nil end
            end
        end
    end

    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildWhichIsA("Humanoid") and char:FindFirstChildWhichIsA("Humanoid").Health > 0 then
                if not playerESP[p] then playerESP[p] = createPlayerESP() end
            end
        end
    end

    if Config.ESP.Enabled and now - lastESPUpdate > 0.015 then
        lastESPUpdate = now
        local wtvp = camera.WorldToViewportPoint
        local camPos = camera.CFrame.Position
        local fillT = (math.sin(now * Config.ESP.BoxFillFadeSpeed) + 1) / 2
        local fillCol = Config.ESP.BoxFillColor1:Lerp(Config.ESP.BoxFillColor2, fillT)

        for p,e in pairs(playerESP) do
            local char = p.Character
            if not char or not char.Parent then destroyPlayerESP(e); playerESP[p]=nil; continue end
            local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if not root or not hum or hum.Health <= 0 then destroyPlayerESP(e); playerESP[p]=nil; continue end
            if Config.ESP.TeamCheck and not isEnemy(p) then hidePlayerESP(e); continue end
            local dist = (camPos - root.Position).Magnitude
            if dist > Config.ESP.MaxDistance then hidePlayerESP(e); continue end

            local rootScreen, onScreen = wtvp(camera, root.Position)
            if not onScreen or rootScreen.Z <= 0 then hidePlayerESP(e); continue end

            local headPart = char:FindFirstChild("Head")
            local isVis = e.IsVisible
            if Config.ESP.VisibilityCheck and (now - e.LastVisCheck > 0.1) then
                isVis = espIsVisible(localChar, char)
                e.IsVisible = isVis
                e.LastVisCheck = now
            elseif not Config.ESP.VisibilityCheck then
                isVis = true; e.IsVisible = true
            end

            local rPos = root.Position
            local hPos = headPart and headPart.Position or (rPos + Vector3.new(0,2,0))
            local topScreen = wtvp(camera, hPos + Vector3.new(0,0.5,0))
            local botScreen = wtvp(camera, rPos - Vector3.new(0,3,0))
            if topScreen.Z <= 0 or botScreen.Z <= 0 then hidePlayerESP(e); continue end

            local topY, botY = topScreen.Y, botScreen.Y
            local sH = math.abs(botY - topY)
            local sW = sH * 0.55
            local cx = rootScreen.X
            local tl = Vector2.new(cx - sW/2, topY); local tr = Vector2.new(cx + sW/2, topY)
            local bl = Vector2.new(cx - sW/2, botY); local br = Vector2.new(cx + sW/2, botY)

            if Config.ESP.Box then
                local col = Config.ESP.VisibilityCheck and (isVis and Config.ESP.BoxVisibleColor or Config.ESP.BoxNotVisibleColor) or Config.ESP.BoxColor
                for i=1,4 do if e.Box[i] then e.Box[i].Thickness = Config.ESP.BoxThickness end end
                if e.Box[1] then e.Box[1].From, e.Box[1].To, e.Box[1].Color, e.Box[1].Visible = tl, tr, col, true end
                if e.Box[2] then e.Box[2].From, e.Box[2].To, e.Box[2].Color, e.Box[2].Visible = tr, br, col, true end
                if e.Box[3] then e.Box[3].From, e.Box[3].To, e.Box[3].Color, e.Box[3].Visible = br, bl, col, true end
                if e.Box[4] then e.Box[4].From, e.Box[4].To, e.Box[4].Color, e.Box[4].Visible = bl, tl, col, true end
                if Config.ESP.BoxOutline then
                    for i=1,4 do if e.BoxOutline[i] and e.Box[i] then e.BoxOutline[i].From, e.BoxOutline[i].To = e.Box[i].From, e.Box[i].To; e.BoxOutline[i].Thickness = Config.ESP.BoxThickness+2; e.BoxOutline[i].Color, e.BoxOutline[i].Visible = Color3.new(0,0,0), true end end
                else
                    for i=1,4 do if e.BoxOutline[i] then e.BoxOutline[i].Visible = false end end
                end
            else
                for i=1,4 do if e.Box[i] then e.Box[i].Visible = false end if e.BoxOutline[i] then e.BoxOutline[i].Visible = false end end
            end

            if Config.ESP.BoxFill then
                if e.Fill[1] and type(e.Fill[1])~="number" then e.Fill[1].PointA, e.Fill[1].PointB, e.Fill[1].PointC = tl, tr, bl; e.Fill[1].Color, e.Fill[1].Transparency = fillCol, 1-Config.ESP.BoxFillTransparency; e.Fill[1].Filled, e.Fill[1].Visible = true, true end
                if e.Fill[2] and type(e.Fill[2])~="number" then e.Fill[2].PointA, e.Fill[2].PointB, e.Fill[2].PointC = tr, br, bl; e.Fill[2].Color, e.Fill[2].Transparency = fillCol, 1-Config.ESP.BoxFillTransparency; e.Fill[2].Filled, e.Fill[2].Visible = true, true end
            else
                for i=1,2 do if e.Fill[i] and type(e.Fill[i])~="number" then e.Fill[i].Visible = false end end
            end
            
            local tY = tl.Y - 18
            if Config.ESP.Name and e.Name then
                e.Name.Size = Config.ESP.NameSize
                e.Name.Text = p.Name
                e.Name.Position = Vector2.new(cx, tY)
                e.Name.Color = Config.ESP.VisibilityCheck and (isVis and Config.ESP.NameVisibleColor or Config.ESP.NameNotVisibleColor) or Config.ESP.NameColor
                e.Name.Visible = true
                tY = tY + Config.ESP.NameSize
            elseif e.Name then e.Name.Visible = false end

            if Config.ESP.Distance and e.Dist then
                e.Dist.Text = math.floor(dist) .. "m"
                e.Dist.Position = Vector2.new(cx, bl.Y + 2)
                e.Dist.Color = Config.ESP.DistanceColor
                e.Dist.Visible = true
            elseif e.Dist then e.Dist.Visible = false end

            if Config.ESP.Health and hum then
                local hp, mhp = hum.Health, hum.MaxHealth
                if mhp <= 0 then mhp = 100 end
                local hpF = math.clamp(hp/mhp, 0, 1)
                local bx = tl.X - 5
                local barH = sH * hpF
                if e.HpBg then e.HpBg.From, e.HpBg.To = Vector2.new(bx, bl.Y), Vector2.new(bx, tl.Y); e.HpBg.Visible = true end
                if e.Hp then e.Hp.From, e.Hp.To = Vector2.new(bx, bl.Y), Vector2.new(bx, bl.Y - barH); e.Hp.Color = Config.ESP.HealthBarCustom and Config.ESP.HealthBarColor or Color3.fromRGB(255,0,0):Lerp(Color3.fromRGB(0,255,0), hpF); e.Hp.Visible = true end
            else
                if e.HpBg then e.HpBg.Visible = false end
                if e.Hp then e.Hp.Visible = false end
            end

            if Config.ESP.Skeleton and hum and dist < 300 then
                local skelCol = Config.ESP.VisibilityCheck and (isVis and Config.ESP.SkeletonVisibleColor or Config.ESP.SkeletonNotVisibleColor) or Config.ESP.SkeletonColor
                local isR15 = char:FindFirstChild("UpperTorso") ~= nil
                local bones = isR15 and BONES_R15 or BONES_R6
                local boneCache = {}
                for i, pair in ipairs(bones) do
                    local ln = e.Skeleton[i]
                    if not ln then continue end
                    local p1, p2 = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
                    if p1 and p2 then
                        local s1 = boneCache[pair[1]]
                        if not s1 then local p = wtvp(camera, p1.Position); if p.Z > 0 then s1 = Vector2.new(p.X, p.Y) end; boneCache[pair[1]] = s1 end
                        local s2 = boneCache[pair[2]]
                        if not s2 then local p = wtvp(camera, p2.Position); if p.Z > 0 then s2 = Vector2.new(p.X, p.Y) end; boneCache[pair[2]] = s2 end
                        if s1 and s2 then
                            ln.Color, ln.From, ln.To, ln.Thickness, ln.Visible = skelCol, s1, s2, Config.ESP.SkeletonThickness, true
                        else ln.Visible = false end
                    else ln.Visible = false end
                end
                for i = #bones+1, #e.Skeleton do if e.Skeleton[i] then e.Skeleton[i].Visible = false end end
            else
                for _, ln in ipairs(e.Skeleton) do if ln then ln.Visible = false end end
            end

            if Config.ESP.Highlight and e.HL then
                pcall(function()
                    e.HL.Adornee = char
                    e.HL.FillColor = Config.ESP.VisibilityCheck and (isVis and Config.ESP.HighlightVisibleFill or Config.ESP.HighlightHiddenFill) or Config.ESP.HighlightFill
                    e.HL.OutlineColor = Config.ESP.HighlightOutline
                    e.HL.Enabled = true
                end)
            elseif e.HL then e.HL.Enabled = false end

            if Config.ESP.CurrentWeapon and e.WeaponName then
                local attr = p:GetAttribute("CurrentEquipped")
                if attr and type(attr) == "string" then
                    local s, decoded = pcall(HttpService.JSONDecode, HttpService, attr)
                    if s and decoded and decoded.Name then
                        e.WeaponName.Text = decoded.Name
                        e.WeaponName.Color = Config.ESP.WeaponColor
                        e.WeaponName.Position = Vector2.new(tr.X + 5, (tl.Y + bl.Y)/2)
                        e.WeaponName.Visible = true
                    else e.WeaponName.Visible = false end
                else e.WeaponName.Visible = false end
            elseif e.WeaponName then e.WeaponName.Visible = false end

            if Config.ESP.HeadDot and e.HeadDot then
                local hp = wtvp(camera, hPos)
                if hp.Z > 0 then
                    e.HeadDot.Position = Vector2.new(hp.X, hp.Y)
                    e.HeadDot.Radius = math.max(sW/10, 3)
                    e.HeadDot.Color = Config.ESP.VisibilityCheck and (isVis and Config.ESP.HeadDotVisibleColor or Config.ESP.HeadDotNotVisibleColor) or Config.ESP.HeadDotColor
                    e.HeadDot.Visible = true
                else e.HeadDot.Visible = false end
            elseif e.HeadDot then e.HeadDot.Visible = false end
        end
    end

    if now - lastWorldScan > 0.2 then
        lastWorldScan = now
        local debris = Workspace:FindFirstChild("Debris")
        if debris then
            local curDW, curMol, curSmk = {}, {}, {}
            local bombFound = false
            for _, item in ipairs(debris:GetChildren()) do
                if Config.WorldESP.DroppedWeapons.Enabled and item:IsA("Model") and item:GetAttribute("Weapon") and item:GetAttribute("CanPickup") == true then
                    curDW[item] = true
                    if not worldESP.DroppedWeapons[item] then
                        worldESP.DroppedWeapons[item] = createWorldESPObj(true, false)
                        worldESP.DroppedWeapons[item].Model = item
                    end
                end
                if Config.WorldESP.Bomb.Enabled and item:IsA("Model") and item.Name == "Character" and item:GetAttribute("BombPlanted") then
                    bombFound = true
                    if not worldESP.Bomb or worldESP.Bomb.Model ~= item then
                        if worldESP.Bomb then destroyWorldESPObj(worldESP.Bomb) end
                        worldESP.Bomb = createWorldESPObj(true, false)
                        worldESP.Bomb.Model = item
                    end
                end
                if Config.WorldESP.Molotovs.Enabled and item:IsA("Folder") and item.Name:match("^VoxelFire") then
                    curMol[item] = true
                    if not worldESP.Molotovs[item] then
                        worldESP.Molotovs[item] = createWorldESPObj(true, true)
                        worldESP.Molotovs[item].Model = item
                    end
                end
                if Config.WorldESP.Smokes.Enabled and item:IsA("Folder") and item.Name:match("^VoxelSmoke") then
                    curSmk[item] = true
                    if not worldESP.Smokes[item] then
                        worldESP.Smokes[item] = createWorldESPObj(true, true)
                        worldESP.Smokes[item].Model = item
                    end
                end
            end
            for item, eo in pairs(worldESP.DroppedWeapons) do if not curDW[item] then destroyWorldESPObj(eo); worldESP.DroppedWeapons[item] = nil end end
            for item, eo in pairs(worldESP.Molotovs) do if not curMol[item] then destroyWorldESPObj(eo); worldESP.Molotovs[item] = nil end end
            for item, eo in pairs(worldESP.Smokes) do if not curSmk[item] then destroyWorldESPObj(eo); worldESP.Smokes[item] = nil end end
            if not bombFound and worldESP.Bomb then destroyWorldESPObj(worldESP.Bomb); worldESP.Bomb = nil end
        end
    end

    if camera then
        local wtvp = camera.WorldToViewportPoint
        for item, eo in pairs(worldESP.DroppedWeapons) do
            if not item.PrimaryPart then hideWorldESPObj(eo); continue end
            local pos, on = wtvp(camera, item.PrimaryPart.Position)
            if on and pos.Z > 0 then
                if Config.WorldESP.DroppedWeapons.Box then
                    local tl2 = Vector2.new(pos.X-15, pos.Y-10); local tr2 = Vector2.new(pos.X+15, pos.Y-10); local bl2 = Vector2.new(pos.X-15, pos.Y+10); local br2 = Vector2.new(pos.X+15, pos.Y+10)
                    if eo.Box[1] then eo.Box[1].From, eo.Box[1].To, eo.Box[1].Color = tl2, tr2, Config.WorldESP.DroppedWeapons.Color end
                    if eo.Box[2] then eo.Box[2].From, eo.Box[2].To, eo.Box[2].Color = tr2, br2, Config.WorldESP.DroppedWeapons.Color end
                    if eo.Box[3] then eo.Box[3].From, eo.Box[3].To, eo.Box[3].Color = br2, bl2, Config.WorldESP.DroppedWeapons.Color end
                    if eo.Box[4] then eo.Box[4].From, eo.Box[4].To, eo.Box[4].Color = bl2, tl2, Config.WorldESP.DroppedWeapons.Color end
                    for i=1,4 do eo.Box[i].Visible = true end
                else for i=1,4 do eo.Box[i].Visible = false end end
                if eo.Name and Config.WorldESP.DroppedWeapons.Name then eo.Name.Text = item:GetAttribute("Weapon") or "武器"; eo.Name.Position = Vector2.new(pos.X, pos.Y-25); eo.Name.Color = Config.WorldESP.DroppedWeapons.Color; eo.Name.Visible = true elseif eo.Name then eo.Name.Visible = false end
                if eo.HL then eo.HL.Adornee = item; eo.HL.FillColor = Config.WorldESP.DroppedWeapons.Color; eo.HL.OutlineColor = Color3.new(1,1,1); eo.HL.Enabled = Config.WorldESP.DroppedWeapons.Highlight end
            else hideWorldESPObj(eo) end
        end
        if worldESP.Bomb and worldESP.Bomb.Model and worldESP.Bomb.Model.PrimaryPart then
            local item = worldESP.Bomb.Model
            local cf, sz = item:GetBoundingBox()
            local pos, on = wtvp(camera, cf.Position)
            if on and pos.Z > 0 then
                local topS = wtvp(camera, cf.Position + Vector3.new(0, sz.Y/2, 0))
                local botS = wtvp(camera, cf.Position - Vector3.new(0, sz.Y/2, 0))
                local sH = math.clamp(math.abs(topS.Y - botS.Y), 10, 80)
                local sW = math.clamp(sH * 0.8, 10, 60)
                local cx2 = pos.X; local cy2 = (topS.Y + botS.Y)/2
                local tl3 = Vector2.new(cx2 - sW/2, cy2 - sH/2); local tr3 = Vector2.new(cx2 + sW/2, cy2 - sH/2)
                local bl3 = Vector2.new(cx2 - sW/2, cy2 + sH/2); local br3 = Vector2.new(cx2 + sW/2, cy2 + sH/2)
                if Config.WorldESP.Bomb.Box then
                    if worldESP.Bomb.Box[1] then worldESP.Bomb.Box[1].From, worldESP.Bomb.Box[1].To, worldESP.Bomb.Box[1].Color = tl3, tr3, Config.WorldESP.Bomb.Color end
                    if worldESP.Bomb.Box[2] then worldESP.Bomb.Box[2].From, worldESP.Bomb.Box[2].To, worldESP.Bomb.Box[2].Color = tr3, br3, Config.WorldESP.Bomb.Color end
                    if worldESP.Bomb.Box[3] then worldESP.Bomb.Box[3].From, worldESP.Bomb.Box[3].To, worldESP.Bomb.Box[3].Color = br3, bl3, Config.WorldESP.Bomb.Color end
                    if worldESP.Bomb.Box[4] then worldESP.Bomb.Box[4].From, worldESP.Bomb.Box[4].To, worldESP.Bomb.Box[4].Color = bl3, tl3, Config.WorldESP.Bomb.Color end
                    for i=1,4 do worldESP.Bomb.Box[i].Visible = true end
                else for i=1,4 do worldESP.Bomb.Box[i].Visible = false end end
                if worldESP.Bomb.Name and Config.WorldESP.Bomb.Name then worldESP.Bomb.Name.Text = "C4"; worldESP.Bomb.Name.Position = Vector2.new(cx2, topS.Y-15); worldESP.Bomb.Name.Color = Config.WorldESP.Bomb.Color; worldESP.Bomb.Name.Visible = true elseif worldESP.Bomb.Name then worldESP.Bomb.Name.Visible = false end
                if worldESP.Bomb.HL then worldESP.Bomb.HL.Adornee = item; worldESP.Bomb.HL.FillColor = Config.WorldESP.Bomb.Color; worldESP.Bomb.HL.OutlineColor = Color3.new(1,1,1); worldESP.Bomb.HL.Enabled = Config.WorldESP.Bomb.Highlight end
            else hideWorldESPObj(worldESP.Bomb) end
        end
        for item, eo in pairs(worldESP.Molotovs) do
            if not item.Parent then hideWorldESPObj(eo); continue end
            local center = getFolderCenter(item); local radius = getFolderRadius(item)
            if center and radius > 0 then
                local pos, on = wtvp(camera, center)
                if on and pos.Z > 0 then
                    local edgePos = wtvp(camera, center + camera.CFrame.RightVector * radius)
                    local screenRadius = math.clamp((Vector2.new(edgePos.X, edgePos.Y) - Vector2.new(pos.X, pos.Y)).Magnitude, 5, 200)
                    if eo.Radius then eo.Radius.Position = Vector2.new(pos.X, pos.Y); eo.Radius.Radius = screenRadius; eo.Radius.Color = Config.WorldESP.Molotovs.Color; eo.Radius.Visible = true end
                    if eo.Name then eo.Name.Text = "火焰"; eo.Name.Position = Vector2.new(pos.X, pos.Y-15); eo.Name.Color = Config.WorldESP.Molotovs.Color; eo.Name.Visible = true end
                else if eo.Radius then eo.Radius.Visible = false end if eo.Name then eo.Name.Visible = false end end
            end
            if eo.HL then
                local fc; for _, c in ipairs(item:GetChildren()) do if c:IsA("BasePart") then fc = c; break end end
                if fc then eo.HL.Adornee = fc; eo.HL.FillColor = Config.WorldESP.Molotovs.Color; eo.HL.OutlineColor = Color3.new(1,1,1); eo.HL.Enabled = Config.WorldESP.Molotovs.Highlight else eo.HL.Enabled = false end
            end
        end
        for item, eo in pairs(worldESP.Smokes) do
            if not item.Parent then hideWorldESPObj(eo); continue end
            local center = getFolderCenter(item); local radius = getFolderRadius(item)
            if center and radius > 0 then
                local pos, on = wtvp(camera, center)
                if on and pos.Z > 0 then
                    local edgePos = wtvp(camera, center + camera.CFrame.RightVector * radius)
                    local screenRadius = math.clamp((Vector2.new(edgePos.X, edgePos.Y) - Vector2.new(pos.X, pos.Y)).Magnitude, 5, 200)
                    if eo.Radius then eo.Radius.Position = Vector2.new(pos.X, pos.Y); eo.Radius.Radius = screenRadius; eo.Radius.Color = Config.WorldESP.Smokes.Color; eo.Radius.Visible = true end
                    if eo.Name then eo.Name.Text = "烟雾"; eo.Name.Position = Vector2.new(pos.X, pos.Y-15); eo.Name.Color = Config.WorldESP.Smokes.Color; eo.Name.Visible = true end
                else if eo.Radius then eo.Radius.Visible = false end if eo.Name then eo.Name.Visible = false end end
            end
            if eo.HL then
                local fc; for _, c in ipairs(item:GetChildren()) do if c:IsA("BasePart") then fc = c; break end end
                if fc then eo.HL.Adornee = fc; eo.HL.FillColor = Config.WorldESP.Smokes.Color; eo.HL.OutlineColor = Color3.new(1,1,1); eo.HL.Enabled = Config.WorldESP.Smokes.Highlight else eo.HL.Enabled = false end
            end
        end
    end
    
    if Config.Charms.Enabled then
        if not charmFolder then charmFolder = Instance.new("Folder", CoreGui); charmFolder.Name = "Charms_Container" end
        if now - lastCharmUpdate > 0.3 then
            lastCharmUpdate = now
            local scanNeeded = (now - (charmVisCache._lastScan or 0)) > 1
            if scanNeeded then charmVisCache._lastScan = now end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player then
                    local char = plr.Character
                    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
                    if char and char:FindFirstChild("HumanoidRootPart") and hum and hum.Health > 0 then
                        if Config.Charms.TeamCheck and not isEnemy(plr) then
                            if charmCache[plr] then for _, box in pairs(charmCache[plr]) do box:Destroy() end; charmCache[plr] = nil; charmVisCache[plr] = nil end
                            continue
                        end
                        if not charmCache[plr] then charmCache[plr] = {} end
                        local head = char:FindFirstChild("Head") or char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
                        local isVis = charmVisCache[plr]
                        if not isVis or scanNeeded then isVis = head and espIsVisible(localChar, char); charmVisCache[plr] = isVis end
                        local col = isVis and Config.Charms.VisibleColor or Config.Charms.HiddenColor
                        for part, box in pairs(charmCache[plr]) do
                            if not (part and part.Parent and part:IsDescendantOf(char) and box and box.Parent) then pcall(function() box:Destroy() end); charmCache[plr][part] = nil end
                        end
                        for part, box in pairs(charmCache[plr]) do
                            if box:IsA("BoxHandleAdornment") then box.Size = part.Size + Vector3.new(0.05,0.05,0.05); box.Adornee = part; box.Color3 = col; box.Transparency = Config.Charms.Transparency; box.AlwaysOnTop = Config.Charms.AlwaysOnTop; box.Visible = true end
                        end
                        if scanNeeded then
                            local validNames = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
                            for _, part in ipairs(char:GetDescendants()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Transparency < 1 and not charmCache[plr][part] then
                                    local valid = false; for _, vn in ipairs(validNames) do if part.Name == vn then valid = true; break end end
                                    if valid then
                                        local box = Instance.new("BoxHandleAdornment"); box.Name = "Charm_"..part.Name; box.Adornee = part; box.Size = part.Size + Vector3.new(0.05,0.05,0.05); box.Color3 = col; box.Transparency = Config.Charms.Transparency; box.AlwaysOnTop = Config.Charms.AlwaysOnTop; box.ZIndex = 5; box.Parent = charmFolder; charmCache[plr][part] = box
                                    end
                                end
                            end
                        end
                    elseif charmCache[plr] then
                        for _, box in pairs(charmCache[plr]) do box:Destroy() end; charmCache[plr] = nil; charmVisCache[plr] = nil
                    end
                end
            end
            for plr, _ in pairs(charmCache) do
                if not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    for _, box in pairs(charmCache[plr]) do box:Destroy() end; charmCache[plr] = nil; charmVisCache[plr] = nil
                end
            end
        end
    else
        if charmFolder then charmFolder:Destroy(); charmFolder = nil; for plr, parts in pairs(charmCache) do for _, box in pairs(parts) do box:Destroy() end end; table.clear(charmCache); table.clear(charmVisCache) end
    end
end)

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("菜单", "wrench")
MenuGroup:AddToggle("KeybindMenuOpen", { Default = false, Text = "打开快捷键菜单", Callback = function(v) Library.KeybindFrame.Visible=v end })
MenuGroup:AddToggle("ShowCustomCursor", { Text = "自定义光标", Default = true, Callback = function(v) Library.ShowCustomCursor=v end })
MenuGroup:AddDropdown("NotificationSide", { Values = {"左","右"}, Default = "右", Text = "通知位置", Callback = function(v) Library:SetNotifySide(v) end })
MenuGroup:AddDropdown("DPIDropdown", { Values = {"50%","75%","100%","125%","150%","175%","200%"}, Default = "100%", Text = "DPI缩放", Callback = function(v) v=v:gsub("%%",""); Library:SetDPIScale(tonumber(v)) end })
MenuGroup:AddDivider()
MenuGroup:AddLabel("菜单热键"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "菜单热键" })
MenuGroup:AddButton("卸载脚本", function() Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind

task.spawn(function()
    task.wait(0.5)
    pcall(function()
        ThemeManager:SetLibrary(Library)
        SaveManager:SetLibrary(Library)
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

Library:OnUnload(function()
    pcall(function() FOVCircle:Remove() end)
    for _, d in ipairs(drawings) do pcall(function() d:Remove() end) end
    for _, hl in ipairs(highlights) do pcall(function() hl:Destroy() end) end
    if charmFolder then charmFolder:Destroy() end
    if holder then holder:Destroy() end
    if endSphere then endSphere:Destroy() end
    RunService:UnbindFromRenderStep("GrenadePredict")
    print("已卸载")
end)
