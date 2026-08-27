local RanTimes = 0

local Connection = game:GetService("RunService").Heartbeat:Connect(function()
    RanTimes += 1
end)

repeat
    task.wait()
until RanTimes >= 2

Connection:Disconnect()


local backgroundIDs = {
    "rbxassetid://123801569679489",
    "rbxassetid://96971948979145",
    "rbxassetid://73652381047275",
    "rbxassetid://89414694868778"
}

local bgFolder = "ChickenBeachChickenTech_Data"
local bgIndexFile = "background_index.txt"

local function getNextBackground()
    if not isfolder(bgFolder) then
        makefolder(bgFolder)
    end
    local nextIndex = 0
    if isfile(bgFolder .. "/" .. bgIndexFile) then
        nextIndex = tonumber(readfile(bgFolder .. "/" .. bgIndexFile)) or 0
    end
    local currentIndex = nextIndex
    writefile(bgFolder .. "/" .. bgIndexFile, tostring((nextIndex + 1) % #backgroundIDs))
    return backgroundIDs[currentIndex + 1]
end

local selectedBackground = getNextBackground()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "鸡肉沙滩鸡技",
    Icon = "dumbbell",
    Author = "7891",
    Folder = "ChickenBeachChickenTech",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HasOutline = true,
    Background = selectedBackground,
    User = {
        Enabled = true,
        Callback = function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local userId = player.UserId
            local thumbnail = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            Window:Dialog({
                Title = "玩家信息",
                Content = "头像：rbxassetid://" .. thumbnail .. "\n名称：" .. player.DisplayName .. "\n用户名：" .. player.Name,
                Icon = "user",
                Buttons = {
                    { Title = "关闭", Variant = "Primary", Callback = function() end }
                }
            })
        end,
        Anonymous = false
    }
})

Window:EditOpenButton({
    Title = "丢你老牟😡",
    Icon = "dumbbell",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("4F46E5"),
        Color3.fromHex("A855F7")
    ),
    Draggable = true,
})

local MainTab = Window:Tab({
    Title = "主要",
    Icon = "activity",
    Desc = ""
})

local EquipmentTab = Window:Tab({
    Title = "器材",
    Icon = "dumbbell",
    Desc = ""
})

local KillTab = Window:Tab({
    Title = "杀戮",
    Icon = "swords",
    Desc = ""
})

local MiscTab = Window:Tab({
    Title = "杂项",
    Icon = "wrench",
    Desc = ""
})

local TeleportTab = Window:Tab({
    Title = "传送",
    Icon = "map",
    Desc = ""
})

local EggTab = Window:Tab({
    Title = "抽蛋",
    Icon = "egg",
    Desc = ""
})

local PetTab = Window:Tab({
    Title = "宠物",
    Icon = "paw-print",
    Desc = ""
})

local NoticeTab = Window:Tab({
    Title = "公告",
    Icon = "megaphone",
    Desc = ""
})

NoticeTab:Paragraph({
    Title = "原作者：哈哈哈葛",
    Desc = ""
})

NoticeTab:Paragraph({
    Title = "禁止倒卖圈钱(说白了老弟就这点B功能你圈你妈呢 自己做一个不会吗？)",
    Desc = ""
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local deathPosition = nil
local reviveEnabled = false

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if reviveEnabled then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                deathPosition = root.Position
            end
        end
    end)
end

player.CharacterAdded:Connect(function(character)
    if reviveEnabled and deathPosition then
        task.wait(0.1)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        humanoidRootPart.CFrame = CFrame.new(deathPosition)
    end
    onCharacterAdded(character)
end)

if player.Character then
    onCharacterAdded(player.Character)
end

local selectedTool1 = "Dead Lift"
local selectedTool2 = "Dead Lift"
local selectedTool3 = "Dead Lift"
local selectedTool4 = "Dead Lift"

local autoEquipRunning = false
local autoEquipThread = nil

local function startAutoEquip()
    if autoEquipRunning then return end
    autoEquipRunning = true
    autoEquipThread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").remotes.dumbbellTake
        local rookieName = "Rookie Dumbbell"
        local isHoldingRookie = false

        local function findTool()
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local tool = backpack:FindFirstChild(selectedTool1)
                if tool then return tool, "backpack" end
            end
            if character then
                local tool = character:FindFirstChild(selectedTool1)
                if tool then return tool, "character" end
            end
            return nil, nil
        end

        while autoEquipRunning and task.wait(0.1) do
            local tool, location = findTool()

            if tool then
                if location == "backpack" then
                    local character = player.Character
                    if character then
                        tool.Parent = character
                    end
                end
            else
                Event:FireServer(selectedTool1)

                local character = player.Character
                local backpack = player:FindFirstChild("Backpack")
                if character and backpack and not isHoldingRookie then
                    local rookieInChar = character:FindFirstChild(rookieName)
                    local rookieInBack = backpack:FindFirstChild(rookieName)
                    if not rookieInChar and rookieInBack then
                        isHoldingRookie = true
                        rookieInBack.Parent = character
                        task.delay(4, function()
                            if rookieInBack and rookieInBack.Parent == character then
                                rookieInBack.Parent = backpack
                            end
                            isHoldingRookie = false
                        end)
                    end
                end
            end
        end
    end)
end

local function stopAutoEquip()
    autoEquipRunning = false
    autoEquipThread = nil
end

local autoEquip2Running = false
local autoEquip2Thread = nil

