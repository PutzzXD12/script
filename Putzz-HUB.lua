-- ================== DRIP CLIENT V7.5 - SIMPLE FIX ==================
-- Developer: Putzz XD

local FIREBASE_URL = "https://key-database-701af-default-rtdb.asia-southeast1.firebasedatabase.app/keys.json"
local WEBSITE_URL = "https://putzzdevxit.github.io/KEY-GENERATOR-/"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Warna
local themeColor = Color3.fromRGB(156, 39, 176)
local darkPurple = Color3.fromRGB(74, 20, 90)

-- ================== FUNGSI CEK KEY (SEDERHANA) ==================
local function cekKey(key)
    local success, data = pcall(function()
        return game:HttpGet(FIREBASE_URL, true)
    end)
    if success and data then
        local success2, json = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success2 and json then
            for _, k in pairs(json) do
                if k.key and string.upper(k.key) == string.upper(key) then
                    return true, k.jenis or "PERMANEN"
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
KeyFrame.Size = UDim2.new(0, 400, 0, 420)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -210)
KeyFrame.BackgroundColor3 = darkPurple
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.Parent = KeyFrame
KeyCorner.CornerRadius = UDim.new(0, 20)

local KeyHeader = Instance.new("Frame")
KeyHeader.Parent = KeyFrame
KeyHeader.Size = UDim2.new(1, 0, 0, 80)
KeyHeader.BackgroundTransparency = 1

