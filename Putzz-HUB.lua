--[[
    ██████╗ ██╗   ██╗████████╗███████╗███████╗
    ██╔══██╗██║   ██║╚══██╔══╝╚══███╔╝██╔════╝
    ██████╔╝██║   ██║   ██║     ███╔╝ █████╗  
    ██╔═══╝ ██║   ██║   ██║    ███╔╝  ██╔══╝  
    ██║     ╚██████╔╝   ██║   ███████╗███████╗
    ╚═╝      ╚═════╝    ╚═╝   ╚══════╝╚══════╝
    ██████╗ ███████╗██╗   ██╗███████╗██╗      ██████╗ ██████╗ ███████╗██████╗ 
    ██╔══██╗██╔════╝██║   ██║██╔════╝██║     ██╔═══██╗██╔══██╗██╔════╝██╔══██╗
    ██║  ██║█████╗  ██║   ██║█████╗  ██║     ██║   ██║██████╔╝█████╗  ██████╔╝
    ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║     ██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗
    ██████╔╝███████╗ ╚████╔╝ ███████╗███████╗╚██████╔╝██║     ███████╗██║  ██║
    ╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝
    
    [ Putzz Developer - Ultimate GUI V2 ]
    Fitur: ESP, Main, Aimbot, Custom Color, Toggle GUI
]]

-- Load Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PutzzDeveloperGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Variables
local GUIEnabled = true
local ESPEnabled = false
local ESPBox = false
local ESPName = false
local ESPDistance = false
local ESPHealth = false
local ESPSkeleton = false
local ESPLine = false
local ESPHead = false
local FlyEnabled = false
local NoclipEnabled = false
local InvisibleEnabled = false
local AimbotEnabled = false
local TeleportMode = false
local CurrentColor = Color3.fromRGB(0, 255, 255) -- Cyan default
local ESPObjects = {}
local FlySpeed = 50
local BodyGyro, BodyVelocity

-- UI Elements
local MainFrame
local ESPFrame
local MainFrameFrame
local ColorPickerFrame