local function startAutoEquip2()
    if autoEquip2Running then return end
    autoEquip2Running = true
    autoEquip2Thread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").remotes.dumbbellTake
        local rookieName = "Rookie Dumbbell"
        local isHoldingRookie = false

        local function findTool()
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local tool = backpack:FindFirstChild(selectedTool2)
                if tool then return tool, "backpack" end
            end
            if character then
                local tool = character:FindFirstChild(selectedTool2)
                if tool then return tool, "character" end
            end
            return nil, nil
        end

        while autoEquip2Running and task.wait(0.1) do
            local tool, location = findTool()

            if tool then
                if location == "backpack" then
                    local character = player.Character
                    if character then
                        tool.Parent = character
                    end
                end
            else
                Event:FireServer(selectedTool2)

                local character = player.Character
                local backpack = player:FindFirstChild("Backpack")
                if character and backpack and not isHoldingRookie then
                    local rookieInChar = character:FindFirstChild(rookieName)
                    local rookieInBack = backpack:FindFirstChild(rookieName)
                    if not rookieInChar and rookieInBack then
                        isHoldingRookie = true
                        rookieInBack.Parent = character
                        task.delay(4, function()
                            if rookieInBack and rookieInBack.Parent == character then
                                rookieInBack.Parent = backpack
                            end
                            isHoldingRookie = false
                        end)
                    end
                end
            end
        end
    end)
end

local function stopAutoEquip2()
    autoEquip2Running = false
    autoEquip2Thread = nil
end

local autoEquip3Running = false
local autoEquip3Thread = nil

local function startAutoEquip3()
    if autoEquip3Running then return end
    autoEquip3Running = true
    autoEquip3Thread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").remotes.dumbbellTake
        local rookieName = "Rookie Dumbbell"
        local isHoldingRookie = false

        local function findTool()
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local tool = backpack:FindFirstChild(selectedTool3)
                if tool then return tool, "backpack" end
            end
            if character then
                local tool = character:FindFirstChild(selectedTool3)
                if tool then return tool, "character" end
            end
            return nil, nil
        end

        while autoEquip3Running and task.wait(0.1) do
            local tool, location = findTool()

            if tool then
                if location == "backpack" then
                    local character = player.Character
                    if character then
                        tool.Parent = character
                    end
                end
            else
                Event:FireServer(selectedTool3)

                local character = player.Character
                local backpack = player:FindFirstChild("Backpack")
                if character and backpack and not isHoldingRookie then
                    local rookieInChar = character:FindFirstChild(rookieName)
                    local rookieInBack = backpack:FindFirstChild(rookieName)
                    if not rookieInChar and rookieInBack then
                        isHoldingRookie = true
                        rookieInBack.Parent = character
                        task.delay(4, function()
                            if rookieInBack and rookieInBack.Parent == character then
                                rookieInBack.Parent = backpack
                            end
                            isHoldingRookie = false
                        end)
                    end
                end
            end
        end
    end)
end

local function stopAutoEquip3()
    autoEquip3Running = false
    autoEquip3Thread = nil
end

local autoEquip4Running = false
local autoEquip4Thread = nil

local function startAutoEquip4()
    if autoEquip4Running then return end
    autoEquip4Running = true
    autoEquip4Thread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").remotes.dumbbellTake
        local rookieName = "Rookie Dumbbell"
        local isHoldingRookie = false

        local function findTool()
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local tool = backpack:FindFirstChild(selectedTool4)
                if tool then return tool, "backpack" end
            end
            if character then
                local tool = character:FindFirstChild(selectedTool4)
                if tool then return tool, "character" end
            end
            return nil, nil
        end

        while autoEquip4Running and task.wait(0.1) do
            local tool, location = findTool()

            if tool then
                if location == "backpack" then
                    local character = player.Character
                    if character then
                        tool.Parent = character
                    end
                end
            else
                Event:FireServer(selectedTool4)

                local character = player.Character
                local backpack = player:FindFirstChild("Backpack")
                if character and backpack and not isHoldingRookie then
                    local rookieInChar = character:FindFirstChild(rookieName)
                    local rookieInBack = backpack:FindFirstChild(rookieName)
                    if not rookieInChar and rookieInBack then
                        isHoldingRookie = true
                        rookieInBack.Parent = character
                        task.delay(4, function()
                            if rookieInBack and rookieInBack.Parent == character then
                                rookieInBack.Parent = backpack
                            end
                            isHoldingRookie = false
                        end)
                    end
                end
            end
        end
    end)
end

local function stopAutoEquip4()
    autoEquip4Running = false
    autoEquip4Thread = nil
end

local autoLiftRunning = false
local autoLiftThread = nil

local function startAutoLift()
    if autoLiftRunning then return end
    autoLiftRunning = true
    autoLiftThread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").remotes.MuscleEvent
        while autoLiftRunning do
            task.wait()
            Event:FireServer("tool")
        end
    end)
end

local function stopAutoLift()
    autoLiftRunning = false
    autoLiftThread = nil
end

MainTab:Toggle({
    Title = "自动举重",
    Desc = "自动使用当前器材",
    Value = false,
    Callback = function(state)
        if state then
            startAutoLift()
        else
            stopAutoLift()
        end
    end
})

local autoRebirthRunning = false
local autoRebirthThread = nil

local function startAutoRebirth()
    if autoRebirthRunning then return end
    autoRebirthRunning = true
    autoRebirthThread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").remotes.rebirthRequest
        while autoRebirthRunning do
            task.wait()
            Event:FireServer()
        end
    end)
end

local function stopAutoRebirth()
    autoRebirthRunning = false
    autoRebirthThread = nil
end

