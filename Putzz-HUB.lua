-- ================== DRIP CLIENT - FULL EDITION ==================
-- By Putzzdev

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Warna
local cyan = Color3.fromRGB(0, 255, 255)
local dark = Color3.fromRGB(10, 10, 15)

-- Database Key
local DB_URL = "https://key-database-701af-default-rtdb.asia-southeast1.firebasedatabase.app/keys.json"
local WEB_URL = "https://putzzdevxit.github.io/KEY-GENERATOR-/"

-- ================== FITUR VARIABEL ==================
local flyEnabled = false
local flyConn = nil
local flySpeed = 50
local flyBV = nil
local flyBG = nil
local vert = 0
local horiz = 0
local touchingFly = false
local touchStart = nil

local speedEnabled = false
local noclipEnabled = false
local noclipConn = nil
local jumpEnabled = false
local godEnabled = false
local godConn = nil
local spinEnabled = false
local spinConn = nil
local spinDir = 1
local espEnabled = false
local espLines = {}

-- ================== FUNGSI CEK KEY ==================
local function cekKey(key)
    local success, data = pcall(function()
        return game:HttpGet(DB_URL, true)
    end)
    if success and data then
        local success2, json = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success2 and json then
            for _, k in pairs(json) do
                if k.key and string.upper(k.key) == string.upper(key) then
                    return true
                end
            end
        end
    end
    return false
end

-- ================== FLY ==================
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    if not torso then return end
    if torso:FindFirstChild("FlyBV") then torso.FlyBV:Destroy() end
    if torso:FindFirstChild("FlyBG") then torso.FlyBG:Destroy() end
    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "FlyBV"
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Parent = torso
    flyBG = Instance.new("BodyGyro")
    flyBG.Name = "FlyBG"
    flyBG.P = 9e4
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.Parent = torso
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end
    if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
    if flyConn then flyConn:Disconnect() end
    flyConn = RunService.RenderStepped:Connect(function()
        if not flyEnabled then return end
        local ct = LocalPlayer.Character
        if not ct then return end
        local t = ct:FindFirstChild("UpperTorso") or ct:FindFirstChild("Torso") or ct:FindFirstChild("HumanoidRootPart")
        if not t then return end
        local b = t:FindFirstChild("FlyBV")
        local g = t:FindFirstChild("FlyBG")
        if not b or not g then return end
        local cf = Camera.CFrame
        local f = cf.LookVector
        local r = cf.RightVector
        local u = cf.UpVector
        local dir = f
        if horiz ~= 0 then
            local ang = horiz * 0.5
            dir = (f * math.cos(ang) + r * math.sin(ang)).Unit
        end
        b.Velocity = (dir * flySpeed) + (u * vert * flySpeed * 0.7)
        g.CFrame = cf
    end)
end

local function stopFly()
    flyEnabled = false
    if flyConn then flyConn:Disconnect() flyConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
        if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
        local t = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        if t then
            if t:FindFirstChild("FlyBV") then t.FlyBV:Destroy() end
            if t:FindFirstChild("FlyBG") then t.FlyBG:Destroy() end
        end
    end
    vert = 0
    horiz = 0
end

-- Touch untuk Fly
UserInputService.TouchBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        touchingFly = true
        touchStart = input.Position
    end
end)
UserInputService.TouchMoved:Connect(function(input, gp)
    if gp then return end
    if not flyEnabled then return end
    if touchingFly and touchStart then
        local d = input.Position - touchStart
        vert = math.abs(d.Y) > 15 and (d.Y < 0 and 1 or -1) or 0
        horiz = math.abs(d.X) > 15 and (d.X < 0 and -1 or 1) or 0
        touchStart = input.Position
    end
end)
UserInputService.TouchEnded:Connect(function()
    touchingFly = false
    vert = 0
    horiz = 0
end)

-- ================== NOCLIP ==================
local function updateNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end

-- ================== GOD MODE ==================
local function updateGod()
    if godConn then godConn:Disconnect() end
    godConn = RunService.Heartbeat:Connect(function()
        if godEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        end
    end)
end

-- ================== SPIN ==================
local function updateSpin()
    if spinConn then spinConn:Disconnect() end
    spinConn = RunService.Heartbeat:Connect(function()
        if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(200 * spinDir), 0)
        end
    end)
end

