-- ================== DRIP CLIENT - KEY SYSTEM ==================
-- Tipe Key: 1 HARI dan PERMANEN
-- Database: key-database-701af

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Konfigurasi
local DATABASE_URL = "https://key-database-701af-default-rtdb.asia-southeast1.firebasedatabase.app/keys.json"
local WEBSITE_URL = "https://putzzdevxit.github.io/KEY-GENERATOR-/"

-- Warna
local cyan = Color3.fromRGB(0, 255, 255)
local darkBg = Color3.fromRGB(10, 10, 15)

-- ================== FUNGSI CEK KEY ==================
local function checkKey(key)
    local success, data = pcall(function()
        return game:HttpGet(DATABASE_URL, true)
    end)
    if success and data then
        local success2, json = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success2 and json then
            for _, k in pairs(json) do
                if k.key and string.upper(k.key) == string.upper(key) then
                    local jenis = k.jenis or "1 HARI"
                    return true, jenis
                end
            end
        end
    end
    return false, nil
end

-- ================== BUAT GUI KEY ==================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "DripKeySystem"
KeyGui.Parent = game.CoreGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyGui
KeyFrame.Size = UDim2.new(0, 380, 0, 380)
KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -190)
KeyFrame.BackgroundColor3 = darkBg
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.BorderSizePixel = 0
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

-- Header
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
KeyTitle.Text = "DRIP CLIENT"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 20

-- Info
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
InfoText.Text = "Masukkan Key Anda\n\nTIPE KEY:\n📅 1 HARI  |  ♾️ PERMANEN"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 11
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextWrapped = true

-- Input Key
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

-- Tombol Verifikasi
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

-- Tombol GET KEY
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = KeyFrame
GetKeyBtn.Size = UDim2.new(0.5, 0, 0, 35)
GetKeyBtn.Position = UDim2.new(0.25, 0, 0.85, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
GetKeyBtn.BackgroundTransparency = 0.2
GetKeyBtn.Text = "🌐 GET KEY"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.Parent = GetKeyBtn
GetKeyCorner.CornerRadius = UDim.new(0, 8)

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = KeyFrame
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.92, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔑 Masukkan key"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

-- Loading
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

-- GET KEY button
GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(WEBSITE_URL)
            StatusLabel.Text = "✅ Link disalin! Buka browser"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(2)
            StatusLabel.Text = "🔑 Masukkan key"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end)

