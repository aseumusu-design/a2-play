--[[
    NINJA REMOTE TOOL v2  —  Roblox LocalScript / Executor UI
    =====================================================================
    Fitur:
      • TAB SCAN   : Scan SEMUA remote di seluruh game (RemoteEvent,
                     RemoteFunction, UnreliableRemoteEvent, BindableEvent,
                     BindableFunction) di semua service + auto-copy
                     + auto-generate code template (format Cobalt).
      • TAB SPY    : Hook __namecall — otomatis nangkep remote yang
                     di-fire/invoke saat kamu klik tombol di game
                     (mis. tombol "ambil benda" → remote server-nya
                     langsung ketahuan + contoh code siap pakai).
                     Log lengkap: path, method, args, caller script,
                     owner script. Refire [F], Auto-refire, copy 1 baris,
                     copy log, blokir remote spam.
      • TAB OBJEK  : Cari nama benda apa pun di dalam map (misal
                     "AreaEggSlotsClient") → lihat semua child-nya,
                     copy semua nama / semua path (GetFullName),
                     "Trace Mouse" untuk hover part → tampil path-nya.
      • TAB TOOLS  : Tombol [C] di log DevConsole (copy 1 baris),
                     info keybind, save log ke file.

    Konteks: tool pembelajaran/debugging client-side; hanya membaca objek
    yang ter-replicate ke client. Jalankan sebagai LocalScript/executor.
    =====================================================================
]]

--=====================================================================
-- 0. SERVICES & KOMPATIBILITAS EXECUTOR
--=====================================================================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local StarterGui        = game:GetService("StarterGui")
local TextService       = game:GetService("TextService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Fallback parent UI (executor-safe)
local function getUIParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then
        local ok, g = pcall(function() return syn.protect_gui() end)
        if ok and g then return g end
    end
    local ok = pcall(function()
        local t = Instance.new("TextLabel")
        t.Parent = CoreGui
        t:Destroy()
    end)
    if ok then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function setClip(t)
    t = tostring(t)
    if setclipboard then return setclipboard(t) end
    if setrbxclipboard then return setrbxclipboard(t) end
    if syn and syn.write_clipboard then return syn.write_clipboard(t) end
    -- fallback: TextBox muncul sebentar untuk copy manual
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NinjaClipFallback"
        gui.ResetOnSpawn = false
        gui.Parent = getUIParent()
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 420, 0, 30)
        box.Position = UDim2.new(0.5, -210, 1, -70)
        box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        box.TextColor3 = Color3.fromRGB(0, 255, 180)
        box.PlaceholderText = "Clipboard tidak ada — Ctrl+A lalu Ctrl+C"
        box.Text = t
        box.TextSize = 12
        box.Font = Enum.Font.Code
        box.ClearTextOnFocus = false
        box.TextWrapped = true
        box.Parent = gui
        task.delay(15, function() gui:Destroy() end)
    end)
    return false
end

local function hasClipboard()
    return (setclipboard ~= nil) or (setrbxclipboard ~= nil)
        or (syn and syn.write_clipboard ~= nil) or false
end

local function notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = tostring(title), Text = tostring(text), Duration = dur or 3
        })
    end)
end

--=====================================================================
-- 1. STATE GLOBAL
--=====================================================================
local State = {
    spyActive        = false,
    hookInstalled    = false,
    spyIgnoreRepeat  = true,
    copyOnCapture    = false,
    logLines         = {},
    logCount         = 0,
    lastNotifText    = "",
    lastNotifTime    = 0,
    refireLoops      = {},  -- [entry] = connection
    mouseTracerOn    = false,
    tracerHighlight  = nil,
    hookBlocked      = false,  -- true jika hooknamecall dipakai sistem lain
}

local REMOTE_CLASSES = {
    ["RemoteEvent"]           = "RE",
    ["RemoteFunction"]        = "RF",
    ["UnreliableRemoteEvent"] = "URE",
    ["BindableEvent"]         = "BE",
    ["BindableFunction"]      = "BF",
}

-- Script internal Roblox yang biasanya bikin log spam (khusus spy)
local SPY_NOISE = {
    "RobloxPlaylist16", "CircuitOne", "ImageLabelAcquire",
    "RbxStarterScript", "TeleportRunner",
}

--=====================================================================
-- 2. SERIALIZER — ubah value jadi teks code Lua yang valid
--=====================================================================
local function fmtNum(n)
    if n ~= n then return "0/0" end          -- NaN
    if n == math.huge then return "math.huge" end
    if n == -math.huge then return "-math.huge" end
    local s = string.format("%.6g", n)
    return s
end

-- forward declaration (didefinisikan di bagian 3, dipakai serializer ini)
local instanceToCode

local function serialize(v, depth)
    depth = depth or 0
    if depth > 4 then return '"..."' end
    local t = typeof(v)
    if t == "number" then
        return fmtNum(v)
    elseif t == "string" then
        return string.format("%q", v)
    elseif t == "boolean" then
        return tostring(v)
    elseif t == "nil" then
        return "nil"
    elseif t == "Instance" then
        if not v or not v.Parent then
            return "nil --[[ Instance hilang ]]"
        end
        return instanceToCode(v)
    elseif t == "table" then
        local parts = {}
        local n = 0
        for k, val in pairs(v) do
            n = n + 1
            if n > 40 then
                table.insert(parts, "... (tabel terpotong)")
                break
            end
            local key
            if typeof(k) == "string" and string.match(k, "^[%w_]+$") then
                key = k
            elseif typeof(k) == "number" then
                key = "[" .. fmtNum(k) .. "]"
            else
                key = "[" .. serialize(k, depth + 1) .. "]"
            end
            table.insert(parts, key .. " = " .. serialize(val, depth + 1))
        end
        if #parts == 0 then return "{}" end
        return "{\n" .. string.rep("    ", depth + 1)
            .. table.concat(parts, ",\n" .. string.rep("    ", depth + 1))
            .. "\n" .. string.rep("    ", depth) .. "}"
    elseif t == "Vector3" then
        return string.format("Vector3.new(%s, %s, %s)",
            fmtNum(v.X), fmtNum(v.Y), fmtNum(v.Z))
    elseif t == "Vector2" then
        return string.format("Vector2.new(%s, %s)", fmtNum(v.X), fmtNum(v.Y))
    elseif t == "CFrame" then
        return string.format(
            "CFrame.new(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
            fmtNum(v.X), fmtNum(v.Y), fmtNum(v.Z),
            fmtNum(v.R00), fmtNum(v.R01), fmtNum(v.R02),
            fmtNum(v.R10), fmtNum(v.R11), fmtNum(v.R12),
            fmtNum(v.R20), fmtNum(v.R21), fmtNum(v.R22))
    elseif t == "EnumItem" then
        return tostring(v)
    elseif t == "Color3" then
        return string.format("Color3.new(%s, %s, %s)",
            fmtNum(v.R), fmtNum(v.G), fmtNum(v.B))
    elseif t == "UDim2" then
        return string.format("UDim2.new(%s, %s, %s, %s)",
            fmtNum(v.X.Scale), fmtNum(v.X.Offset),
            fmtNum(v.Y.Scale), fmtNum(v.Y.Offset))
    elseif t == "UDim" then
        return string.format("UDim.new(%s, %s)", fmtNum(v.Scale), fmtNum(v.Offset))
    elseif t == "Ray" then
        return "Ray.new(...)"
    elseif t == "Rect" then
        return "Rect.new(...)"
    elseif t == "NumberRange" then
        return string.format("NumberRange.new(%s, %s)", fmtNum(v.Min), fmtNum(v.Max))
    elseif t == "Random" then
        return "Random.new()"
    else
        return string.format('"%s" --[[ tipe: %s ]]', tostring(v), t)
    end
end