-- ================== INFINITY JUMP ==================
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- ================== ESP LINE ==================
local function updateESP()
    for _, v in pairs(espLines) do pcall(function() v:Remove() end) end
    espLines = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local line = Drawing.new("Line")
            line.Thickness = 2
            line.Color = cyan
            line.Visible = false
            table.insert(espLines, {line, p})
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for _, v in pairs(espLines) do v[1].Visible = false end
        return
    end
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    for _, v in pairs(espLines) do
        local line, player = v[1], v[2]
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and myPos then
            local hrp = char.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            if vis then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end)

-- ================== RESPAWN ==================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flyEnabled then startFly() end
    if noclipEnabled then updateNoclip() end
    if speedEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 70 end
    end
end)

-- ================== GUI KEY ==================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "DripKeySystem"
KeyGui.Parent = game.CoreGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyGui
KeyFrame.Size = UDim2.new(0, 350, 0, 380)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -190)
KeyFrame.BackgroundColor3 = dark
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.Parent = KeyFrame
KeyCorner.CornerRadius = UDim.new(0, 20)

local KeyBorder = Instance.new("Frame")
KeyBorder.Parent = KeyFrame
KeyBorder.Size = UDim2.new(1, 0, 1, 0)
KeyBorder.BackgroundTransparency = 1
KeyBorder.BorderSizePixel = 2
KeyBorder.BorderColor3 = cyan
local KeyBorderCorner = Instance.new("UICorner")
KeyBorderCorner.Parent = KeyBorder
KeyBorderCorner.CornerRadius = UDim.new(0, 20)

local KeyIcon = Instance.new("TextLabel")
KeyIcon.Parent = KeyFrame
KeyIcon.Size = UDim2.new(1, 0, 0, 70)
KeyIcon.Position = UDim2.new(0, 0, 0, 15)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Text = "🔐"
KeyIcon.TextColor3 = cyan
KeyIcon.Font = Enum.Font.GothamBlack
KeyIcon.TextSize = 45

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Position = UDim2.new(0, 0, 0, 75)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "DRIP CLIENT AUTH"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16

local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = KeyFrame
InfoFrame.Size = UDim2.new(0.9, 0, 0, 80)
InfoFrame.Position = UDim2.new(0.05, 0, 0.26, 0)
InfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
InfoFrame.BackgroundTransparency = 0.3
InfoFrame.BorderSizePixel = 0
local InfoCorner = Instance.new("UICorner")
InfoCorner.Parent = InfoFrame
InfoCorner.CornerRadius = UDim.new(0, 12)

local InfoText = Instance.new("TextLabel")
InfoText.Parent = InfoFrame
InfoText.Size = UDim2.new(1, -20, 1, -10)
InfoText.Position = UDim2.new(0, 10, 0, 5)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Masukkan Key Anda\n\nTIPE KEY: 1 JAM | 1 HARI | 2 HARI | 3 HARI | 7 HARI | 30 HARI | PERMANEN"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 11
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextWrapped = true

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Parent = KeyFrame
KeyLabel.Size = UDim2.new(0.8, 0, 0, 20)
KeyLabel.Position = UDim2.new(0.1, 0, 0.52, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "MASUKAN KEY ANDA"
KeyLabel.TextColor3 = cyan
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextSize = 12

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.Position = UDim2.new(0.1, 0, 0.57, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyTextBox.BackgroundTransparency = 0.1
KeyTextBox.TextColor3 = Color3.new(1, 1, 1)
KeyTextBox.PlaceholderText = "Contoh: PutzzVIP"
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.TextSize = 14
KeyTextBox.ClearTextOnFocus = true
local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.Parent = KeyTextBox
KeyBoxCorner.CornerRadius = UDim.new(0, 10)

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = KeyFrame
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 45)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.72, 0)
VerifyBtn.BackgroundColor3 = cyan
VerifyBtn.BackgroundTransparency = 0.2
VerifyBtn.Text = "VERIFIKASI KEY"
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 16
local VerifyCorner = Instance.new("UICorner")
VerifyCorner.Parent = VerifyBtn
VerifyCorner.CornerRadius = UDim.new(0, 10)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = KeyFrame
GetKeyBtn.Size = UDim2.new(0.5, 0, 0, 35)
GetKeyBtn.Position = UDim2.new(0.25, 0, 0.86, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
GetKeyBtn.BackgroundTransparency = 0.2
GetKeyBtn.Text = "🌐 GET KEY"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14
local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.Parent = GetKeyBtn
GetKeyCorner.CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = KeyFrame
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.93, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔑 Masukkan key"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

local LoadingCircle = Instance.new("Frame")
LoadingCircle.Parent = KeyFrame
LoadingCircle.Size = UDim2.new(0, 25, 0, 25)
LoadingCircle.Position = UDim2.new(0.5, -12, 0.96, -12)
LoadingCircle.BackgroundColor3 = cyan
LoadingCircle.BackgroundTransparency = 1
LoadingCircle.Visible = false
local CircleCorner = Instance.new("UICorner")
CircleCorner.Parent = LoadingCircle
CircleCorner.CornerRadius = UDim.new(1, 0)

local function showLoading(show)
    LoadingCircle.Visible = show
    if show then
        task.spawn(function()
            local r = 0
            while LoadingCircle and LoadingCircle.Visible do
                r = (r + 5) % 360
                LoadingCircle.Rotation = r
                task.wait(0.01)
            end
        end)
    end
end

GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(WEB_URL)
            StatusLabel.Text = "✅ Link disalin!"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(2)
            StatusLabel.Text = "🔑 Masukkan key"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end)

