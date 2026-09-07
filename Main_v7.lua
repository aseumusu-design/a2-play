--========================================================--
--   ULTIMATE CLONE INVISIBLE V2 (FIX POSISI JONGKOK/NYANGKUT)
--========================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local isInvisible = false
local fakeChar = nil
local connection = nil

local function toggleInvisibility()
    isInvisible = not isInvisible
    local player = localPlayer
    local char = player.Character
    
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    if isInvisible then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local savedPos = rootPart.CFrame

        -- 1. Buat klon karakter di atas sebagai badan visual kamu sendiri
        char.Archivable = true
        fakeChar = char:Clone()
        fakeChar.Name = "InvisClone"
        fakeChar.Parent = workspace
        char.Archivable = false

        -- Matikan script di klon biar gak bentrok
        for _, v in pairs(fakeChar:GetDescendants()) do
            if v:IsA("LocalScript") or v:IsA("Script") then
                v:Destroy()
            elseif v:IsA("BasePart") then
                v.Transparency = 0.5 -- Set agak transparan buat layar kamu sendiri
                v.CanCollide = false
            end
        end

        local cloneRoot = fakeChar:FindFirstChild("HumanoidRootPart")
        local cloneHum = fakeChar:FindFirstChildOfClass("Humanoid")
        if cloneRoot then
            cloneRoot.CFrame = savedPos
        end
        workspace.CurrentCamera.CameraSubject = cloneHum

        -- 2. Pindahkan badan asli ke bawah tanah dengan aman & cegah jongkok/nyangkut
        if humanoid then
            humanoid.PlatformStand = true
        end
        rootPart.CFrame = savedPos + Vector3.new(0, -10000, 0)
        rootPart.Anchored = true -- Kunci agar tidak jatuh atau ketarik gravitasi

        -- Sembunyikan total badan asli
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("Accessory") then
                local h = v:FindFirstChild("Handle")
                if h then h.Transparency = 1 end
            end
        end

        -- 3. Sinkronisasi pergerakan mulus
        connection = RunService.RenderStepped:Connect(function()
            if fakeChar and fakeChar:FindFirstChild("HumanoidRootPart") and rootPart and rootPart.Parent then
                local cRoot = fakeChar.HumanoidRootPart
                local cHum = fakeChar:FindFirstChildOfClass("Humanoid")

                if humanoid and cHum then
                    cHum:Move(humanoid.MoveDirection, false)
                    if humanoid.Jump then
                        cHum.Jump = true
                    end
                end
            end
        end)

        pcall(function()
            game.StarterGui:SetCore("SendNotification", { Title = "Invisible: ON"; Duration = 1; Text = "Clone Fixed Active"; })
        end)
    else
        -- KETIKA OFF: Lepaskan kuncian, kembalikan posisi, hapus klon TANPA MATI!
        if connection then
            connection:Disconnect()
            connection = nil
        end

        local rootPart = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")

        if rootPart then
            rootPart.Anchored = false
        end
        if humanoid then
            humanoid.PlatformStand = false
        end

        if fakeChar then
            local cloneRoot = fakeChar:FindFirstChild("HumanoidRootPart")
            if cloneRoot and rootPart then
                rootPart.CFrame = cloneRoot.CFrame
            end
            fakeChar:Destroy()
            fakeChar = nil
        end

        workspace.CurrentCamera.CameraSubject = humanoid

        -- Kembalikan transparansi badan asli jadi normal
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 0
            elseif v:IsA("Accessory") then
                local h = v:FindFirstChild("Handle")
                if h then h.Transparency = 0 end
            end
        end

        pcall(function()
            game.StarterGui:SetCore("SendNotification", { Title = "Invisible: OFF"; Duration = 1; Text = "Back to Normal"; })
        end)
    end
end

--========================================================--
-- GUI MENU TROLLER (DRAGGABLE & HOTKEY ;)
--========================================================--
local troller = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local nameofgui = Instance.new("TextLabel")
local border = Instance.new("Frame")
local invisBtn = Instance.new("TextButton")
local toggleUIBtn = Instance.new("TextButton")
local memedog = Instance.new("TextLabel")
local die = Instance.new("TextLabel")
local axy = Instance.new("TextLabel")

troller.Name = "troller"
troller.Parent = localPlayer:WaitForChild("PlayerGui")
troller.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
troller.ResetOnSpawn = false

Main.Name = "Main"
Main.Parent = troller
Main.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.045, 0, 0.087, 0)
Main.Size = UDim2.new(0, 248, 0, 220)