-- Serializer ringkas untuk tampilan log (satu baris)
local function serializeShort(v, depth)
    depth = depth or 0
    if depth > 2 then return "..." end
    local t = typeof(v)
    if t == "string" then
        if #v > 60 then return string.format("%q", string.sub(v, 1, 57) .. "...") end
        return string.format("%q", v)
    elseif t == "number" or t == "boolean" then
        return tostring(v)
    elseif t == "nil" then
        return "nil"
    elseif t == "Instance" then
        if v and v.Parent then return v.Name end
        return "nil"
    elseif t == "Vector3" then
        return string.format("Vec3(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
    elseif t == "CFrame" then
        return string.format("CF(%.1f, %.1f, %.1f)", v.X, v.Y, v.Z)
    elseif t == "EnumItem" then
        return tostring(v)
    elseif t == "table" then
        local parts = {}
        for k, val in pairs(v) do
            if #parts >= 6 then table.insert(parts, "…"); break end
            local ks = (typeof(k) == "string") and tostring(k)
                or "[" .. tostring(k) .. "]"
            table.insert(parts, ks .. "=" .. serializeShort(val, depth + 1))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    else
        return tostring(v)
    end
end

local function argsShort(args, max)
    max = max or 3
    local parts = {}
    for i = 1, math.min(#args, max) do
        table.insert(parts, serializeShort(args[i]))
    end
    if #args > max then table.insert(parts, "…(" .. #args .. ")") end
    return table.concat(parts, ", ")
end

--=====================================================================
-- 3. BUILDER CODE COBALT-STYLE
--    Contoh output:
--    local Event = game:GetService("ReplicatedStorage").Packages.Networking["RF/EggWorld/AskFieldEggCarry"]
--    Event:InvokeServer({ Uid = "..." })
--=====================================================================

-- Parser path hasil GetFullName(): sadar segmen berkutip ["Nama Aneh"]
-- contoh: ReplicatedStorage.Packages.Networking["RF/EggWorld/AskFieldEggCarry"]
local function parsePathSegments(fullPath)
    local segs = {}
    local i, n = 1, #fullPath
    while i <= n do
        local c = string.sub(fullPath, i, i)
        if c == "[" and string.sub(fullPath, i + 1, i + 1) == '"' then
            -- segmen berkutip: ["Nama"]
            local close = string.find(fullPath, '"]', i, true)
            if close then
                table.insert(segs, string.sub(fullPath, i + 2, close - 1))
                i = close + 2
                if string.sub(fullPath, i, i) == "." then i = i + 1 end
            else
                table.insert(segs, string.sub(fullPath, i + 2))
                break
            end
        elseif c == "." then
            i = i + 1
        else
            -- nama polos sampai '.' atau '['
            local j = i
            while j <= n do
                local cj = string.sub(fullPath, j, j)
                if cj == "." or cj == "[" then break end
                j = j + 1
            end
            table.insert(segs, string.sub(fullPath, i, j - 1))
            i = j
            if string.sub(fullPath, i, i) == "." then i = i + 1 end
        end
    end
    return segs
end

-- Apakah nama bisa dipakai langsung sebagai .nama (identifier valid Lua)?
local function isValidIdent(name)
    if name == "" then return false end
    local first = string.byte(string.sub(name, 1, 1))
    if not ((first >= 65 and first <= 90) or (first >= 97 and first <= 122)
        or first == 95) then
        return false
    end
    for k = 2, #name do
        local b = string.byte(name, k)
        if not ((b >= 65 and b <= 90) or (b >= 97 and b <= 122)
            or (b >= 48 and b <= 57) or b == 95) then
            return false
        end
    end
    return true
end

-- Bangun accessor: {"Packages","Networking","RF/EggWorld/Ask"}
--   → ".Packages.Networking[\"RF/EggWorld/Ask\"]"
local function buildAccessor(segs)
    local out = {}
    for _, name in ipairs(segs) do
        if isValidIdent(name) then
            table.insert(out, "." .. name)
        else
            table.insert(out, string.format("[%q]", name))
        end
    end
    return table.concat(out)
end

-- Path instance → kode akses lengkap yang bisa langsung dijalankan
function instanceToCode(inst)
    local okPath, fullPath = pcall(function() return inst:GetFullName() end)
    if not okPath or not fullPath or fullPath == "" then
        return string.format('nil --[[ %s (%s) ]]', tostring(inst.Name), inst.ClassName)
    end
    local segs = parsePathSegments(fullPath)
    local root = table.remove(segs, 1)
    local okSvc = pcall(function() return game:GetService(root) end)
    if okSvc and root then
        return string.format('game:GetService(%q)%s --[[ %s ]]',
            root, buildAccessor(segs), inst.ClassName)
    end
    return string.format('nil --[[ path: %s (%s) ]]', fullPath, inst.ClassName)
end

local function buildInvokeCode(remote, method, args)
    local path
    local okP = pcall(function() path = remote:GetFullName() end)
    if not okP or not path then return "-- [remote sudah hilang]" end
    local segs = parsePathSegments(path)
    local root = table.remove(segs, 1)
    if not root then return "-- [remote sudah hilang]" end
    local okSvc = pcall(function() return game:GetService(root) end)
    if not okSvc then
        return string.format('-- remote tidak bisa diakses dari client: %s', path)
    end
    local accessor = buildAccessor(segs)
    local argCode = {}
    for i = 1, #args do
        table.insert(argCode, serialize(args[i]))
    end
    local argText
    if #argCode == 0 then
        argText = "()"
    else
        argText = "(\n    " .. table.concat(argCode, ",\n    ") .. "\n)"
    end
    local callName = (method == "InvokeServer") and "InvokeServer"
        or (method == "FireServer" and "FireServer"
        or (method == "Invoke" and "Invoke" or "Fire"))
    return string.format(
        "local Event = game:GetService(%q)%s\nEvent:%s%s",
        root, accessor, callName, argText)
end

--=====================================================================
-- 4. SCAN REMOTES
--=====================================================================
local SERVICES_TO_SCAN = {
    "ReplicatedStorage", "Workspace", "ServerStorage", "ServerScriptService",
    "StarterGui", "StarterPack", "StarterPlayer", "Players", "Lighting",
    "SoundService", "MaterialService", "ReplicatedFirst",
}

local function scanAllRemotes()
    local found = {}
    for _, name in ipairs(SERVICES_TO_SCAN) do
        local svc
        local ok = pcall(function() svc = game:GetService(name) end)
        if ok and svc then
            local ok2, err = pcall(function()
                for _, obj in ipairs(svc:GetDescendants()) do
                    local tag = REMOTE_CLASSES[obj.ClassName]
                    if tag then
                        table.insert(found, {
                            obj   = obj,
                            tag   = tag,
                            class = obj.ClassName,
                            path  = obj:GetFullName(),
                        })
                    end
                end
            end)
            if not ok2 then
                -- service bisa dibaca tapi GetDescendants dibatasi
            end
        end
    end
    return found
end

--=====================================================================
-- 5. CARI OBJEK (TAB OBJEK)
--=====================================================================
local function findObjects(term)
    term = string.lower(term or "")
    local results = {}
    if term == "" then return results end
    for _, name in ipairs(SERVICES_TO_SCAN) do
        local svc
        local ok = pcall(function() svc = game:GetService(name) end)
        if ok and svc then
            pcall(function()
                for _, obj in ipairs(svc:GetDescendants()) do
                    if string.find(string.lower(obj.Name), term, 1, true) then
                        table.insert(results, obj)
                        if #results >= 300 then return end
                    end
                end
            end)
            if #results >= 300 then break end
        end
    end
    return results
end

local function safeGetChildren(inst)
    local list = {}
    pcall(function()
        for _, c in ipairs(inst:GetChildren()) do
            table.insert(list, c)
        end
    end)
    return list
end

local function safeGetFullName(inst)
    local ok, p = pcall(function() return inst:GetFullName() end)
    if ok then return p end
    return inst.Name
end

--=====================================================================
-- 6. LOG SPY + LOG CAPTURE (dengan anti-spam notifikasi)
--=====================================================================
local UI = {}  -- diisi setelah UI dibuat (bagian 8)

local function addLog(entry)
    if UI.addLogEntry then
        UI.addLogEntry(entry)
    end
end

local function pushStateLog(line)
    State.logCount = State.logCount + 1
    table.insert(State.logLines, line)
    if #State.logLines > 400 then table.remove(State.logLines, 1) end
end

--=====================================================================
-- 7. HOOK SPY (namecall)
--=====================================================================
local oldNamecall
local callingFromHook = false

local function isNoiseScript(src)
    for _, n in ipairs(SPY_NOISE) do
        if string.find(src, n, 1, true) then return true end
    end
    return false
end

local function getCallerScript()
    -- naik beberapa level stack sampai keluar dari hook internal kita
    for level = 2, 12 do
        local ok, info = pcall(function()
            return debug.getinfo(level, "s")
        end)
        if not ok or not info then break end
        local src = info.short_src or "?"
        if src ~= "?" and string.find(src, "Ninja_Remote_Tool", 1, true) == nil then
            return src
        end
    end
    local ok, s = pcall(function() return debug.getinfo(2, "s").short_src end)
    if ok and s then return s end
    return "?"
end

local function refireCall(entry)
    if not entry or not entry.remote or not entry.remote.Parent then
        notify("Refire gagal", "Remote sudah tidak ada di game")
        return
    end
    local method = entry.method
    local args = entry.args
    local ok, err
    callingFromHook = true
    if method == "InvokeServer" then
        ok, err = pcall(function()
            return entry.remote:InvokeServer(unpack(args, 1, #args))
        end)
    elseif method == "Invoke" then
        ok, err = pcall(function()
            return entry.remote:Invoke(unpack(args, 1, #args))
        end)
    elseif method == "Fire" then
        ok, err = pcall(function()
            entry.remote:Fire(unpack(args, 1, #args))
        end)
    else
        ok, err = pcall(function()
            entry.remote:FireServer(unpack(args, 1, #args))
        end)
    end
    callingFromHook = false
    if ok then
        notify("Refire sukses", entry.remoteName .. ":" .. method)
    else
        notify("Refire error", tostring(err))
    end
end

local function toggleAutoRefire(entry)
    if State.refireLoops[entry] then
        State.refireLoops[entry]:Disconnect()
        State.refireLoops[entry] = nil
        notify("Auto-refire OFF", entry.remoteName)
    else
        State.refireLoops[entry] = RunService.Heartbeat:Connect(function()
            refireCall(entry)
        end)
        notify("Auto-refire ON", entry.remoteName ..
            " — tiap frame! Klik lagi untuk stop")
    end
end

local function installHook()
    if State.hookInstalled then return true end

    -- tangkap fungsi asli DULU (aman utk semua jalur hook)
    local okGet, oldNC = pcall(function()
        return getrawmetatable(game).__namecall
    end)
    if not okGet or type(oldNC) ~= "function" then
        State.hookBlocked = true
        notify("Hook gagal", "Executor memblokir akses __namecall")
        return false
    end
    oldNamecall = oldNC

    local function handleCall(self, ...)
        local method = getnamecallmethod and getnamecallmethod() or nil
        if method and typeof(self) == "Instance" then
            local cls = self.ClassName
            local isRemote = (cls == "RemoteEvent" and method == "FireServer")
                or (cls == "RemoteFunction" and method == "InvokeServer")
                or (cls == "UnreliableRemoteEvent" and method == "FireServer")
                or (cls == "BindableEvent" and method == "Fire")
                or (cls == "BindableFunction" and method == "Invoke")
            if isRemote and State.spyActive and not callingFromHook then
                local args = table.pack(...)
                local argsList = {}
                for i = 1, args.n do argsList[i] = args[i] end
                local ok, entry = pcall(function()
                    local okOwner, owner = pcall(function()
                        local sc = self:FindFirstAncestorOfClass("LocalScript")
                            or self:FindFirstAncestorOfClass("ModuleScript")
                            or self:FindFirstAncestorOfClass("Script")
                        return sc and sc.Name or "-"
                    end)
                    local e = {
                        remote     = self,
                        remoteName = self.Name,
                        remotePath = safeGetFullName(self),
                        class      = cls,
                        method     = method,
                        args       = argsList,
                        caller     = getCallerScript(),
                        owner      = (okOwner and owner) or "-",
                        time       = os.clock(),
                    }
                    e.code = buildInvokeCode(self, method, argsList)
                    return e
                end)
                if ok and entry then
                    task.spawn(function()
                        addLog(entry)
                    end)
                end
            end
        end
        return oldNamecall(self, ...)
    end

    -- jalur 1: hookmetamethod (paling aman di executor modern)
    if hookmetamethod then
        local okH = pcall(function()
            hookmetamethod(game, "__namecall", handleCall)
        end)
        if okH then
            State.hookInstalled = true
            State.hookStyle = "hookmetamethod"
            return true
        end
    end

    -- jalur 2: hooknamecall
    if hooknamecall then
        local ok2 = pcall(function()
            hooknamecall("__namecall", handleCall)
        end)
        if ok2 then
            State.hookInstalled = true
            State.hookStyle = "hooknamecall"
            return true
        end
    end

    -- jalur 3: replace __namecall manual
    local mt = getrawmetatable(game)
    if not mt then
        State.hookBlocked = true
        notify("Hook gagal", "getrawmetatable tidak tersedia di executor ini")
        return false
    end
    local ok3 = pcall(function()
        setreadonly(mt, false)
        mt.__namecall = handleCall
        setreadonly(mt, true)
    end)
    if ok3 then
        State.hookInstalled = true
        State.hookStyle = "rawset"
        return true
    end

    State.hookBlocked = true
    notify("Hook gagal", "Semua metode hook diblokir executor")
    return false
end

--=====================================================================
-- 8. UI UTAMA
--=====================================================================
local THEME = {
    bg      = Color3.fromRGB(18, 18, 24),
    bg2     = Color3.fromRGB(24, 24, 32),
    card    = Color3.fromRGB(30, 30, 40),
    accent  = Color3.fromRGB(0, 255, 170),
    accent2 = Color3.fromRGB(255, 170, 0),
    red     = Color3.fromRGB(255, 80, 80),
    blue    = Color3.fromRGB(80, 170, 255),
    text    = Color3.fromRGB(235, 235, 235),
    dim     = Color3.fromRGB(140, 140, 155),
    border  = Color3.fromRGB(55, 55, 70),
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NinjaRemoteToolV2"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = getUIParent()

-- ---------- util UI ----------
local function round(parent, px)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, px or 6)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function pad(parent, all)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, all)
    p.PaddingBottom = UDim.new(0, all)
    p.PaddingLeft = UDim.new(0, all)
    p.PaddingRight = UDim.new(0, all)
    p.Parent = parent
    return p
end

local function mkText(parent, txt, size, color, font, ts, align)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = txt or ""
    t.TextSize = ts or 13
    t.TextColor3 = color or THEME.text
    t.Font = font or Enum.Font.Code
    t.TextXAlignment = align or Enum.TextXAlignment.Left
    t.Size = size or UDim2.new(1, 0, 0, 18)
    t.Parent = parent
    return t
end

local function mkButton(parent, txt, size, pos, cb, accent)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.Text = txt
    b.Font = Enum.Font.Code
    b.TextSize = 12
    b.TextColor3 = accent or THEME.text
    b.BackgroundColor3 = THEME.card
    b.AutoButtonColor = true
    b.BorderSizePixel = 0
    b.Parent = parent
    round(b, 4)
    stroke(b, THEME.border)
    b.MouseButton1Click:Connect(function()
        pcall(cb)
    end)
    return b
end

local function mkToggle(parent, label, size, pos, default, cb)
    local holder = Instance.new("TextButton")
    holder.Size = size
    holder.Position = pos
    holder.BackgroundColor3 = THEME.card
    holder.BorderSizePixel = 0
    holder.Text = ""
    holder.AutoButtonColor = false
    holder.Parent = parent
    round(holder, 4)
    stroke(holder, THEME.border)

    local lbl = mkText(holder, label, UDim2.new(1, -46, 1, 0))
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 34, 0, 16)
    pill.Position = UDim2.new(1, -40, 0.5, -8)
    pill.BackgroundColor3 = THEME.border
    pill.BorderSizePixel = 0
    pill.Parent = holder
    round(pill, 8)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = THEME.dim
    knob.BorderSizePixel = 0
    knob.Parent = pill
    round(knob, 6)

    local state = default and true or false
    local function render()
        TweenService:Create(pill, TweenInfo.new(0.15),
            { BackgroundColor3 = state and THEME.accent or THEME.border }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15),
            { BackgroundColor3 = state and THEME.bg or THEME.dim }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15),
            { Position = state and UDim2.new(1, -14, 0.5, -6)
                or UDim2.new(0, 2, 0.5, -6) }):Play()
    end
    render()

    holder.MouseButton1Click:Connect(function()
        state = not state
        render()
        pcall(function() cb(state) end)
    end)
    return holder
end

-- ---------- MAIN WINDOW ----------
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 760, 0, 520)
main.Position = UDim2.new(0.5, -380, 0.5, -260)
main.BackgroundColor3 = THEME.bg
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
round(main, 10)
stroke(main, THEME.accent, 1)

-- drag manual via title bar (lihat blok InputBegan di bawah)

-- ---------- TITLE BAR ----------
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundColor3 = THEME.bg2
titleBar.BorderSizePixel = 0
titleBar.Parent = main
round(titleBar, 10)

local tShadow = Instance.new("Frame")
tShadow.Size = UDim2.new(1, 0, 0, 10)
tShadow.Position = UDim2.new(0, 0, 1, 0)
tShadow.BackgroundColor3 = THEME.bg2
tShadow.BorderSizePixel = 0
tShadow.Parent = titleBar

local titleIcon = mkText(titleBar, "🥷", UDim2.new(0, 30, 1, 0), nil, nil, 16)
titleIcon.Position = UDim2.new(0, 8, 0, 0)
titleIcon.TextXAlignment = Enum.TextXAlignment.Center

local titleText = mkText(titleBar, "NINJA REMOTE TOOL v2", UDim2.new(1, -140, 1, 0), THEME.accent, nil, 15)
titleText.Position = UDim2.new(0, 34, 0, 0)
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- status kecil (clipboard support)
local statusClip = mkText(titleBar,
    hasClipboard() and "📋 clipboard ✓" or "📋 clipboard ✗",
    UDim2.new(0, 110, 1, 0), hasClipboard() and THEME.accent or THEME.red, nil, 11)
statusClip.Position = UDim2.new(1, -220, 0, 0)
statusClip.TextXAlignment = Enum.TextXAlignment.Right

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 24)
closeBtn.Position = UDim2.new(1, -38, 0.5, -12)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 13
closeBtn.TextColor3 = THEME.red
closeBtn.BackgroundColor3 = THEME.card
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
round(closeBtn, 4)
stroke(closeBtn, THEME.border)

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 24)
minimizeBtn.Position = UDim2.new(1, -74, 0.5, -12)
minimizeBtn.Text = "—"
minimizeBtn.Font = Enum.Font.Code
minimizeBtn.TextSize = 13
minimizeBtn.TextColor3 = THEME.accent
minimizeBtn.BackgroundColor3 = THEME.card
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
round(minimizeBtn, 4)
stroke(minimizeBtn, THEME.border)

local minimized = false
local savedSize
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        savedSize = main.Size
        main:TweenSize(UDim2.new(0, 760, 0, 34), Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad, 0.25, true)
    else
        main:TweenSize(UDim2.new(0, 760, 0, 520), Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad, 0.25, true)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    -- matikan semua loop sebelum keluar
    for _, conn in pairs(State.refireLoops) do
        pcall(function() conn:Disconnect() end)
    end
    if State.tracerHighlight then pcall(function() State.tracerHighlight:Destroy() end) end
    if State.mouseTracerOn and State.tracerConn then
        pcall(function() State.tracerConn:Disconnect() end)
    end
    if oldNamecall and State.hookInstalled and State.hookStyle ~= "hookmetamethod" then
        pcall(function()
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            mt.__namecall = oldNamecall
            setreadonly(mt, true)
        end)
    end
    screenGui:Destroy()
    notify("Bye!", "Ninja Remote Tool ditutup")
end)

-- drag manual (kalau UIDragDetector tidak ada)
do
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ---------- TAB BAR ----------
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 32)
tabBar.Position = UDim2.new(0, 0, 0, 34)
tabBar.BackgroundColor3 = THEME.bg
tabBar.BorderSizePixel = 0
tabBar.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Parent = tabBar
pad(tabBar, 8)

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, 0, 1, -66)
contentArea.Position = UDim2.new(0, 0, 0, 66)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.Parent = main