MainTab:Toggle({
    Title = "自动重生",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        if state then
            startAutoRebirth()
        else
            stopAutoRebirth()
        end
    end
})

local autoSpinRunning = false
local autoSpinThread = nil

local function startAutoSpin()
    if autoSpinRunning then return end
    autoSpinRunning = true
    autoSpinThread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").spinRequest
        while autoSpinRunning do
            Event:FireServer()
            task.wait()
        end
    end)
end

local function stopAutoSpin()
    autoSpinRunning = false
    autoSpinThread = nil
end

MainTab:Toggle({
    Title = "自动转盘",
    Desc = "自动使用转盘",
    Value = false,
    Callback = function(state)
        if state then
            startAutoSpin()
        else
            stopAutoSpin()
        end
    end
})

local autoChocolateRunning = false
local autoChocolateThread = nil

local function startAutoChocolate()
    if autoChocolateRunning then return end
    autoChocolateRunning = true
    autoChocolateThread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").remotes.proteineRequest
        while autoChocolateRunning do
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            if character and backpack then
                local chocolateInChar = character:FindFirstChild("Chocolate")
                local chocolateInBack = backpack:FindFirstChild("Chocolate")
                if not chocolateInChar and chocolateInBack then
                    chocolateInBack.Parent = character
                end
                if chocolateInChar or character:FindFirstChild("Chocolate") then
                    Event:FireServer()
                end
            end
            task.wait()
        end
    end)
end

local function stopAutoChocolate()
    autoChocolateRunning = false
    autoChocolateThread = nil
end

MainTab:Toggle({
    Title = "自动吃巧克力",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        if state then
            startAutoChocolate()
        else
            stopAutoChocolate()
        end
    end
})

local autoPunchRunning = false
local autoPunchThread = nil

local function startAutoPunch()
    if autoPunchRunning then return end
    autoPunchRunning = true

    local function equipPunch()
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        if backpack and character then
            local punchTool = backpack:FindFirstChild("Punch")
            if punchTool and not character:FindFirstChild("Punch") then
                punchTool.Parent = character
            end
        end
    end
    equipPunch()

    autoPunchThread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("punchRequest")
        local hand = "LeftHand"
        while autoPunchRunning do
            Event:FireServer(hand)
            hand = (hand == "LeftHand") and "RightHand" or "LeftHand"
            task.wait()
        end
    end)
end

local function stopAutoPunch()
    autoPunchRunning = false
    autoPunchThread = nil
end

KillTab:Section({
    Title = "全图杀戮内置自动挥拳，不用两个都开"
})

KillTab:Toggle({
    Title = "自动挥拳",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        if state then
            startAutoPunch()
        else
            stopAutoPunch()
        end
    end
})

local killAllRunning = false
local killAllAttackThread = nil
local killAllTeleportThread = nil
local modifiedData = {}
local killAllCharacterAddedConnections = {}
local whitelistedPlayers = {}

