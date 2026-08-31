local LoadedChunk = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

assert(LocalPlayer, "LocalPlayer is unavailable")

local function safeRun(label, callback)
    local ok, result = pcall(callback)
    if not ok then
        warn("[力量传奇/" .. label .. "] " .. tostring(result))
    end
    return ok, result
end

local function notify(title, content)
    safeRun("通知", function()
        LoadedChunk:Notify({
            Title = title,
            Content = content,
            Duration = 5,
        })
    end)
end

local function getRemote(names)
    local searchNames = type(names) == "table" and names or { names }
    local rEvents = ReplicatedStorage:FindFirstChild("rEvents")

    for _, name in ipairs(searchNames) do
        local remote = rEvents and rEvents:FindFirstChild(name)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            return remote
        end

        remote = ReplicatedStorage:FindFirstChild(name, true)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            return remote
        end
    end
end

local function callRemote(remote, ...)
    if not remote then
        return false
    end
    if remote:IsA("RemoteFunction") then
        remote:InvokeServer(...)
    else
        remote:FireServer(...)
    end
    return true
end

local function getPetShopFolder()
    local shared = ReplicatedStorage:FindFirstChild("shared")
    local runtime = shared and shared:FindFirstChild("runtime")
    return (runtime and runtime:FindFirstChild("cPetShopFolder"))
        or ReplicatedStorage:FindFirstChild("cPetShopFolder")
end

local function getPetShopRemote()
    local shared = ReplicatedStorage:FindFirstChild("shared")
    local runtime = shared and shared:FindFirstChild("runtime")
    local remote = ReplicatedStorage:FindFirstChild("cPetShopRemote")
        or (runtime and runtime:FindFirstChild("cPetShopRemote"))
    if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        return remote
    end
    return getRemote({ "cPetShopRemote", "petShopRemote" })
end

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot(character)
    character = character or getCharacter()
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

local function getHumanoid(character)
    character = character or getCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

local function getOwnedPets()
    local petsFolder = LocalPlayer:FindFirstChild("petsFolder")
    local pets = {}
    if not petsFolder then
        return pets
    end

    for _, category in ipairs(petsFolder:GetChildren()) do
        if category:IsA("Folder") then
            for _, pet in ipairs(category:GetChildren()) do
                table.insert(pets, pet)
            end
        else
            table.insert(pets, category)
        end
    end
    return pets
end

local function findOwnedPet(name)
    local wanted = string.lower(name)
    for _, pet in ipairs(getOwnedPets()) do
        if string.lower(pet.Name) == wanted then
            return pet
        end
    end
end

local function unequipAllPets()
    local equipPetEvent = getRemote("equipPetEvent")
    if not equipPetEvent then
        return false
    end
    for _, pet in ipairs(getOwnedPets()) do
        callRemote(equipPetEvent, "unequipPet", pet)
    end
    return true
end

local function equipOnlyPet(name)
    local pet = findOwnedPet(name)
    local equipPetEvent = getRemote("equipPetEvent")
    if not pet or not equipPetEvent then
        return false
    end

    local equippedPets = LocalPlayer:FindFirstChild("equippedPets")
    local pet1 = equippedPets and equippedPets:FindFirstChild("pet1")
    if pet1 and tostring(pet1.Value) == pet.Name then
        return true
    end

    unequipAllPets()
    task.wait(0.05)
    callRemote(equipPetEvent, "equipPet", pet)
    return true
end

local function findConsumable(name)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local consumables = LocalPlayer:FindFirstChild("consumablesFolder")
    return (character and character:FindFirstChild(name))
        or (backpack and backpack:FindFirstChild(name))
        or (consumables and consumables:FindFirstChild(name))
end

local function useConsumable(name)
    local item = findConsumable(name)
    if not item then
        return false
    end

    local eatEvent = getRemote("eatEvent")
    if eatEvent then
        callRemote(eatEvent, "eat", item)
        return true
    end

    local muscleEvent = LocalPlayer:FindFirstChild("muscleEvent")
    local command = name == "Protein Egg" and "proteinEgg"
        or name == "Tropical Shake" and "tropicalShake"
    if muscleEvent and command then
        muscleEvent:FireServer(command, item)
        return true
    end

    if item:IsA("Tool") then
        local humanoid = getHumanoid()
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if humanoid and backpack and item.Parent == backpack then
            humanoid:EquipTool(item)
        end
        item:Activate()
        return true
    end
    return false
end

