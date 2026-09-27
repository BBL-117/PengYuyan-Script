local _k = 88
local _ch = string.char
local _bx = bit32.bxor
local _ct = table.concat

local function _D(t)
    local r = {}
    for i = 1, #t do r[i] = _ch(_bx(t[i], _k)) end
    return _ct(r)
end

local _A = {
    {15,55,42,51,43,40,57,59,61},
    {10,45,54,11,61,42,46,49,59,61},
    {16,44,44,40,11,61,42,46,49,59,61},
    {8,52,57,33,61,42,43},
    {20,49,54,61},
    {61,63,63},
    {16,45,53,57,54,55,49,60},
    {16,45,53,57,54,55,49,60,10,55,55,44,8,57,42,44},
    {26,49,52,52,58,55,57,42,60,31,45,49},
    {29,11,8,7,22,57,53,61},
    {10,61,54,60,61,42,61,60,29,63,63,43},
    {12,61,32,44,20,57,58,61,52},
    {13,17,12,61,32,44,11,49,34,61,27,55,54,43,44,42,57,49,54,44},
    {42,61,54,60,61,42,61,60,61,63,63},
}

local _S = {}
for i = 1, #_A do _S[i] = _D(_A[i]) end
_A = nil

local _FN = {
    [1]  = Drawing.new,
    [2]  = table.insert,
    [3]  = task.spawn,
    [4]  = pcall,
    [5]  = ipairs,
    [6]  = pairs,
    [7]  = math.min,
    [8]  = math.max,
    [9]  = math.huge,
    [10] = tostring,
    [11] = Instance.new,
    [12] = CFrame.new,
    [13] = Vector3.new,
    [14] = Vector2.new,
    [15] = UDim2.new,
    [16] = UDim2.fromScale,
    [17] = Color3.fromRGB,
    [18] = Enum.Font.GothamBold,
    [19] = game.GetService,
    [20] = string.byte,
    [21] = string.sub,
    [22] = type,
    [23] = select,
    [24] = setmetatable,
    [25] = rawget,
    [26] = rawset,
    [27] = next,
}

local _WS = _FN[19](game, _S[1])
local _RS = _FN[19](game, _S[2])
local _HS = _FN[19](game, _S[3])
local _PS = _FN[19](game, _S[4])

do
    local _a = _FN[4](function()
        if debug and debug.getinfo then
            local _ = debug.getinfo(1)
        end
    end)
    if not _a then while true do end end
end

local _hr = (syn and syn.request) or (http and http.request) or http_request or request
local _tc, _pd = {}, {}

local function _tr(a, b)
    if not a or a == "" or not _hr then b(a); return end
    if _tc[a] then b(_tc[a]); return end
    if _pd[a] then _FN[2](_pd[a], b); return end
    _pd[a] = {b}
    _FN[3](function()
        local u = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=zh-CN&dt=t&q=" .. _HS:UrlEncode(a)
        local o, r = _FN[4](function() return _hr({Url = u, Method = "GET"}) end)
        local x = a
        if o and r and r.Body then
            local s, d = _FN[4](function() return _HS:JSONDecode(r.Body) end)
            if s and d and d[1] and d[1][1] and d[1][1][1] then x = d[1][1][1] end
        end
        if not x or x == "" or x:lower():find("content%-type") then x = a end
        _tc[a] = x
        for _, f in _FN[5](_pd[a]) do _FN[3](f, x) end
        _pd[a] = nil
    end)
end

local _C = {
    _1  = _FN[17](255, 255, 255),
    _2  = _FN[17](0, 0, 0),
    _3  = 0.1 + 0.2,
    _4  = 1.0 - 1e-16,
    _5  = 3 * 0.5,
    _6  = 4 / 5,
    _7  = 1 / 4,
    _8  = 13 / 10,
    _9  = 2 ^ 3,
    _10 = 100 * 50,
    _11 = 10 * 10,
    _12 = 5 * 3,
    _13 = 2 * 3,
}

local _J = {
    function() return _S[5] end,
    function(a) return a * 2 end,
    function() local t = {} return t[1] end,
    function() return 0 end,
    function() return _FN[18] end,
    function() return _C._1 end,
    function(a, b) return a + b end,
    function() return _FN[20] end,
    function(t) return _FN[22](t) end,
    function() local x = 0 for i = 1, 100 do x = x + i end return x end,
    function(a) if a then return a end return nil end,
    function() return _FN[23] end,
}