nameofgui.Name = "nameofgui"
nameofgui.Parent = Main
nameofgui.BackgroundTransparency = 1
nameofgui.Size = UDim2.new(0, 248, 0, 19)
nameofgui.Font = Enum.Font.GothamBold
nameofgui.Text = "Troller"
nameofgui.TextColor3 = Color3.fromRGB(255, 255, 255)
nameofgui.TextSize = 16
nameofgui.TextXAlignment = Enum.TextXAlignment.Left

border.Name = "border"
border.Parent = Main
border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
border.Position = UDim2.new(0, 0, 0.09, 0)
border.Size = UDim2.new(0, 248, 0, 1)

invisBtn.Name = "invis"
invisBtn.Parent = Main
invisBtn.BackgroundColor3 = Color3.fromRGB(255, 138, 42)
invisBtn.Position = UDim2.new(0, 0, 0.15, 0)
invisBtn.Size = UDim2.new(0, 248, 0, 32)
invisBtn.Font = Enum.Font.SourceSansItalic
invisBtn.Text = "Invis: OFF"
invisBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
invisBtn.TextSize = 16

invisBtn.MouseButton1Click:Connect(function()
    toggleInvisibility()
    if isInvisible then
        invisBtn.Text = "Invis: ON"
        invisBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        invisBtn.Text = "Invis: OFF"
        invisBtn.BackgroundColor3 = Color3.fromRGB(255, 138, 42)
    end
end)

toggleUIBtn.Name = "toggleUIBtn"
toggleUIBtn.Parent = Main
toggleUIBtn.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
toggleUIBtn.Position = UDim2.new(0, 0, 0.33, 0)
toggleUIBtn.Size = UDim2.new(0, 248, 0, 32)
toggleUIBtn.Font = Enum.Font.SourceSansBold
toggleUIBtn.Text = "UI ON / OFF (Click)"
toggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleUIBtn.TextSize = 14

memedog.Name = "memedog"
memedog.Parent = Main
memedog.BackgroundTransparency = 1
memedog.Position = UDim2.new(0.04, 0, 0.58, 0)
memedog.Size = UDim2.new(0, 200, 0, 23)
memedog.Font = Enum.Font.SourceSansLight
memedog.Text = "Clone Fix V2"
memedog.TextColor3 = Color3.fromRGB(0, 255, 0)
memedog.TextSize = 14

die.Name = "die"
die.Parent = Main
die.BackgroundTransparency = 1
die.Position = UDim2.new(0.01, 0, 0.72, 0)
die.Size = UDim2.new(0, 246, 0, 23)
die.Font = Enum.Font.SourceSansLight
die.Text = "No Glitch / Crouch"
die.TextColor3 = Color3.fromRGB(0, 255, 255)
die.TextSize = 14

axy.Name = "axy"
axy.Parent = Main
axy.BackgroundTransparency = 1
axy.Position = UDim2.new(0.01, 0, 0.85, 0)
axy.Size = UDim2.new(0, 246, 0, 23)
axy.Font = Enum.Font.SourceSansLight
axy.Text = "Press ; to hide or show"
axy.TextColor3 = Color3.fromRGB(255, 255, 0)
axy.TextSize = 14

local isHidden = false
local mouse = localPlayer:GetMouse()

function Draggable(frame)
    frame.Active = true
    frame.InputBegan:Connect(function(key)
        if key.UserInputType == Enum.UserInputType.MouseButton1 then
            local objectPosition = Vector2.new(mouse.X - frame.AbsolutePosition.X, mouse.Y - frame.AbsolutePosition.Y)
            while RunService.Heartbeat:Wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                frame:TweenPosition(UDim2.new(0, mouse.X - objectPosition.X + (frame.Size.X.Offset * frame.AnchorPoint.X), 0, mouse.Y - objectPosition.Y + (frame.Size.Y.Offset * frame.AnchorPoint.Y)), 'Out', 'Quad', 0.1, true)
            end
        end
    end)
end

Draggable(Main)

local function toggleMenu()
    if isHidden == false then
        Main:TweenPosition(Main.Position - UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.4, false)
        isHidden = true
    else
        Main:TweenPosition(Main.Position + UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.4, false)
        isHidden = false
    end
end

mouse.KeyDown:Connect(function(key)
    if key == ";" then
        toggleMenu()
    end
end)

toggleUIBtn.MouseButton1Click:Connect(function()
    toggleMenu()
end)
