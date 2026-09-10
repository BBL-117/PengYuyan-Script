--[[
   ___ _         _       ___         _          _   _           __   ___    
  / __| |_  _ __| |___  | _ \_ _ ___| |_ ___ __| |_(_)___ _ _   \ \ / / |  
 | (__| | || / _` / -_) |  _/ '_/ _ \  _/ -_) _|  _| / _ \ ' \   \ V /| |    
  \___|_|\_, \__,_\___| |_| |_| \___/\__\___\__|\__|_\___/_||_|   \_/ |_|    
         |__/ 
 
  https://clydeprotectionde.cloud   
  build F5B3C4A8 
]]
local _genv=(type(getgenv)=="function" and getgenv())or(type(getfenv)=="function" and getfenv(0))or _G
local _env=setmetatable({print=print,warn=warn,error=error,assert=assert,type=type,typeof=typeof,tostring=tostring,tonumber=tonumber,pcall=pcall,xpcall=xpcall,select=select,unpack=unpack,pairs=pairs,ipairs=ipairs,next=next,rawget=rawget,rawset=rawset,rawequal=rawequal,rawlen=rawlen,setmetatable=setmetatable,getmetatable=getmetatable,string=string,table=table,math=math,bit32=bit32,coroutine=coroutine,os=os,debug=debug,utf8=utf8,buffer=buffer,game=game,workspace=workspace,script=script,Instance=Instance,Vector3=Vector3,Vector2=Vector2,CFrame=CFrame,Color3=Color3,BrickColor=BrickColor,UDim=UDim,UDim2=UDim2,Enum=Enum,Ray=Ray,Region3=Region3,Rect=Rect,TweenInfo=TweenInfo,NumberSequence=NumberSequence,ColorSequence=ColorSequence,NumberRange=NumberRange,Random=Random,DateTime=DateTime,RaycastParams=RaycastParams,OverlapParams=OverlapParams,tick=tick,time=time,wait=wait,task=task,spawn=spawn,delay=delay,require=require,loadstring=loadstring,load=load,getfenv=getfenv,setfenv=setfenv,newproxy=newproxy,_G=_G,shared=shared,settings=settings,stats=stats,UserSettings=UserSettings,version=version},{__index=function(_,k) local ok,v=pcall(function() return _genv[k] end)
if ok then return v end
return nil end})

local function _run(K,code,_env,protos,initLocals,upvalues,varargs)
protos=protos or {}
upvalues=upvalues or {}
varargs=varargs or {}
local varargCount=varargs.n or #varargs
local function resolveK(_idx) return K[_idx] end
local stack={}
local locals={}
local callBases={}
local stackTop=0
local localBoxes={}
local ip=1
local callBaseTop=0
local _doReturn=false
local _retFromStack=false
local _retBase=0
local _retTop=0
local _retN=0
local _retPack=nil
local ctxBit=0
if initLocals then for _k=0,(initLocals.n or 0)-1 do locals[_k]=initLocals[_k] end end
local function push(v) stackTop=stackTop+1
stack[stackTop]=v end
local function pop() local v=stack[stackTop]
stack[stackTop]=nil
stackTop=stackTop-1
return v end
local function top() return stack[stackTop] end
local function getLocal(slot) local box=localBoxes[slot]
if box then return box[1] end
return locals[slot] end
local function setLocal(slot,val) local box=localBoxes[slot]
if box then box[1]=val else locals[slot]=val end end
local function boxLocal(slot) if not localBoxes[slot] then localBoxes[slot]={locals[slot]} end
return localBoxes[slot] end
local function getMM(obj,name) local ok,mt=pcall(getmetatable,obj)
if ok and mt and type(mt)=="table" then return rawget(mt,name) end
return nil end
local function arithMM(a,b,op,name) if type(a)=="number" and type(b)=="number" then return op(a,b) end
local ok,r=pcall(op,a,b)
if ok then return r end
local mm=getMM(a,name) or getMM(b,name)
if mm then return mm(a,b) end
return op(a,b) end
local handlers={}
handlers[0]=function() end
handlers[1]=function() push(nil) end
handlers[2]=function() push(true) end
handlers[3]=function() push(false) end
handlers[4]=function() push(resolveK(code[ip]+1))
ip=ip+1 end
handlers[5]=function() push(getLocal(code[ip]))
ip=ip+1 end
handlers[6]=function() setLocal(code[ip],pop())
ip=ip+1 end
handlers[7]=function() push(_env[resolveK(code[ip]+1)])
ip=ip+1 end
handlers[8]=function() _env[resolveK(code[ip]+1)]=pop()
ip=ip+1 end
handlers[9]=function() local b,a=pop(),pop()
push(arithMM(a,b,function(x,y) return x+y end,"__add")) end
handlers[10]=function() local b,a=pop(),pop()
push(arithMM(a,b,function(x,y) return x-y end,"__sub")) end
handlers[11]=function() local b,a=pop(),pop()
push(arithMM(a,b,function(x,y) return x*y end,"__mul")) end
handlers[12]=function() local b,a=pop(),pop()
push(arithMM(a,b,function(x,y) return x/y end,"__div")) end
handlers[13]=function() local b,a=pop(),pop()
push(arithMM(a,b,function(x,y) return x%y end,"__mod")) end
handlers[14]=function() local b,a=pop(),pop()
push(arithMM(a,b,function(x,y) return x^y end,"__pow")) end
handlers[15]=function() local b,a=pop(),pop()
local ok,r=pcall(function() return a..b end)
if ok then push(r) else push(tostring(a)..tostring(b)) end end
handlers[16]=function() local b,a=pop(),pop()
push(a==b) end
handlers[17]=function() local b,a=pop(),pop()
push(a~=b) end
handlers[18]=function() local b,a=pop(),pop()
push(a<b) end
handlers[19]=function() local b,a=pop(),pop()
push(a<=b) end
handlers[20]=function() local b,a=pop(),pop()
push(a>b) end
handlers[21]=function() local b,a=pop(),pop()
push(a>=b) end
handlers[22]=function() local b,a=pop(),pop()
push(a and b) end
handlers[23]=function() local b,a=pop(),pop()
push(a or b) end
handlers[24]=function() push(not pop()) end
handlers[25]=function() push(-pop()) end
handlers[26]=function() push(#pop()) end
handlers[27]=function() push({}) end
handlers[28]=function() local k,t=pop(),pop()
push(t[k]) end
handlers[29]=function() local v,k,t=pop(),pop(),pop()
t[k]=v end
handlers[30]=function() local n=code[ip]
ip=ip+1
local args={}
for i=1,n do args[n-i+1]=pop() end
local f=pop()
if type(f)~="function" then local mm=getMM(f,"__call")
if mm then table.insert(args,1,f)
n=n+1
f=mm else error("attempt to call a "..type(f).." value") end end
local r
if n==0 then r={f()} else r={f(table.unpack(args,1,n))} end
push(r[1]) end
handlers[31]=function() local n=code[ip]
ip=ip+1
_doReturn=true
if n==0 then _retN=0 elseif n>0 then if n>stackTop then n=stackTop end
_retN=n
_retFromStack=true
_retTop=stackTop
_retBase=stackTop-n else _retN=stackTop
_retFromStack=true
_retTop=stackTop
_retBase=0 end end
handlers[32]=function() ip=code[ip]+1 end
handlers[33]=function() local target=code[ip]
ip=ip+1
if not pop() then ip=target+1 end end
handlers[34]=function() local n=code[ip]
ip=ip+1
for _=1,n do pop() end end
handlers[35]=function() local pi=code[ip]
ip=ip+1
local P=protos[pi]
if P then
local _r,Kp,Cp=_run,P.K or K,P.C or {}
local nU={}
if P.U then for ui,ud in ipairs(P.U) do local iL,idx=ud[1],ud[2]
if iL==1 then nU[ui]=boxLocal(idx) else nU[ui]=upvalues[idx+1] end end end
local nP=P.nParams or 0
push(function(...)
local a={...}
local ac=select("#",...)
local L={}
L.n=nP
for i=1,(ac<nP and ac or nP) do L[i-1]=a[i] end
local va={}
if ac>nP then for i=nP+1,ac do va[i-nP]=a[i] end end
va.n=ac-nP
return _r(Kp,Cp,_env,P.P or {},L,nU,va)
end)
else push(nil) end end
handlers[36]=function() push(top()) end
handlers[37]=function() local ui=code[ip]
ip=ip+1
local box=upvalues[ui+1]
push(box and box[1] or nil) end
handlers[38]=function() local ui=code[ip]
ip=ip+1
local box=upvalues[ui+1]
if box then box[1]=pop() else pop() end end
handlers[39]=function() local na=code[ip]
ip=ip+1
local nr=code[ip]
ip=ip+1
local args={}
for i=1,na do args[na-i+1]=pop() end
local f=pop()
if type(f)~="function" then local mm=getMM(f,"__call")
if mm then table.insert(args,1,f)
na=na+1
f=mm else error("attempt to call a "..type(f).." value") end end
local r
if na==0 then r=table.pack(f()) else r=table.pack(f(table.unpack(args,1,na))) end
local rn=nr<0 and r.n or nr
for i=1,rn do push(r[i]) end end
handlers[40]=function() local n=code[ip]
ip=ip+1
if n<0 then for i=1,varargCount do push(varargs[i]) end else for i=1,n do push(varargs[i]) end end end
handlers[41]=function() local n=code[ip]
ip=ip+1
local args={}
for j=n,1,-1 do args[j]=pop() end
local f=pop()
if type(f)~="function" then local mm=getMM(f,"__call")
if mm then table.insert(args,1,f)
n=n+1
f=mm end end
_doReturn=true
_retPack=table.pack(f(table.unpack(args,1,n))) end
handlers[42]=function() local off=code[ip]
ip=ip+1
local step=pop()
local limit=pop()
local init=pop()
push(init)
push(limit)
push(step)
if step>=0 then if init>limit then ip=off+1 end else if init<limit then ip=off+1 end end end
handlers[43]=function() local off=code[ip]
ip=ip+1
local step=stack[stackTop]
local i=stack[stackTop-2]+step
stack[stackTop-2]=i
local limit=stack[stackTop-1]
if step>=0 then if i<=limit then ip=off+1 end else if i>=limit then ip=off+1 end end end
handlers[44]=function() local n=code[ip]
ip=ip+1
local parts={}
for i=1,n do parts[n-i+1]=tostring(pop()) end
push(table.concat(parts)) end
handlers[45]=function() local n=code[ip]
ip=ip+1
for _=1,n do push(nil) end end
handlers[46]=function() callBaseTop=callBaseTop+1
callBases[callBaseTop]=stackTop end
handlers[47]=function() local nr=code[ip]
ip=ip+1
local base=callBases[callBaseTop]
callBaseTop=callBaseTop-1
local f=stack[base+1]
local na=stackTop-base-1
local args={}
for i=1,na do args[i]=stack[base+1+i] end
stackTop=base
if type(f)~="function" then local mm=getMM(f,"__call")
if mm then table.insert(args,1,f)
na=na+1
f=mm else error("attempt to call a "..type(f).." value") end end
local r
if na==0 then r=table.pack(f()) else r=table.pack(f(table.unpack(args,1,na))) end
local rn=nr<0 and r.n or nr
for i=1,rn do push(r[i]) end end
handlers[48]=function() local b,a=pop(),pop()
push(arithMM(a,b,function(x,y) return math.floor(x/y) end,"__idiv")) end
handlers[49]=function() local slot=code[ip]
ip=ip+1
local box=localBoxes[slot]
if box then locals[slot]=box[1]
localBoxes[slot]=nil end end
handlers[50]=function() local startIdx=code[ip]
ip=ip+1
local base=callBases[callBaseTop]
callBaseTop=callBaseTop-1
local tbl=stack[base]
local idx=startIdx
for i=base+1,stackTop do tbl[idx]=stack[i]
idx=idx+1 end
stackTop=base
stack[stackTop]=tbl end
handlers[51]=function() local a=stack[stackTop]
stack[stackTop]=stack[stackTop-1]
stack[stackTop-1]=a end
handlers[52]=function() local nameIdx=code[ip]
ip=ip+1
local methodName=resolveK(nameIdx+1)
local obj=pop()
local method=obj[methodName]
push(obj)
push(method)
local b,a=pop(),pop()
push(b)
push(a) end
handlers[53]=function() local nVars=code[ip]
ip=ip+1
local target=code[ip]
ip=ip+1
local iter=stack[stackTop-2]
local state=stack[stackTop-1]
local ctl=stack[stackTop]
local r={iter(state,ctl)}
for i=1,nVars do push(r[i]) end
if r[1]~=nil then stack[stackTop-nVars]= r[1] else ip=target+1 end end
handlers[54]=function() local n=code[ip]
ip=ip+1
local args={}
for i=1,n do args[n-i+1]=pop() end
local f=pop()
local results
if n==0 then results=table.pack(pcall(f)) else results=table.pack(pcall(f,table.unpack(args,1,n))) end
local ok=results[1]
push(ok)
if ok then for i=2,results.n do push(results[i]) end else push(results[2]) end end
handlers[55]=function() local n=code[ip]
ip=ip+1
local args={}
for i=1,n do args[n-i+1]=pop() end
local handler=pop()
local f=pop()
local results
if n==0 then results=table.pack(xpcall(f,handler)) else results=table.pack(xpcall(f,handler,table.unpack(args,1,n))) end
local ok=results[1]
push(ok)
for i=2,results.n do push(results[i]) end end
handlers[56]=function() local iS=code[ip]
ip=ip+1
local sS=code[ip]
ip=ip+1
local vS=code[ip]
ip=ip+1
local it=getLocal(iS)
if type(it)=="table" then local ok2,mt=pcall(getmetatable,it)
if ok2 and type(mt)=="table" and mt.__iter then local fn=mt.__iter(it)
setLocal(iS,fn) elseif ok2 and type(mt)=="table" and mt.__call then else setLocal(iS,next)
setLocal(sS,it)
setLocal(vS,nil) end end end
handlers[57]=function() local a=code[ip]
ip=ip+1
local b=code[ip]
ip=ip+1
local c=code[ip]
ip=ip+1
setLocal(c,getLocal(a)+getLocal(b)) end
handlers[58]=function() local a=code[ip]
ip=ip+1
local b=code[ip]
ip=ip+1
local c=code[ip]
ip=ip+1
setLocal(c,getLocal(a)-getLocal(b)) end
handlers[59]=function() local a=code[ip]
ip=ip+1
local b=code[ip]
ip=ip+1
local c=code[ip]
ip=ip+1
setLocal(c,getLocal(a)*getLocal(b)) end
handlers[60]=function() local k=code[ip]
ip=ip+1
local s=code[ip]
ip=ip+1
setLocal(s,resolveK(k+1)) end
handlers[61]=function() local a=code[ip]
ip=ip+1
local b=code[ip]
ip=ip+1
setLocal(b,getLocal(a)) end
handlers[62]=function() local a=code[ip]
ip=ip+1
local k=code[ip]
ip=ip+1
local c=code[ip]
ip=ip+1
setLocal(c,getLocal(a)+resolveK(k+1)) end
handlers[63]=function() local a=code[ip]
ip=ip+1
local b=code[ip]
ip=ip+1
local c=code[ip]
ip=ip+1
setLocal(c,getLocal(a)..getLocal(b)) end
handlers[64]=function() local _=stackTop end
handlers[65]=function() local _a=code[ip]
ip=ip+1
local _=stack[_a] or 0 end
handlers[66]=function() local _a=code[ip]
ip=ip+1
local _b=code[ip]
ip=ip+1
local _=bit32.bxor(_a,_b) end
handlers[67]=function() local _a=code[ip]
ip=ip+1
if ctxBit==0 then push(getLocal(_a)) else push(resolveK(_a+1)) end end
while true do
if _doReturn or ip>#code then break end
local op=code[ip]
ip=ip+1
local h=handlers[op]
if h then h() end
end
if _doReturn then
if _retPack then return table.unpack(_retPack,1,_retPack.n or #_retPack) end
if _retFromStack then
if _retN==0 then return end
return table.unpack(stack,_retBase+1,_retTop)
end
return
end
return nil
end
local _O0O4={{K={"UIElements","Main",1,2,"FindFirstChild","RainbowStroke",15,225,"Destroy",100,7,"FindFirstChildOfClass","UICorner","Instance","new","CornerRadius","UDim",0,16,"Parent","UIStroke","Name","Thickness",1.5,"Transparency",0.15,"Color","Color3","ApplyStrokeMode","Enum","Border","LineJoinMode","Round","UIGradient","GlowEffect","Fallen Purple","Rotation","OuterGlow",8,0.85,"fromHex","7C3AED"},C={5,0,4,0,28,4,1,28,6,2,4,2,4,2,9,4,3,16,36,33,26,34,1,5,2,24,33,33,1,31,1,32,33,5,2,36,4,4,28,51,4,5,30,2,6,3,4,6,4,6,11,4,7,16,36,33,61,34,1,5,3,33,76,5,3,36,4,8,28,51,30,1,34,1,32,76,4,9,4,10,13,4,3,16,36,33,101,34,1,5,2,36,4,11,28,51,4,12,30,2,24,33,139,7,13,4,14,28,4,12,30,1,6,4,5,4,4,15,7,16,4,14,28,4,17,4,18,30,2,29,5,4,4,19,5,2,29,32,139,7,13,4,14,28,4,20,30,1,6,5,5,5,4,21,4,5,29,5,5,4,22,4,23,29,5,5,4,24,4,25,29,5,5,4,26,7,27,4,14,28,4,2,4,2,4,2,30,3,29,5,5,4,28,7,29,4,28,28,4,30,28,29,5,5,4,31,7,29,4,31,28,4,32,28,29,5,5,4,19,5,2,29,7,13,4,14,28,4,33,30,1,6,6,5,6,4,21,4,34,29,37,0,5,1,36,24,33,252,34,1,4,35,28,6,7,5,6,4,26,5,7,36,33,271,34,1,5,7,4,2,28,36,24,33,285,34,1,37,0,4,35,28,4,2,28,29,5,6,4,36,4,17,29,5,6,4,19,5,5,29,7,13,4,14,28,4,20,30,1,6,8,5,8,4,21,4,37,29,5,8,4,22,4,38,29,5,8,4,24,4,39,29,5,8,4,26,7,27,4,40,28,4,41,30,1,29,5,8,4,28,7,29,4,28,28,4,30,28,29,5,8,4,19,5,2,29,5,5,31,1},P={},U={{1,2}},nParams=2},{K={"UIElements","Main",12,144,"FindFirstChild","RainbowStroke",3,2,9,"GlowEffect",7,49,"game","GetService","RunService","Heartbeat","Connect"},C={5,0,4,0,28,4,1,28,6,2,4,2,4,2,11,4,3,16,36,33,26,34,1,5,2,24,33,33,1,31,1,32,33,5,2,36,4,4,28,51,4,5,30,2,6,3,4,6,4,7,14,4,8,16,36,33,62,34,1,5,3,24,33,69,1,31,1,32,69,5,3,36,4,4,28,51,4,9,30,2,6,4,4,10,4,10,11,4,11,16,36,33,98,34,1,5,4,24,33,105,1,31,1,32,105,7,12,36,4,13,28,51,4,14,30,2,4,15,28,36,4,16,28,51,35,1,39,2,-1,31,-1},P={{K={1,2,"Parent","Rotation","tick",10,360},C={4,0,4,0,9,4,1,16,36,33,29,34,1,37,0,24,36,24,33,29,34,1,37,0,4,2,28,1,16,33,35,31,0,32,35,37,1,4,3,7,4,30,0,37,2,11,4,5,11,4,6,13,29,31,0},P={},U={{1,3},{1,4},{1,1}},nParams=0}},U=nil,nParams=2},{K={12,144,"task","wait",0.1,"UIElements","Main","Visible",3,2,9,"Create","TweenInfo","new",0.3,"Size",20,0,"Play"},C={3,6,0,4,0,4,0,11,4,1,16,36,33,17,34,1,2,33,154,7,2,4,3,28,4,4,30,1,34,1,37,0,4,5,28,36,33,48,34,1,37,0,4,5,28,4,6,28,6,1,5,1,36,33,62,34,1,5,1,4,7,28,36,24,33,69,34,1,3,6,2,4,8,4,9,14,4,10,16,36,33,89,34,1,5,2,5,0,17,33,148,5,2,6,0,37,1,36,4,11,28,51,37,2,7,12,4,13,28,4,14,30,1,27,36,4,15,5,2,36,33,126,34,1,4,16,36,24,33,134,34,1,4,17,29,30,4,36,4,18,28,51,30,1,34,1,32,148,49,1,49,2,32,3,31,0},P={},U={{1,1},{1,9},{1,10}},nParams=0},{K={7,49,1,2,"coroutine","close","create","resume"},C={5,0,38,0,4,0,4,0,11,4,1,16,36,33,19,34,1,37,0,33,79,4,2,4,2,9,4,3,16,36,33,36,34,1,37,1,33,54,7,4,4,5,28,37,1,30,1,34,1,1,38,1,32,54,7,4,4,6,28,35,1,39,1,1,38,1,7,4,4,7,28,37,1,30,1,34,1,32,112,4,0,4,0,11,4,1,16,36,33,94,34,1,37,1,33,112,7,4,4,5,28,37,1,30,1,34,1,1,38,1,32,112,31,0},P={{K={15,225,"ipairs","GetPlayers",100,7,2,"LocalPlayer","Parent","Character",12,144,"workspace","FindFirstChildOfClass","Humanoid",3,9,"Health",0,"pcall","task","wait",0.1},C={4,0,4,0,11,4,1,16,36,33,15,34,1,37,0,33,229,46,7,2,37,1,36,4,3,28,51,39,1,-1,47,3,6,2,6,1,6,0,56,0,1,2,49,3,49,4,5,0,5,1,5,2,39,2,2,6,4,6,3,5,3,6,2,5,3,1,17,33,202,4,4,4,5,13,4,6,16,36,33,100,34,1,5,4,37,1,4,7,28,17,36,33,100,34,1,5,4,4,8,28,33,196,5,4,4,9,28,6,5,4,10,4,10,11,4,11,16,36,33,137,34,1,5,5,36,33,137,34,1,5,5,4,8,28,7,12,16,33,194,5,5,36,4,13,28,51,4,14,30,2,6,6,4,15,4,6,14,4,16,16,36,33,180,34,1,5,6,36,33,180,34,1,5,6,4,17,28,4,18,20,33,192,7,19,35,1,30,1,34,1,32,192,32,194,32,196,49,5,49,6,32,42,7,20,4,21,28,4,22,30,1,34,1,49,0,49,1,49,2,49,3,49,4,49,5,49,6,32,0,31,0},P={{K={"FireServer"},C={37,0,36,4,0,28,51,37,1,30,2,34,1,31,0},P={},U={{0,2},{1,5}},nParams=0}},U={{0,0},{0,2},{0,3}},nParams=0}},U={{1,16},{1,17},{1,11},{1,13}},nParams=1},{K={1,2,15,225,"coroutine","close","create","resume",12,144,"pcall"},C={5,0,38,0,4,0,4,0,9,4,1,16,36,33,19,34,1,37,0,33,79,4,2,4,2,11,4,3,16,36,33,36,34,1,37,1,33,54,7,4,4,5,28,37,1,30,1,34,1,1,38,1,32,54,7,4,4,6,28,35,1,39,1,1,38,1,7,4,4,7,28,37,1,30,1,34,1,32,120,4,8,4,8,11,4,9,16,36,33,94,34,1,37,1,33,112,7,4,4,5,28,37,1,30,1,34,1,1,38,1,32,112,7,10,35,2,30,1,34,1,31,0},P={{K={100,7,2,"task","wait",0.1,"pcall"},C={4,0,4,1,13,4,2,16,36,33,29,34,1,7,3,4,4,28,4,5,30,1,36,33,29,34,1,37,0,33,41,7,6,35,1,30,1,34,1,32,0,31,0},P={{K={"FireServer"},C={37,0,36,4,0,28,51,2,30,2,34,1,31,0},P={},U={{0,1}},nParams=0}},U={{0,0},{0,2}},nParams=0},{K={"FireServer"},C={37,0,36,4,0,28,51,3,30,2,34,1,31,0},P={},U={{0,2}},nParams=0}},U={{1,19},{1,20},{1,14}},nParams=1},{K={"game","GetService","RunService","Heartbeat","Wait"},C={7,0,36,4,1,28,51,4,2,30,2,4,3,28,36,4,4,28,51,30,1,34,1,31,0},P={},U=nil,nParams=0}}
local _I_O2={"loadstring","game","HttpGet","https://raw.githubusercontent.com/Yisan886/Aero/refs/heads/main/ui.lua.txt","AddTheme","Name","Fallen Aero","Accent","Color3","fromHex","#7C3AED","Background","#09090B","Outline","#4C1D95","Text","#FFFFFF","Placeholder","#71717A","Button","#1E1B4B","Icon","#A78BFA","CreateWindow","Title","Aero      ","Folder","Aero","SideBarWidth",180,"https://chaton-images.s3.us-east-2.amazonaws.com/alHcHts2JjSlmMRKjQeDXFipKS5LjNhrKrkN8TxbH7HgPmXA1QbuEYZh3Hwnb9F5_1536x1024x1945789.png","BackgroundImageTransparency",0.35,"OpenButton","\231\131\173\232\161\128\233\171\152\230\160\161 \232\128\129\232\130\175","CornerRadius","UDim","new",1,0,"StrokeThickness",3,"Enabled","Draggable","OnlyMobile","Scale",0.9,"Color","ColorSequence","ColorSequenceKeypoint","6D28D9","A855F7","Topbar","Height",44,"ButtonsType","Mac","Tag","V1.00","00CED1","Radius",2,"Yisan","crown","FFD700","\232\128\129\232\130\175","square-chevron-right","#30ff6a","Fallen Purple","2E1065",0.3,"4C1D95",0.6,"7C3AED","C084FC","waves",5,15,225,"GetService","Lighting","TweenService","FindFirstChildOfClass","BlurEffect",100,7,"Instance","Size","Parent","task","spawn","Players","ReplicatedStorage","WaitForChild","DealDamageEvent","PunchStateEvent","Tab","\229\135\187\230\137\147\229\138\159\232\131\189","sparkles","Locked","Toggle","\232\140\131\229\155\180\230\148\187\229\135\187","Desc","\230\148\187\229\135\187\229\136\176\229\147\170\228\184\170\229\176\177\232\135\170\229\138\168\230\137\147\229\147\170\228\184\170","Type","Checkbox","Value","Callback","\229\146\143\230\152\165","\229\133\182\229\174\158\229\176\177\230\152\175\232\135\170\229\138\168\230\137\147\231\142\187\231\146\131"}
local _I_03={46,7,0,7,1,36,4,2,28,51,4,3,39,2,-1,47,1,30,0,6,0,5,0,36,4,4,28,51,27,36,4,5,4,6,29,36,4,7,7,8,4,9,28,4,10,30,1,29,36,4,11,7,8,4,9,28,4,12,30,1,29,36,4,13,7,8,4,9,28,4,14,30,1,29,36,4,15,7,8,4,9,28,4,16,30,1,29,36,4,17,7,8,4,9,28,4,18,30,1,29,36,4,19,7,8,4,9,28,4,20,30,1,29,36,4,21,7,8,4,9,28,4,22,30,1,29,30,2,34,1,5,0,36,4,23,28,51,27,36,4,24,4,25,29,36,4,26,4,27,29,36,4,28,4,29,29,36,4,11,4,30,29,36,4,31,4,32,29,36,4,33,27,36,4,24,4,34,29,36,4,35,7,36,4,37,28,4,38,4,39,30,2,29,36,4,40,4,41,29,36,4,42,2,29,36,4,43,2,29,36,4,44,3,29,36,4,45,4,46,29,36,4,47,7,48,4,37,28,27,36,4,38,46,7,49,4,37,28,4,39,7,8,4,9,28,4,50,39,1,-1,47,1,29,46,46,7,49,4,37,28,4,38,7,8,4,9,28,4,51,39,1,-1,47,-1,50,2,30,1,29,29,36,4,52,27,36,4,53,4,54,29,36,4,55,4,56,29,29,30,2,6,1,5,1,36,4,57,28,51,27,36,4,24,4,58,29,36,4,47,7,8,4,9,28,4,59,30,1,29,36,4,60,4,61,29,30,2,34,1,5,1,36,4,57,28,51,27,36,4,24,4,62,29,36,4,21,4,63,29,36,4,47,7,8,4,9,28,4,64,30,1,29,36,4,60,4,61,29,30,2,34,1,5,1,36,4,57,28,51,27,36,4,24,4,65,29,36,4,21,4,66,29,36,4,47,7,8,4,9,28,4,67,30,1,29,36,4,60,4,61,29,30,2,34,1,27,36,4,68,27,36,4,38,7,48,4,37,28,27,36,4,38,46,7,49,4,37,28,4,39,7,8,4,9,28,4,69,39,1,-1,47,1,29,36,4,61,46,7,49,4,37,28,4,70,7,8,4,9,28,4,71,39,1,-1,47,1,29,36,4,41,46,7,49,4,37,28,4,72,7,8,4,9,28,4,73,39,1,-1,47,1,29,46,46,7,49,4,37,28,4,38,7,8,4,9,28,4,74,39,1,-1,47,-1,50,4,30,1,29,36,4,61,4,75,29,29,6,2,1,6,3,4,76,6,4,35,1,6,5,35,2,6,6,5,5,5,1,4,68,30,2,6,7,4,77,4,77,11,4,78,16,36,33,585,34,1,5,7,33,600,5,6,5,1,5,4,39,2,1,6,3,32,600,7,1,36,4,79,28,51,4,80,30,2,6,8,7,1,36,4,79,28,51,4,81,30,2,6,9,5,8,36,4,82,28,51,4,83,30,2,6,10,4,84,4,85,13,4,61,16,36,33,655,34,1,5,10,24,33,685,7,86,4,37,28,4,83,39,1,1,6,10,5,10,4,87,4,39,29,5,10,4,88,5,8,29,32,685,7,89,4,90,28,35,3,30,1,34,1,7,1,36,4,79,28,51,4,91,30,2,6,11,7,1,36,4,79,28,51,4,92,30,2,6,12,5,12,36,4,93,28,51,4,94,30,2,6,13,5,12,36,4,93,28,51,4,95,30,2,6,14,5,1,36,4,96,28,51,27,36,4,24,4,97,29,36,4,21,4,98,29,36,4,99,3,29,30,2,6,15,3,6,16,1,6,17,5,15,36,4,100,28,51,27,36,4,24,4,101,29,36,4,102,4,103,29,36,4,104,4,105,29,36,4,106,3,29,36,4,107,35,4,29,30,2,6,18,3,6,19,1,6,20,5,15,36,4,100,28,51,27,36,4,24,4,108,29,36,4,102,4,109,29,36,4,104,4,105,29,36,4,106,3,29,36,4,107,35,5,29,30,2,6,21,7,89,4,90,28,35,6,30,1,34,1,31,0}
return _run(_I_O2,_I_03,_env,_O0O4)
