local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/hun/main/jmlibrary1.lua"))()     
local win = ui:new("老肯脚本")
local UITab1 = win:Tab("『通用』",'87437251671184')
local about = UITab1:section("『通用』",true)

local isLooping = false
local loopCoroutine = nil
local LocalPlayer = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")

local function GetCharacter()
    if not LocalPlayer.Character or not LocalPlayer.Character.Parent then
        LocalPlayer.CharacterAdded:Wait()
    end
    return LocalPlayer.Character
end

local function GetHumanoidRootPart()
    local character = GetCharacter()
    if not character:FindFirstChild("HumanoidRootPart") then
        return character:WaitForChild("HumanoidRootPart")
    end
    return character.HumanoidRootPart
end

local function SafeTeleport(targetCFrame)
    local hrp = GetHumanoidRootPart()
    if not hrp then return end
    local originalCanCollide = {}
    for _, part in pairs(GetCharacter():GetDescendants()) do
        if part:IsA("BasePart") then
            originalCanCollide[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    hrp.CFrame = targetCFrame
    task.wait(0.2)
    for part, originalValue in pairs(originalCanCollide) do
        if part and part.Parent then
            part.CanCollide = originalValue
        end
    end
end

local function IsNPC(model)
    if not model or not model:IsA("Model") then return false end
    if model == GetCharacter() then return false end
    if game:GetService("Players"):GetPlayerFromCharacter(model) then return false end
    local humanoid = model:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return false end
    if humanoid.Health <= 0 then return false end
    local name = model.Name:lower()
    local excludeKeywords = {"effect", "particle", "weapon", "tool", "decoration"}
    for _, keyword in pairs(excludeKeywords) do
        if name:find(keyword) then return false end
    end
    return true
end

local function GetAllNPCs()
    local npcList = {}
    for _, model in pairs(Workspace:GetDescendants()) do
        if IsNPC(model) then
            local npcHrp = model:FindFirstChild("HumanoidRootPart")
            if npcHrp and npcHrp.Position then
                table.insert(npcList, {
                    model = model,
                    hrp = npcHrp,
                    name = model.Name,
                    position = npcHrp.Position
                })
            end
        end
    end
    return npcList
end

local function TeleportToNPC(npcInfo)
    if not npcInfo or not npcInfo.hrp then return false end
    local npcPosition = npcInfo.hrp.Position
    local npcCFrame = npcInfo.hrp.CFrame
    local forwardOffset = npcCFrame.LookVector * 1.5
    local basePosition = npcPosition + forwardOffset
    basePosition = Vector3.new(basePosition.X, basePosition.Y + 1, basePosition.Z)
    local finalPosition = basePosition + Vector3.new(0, 3, 0)
    local lookAtPosition = Vector3.new(npcPosition.X, finalPosition.Y, npcPosition.Z)
    local finalCFrame = CFrame.new(finalPosition, lookAtPosition)
    SafeTeleport(finalCFrame)
    return true
end

local function StartLoopTeleport()
    if loopCoroutine then return end
    loopCoroutine = task.spawn(function()
        while task.wait(2.5) and isLooping do
            local npcList = GetAllNPCs()
            if #npcList == 0 then
                task.wait(5)
                continue
            end
            for _, npc in ipairs(npcList) do
                if not isLooping then break end
                TeleportToNPC(npc)
                local startWait = os.clock()
                while os.clock() - startWait < 2.5 and isLooping do
                    task.wait(0.1)
                end
                if not isLooping then break end
            end
        end
        loopCoroutine = nil
    end)
end

local function StopLoopTeleport()
    isLooping = false
    if loopCoroutine then
        task.cancel(loopCoroutine)
        loopCoroutine = nil
    end
end

about:Toggle("自动NPC", "Toggle", false, function(Value)
    if Value then
        if not isLooping then
            isLooping = true
            StartLoopTeleport()
        end
    else
        if isLooping then
            StopLoopTeleport()
        end
    end
end)