local tabs = {}
local tabOrder = { "SCAN", "SPY", "OBJEK", "TOOLS" }
local currentTab = "SCAN"

local function selectTab(name)
    currentTab = name
    for tabName, btn in pairs(tabs) do
        if tabName == name then
            TweenService:Create(btn, TweenInfo.new(0.15),
                { BackgroundColor3 = THEME.accent }):Play()
            btn.TextColor3 = THEME.bg
        else
            TweenService:Create(btn, TweenInfo.new(0.15),
                { BackgroundColor3 = THEME.card }):Play()
            btn.TextColor3 = THEME.dim
        end
    end
    for tabName, page in pairs(UI.pages) do
        page.Visible = (tabName == name)
    end
end

for _, name in ipairs(tabOrder) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 80, 0, 24)
    b.Text = name
    b.Font = Enum.Font.Code
    b.TextSize = 12
    b.BackgroundColor3 = THEME.card
    b.TextColor3 = THEME.dim
    b.BorderSizePixel = 0
    b.Parent = tabBar
    round(b, 4)
    stroke(b, THEME.border)
    tabs[name] = b
    b.MouseButton1Click:Connect(function() selectTab(name) end)
end

UI.pages = {}
UI.tabs = tabs

-- helper bikin halaman
local function newPage(name)
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.Visible = false
    p.Parent = contentArea
    UI.pages[name] = p
    return p
