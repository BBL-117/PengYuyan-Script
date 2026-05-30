local W=loadstring(game:HttpGet("https://raw.githubusercontent.com/Yisan886/Aero/refs/heads/main/ui.lua.txt"))()
W:AddTheme({Name="My Theme",Accent=Color3.fromHex("#18181b"),Background=Color3.fromHex("#101010"),Outline=Color3.fromHex("#FFFFFF"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#7a7a7a"),Button=Color3.fromHex("#52525b"),Icon=Color3.fromHex("#a1a1aa")})
local X=W:CreateWindow({Title="国内最强被诅咒之刃      ",Folder="国内最强被诅咒之刃",SideBarWidth=180,Background="https://chaton-images.s3.us-east-2.amazonaws.com/GHn9L9UJLf0XcVNyCpbG72D0rmNmBEWndPkh6CjJNya8GLnWzz1vImvt8wlJSBwv_2700x1519x1393696.jpeg",BackgroundImageTransparency=0.5,OpenButton={Title="打开脚本",CornerRadius=UDim.new(1,0),StrokeThickness=3,Enabled=true,Draggable=true,OnlyMobile=false,Scale=0.9,Color=ColorSequence.new(Color3.fromHex("#30FF6A"),Color3.fromHex("#e7ff2f"))},Topbar={Height=44,ButtonsType="Mac"}})
X:Tag({Title="V91.78",Color=Color3.fromHex("00CED1"),Radius=2})
X:Tag({Title="老肯",Icon="crown",Color=Color3.fromHex("FFD700"),Radius=2})
local L=game:GetService("Lighting")
local T=game:GetService("TweenService")
local B=L:FindFirstChildOfClass("BlurEffect")
if not B then B=Instance.new("BlurEffect") B.Size=0 B.Parent=L end
local _0=false
task.spawn(function()while true do task.wait(0.1)local M=X.UIElements and X.UIElements.Main local V=M and M.Visible or false if V~=_0 then _0=V T:Create(B,TweenInfo.new(0.3),{Size=V and 20 or 0}):Play()end end end)
local P=game:GetService("Players")
local R=game:GetService("ReplicatedStorage")
local U=game:GetService("RunService")
local p=P.LocalPlayer
local g=p:WaitForChild("PlayerGui")
local h
__yisanbuy=false
__yisankill=false
__yisanloot=false
__optimizeGraphics=false
local e=workspace:WaitForChild("Entity")
local f=workspace:WaitForChild("FX")
local s=16
local j=50
local MAX_DAMAGE = (10^9) - 1
local d = MAX_DAMAGE
local H={}
local function hB(hide)local b={workspace:FindFirstChild("Buildings"),workspace:FindFirstChild("Map"),workspace:FindFirstChild("Environment"),workspace:FindFirstChild("Props"),workspace:FindFirstChild("Scenery"),workspace:FindFirstChild("Terrain")}for _,i in ipairs(b)do if i then for _,k in ipairs(i:GetDescendants())do if k:IsA("BasePart")and not k:IsDescendantOf(p.Character)then if hide then if k.Transparency~=1 then H[k]=k.Transparency k.Transparency=1 end else if H[k]then k.Transparency=H[k]end end end end end end end
local function wN()local c={workspace:FindFirstChild("Buildings"),workspace:FindFirstChild("Map"),workspace:FindFirstChild("Environment"),workspace:FindFirstChild("Props"),workspace:FindFirstChild("Scenery")}for _,n in ipairs(c)do if n then n.DescendantAdded:Connect(function(o)if __optimizeGraphics and o:IsA("BasePart")and not o:IsDescendantOf(p.Character)then if o.Transparency~=1 then H[o]=o.Transparency o.Transparency=1 end end end)end end end
local function uH()local a=p.Character if a then h=a:FindFirstChild("HumanoidRootPart")else h=nil end end
p.CharacterAdded:Connect(uH)uH()wN()
local Y={Main=X:Tab({Title="功能",Icon="swords",Opened=true}),Settings=X:Tab({Title="设置",Icon="settings",Opened=true})}
X:SelectTab(1)
local Z=Y.Main:Section({Title="功能"})
Z:Toggle({Title="全图杀戮",Value=false,Callback=function(v)__yisankill=v end})
Z:Toggle({Title="自动收集",Value=false,Callback=function(w)__yisanloot=w end})
Z:Toggle({Title="自动售卖",Value=false,Callback=function(x)__yisanbuy=x end})
local oF=L.FogEnd
local oG=L.GlobalShadows
Z:Toggle({Title="自动165帧",Value=false,Callback=function(y)__optimizeGraphics=y if y then L.GlobalShadows=false L.FogEnd=1 hB(true)game:GetService("StarterGui"):SetCore("SendNotification",{Title="自动165帧",Text="已除雾阴影和隐藏建筑",Duration=2})else L.GlobalShadows=oG L.FogEnd=oF hB(false)H={}game:GetService("StarterGui"):SetCore("SendNotification",{Title="自动165帧",Text="已恢复画质阴影建筑物）",Duration=2})end end})
local z=nil
local function sD()if z then return end z=task.spawn(function()while true do task.wait(0.5)local A=p.Character if A then local C=A:FindFirstChild("NetMessage") if C then local D=C:FindFirstChild("AddBuff") if D then D:FireServer(1005,{d}) end end end end end)end
local function tD()if z then task.cancel(z)z=nil end end
Z:Toggle({Title="神的伤害",Value=false,Callback=function(E)if E then local F=p.Character if not F then game:GetService("StarterGui"):SetCore("SendNotification",{Title="错误",Text="角色未加载，无法启动自动刷新",Duration=2})return end local G=F:FindFirstChild("NetMessage")if not G or not G:FindFirstChild("AddBuff")then game:GetService("StarterGui"):SetCore("SendNotification",{Title="错误",Text="未找到 AddBuff，可能游戏已更新",Duration=2})return end sD()game:GetService("StarterGui"):SetCore("SendNotification",{Title="伤害加成",Text="已开启自动刷新 (伤害值: "..MAX_DAMAGE.."%)",Duration=2})else tD()game:GetService("StarterGui"):SetCore("SendNotification",{Title="伤害加成",Text="已停止自动刷新",Duration=2})end end})
Z:Input({Title="伤害加成数值",Placeholder="输入数字 (最高 "..MAX_DAMAGE..")",Default=tostring(MAX_DAMAGE),Callback=function(I)local J=tonumber(I)if J and J>=0 then if J>MAX_DAMAGE then J=MAX_DAMAGE game:GetService("StarterGui"):SetCore("SendNotification",{Title="伤害设置",Text="已超过上限，自动调整为 "..MAX_DAMAGE, Duration=2})end d=math.floor(J)game:GetService("StarterGui"):SetCore("SendNotification",{Title="伤害设置",Text="伤害加成已设为 "..d.."%",Duration=2})else d=MAX_DAMAGE game:GetService("StarterGui"):SetCore("SendNotification",{Title="伤害设置",Text="无效输入，已重置为默认 "..MAX_DAMAGE, Duration=2})end end})
local K=Y.Settings:Section({Title="移动速度"})
K:Slider({Title="移动速度",Step=1,Value={Min=16,Max=500,Default=16},Callback=function(N)s=N end})
K:Slider({Title="跳跃高度",Step=1,Value={Min=50,Max=200,Default=50},Callback=function(Q)j=Q if p.Character then local S=p.Character:FindFirstChildOfClass("Humanoid")if S then S.JumpPower=Q end end end})
U.Heartbeat:Connect(function()if p.Character then local T1=p.Character:FindFirstChildOfClass("Humanoid")if T1 then T1.WalkSpeed=s T1.JumpPower=j end end end)
local net,set,trig
local function bN(U1)net=U1:WaitForChild("NetMessage")set=net:WaitForChild("SetState")trig=net:WaitForChild("TrigerSkill")end
if p.Character then bN(p.Character)end
p.CharacterAdded:Connect(bN)
local sw=R:WaitForChild("Model"):WaitForChild("Item"):WaitForChild("Weapon"):WaitForChild("Sword")
local st=R:WaitForChild("Model"):WaitForChild("Item"):WaitForChild("Weapon"):WaitForChild("Staff")
local cid=101
task.spawn(function()while true do pcall(function()local W1=p.PlayerGui.EquipPanel.Main.EquipInfo.Main.Page.PlayerEquip.Equipment_Slot.Slot2.Weapon.ItemInfo.ItemName.Text if sw:FindFirstChild(W1)then cid=101 elseif st:FindFirstChild(W1)then cid=103 end end)task.wait(1)end end)
local MB=100;local mB=1;local MF=12;local mF=1
local cb=38;local cf=6
local ft={};local HL=8;local ac=0
local TFI=1/45;local TFS=1/28
local ce={}
local function uEC()ce=e:GetChildren()end
e.ChildAdded:Connect(uEC)e.ChildRemoved:Connect(uEC)uEC()
local function gAFT()local _s=0 for _,t in ipairs(ft)do _s=_s+t end return _s/#ft end
local function aFT(dt)table.insert(ft,dt)if #ft>HL then table.remove(ft,1)end end
U.Heartbeat:Connect(function(dt)if not __yisankill then return end if not trig or not set then return end if #ce==0 then return end aFT(dt)ac=ac+1 if ac>=3 then ac=0 local avg=gAFT()if avg>TFS then cb=math.max(mB,cb-6)cf=math.max(mF,cf-1)elseif avg>TFI then cb=math.max(mB,cb-2)cf=math.max(mF,cf-0.5)else cb=math.min(MB,cb+5)cf=math.min(MF,cf+1.5)end cb=math.floor(cb)cf=math.floor(cf)cb=math.max(mB,math.floor(cb*0.65))cf=math.max(mF,math.floor(cf*0.65))cb=math.max(mB,math.floor(cb*0.85))cf=math.max(mF,math.floor(cf*0.85))local ec=#ce if ec>0 then local mfa=math.floor(35/ec)+1 cf=math.min(cf,mfa)end end if set then set:FireServer("action",true)end for _=1,cf do for _,ent in ipairs(ce)do local rp=ent:FindFirstChild("HumanoidRootPart")or ent.PrimaryPart if rp then trig:FireServer(cid,"Enter",rp.CFrame,cb)end end end if set then set:FireServer("action",false)end end)
task.spawn(function()while true do if __yisanloot then if h then for _,fx in ipairs(f:GetChildren())do pcall(function()if fx:IsA("BasePart")then fx.CFrame=h.CFrame elseif fx:IsA("Model")and fx.PrimaryPart then fx:SetPrimaryPartCFrame(h.CFrame)end end)end end end task.wait(0.5)end end)
local sr=R:WaitForChild("Remote"):WaitForChild("RemoteEvent")
local pay=table.create(100)for i=1,100 do pay[i]=i end
task.spawn(function()while true do if __yisanbuy then if set then set:FireServer("action",true)task.wait(0.05)set:FireServer("action",false)sr:FireServer(539767613,pay)end task.wait(2)else task.wait(1)end end end)