local function claimOnlineRewards()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if firesignal and playerGui then
        for _, object in ipairs(playerGui:GetDescendants()) do
            if object:IsA("GuiButton") then
                local label = object:IsA("TextButton") and object.Text or object.Name
                local text = string.lower(tostring(label or ""))
                if object.Visible and (string.find(text, "claim", 1, true) or string.find(text, "领取", 1, true)) then
                    firesignal(object.Activated)
                    if object:IsA("TextButton") or object:IsA("ImageButton") then
                        firesignal(object.MouseButton1Click)
                    end
                end
            end
        end
    end

    local remotes = {}
    for _, object in ipairs(ReplicatedStorage:GetDescendants()) do
        if object:IsA("RemoteEvent") or object:IsA("RemoteFunction") then
            local name = string.lower(object.Name)
            local isReward = string.find(name, "reward", 1, true)
            local isOnline = string.find(name, "online", 1, true) or string.find(name, "time", 1, true)
            if isReward and isOnline then
                table.insert(remotes, object)
            end
        end
    end

    for _, remote in ipairs(remotes) do
        safeRun("在线奖励", function()
            callRemote(remote)
            for index = 1, 12 do
                callRemote(remote, index)
                callRemote(remote, "claimReward", index)
                callRemote(remote, "claimOnlineReward", index)
            end
        end)
    end
end

local function clampNumber(value, minimum, maximum)
    value = tonumber(value) or minimum
    if value < minimum then
        return minimum
    end
    if value > maximum then
        return maximum
    end
    return value
end

local loopTokens = {}
local function setLoop(name, enabled, interval, callback)
    loopTokens[name] = (loopTokens[name] or 0) + 1
    local token = loopTokens[name]
    if not enabled then
        return
    end

    task.spawn(function()
        while loopTokens[name] == token do
            safeRun(name, callback)
            task.wait(interval)
        end
    end)
end

local function loadRemote(urls)
    local errors = {}
    for _, url in ipairs(urls) do
        local ok, source = pcall(function()
            return game:HttpGet(url)
        end)
        if ok and type(source) == "string" and #source > 0 then
            local loader, compileError = loadstring(source)
            if loader then
                local ran, result = pcall(loader)
                if ran then
                    return result
                end
                table.insert(errors, tostring(result))
            else
                table.insert(errors, tostring(compileError))
            end
        else
            table.insert(errors, tostring(source))
        end
    end
    error(table.concat(errors, " | "))
end