-- Create Draggable Function
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.Cancel then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            frame:TweenPosition(newPos, "Out", "Quad", 0.1, true)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create UI
local function CreateMainUI()
    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = CurrentColor
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = false
    MainFrame.Parent = ScreenGui
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.Position = UDim2.new(0, -25, 0, -25)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = MainFrame
    
    -- Gradient Effect
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    Gradient.Rotation = 45
    Gradient.Parent = MainFrame
    
    -- Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.8, 0, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Putzz Developer Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TitleBar
    
    -- Close Button
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Image = "rbxassetid://6031094678"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("ImageButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Image = "rbxassetid://6031094678"
    MinimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 0)
    MinimizeBtn.Parent = TitleBar
    
    -- Color Button
    local ColorBtn = Instance.new("ImageButton")
    ColorBtn.Name = "ColorBtn"
    ColorBtn.Size = UDim2.new(0, 30, 0, 30)
    ColorBtn.Position = UDim2.new(1, -105, 0, 5)
    ColorBtn.BackgroundTransparency = 1
    ColorBtn.Image = "rbxassetid://6031094678"
    ColorBtn.ImageColor3 = Color3.fromRGB(0, 255, 255)
    ColorBtn.Parent = TitleBar
    
    -- Tab Buttons
    local TabFrame = Instance.new("Frame")
    TabFrame.Name = "TabFrame"
    TabFrame.Size = UDim2.new(1, 0, 0, 40)
    TabFrame.Position = UDim2.new(0, 0, 0, 40)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Parent = MainFrame
    
    local ESPTab = Instance.new("TextButton")
    ESPTab.Name = "ESPTab"
    ESPTab.Size = UDim2.new(0.33, -5, 1, -10)
    ESPTab.Position = UDim2.new(0, 5, 0, 5)
    ESPTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ESPTab.BackgroundTransparency = 0.8
    ESPTab.Text = "ESP FEATURES"
    ESPTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTab.TextSize = 14
    ESPTab.Font = Enum.Font.GothamBold
    ESPTab.Parent = TabFrame
    
    local MainTab = Instance.new("TextButton")
    MainTab.Name = "MainTab"
    MainTab.Size = UDim2.new(0.33, -5, 1, -10)
    MainTab.Position = UDim2.new(0.335, 0, 0, 5)
    MainTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainTab.BackgroundTransparency = 0.8
    MainTab.Text = "MAIN FEATURES"
    MainTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTab.TextSize = 14
    MainTab.Font = Enum.Font.GothamBold
    MainTab.Parent = TabFrame
    
    local AimbotTab = Instance.new("TextButton")
    AimbotTab.Name = "AimbotTab"
    AimbotTab.Size = UDim2.new(0.33, -5, 1, -10)
    AimbotTab.Position = UDim2.new(0.67, 0, 0, 5)
    AimbotTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AimbotTab.BackgroundTransparency = 0.8
    AimbotTab.Text = "AIMBOT"
    AimbotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimbotTab.TextSize = 14
    AimbotTab.Font = Enum.Font.GothamBold
    AimbotTab.Parent = TabFrame
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(0.9, 0, 0, 380)
    ContentFrame.Position = UDim2.new(0.05, 0, 0, 90)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ContentFrame.BackgroundTransparency = 0.5
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame
    
    -- ESP Frame
    ESPFrame = Instance.new("ScrollingFrame")
    ESPFrame.Name = "ESPFrame"
    ESPFrame.Size = UDim2.new(1, 0, 1, 0)
    ESPFrame.BackgroundTransparency = 1
    ESPFrame.BorderSizePixel = 0
    ESPFrame.ScrollBarThickness = 5
    ESPFrame.Visible = true
    ESPFrame.Parent = ContentFrame
    
    local ESPLayout = Instance.new("UIListLayout")
    ESPLayout.Padding = UDim.new(0, 5)
    ESPLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ESPLayout.Parent = ESPFrame
    
    -- Main Features Frame
    MainFrameFrame = Instance.new("ScrollingFrame")
    MainFrameFrame.Name = "MainFrameFrame"
    MainFrameFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrameFrame.BackgroundTransparency = 1
    MainFrameFrame.BorderSizePixel = 0
    MainFrameFrame.ScrollBarThickness = 5
    MainFrameFrame.Visible = false
    MainFrameFrame.Parent = ContentFrame
    
    local MainLayout = Instance.new("UIListLayout")
    MainLayout.Padding = UDim.new(0, 5)
    MainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MainLayout.Parent = MainFrameFrame
    
    -- Aimbot Frame
    local AimbotFrame = Instance.new("ScrollingFrame")
    AimbotFrame.Name = "AimbotFrame"
    AimbotFrame.Size = UDim2.new(1, 0, 1, 0)
    AimbotFrame.BackgroundTransparency = 1
    AimbotFrame.BorderSizePixel = 0
    AimbotFrame.ScrollBarThickness = 5
    AimbotFrame.Visible = false
    AimbotFrame.Parent = ContentFrame
    
    local AimbotLayout = Instance.new("UIListLayout")
    AimbotLayout.Padding = UDim.new(0, 5)
    AimbotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    AimbotLayout.Parent = AimbotFrame
    
    -- Color Picker Frame
    ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = "ColorPickerFrame"
    ColorPickerFrame.Size = UDim2.new(0, 300, 0, 400)
    ColorPickerFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ColorPickerFrame.BorderSizePixel = 0
    ColorPickerFrame.Visible = false
    ColorPickerFrame.Parent = ScreenGui
    
    local ColorCorner = Instance.new("UICorner")
    ColorCorner.CornerRadius = UDim.new(0, 15)
    ColorCorner.Parent = ColorPickerFrame
    
    local ColorTitle = Instance.new("TextLabel")
    ColorTitle.Size = UDim2.new(1, 0, 0, 40)
    ColorTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ColorTitle.BackgroundTransparency = 0.3
    ColorTitle.Text = "Pilih Warna GUI"
    ColorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorTitle.TextSize = 18
    ColorTitle.Font = Enum.Font.GothamBold
    ColorTitle.Parent = ColorPickerFrame
    
    local ColorClose = Instance.new("TextButton")
    ColorClose.Size = UDim2.new(0, 30, 0, 30)
    ColorClose.Position = UDim2.new(1, -35, 0, 5)
    ColorClose.BackgroundTransparency = 1
    ColorClose.Text = "X"
    ColorClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorClose.TextSize = 20
    ColorClose.Font = Enum.Font.GothamBold
    ColorClose.Parent = ColorPickerFrame
    
    makeDraggable(MainFrame)
    makeDraggable(ColorPickerFrame)
    
    -- Create Toggle Button (for opening/closing GUI)
    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleBtn.BackgroundColor3 = CurrentColor
    ToggleBtn.BackgroundTransparency = 0.2
    ToggleBtn.Image = "rbxassetid://6031094678"
    ToggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Parent = ScreenGui
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleBtn
    
    -- Create Buttons for ESP
    local function CreateToggleButton(parent, text, variable)
        local btn = Instance.new("Frame")
        btn.Name = text.."Btn"
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.BackgroundTransparency = 0.3
        btn.Parent = parent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.6, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextSize = 14
        lbl.Font = Enum.Font.Gotham
        lbl.Parent = btn
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 60, 0, 30)
        toggle.Position = UDim2.new(1, -70, 0.5, -15)
        toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggle.BackgroundTransparency = 0.3
        toggle.Text = "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 12
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = btn
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 5)
        toggleCorner.Parent = toggle
        
        return {Frame = btn, Button = toggle}
    end
    
    -- Create ESP Toggles
    local ESPBoxBtn = CreateToggleButton(ESPFrame, "ESP Box", "ESPBox")
    local ESPNameBtn = CreateToggleButton(ESPFrame, "ESP Name", "ESPName")
    local ESPDistanceBtn = CreateToggleButton(ESPFrame, "ESP Distance", "ESPDistance")
    local ESPHealthBtn = CreateToggleButton(ESPFrame, "ESP Health", "ESPHealth")
    local ESPSkeletonBtn = CreateToggleButton(ESPFrame, "ESP Skeleton", "ESPSkeleton")
    local ESPLineBtn = CreateToggleButton(ESPFrame, "ESP Line", "ESPLine")
    local ESPHeadBtn = CreateToggleButton(ESPFrame, "ESP Head", "ESPHead")
    
    -- Create Main Toggles
    local FlyBtn = CreateToggleButton(MainFrameFrame, "Fly Mode", "Fly")
    local NoclipBtn = CreateToggleButton(MainFrameFrame, "Noclip", "Noclip")
    local InvisibleBtn = CreateToggleButton(MainFrameFrame, "Invisible", "Invisible")
    
    -- Teleport Input
    local TPFrame = Instance.new("Frame")
    TPFrame.Name = "TPFrame"
    TPFrame.Size = UDim2.new(0.9, 0, 0, 40)
    TPFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TPFrame.BackgroundTransparency = 0.3
    TPFrame.Parent = MainFrameFrame
    
    local TPCorner = Instance.new("UICorner")
    TPCorner.CornerRadius = UDim.new(0, 8)
    TPCorner.Parent = TPFrame
    
    local TPLabel = Instance.new("TextLabel")
    TPLabel.Size = UDim2.new(0.3, 0, 1, 0)
    TPLabel.Position = UDim2.new(0, 10, 0, 0)
    TPLabel.BackgroundTransparency = 1
    TPLabel.Text = "Teleport:"
    TPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPLabel.TextXAlignment = Enum.TextXAlignment.Left
    TPLabel.TextSize = 14
    TPLabel.Font = Enum.Font.Gotham
    TPLabel.Parent = TPFrame
    
    local TPInput = Instance.new("TextBox")
    TPInput.Size = UDim2.new(0.5, 0, 0, 30)
    TPInput.Position = UDim2.new(0.35, 0, 0.5, -15)
    TPInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TPInput.PlaceholderText = "Nama Player"
    TPInput.Text = ""
    TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPInput.TextSize = 14
    TPInput.Font = Enum.Font.Gotham
    TPInput.Parent = TPFrame
    
    local TPInputCorner = Instance.new("UICorner")
    TPInputCorner.CornerRadius = UDim.new(0, 5)
    TPInputCorner.Parent = TPInput
    
    local TPButton = Instance.new("TextButton")
    TPButton.Size = UDim2.new(0, 50, 0, 30)
    TPButton.Position = UDim2.new(0.87, -25, 0.5, -15)
    TPButton.BackgroundColor3 = CurrentColor
    TPButton.BackgroundTransparency = 0.3
    TPButton.Text = "TP"
    TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPButton.TextSize = 14
    TPButton.Font = Enum.Font.GothamBold
    TPButton.Parent = TPFrame
    
    local TPButtonCorner = Instance.new("UICorner")
    TPButtonCorner.CornerRadius = UDim.new(0, 5)
    TPButtonCorner.Parent = TPButton
    
    -- Create Aimbot Toggles
    local AimbotToggle = CreateToggleButton(AimbotFrame, "Aimbot", "Aimbot")
    
    -- Color Picker Buttons
    local Colors = {
        {Color3.fromRGB(255, 0, 0), "Merah"},
        {Color3.fromRGB(0, 255, 0), "Hijau"},
        {Color3.fromRGB(0, 0, 255), "Biru"},
        {Color3.fromRGB(255, 255, 0), "Kuning"},
        {Color3.fromRGB(255, 0, 255), "Pink"},
        {Color3.fromRGB(0, 255, 255), "Cyan"},
        {Color3.fromRGB(255, 128, 0), "Orange"},
        {Color3.fromRGB(128, 0, 255), "Ungu"}
    }
    
    for i, colorData in ipairs(Colors) do
        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.new(0.8, 0, 0, 40)
        colorBtn.Position = UDim2.new(0.1, 0, 0.1 + (i-1)*0.1, 5)
        colorBtn.BackgroundColor3 = colorData[1]
        colorBtn.Text = colorData[2]
        colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorBtn.TextSize = 16
        colorBtn.Font = Enum.Font.GothamBold
        colorBtn.Parent = ColorPickerFrame
        
        local colorBtnCorner = Instance.new("UICorner")
        colorBtnCorner.CornerRadius = UDim.new(0, 8)
        colorBtnCorner.Parent = colorBtn
        
        colorBtn.MouseButton1Click:Connect(function()
            CurrentColor = colorData[1]
            MainFrame.BackgroundColor3 = CurrentColor
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, CurrentColor),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
            TPButton.BackgroundColor3 = CurrentColor
            ToggleBtn.BackgroundColor3 = CurrentColor
            ColorPickerFrame.Visible = false
        end)
    end
    
    -- Button Click Events
    ESPTab.MouseButton1Click:Connect(function()
        ESPFrame.Visible = true
        MainFrameFrame.Visible = false
        AimbotFrame.Visible = false
        ESPTab.BackgroundTransparency = 0.3
        MainTab.BackgroundTransparency = 0.8
        AimbotTab.BackgroundTransparency = 0.8
    end)
    
    MainTab.MouseButton1Click:Connect(function()
        ESPFrame.Visible = false
        MainFrameFrame.Visible = true
        AimbotFrame.Visible = false
        ESPTab.BackgroundTransparency = 0.8
        MainTab.BackgroundTransparency = 0.3
        AimbotTab.BackgroundTransparency = 0.8
    end)
    
    AimbotTab.MouseButton1Click:Connect(function()
        ESPFrame.Visible = false
        MainFrameFrame.Visible = false
        AimbotFrame.Visible = true
        ESPTab.BackgroundTransparency = 0.8
        MainTab.BackgroundTransparency = 0.8
        AimbotTab.BackgroundTransparency = 0.3
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ToggleBtn.Visible = true
    end)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        ToggleBtn.Visible = false
    end)
    
    ColorBtn.MouseButton1Click:Connect(function()
        ColorPickerFrame.Visible = true
    end)
    
    ColorClose.MouseButton1Click:Connect(function()
        ColorPickerFrame.Visible = false
    end)
    
    -- ESP Toggle Functions
    ESPBoxBtn.Button.MouseButton1Click:Connect(function()
        ESPBox = not ESPBox
        ESPBoxBtn.Button.BackgroundColor3 = ESPBox and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ESPBoxBtn.Button.Text = ESPBox and "ON" or "OFF"
        if ESPBox then ESPEnabled = true else CheckESPStatus() end
    end)
    
    ESPNameBtn.Button.MouseButton1Click:Connect(function()
        ESPName = not ESPName
        ESPNameBtn.Button.BackgroundColor3 = ESPName and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ESPNameBtn.Button.Text = ESPName and "ON" or "OFF"
        if ESPName then ESPEnabled = true else CheckESPStatus() end
    end)
    
    ESPDistanceBtn.Button.MouseButton1Click:Connect(function()
        ESPDistance = not ESPDistance
        ESPDistanceBtn.Button.BackgroundColor3 = ESPDistance and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ESPDistanceBtn.Button.Text = ESPDistance and "ON" or "OFF"
        if ESPDistance then ESPEnabled = true else CheckESPStatus() end
    end)
    
    ESPHealthBtn.Button.MouseButton1Click:Connect(function()
        ESPHealth = not ESPHealth
        ESPHealthBtn.Button.BackgroundColor3 = ESPHealth and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ESPHealthBtn.Button.Text = ESPHealth and "ON" or "OFF"
        if ESPHealth then ESPEnabled = true else CheckESPStatus() end
    end)
    
    ESPSkeletonBtn.Button.MouseButton1Click:Connect(function()
        ESPSkeleton = not ESPSkeleton
        ESPSkeletonBtn.Button.BackgroundColor3 = ESPSkeleton and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ESPSkeletonBtn.Button.Text = ESPSkeleton and "ON" or "OFF"
        if ESPSkeleton then ESPEnabled = true else CheckESPStatus() end
    end)
    
    ESPLineBtn.Button.MouseButton1Click:Connect(function()
        ESPLine = not ESPLine
        ESPLineBtn.Button.BackgroundColor3 = ESPLine and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ESPLineBtn.Button.Text = ESPLine and "ON" or "OFF"
        if ESPLine then ESPEnabled = true else CheckESPStatus() end
    end)
    
    ESPHeadBtn.Button.MouseButton1Click:Connect(function()
        ESPHead = not ESPHead
        ESPHeadBtn.Button.BackgroundColor3 = ESPHead and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ESPHeadBtn.Button.Text = ESPHead and "ON" or "OFF"
        if ESPHead then ESPEnabled = true else CheckESPStatus() end
    end)
    
    -- Main Toggle Functions
    FlyBtn.Button.MouseButton1Click:Connect(function()
        FlyEnabled = not FlyEnabled
        FlyBtn.Button.BackgroundColor3 = FlyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        FlyBtn.Button.Text = FlyEnabled and "ON" or "OFF"
        ToggleFly()
    end)
    
    NoclipBtn.Button.MouseButton1Click:Connect(function()
        NoclipEnabled = not NoclipEnabled
        NoclipBtn.Button.BackgroundColor3 = NoclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        NoclipBtn.Button.Text = NoclipEnabled and "ON" or "OFF"
        ToggleNoclip()
    end)
    
    InvisibleBtn.Button.MouseButton1Click:Connect(function()
        InvisibleEnabled = not InvisibleEnabled
        InvisibleBtn.Button.BackgroundColor3 = InvisibleEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        InvisibleBtn.Button.Text = InvisibleEnabled and "ON" or "OFF"
        ToggleInvisible()
    end)
    
    AimbotToggle.Button.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        AimbotToggle.Button.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        AimbotToggle.Button.Text = AimbotEnabled and "ON" or "OFF"
    end)
    
    TPButton.MouseButton1Click:Connect(function()
        local targetName = TPInput.Text
        TeleportToPlayer(targetName)
    end)
    
    TPInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local targetName = TPInput.Text
            TeleportToPlayer(targetName)
        end
    end)
    
    -- Keybind to toggle GUI (Right Ctrl)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            MainFrame.Visible = not MainFrame.Visible
            ToggleBtn.Visible = not MainFrame.Visible
        end
    end)