local KeyIcon = Instance.new("TextLabel")
KeyIcon.Parent = KeyHeader
KeyIcon.Size = UDim2.new(1, 0, 0.5, 0)
KeyIcon.Position = UDim2.new(0, 0, 0, 10)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Text = "🔐"
KeyIcon.TextColor3 = themeColor
KeyIcon.Font = Enum.Font.GothamBlack
KeyIcon.TextSize = 45

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyHeader
KeyTitle.Size = UDim2.new(1, 0, 0.5, 0)
KeyTitle.Position = UDim2.new(0, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "DRIP CLIENT AUTH"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16

local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = KeyFrame
InfoFrame.Size = UDim2.new(0.9, 0, 0, 90)
InfoFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
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
InfoText.Text = "Masukkan Key Anda untuk mengakses script premium\n\nTIPE KEY: 1 JAM | 1 HARI | 2 HARI | 3 HARI | 7 HARI | 30 HARI | PERMANEN"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 12
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextWrapped = true

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Parent = KeyFrame
KeyLabel.Size = UDim2.new(0.8, 0, 0, 20)
KeyLabel.Position = UDim2.new(0.1, 0, 0.40, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "MASUKAN KEY ANDA"
KeyLabel.TextColor3 = themeColor
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextSize = 12

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.Position = UDim2.new(0.1, 0, 0.44, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyTextBox.BackgroundTransparency = 0.1
KeyTextBox.TextColor3 = Color3.new(1, 1, 1)
KeyTextBox.PlaceholderText = "Masukkan key..."
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.TextSize = 14
KeyTextBox.ClearTextOnFocus = true
KeyTextBox.Text = "PutzzVIP"

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.Parent = KeyTextBox
KeyBoxCorner.CornerRadius = UDim.new(0, 10)

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = KeyFrame
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 45)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.57, 0)
VerifyBtn.BackgroundColor3 = themeColor
VerifyBtn.BackgroundTransparency = 0.2
VerifyBtn.Text = "VERIFIKASI KEY"
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 16

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.Parent = VerifyBtn
VerifyCorner.CornerRadius = UDim.new(0, 10)

local WebsiteBtn = Instance.new("TextButton")
WebsiteBtn.Parent = KeyFrame
WebsiteBtn.Size = UDim2.new(0.5, 0, 0, 35)
WebsiteBtn.Position = UDim2.new(0.25, 0, 0.69, 0)
WebsiteBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
WebsiteBtn.BackgroundTransparency = 0.2
WebsiteBtn.Text = "GET KEY"
WebsiteBtn.TextColor3 = Color3.new(1, 1, 1)
WebsiteBtn.Font = Enum.Font.GothamBold
WebsiteBtn.TextSize = 14

local WebsiteCorner = Instance.new("UICorner")
WebsiteCorner.Parent = WebsiteBtn
WebsiteCorner.CornerRadius = UDim.new(0, 8)

local StatusFrame = Instance.new("Frame")
StatusFrame.Parent = KeyFrame
StatusFrame.Size = UDim2.new(0.9, 0, 0, 50)
StatusFrame.Position = UDim2.new(0.05, 0, 0.80, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
StatusFrame.BackgroundTransparency = 0.3
StatusFrame.BorderSizePixel = 0

local StatusCorner = Instance.new("UICorner")
StatusCorner.Parent = StatusFrame
StatusCorner.CornerRadius = UDim.new(0, 10)

local StatusIcon = Instance.new("TextLabel")
StatusIcon.Parent = StatusFrame
StatusIcon.Size = UDim2.new(0, 30, 1, 0)
StatusIcon.Position = UDim2.new(0, 5, 0, 0)
StatusIcon.BackgroundTransparency = 1
StatusIcon.Text = "🔒"
StatusIcon.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusIcon.Font = Enum.Font.GothamBold
StatusIcon.TextSize = 18

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusFrame
StatusLabel.Size = UDim2.new(1, -40, 1, 0)
StatusLabel.Position = UDim2.new(0, 35, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Masukkan Key Anda"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextWrapped = true

-- ================== TOMBOL GET KEY ==================
WebsiteBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(WEBSITE_URL)
            StatusLabel.Text = "✓ Link disalin! Buka browser"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            StatusIcon.Text = "✅"
            task.wait(2)
            StatusLabel.Text = "Masukkan Key Anda"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            StatusIcon.Text = "🔒"
        end
    end)
end)

-- ================== TOMBOL VERIFIKASI (DIREKAT ULANG) ==================
VerifyBtn.MouseButton1Click:Connect(function()
    print("Tombol VERIFIKASI ditekan!") -- DEBUG
    local inputKey = KeyTextBox.Text:gsub("%s+", "")
    
    if inputKey == "" then
        StatusLabel.Text = "❌ Masukkan key terlebih dahulu!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        StatusIcon.Text = "❌"
        return
    end
    
    StatusLabel.Text = "⏳ Memverifikasi..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    StatusIcon.Text = "⏳"
    VerifyBtn.Text = "⏳ VERIFIKASI..."
    VerifyBtn.BackgroundTransparency = 0.5
    
    local isValid, jenis = cekKey(inputKey)
    
    VerifyBtn.Text = "VERIFIKASI KEY"
    VerifyBtn.BackgroundTransparency = 0.2
    
    if isValid then
        StatusLabel.Text = "✅ KEY VALID! (" .. (jenis or "PERMANEN") .. ")"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        StatusIcon.Text = "✅"
        
        TweenService:Create(KeyFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
        task.wait(0.3)
        
        -- Hapus GUI Key
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
        frame.Size = UDim2.new(0, 300, 0, 400)
        frame.Position = UDim2.new(0.5, -150, 0.5, -200)
        frame.BackgroundColor3 = darkPurple
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.Draggable = true
        
        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 20)
        
        local header = Instance.new("Frame")
        header.Parent = frame
        header.Size = UDim2.new(1, 0, 0, 50)
        header.BackgroundColor3 = themeColor
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
        title.TextSize = 20
        
        local content = Instance.new("ScrollingFrame")
        content.Parent = frame
        content.Size = UDim2.new(0.94, 0, 0.8, 0)
        content.Position = UDim2.new(0.03, 0, 0.14, 0)
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
        
        -- Fungsi toggle
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
                sw.BackgroundColor3 = state and themeColor or Color3.fromRGB(80, 80, 90)
                circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0.05, 0, 0.5, -8)
                callback(state)
            end)
        end
        
        -- Variabel fitur sederhana
        local flyEnabled = false
        local flyConn = nil
        local flyBV = nil
        local flyBG = nil
        local vert = 0
        local horiz = 0
        local touchingFly = false
        local touchStart = nil
        
        -- Fly function
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
        
        -- Tambah toggle ke menu
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
        
        -- Info label
        local infoFrame = Instance.new("Frame")
        infoFrame.Parent = content
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
        infoText.Text = "DRIP CLIENT V7.5\n\nBy Putzzdev\nTikTok: @Putzz_mvpp"
        infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 12
        infoText.TextWrapped = true
        
        -- Tombol toggle menu
        local menuBtn = Instance.new("TextButton")
        menuBtn.Parent = gui
        menuBtn.Size = UDim2.new(0, 90, 0, 40)
        menuBtn.Position = UDim2.new(0, 10, 0.5, -20)
        menuBtn.BackgroundColor3 = themeColor
        menuBtn.BackgroundTransparency = 0.2
        menuBtn.Text = "⚡ DRIP"
        menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        menuBtn.Font = Enum.Font.GothamBlack
        menuBtn.TextSize = 13
        menuBtn.Draggable = true
        local menuCorner = Instance.new("UICorner")
        menuCorner.Parent = menuBtn
        menuCorner.CornerRadius = UDim.new(0, 12)
        
        local menuVisible = true
        menuBtn.MouseButton1Click:Connect(function()
            menuVisible = not menuVisible
            frame.Visible = menuVisible
        end)
        
        print("✅ MENU LOADED! Klik DRIP di pojok kiri")
    else
        StatusLabel.Text = "❌ " .. message
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        StatusIcon.Text = "❌"
        task.wait(2)
        StatusLabel.Text = "Masukkan Key Anda"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusIcon.Text = "🔒"
        KeyTextBox.Text = ""
    end
end)

print("🔐 DRIP CLIENT V7.5 - READY!")