local success, ui = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/hun/main/jmlibrary1.lua"))()
end)
if not success or not ui then
    return
end

local win = ui:new("训练怪物")
local infoTab = win:Tab("『脚本公告』", '87437251671184')
local infoSection = infoTab:section("关于", true)
infoSection:Label("霖溺QQ主群：744830231")
infoSection:Label("老肯制作")
infoSection:Label("感谢自己一路下来自己教自己写脚本")
infoSection:Label("多多支持伊散、霖溺、吃囊吃出毛线的神仇")
infoSection:Label("暂时先做散装的！因为服务器加载还没研究明白，懒得搞")
infoSection:Label("一路过来都是自己教自己都没人教我技术")
infoSection:Label("想叫我更新什么就直接在霖溺群@我")

local UITab1 = win:Tab("『通用』", '87437251671184')
local about = UITab1:section("『通用』", true)

local trainingRunning = false
local threads = {}

about:Toggle("快速训练", "Toggle", false, function(Value)
    if Value then
        if trainingRunning then return end
        trainingRunning = true
        local intervals = {0.15, 0.15, 0.15, 0.15}
        for _, interval in ipairs(intervals) do
            table.insert(threads, task.spawn(function()
                while trainingRunning do
                    task.wait(interval)
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("E&F")
                    if remote then
                        local train = remote:FindFirstChild("Train")
                        if train then
                            local event = train:FindFirstChild("TrainOnceRE")
                            if event then
                                event:FireServer()
                            end
                        end
                    end
                end
            end))
        end
    else
        trainingRunning = false
        for _, thread in ipairs(threads) do
            task.cancel(thread)
        end
        threads = {}
    end
end)

local glowRunning = false
local glowThread = nil
local args = { [1] = true }

about:Toggle("发光模式", "Toggle", false, function(Value)
    if Value then
        if glowRunning then return end
        glowRunning = true
        glowThread = task.spawn(function()
            while glowRunning do
                task.wait(0.5)
                local eandf = game:GetService("ReplicatedStorage"):FindFirstChild("E&F")
                if eandf then
                    local train = eandf:FindFirstChild("Train")
                    if train then
                        local event = train:FindFirstChild("FirePOWERVFX")
                        if event then
                            event:FireServer(unpack(args))
                        end
                    end
                end
            end
        end)
    else
        glowRunning = false
        if glowThread then
            task.cancel(glowThread)
            glowThread = nil
        end
    end
end)

local rebirthRunning = false
local rebirthThread = nil

about:Toggle("自动重生", "Toggle", false, function(Value)
    if Value then
        if rebirthRunning then return end
        rebirthRunning = true
        rebirthThread = task.spawn(function()
            while rebirthRunning do
                task.wait(2.5)
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local eAndF = replicatedStorage:FindFirstChild("E&F")
                if eAndF then
                    local rebirth = eAndF:FindFirstChild("Rebirth")
                    if rebirth then
                        local rebirthRE = rebirth:FindFirstChild("RebirthRE")
                        if rebirthRE and rebirthRE:IsA("RemoteEvent") then
                            rebirthRE:FireServer()
                        end
                    end
                end
            end
        end)
    else
        rebirthRunning = false
        if rebirthThread then
            task.cancel(rebirthThread)
            rebirthThread = nil
        end
    end
end)