-- ================== VERIFIKASI ==================
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyTextBox.Text:gsub("%s+", "")
    if key == "" then
        StatusLabel.Text = "❌ Masukkan key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    showLoading(true)
    StatusLabel.Text = "⏳ Verifikasi..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    VerifyBtn.Text = "⏳ VERIFIKASI..."
    
    local valid = cekKey(key)
    
    showLoading(false)
    VerifyBtn.Text = "VERIFIKASI KEY"
    
    if valid then
        StatusLabel.Text = "✅ KEY VALID!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        TweenService:Create(KeyFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
        task.wait(0.3)
        
        for i = 3, 1, -1 do
            StatusLabel.Text = "Loading " .. i .. "..."
            task.wait(1)
        end
        
        KeyGui:Destroy()
        
        -- Notifikasi
        local notif = Instance.new("ScreenGui")
        notif.Parent = game.CoreGui
        local nf = Instance.new("Frame")
        nf.Parent = notif
        nf.Size = UDim2.new(0, 280, 0, 50)
        nf.Position = UDim2.new(0.5, -140, 0.5, -25)
        nf.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        nf.BackgroundTransparency = 0.1
        local nc = Instance.new("UICorner")
        nc.Parent = nf
        nc.CornerRadius = UDim.new(0, 12)
        local nt = Instance.new("TextLabel")
        nt.Parent = nf
        nt.Size = UDim2.new(1, 0, 1, 0)
        nt.BackgroundTransparency = 1
        nt.Text = "✅ DRIP CLIENT ACTIVATED!"
        nt.TextColor3 = Color3.fromRGB(255, 255, 255)
        nt.Font = Enum.Font.GothamBold
        nt.TextSize = 16
        task.wait(2)
        notif:Destroy()
        
        -- ================== MENU UTAMA ==================
        local MenuGui = Instance.new("ScreenGui")
        MenuGui.Name = "DripClient"
        MenuGui.Parent = game.CoreGui
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Parent = MenuGui
        MainFrame.Size = UDim2.new(0, 300, 0, 400)
        MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
        MainFrame.BackgroundColor3 = dark
        MainFrame.BackgroundTransparency = 0.1
        MainFrame.Active = true
        MainFrame.Draggable = true
        MainFrame.Visible = true
        
        local MainCorner = Instance.new("UICorner")
        MainCorner.Parent = MainFrame
        MainCorner.CornerRadius = UDim.new(0, 20)
        
        local Border = Instance.new("Frame")
        Border.Parent = MainFrame
        Border.Size = UDim2.new(1, 0, 1, 0)
        Border.BackgroundTransparency = 1
        Border.BorderSizePixel = 2
        Border.BorderColor3 = cyan
        local BorderCorner = Instance.new("UICorner")
        BorderCorner.Parent = Border
        BorderCorner.CornerRadius = UDim.new(0, 20)
        
        local Header = Instance.new("Frame")
        Header.Parent = MainFrame
        Header.Size = UDim2.new(1, 0, 0, 50)
        Header.BackgroundColor3 = cyan
        Header.BackgroundTransparency = 0.15
        Header.BorderSizePixel = 0
        local HeaderCorner = Instance.new("UICorner")
        HeaderCorner.Parent = Header
        HeaderCorner.CornerRadius = UDim.new(0, 20)
        
        local Title = Instance.new("TextLabel")
        Title.Parent = Header
        Title.Size = UDim2.new(1, 0, 1, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "DRIP CLIENT"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = 20
        
        local Content = Instance.new("ScrollingFrame")
        Content.Parent = MainFrame
        Content.Size = UDim2.new(0.94, 0, 0.78, 0)
        Content.Position = UDim2.new(0.03, 0, 0.16, 0)
        Content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        Content.BackgroundTransparency = 0.4
        Content.BorderSizePixel = 0
        Content.ScrollBarThickness = 5
        Content.ScrollBarImageColor3 = cyan
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local ContentCorner = Instance.new("UICorner")
        ContentCorner.Parent = Content
        ContentCorner.CornerRadius = UDim.new(0, 12)
        
        local Layout = Instance.new("UIListLayout")
        Layout.Parent = Content
        Layout.Padding = UDim.new(0, 8)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- Fungsi Toggle
        local function addToggle(text, callback)
            local f = Instance.new("Frame")
            f.Parent = Content
            f.Size = UDim2.new(0.95, 0, 0, 42)
            f.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            f.BackgroundTransparency = 0.2
            f.BorderSizePixel = 0
            local fc = Instance.new("UICorner")
            fc.Parent = f
            fc.CornerRadius = UDim.new(0, 8)
            
            local lbl = Instance.new("TextLabel")
            lbl.Parent = f
            lbl.Size = UDim2.new(0.7, 0, 1, 0)
            lbl.Position = UDim2.new(0.05, 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local sw = Instance.new("Frame")
            sw.Parent = f
            sw.Size = UDim2.new(0, 42, 0, 22)
            sw.Position = UDim2.new(0.82, 0, 0.5, -11)
            sw.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            sw.BorderSizePixel = 0
            local swc = Instance.new("UICorner")
            swc.Parent = sw
            swc.CornerRadius = UDim.new(0, 11)
            
            local circle = Instance.new("Frame")
            circle.Parent = sw
            circle.Size = UDim2.new(0, 18, 0, 18)
            circle.Position = UDim2.new(0.05, 0, 0.5, -9)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle.BorderSizePixel = 0
            local circ = Instance.new("UICorner")
            circ.Parent = circle
            circ.CornerRadius = UDim.new(1, 0)
            
            local state = false
            local btn = Instance.new("TextButton")
            btn.Parent = f
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.MouseButton1Click:Connect(function()
                state = not state
                sw.BackgroundColor3 = state and cyan or Color3.fromRGB(80, 80, 90)
                circle.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0.05, 0, 0.5, -9)
                callback(state)
            end)
        end
        
        -- Slider Fly Speed
        local flyFrame = Instance.new("Frame")
        flyFrame.Parent = Content
        flyFrame.Size = UDim2.new(0.95, 0, 0, 50)
        flyFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        flyFrame.BackgroundTransparency = 0.2
        flyFrame.BorderSizePixel = 0
        local flyCorner = Instance.new("UICorner")
        flyCorner.Parent = flyFrame
        flyCorner.CornerRadius = UDim.new(0, 8)
        
        local flyLabel = Instance.new("TextLabel")
        flyLabel.Parent = flyFrame
        flyLabel.Size = UDim2.new(0.45, 0, 1, 0)
        flyLabel.Position = UDim2.new(0.05, 0, 0, 0)
        flyLabel.BackgroundTransparency = 1
        flyLabel.Text = "🚀 Fly Speed: 50"
        flyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        flyLabel.Font = Enum.Font.Gotham
        flyLabel.TextSize = 12
        flyLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Parent = flyFrame
        sliderBar.Size = UDim2.new(0.35, 0, 0, 5)
        sliderBar.Position = UDim2.new(0.55, 0, 0.5, -2.5)
        sliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        sliderBar.BorderSizePixel = 0
        local barCorner = Instance.new("UICorner")
        barCorner.Parent = sliderBar
        barCorner.CornerRadius = UDim.new(1, 0)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBar
        sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        sliderFill.BackgroundColor3 = cyan
        sliderFill.BorderSizePixel = 0
        local fillCorner = Instance.new("UICorner")
        fillCorner.Parent = sliderFill
        fillCorner.CornerRadius = UDim.new(1, 0)
        
        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Parent = sliderBar
        sliderBtn.Size = UDim2.new(0, 16, 0, 16)
        sliderBtn.Position = UDim2.new(0.5, -8, 0.5, -8)
        sliderBtn.BackgroundColor3 = cyan
        sliderBtn.BorderSizePixel = 0
        sliderBtn.Text = ""
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = sliderBtn
        btnCorner.CornerRadius = UDim.new(1, 0)
        
        local dragging = false
        sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local barPos = sliderBar.AbsolutePosition.X
                local barW = sliderBar.AbsoluteSize.X
                local percent = math.clamp((input.Position.X - barPos) / barW, 0, 1)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderBtn.Position = UDim2.new(percent, -8, 0.5, -8)
                flySpeed = math.floor(percent * 80 + 20)
                flyLabel.Text = "🚀 Fly Speed: " .. flySpeed
            end
        end)
        
        -- TAMBAH FITUR
        addToggle("✈️ FLY MODE", function(s)
            flyEnabled = s
            if s then startFly() else stopFly() end
        end)
        
        addToggle("⚡ SPEED BOOST", function(s)
            speedEnabled = s
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = s and 70 or 16 end
        end)
        
        addToggle("🌀 NOCLIP", function(s)
            noclipEnabled = s
            if s then updateNoclip() end
        end)
        
        addToggle("🦘 INFINITY JUMP", function(s)
            jumpEnabled = s
        end)
        
        addToggle("📏 ESP LINE", function(s)
            espEnabled = s
            if s then updateESP() end
        end)
        
        addToggle("💀 GOD MODE", function(s)
            godEnabled = s
            if s then updateGod() elseif godConn then godConn:Disconnect() end
        end)
        
        addToggle("🌀 SPIN", function(s)
            spinEnabled = s
            if s then updateSpin() elseif spinConn then spinConn:Disconnect() end
        end)
        
        -- Tombol ganti arah spin
        local spinBtnFrame = Instance.new("Frame")
        spinBtnFrame.Parent = Content
        spinBtnFrame.Size = UDim2.new(0.95, 0, 0, 42)
        spinBtnFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        spinBtnFrame.BackgroundTransparency = 0.2
        spinBtnFrame.BorderSizePixel = 0
        local spinBtnCorner = Instance.new("UICorner")
        spinBtnCorner.Parent = spinBtnFrame
        spinBtnCorner.CornerRadius = UDim.new(0, 8)
        
        local spinBtn = Instance.new("TextButton")
        spinBtn.Parent = spinBtnFrame
        spinBtn.Size = UDim2.new(1, 0, 1, 0)
        spinBtn.BackgroundTransparency = 1
        spinBtn.Text = "🔄 GANTI ARAH SPIN"
        spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        spinBtn.Font = Enum.Font.GothamBold
        spinBtn.TextSize = 13
        spinBtn.MouseButton1Click:Connect(function()
            spinDir = spinDir * -1
        end)
        
        -- Info
        local infoFrame = Instance.new("Frame")
        infoFrame.Parent = Content
        infoFrame.Size = UDim2.new(0.95, 0, 0, 80)
        infoFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        infoFrame.BackgroundTransparency = 0.2
        infoFrame.BorderSizePixel = 0
        local infoCorner = Instance.new("UICorner")
        infoCorner.Parent = infoFrame
        infoCorner.CornerRadius = UDim.new(0, 8)
        
        local infoText = Instance.new("TextLabel")
        infoText.Parent = infoFrame
        infoText.Size = UDim2.new(1, 0, 1, 0)
        infoText.BackgroundTransparency = 1
        infoText.Text = "DRIP CLIENT V7.5\n\n👨‍💻 Putzzdev\n📱 TikTok: @Putzz_mvpp\n📞 WA: 088976255131"
        infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 11
        infoText.TextWrapped = true
        
        -- Tombol toggle menu
        local menuBtn = Instance.new("TextButton")
        menuBtn.Parent = MenuGui
        menuBtn.Size = UDim2.new(0, 85, 0, 38)
        menuBtn.Position = UDim2.new(0, 10, 0.5, -19)
        menuBtn.BackgroundColor3 = cyan
        menuBtn.BackgroundTransparency = 0.2
        menuBtn.Text = "🔓 DRIP"
        menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        menuBtn.Font = Enum.Font.GothamBlack
        menuBtn.TextSize = 12
        menuBtn.Draggable = true
        local menuCorner = Instance.new("UICorner")
        menuCorner.Parent = menuBtn
        menuCorner.CornerRadius = UDim.new(0, 10)
        
        local menuVisible = true
        menuBtn.MouseButton1Click:Connect(function()
            menuVisible = not menuVisible
            MainFrame.Visible = menuVisible
        end)
        
        print("✅ DRIP CLIENT - SEMUA FITUR READY!")
        
    else
        StatusLabel.Text = "❌ KEY INVALID!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        for i = 1, 3 do
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(100, 0, 0)}):Play()
            task.wait(0.05)
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = dark}):Play()
            task.wait(0.05)
        end
        task.wait(1.5)
        StatusLabel.Text = "🔑 Masukkan key"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        KeyTextBox.Text = ""
    end
end)

print("🔐 DRIP CLIENT READY - Masukkan key: PutzzVIP")