--[[
   ___ _         _       ___         _          _   _           __   ___  
  / __| |_  _ __| |___  | _ \_ _ ___| |_ ___ __| |_(_)___ _ _   \ \ / / | 
 | (__| | || / _` / -_) |  _/ '_/ _ \  _/ -_) _|  _| / _ \ ' \   \ V /| |   
  \___|_|\_, \__,_\___| |_| |_| \___/\__\___\__|\__|_\___/_||_|   \_/ |_| 
         |__/ 
   
  https://clydeprotectionde.cloud  
  build 54E8C214 
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
local _OIO2={"loadstring","game","HttpGet",1,50,2,46,3,4,42,5,41,6,96,7,117,8,9,40,10,59,11,45,12,116,13,61,14,51,15,16,17,47,18,56,19,20,21,63,22,23,57,24,53,25,52,26,27,28,29,30,31,32,33,55,34,35,36,37,38,39,98,108,43,44,48,49,60,54,62,58,64,65,66,67,68,69,70,71,72,73,74,90,"AddTheme","Name",122,"Accent","Color3","fromHex",121,109,105,"Background",106,99,"Outline",110,107,111,"Text","Placeholder","Button","Icon","CreateWindow","Title","Folder","SideBarWidth",180,119,104,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,91,92,93,94,95,97,100,101,102,103,0,112,113,114,115,118,120,123,124,125,126,127,128,129,130,131,132,133,134,135,"BackgroundImageTransparency",0.35,"OpenButton",28855,34842,39554,26747,32859,33013,"CornerRadius","UDim","new","StrokeThickness","Enabled","Draggable","OnlyMobile","Scale",0.9,"Color","ColorSequence","ColorSequenceKeypoint","Topbar","Height","ButtonsType","Tag","Radius",0.3,0.6,"GetService","FindFirstChildOfClass",144,"Instance","Size","Parent","task","spawn","WaitForChild","Tab",20897,25097,21189,32935,"Locked","Toggle",33625,22190,25953,"Desc",21098,21680,20080,23659,33200,21234,"Type","Value","Callback",21717,26239,20780,23492,26229,29665,29913}
local _II13={27,6,0,35,1,6,1,46,7,0,46,7,1,36,4,2,28,51,5,1,27,36,4,3,4,4,29,36,4,5,4,6,29,36,4,7,4,6,29,36,4,8,4,9,29,36,4,10,4,11,29,36,4,12,4,13,29,36,4,14,4,15,29,36,4,16,4,15,29,36,4,17,4,18,29,36,4,19,4,20,29,36,4,21,4,22,29,36,4,23,4,24,29,36,4,25,4,26,29,36,4,27,4,28,29,36,4,29,4,6,29,36,4,30,4,4,29,36,4,31,4,32,29,36,4,33,4,34,29,36,4,35,4,32,29,36,4,36,4,11,29,36,4,37,4,38,29,36,4,39,4,18,29,36,4,40,4,41,29,36,4,42,4,43,29,36,4,44,4,45,29,36,4,46,4,6,29,36,4,47,4,38,29,36,4,48,4,45,29,36,4,49,4,6,29,36,4,50,4,24,29,36,4,51,4,41,29,36,4,52,4,43,29,36,4,53,4,54,29,36,4,55,4,15,29,36,4,56,4,7,29,36,4,57,4,28,29,36,4,58,4,11,29,36,4,59,4,20,29,36,4,60,4,45,29,36,4,18,4,61,29,36,4,11,4,61,29,36,4,9,4,62,29,36,4,63,4,15,29,36,4,64,4,47,29,36,4,22,4,38,29,36,4,6,4,18,29,36,4,32,4,43,29,36,4,65,4,15,29,36,4,66,4,18,29,36,4,4,4,38,29,36,4,28,4,67,29,36,4,45,4,11,29,36,4,43,4,15,29,36,4,68,4,4,29,36,4,54,4,38,29,36,4,34,4,20,29,36,4,41,4,69,29,36,4,70,4,11,29,36,4,20,4,15,29,36,4,67,4,54,29,36,4,26,4,20,29,36,4,69,4,28,29,36,4,38,4,45,29,36,4,71,4,15,29,36,4,72,4,32,29,36,4,73,4,28,29,36,4,74,4,24,29,36,4,75,4,68,29,36,4,76,4,32,29,36,4,77,4,20,29,36,4,78,4,24,29,36,4,79,4,6,29,36,4,80,4,55,29,36,4,81,4,6,29,4,82,39,2,-1,47,-1,47,1,30,0,6,2,5,2,36,4,83,28,51,27,36,4,84,5,1,27,36,4,3,4,48,29,36,4,5,4,20,29,36,4,7,4,68,29,36,4,8,4,68,29,36,4,10,4,38,29,36,4,12,4,45,29,36,4,14,4,85,29,36,4,16,4,47,29,36,4,17,4,38,29,36,4,19,4,18,29,36,4,21,4,43,29,4,82,30,2,29,36,4,86,46,7,87,4,88,28,5,1,27,36,4,3,4,89,29,36,4,5,4,90,29,36,4,7,4,44,29,36,4,8,4,91,29,36,4,10,4,47,29,36,4,12,4,51,29,36,4,14,4,50,29,4,82,39,2,-1,47,1,29,36,4,92,46,7,87,4,88,28,5,1,27,36,4,3,4,89,29,36,4,5,4,93,29,36,4,7,4,94,29,36,4,8,4,93,29,36,4,10,4,94,29,36,4,12,4,93,29,36,4,14,4,42,29,4,82,39,2,-1,47,1,29,36,4,95,46,7,87,4,88,28,5,1,27,36,4,3,4,89,29,36,4,5,4,96,29,36,4,7,4,44,29,36,4,8,4,97,29,36,4,10,4,50,29,36,4,12,4,94,29,36,4,14,4,98,29,4,82,39,2,-1,47,1,29,36,4,99,46,7,87,4,88,28,5,1,27,36,4,3,4,89,29,36,4,5,4,48,29,36,4,7,4,48,29,36,4,8,4,48,29,36,4,10,4,48,29,36,4,12,4,48,29,36,4,14,4,48,29,4,82,39,2,-1,47,1,29,36,4,100,46,7,87,4,88,28,5,1,27,36,4,3,4,89,29,36,4,5,4,90,29,36,4,7,4,97,29,36,4,8,4,90,29,36,4,10,4,97,29,36,4,12,4,90,29,36,4,14,4,47,29,4,82,39,2,-1,47,1,29,36,4,101,46,7,87,4,88,28,5,1,27,36,4,3,4,89,29,36,4,5,4,97,29,36,4,7,4,51,29,36,4,8,4,97,29,36,4,10,4,42,29,36,4,12,4,96,29,36,4,14,4,42,29,4,82,39,2,-1,47,1,29,36,4,102,46,7,87,4,88,28,5,1,27,36,4,3,4,89,29,36,4,5,4,47,29,36,4,7,4,90,29,36,4,8,4,61,29,36,4,10,4,42,29,36,4,12,4,48,29,36,4,14,4,47,29,4,82,39,2,-1,47,1,29,30,2,34,1,5,2,36,4,103,28,51,27,36,4,104,5,1,27,36,4,3,4,47,29,36,4,5,4,38,29,36,4,7,4,18,29,36,4,8,4,43,29,36,4,10,4,85,29,36,4,12,4,85,29,36,4,14,4,85,29,36,4,16,4,85,29,36,4,17,4,85,29,36,4,19,4,85,29,4,82,30,2,29,36,4,105,5,1,27,36,4,3,4,47,29,36,4,5,4,38,29,36,4,7,4,18,29,36,4,8,4,43,29,4,82,30,2,29,36,4,106,4,107,29,36,4,92,5,1,27,36,4,3,4,4,29,36,4,5,4,6,29,36,4,7,4,6,29,36,4,8,4,9,29,36,4,10,4,11,29,36,4,12,4,13,29,36,4,14,4,15,29,36,4,16,4,15,29,36,4,17,4,41,29,36,4,19,4,4,29,36,4,21,4,20,29,36,4,23,4,6,29,36,4,25,4,43,29,36,4,27,4,45,29,36,4,29,4,108,29,36,4,30,4,28,29,36,4,31,4,54,29,36,4,33,4,20,29,36,4,35,4,26,29,36,4,36,4,38,29,36,4,37,4,11,29,36,4,39,4,24,29,36,4,40,4,11,29,36,4,42,4,91,29,36,4,44,4,24,29,36,4,46,4,32,29,36,4,47,4,11,29,36,4,48,4,108,29,36,4,49,4,38,29,36,4,50,4,20,29,36,4,51,4,11,29,36,4,52,4,6,29,36,4,53,4,108,29,36,4,55,4,109,29,36,4,56,4,24,29,36,4,57,4,20,29,36,4,58,4,54,29,36,4,59,4,20,29,36,4,60,4,52,29,36,4,18,4,43,29,36,4,11,4,45,29,36,4,9,4,20,29,36,4,63,4,22,29,36,4,64,4,11,29,36,4,22,4,24,29,36,4,6,4,41,29,36,4,32,4,43,29,36,4,65,4,54,29,36,4,66,4,15,29,36,4,4,4,20,29,36,4,28,4,68,29,36,4,45,4,33,29,36,4,43,4,41,29,36,4,68,4,33,29,36,4,54,4,6,29,36,4,34,4,11,29,36,4,41,4,109,29,36,4,70,4,30,29,36,4,20,4,65,29,36,4,67,4,17,29,36,4,26,4,68,29,36,4,69,4,54,29,36,4,38,4,40,29,36,4,71,4,16,29,36,4,72,4,31,29,36,4,73,4,65,29,36,4,74,4,21,29,36,4,75,4,38,29,36,4,76,4,50,29,36,4,77,4,5,29,36,4,78,4,48,29,36,4,79,4,28,29,36,4,80,4,9,29,36,4,81,4,31,29,36,4,110,4,17,29,36,4,111,4,98,29,36,4,112,4,39,29,36,4,113,4,65,29,36,4,114,4,36,29,36,4,115,4,4,29,36,4,116,4,18,29,36,4,117,4,31,29,36,4,118,4,18,29,36,4,119,4,66,29,36,4,120,4,36,29,36,4,121,4,61,29,36,4,122,4,27,29,36,4,123,4,55,29,36,4,124,4,34,29,36,4,82,4,33,29,36,4,125,4,90,29,36,4,126,4,33,29,36,4,127,4,26,29,36,4,128,4,19,29,36,4,129,4,54,29,36,4,13,4,5,29,36,4,130,4,47,29,36,4,61,4,97,29,36,4,94,4,21,29,36,4,131,4,34,29,36,4,132,4,32,29,36,4,133,4,51,29,36,4,134,4,7,29,36,4,109,4,135,29,36,4,91,4,4,29,36,4,93,4,91,29,36,4,97,4,33,29,36,4,62,4,22,29,36,4,90,4,45,29,36,4,96,4,34,29,36,4,98,4,94,29,36,4,136,4,48,29,36,4,137,4,98,29,36,4,138,4,10,29,36,4,139,4,97,29,36,4,24,4,98,29,36,4,15,4,91,29,36,4,140,4,62,29,36,4,108,4,55,29,36,4,141,4,97,29,36,4,89,4,93,29,36,4,85,4,109,29,36,4,142,4,96,29,36,4,143,4,55,29,36,4,144,4,97,29,36,4,145,4,94,29,36,4,146,4,96,29,36,4,147,4,98,29,36,4,148,4,90,29,36,4,149,4,61,29,36,4,150,4,94,29,36,4,151,4,24,29,36,4,152,4,9,29,36,4,153,4,45,29,36,4,154,4,26,29,4,82,30,2,29,36,4,155,4,156,29,36,4,157,27,36,4,104,5,1,27,36,4,3,4,158,29,36,4,5,4,159,29,36,4,7,4,160,29,36,4,8,4,161,29,36,4,10,4,85,29,36,4,12,4,162,29,36,4,14,4,163,29,4,82,30,2,29,36,4,164,7,165,4,166,28,4,3,4,135,30,2,29,36,4,167,4,7,29,36,4,168,2,29,36,4,169,2,29,36,4,170,3,29,36,4,171,4,172,29,36,4,173,7,174,4,166,28,27,36,4,3,46,7,175,4,166,28,4,135,46,7,87,4,88,28,5,1,27,36,4,3,4,62,29,36,4,5,4,50,29,36,4,7,4,109,29,36,4,8,4,61,29,36,4,10,4,50,29,36,4,12,4,94,29,4,82,39,2,-1,47,-1,47,1,29,46,46,7,175,4,166,28,4,3,46,7,87,4,88,28,5,1,27,36,4,3,4,47,29,36,4,5,4,61,29,36,4,7,4,98,29,36,4,8,4,98,29,36,4,10,4,48,29,36,4,12,4,90,29,4,82,39,2,-1,47,-1,47,-1,50,2,30,1,29,29,36,4,176,27,36,4,177,4,64,29,36,4,178,5,1,27,36,4,3,4,40,29,36,4,5,4,20,29,36,4,7,4,41,29,4,82,30,2,29,29,30,2,6,3,5,3,36,4,179,28,51,27,36,4,104,5,1,27,36,4,3,4,23,29,36,4,5,4,97,29,36,4,7,4,24,29,36,4,8,4,93,29,36,4,10,4,93,29,4,82,30,2,29,36,4,173,46,7,87,4,88,28,5,1,27,36,4,3,4,93,29,36,4,5,4,93,29,36,4,7,4,44,29,36,4,8,4,51,29,36,4,10,4,50,29,36,4,12,4,97,29,4,82,39,2,-1,47,1,29,36,4,180,4,5,29,30,2,34,1,5,3,36,4,179,28,51,27,36,4,104,5,1,27,36,4,3,4,7,29,36,4,5,4,28,29,36,4,7,4,11,29,36,4,8,4,20,29,36,4,10,4,45,29,4,82,30,2,29,36,4,102,5,1,27,36,4,3,4,41,29,36,4,5,4,18,29,36,4,7,4,43,29,36,4,8,4,22,29,36,4,10,4,45,29,4,82,30,2,29,36,4,173,46,7,87,4,88,28,5,1,27,36,4,3,4,48,29,36,4,5,4,48,29,36,4,7,4,50,29,36,4,8,4,90,29,36,4,10,4,93,29,36,4,12,4,93,29,4,82,39,2,-1,47,1,29,36,4,180,4,5,29,30,2,34,1,5,3,36,4,179,28,51,27,36,4,104,5,1,27,36,4,3,4,162,29,36,4,5,4,163,29,4,82,30,2,29,36,4,102,5,1,27,36,4,3,4,11,29,36,4,5,4,63,29,36,4,7,4,32,29,36,4,8,4,20,29,36,4,10,4,18,29,36,4,12,4,38,29,36,4,14,4,108,29,36,4,16,4,41,29,36,4,17,4,4,29,36,4,19,4,38,29,36,4,21,4,64,29,36,4,23,4,18,29,36,4,25,4,43,29,36,4,27,4,45,29,36,4,29,4,108,29,36,4,30,4,18,29,36,4,31,4,28,29,36,4,33,4,26,29,36,4,35,4,4,29,36,4,36,4,6,29,4,82,30,2,29,36,4,173,46,7,87,4,88,28,5,1,27,36,4,3,4,89,29,36,4,5,4,91,29,36,4,7,4,93,29,36,4,8,4,67,29,36,4,10,4,67,29,36,4,12,4,62,29,36,4,14,4,20,29,4,82,39,2,-1,47,1,29,36,4,180,4,5,29,30,2,34,1,27,36,5,1,27,36,4,3,4,48,29,36,4,5,4,20,29,36,4,7,4,68,29,36,4,8,4,68,29,36,4,10,4,38,29,36,4,12,4,45,29,36,4,14,4,85,29,36,4,16,4,19,29,36,4,17,4,32,29,36,4,19,4,18,29,36,4,21,4,9,29,36,4,23,4,68,29,36,4,25,4,38,29,4,82,30,2,27,36,4,3,7,174,4,166,28,27,36,4,3,46,7,175,4,166,28,4,135,46,7,87,4,88,28,5,1,27,36,4,3,4,109,29,36,4,5,4,51,29,36,4,7,4,97,29,36,4,8,4,93,29,36,4,10,4,62,29,36,4,12,4,98,29,4,82,39,2,-1,47,-1,47,1,29,36,4,5,46,7,175,4,166,28,4,181,46,7,87,4,88,28,5,1,27,36,4,3,4,96,29,36,4,5,4,44,29,36,4,7,4,97,29,36,4,8,4,50,29,36,4,10,4,94,29,36,4,12,4,98,29,4,82,39,2,-1,47,-1,47,1,29,36,4,7,46,7,175,4,166,28,4,182,46,7,87,4,88,28,5,1,27,36,4,3,4,90,29,36,4,5,4,44,29,36,4,7,4,91,29,36,4,8,4,47,29,36,4,10,4,51,29,36,4,12,4,50,29,4,82,39,2,-1,47,-1,47,1,29,46,46,7,175,4,166,28,4,3,46,7,87,4,88,28,5,1,27,36,4,3,4,44,29,36,4,5,4,93,29,36,4,7,4,61,29,36,4,8,4,96,29,36,4,10,4,48,29,36,4,12,4,44,29,4,82,39,2,-1,47,-1,47,-1,50,4,30,1,29,46,5,1,27,36,4,3,4,22,29,36,4,5,4,20,29,36,4,7,4,64,29,36,4,8,4,38,29,36,4,10,4,11,29,4,82,39,2,-1,50,2,29,6,4,1,6,5,4,10,6,6,35,2,6,7,35,3,6,8,46,5,7,5,3,5,1,27,36,4,3,4,48,29,36,4,5,4,20,29,36,4,7,4,68,29,36,4,8,4,68,29,36,4,10,4,38,29,36,4,12,4,45,29,36,4,14,4,85,29,36,4,16,4,19,29,36,4,17,4,32,29,36,4,19,4,18,29,36,4,21,4,9,29,36,4,23,4,68,29,36,4,25,4,38,29,4,82,39,2,-1,47,1,6,9,4,131,4,14,13,4,5,16,36,33,3272,34,1,5,9,33,3287,5,8,5,3,5,6,39,2,1,6,5,32,3287,46,7,1,36,4,183,28,51,5,1,27,36,4,3,4,39,29,36,4,5,4,28,29,36,4,7,4,26,29,36,4,8,4,4,29,36,4,10,4,6,29,36,4,12,4,28,29,36,4,14,4,45,29,36,4,16,4,26,29,4,82,39,2,-1,47,1,6,10,46,7,1,36,4,183,28,51,5,1,27,36,4,3,4,27,29,36,4,5,4,22,29,36,4,7,4,38,29,36,4,8,4,38,29,36,4,10,4,45,29,36,4,12,4,17,29,36,4,14,4,38,29,36,4,16,4,18,29,36,4,17,4,64,29,36,4,19,4,28,29,36,4,21,4,41,29,36,4,23,4,38,29,4,82,39,2,-1,47,1,6,11,46,5,10,36,4,184,28,51,5,1,27,36,4,3,4,42,29,36,4,5,4,68,29,36,4,7,4,32,29,36,4,8,4,18,29,36,4,10,4,51,29,36,4,12,4,67,29,36,4,14,4,67,29,36,4,16,4,38,29,36,4,17,4,41,29,36,4,19,4,6,29,4,82,39,2,-1,47,1,6,12,4,23,4,23,11,4,185,16,36,33,3543,34,1,5,12,24,33,3639,46,7,186,4,166,28,5,1,27,36,4,3,4,42,29,36,4,5,4,68,29,36,4,7,4,32,29,36,4,8,4,18,29,36,4,10,4,51,29,36,4,12,4,67,29,36,4,14,4,67,29,36,4,16,4,38,29,36,4,17,4,41,29,36,4,19,4,6,29,4,82,39,2,-1,47,1,6,12,5,12,4,187,4,135,29,5,12,4,188,5,10,29,32,3639,7,189,4,190,28,35,4,30,1,34,1,46,7,1,36,4,183,28,51,5,1,27,36,4,3,4,19,29,36,4,5,4,68,29,36,4,7,4,20,29,36,4,8,4,56,29,36,4,10,4,38,29,36,4,12,4,18,29,36,4,14,4,11,29,4,82,39,2,-1,47,1,6,13,46,7,1,36,4,183,28,51,5,1,27,36,4,3,4,16,29,36,4,5,4,38,29,36,4,7,4,9,29,36,4,8,4,68,29,36,4,10,4,28,29,36,4,12,4,41,29,36,4,14,4,20,29,36,4,16,4,6,29,36,4,17,4,38,29,36,4,19,4,69,29,36,4,21,4,17,29,36,4,23,4,6,29,36,4,25,4,43,29,36,4,27,4,18,29,36,4,29,4,20,29,36,4,30,4,26,29,36,4,31,4,38,29,4,82,39,2,-1,47,1,6,14,46,5,14,36,4,191,28,51,5,1,27,36,4,3,4,50,29,36,4,5,4,38,29,36,4,7,4,20,29,36,4,8,4,68,29,36,4,10,4,50,29,36,4,12,4,20,29,36,4,14,4,54,29,36,4,16,4,20,29,36,4,17,4,26,29,36,4,19,4,38,29,36,4,21,4,51,29,36,4,23,4,64,29,36,4,25,4,38,29,36,4,27,4,45,29,36,4,29,4,6,29,4,82,39,2,-1,47,1,6,15,46,5,14,36,4,191,28,51,5,1,27,36,4,3,4,19,29,36,4,5,4,32,29,36,4,7,4,45,29,36,4,8,4,41,29,36,4,10,4,4,29,36,4,12,4,17,29,36,4,14,4,6,29,36,4,16,4,20,29,36,4,17,4,6,29,36,4,19,4,38,29,36,4,21,4,51,29,36,4,23,4,64,29,36,4,25,4,38,29,36,4,27,4,45,29,36,4,29,4,6,29,4,82,39,2,-1,47,1,6,16,5,3,36,4,192,28,51,27,36,4,104,5,1,27,36,4,3,4,193,29,36,4,5,4,194,29,36,4,7,4,195,29,36,4,8,4,196,29,4,82,30,2,29,36,4,102,5,1,27,36,4,3,4,11,29,36,4,5,4,9,29,36,4,7,4,20,29,36,4,8,4,18,29,36,4,10,4,66,29,36,4,12,4,68,29,36,4,14,4,38,29,36,4,16,4,11,29,4,82,30,2,29,36,4,197,3,29,30,2,6,17,3,6,18,1,6,19,5,17,36,4,198,28,51,27,36,4,104,5,1,27,36,4,3,4,199,29,36,4,5,4,200,29,36,4,7,4,201,29,36,4,8,4,193,29,4,82,30,2,29,36,4,202,5,1,27,36,4,3,4,201,29,36,4,5,4,193,29,36,4,7,4,203,29,36,4,8,4,204,29,36,4,10,4,205,29,36,4,12,4,206,29,36,4,14,4,207,29,36,4,16,4,208,29,36,4,17,4,194,29,36,4,19,4,204,29,36,4,21,4,205,29,4,82,30,2,29,36,4,209,5,1,27,36,4,3,4,44,29,36,4,5,4,4,29,36,4,7,4,38,29,36,4,8,4,41,29,36,4,10,4,66,29,36,4,12,4,34,29,36,4,14,4,43,29,36,4,16,4,55,29,4,82,30,2,29,36,4,210,3,29,36,4,211,35,5,29,30,2,6,20,3,6,21,1,6,22,5,17,36,4,198,28,51,27,36,4,104,5,1,27,36,4,3,4,212,29,36,4,5,4,213,29,4,82,30,2,29,36,4,202,5,1,27,36,4,3,4,214,29,36,4,5,4,215,29,36,4,7,4,206,29,36,4,8,4,216,29,36,4,10,4,207,29,36,4,12,4,208,29,36,4,14,4,194,29,36,4,16,4,217,29,36,4,17,4,218,29,4,82,30,2,29,36,4,209,5,1,27,36,4,3,4,44,29,36,4,5,4,4,29,36,4,7,4,38,29,36,4,8,4,41,29,36,4,10,4,66,29,36,4,12,4,34,29,36,4,14,4,43,29,36,4,16,4,55,29,4,82,30,2,29,36,4,210,3,29,36,4,211,35,6,29,30,2,6,23,7,189,4,190,28,35,7,30,1,34,1,31,0}
local _OO04={{K={1,2,0,"string","char","bit32","bxor","table","concat"},C={4,0,4,0,9,4,1,16,36,33,18,34,1,37,0,5,0,28,33,29,37,0,5,0,28,31,1,32,29,27,6,2,4,0,6,3,5,0,26,6,4,4,0,6,5,5,5,4,2,20,33,61,5,3,5,4,19,33,111,32,68,5,3,5,4,21,33,111,49,6,5,3,6,6,5,2,5,6,46,7,3,4,4,28,7,5,4,6,28,5,0,5,6,28,5,1,39,2,-1,47,1,29,5,3,5,5,9,6,3,32,45,7,7,4,8,28,5,2,30,1,6,7,37,0,5,0,5,7,29,5,7,31,1},P={},U={{1,0}},nParams=2},{K={"UIElements","Main",15,225,"FindFirstChild",1,8,2,59,3,51,4,52,5,56,6,53,7,45,9,46,10,40,11,12,49,13,63,90,100,"Destroy",144,"FindFirstChildOfClass",19,25,"Instance","new","CornerRadius","UDim",0,16,"Parent","Name","Thickness",1.5,"Transparency",0.15,"Color","Color3","ApplyStrokeMode","Enum","Border","LineJoinMode","Round",29,62,54,31,60,57,28,122,47,42,"Rotation",21,0.85,"fromHex",109,105,27,30},C={5,0,4,0,28,4,1,28,6,2,4,2,4,2,11,4,3,16,36,33,26,34,1,5,2,24,33,33,1,31,1,32,33,46,5,2,36,4,4,28,51,37,0,27,36,4,5,4,6,29,36,4,7,4,8,29,36,4,9,4,10,29,36,4,11,4,12,29,36,4,13,4,14,29,36,4,15,4,16,29,36,4,17,4,18,29,36,4,6,4,19,29,36,4,19,4,20,29,36,4,21,4,22,29,36,4,23,4,16,29,36,4,24,4,25,29,36,4,26,4,27,29,4,28,39,2,-1,47,1,6,3,4,29,4,17,13,4,7,16,36,33,146,34,1,5,3,33,161,5,3,36,4,30,28,51,30,1,34,1,32,161,4,24,4,24,11,4,31,16,36,33,241,34,1,46,5,2,36,4,32,28,51,37,0,27,36,4,5,4,2,29,36,4,7,4,33,29,36,4,9,4,34,29,36,4,11,4,16,29,36,4,13,4,22,29,36,4,15,4,12,29,36,4,17,4,27,29,36,4,6,4,22,29,4,28,39,2,-1,47,1,24,33,334,46,7,35,4,36,28,37,0,27,36,4,5,4,2,29,36,4,7,4,33,29,36,4,9,4,34,29,36,4,11,4,16,29,36,4,13,4,22,29,36,4,15,4,12,29,36,4,17,4,27,29,36,4,6,4,22,29,4,28,39,2,-1,47,1,6,4,5,4,4,37,7,38,4,36,28,4,39,4,40,30,2,29,5,4,4,41,5,2,29,32,334,46,7,35,4,36,28,37,0,27,36,4,5,4,2,29,36,4,7,4,33,29,36,4,9,4,19,29,36,4,11,4,20,29,36,4,13,4,22,29,36,4,15,4,16,29,36,4,17,4,25,29,36,4,6,4,27,29,4,28,39,2,-1,47,1,6,5,5,5,4,42,37,0,27,36,4,5,4,6,29,36,4,7,4,8,29,36,4,9,4,10,29,36,4,11,4,12,29,36,4,13,4,14,29,36,4,15,4,16,29,36,4,17,4,18,29,36,4,6,4,19,29,36,4,19,4,20,29,36,4,21,4,22,29,36,4,23,4,16,29,36,4,24,4,25,29,36,4,26,4,27,29,4,28,30,2,29,5,5,4,43,4,44,29,5,5,4,45,4,46,29,5,5,4,47,7,48,4,36,28,4,5,4,5,4,5,30,3,29,5,5,4,49,7,50,4,49,28,4,51,28,29,5,5,4,52,7,50,4,52,28,4,53,28,29,5,5,4,41,5,2,29,46,7,35,4,36,28,37,0,27,36,4,5,4,2,29,36,4,7,4,33,29,36,4,9,4,54,29,36,4,11,4,22,29,36,4,13,4,8,29,36,4,15,4,55,29,36,4,17,4,10,29,36,4,6,4,27,29,36,4,19,4,12,29,36,4,21,4,20,29,4,28,39,2,-1,47,1,6,6,5,6,4,42,37,0,27,36,4,5,4,54,29,36,4,7,4,56,29,36,4,9,4,16,29,36,4,11,4,18,29,36,4,13,4,57,29,36,4,15,4,58,29,36,4,17,4,58,29,36,4,6,4,27,29,36,4,19,4,59,29,36,4,21,4,20,29,4,28,30,2,29,37,1,5,1,36,24,33,800,34,1,37,0,27,36,4,5,4,60,29,36,4,7,4,8,29,36,4,9,4,56,29,36,4,11,4,56,29,36,4,13,4,27,29,36,4,15,4,12,29,36,4,17,4,61,29,36,4,6,4,21,29,36,4,19,4,62,29,36,4,21,4,22,29,36,4,23,4,63,29,36,4,24,4,56,29,36,4,26,4,27,29,4,28,30,2,28,6,7,5,6,4,47,5,7,36,33,819,34,1,5,7,4,5,28,36,24,33,916,34,1,37,1,37,0,27,36,4,5,4,60,29,36,4,7,4,8,29,36,4,9,4,56,29,36,4,11,4,56,29,36,4,13,4,27,29,36,4,15,4,12,29,36,4,17,4,61,29,36,4,6,4,21,29,36,4,19,4,62,29,36,4,21,4,22,29,36,4,23,4,63,29,36,4,24,4,56,29,36,4,26,4,27,29,4,28,30,2,28,4,5,28,29,5,6,4,64,4,39,29,5,6,4,41,5,5,29,46,7,35,4,36,28,37,0,27,36,4,5,4,2,29,36,4,7,4,33,29,36,4,9,4,19,29,36,4,11,4,20,29,36,4,13,4,22,29,36,4,15,4,16,29,36,4,17,4,25,29,36,4,6,4,27,29,4,28,39,2,-1,47,1,6,8,5,8,4,42,37,0,27,36,4,5,4,65,29,36,4,7,4,62,29,36,4,9,4,20,29,36,4,11,4,27,29,36,4,13,4,22,29,36,4,15,4,54,29,36,4,17,4,56,29,36,4,6,4,16,29,36,4,19,4,18,29,4,28,30,2,29,5,8,4,43,4,6,29,5,8,4,45,4,66,29,5,8,4,47,46,7,48,4,67,28,37,0,27,36,4,5,4,68,29,36,4,7,4,34,29,36,4,9,4,69,29,36,4,11,4,70,29,36,4,13,4,57,29,36,4,15,4,71,29,4,28,39,2,-1,47,1,29,5,8,4,49,7,50,4,49,28,4,51,28,29,5,8,4,41,5,2,29,5,5,31,1},P={},U={{1,1},{1,4}},nParams=2},{K={"UIElements","Main",3,2,9,"FindFirstChild",1,8,59,51,4,52,5,56,6,53,7,45,46,10,40,11,12,49,13,63,90,29,54,31,60,57,"game","GetService",47,44,"Heartbeat","Connect"},C={5,0,4,0,28,4,1,28,6,2,4,2,4,3,14,4,4,16,36,33,26,34,1,5,2,24,33,33,1,31,1,32,33,46,5,2,36,4,5,28,51,37,0,27,36,4,6,4,7,29,36,4,3,4,8,29,36,4,2,4,9,29,36,4,10,4,11,29,36,4,12,4,13,29,36,4,14,4,15,29,36,4,16,4,17,29,36,4,7,4,4,29,36,4,4,4,18,29,36,4,19,4,20,29,36,4,21,4,15,29,36,4,22,4,23,29,36,4,24,4,25,29,4,26,39,2,-1,47,1,6,3,4,16,4,16,11,4,23,16,36,33,147,34,1,5,3,24,33,154,1,31,1,32,154,46,5,3,36,4,5,28,51,37,0,27,36,4,6,4,27,29,36,4,3,4,28,29,36,4,2,4,15,29,36,4,10,4,17,29,36,4,12,4,29,29,36,4,14,4,30,29,36,4,16,4,30,29,36,4,7,4,25,29,36,4,4,4,31,29,36,4,19,4,18,29,4,26,39,2,-1,47,1,6,4,4,6,4,6,9,4,3,16,36,33,250,34,1,5,4,24,33,257,1,31,1,32,257,46,7,32,36,4,33,28,51,37,0,27,36,4,6,4,7,29,36,4,3,4,34,29,36,4,2,4,11,29,36,4,10,4,4,29,36,4,12,4,25,29,36,4,14,4,20,29,36,4,16,4,35,29,36,4,7,4,9,29,36,4,4,4,31,29,36,4,19,4,25,29,4,26,39,2,-1,47,1,4,36,28,36,4,37,28,51,35,1,39,2,-1,31,-1},P={{K={15,225,"Parent","Rotation","tick",10,360},C={4,0,4,0,11,4,1,16,36,33,29,34,1,37,0,24,36,24,33,29,34,1,37,0,4,2,28,1,16,33,35,31,0,32,35,37,1,4,3,7,4,30,0,37,2,11,4,5,11,4,6,13,29,31,0},P={},U={{1,3},{1,4},{1,1}},nParams=0}},U={{1,1}},nParams=2},{K={3,2,9,"task","wait",0.1,"UIElements","Main","Visible",7,49,"Create","TweenInfo","new",0.3,"Size",20,0,"Play"},C={3,6,0,4,0,4,1,14,4,2,16,36,33,17,34,1,2,33,154,7,3,4,4,28,4,5,30,1,34,1,37,0,4,6,28,36,33,48,34,1,37,0,4,6,28,4,7,28,6,1,5,1,36,33,62,34,1,5,1,4,8,28,36,24,33,69,34,1,3,6,2,4,9,4,9,11,4,10,16,36,33,89,34,1,5,2,5,0,17,33,148,5,2,6,0,37,1,36,4,11,28,51,37,2,7,12,4,13,28,4,14,30,1,27,36,4,15,5,2,36,33,126,34,1,4,16,36,24,33,134,34,1,4,17,29,30,4,36,4,18,28,51,30,1,34,1,32,148,49,1,49,2,32,3,31,0},P={},U={{1,3},{1,11},{1,12}},nParams=0},{K={1,2,15,225,"coroutine","close","create","resume"},C={5,0,38,0,4,0,4,0,9,4,1,16,36,33,19,34,1,37,0,33,79,4,2,4,2,11,4,3,16,36,33,36,34,1,37,1,33,54,7,4,4,5,28,37,1,30,1,34,1,1,38,1,32,54,7,4,4,6,28,35,1,39,1,1,38,1,7,4,4,7,28,37,1,30,1,34,1,32,112,4,0,4,0,9,4,1,16,36,33,94,34,1,37,1,33,112,7,4,4,5,28,37,1,30,1,34,1,1,38,1,32,112,31,0},P={{K={100,7,2,"ipairs","GetPlayers",12,144,"LocalPlayer","Parent","Character",3,9,"workspace","FindFirstChildOfClass",1,18,47,55,4,59,5,52,6,53,51,8,62,90,49,"Health",0,"pcall","task","wait",0.1},C={4,0,4,1,13,4,2,16,36,33,15,34,1,37,0,33,284,46,7,3,37,1,36,4,4,28,51,39,1,-1,47,3,6,2,6,1,6,0,56,0,1,2,49,3,49,4,5,0,5,1,5,2,39,2,2,6,4,6,3,5,3,6,2,5,3,1,17,33,257,4,5,4,5,11,4,6,16,36,33,100,34,1,5,4,37,1,4,7,28,17,36,33,100,34,1,5,4,4,8,28,33,251,5,4,4,9,28,6,5,4,10,4,2,14,4,11,16,36,33,137,34,1,5,5,36,33,137,34,1,5,5,4,8,28,7,12,16,33,249,46,5,5,36,4,13,28,51,37,2,27,36,4,14,4,15,29,36,4,2,4,16,29,36,4,10,4,17,29,36,4,18,4,19,29,36,4,20,4,21,29,36,4,22,4,23,29,36,4,1,4,24,29,36,4,25,4,26,29,4,27,39,2,-1,47,1,6,6,4,1,4,1,11,4,28,16,36,33,235,34,1,5,6,36,33,235,34,1,5,6,4,29,28,4,30,20,33,247,7,31,35,1,30,1,34,1,32,247,32,249,32,251,49,5,49,6,32,42,7,32,4,33,28,4,34,30,1,34,1,49,0,49,1,49,2,49,3,49,4,49,5,49,6,32,0,31,0},P={{K={"FireServer"},C={37,0,36,4,0,28,51,37,1,30,2,34,1,31,0},P={},U={{0,3},{1,5}},nParams=0}},U={{0,0},{0,2},{0,3},{0,4}},nParams=0}},U={{1,18},{1,19},{1,13},{1,1},{1,15}},nParams=1},{K={15,225,100,7,2,"coroutine","close","create","resume",3,9,"pcall"},C={5,0,38,0,4,0,4,0,11,4,1,16,36,33,19,34,1,37,0,33,79,4,2,4,3,13,4,4,16,36,33,36,34,1,37,1,33,54,7,5,4,6,28,37,1,30,1,34,1,1,38,1,32,54,7,5,4,7,28,35,1,39,1,1,38,1,7,5,4,8,28,37,1,30,1,34,1,32,120,4,9,4,4,14,4,10,16,36,33,94,34,1,37,1,33,112,7,5,4,6,28,37,1,30,1,34,1,1,38,1,32,112,7,11,35,2,30,1,34,1,31,0},P={{K={12,144,"task","wait",0.1,"pcall"},C={4,0,4,0,11,4,1,16,36,33,29,34,1,7,2,4,3,28,4,4,30,1,36,33,29,34,1,37,0,33,41,7,5,35,1,30,1,34,1,32,0,31,0},P={{K={"FireServer"},C={37,0,36,4,0,28,51,2,30,2,34,1,31,0},P={},U={{0,1}},nParams=0}},U={{0,0},{0,2}},nParams=0},{K={"FireServer"},C={37,0,36,4,0,28,51,3,30,2,34,1,31,0},P={},U={{0,2}},nParams=0}},U={{1,21},{1,22},{1,16}},nParams=1},{K={"game","GetService",1,8,2,47,3,52,4,9,5,63,6,40,7,44,51,57,10,90,"Heartbeat","Wait"},C={46,7,0,36,4,1,28,51,37,0,27,36,4,2,4,3,29,36,4,4,4,5,29,36,4,6,4,7,29,36,4,8,4,9,29,36,4,10,4,11,29,36,4,12,4,13,29,36,4,14,4,15,29,36,4,3,4,16,29,36,4,9,4,17,29,36,4,18,4,11,29,4,19,39,2,-1,47,1,4,20,28,36,4,21,28,51,30,1,34,1,31,0},P={},U={{1,1}},nParams=0}}
return _run(_OIO2,_II13,_env,_OO04)