-- ================== TOMBOL VERIFIKASI ==================
VerifyBtn.MouseButton1Click:Connect(function()
    local inputKey = KeyTextBox.Text:gsub("%s+", "")
    
    if inputKey == "" then
        StatusLabel.Text = "❌ Masukkan key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1.5)
        StatusLabel.Text = "🔑 Masukkan key"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        return
    end
    
    showLoading(true)
    StatusLabel.Text = "⏳ Verifikasi..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    VerifyBtn.Text = "⏳ VERIFIKASI..."
    
    local isValid, jenis = checkKey(inputKey)
    
    showLoading(false)
    VerifyBtn.Text = "VERIFIKASI KEY"
    
    if isValid then
        StatusLabel.Text = "✅ KEY VALID! (" .. jenis .. ")"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        TweenService:Create(KeyFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
        task.wait(0.3)
        
        -- Loading countdown
        for i = 3, 1, -1 do
            StatusLabel.Text = "Loading " .. i .. "..."
            task.wait(1)
        end
        
        -- Hapus GUI key
        KeyGui:Destroy()
        
        -- Notifikasi sukses
        local notif = Instance.new("ScreenGui")
        notif.Parent = game.CoreGui
        local nf = Instance.new("Frame")
        nf.Parent = notif
        nf.Size = UDim2.new(0, 300, 0, 50)
        nf.Position = UDim2.new(0.5, -150, 0.5, -25)
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
        
        -- ================== MENU SEDERHANA ==================
        local gui = Instance.new("ScreenGui")
        gui.Name = "DripClient"
        gui.Parent = game.CoreGui
        
        local frame = Instance.new("Frame")
        frame.Parent = gui
        frame.Size = UDim2.new(0, 280, 0, 350)
        frame.Position = UDim2.new(0.5, -140, 0.5, -175)
        frame.BackgroundColor3 = darkBg
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.Draggable = true
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.Parent = frame
        frameCorner.CornerRadius = UDim.new(0, 20)
        
        local border = Instance.new("Frame")
        border.Parent = frame
        border.Size = UDim2.new(1, 0, 1, 0)
        border.BackgroundTransparency = 1
        border.BorderSizePixel = 2
        border.BorderColor3 = cyan
        local borderCorner = Instance.new("UICorner")
        borderCorner.Parent = border
        borderCorner.CornerRadius = UDim.new(0, 20)
        
        local header = Instance.new("Frame")
        header.Parent = frame
        header.Size = UDim2.new(1, 0, 0, 50)
        header.BackgroundColor3 = cyan
        header.BackgroundTransparency = 0.15
        header.BorderSizePixel = 0
        local headerCorner = Instance.new("UICorner")
        headerCorner.Parent = header
        headerCorner.CornerRadius = UDim.new(0, 20)
        
        local title = Instance.new("TextLabel")
        title.Parent = header
        title.Size = UDim2.new(1, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = "DRIP CLIENT"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 18
        
        local content = Instance.new("ScrollingFrame")
        content.Parent = frame
        content.Size = UDim2.new(0.94, 0, 0.78, 0)
        content.Position = UDim2.new(0.03, 0, 0.16, 0)
        content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        content.BackgroundTransparency = 0.4
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 5
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local contentCorner = Instance.new("UICorner")
        contentCorner.Parent = content
        contentCorner.CornerRadius = UDim.new(0, 12)
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = content
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- Toggle function
        local function addToggle(text, callback)
            local f = Instance.new("Frame")
            f.Parent = content
            f.Size = UDim2.new(0.95, 0, 0, 40)
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
            sw.Size = UDim2.new(0, 40, 0, 20)
            sw.Position = UDim2.new(0.85, 0, 0.5, -10)
            sw.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            sw.BorderSizePixel = 0
            local swc = Instance.new("UICorner")
            swc.Parent = sw
            swc.CornerRadius = UDim.new(0, 10)
            
            local circle = Instance.new("Frame")
            circle.Parent = sw
            circle.Size = UDim2.new(0, 16, 0, 16)
            circle.Position = UDim2.new(0.05, 0, 0.5, -8)
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
                circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0.05, 0, 0.5, -8)
                callback(state)
            end)
        end
        
        -- FLY variables
        local flyEnabled = false
        local flyConn = nil
        local flyBV = nil
        local flyBG = nil
        local vert = 0
        local horiz = 0
        local touchingFly = false
        local touchStart = nil
        
        -- FLY function
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
                b.Velocity = (dir * 50) + (u * vert * 35)
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
        
        -- Touch control
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
        
        -- Add toggles
        addToggle("✈️ FLY MODE", function(s)
            flyEnabled = s
            if s then startFly() else stopFly() end
        end)
        
        addToggle("⚡ SPEED BOOST", function(s)
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = s and 70 or 16 end
        end)
        
        addToggle("🌀 NOCLIP", function(s)
            if s then
                RunService.Stepped:Connect(function()
                    if LocalPlayer.Character then
                        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end
                end)
            end
        end)
        
        addToggle("🦘 INFINITY JUMP", function(s)
            if s then
                UserInputService.JumpRequest:Connect(function()
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                    end
                end)
            end
        end)
        
        addToggle("💀 GOD MODE", function(s)
            if s then
                RunService.Heartbeat:Connect(function()
                    if LocalPlayer.Character then
                        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
                    end
                end)
            end
        end)
        
        addToggle("🌀 SPIN", function(s)
            local spinDir = 1
            if s then
                RunService.Heartbeat:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(200 * spinDir), 0)
                    end
                end)
            end
        end)
        
        -- Info text
        local infoFrame = Instance.new("Frame")
        infoFrame.Parent = content
        infoFrame.Size = UDim2.new(0.95, 0, 0, 70)
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
        infoText.Text = "DRIP CLIENT\n\n👨‍💻 Putzzdev | 📱 @Putzz_mvpp"
        infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 11
        infoText.TextWrapped = true
        
        -- Menu toggle button
        local menuBtn = Instance.new("TextButton")
        menuBtn.Parent = gui
        menuBtn.Size = UDim2.new(0, 90, 0, 38)
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
            frame.Visible = menuVisible
        end)
        
        print("✅ DRIP CLIENT - MENU READY! Klik DRIP di pojok kiri")
        
    else
        StatusLabel.Text = "❌ KEY INVALID!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        for i = 1, 3 do
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(100, 0, 0)}):Play()
            task.wait(0.05)
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = darkBg}):Play()
            task.wait(0.05)
        end
        task.wait(1.5)
        StatusLabel.Text = "🔑 Masukkan key"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        KeyTextBox.Text = ""
    end
end)

print("🔐 DRIP CLIENT - Masukkan key: PutzzVIP")