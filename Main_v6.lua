--========================================================--
--   SCRIPTBLOX INVISIBLE 8809 + NO-DEATH OFF FIX
--========================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local isInvisible = false

local function toggleInvisibility()
    isInvisible = not isInvisible
    local player = localPlayer
    local char = player.Character
    
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    if isInvisible then
        -- 1. Metode Invisible ON (ScriptBlox Method)
        local position = char.HumanoidRootPart.Position
        task.wait(0.1)
        char:MoveTo(position + Vector3.new(0, 1000000, 0))
        task.wait(0.1)
        
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local humanoidrootpart = rootPart:Clone()
            task.wait(0.1)
            rootPart:Destroy()
            humanoidrootpart.Parent = char
            char:MoveTo(position)
        end
        
        pcall(function()
            game.StarterGui:SetCore("SendNotification", { Title = "Invisible: ON"; Duration = 1; Text = "Active & Hidden"; })
        end)
    else
        -- 2. Metode Invisible OFF (Tanpa Mati / Cukup Reset Transparansi & Posisi)
        -- Jika ingin kembali normal tanpa harus mati total, kita kembalikan part tubuh jadi terlihat
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 0
            elseif v:IsA("Accessory") then
                local h = v:FindFirstChild("Handle")
                if h then h.Transparency = 0 end
            end
        end
        
        -- Memunculkan notifikasi bahwa mode invis sudah mati
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
        invisBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Hijau
    else
        invisBtn.Text = "Invis: OFF"
        invisBtn.BackgroundColor3 = Color3.fromRGB(255, 138, 42) -- Oranye
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
memedog.Text = "No-Death Off Fix"
memedog.TextColor3 = Color3.fromRGB(0, 255, 0)
memedog.TextSize = 14

die.Name = "die"
die.Parent = Main
die.BackgroundTransparency = 1
die.Position = UDim2.new(0.01, 0, 0.72, 0)
die.Size = UDim2.new(0, 246, 0, 23)
die.Font = Enum.Font.SourceSansLight
die.Text = "Smooth Toggle"
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