local function startKillAll()
    if killAllRunning then return end
    killAllRunning = true

    local Event = game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("punchRequest")
    local hand = "LeftHand"
    local teleportDistance = 5
    local enlargedTorsoSize = Vector3.new(8, 8, 4)

    local function equipPunch()
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        if backpack and character then
            local punchTool = backpack:FindFirstChild("Punch")
            if punchTool and not character:FindFirstChild("Punch") then
                punchTool.Parent = character
            end
        end
    end
    equipPunch()

    killAllAttackThread = task.spawn(function()
        while killAllRunning do
            Event:FireServer(hand)
            hand = (hand == "LeftHand") and "RightHand" or "LeftHand"
            task.wait()
        end
    end)

    killAllTeleportThread = task.spawn(function()
        while killAllRunning do
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                local targetPosition = root.Position + root.CFrame.LookVector * teleportDistance

                for _, targetPlayer in ipairs(Players:GetPlayers()) do
                    if targetPlayer ~= player and not whitelistedPlayers[targetPlayer] then
                        if not killAllCharacterAddedConnections[targetPlayer] then
                            killAllCharacterAddedConnections[targetPlayer] = targetPlayer.CharacterAdded:Connect(function()
                                modifiedData[targetPlayer] = nil
                            end)
                        end

                        local targetChar = targetPlayer.Character
                        if targetChar then
                            if not modifiedData[targetPlayer] then
                                local playerData = { character = targetChar, parts = {} }
                                for _, part in ipairs(targetChar:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        playerData.parts[part] = {
                                            CFrame = part.CFrame,
                                            Size = part.Size,
                                            Transparency = part.Transparency
                                        }
                                        part.Transparency = 1
                                    end
                                end
                                modifiedData[targetPlayer] = playerData
                            else
                                for _, part in ipairs(targetChar:GetDescendants()) do
                                    if part:IsA("BasePart") and part.Transparency ~= 1 then
                                        part.Transparency = 1
                                    end
                                end
                            end

                            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                            local targetUpperTorso = targetChar:FindFirstChild("UpperTorso")
                            if targetRoot then
                                local directionAway = (targetPosition - root.Position).Unit
                                targetRoot.CFrame = CFrame.lookAt(targetPosition, targetPosition + directionAway)
                            end
                            if targetUpperTorso then
                                targetUpperTorso.Size = enlargedTorsoSize
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

local function stopKillAll()
    killAllRunning = false

    if killAllAttackThread then
        task.wait(0.1)
        killAllAttackThread = nil
    end
    if killAllTeleportThread then
        task.wait(0.1)
        killAllTeleportThread = nil
    end

    for _, conn in pairs(killAllCharacterAddedConnections) do
        conn:Disconnect()
    end
    killAllCharacterAddedConnections = {}

    for targetPlayer, data in pairs(modifiedData) do
        if targetPlayer and data and data.parts then
            for part, original in pairs(data.parts) do
                if part and part.Parent then
                    part.CFrame = original.CFrame
                    part.Size = original.Size
                    part.Transparency = original.Transparency
                end
            end
        end
    end
    modifiedData = {}
end

KillTab:Toggle({
    Title = "全图杀戮",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        if state then
            startKillAll()
        else
            stopKillAll()
        end
    end
})

KillTab:Section({
    Title = "选择玩家进行杀戮"
})

local selectedTargetPlayers = {}
local playerDisplayMap = {}

local targetedKillRunning = false
local targetedKillAttackThread = nil
local targetedKillTeleportThread = nil
local targetedModifiedData = {}
local targetedCharacterAddedConnections = {}

local function startTargetedKill()
    if targetedKillRunning then return end
    targetedKillRunning = true

    local Event = game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("punchRequest")
    local hand = "LeftHand"
    local teleportDistance = 5
    local enlargedTorsoSize = Vector3.new(8, 8, 4)

    local function equipPunch()
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        if backpack and character then
            local punchTool = backpack:FindFirstChild("Punch")
            if punchTool and not character:FindFirstChild("Punch") then
                punchTool.Parent = character
            end
        end
    end
    equipPunch()

    targetedKillAttackThread = task.spawn(function()
        while targetedKillRunning do
            Event:FireServer(hand)
            hand = (hand == "LeftHand") and "RightHand" or "LeftHand"
            task.wait()
        end
    end)

    targetedKillTeleportThread = task.spawn(function()
        while targetedKillRunning do
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                local targetPosition = root.Position + root.CFrame.LookVector * teleportDistance

                for targetPlayer in pairs(selectedTargetPlayers) do
                    if targetPlayer ~= player then
                        if not targetedCharacterAddedConnections[targetPlayer] then
                            targetedCharacterAddedConnections[targetPlayer] = targetPlayer.CharacterAdded:Connect(function()
                                targetedModifiedData[targetPlayer] = nil
                            end)
                        end

                        local targetChar = targetPlayer.Character
                        if targetChar then
                            if not targetedModifiedData[targetPlayer] then
                                local playerData = { character = targetChar, parts = {} }
                                for _, part in ipairs(targetChar:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        playerData.parts[part] = {
                                            CFrame = part.CFrame,
                                            Size = part.Size,
                                            Transparency = part.Transparency
                                        }
                                        part.Transparency = 1
                                    end
                                end
                                targetedModifiedData[targetPlayer] = playerData
                            else
                                for _, part in ipairs(targetChar:GetDescendants()) do
                                    if part:IsA("BasePart") and part.Transparency ~= 1 then
                                        part.Transparency = 1
                                    end
                                end
                            end

                            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                            local targetUpperTorso = targetChar:FindFirstChild("UpperTorso")
                            if targetRoot then
                                local directionAway = (targetPosition - root.Position).Unit
                                targetRoot.CFrame = CFrame.lookAt(targetPosition, targetPosition + directionAway)
                            end
                            if targetUpperTorso then
                                targetUpperTorso.Size = enlargedTorsoSize
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

local function stopTargetedKill()
    targetedKillRunning = false

    if targetedKillAttackThread then
        task.wait(0.1)
        targetedKillAttackThread = nil
    end
    if targetedKillTeleportThread then
        task.wait(0.1)
        targetedKillTeleportThread = nil
    end

    for _, conn in pairs(targetedCharacterAddedConnections) do
        conn:Disconnect()
    end
    targetedCharacterAddedConnections = {}

    for targetPlayer, data in pairs(targetedModifiedData) do
        if targetPlayer and data and data.parts then
            for part, original in pairs(data.parts) do
                if part and part.Parent then
                    part.CFrame = original.CFrame
                    part.Size = original.Size
                    part.Transparency = original.Transparency
                end
            end
        end
    end
    targetedModifiedData = {}
end

local playerDropdown = nil
local whitelistDropdown = nil
local isUpdatingDropdowns = false

local function updatePlayerDropdowns()
    if isUpdatingDropdowns then return end
    isUpdatingDropdowns = true

    for p in pairs(whitelistedPlayers) do
        if not p:IsDescendantOf(Players) then
            whitelistedPlayers[p] = nil
        end
    end
    for p in pairs(selectedTargetPlayers) do
        if not p:IsDescendantOf(Players) then
            selectedTargetPlayers[p] = nil
        end
    end

    local whitelistOptions = {}
    local selectOptions = {}
    playerDisplayMap = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local displayName = p.DisplayName .. "|" .. p.Name
            playerDisplayMap[displayName] = p
            table.insert(whitelistOptions, displayName)
            if not whitelistedPlayers[p] then
                table.insert(selectOptions, displayName)
            end
        end
    end

    if whitelistDropdown then
        whitelistDropdown:Refresh(whitelistOptions)
    end
    if playerDropdown then
        playerDropdown:Refresh(selectOptions)
    end

    isUpdatingDropdowns = false
end

playerDropdown = KillTab:Dropdown({
    Title = "选择玩家",
    Values = {},
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        if isUpdatingDropdowns then return end
        selectedTargetPlayers = {}
        for _, displayName in ipairs(option) do
            local p = playerDisplayMap[displayName]
            if p then
                selectedTargetPlayers[p] = true
            end
        end
    end
})

KillTab:Toggle({
    Title = "开启杀戮",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        if state then
            startTargetedKill()
        else
            stopTargetedKill()
        end
    end
})

whitelistDropdown = KillTab:Dropdown({
    Title = "白名单",
    Values = {},
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        if isUpdatingDropdowns then return end
        whitelistedPlayers = {}
        for _, displayName in ipairs(option) do
            local p = playerDisplayMap[displayName]
            if p then
                whitelistedPlayers[p] = true
            end
        end
        if playerDropdown then
            updatePlayerDropdowns()
        end
    end
})

updatePlayerDropdowns()

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    updatePlayerDropdowns()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    updatePlayerDropdowns()
end)

local lockPositionRunning = false
local lockPositionThread = nil
local lockPositionCFrame = nil

local function startLockPosition()
    if lockPositionRunning then return end
    lockPositionRunning = true
    lockPositionThread = task.spawn(function()
        repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local root = player.Character.HumanoidRootPart
        lockPositionCFrame = root.CFrame
        while lockPositionRunning do
            task.wait()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = lockPositionCFrame
            end
        end
    end)
end

local function stopLockPosition()
    lockPositionRunning = false
    lockPositionThread = nil
end

local removePetsRunning = false
local removePetsData = {}

local function startRemovePets()
    if removePetsRunning then return end
    removePetsRunning = true
    local petsFolder = workspace:FindFirstChild("PlayersFollowPets")
    if petsFolder then
        for _, pet in ipairs(petsFolder:GetChildren()) do
            removePetsData[pet] = pet.Parent
            pet.Parent = nil
        end
    end
end

local function stopRemovePets()
    removePetsRunning = false
    for pet, originalParent in pairs(removePetsData) do
        if pet and originalParent then
            pet.Parent = originalParent
        end
    end
    removePetsData = {}
end

local antiAfkRunning = false
local antiAfkThread = nil

local function startAntiAfk()
    if antiAfkRunning then return end
    antiAfkRunning = true
    antiAfkThread = task.spawn(function()
        local vim = game:GetService("VirtualInputManager")
        while antiAfkRunning do
            vim:SendKeyEvent(true, Enum.KeyCode.F13, false, nil)
            task.wait(0.1)
            vim:SendKeyEvent(false, Enum.KeyCode.F13, false, nil)
            task.wait(180)
        end
    end)
end

local function stopAntiAfk()
    antiAfkRunning = false
    antiAfkThread = nil
end

local autoClaimRunning = false
local autoClaimThread = nil

local function startAutoClaim()
    if autoClaimRunning then return end
    autoClaimRunning = true
    autoClaimThread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").claimReward
        while autoClaimRunning do
            for i = 1, 6 do
                Event:FireServer("reward" .. i)
                task.wait()
            end
        end
    end)
end

local function stopAutoClaim()
    autoClaimRunning = false
    autoClaimThread = nil
end

local autoChestClaimRunning = false
local autoChestClaimThread = nil
local chestRewards = {"Dumbbell Chest", "V Chest", "Forest Chest", "Sunny Chest", "Snow Chest", "Legend Chest", "Beach chest"}

local function startAutoChestClaim()
    if autoChestClaimRunning then return end
    autoChestClaimRunning = true
    autoChestClaimThread = task.spawn(function()
        local Event = game:GetService("ReplicatedStorage").remotes.CommunityRequest
        while autoChestClaimRunning do
            for _, chestName in ipairs(chestRewards) do
                Event:FireServer(chestName)
                task.wait()
            end
        end
    end)
end

local function stopAutoChestClaim()
    autoChestClaimRunning = false
    autoChestClaimThread = nil
end

MiscTab:Toggle({
    Title = "原地复活",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        reviveEnabled = state
    end
})

MiscTab:Toggle({
    Title = "锁定位置",
    Desc = "防止别人打你移动位置",
    Value = false,
    Callback = function(state)
        if state then
            startLockPosition()
        else
            stopLockPosition()
        end
    end
})

MiscTab:Toggle({
    Title = "删除宠物",
    Desc = "只是删除渲染宠物，防卡顿用的，不是出售宠物",
    Value = false,
    Callback = function(state)
        if state then
            startRemovePets()
        else
            stopRemovePets()
        end
    end
})

MiscTab:Toggle({
    Title = "防挂机踢出",
    Desc = "防止roblox的闲置20分钟踢出",
    Value = false,
    Callback = function(state)
        if state then
            startAntiAfk()
        else
            stopAntiAfk()
        end
    end
})

MiscTab:Toggle({
    Title = "自动领取时长奖励",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        if state then
            startAutoClaim()
        else
            stopAutoClaim()
        end
    end
})

MiscTab:Toggle({
    Title = "自动领取宝箱奖励",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        if state then
            startAutoChestClaim()
        else
            stopAutoChestClaim()
        end
    end
})

PetTab:Section({
    Title = "出售宠物"
})

local selectedPetNames = {}
local petDropdowns = {}

local function updateSelectedPets()
    local allSelected = {}
    for _, dropdown in ipairs(petDropdowns) do
        local value = dropdown.Value
        if type(value) == "table" then
            for _, name in ipairs(value) do
                table.insert(allSelected, name)
            end
        elseif value then
            table.insert(allSelected, value)
        end
    end
    selectedPetNames = allSelected
end

local function sellPetByName(petName)
    local petsFolder = player:FindFirstChild("PetsFolder")
    if not petsFolder then return 0 end
    local sold = 0
    for _, pet in ipairs(petsFolder:GetChildren()) do
        if pet.Name == petName then
            game:GetService("ReplicatedStorage").remotes.sellRequest:FireServer(pet)
            sold = sold + 1
        end
    end
    return sold
end

local function sellSelectedPets()
    for _, petName in ipairs(selectedPetNames) do
        sellPetByName(petName)
        task.wait(0.1)
    end
end

local petOptionLists = {
    {"Cat", "Dog", "Rabbit", "Hamster", "Shark"},
    {"Wolf", "Fox", "Muscleman", "Spike", "Bear"},
    {"Snow Wolf", "Forest Dear", "Fire Pup", "Shadow Wolf", "Thunder Bear"},
    {"Spirit Wolf", "Void Owl", "Storm Tiger", "Lunar Dragon", "Crystal Dragon"},
    {"Pelican", "Divine Dragon", "Neon Divine Dragon", "Space Dragon"},
    {"Red Alien", "Fire Alien", "Vortex", "Astrax"}
}

local petDropdownTitles = {
    "普通蛋",
    "罕见蛋",
    "稀有蛋",
    "史诗蛋",
    "神话蛋",
    "大师蛋"
}

for i = 1, 6 do
    local dropdown = PetTab:Dropdown({
        Title = petDropdownTitles[i],
        Values = petOptionLists[i],
        Value = {},
        Multi = true,
        AllowNone = true,
        Callback = function(option)
            updateSelectedPets()
        end
    })
    table.insert(petDropdowns, dropdown)
end

local autoSellRunning = false
local autoSellThread = nil

local function startAutoSell()
    if autoSellRunning then return end
    autoSellRunning = true
    autoSellThread = task.spawn(function()
        while autoSellRunning do
            sellSelectedPets()
            task.wait()
        end
    end)
end

local function stopAutoSell()
    autoSellRunning = false
    autoSellThread = nil
end

PetTab:Toggle({
    Title = "自动出售",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            startAutoSell()
        else
            stopAutoSell()
        end
    end
})

PetTab:Button({
    Title = "出售一个",
    Desc = "",
    Callback = function()
        sellSelectedPets()
    end
})

PetTab:Section({
    Title = "进化宠物"
})

local function evolveAllPets()
    local petsFolder = player:FindFirstChild("PetsFolder")
    if not petsFolder then return end
    local Event = game:GetService("ReplicatedStorage").remotes.petupgradeRequest
    local petsByName = {}
    for _, pet in ipairs(petsFolder:GetChildren()) do
        if pet and pet.Name then
            local upgradeFlag = pet:FindFirstChild("isUpgrade")
            if not (upgradeFlag and upgradeFlag.Value == true) then
                if not petsByName[pet.Name] then
                    petsByName[pet.Name] = {}
                end
                table.insert(petsByName[pet.Name], pet)
            end
        end
    end
    for name, pets in pairs(petsByName) do
        while #pets >= 3 do
            local group = {pets[1], pets[2], pets[3]}
            Event:FireServer(group)
            table.remove(pets, 1)
            table.remove(pets, 1)
            table.remove(pets, 1)
            task.wait(0.1)
        end
    end
end

local autoEvolveRunning = false
local autoEvolveThread = nil

local function startAutoEvolve()
    if autoEvolveRunning then return end
    autoEvolveRunning = true
    autoEvolveThread = task.spawn(function()
        while autoEvolveRunning do
            evolveAllPets()
            task.wait(0.1)
        end
    end)
end

local function stopAutoEvolve()
    autoEvolveRunning = false
    autoEvolveThread = nil
end

PetTab:Toggle({
    Title = "自动进化",
    Desc = "顾名思义",
    Value = false,
    Callback = function(state)
        if state then
            startAutoEvolve()
        else
            stopAutoEvolve()
        end
    end
})

TeleportTab:Section({
    Title = "传送岛屿"
})

local function teleportTo(cf)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = cf
    end
end

TeleportTab:Button({
    Title = "冰霜岛",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(1750.88525, 10.850832, -97.3209229, -1.19209133e-07, -6.94625371e-08, -1, 4.61967602e-08, 1, -6.94625442e-08, 1, -4.61967673e-08, -1.19209133e-07))
    end
})

TeleportTab:Button({
    Title = "阳光岛",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(3578.39111, 11.3074427, 302.497833, -1.19209275e-07, 1.12956344e-09, -1, -9.0483594e-09, 1, 1.12956444e-09, 1, 9.0483594e-09, -1.19209275e-07))
    end
})

