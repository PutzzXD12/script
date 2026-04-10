-- TEST 1: Apakah Delta bisa bikin GUI?
local gui = Instance.new("ScreenGui")
gui.Name = "TestGui"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BackgroundTransparency = 0.5

local btn = Instance.new("TextButton")
btn.Parent = frame
btn.Size = UDim2.new(1, 0, 1, 0)
btn.Text = "TEST"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)

print("TEST GUI JALAN - harusnya ada kotak merah")