end

--=====================================================================
-- 8A. HALAMAN SCAN
--=====================================================================
local pageScan = newPage("SCAN")

local scanTitle = mkText(pageScan, "REMOTE SCANNER — scan semua remote di seluruh game",
    UDim2.new(1, -16, 0, 20))
scanTitle.Position = UDim2.new(0, 8, 0, 6)
scanTitle.TextColor3 = THEME.accent

local scanInfo = mkText(pageScan, "RemoteEvent • RemoteFunction • UnreliableRemoteEvent • BindableEvent • BindableFunction",
    UDim2.new(1, -16, 0, 14))
scanInfo.Position = UDim2.new(0, 8, 0, 26)
scanInfo.TextColor3 = THEME.dim
scanInfo.TextSize = 11

local scanSearch = Instance.new("TextBox")
scanSearch.Size = UDim2.new(1, -380, 0, 26)
scanSearch.Position = UDim2.new(0, 8, 0, 46)
scanSearch.PlaceholderText = "🔍 Filter nama remote (mis. Egg / Treadmill / Networking)..."
scanSearch.Text = ""
scanSearch.TextColor3 = THEME.text
scanSearch.PlaceholderColor3 = THEME.dim
scanSearch.BackgroundColor3 = THEME.bg2
scanSearch.TextSize = 12
scanSearch.Font = Enum.Font.Code
scanSearch.ClearTextOnFocus = false
scanSearch.BorderSizePixel = 0
scanSearch.Parent = pageScan
round(scanSearch, 4)
stroke(scanSearch, THEME.border)

local scanStatus = mkText(pageScan, "", UDim2.new(1, -16, 0, 14))
scanStatus.Position = UDim2.new(0, 8, 0, 76)
scanStatus.TextColor3 = THEME.blue
scanStatus.TextSize = 11

local scanScroll = Instance.new("ScrollingFrame")
scanScroll.Size = UDim2.new(1, -16, 1, -130)
scanScroll.Position = UDim2.new(0, 8, 0, 96)
scanScroll.BackgroundColor3 = THEME.bg2
scanScroll.BorderSizePixel = 0
scanScroll.ScrollBarThickness = 4
scanScroll.ScrollBarImageColor3 = THEME.accent
scanScroll.Parent = pageScan
round(scanScroll, 6)

local scanList = Instance.new("UIListLayout")
scanList.SortOrder = Enum.SortOrder.LayoutOrder
scanList.Padding = UDim.new(0, 2)
scanList.Parent = scanScroll

-- tombol-tombol scan
local btnRescan = mkButton(pageScan, "🔄 Rescan", UDim2.new(0, 110, 0, 26),
    UDim2.new(1, -258, 0, 46), function() rescanRemotes() end, THEME.accent)