TeleportTab:Button({
    Title = "森林世界",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(-159.789536, 11.3320751, 2581.15576, -1, 5.71108894e-16, 8.9541084e-32, 5.71108894e-16, 1, 3.0982742e-16, 8.74041176e-32, 3.0982742e-16, -1))
    end
})

TeleportTab:Button({
    Title = "火山世界",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(-68.7614594, 12.6194515, 4315.79395, -1, 3.02503906e-08, -2.13314948e-14, 3.02503906e-08, 1, -3.6406469e-08, 2.02301842e-14, -3.6406469e-08, -1))
    end
})

TeleportTab:Button({
    Title = "哑铃世界",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(-1740.26685, 11.3320751, 368.174683, -1.19209275e-07, -5.09700719e-11, 1, 4.35550369e-08, 1, 5.09752657e-11, -1, 4.35550369e-08, -1.19209275e-07))
    end
})

TeleportTab:Section({
    Title = "其他区域"
})

TeleportTab:Button({
    Title = "VIP区域",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(-257.523193, 8.73967266, 348.692444, -0.0972048119, 8.29084641e-08, 0.995264411, 2.08757704e-08, 1, -8.12640764e-08, -0.995264411, 1.28776518e-08, -0.0972048119))
    end
})

TeleportTab:Button({
    Title = "出生岛竞技场",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(-24.1556759, 11.4150496, 341.724823, -0.986523509, -3.33584751e-08, -0.163619518, -1.8231864e-08, 1, -9.39515701e-08, 0.163619518, -8.97023398e-08, -0.986523509))
    end
})

