-- ================== DRIP CLIENT - ESP LINE ONLY ==================
-- By Putzzdev
-- Cuma 1 fitur: garis dari atas layar ke player

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Warna garis (cyan)
local lineColor = Color3.fromRGB(0, 255, 255)

-- Tabel untuk menyimpan garis setiap player
local lines = {}

-- Buat garis untuk setiap player
local function createLine(player)
    if player == LocalPlayer then return end
    
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = lineColor
    line.Visible = false
    lines[player] = line
end

-- Hapus garis jika player keluar
local function removeLine(player)
    if lines[player] then
        lines[player]:Remove()
        lines[player] = nil
    end
end

-- Update posisi garis setiap frame
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position
    
    for player, line in pairs(lines) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and myPos then
            local hrp = char.HumanoidRootPart
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
            local distance = (myPos - hrp.Position).Magnitude
            
            -- Jarak maksimal 150 stud
            if visible and distance <= 150 then
                -- Dari atas layar (x tengah, y = 0) ke posisi player
                local fromX = Camera.ViewportSize.X / 2
                local fromY = 0
                
                line.From = Vector2.new(fromX, fromY)
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

-- Inisialisasi player yang sudah ada
for _, player in pairs(Players:GetPlayers()) do
    createLine(player)
end

-- Player masuk
Players.PlayerAdded:Connect(function(player)
    createLine(player)
end)

-- Player keluar
Players.PlayerRemoving:Connect(function(player)
    removeLine(player)
end)

-- Notifikasi
local notif = Instance.new("ScreenGui")
notif.Parent = game.CoreGui
local frame = Instance.new("Frame")
frame.Parent = notif
frame.Size = UDim2.new(0, 250, 0, 40)
frame.Position = UDim2.new(0.5, -125, 0.5, -20)
frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
frame.BackgroundTransparency = 0.2
local corner = Instance.new("UICorner")
corner.Parent = frame
corner.CornerRadius = UDim.new(0, 10)
local text = Instance.new("TextLabel")
text.Parent = frame
text.Size = UDim2.new(1, 0, 1, 0)
text.BackgroundTransparency = 1
text.Text = "✅ ESP LINE AKTIF!"
text.TextColor3 = Color3.fromRGB(255, 255, 255)
text.Font = Enum.Font.GothamBold
text.TextSize = 14
task.wait(2)
notif:Destroy()

print("✅ ESP LINE ONLY - READY!")