local btnCopyList = mkButton(pageScan, "📋 Copy Semua Path", UDim2.new(0, 130, 0, 26),
    UDim2.new(1, -140, 0, 46), function()
        local lines = {}
        for _, r in ipairs(ScanCache) do table.insert(lines, r.path) end
        if #lines == 0 then notify("Kosong", "Belum ada hasil scan") return end
        setClip(table.concat(lines, "\n"))
        notify("Copied!", #lines .. " path remote di-copy")
    end, THEME.accent2)

ScanCache = ScanCache or {}

local scanRows = {}   -- pool baris untuk reuse

local function clearScanRows()
    for _, row in ipairs(scanRows) do row:Destroy() end
    scanRows = {}
end

local rowEntryMap = {}

local function makeScanRow(index, r)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 44)
    row.BackgroundColor3 = (index % 2 == 0) and THEME.bg or THEME.bg2
    row.BorderSizePixel = 0
    row.Parent = scanScroll
    round(row, 4)

    rowEntryMap[row] = r

    local tagColor = (r.tag == "RF") and THEME.accent2
        or (r.tag == "RE") and THEME.accent
        or (r.tag == "URE") and THEME.blue
        or THEME.dim

    local tag = Instance.new("TextLabel")
    tag.Size = UDim2.new(0, 36, 0, 16)
    tag.Position = UDim2.new(0, 6, 0, 4)
    tag.BackgroundColor3 = tagColor
    tag.Text = r.tag
    tag.Font = Enum.Font.Code
    tag.TextSize = 10
    tag.TextColor3 = THEME.bg
    tag.BorderSizePixel = 0
    tag.Parent = row
    round(tag, 3)

    local nameLabel = mkText(row, r.obj.Name, UDim2.new(1, -190, 0, 16))
    nameLabel.Position = UDim2.new(0, 48, 0, 4)
    nameLabel.TextColor3 = THEME.text
    nameLabel.TextSize = 12
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local pathLabel = mkText(row, r.path, UDim2.new(1, -190, 0, 14))
    pathLabel.Position = UDim2.new(0, 48, 0, 22)
    pathLabel.TextColor3 = THEME.dim
    pathLabel.TextSize = 10
    pathLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local btnFire = mkButton(row, "F", UDim2.new(0, 24, 0, 18),
        UDim2.new(1, -108, 0, 4), function()
            local entry = rowEntryMap[row]
            if not entry or not entry.obj.Parent then
                notify("Gagal", "Remote sudah tidak ada")
                return
            end
            local method = (entry.tag == "RF" or entry.tag == "BF")
                and "InvokeServer" or "FireServer"
            if entry.tag == "BE" then method = "Fire" end
            if entry.tag == "BF" then method = "Invoke" end
            callingFromHook = true
            local ok = pcall(function()
                if method == "InvokeServer" then
                    entry.obj:InvokeServer()
                elseif method == "Invoke" then
                    entry.obj:Invoke()
                else
                    entry.obj:FireServer()
                end
            end)
            callingFromHook = false
            if ok then notify("Terkirim!", method .. " → " .. entry.obj.Name)
            else notify("Gagal", "Remote menolak " .. method) end
        end, THEME.accent)

    local btnCode = mkButton(row, "</>", UDim2.new(0, 34, 0, 18),
        UDim2.new(1, -80, 0, 4), function()
            local entry = rowEntryMap[row]
            if not entry or not entry.obj.Parent then return end
            local method = (entry.tag == "RF" or entry.tag == "BF")
                and "InvokeServer" or "FireServer"
            if entry.tag == "BE" then method = "Fire" end
            if entry.tag == "BF" then method = "Invoke" end
            local code = buildInvokeCode(entry.obj, method, {})
            setClip(code)
            notify("Code di-copy!", entry.obj.Name .. " (tanpa args)")
        end, THEME.blue)

    local btnCopyPath = mkButton(row, "📋", UDim2.new(0, 30, 0, 18),
        UDim2.new(1, -80, 0, 24), function()
            local entry = rowEntryMap[row]
            if not entry then return end
            setClip(entry.path)
            notify("Path di-copy!", entry.obj.Name)
        end, THEME.accent2)

    local btnKids = mkButton(row, "👁", UDim2.new(0, 30, 0, 18),
        UDim2.new(1, -44, 0, 24), function()
            local entry = rowEntryMap[row]
            if not entry or not entry.obj.Parent then return end
            local kids = safeGetChildren(entry.obj)
            local lines = { "Children dari " .. entry.obj.Name .. ":" }
            for i, k in ipairs(kids) do
                if i > 50 then table.insert(lines, "... (" .. #kids .. " total)")
                    break end
                table.insert(lines, "  [" .. k.ClassName .. "] " .. k.Name)
            end
            if #kids == 0 then table.insert(lines, "  (tidak ada children)") end
            setClip(table.concat(lines, "\n"))
            notify("Children di-copy!", #kids .. " anak — cek clipboard")
        end, THEME.dim)

    -- klik baris = copy full path
    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local entry = rowEntryMap[row]
            if entry then
                setClip(entry.path)
                notify("Path di-copy!", entry.obj.Name)
            end
        end
    end)

    return row
end

local function renderScan(filter)
    clearScanRows()
    rowEntryMap = {}
    filter = string.lower(filter or "")
    local shown = 0
    for _, r in ipairs(ScanCache) do
        if filter == "" or string.find(string.lower(r.path), filter, 1, true) then
            shown = shown + 1
            if shown > 500 then break end
            makeScanRow(shown, r)
        end
    end
    scanScroll.CanvasSize = UDim2.new(0, 0, 0, shown * 46 + 8)
    scanStatus.Text = ("Hasil: %d/%d remote  •  RE=%d  RF=%d  URE=%d  BE=%d  BF=%d")
        :format(shown, #ScanCache, tagCount.RE or 0, tagCount.RF or 0,
            tagCount.URE or 0, tagCount.BE or 0, tagCount.BF or 0)
end

tagCount = tagCount or {}

function rescanRemotes()
    scanStatus.Text = "⏳ Scanning..."
    task.delay(0.05, function()
        local results = scanAllRemotes()
        ScanCache = results
        tagCount = { RE = 0, RF = 0, URE = 0, BE = 0, BF = 0 }
        for _, r in ipairs(results) do
            tagCount[r.tag] = (tagCount[r.tag] or 0) + 1
        end
        renderScan(scanSearch.Text)
        notify("Scan selesai!", #results .. " remote ditemukan")
    end)
end

scanSearch:GetPropertyChangedSignal("Text"):Connect(function()
    renderScan(scanSearch.Text)
end)

--=====================================================================
-- 8B. HALAMAN SPY
--=====================================================================
local pageSpy = newPage("SPY")

local spyTitle = mkText(pageSpy, "REMOTE SPY — klik tombol di game, remote-nya ketangkep otomatis",
    UDim2.new(1, -16, 0, 20))
spyTitle.Position = UDim2.new(0, 8, 0, 6)
spyTitle.TextColor3 = THEME.accent

local spyInfo = mkText(pageSpy, "Hook __namecall: FireServer / InvokeServer / Fire / Invoke + semua argumen",
    UDim2.new(1, -16, 0, 14))
spyInfo.Position = UDim2.new(0, 8, 0, 26)
spyInfo.TextColor3 = THEME.dim
spyInfo.TextSize = 11

local spyToggleBtn = Instance.new("TextButton")
spyToggleBtn.Size = UDim2.new(0, 150, 0, 26)
spyToggleBtn.Position = UDim2.new(0, 8, 0, 46)
spyToggleBtn.Text = "🔴 SPY: OFF"
spyToggleBtn.Font = Enum.Font.Code
spyToggleBtn.TextSize = 12
spyToggleBtn.TextColor3 = THEME.text
spyToggleBtn.BackgroundColor3 = THEME.card
spyToggleBtn.BorderSizePixel = 0
spyToggleBtn.Parent = pageSpy
round(spyToggleBtn, 4)
stroke(spyToggleBtn, THEME.border)

local spyStatus = mkText(pageSpy, "Status: mati — klik tombol di game setelah SPY dinyalakan",
    UDim2.new(1, -330, 0, 14))
spyStatus.Position = UDim2.new(0, 170, 0, 52)
spyStatus.TextColor3 = THEME.dim
spyStatus.TextSize = 11

mkToggle(pageSpy, "Auto-copy saat capture", UDim2.new(0, 185, 0, 22),
    UDim2.new(0, 8, 0, 80), false, function(v)
        State.copyOnCapture = v
    end)

mkToggle(pageSpy, "Abaikan spam (remote sama + args sama)",
    UDim2.new(0, 250, 0, 22), UDim2.new(0, 200, 0, 80), true, function(v)
        State.spyIgnoreRepeat = v
    end)

local spyCounter = mkText(pageSpy, "Capture: 0", UDim2.new(0, 120, 0, 14),
    THEME.accent2, nil, 11)
spyCounter.Position = UDim2.new(1, -128, 0, 52)

local spyScroll = Instance.new("ScrollingFrame")
spyScroll.Size = UDim2.new(1, -16, 1, -102)
spyScroll.Position = UDim2.new(0, 8, 0, 102)
spyScroll.BackgroundColor3 = THEME.bg2
spyScroll.BorderSizePixel = 0
spyScroll.ScrollBarThickness = 4
spyScroll.ScrollBarImageColor3 = THEME.accent
spyScroll.Parent = pageSpy
round(spyScroll, 6)

local spyList = Instance.new("UIListLayout")
spyList.SortOrder = Enum.SortOrder.LayoutOrder
spyList.Padding = UDim.new(0, 2)
spyList.Parent = spyScroll

local spyBtnClear = mkButton(pageSpy, "🗑 Clear", UDim2.new(0, 70, 0, 22),
    UDim2.new(0, 470, 0, 80), function()
        for _, row in ipairs(spyRows) do row:Destroy() end
        spyRows = {}
        State.logLines = {}
        State.logCount = 0
        State.captureCount = 0
        spyCounter.Text = "Capture: 0"
    end, THEME.red)

local spyBtnCopyLog = mkButton(pageSpy, "📋 Copy Log", UDim2.new(0, 90, 0, 22),
    UDim2.new(0, 548, 0, 80), function()
        if #State.logLines == 0 then notify("Kosong", "Belum ada capture") return end
        setClip(table.concat(State.logLines, "\n"))
        notify("Copied!", #State.logLines .. " baris log")
    end, THEME.accent2)

local spyBtnSaveLog = mkButton(pageSpy, "💾 Save Log", UDim2.new(0, 86, 0, 22),
    UDim2.new(0, 646, 0, 80), function()
        if not writefile then notify("Tidak bisa", "Executor tanpa writefile") return end
        if #State.logLines == 0 then notify("Kosong", "Belum ada capture") return end
        local header = {
            "-- Ninja Remote Tool v2 — Log Spy",
            "-- Game: " .. game.PlaceId,
            "-- Waktu: " .. os.date("%Y-%m-%d %H:%M:%S"),
            "",
        }
        pcall(function()
            writefile("NinjaRemoteSpy_Log.lua",
                table.concat(header, "\n") .. table.concat(State.logLines, "\n\n"))
        end)
        notify("Saved!", "NinjaRemoteSpy_Log.lua (folder executor)")
    end, THEME.blue)

spyRows = spyRows or {}
State.captureCount = 0
State.lastSignature = nil

local function addLogEntry(entry)
    -- entry = table { remote, remoteName, remotePath, class, method, args, caller, owner, code }
    local sig = entry.remotePath .. "|" .. entry.method .. "|"
        .. argsShort(entry.args, 99)
    if State.spyIgnoreRepeat and sig == State.lastSignature then
        return  -- spam yang sama berturut-turut tidak ditampilkan lagi
    end
    State.lastSignature = sig

    State.captureCount = State.captureCount + 1
    spyCounter.Text = "Capture: " .. State.captureCount

    -- ===== buat baris log =====
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 66)
    row.BackgroundColor3 = (State.captureCount % 2 == 0) and THEME.bg or THEME.bg2
    row.BorderSizePixel = 0
    row.Parent = spyScroll
    round(row, 4)
    table.insert(spyRows, row)
    if #spyRows > 120 then
        local old = table.remove(spyRows, 1)
        old:Destroy()
    end

    local methodColor = (entry.method == "InvokeServer" or entry.method == "Invoke")
        and THEME.accent2 or THEME.accent

    local tag = Instance.new("TextLabel")
    tag.Size = UDim2.new(0, 70, 0, 15)
    tag.Position = UDim2.new(0, 5, 0, 3)
    tag.BackgroundColor3 = methodColor
    tag.Text = entry.method
    tag.Font = Enum.Font.Code
    tag.TextSize = 9
    tag.TextColor3 = THEME.bg
    tag.BorderSizePixel = 0
    tag.Parent = row
    round(tag, 3)

    local nameLabel = mkText(row, entry.remoteName, UDim2.new(1, -320, 0, 15))
    nameLabel.Position = UDim2.new(0, 80, 0, 3)
    nameLabel.TextColor3 = THEME.text
    nameLabel.TextSize = 11
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local pathLabel = mkText(row, entry.remotePath, UDim2.new(1, -320, 0, 12))
    pathLabel.Position = UDim2.new(0, 80, 0, 18)
    pathLabel.TextColor3 = THEME.dim
    pathLabel.TextSize = 9
    pathLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local argsLabel = mkText(row, "args: " .. argsShort(entry.args, 4),
        UDim2.new(1, -320, 0, 12))
    argsLabel.Position = UDim2.new(0, 80, 0, 32)
    argsLabel.TextColor3 = THEME.blue
    argsLabel.TextSize = 9
    argsLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local metaLabel = mkText(row,
        "caller: " .. tostring(entry.caller) .. "   owner: " .. tostring(entry.owner),
        UDim2.new(1, -320, 0, 12))
    metaLabel.Position = UDim2.new(0, 80, 0, 46)
    metaLabel.TextColor3 = THEME.dim
    metaLabel.TextSize = 9
    metaLabel.TextTruncate = Enum.TextTruncate.AtEnd

    -- tombol aksi per-log (rapi kanan→kiri, tanpa tabrakan)
    mkButton(row, "📋 Code", UDim2.new(0, 60, 0, 18), UDim2.new(1, -244, 0, 6),
        function()
            setClip(entry.code)
            notify("Code di-copy!", entry.remoteName .. " — siap paste ke executor")
        end, THEME.accent2)

    mkButton(row, "📋 Log", UDim2.new(0, 54, 0, 18), UDim2.new(1, -180, 0, 6),
        function()
            local lines = {
                "[" .. entry.class .. "] " .. entry.remoteName,
                "Path   : " .. entry.remotePath,
                "Method : " .. entry.method,
                "Caller : " .. tostring(entry.caller),
                "Owner  : " .. tostring(entry.owner),
                "Args   :",
            }
            for i, a in ipairs(entry.args) do
                table.insert(lines, "  [" .. i .. "] " .. serialize(a))
            end
            if #entry.args == 0 then table.insert(lines, "  (tanpa args)") end
            table.insert(lines, "")
            table.insert(lines, "-- contoh code:")
            table.insert(lines, entry.code)
            setClip(table.concat(lines, "\n"))
            notify("Log di-copy!", entry.remoteName)
        end, THEME.blue)

    mkButton(row, "🔥 Refire", UDim2.new(0, 70, 0, 18), UDim2.new(1, -244, 0, 28),
        function()
            refireCall(entry)
        end, THEME.accent)

    mkButton(row, "🔁", UDim2.new(0, 26, 0, 18), UDim2.new(1, -168, 0, 28),
        function()
            toggleAutoRefire(entry)
        end, THEME.accent2)

    mkButton(row, "❌", UDim2.new(0, 24, 0, 18), UDim2.new(1, -138, 0, 28),
        function()
            if State.refireLoops[entry] then
                State.refireLoops[entry]:Disconnect()
                State.refireLoops[entry] = nil
            end
            table.remove(spyRows, table.find(spyRows, row))
            row:Destroy()
        end, THEME.red)

    -- simpan log ke state
    local logText = string.format(
        "[%s] %s:%s\n  Path  : %s\n  Caller: %s\n  Owner : %s\n  Args  : %s\n  Code  :\n%s",
        entry.class, entry.remoteName, entry.method, entry.remotePath,
        tostring(entry.caller), tostring(entry.owner),
        argsShort(entry.args, 99), entry.code)
    pushStateLog(logText)

    -- auto scroll ke bawah
    spyScroll.CanvasSize = UDim2.new(0, 0, 0, #spyRows * 68 + 8)
    spyScroll.CanvasPosition = Vector2.new(0, math.max(0, #spyRows * 68 - spyScroll.AbsoluteSize.Y))

    -- auto copy
    if State.copyOnCapture then
        setClip(entry.code)
    end
end

UI.addLogEntry = addLogEntry

-- tombol ON/OFF spy
local function setSpyState(on)
    if on then
        if not installHook() then
            spyToggleBtn.Text = "⚠ SPY: BLOCKED"
            spyStatus.Text = "Status: executor tidak mengizinkan hook — coba executor lain"
            return
        end
        State.spyActive = true
        spyToggleBtn.Text = "🟢 SPY: ON"
        spyStatus.Text = "Status: AKTIF — sekarang klik tombol yang kamu mau di game"
        notify("SPY ON", "Klik tombol apapun di game!")
    else
        State.spyActive = false
        spyToggleBtn.Text = "🔴 SPY: OFF"
        spyStatus.Text = "Status: mati — hook tetap terpasang, tinggal nyalakan lagi"
    end
end

spyToggleBtn.MouseButton1Click:Connect(function()
    setSpyState(not State.spyActive)
end)

--=====================================================================
-- 8C. HALAMAN OBJEK
--=====================================================================
local pageObj = newPage("OBJEK")

local objTitle = mkText(pageObj, "OBJECT FINDER — cari nama benda apa pun di dalam map",
    UDim2.new(1, -16, 0, 20))
objTitle.Position = UDim2.new(0, 8, 0, 6)
objTitle.TextColor3 = THEME.accent

local objInfo = mkText(pageObj, 'Contoh: AreaEggSlotsClient / Egg / Treadmill / nama benda apapun',
    UDim2.new(1, -16, 0, 14))
objInfo.Position = UDim2.new(0, 8, 0, 26)
objInfo.TextColor3 = THEME.dim
objInfo.TextSize = 11

local objSearch = Instance.new("TextBox")
objSearch.Size = UDim2.new(1, -330, 0, 26)
objSearch.Position = UDim2.new(0, 8, 0, 46)
objSearch.PlaceholderText = "🔍 Ketik nama objek... (mis. AreaEggSlotsClient)"
objSearch.Text = ""
objSearch.TextColor3 = THEME.text
objSearch.PlaceholderColor3 = THEME.dim
objSearch.BackgroundColor3 = THEME.bg2
objSearch.TextSize = 12
objSearch.Font = Enum.Font.Code
objSearch.ClearTextOnFocus = false
objSearch.BorderSizePixel = 0
objSearch.Parent = pageObj
round(objSearch, 4)
stroke(objSearch, THEME.border)

local objStatus = mkText(pageObj, "Hasil: 0", UDim2.new(1, -240, 0, 16),
    THEME.blue, nil, 11)
objStatus.Position = UDim2.new(0, 8, 0, 78)

local objBtnSearch = mkButton(pageObj, "🔍 Cari", UDim2.new(0, 100, 0, 26),
    UDim2.new(1, -322, 0, 46), function() runObjSearch() end, THEME.accent)

local objBtnTrace = mkButton(pageObj, "🖱 Trace Mouse", UDim2.new(0, 110, 0, 26),
    UDim2.new(1, -214, 0, 46), function() toggleMouseTracer() end, THEME.accent2)

local objBtnCopyNames = mkButton(pageObj, "📋 Copy Nama", UDim2.new(0, 95, 0, 24),
    UDim2.new(1, -214, 0, 76), function()
        local lines = {}
        for _, o in ipairs(ObjCache) do table.insert(lines, o.Name) end
        if #lines == 0 then notify("Kosong", "Cari dulu") return end
        setClip(table.concat(lines, "\n"))
        notify("Copied!", #lines .. " nama objek")
    end, THEME.blue)

local objBtnCopyPaths = mkButton(pageObj, "📋 Copy Path", UDim2.new(0, 95, 0, 24),
    UDim2.new(1, -106, 0, 76), function()
        local lines = {}
        for _, o in ipairs(ObjCache) do
            table.insert(lines, safeGetFullName(o))
        end
        if #lines == 0 then notify("Kosong", "Cari dulu") return end
        setClip(table.concat(lines, "\n"))
        notify("Copied!", #lines .. " path objek")
    end, THEME.blue)

local objScroll = Instance.new("ScrollingFrame")
objScroll.Size = UDim2.new(1, -16, 1, -114)
objScroll.Position = UDim2.new(0, 8, 0, 104)
objScroll.BackgroundColor3 = THEME.bg2
objScroll.BorderSizePixel = 0
objScroll.ScrollBarThickness = 4
objScroll.ScrollBarImageColor3 = THEME.accent
objScroll.Parent = pageObj
round(objScroll, 6)

local objListLayout = Instance.new("UIListLayout")
objListLayout.SortOrder = Enum.SortOrder.LayoutOrder
objListLayout.Padding = UDim.new(0, 2)
objListLayout.Parent = objScroll

ObjCache = ObjCache or {}
objRows = objRows or {}

local function clearObjRows()
    for _, row in ipairs(objRows) do row:Destroy() end
    objRows = {}
end

local function makeObjRow(index, obj)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 40)
    row.BackgroundColor3 = (index % 2 == 0) and THEME.bg or THEME.bg2
    row.BorderSizePixel = 0
    row.Parent = objScroll
    round(row, 4)
    table.insert(objRows, row)

    local classTag = Instance.new("TextLabel")
    classTag.Size = UDim2.new(0, 90, 0, 14)
    classTag.Position = UDim2.new(0, 5, 0, 4)
    classTag.BackgroundColor3 = THEME.dim
    classTag.Text = obj.ClassName
    classTag.Font = Enum.Font.Code
    classTag.TextSize = 9
    classTag.TextColor3 = THEME.bg
    classTag.BorderSizePixel = 0
    classTag.Parent = row
    round(classTag, 3)

    local nameLabel = mkText(row, obj.Name, UDim2.new(1, -220, 0, 14))
    nameLabel.Position = UDim2.new(0, 100, 0, 4)
    nameLabel.TextColor3 = THEME.text
    nameLabel.TextSize = 11
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local pathLabel = mkText(row, safeGetFullName(obj), UDim2.new(1, -220, 0, 12))
    pathLabel.Position = UDim2.new(0, 100, 0, 20)
    pathLabel.TextColor3 = THEME.dim
    pathLabel.TextSize = 9
    pathLabel.TextTruncate = Enum.TextTruncate.AtEnd

    mkButton(row, "📋 Path", UDim2.new(0, 56, 0, 16), UDim2.new(1, -188, 0, 4),
        function()
            setClip(safeGetFullName(obj))
            notify("Path di-copy!", obj.Name)
        end, THEME.accent)

    mkButton(row, "👁 Kids", UDim2.new(0, 56, 0, 16), UDim2.new(1, -126, 0, 4),
        function()
            local kids = safeGetChildren(obj)
            local lines = { "[" .. obj.ClassName .. "] " .. safeGetFullName(obj) }
            for i, k in ipairs(kids) do
                if i > 80 then table.insert(lines, "... (" .. #kids .. " total)") break end
                table.insert(lines, "  [" .. k.ClassName .. "] " .. k.Name)
            end
            if #kids == 0 then table.insert(lines, "  (tidak ada children)") end
            setClip(table.concat(lines, "\n"))
            notify("Children di-copy!", #kids .. " anak")
        end, THEME.blue)

    mkButton(row, "🎯 TP", UDim2.new(0, 44, 0, 16), UDim2.new(1, -64, 0, 4),
        function()
            pcall(function()
                if obj:IsA("BasePart") then
                    LocalPlayer.Character:PivotTo(obj.CFrame + Vector3.new(0, 4, 0))
                elseif obj:IsA("Model") then
                    LocalPlayer.Character:PivotTo(obj:GetPivot() + Vector3.new(0, 4, 0))
                else
                    notify("TP gagal", obj.ClassName .. " bukan part/model")
                end
            end)
        end, THEME.accent2)

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setClip(safeGetFullName(obj))
            notify("Path di-copy!", obj.Name)
        end
    end)
end

function runObjSearch()
    local term = objSearch.Text
    if term == "" then
        notify("Kosong", "Ketik nama yang mau dicari dulu")
        return
    end
    objStatus.Text = "⏳ Mencari..."
    task.delay(0.05, function()
        ObjCache = findObjects(term)
        clearObjRows()
        local shown = 0
        for _, obj in ipairs(ObjCache) do
            shown = shown + 1
            if shown > 200 then break end
            makeObjRow(shown, obj)
        end
        objScroll.CanvasSize = UDim2.new(0, 0, 0, shown * 42 + 8)
        objStatus.Text = "Hasil: " .. #ObjCache .. " objek" ..
            (#ObjCache > 200 and " (menampilkan 200)" or "")
        notify("Selesai!", #ObjCache .. " objek ditemukan")
    end)
end

objSearch.FocusLost:Connect(function(enter)
    if enter then runObjSearch() end
end)

-- ---------- MOUSE TRACER ----------
toggleMouseTracer = toggleMouseTracer or function() end

function toggleMouseTracer()
    State.mouseTracerOn = not State.mouseTracerOn
    if State.mouseTracerOn then
        objBtnTrace.Text = "🟢 Tracer ON"
        if not State.tracerHighlight then
            State.tracerHighlight = Instance.new("Highlight")
            State.tracerHighlight.Name = "NinjaTracer"
            State.tracerHighlight.FillColor = Color3.fromRGB(0, 255, 170)
            State.tracerHighlight.FillTransparency = 0.7
            State.tracerHighlight.OutlineColor = Color3.fromRGB(0, 255, 170)
            State.tracerHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
        State.tracerHighlight.Parent = workspace -- sementara
        State.tracerConn = RunService.RenderStepped:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target then
                State.tracerHighlight.Adornee = target
                objStatus.Text = "🎯 " .. safeGetFullName(target)
            else
                State.tracerHighlight.Adornee = nil
                objStatus.Text = "🎯 (arahkan kursor ke benda)"
            end
        end)
        notify("Tracer ON", "Arahkan kursor ke benda — status bar jadi path-nya")
    else
        objBtnTrace.Text = "🖱 Trace Mouse"
        if State.tracerConn then State.tracerConn:Disconnect() end
        if State.tracerHighlight then
            State.tracerHighlight.Adornee = nil
            State.tracerHighlight.Parent = nil
        end
        objStatus.Text = "Hasil: " .. #ObjCache .. " objek"
        notify("Tracer OFF", "Mouse tracer dimatikan")
    end
end

--=====================================================================
-- 8D. HALAMAN TOOLS
--=====================================================================
local pageTools = newPage("TOOLS")

local toolTitle = mkText(pageTools, "TOOLS EXTRA", UDim2.new(1, -16, 0, 20))
toolTitle.Position = UDim2.new(0, 8, 0, 6)
toolTitle.TextColor3 = THEME.accent

local toolInfo = mkText(pageTools,
    "Console Copy: buka DevConsole (F9) → tiap baris log ada tombol [C] buat copy 1 baris.",
    UDim2.new(1, -16, 0, 14))
toolInfo.Position = UDim2.new(0, 8, 0, 26)
toolInfo.TextColor3 = THEME.dim
toolInfo.TextSize = 11

-- toggle console copy
local consoleActive = false
local consoleBtn  -- deklarasi dulu supaya bisa dipakai dalam callback-nya sendiri
consoleBtn = mkButton(pageTools, "▶ Nyalakan Console Copy [C]",
    UDim2.new(0, 210, 0, 28), UDim2.new(0, 8, 0, 50), function()
        consoleActive = not consoleActive
        if consoleActive then
            installConsoleCopy()
            consoleBtn.Text = "■ Matikan Console Copy [C]"
        else
            if State.consoleConn then State.consoleConn:Disconnect() end
            State.consoleConn = nil
            State.consoleInstalled = nil
            consoleBtn.Text = "▶ Nyalakan Console Copy [C]"
            notify("Console Copy OFF", "Tombol [C] dimatikan")
        end
    end, THEME.accent2)

-- info keybind
local kb1 = mkText(pageTools, "KEYBIND:", UDim2.new(0, 100, 0, 16), THEME.accent, nil, 12)
kb1.Position = UDim2.new(0, 8, 0, 96)

local kb2 = mkText(pageTools,
    "  [ RightControl ]  —  buka/tutup UI  \n  [ LeftAlt ]  —  toggle SPY on/off  \n  [ F ]  —  refire capture terakhir",
    UDim2.new(1, -16, 0, 54))
kb2.Position = UDim2.new(0, 8, 0, 114)
kb2.TextColor3 = THEME.text
kb2.TextSize = 11
kb2.TextWrapped = true

-- info place
local placeInfo = mkText(pageTools,
    "Place: " .. tostring(game.PlaceId) ..
    "  •  JobId: " .. tostring(game.JobId) ..
    "  •  Clipboard: " .. (hasClipboard() and "OK" or "fallback TextBox"),
    UDim2.new(1, -16, 0, 16))
placeInfo.Position = UDim2.new(0, 8, 1, -24)
placeInfo.TextColor3 = THEME.dim
placeInfo.TextSize = 10

--=====================================================================
-- 9. CONSOLE COPY (tombol [C] di DevConsole)
--=====================================================================
local function addCopyButton(label)
    if not label:FindFirstChild("NinjaCopyBtn") then
        local btn = Instance.new("TextButton")
        btn.Name = "NinjaCopyBtn"
        btn.Size = UDim2.new(0, 30, 0, 20)
        btn.BackgroundTransparency = 1
        btn.Text = "[C]"
        btn.TextColor3 = label.TextColor3
        btn.Font = label.Font
        btn.TextSize = label.TextSize
        btn.TextTransparency = 0.5
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = label
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not btn.Parent then
                conn:Disconnect()
                return
            end
            local tb = label.TextBounds
            if tb.X > 0 then
                btn.AnchorPoint = Vector2.new(0, 0.5)
                if string.find(label.Text, "\n") then
                    local last = label.Text:match("([^\n]*)$")
                    local size = TextService:GetTextSize(last, label.TextSize,
                        label.Font, Vector2.new(label.AbsoluteSize.X, math.huge))
                    btn.Position = UDim2.new(0, size.X + 5, 1, -label.TextSize / 2)
                else
                    btn.Position = UDim2.new(0, tb.X + 5, 0.5, 0)
                end
                conn:Disconnect()
            end
        end)
        btn.MouseEnter:Connect(function() btn.TextTransparency = 0 end)
        btn.MouseLeave:Connect(function() btn.TextTransparency = 0.5 end)
        btn.MouseButton1Click:Connect(function()
            setClip(label.Text)
            btn.Text = "[✓]"
            task.delay(0.3, function() btn.Text = "[C]" end)
        end)
    end
end

function installConsoleCopy()
    if State.consoleInstalled then
        return  -- sudah aktif, jangan double-hook (bocor koneksi)
    end
    State.consoleInstalled = true

    local consoleHooked = false
    local function hookConsole()
        local dcm = CoreGui:FindFirstChild("DevConsoleMaster")
        if not dcm then return end
        local dcw = dcm:FindFirstChild("DevConsoleWindow")
        if not dcw then return end
        local dcui = dcw:FindFirstChild("DevConsoleUI")
        if not dcui then return end
        local mv = dcui:FindFirstChild("MainView")
        if not mv then return end
        local cl = mv:FindFirstChild("ClientLog")
        if not cl then return end
        if cl:FindFirstChild("NinjaHooked") then return end

        local marker = Instance.new("BoolValue")
        marker.Name = "NinjaHooked"
        marker.Parent = cl

        consoleHooked = true
        local function scanLabels(container)
            pcall(function()
                for _, lbl in ipairs(container:GetDescendants()) do
                    if lbl:IsA("TextLabel") then
                        addCopyButton(lbl)
                    end
                end
            end)
        end

        for _, frame in ipairs(cl:GetChildren()) do
            if frame:IsA("Frame") or frame:IsA("ScrollingFrame") then
                scanLabels(frame)
            end
        end
        cl.ChildAdded:Connect(function(child)
            task.wait(0.15)
            if child then scanLabels(child) end
        end)
        cl.DescendantAdded:Connect(function(desc)
            if desc:IsA("TextLabel") then
                task.wait(0.05)
                addCopyButton(desc)
            end
        end)
    end

    hookConsole()
    local timer = 0
    State.consoleConn = RunService.Heartbeat:Connect(function(delta)
        timer = timer + delta
        if timer > 1 then
            timer = 0
            -- console bisa dibuka-tutup lagi; re-hook bila perlu (aman, ada marker)
            if not consoleHooked or not CoreGui:FindFirstChild("DevConsoleMaster") then
                consoleHooked = false
                pcall(hookConsole)
            end
        end
    end)
    notify("Console Copy ON", "Buka F9 — tiap baris ada tombol [C]")
end

--=====================================================================
-- 10. KEYBIND GLOBAL
--=====================================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        screenGui.Enabled = not screenGui.Enabled
    elseif input.KeyCode == Enum.KeyCode.LeftAlt then
        setSpyState(not State.spyActive)
        if screenGui.Enabled == false then screenGui.Enabled = true end
    elseif input.KeyCode == Enum.KeyCode.F then
        local lastEntry = UI.lastEntry
        if lastEntry then refireCall(lastEntry) end
    end
end)

--=====================================================================
-- 11. SPY: simpan entry terakhir untuk keybind F
--=====================================================================
local oldAddLogEntry = UI.addLogEntry
UI.addLogEntry = function(entry)
    UI.lastEntry = entry
    oldAddLogEntry(entry)
end

--=====================================================================
-- 12. INIT
--=====================================================================
selectTab("SCAN")
rescanRemotes()

notify("Ninja Remote Tool v2", "Loaded! 4 tab: SCAN • SPY • OBJEK • TOOLS")
print("============================================")
print("  NINJA REMOTE TOOL v2 — aktif")
print("  • Tab SCAN  : semua remote di game + copy")
print("  • Tab SPY   : klik tombol → remote ketangkep")
print("  • Tab OBJEK : cari nama benda di map")
print("  • Tab TOOLS : console copy F9 + keybind")
print("  Keybind: RightControl=UI, LeftAlt=SPY, F=refire")
print("============================================")