TeleportTab:Button({
    Title = "头目",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(256.714996, 10.6357336, 336.981842, -0.00746340817, 5.08077349e-08, -0.999972165, -6.81456456e-08, 1, 5.13177625e-08, 0.999972165, 6.85267523e-08, -0.00746340817))
    end
})

TeleportTab:Button({
    Title = "安全区",
    Desc = "",
    Callback = function()
        teleportTo(CFrame.new(-234.462982, 10.5597506, 13.9703417, -0.0534088016, 1.02797024e-08, 0.998572707, 3.17798481e-08, 1, -8.59464588e-09, -0.998572707, 3.12754587e-08, -0.0534088016))
    end
})

TeleportTab:Section({
    Title = "阴间点位(有加成)"
})

local createdFloors = {}

local function teleportWithFloor(cf, key)
    teleportTo(cf)
    if not createdFloors[key] then
        createdFloors[key] = true
        task.spawn(function()
            task.wait(0.05)
            local part = Instance.new("Part")
            part.Size = Vector3.new(10, 1, 10)
            part.Position = cf.Position - Vector3.new(0, 2.5, 0)
            part.Anchored = true
            part.CanCollide = true
            part.Massless = true
            part.Locked = true
            part.Parent = workspace
        end)
    end
end

local function shrinkPart4()
    local targetSize = Vector3.new(196.86654663085938, 31.569665908813477, 189.82887268066406)
    local newSize = Vector3.new(196.86654663085938, 1, 189.82887268066406)
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "Part4" and obj:IsA("BasePart") then
            local size = obj.Size
            if math.abs(size.X - targetSize.X) < 0.01 and
               math.abs(size.Y - targetSize.Y) < 0.01 and
               math.abs(size.Z - targetSize.Z) < 0.01 then
                obj.Size = newSize
                break
            end
        end
    end