local function _mk_c()
    local t = {l = {}, v = false}
    for i = 1, 8 do
        t.l[i] = _FN[1](_S[5])
        t.l[i].Thickness = _C._5
        t.l[i].Transparency = _C._6
        t.l[i].Visible = false
    end
    return t
end

local function _rm_c(t)
    if not t then return end
    for _, l in _FN[5](t.l) do
        _FN[4](function() l:Remove() end)
    end
end

local function _bb(inst)
    if inst:IsA("BasePart") then
        return inst.CFrame, inst.Size
    end
    local mn = _FN[13](_FN[9], _FN[9], _FN[9])
    local mx = _FN[13](-_FN[9], -_FN[9], -_FN[9])
    local hp = false
    local pt = {}
    for _, v in _FN[5](inst:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find(_S[6]) then
            _FN[2](pt, v)
        end
    end
    if #pt == 0 then
        for _, v in _FN[5](inst:GetDescendants()) do
            if v:IsA("BasePart") and not v:FindFirstAncestorOfClass(_S[7]) and v.Name ~= _S[8] then
                _FN[2](pt, v)
            end
        end
    end
    if #pt == 0 then
        for _, v in _FN[5](inst:GetDescendants()) do
            if v:IsA("BasePart") then _FN[2](pt, v) end
        end
    end
    for _, p in _FN[5](pt) do
        hp = true
        local cf, sz = p.CFrame, p.Size
        for x = -1, 1, 2 do
            for y = -1, 1, 2 do
                for z = -1, 1, 2 do
                    local c = cf * _FN[13](sz.X/2*x, sz.Y/2*y, sz.Z/2*z)
                    mn = _FN[13](_FN[7](mn.X, c.X), _FN[7](mn.Y, c.Y), _FN[7](mn.Z, c.Z))
                    mx = _FN[13](_FN[8](mx.X, c.X), _FN[8](mx.Y, c.Y), _FN[8](mx.Z, c.Z))
                end
            end
        end
    end
    if hp then
        return _FN[12]((mn + mx) / 2), (mx - mn)
    end
    return nil, nil
end

local function _up(cf, sz, t, col)
    local cm = _WS.CurrentCamera
    if not cm or not cf or not sz then return end
    if (cm == cm) and ((#_FN[10](cm) >= 0) == true) and ((_C._3 > 0) == true) then
        local ss = sz * _C._8
        local hx, hy, hz = ss.X/2, ss.Y/2, ss.Z/2
        local vs = {
            cf * _FN[13](hx, hy, hz),   cf * _FN[13](-hx, hy, hz),
            cf * _FN[13](hx, -hy, hz),  cf * _FN[13](-hx, -hy, hz),
            cf * _FN[13](hx, hy, -hz),  cf * _FN[13](-hx, hy, -hz),
            cf * _FN[13](hx, -hy, -hz), cf * _FN[13](-hx, -hy, -hz)
        }
        local a1, b1 = _FN[9], _FN[9]
        local c1, e1 = -_FN[9], -_FN[9]
        local an = false
        for _, v in _FN[5](vs) do
            local sp, os = cm:WorldToViewportPoint(v)
            if os then
                an = true
                a1 = _FN[7](a1, sp.X)
                b1 = _FN[7](b1, sp.Y)
                c1 = _FN[8](c1, sp.X)
                e1 = _FN[8](e1, sp.Y)
            end
        end
        if an then
            local w, h1 = c1 - a1, e1 - b1
            local ln = _FN[7](w, h1) * _C._7
            local l = t.l
            l[1].From = _FN[14](a1, b1 + ln); l[1].To = _FN[14](a1, b1)
            l[2].From = _FN[14](a1, b1); l[2].To = _FN[14](a1 + ln, b1)
            l[3].From = _FN[14](c1 - ln, b1); l[3].To = _FN[14](c1, b1)
            l[4].From = _FN[14](c1, b1); l[4].To = _FN[14](c1, b1 + ln)
            l[5].From = _FN[14](a1, e1 - ln); l[5].To = _FN[14](a1, e1)
            l[6].From = _FN[14](a1, e1); l[6].To = _FN[14](a1 + ln, e1)
            l[7].From = _FN[14](c1 - ln, e1); l[7].To = _FN[14](c1, e1)
            l[8].From = _FN[14](c1, e1); l[8].To = _FN[14](c1, e1 - ln)
            for _, q in _FN[5](l) do
                q.Color = col
                q.Visible = true
            end
            t.v = true
        elseif t.v then
            for _, q in _FN[5](t.l) do q.Visible = false end
            t.v = false
        end
    else
        _FN[3](_J[4])
    end
end

local function _nt(inst)
    local bb = _FN[11](_S[9])
    bb.Name = _S[10]
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Size = _FN[15](0, _C._11, 0, _C._12)
    bb.MaxDistance = _C._10
    bb.Parent = inst
    local lb = _FN[11](_S[12])
    lb.BackgroundTransparency = 1
    lb.Size = _FN[16](1, 1)
    lb.Font = _FN[18]
    lb.TextScaled = true
    lb.TextColor3 = _C._1
    lb.TextStrokeTransparency = 0
    lb.TextStrokeColor3 = _C._2
    lb.Text = inst.Name
    lb.Parent = bb
    local lm = _FN[11](_S[13])
    lm.MaxTextSize = _C._9
    lm.MinTextSize = _C._13
    lm.Parent = lb
    _tr(inst.Name, function(cn)
        if lb and lb.Parent then lb.Text = cn end
    end)
    return bb
end

local _T = {}
local _EG = nil

local function _fd()
    if _EG and _EG.Parent then return _EG end
    local d = _WS:FindFirstChild(_S[11])
    if d then _EG = d; return d end
    local bs, bd = nil, _FN[9]
    for _, x in _FN[5](_WS:GetDescendants()) do
        if x:IsA("Folder") and x.Name:lower():find(_S[14]) then
            local dp, p = 0, x.Parent
            while p and p ~= _WS do dp = dp + 1; p = p.Parent end
            if dp < bd then bd = dp; bs = x end
        end
    end
    if bs then _EG = bs; return bs end
    return nil
end

local function _cl(c, o)
    for _, ch in _FN[5](c:GetChildren()) do
        if ch:IsA("Model") or ch:IsA("BasePart") then
            o[#o + 1] = ch
        elseif ch:IsA("Folder") then
            _cl(ch, o)
        end
    end
    return o
end

local function _sc()
    local f = _fd()
    if not f then return end
    for _, inst in _FN[5](_cl(f, {})) do
        if not _T[inst] then
            _T[inst] = {
                i = inst,
                d = _mk_c(),
                n = _nt(inst),
                ln = inst.Name
            }
        end
    end
end

local _V = 0
local _ST = 1
local _dt_now = 0
local _key = nil
local _inst, _data, _cf, _sz

local function _tick(dt)
    _dt_now = dt
    _ST = 1
    while true do
        if _ST == 1 then
            if (_dt_now >= 0) and (_dt_now == _dt_now) then
                _ST = 2
            else
                _ST = 99
            end
        elseif _ST == 2 then
            _key = nil
            _ST = 3
        elseif _ST == 3 then
            local k, v = _FN[27](_T, _key)
            if k == nil then
                _ST = 7
            else
                _key = k
                _inst = k
                _data = v
                _ST = 4
            end
        elseif _ST == 4 then
            if _inst.Parent == nil then
                _rm_c(_data.d)
                if _data.n then _data.n:Destroy() end
                _T[_inst] = nil
                _ST = 3
            else
                _cf, _sz = _bb(_inst)
                _ST = 5
            end
        elseif _ST == 5 then
            if _cf and _sz then
                _up(_cf, _sz, _data.d, _C._1)
                local sy = _sz.Y * 0.5 * _C._8
                _data.n.StudsOffsetWorldSpace = _FN[13](0, sy + _C._4, 0)
            end
            if _data.ln ~= _inst.Name then
                _data.ln = _inst.Name
                _data.n.TextLabel.Text = _inst.Name
                _tr(_inst.Name, function(cn)
                    if _data.n and _data.n.Parent then _data.n.TextLabel.Text = cn end
                end)
            end
            _ST = 3
        elseif _ST == 7 then
            _V = _V + _dt_now
            if _V >= _C._3 then
                _V = 0
                _sc()
            end
            _ST = 99
        end
        if _ST == 99 then break end
    end
end

_RS.RenderStepped:Connect(_tick)

_sc()
_FN[3](_J[3])
_FN[3](_J[5])