end

-- Helper function to check if any ESP is enabled
function CheckESPStatus()
    ESPEnabled = ESPBox or ESPName or ESPDistance or ESPHealth or ESPSkeleton or ESPLine or ESPHead
    if not ESPEnabled then
        -- Clear all ESP objects
        for player, objects in pairs(ESPObjects) do
            for _, obj in ipairs(objects) do
                if obj and obj.Parent then
                    obj:Destroy()
                end
            end
        end
        ESPObjects = {}
    end
end

-- Fly Function
function ToggleFly()
    if FlyEnabled then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then return end
        
        humanoid.PlatformStand = true
        
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.P = 9e4
        BodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        BodyGyro.CFrame = rootPart.CFrame
        BodyGyro.Parent = rootPart
        
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        BodyVelocity.Parent = rootPart
        
        RunService.RenderStepped:Connect(function()
            if not FlyEnabled or not character or not character.Parent then
                if BodyGyro then BodyGyro:Destroy() end
                if BodyVelocity then BodyVelocity:Destroy() end
                if humanoid then humanoid.PlatformStand = false end
                return
            end
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                BodyVelocity.Velocity = moveDirection.Unit * FlySpeed
            else
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            
            BodyGyro.CFrame = Camera.CFrame
        end)
    else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

-- Noclip Function
function ToggleNoclip()
    if NoclipEnabled then
        RunService.Stepped:Connect(function(_, step)
            if not NoclipEnabled then return end
            local character = LocalPlayer.Character
            if not character then return end
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Invisible Function
function ToggleInvisible()
    local character = LocalPlayer.Character
    if not character then return end
    
    if InvisibleEnabled then
        -- Pindahkan karakter ke posisi jauh
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = CFrame.new(999999, 999999, 999999)
        end
        
        -- Buat karakter transparan di view local
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0.5
            end
        end
    else
        -- Kembalikan ke posisi normal
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart and rootPart.Position.Magnitude > 10000 then
            rootPart.CFrame = CFrame.new(0, 50, 0)
        end
        
        -- Kembalikan transparansi
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

-- Teleport Function
function TeleportToPlayer(playerName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(playerName:lower()) or player.DisplayName:lower():find(playerName:lower()) then
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    return
                end
            end
        end
    end
end

-- ESP Functions
function CreateESP(player)
    if not player or player == LocalPlayer then return end
    
    local espObjects = {}
    
    -- Box ESP
    if ESPBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP_Box"
        box.Size = Vector3.new(4, 6, 4)
        box.Transparency = 0.5
        box.Color3 = CurrentColor
        box.ZIndex = 10
        box.AlwaysOnTop = true
        box.Adornee = player.Character
        box.Parent = player.Character
        table.insert(espObjects, box)
    end
    
    -- Name ESP
    if ESPName then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Name"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = CurrentColor
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = billboard
        
        billboard.Parent = player.Character
        table.insert(espObjects, billboard)
    end
    
    -- Head ESP
    if ESPHead then
        local head = player.Character:FindFirstChild("Head")
        if head then
            local circle = Instance.new("SelectionSphere")
            circle.Name = "ESP_Head"
            circle.Transparency = 0.5
            circle.Color3 = CurrentColor
            circle.SurfaceTransparency = 0.5
            circle.Adornee = head
            circle.Parent = player.Character
            table.insert(espObjects, circle)
        end
    end
    
    -- Line ESP
    if ESPLine then
        local line = Instance.new("SelectionBox")
        line.Name = "ESP_Line"
        line.LineThickness = 0.1
        line.Color3 = CurrentColor
        line.Transparency = 0.5
        line.Adornee = player.Character
        line.Parent = player.Character
        table.insert(espObjects, line)
    end
    
    ESPObjects[player] = espObjects
end

-- Skeleton ESP
function CreateSkeletonESP(player)
    if not player or player == LocalPlayer then return end
    
    local skeleton = {}
    local joints = {
        {"Head", "Torso", "Neck"},
        {"Torso", "Left Arm", "Left Shoulder"},
        {"Torso", "Right Arm", "Right Shoulder"},
        {"Torso", "Left Leg", "Left Hip"},
        {"Torso", "Right Leg", "Right Hip"},
        {"Left Arm", "Left Hand", "Left Wrist"},
        {"Right Arm", "Right Hand", "Right Wrist"},
        {"Left Leg", "Left Foot", "Left Ankle"},
        {"Right Leg", "Right Foot", "Right Ankle"}
    }
    
    for _, jointData in ipairs(joints) do
        local part1 = player.Character:FindFirstChild(jointData[1])
        local part2 = player.Character:FindFirstChild(jointData[2])
        
        if part1 and part2 then
            local attach1 = Instance.new("Attachment")
            attach1.Name = "Attach1"
            attach1.Parent = part1
            
            local attach2 = Instance.new("Attachment")
            attach2.Name = "Attach2"
            attach2.Parent = part2
            
            local alignPos = Instance.new("AlignPosition")
            alignPos.Attachment0 = attach1
            alignPos.Attachment1 = attach2
            alignPos.Responsiveness = 200
            alignPos.RigidityEnabled = false
            alignPos.Parent = part1
            
            table.insert(skeleton, attach1)
            table.insert(skeleton, attach2)
            table.insert(skeleton, alignPos)
            
            -- Visual line
            local line = Instance.new("SelectionBox")
            line.Name = "ESP_Skeleton"
            line.LineThickness = 0.05
            line.Color3 = CurrentColor
            line.Transparency = 0.3
            line.Adornee = part1
            line.Parent = part1
            
            table.insert(skeleton, line)
        end
    end
    
    if ESPObjects[player] then
        for _, obj in ipairs(skeleton) do
            table.insert(ESPObjects[player], obj)
        end
    else
        ESPObjects[player] = skeleton
    end
end

-- Aimbot
RunService.RenderStepped:Connect(function()
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Right click
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local headPos = player.Character.Head.Position
                local screenPos, onScreen = Camera:WorldToScreenPoint(headPos)
                
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if distance < shortestDistance and distance < 100 then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
        end
    end
end)

-- Update ESP
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not ESPObjects[player] then
                CreateESP(player)
                if ESPSkeleton then
                    CreateSkeletonESP(player)
                end
            end
            
            -- Update existing ESP
            for _, obj in ipairs(ESPObjects[player] or {}) do
                if obj:IsA("BoxHandleAdornment") then
                    obj.Color3 = CurrentColor
                elseif obj:IsA("BillboardGui") and obj:FindFirstChildOfClass("TextLabel") then
                    obj:FindFirstChildOfClass("TextLabel").TextColor3 = CurrentColor
                    if ESPDistance then
                        local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        obj:FindFirstChildOfClass("TextLabel").Text = player.Name .. " [" .. math.floor(dist) .. "m]"
                    else
                        obj:FindFirstChildOfClass("TextLabel").Text = player.Name
                    end
                    
                    if ESPHealth and player.Character:FindFirstChildOfClass("Humanoid") then
                        local health = player.Character:FindFirstChildOfClass("Humanoid").Health
                        obj:FindFirstChildOfClass("TextLabel").Text = obj:FindFirstChildOfClass("TextLabel").Text .. " [" .. math.floor(health) .. "HP]"
                    end
                elseif obj:IsA("SelectionSphere") then
                    obj.Color3 = CurrentColor
                elseif obj:IsA("SelectionBox") and obj.Name == "ESP_Line" then
                    obj.Color3 = CurrentColor
                end
            end
        elseif ESPObjects[player] then
            for _, obj in ipairs(ESPObjects[player]) do
                if obj and obj.Parent then
                    obj:Destroy()
                end
            end
            ESPObjects[player] = nil
        end
    end
end)

-- Player Added Event
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)
        if ESPEnabled then
            CreateESP(player)
            if ESPSkeleton then
                CreateSkeletonESP(player)
            end
        end
    end)
end)

-- Initialize
CreateMainUI()
print("Putzz Developer")