end

TeleportTab:Button({
    Title = "阴间冰霜",
    Desc = "有加成",
    Callback = function()
        teleportWithFloor(CFrame.new(1877.01624, -18.3961716, 79.8687515, -0.0570680015, 0.0186032858, -0.998196959, 3.52947359e-11, 0.999826372, 0.0186336525, 0.99837029, 0.00106338528, -0.0570580922), "阴间冰霜")
    end
})

TeleportTab:Button({
    Title = "阴间阳光",
    Desc = "有加成",
    Callback = function()
        teleportWithFloor(CFrame.new(3828.05884, -21.4522266, 400.468719, -0.355241776, -0.0186421406, -0.934588552, -2.16733187e-09, 0.999801099, -0.0199429281, 0.934774458, -0.00708455918, -0.355171144), "阴间阳光")
    end
})

TeleportTab:Button({
    Title = "阴间森林",
    Desc = "有加成",
    Callback = function()
        teleportWithFloor(CFrame.new(-299.5914, -21.2065258, 2651.88037, 0.482831359, -0.0497556701, -0.874298692, 2.5533653e-09, 0.998384595, -0.0568173006, 0.875713348, 0.0274331737, 0.482051402), "阴间森林")
    end
})

TeleportTab:Button({
    Title = "阴间火山",
    Desc = "有加成",
    Callback = function()
        local cf = CFrame.new(-109.754448, -2.66538072, 4398.94971, 0.0710230842, 1.52219553e-08, -0.99747467, 1.98873948e-08, 1, 1.66765339e-08, 0.99747467, -2.10215916e-08, 0.0710230842)
        teleportWithFloor(cf, "阴间火山")
        shrinkPart4()
    end
})

TeleportTab:Button({
    Title = "阴间哑铃",
    Desc = "有加成",
    Callback = function()
        teleportWithFloor(CFrame.new(-1818.23792, -18.6075249, 339.463196, -0.999936283, 0.00010673744, 0.0112887826, -5.11255578e-12, 0.999955297, -0.00945475511, -0.0112892874, -0.00945415255, -0.999891579), "阴间哑铃")
    end
})

EggTab:Section({
    Title = "单抽"
})

EggTab:Button({
    Title = "普通(25)",
    Desc = "",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").remotes.BuyPetRequest
        Event:FireServer("common")
    end
})

EggTab:Button({
    Title = "罕见(350)",
    Desc = "",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").remotes.BuyPetRequest
        Event:FireServer("uncommon")
    end
})

EggTab:Button({
    Title = "稀有(2.5K)",
    Desc = "",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").remotes.BuyPetRequest
        Event:FireServer("rare")
    end
})

EggTab:Button({
    Title = "史诗(15K)",
    Desc = "",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").remotes.BuyPetRequest
        Event:FireServer("epic")
    end
})

EggTab:Button({
    Title = "神话(90K)",
    Desc = "",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").remotes.BuyPetRequest
        Event:FireServer("mythic")
    end
})

EggTab:Button({
    Title = "大师(3M)",
    Desc = "",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").remotes.BuyPetRequest
        Event:FireServer("master")
    end
})

EggTab:Section({
    Title = "自动抽"
})

local function createAutoBuyToggle(title, petType)
    local running = false
    local thread = nil
    EggTab:Toggle({
        Title = title,
        Desc = "",
        Value = false,
        Callback = function(state)
            if state then
                if running then return end
                running = true
                thread = task.spawn(function()
                    local Event = game:GetService("ReplicatedStorage").remotes.BuyPetRequest
                    while running do
                        Event:FireServer(petType)
                        task.wait()
                    end
                end)
            else
                running = false
                thread = nil
            end
        end
    })