LocalPlayer.Idled:Connect(function()
    safeRun("反挂机", function()
        VirtualUser:CaptureController()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

LoadedChunk.TransparencyValue = 0.2
LoadedChunk:SetTheme("Midnight")

local window = LoadedChunk:CreateWindow({
    Title = "安脚本·力量传奇",
    Icon = "geist:window",
    Author = "作者:ato|QQ2134702438",
    Folder = "WindUI_Example",
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    Acrylic = true,
    SideBarWidth = 150,
    HideSearchBar = false,
    OpenButton = {
        Title = "安脚本",
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#E7FF2F")),
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
    },
})

assert(window, "WindUI window creation failed")

window:CreateTopbarButton("theme-switcher", "moon", function()
    local current = LoadedChunk:GetCurrentTheme()
    LoadedChunk:SetTheme(current == "Dark" and "Light" or "Dark")
end, 990)

local aboutTab = window:Tab({ Title = "关于脚本", Border = true })
local aboutSection = aboutTab:Section({ Title = "使用须知" })
aboutSection:Section({
    Title = "安作者qq2134702438，没有任何小号和代理！\n安脚本是国内第一个做出来切换宠物和刷包的脚本，其他脚本都是缝合本脚本或在基础上优化\n本脚本为国内第一牛逼的力量传奇脚本，支持安脚本",
    TextSize = 18,
    TextTransparency = 0.35,
    FontWeight = Enum.FontWeight.Medium,
})
aboutTab:Paragraph({
    Title = "点击复制",
    Desc = "作者QQ:2134702438\n作者B站UID:3546736987474050\n安脚本群号:1036668808",
    Buttons = {
        {
            Title = "作者B站UID",
            Callback = function()
                if setclipboard then setclipboard("3546736987474050") end
            end,
        },
        {
            Title = "作者QQ",
            Callback = function()
                if setclipboard then setclipboard("2134702438") end
            end,
        },
        {
            Title = "安脚本Q群号",
            Callback = function()
                if setclipboard then setclipboard("1036668808") end
            end,
        },
    },
})

local logTab = window:Tab({ Title = "更新日志", Border = true })
local logSection = logTab:Section({ Title = "8月22日更新日志" })
logSection:Section({
    Title = "1.更新UI布局与风格\n2.优化功能代码，删除部分不必要功能（修改数据、小中大石头等）",
    TextSize = 18,
    TextTransparency = 0.35,
    FontWeight = Enum.FontWeight.Medium,
})

local dataTab = window:Tab({ Title = "玩家数据", Icon = "file" })
local dataParagraph = dataTab:Paragraph({ Title = "数据", Desc = "读取中..." })
task.spawn(function()
    while task.wait(1) do
        safeRun("玩家数据", function()
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            local parts = {}
            if leaderstats then
                for _, value in ipairs(leaderstats:GetChildren()) do
                    if value:IsA("ValueBase") then
                        table.insert(parts, value.Name .. ": " .. tostring(value.Value))
                    end
                end
            end
            dataParagraph:SetDesc(#parts > 0 and table.concat(parts, "\n") or "暂无可读取数据")
        end)
    end
end)

local displayTab = window:Tab({ Title = "减少延迟", Icon = "hand-helping" })
displayTab:Button({
    Title = "删除显示",
    Desc = "包括力量，头衔以及粒子效果等等",
    Callback = function()
        safeRun("删除显示", function()
            local character = getCharacter()
            local removed = 0
            for _, item in ipairs(character:GetDescendants()) do
                if item:IsA("ParticleEmitter") or item:IsA("Trail") or item:IsA("Beam") then
                    item:Destroy()
                    removed = removed + 1
                end
            end
            for _, name in ipairs({ "strengthFrame", "durabilityFrame", "agilityFrame" }) do
                local frame = ReplicatedStorage:FindFirstChild(name)
                if frame then
                    frame:Destroy()
                    removed = removed + 1
                end
            end
            notify("删除显示", "已清理 " .. tostring(removed) .. " 个本地显示对象。")
        end)
    end,
})
displayTab:Button({
    Title = "删除杂物",
    Callback = function()
        safeRun("删除杂物", function()
            local character = getCharacter()
            for _, item in ipairs(character:GetChildren()) do
                if item.Name == "sweatPart" or item.Name == "airPart" then
                    item:Destroy()
                end
            end
        end)
    end,
})

local inspectTab = window:Tab({ Title = "便捷显示", Icon = "eye" })
inspectTab:Button({
    Title = "便捷显示属性面板",
    Callback = function()
        local ok, err = pcall(function()
            loadRemote({
                "https://cdn.jsdelivr.net/gh/bloxato/script@main/Display",
                "https://raw.githubusercontent.com/bloxato/script/refs/heads/main/Display",
            })
        end)
        if not ok then
            notify("属性面板加载失败", tostring(err))
        end
    end,
})

local workoutTab = window:Tab({ Title = "锻炼功能", Icon = "rbxassetid://3650695359" })
local workoutType = "通用"
local workoutMultiplier = 200
local multiplierEnabled = false
workoutTab:Dropdown({
    Title = "请选择锻炼类型",
    Desc = "不选默认通用器材",
    Values = { "哑铃", "仰卧起坐", "俯卧撑", "倒立" },
    Value = nil,
    AllowNone = true,
    Multi = false,
    Callback = function(value)
        workoutType = tostring(value or "通用")
    end,
})
workoutTab:Toggle({
    Title = "自动锻炼",
    Value = false,
    Callback = function(value)
        setLoop("自动锻炼", value, 0.0001, function()
            local event = LocalPlayer:FindFirstChild("muscleEvent")
            if not event then
                error("未找到 muscleEvent")
            end
            local count = multiplierEnabled and clampNumber(workoutMultiplier, 1, 700) or 1
            for _ = 2, count do
                event:FireServer("rep")
            end
        end)
    end,
})
workoutTab:Section({ Title = "快速锻炼(需要至少7个2999R币包)", TextSize = 25 })
workoutTab:Input({
    Title = "自定义锻炼倍数",
    Desc = "建议200～300，手机配置好可以尝试更高",
    Placeholder = "请输入",
    Value = tostring(workoutMultiplier),
    ClearTextOnFocus = false,
    Callback = function(value)
        workoutMultiplier = clampNumber(value, 0.1, 1000)
    end,
})
workoutTab:Toggle({
    Title = "倍数锻炼",
    Value = false,
    Callback = function(value)
        multiplierEnabled = value and true or false
        notify("倍数锻炼", (multiplierEnabled and "已开启，倍数: " or "已关闭，当前设置: ") .. tostring(workoutMultiplier))
    end,
})

local rebirthTab = window:Tab({ Title = "重生功能", Icon = "rbxassetid://3165273130" })
local targetRebirth = 0
local rebirthData = rebirthTab:Paragraph({ Title = "数据:", Desc = "读取中..." })
local targetReachedNotice = false

local function requestRebirth()
    local remote = getRemote("rebirthRemote")
    if not remote then
        error("未找到 rebirthRemote")
    end
    callRemote(remote, "rebirthRequest")
end

rebirthTab:Toggle({
    Title = "自动传送肌肉之王健身房",
    Value = false,
    Callback = function(value)
        setLoop("自动传送肌肉之王健身房", value, 0.25, function()
            local root = getRoot()
            if root then
                root.CFrame = CFrame.new(-8646, 17, -5738)
            end
        end)
    end,
})
rebirthTab:Input({
    Title = "请输入指定重生",
    Desc = "达到指定重生自动停止转而继续锻炼",
    Value = "0",
    Placeholder = "请输入",
    ClearTextOnFocus = false,
    Callback = function(value)
        targetRebirth = math.floor(clampNumber(value, 0, 1000000000))
    end,
})
local autoRebirthToggle
autoRebirthToggle = rebirthTab:Toggle({
    Title = "自动重生",
    Desc = "不输入或为0则无上限",
    Value = false,
    Callback = function(value)
        targetReachedNotice = false
        setLoop("自动重生", value, 0.12, function()
            local stats = LocalPlayer:FindFirstChild("leaderstats")
            local rebirths = stats and stats:FindFirstChild("Rebirths")
            local current = rebirths and tonumber(rebirths.Value) or 0
            if targetRebirth > 0 and current >= targetRebirth then
                loopTokens["自动重生"] = (loopTokens["自动重生"] or 0) + 1
                if not targetReachedNotice then
                    targetReachedNotice = true
                    notify("自动重生", "已达到指定重生: " .. tostring(targetRebirth))
                end
                if autoRebirthToggle and autoRebirthToggle.SetValue then
                    autoRebirthToggle:SetValue(false)
                end
                return
            end
            requestRebirth()
        end)
    end,
})
rebirthTab:Section({ Title = "快速重生(需要至少7个2999R币包)", TextSize = 25 })
rebirthTab:Paragraph({
    Title = "提示",
    Desc = "1.开启本功能刷重生，请务必开启本区域的自动重生\n2.连点器建议设置延迟：1-7-1\n3.本功能只对7包以上人群有用\n4.开启本功能之前请确保没有任何宠物装备\n5.建议在丛林健身房中的硬拉锻炼（只加力量，可以减少延迟)",
})
rebirthTab:Toggle({
    Title = "自动切换宠物1",
    Value = false,
    Callback = function(value)
        setLoop("自动切换宠物1", value, 0.35, function()
            equipOnlyPet("Swift Samurai")
        end)
    end,
})
rebirthTab:Toggle({
    Title = "自动切换宠物2",
    Value = false,
    Callback = function(value)
        setLoop("自动切换宠物2", value, 0.35, function()
            equipOnlyPet("Tribal Overlord")
        end)
    end,
})
rebirthTab:Toggle({
    Title = "自动重生",
    Value = false,
    Callback = function(value)
        setLoop("快速自动重生", value, 0.08, requestRebirth)
    end,
})
task.spawn(function()
    while task.wait(1) do
        safeRun("重生数据", function()
            local stats = LocalPlayer:FindFirstChild("leaderstats")
            local rebirths = stats and stats:FindFirstChild("Rebirths")
            local current = rebirths and tonumber(rebirths.Value) or 0
            local petFolder = LocalPlayer:FindFirstChild("equippedPets")
            local pet = petFolder and petFolder:FindFirstChild("pet1")
            local required = 1000 + ((5000 * current) / 2)
            rebirthData:SetDesc("重生所需力量:" .. tostring(required) .. "\n当前宠物:" .. tostring(pet and pet.Value or "无"))
        end)
    end
end)

local killTab = window:Tab({ Title = "击杀功能", Icon = "rbxassetid://3649607608" })
local population = killTab:Paragraph({ Title = "当前服务器总人数:", Desc = tostring(#Players:GetPlayers()) })
Players.PlayerAdded:Connect(function()
    population:SetDesc(tostring(#Players:GetPlayers()))
end)
Players.PlayerRemoving:Connect(function()
    task.defer(function()
        population:SetDesc(tostring(#Players:GetPlayers()))
    end)
end)

local function punchOnce()
    local character = getCharacter()
    local humanoid = getHumanoid(character)
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local punch = character:FindFirstChild("Punch") or (backpack and backpack:FindFirstChild("Punch"))
    if punch and humanoid and backpack and punch.Parent == backpack then
        humanoid:EquipTool(punch)
    end
    punch = character:FindFirstChild("Punch") or punch
    if punch and punch:IsA("Tool") then
        punch:Activate()
    end
end

killTab:Toggle({
    Title = "自动挥拳",
    Value = false,
    Callback = function(value)
        setLoop("自动挥拳", value, 0.1, punchOnce)
    end,
})

local function touchPlayer(player)
    if player == LocalPlayer or not player.Character then
        return
    end
    local head = player.Character:FindFirstChild("Head")
    local character = getCharacter()
    local hand = character:FindFirstChild("LeftHand") or character:FindFirstChild("Left Arm")
    if head and hand and firetouchinterest then
        firetouchinterest(head, hand, 0)
        task.wait(0.01)
        firetouchinterest(head, hand, 1)
    end
end

local kingToggle
kingToggle = killTab:Toggle({
    Title = "隔空自动击杀肌肉之王拥有者",
    Desc = "读取中...",
    Value = false,
    Callback = function(value)
        setLoop("肌肉之王攻击", value, 0.15, function()
            local shared = ReplicatedStorage:FindFirstChild("shared")
            local state = shared and shared:FindFirstChild("state")
            local worldState = state and state:FindFirstChild("World")
            local kingValue = worldState and worldState:FindFirstChild("muscleKing")
            local king = kingValue and kingValue.Value
            local player = typeof(king) == "Instance" and king or Players:FindFirstChild(tostring(king or ""))
            if player then
                touchPlayer(player)
            end
        end)
    end,
})
task.spawn(function()
    while task.wait(1) do
        safeRun("肌肉之王状态", function()
            local shared = ReplicatedStorage:FindFirstChild("shared")
            local state = shared and shared:FindFirstChild("state")
            local worldState = state and state:FindFirstChild("World")
            local kingValue = worldState and worldState:FindFirstChild("muscleKing")
            kingToggle:SetDesc("当前: " .. tostring(kingValue and kingValue.Value or "未知"))
        end)
    end
end)
killTab:Toggle({
    Title = "隔空全图击杀",
    Value = false,
    Callback = function(value)
        setLoop("全图攻击", value, 0.1, function()
            for _, player in ipairs(Players:GetPlayers()) do
                touchPlayer(player)
            end
        end)
    end,
})

local rockTab = window:Tab({ Title = "石头功能", Icon = "rbxassetid://3649607608" })
local selectedRock = "Blue Rock"
local rockNames = {
    ["蓝石头"] = "Blue Rock",
    ["紫石头"] = "Purple Rock",
    ["橙石头"] = "Orange Rock",
    ["白石头"] = "White Rock",
    ["绿石头"] = "Green Rock",
    ["丛林石头"] = "Jungle Rock",
}
rockTab:Dropdown({
    Title = "请选择石头",
    Values = { "蓝石头", "紫石头", "橙石头", "白石头", "绿石头", "丛林石头" },
    Value = "蓝石头",
    AllowNone = false,
    Multi = false,
    Callback = function(value)
        selectedRock = rockNames[tostring(value)] or tostring(value)
    end,
})
rockTab:Toggle({
    Title = "隔空打石头",
    Desc = "",
    Value = false,
    Callback = function(value)
        setLoop("隔空打石头", value, 0.12, function()
            local character = getCharacter()
            local hand = character:FindFirstChild("LeftHand") or character:FindFirstChild("Left Arm")
            if not hand or not firetouchinterest then
                return
            end
            for _, object in ipairs(workspace:GetDescendants()) do
                if object:IsA("BasePart") and string.find(string.lower(object.Name), string.lower(selectedRock), 1, true) then
                    firetouchinterest(object, hand, 0)
                    firetouchinterest(object, hand, 1)
                    break
                end
            end
        end)
    end,
})

local shopTab = window:Tab({ Title = "宠物商店", Icon = "rbxassetid://2877421636" })
local selectedRarity = "普通"
local selectedPet = ""
local rarityNames = {
    ["普通"] = "Basic",
    ["高级"] = "Advanced",
    ["稀有"] = "Rare",
    ["史诗"] = "Epic",
    ["传说"] = "Unique",
}
local petDropdown
shopTab:Dropdown({
    Title = "请选择品质",
    Values = { "普通", "高级", "稀有", "史诗", "传说" },
    Value = selectedRarity,
    AllowNone = true,
    Multi = false,
    Callback = function(value)
        selectedRarity = tostring(value or "")
        safeRun("刷新宠物", function()
            if not petDropdown then
                return
            end
            local folder = getPetShopFolder()
            local values = {}
            if folder then
                for _, pet in ipairs(folder:GetChildren()) do
                    local rarity = pet:GetAttribute("Rarity") or pet:GetAttribute("rarity")
                    local wantedRarity = rarityNames[selectedRarity] or selectedRarity
                    if selectedRarity == "" or rarity == nil or tostring(rarity) == wantedRarity then
                        table.insert(values, pet.Name)
                    end
                end
            end
            table.sort(values)
            petDropdown:Refresh(values)
        end)
    end,
})
petDropdown = shopTab:Dropdown({
    Title = "请选择宠物",
    Values = {},
    Value = nil,
    AllowNone = true,
    Multi = false,
    Callback = function(value)
        selectedPet = tostring(value or "")
    end,
})
shopTab:Button({
    Title = "刷新宠物列表",
    Callback = function()
        local folder = getPetShopFolder()
        local values = {}
        if folder then
            for _, pet in ipairs(folder:GetChildren()) do
                table.insert(values, pet.Name)
            end
        end
        table.sort(values)
        petDropdown:Refresh(values)
        notify("宠物列表", "发现 " .. tostring(#values) .. " 个条目。")
    end,
})
shopTab:Toggle({
    Title = "自动购买宠物",
    Value = false,
    Callback = function(value)
        setLoop("自动购买宠物", value, 0.2, function()
            if selectedPet == "" then
                return
            end
            local folder = getPetShopFolder()
            local pet = folder and folder:FindFirstChild(selectedPet)
            local remote = getPetShopRemote()
            if not pet or not remote then
                error("未找到宠物商店对象或 Remote")
            end
            callRemote(remote, pet)
        end)
    end,
})
shopTab:Divider()

local selectedCrystal = "蓝色水晶"
local crystalCount = 1
local crystalNames = {
    ["蓝色水晶"] = "Blue Crystal",
    ["绿色水晶"] = "Green Crystal",
    ["暗星云水晶"] = "Dark Nebula Crystal",
    ["冰霜水晶"] = "Frost Crystal",
    ["银河甲骨文水晶"] = "Galaxy Oracle Crystal",
    ["丛林水晶"] = "Jungle Crystal",
    ["传奇水晶"] = "Legends Crystal",
    ["地狱水晶"] = "Inferno Crystal",
    ["神话水晶"] = "Mythical Crystal",
    ["肌肉精英水晶"] = "Muscle Elite Crystal",
    ["战斗传奇水晶"] = "Battle Legends Crystal",
    ["天空月食水晶"] = "Sky Eclipse Crystal",
    ["工业水晶"] = "Industrial Crystal",
}
shopTab:Dropdown({
    Title = "请选择水晶",
    Values = {
        "蓝色水晶", "绿色水晶", "暗星云水晶", "冰霜水晶", "银河甲骨文水晶", "丛林水晶",
        "传奇水晶", "地狱水晶", "神话水晶", "肌肉精英水晶", "战斗传奇水晶", "天空月食水晶", "工业水晶",
    },
    Value = selectedCrystal,
    AllowNone = true,
    Multi = false,
    Callback = function(value)
        selectedCrystal = tostring(value or selectedCrystal)
    end,
})
shopTab:Dropdown({
    Title = "请选择开启次数",
    Values = { "1", "3", "10" },
    Value = "1",
    AllowNone = false,
    Multi = false,
    Callback = function(value)
        crystalCount = tonumber(value) or 1
    end,
})
shopTab:Toggle({
    Title = "自动开水晶",
    Value = false,
    Callback = function(value)
        setLoop("自动开水晶", value, 0.2, function()
            local crystalName = crystalNames[selectedCrystal] or selectedCrystal
            local remote = getRemote("openCrystalRemote")
            if remote then
                for _ = 1, crystalCount do
                    callRemote(remote, "openCrystal", crystalName)
                end
                return
            end

            local folder = getPetShopFolder()
            local crystal = folder and folder:FindFirstChild(crystalName)
            local shopRemote = getPetShopRemote()
            if not crystal or not shopRemote then
                error("未找到水晶对象或 Remote")
            end
            for _ = 1, crystalCount do
                callRemote(shopRemote, crystal)
            end
        end)
    end,
})
local itemParagraph = shopTab:Paragraph({ Title = "物品", Desc = "读取中..." })
task.spawn(function()
    while task.wait(2) do
        safeRun("物品统计", function()
            local lines = {}
            for _, folderName in ipairs({ "petsFolder", "powerUpsFolder" }) do
                local folder = LocalPlayer:FindFirstChild(folderName)
                if folder then
                    table.insert(lines, folderName == "petsFolder" and "[宠物]" or "[光环/加成]")
                    for _, item in ipairs(folder:GetChildren()) do
                        local value = item:IsA("ValueBase") and item.Value or item:GetAttribute("Amount") or 1
                        table.insert(lines, item.Name .. " x" .. tostring(value))
                    end
                end
            end
            itemParagraph:SetDesc(#lines > 0 and table.concat(lines, "\n") or "暂无物品")
        end)
    end
end)

local foodTab = window:Tab({ Title = "吃食功能", Icon = "rbxassetid://3656052794" })
local selectedFood = "蛋白质棒"
local foodNames = {
    ["蛋白质棒"] = "Protein Bar",
    ["能量棒"] = "Energy Bar",
    ["健壮条"] = "TOUGH Bar",
    ["蛋白质奶昔"] = "Protein Shake",
    ["超级奶昔"] = "ULTRA Shake",
    ["能量奶昔"] = "Energy Shake",
}
local foodDropdown = foodTab:Dropdown({
    Title = "请选择食物:",
    Values = { "蛋白质棒", "能量棒", "健壮条", "蛋白质奶昔", "超级奶昔", "能量奶昔" },
    Value = selectedFood,
    AllowNone = true,
    Multi = false,
    Callback = function(value)
        selectedFood = tostring(value or selectedFood)
    end,
})
foodTab:Toggle({
    Title = "自动食用",
    Desc = "吃食物会使宠物经验上涨",
    Value = false,
    Callback = function(value)
        setLoop("自动食用", value, 0.35, function()
            useConsumable(foodNames[selectedFood] or selectedFood)
        end)
    end,
})
foodTab:Section({ Title = "特殊加成物品", TextSize = 25 })
foodTab:Toggle({
    Title = "自动吃蛋",
    Desc = "没有x2力量时自动吃蛋",
    Value = false,
    Callback = function(value)
        setLoop("自动吃蛋", value, 2, function()
            local timers = LocalPlayer:FindFirstChild("boostTimersFolder")
            local boost = timers and timers:FindFirstChild("Protein Egg")
            if boost and boost:IsA("ValueBase") and tonumber(boost.Value) and tonumber(boost.Value) > 0 then
                return
            end
            useConsumable("Protein Egg")
        end)
    end,
})
task.spawn(function()
    while task.wait(1) do
        safeRun("食物数量", function()
            local itemName = foodNames[selectedFood] or selectedFood
            local folder = LocalPlayer:FindFirstChild("consumablesFolder")
            local item = folder and folder:FindFirstChild(itemName)
            local amount = item and (item:IsA("ValueBase") and item.Value or item:GetAttribute("Amount")) or 0
            local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
            local character = LocalPlayer.Character
            for _, container in pairs({ backpack, character }) do
                if container then
                    for _, object in ipairs(container:GetChildren()) do
                        if object.Name == itemName then
                            amount = amount + 1
                        end
                    end
                end
            end
            foodDropdown:SetDesc("当前: " .. selectedFood .. " | 数量: " .. tostring(amount))
        end)
    end
end)

local rankTab = window:Tab({ Title = "排行榜", Icon = "clipboard-list" })
local selectedRank = 1
rankTab:Input({
    Title = "排行榜名次",
    Desc = "请输入名字1～99",
    Value = "1",
    Placeholder = "请输入",
    ClearTextOnFocus = false,
    Callback = function(value)
        selectedRank = math.floor(clampNumber(value, 1, 99))
    end,
})
local strengthRank = rankTab:Paragraph({ Title = "力量排行榜", Desc = "请先输入名次" })
local rebirthRank = rankTab:Paragraph({ Title = "重生排行榜", Desc = "请先输入名次" })
local function readLeaderboard(boardName)
    local board = workspace:FindFirstChild(boardName)
    local part = board and board:FindFirstChild("leaderboardPart")
    local gui = part and part:FindFirstChild("leaderboardGui")
    local list = gui and gui:FindFirstChild("playerList")
    local frame = list and list:FindFirstChild("innerFrame")
    if not frame then
        return "未找到排行榜"
    end

    local entries = {}
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("GuiObject") then
            table.insert(entries, child)
        end
    end
    table.sort(entries, function(a, b)
        return a.LayoutOrder < b.LayoutOrder
    end)
    local entry = entries[selectedRank]
    if not entry then
        return "该名次暂无数据"
    end
    local textValues = {}
    for _, object in ipairs(entry:GetDescendants()) do
        if object:IsA("TextLabel") and object.Text ~= "" then
            table.insert(textValues, object.Text)
        end
    end
    return #textValues > 0 and table.concat(textValues, " | ") or entry.Name
end
task.spawn(function()
    while task.wait(1) do
        safeRun("排行榜", function()
            strengthRank:SetDesc(readLeaderboard("strengthLeaderboard"))
            rebirthRank:SetDesc(readLeaderboard("rebirthsLeaderboard"))
        end)
    end
end)

local otherTab = window:Tab({ Title = "其他功能", Icon = "zap" })
local spinToggle = otherTab:Toggle({
    Title = "自动转盘",
    Desc = "当前次数: 读取中...",
    Value = false,
    Callback = function(value)
        setLoop("自动转盘", value, 0.5, function()
            local remote = getRemote("openFortuneWheelRemote")
            local chances = ReplicatedStorage:FindFirstChild("fortuneWheelChances")
            local wheel = chances and chances:FindFirstChild("Fortune Wheel")
            if not remote or not wheel then
                error("未找到转盘 Remote 或概率表")
            end
            callRemote(remote, "openFortuneWheel", wheel)
        end)
    end,
})
otherTab:Toggle({
    Title = "自动领取在线奖励",
    Desc = "卡宠的时候不要打开，否则将会导致经验上涨",
    Value = false,
    Callback = function(value)
        setLoop("自动领取在线奖励", value, 15, claimOnlineRewards)
    end,
})
otherTab:Button({
    Title = "传送所有宝箱",
    Callback = function()
        task.spawn(function()
            local root = getRoot()
            if not root then
                notify("传送宝箱", "未找到角色根部件。")
                return
            end
            local count = 0
            for _, object in ipairs(workspace:GetDescendants()) do
                if object:IsA("BasePart") and string.find(string.lower(object.Name), "chest", 1, true) then
                    root.CFrame = object.CFrame + Vector3.new(0, 3, 0)
                    count = count + 1
                    task.wait(0.2)
                end
            end
            notify("传送宝箱", "已尝试传送到 " .. tostring(count) .. " 个宝箱。")
        end)
    end,
})
otherTab:Toggle({
    Title = "自动加入乱斗",
    Value = false,
    Callback = function(value)
        setLoop("自动加入乱斗", value, 1, function()
            local remote = getRemote("brawlEvent")
            if not remote then
                error("未找到 brawlEvent")
            end
            callRemote(remote, "joinBrawl")
        end)
    end,
})
task.spawn(function()
    while task.wait(1) do
        safeRun("转盘次数", function()
            local spins = LocalPlayer:FindFirstChild("Spins")
            spinToggle:SetDesc("当前次数: " .. tostring(spins and spins.Value or 0))
        end)
    end
end)

local killLogTab = window:Tab({ Title = "检测击杀", Icon = "zap" })
local maxKillRecords = 10
killLogTab:Input({
    Title = "请输入最多记录击杀条数",
    Placeholder = "请输入",
    Value = tostring(maxKillRecords),
    ClearTextOnFocus = false,
    Callback = function(value)
        maxKillRecords = math.floor(clampNumber(value, 1, 100))
    end,
})
local killLog = killLogTab:Paragraph({ Title = "击杀信息", Desc = "最近击杀记录:\n暂无击杀记录..." })
local killRecords = {}
task.spawn(function()
    local leaderstats = LocalPlayer:WaitForChild("leaderstats", 30)
    local kills = leaderstats and leaderstats:FindFirstChild("Kills")
    if not kills then
        killLog:SetDesc("未找到 Kills 数据")
        return
    end
    local last = tonumber(kills.Value) or 0
    kills.Changed:Connect(function(value)
        local current = tonumber(value) or last
        if current > last then
            table.insert(killRecords, 1, os.date("%H:%M:%S") .. " 击杀数增加至 " .. tostring(current))
            while #killRecords > maxKillRecords do
                table.remove(killRecords)
            end
            killLog:SetDesc("最近击杀记录:\n" .. table.concat(killRecords, "\n"))
        end
        last = current
    end)
end)