end

createAutoBuyToggle("普通(25)", "common")
createAutoBuyToggle("罕见(350)", "uncommon")
createAutoBuyToggle("稀有(2.5K)", "rare")
createAutoBuyToggle("史诗(15K)", "epic")
createAutoBuyToggle("神话(90K)", "mythic")
createAutoBuyToggle("大师(3M)", "master")

local toolMap1 = {
    ["一公斤哑铃(默认)"] = "Rookie Dumbbell",
    ["五公斤哑铃(出生岛)"] = "Dumbbell Curl",
    ["十公斤哑铃(出生岛、冰霜岛)"] = "Dumbbell Curl2",
    ["十五公斤哑铃(阳光岛)"] = "Dumbbell Curl3",
    ["二十五公斤哑铃(森林世界)"] = "Dumbbell Curl4",
    ["四十公斤哑铃(火山世界)"] = "Dumbbell Curl Magma",
    ["七十五公斤哑铃(哑铃世界)"] = "Dumbbell Curl Legend"
}

local toolMap2 = {
    ["五公斤深蹲(出生岛)"] = "Squat",
    ["十公斤深蹲(出生岛、冰霜岛)"] = "Squat2",
    ["十五公斤深蹲(阳光岛)"] = "Squat3",
    ["二十五公斤深蹲(森林世界)"] = "Squat4",
    ["四十公斤深蹲(火山世界)"] = "Squat Magma",
    ["七十五公斤深蹲(哑铃世界)"] = "Squat Legend"
}

local toolMap3 = {
    ["五公斤硬拉(出生岛)"] = "Dead Lift",
    ["十公斤硬拉(出生岛、冰霜岛)"] = "Dead Lift2",
    ["十五公斤硬拉(阳光岛)"] = "Dead Lift3",
    ["二十五公斤硬拉(森林世界)"] = "Dead Lift4",
    ["四十公斤硬拉(火山世界)"] = "Dead Lift Magma",
    ["七十五公斤硬拉(哑铃世界)"] = "Dead Lift Legend"
}

local toolMap4 = {
    ["五公斤俯卧撑(出生岛)"] = "Push Ups",
    ["十公斤俯卧撑(出生岛、冰霜岛)"] = "Push Ups2",
    ["二十五公斤俯卧撑(森林世界)"] = "Push Ups3",
    ["四十公斤俯卧撑(火山世界)"] = "Push Ups Magma",
    ["七十五公斤俯卧撑(哑铃世界)"] = "Push Ups Legend"
}

EquipmentTab:Section({
    Title = "哑铃"
})

EquipmentTab:Dropdown({
    Title = "选择哑铃",
    Values = {"一公斤哑铃(默认)", "五公斤哑铃(出生岛)", "十公斤哑铃(出生岛、冰霜岛)", "十五公斤哑铃(阳光岛)", "二十五公斤哑铃(森林世界)", "四十公斤哑铃(火山世界)", "七十五公斤哑铃(哑铃世界)"},
    Value = "一公斤哑铃(默认)",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        selectedTool1 = toolMap1[option]
    end
})

EquipmentTab:Toggle({
    Title = "自动装备哑铃",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            startAutoEquip()
        else
            stopAutoEquip()
        end
    end
})

EquipmentTab:Section({
    Title = "深蹲"
})

EquipmentTab:Dropdown({
    Title = "选择深蹲",
    Values = {"五公斤深蹲(出生岛)", "十公斤深蹲(出生岛、冰霜岛)", "十五公斤深蹲(阳光岛)", "二十五公斤深蹲(森林世界)", "四十公斤深蹲(火山世界)", "七十五公斤深蹲(哑铃世界)"},
    Value = "五公斤深蹲(出生岛)",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        selectedTool2 = toolMap2[option]
    end
})

EquipmentTab:Toggle({
    Title = "自动装备深蹲",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            startAutoEquip2()
        else
            stopAutoEquip2()
        end
    end
})

EquipmentTab:Section({
    Title = "硬拉"
})

EquipmentTab:Dropdown({
    Title = "选择硬拉",
    Values = {"五公斤硬拉(出生岛)", "十公斤硬拉(出生岛、冰霜岛)", "十五公斤硬拉(阳光岛)", "二十五公斤硬拉(森林世界)", "四十公斤硬拉(火山世界)", "七十五公斤硬拉(哑铃世界)"},
    Value = "五公斤硬拉(出生岛)",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        selectedTool3 = toolMap3[option]
    end
})

EquipmentTab:Toggle({
    Title = "自动装备硬拉",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            startAutoEquip3()
        else
            stopAutoEquip3()
        end
    end
})

EquipmentTab:Section({
    Title = "俯卧撑"
})

EquipmentTab:Dropdown({
    Title = "选择俯卧撑",
    Values = {"五公斤俯卧撑(出生岛)", "十公斤俯卧撑(出生岛、冰霜岛)", "二十五公斤俯卧撑(森林世界)", "四十公斤俯卧撑(火山世界)", "七十五公斤俯卧撑(哑铃世界)"},
    Value = "五公斤俯卧撑(出生岛)",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        selectedTool4 = toolMap4[option]
    end
})

EquipmentTab:Toggle({
    Title = "自动装备俯卧撑",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            startAutoEquip4()
        else
            stopAutoEquip4()
        end
    end
})

Window:SelectTab(1)