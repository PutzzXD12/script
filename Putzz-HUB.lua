pcall(function() 
    game:HttpGet("https://nexviewsservice.shardweb.app/services/drip_client/start") 
end) 

local Translator = {} 
Translator.Frases = loadstring(game:HttpGet("https://raw.githubusercontent.com/realgengar/Brookhaven/refs/heads/main/translations.lua"))() 
local idioma = (game.Players.LocalPlayer.LocaleId or "en-US"):sub(1, 2):lower() 
if not Translator.Frases[idioma] then idioma = "en" end 
Translator.Idioma = idioma 

function Translator:traduzir(frase) 
    return self.Frases[self.Idioma][frase] or frase 
end 

-- /////////////Script Functions///////////////------
local Players = game:GetService("Players") 
local TextChatService = game:GetService("TextChatService") 
local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local HttpService = game:GetService("HttpService") 
local playerName = game.Players.LocalPlayer.Name 
local LocalPlayer = Players.LocalPlayer 
local VirtualInputManager = game:GetService("VirtualInputManager") 
local RunService = game:GetService("RunService") 
local TweenService = game:GetService("TweenService") 
local Camera = workspace.CurrentCamera 
local Workspace = game:GetService("Workspace") 
local UserInputService = game:GetService("UserInputService") 

local redzlibContent = game:HttpGet("https://raw.githubusercontent.com/realgengar/Library/refs/heads/main/remake.lua", true) 
local redzlib = loadstring(redzlibContent)() 
if not redzlib then error("deu red") end 

workspace.FallenPartsDestroyHeight = -math.huge 

local Window = redzlib:MakeWindow({ 
    Title = "Drip Client | Desofuscado Putzzdev | Brookhaven Rp ", 
    SaveFolder = "redz Hub | Brookhaven RP.lua" 
}) 

Window:AddMinimizeButton({ 
    Button = { Image = "rbxassetid://72495850369898" }, 
    Corner = { CornerRadius = UDim.new(0, 2) }, 
    Stroke = { Color = Color3.new(0, 0, 0), Transparency = 1, Thickness = 1 } 
}) 

local args = { [1] = "RolePlayName", [2] = "This Script Was Leaked by team Illuminati & WxDevelopee" } 
game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPNam1eTex1t"):FireServer(unpack(args)) 

local function copyDiscordLink() 
    setclipboard("https://tiktok:Putzzdev") 
end 

--[[ 
local function AntiSkidder() 
    local antiSkidContent = game:HttpGet('https://raw.githubusercontent.com/scriptclient/Brookhaven/refs/heads/main/iploggs.lua', true) 
    loadstring(antiSkidContent)() 
end 
]] 

local function chatlogs() 
    local player = game.Players.LocalPlayer 
    local gui = Instance.new("ScreenGui") 
    gui.Name = "PainelChatLogs" 
    gui.ResetOnSpawn = false 
    gui.Parent = player:WaitForChild("PlayerGui") 

    local frame = Instance.new("Frame") 
    frame.Size = UDim2.new(0, 400, 0, 250) 
    frame.Position = UDim2.new(0.5, -200, 0.5, -125) 
    frame.BackgroundColor3 = Color3.fromRGB(128, 0, 255) 
    frame.BackgroundTransparency = 0.3 
    frame.BorderSizePixel = 0 
    frame.AnchorPoint = Vector2.new(0.5, 0.5) 
    frame.Parent = gui 

    local corner = Instance.new("UICorner") 
    corner.CornerRadius = UDim.new(0, 12) 
    corner.Parent = frame 

    local title = Instance.new("TextLabel") 
    title.Size = UDim2.new(1, -40, 0, 40) 
    title.Position = UDim2.new(0, 20, 0, 10) 
    title.BackgroundTransparency = 1 
    title.Text = "Changelog" 
    title.TextColor3 = Color3.fromRGB(255, 255, 255) 
    title.Font = Enum.Font.GothamBold 
    title.TextSize = 22 
    title.TextXAlignment = Enum.TextXAlignment.Left 
    title.Parent = frame 

    local linha = Instance.new("Frame") 
    linha.Size = UDim2.new(0.9, 0, 0, 2) 
    linha.Position = UDim2.new(0.05, 0, 0, 50) 
    linha.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
    linha.BorderSizePixel = 0 
    linha.Parent = frame 

    local closeButton = Instance.new("TextButton") 
    closeButton.Size = UDim2.new(0, 30, 0, 30) 
    closeButton.Position = UDim2.new(1, -35, 0, 5) 
    closeButton.BackgroundTransparency = 1 
    closeButton.Text = "×" 
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255) 
    closeButton.Font = Enum.Font.GothamBold 
    closeButton.TextSize = 20 
    closeButton.Parent = frame 

    local closeCorner = Instance.new("UICorner") 
    closeCorner.CornerRadius = UDim.new(0, 8) 
    closeCorner.Parent = closeButton 
    closeButton.MouseButton1Click:Connect(function() gui:Destroy() end) 

    local chatLog = Instance.new("TextLabel") 
    chatLog.Size = UDim2.new(0.9, 0, 0.7, 0) 
    chatLog.Position = UDim2.new(0.05, 0, 0, 60) 
    chatLog.BackgroundTransparency = 1 
    chatLog.Text = [[ • Add Tab Lags • Add news Lag: Box,Book,Guitar [ Troll ] • Add Annoy Fling [ Toggle ] • Add Lag Select Target Player [ Provied ] • add fling couch all v2 [ Button ] • add Musics +10 [ Tab Car ] • add tornado tool, wall tool, name tool [Character Tab] • Fixed bugs • ]] 
    chatLog.TextColor3 = Color3.fromRGB(255, 255, 255) 
    chatLog.Font = Enum.Font.Gotham 
    chatLog.TextSize = 16 
    chatLog.TextWrapped = true 
    chatLog.TextYAlignment = Enum.TextYAlignment.Top 
    chatLog.TextXAlignment = Enum.TextXAlignment.Left 
    chatLog.Parent = frame 

    frame.Size = UDim2.new(0, 0, 0, 0) 
    frame.Position = UDim2.new(0.5, 0, 0.5, 0) 

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out) 
    local tween = TweenService:Create(frame, tweenInfo, { Size = UDim2.new(0, 400, 0, 250), Position = UDim2.new(0.5, -200, 0.5, -125) }) 
    tween:Play() 
end 

Window:Dialog({ 
    Title = Translator:traduzir("Seja Bem-Vindo(a)"), 
    Text = Translator:traduzir("E aí! Você acaba de dar o play no Drip Client. Não se preocupe, ele não morde a menos que você entre em nosso discord. Está aqui o melhor Hub. Bora nessa!"), 
    Options = { 
        {"Discord", function() copyDiscordLink() end}, 
        {"Open", function() AntiSkidder() end}, 
        {"logs", function() chatlogs() end} 
    } 
}) 

local Tabs = { 
    M = Window:MakeTab({Translator:traduzir("informações"), "Info"}), 
    H = Window:MakeTab({Translator:traduzir("Início"), "coffee"}), 
    PR = Window:MakeTab({Translator:traduzir("Proteção"), "shield"}), 
    Client = Window:MakeTab({Translator:traduzir("Spam/Client"), "eye"}), 
    JJ = Window:MakeTab({Translator:traduzir("Personagem"), "userplus"}), 
    TT = Window:MakeTab({Translator:traduzir("Trolar"), "flame"}), 
    LG = Window:MakeTab({Translator:traduzir("Lag Servidor"), "bomb"}), 
    AD = Window:MakeTab({Translator:traduzir("Audio/Musica"), "headphones"}), 
    AVT = Window:MakeTab({Translator:traduzir("Roupas"), "shirt"}), 
    HouseTab = Window:MakeTab({Translator:traduzir("Casa"), "home"}), 
    Carros = Window:MakeTab({Translator:traduzir("Carro"), "truck"}), 
    Tp = Window:MakeTab({Translator:traduzir("Portal"), "apple"}), 
    CFG = Window:MakeTab({Translator:traduzir("Configurações"), "Settings"}) 
} 

Tabs.M:AddDiscordInvite({ 
    Name = Translator:traduzir("Drip Hub | Community"), 
    Description = Translator:traduzir("Junte-se à nossa comunidade discord para receber informações sobre a próxima atualização"), 
    Logo = "rbxassetid://94502262507600", 
    Invite = "https://discord.gg/6YzXUMu49y" 
}) 

Tabs.M:AddSection({Translator:traduzir("Acess Admin")}) 
Tabs.M:AddButton({Translator:traduzir("Painel Admin"), function() 
    Window:Dialog({ 
        Title = Translator:traduzir("Como Obter Grátis"), 
        Text = Translator:traduzir("• Formas de conseguir acesso ao Painel Admin Premium:\nVocê pode obter de diferentes maneiras\nDando 2 boosts em nosso servidor e recebendo 20 dias de acesso.\nTornando-se um divulgador oficial."), 
        Options = { {"Discord", function() copyDiscordLink() end} } 
    }) 
end}) 

local function links() 
    setclipboard("https://discord.gg/6YzXUMu49y") 
end 

local gameName = "Unknown Game" 
local success, gameInfo = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end) 
if success and gameInfo then gameName = gameInfo.Name end 

Tabs.M:AddSection({Translator:traduzir("Mapa Status")}) 
local Paragraph1 = Tabs.M:AddParagraph({Translator:traduzir("Nome do Jogo: " .. gameName)}) 
local executor = identifyexecutor() 
local Paragraph = Tabs.M:AddParagraph({Translator:traduzir("Executor: " .. executor)}) 
do 
    Tabs.M:AddSection({Translator:traduzir("Ánuncios ")}) 
    Tabs.M:AddButton({Translator:traduzir("Aviso Externo"), function() 
        Window:Dialog({ 
            Title = "Erros", 
            Text = Translator:traduzir("• O script pode apresentar erros. Caso encontre algum, por favor, reporte-o no nosso Discord."), 
            Options = { {"Link Discord", function() copyDiscordLink() end}, {"Fechar", function() AntiSkidder() end} } 
        }) 
    end}) 
    Tabs.M:AddButton({Translator:traduzir("Aviso Externo2"), function() 
        Window:Dialog({ 
            Title = "Update", 
            Text = Translator:traduzir("•Devido às atualizações, algumas funções podem parar de funcionar. Estamos trabalhando para garantir a melhor experiência."), 
            Options = { {"Link Discord", function() copyDiscordLink() end}, {"Fechar", function() AntiSkidder() end} } 
        }) 
    end}) 
end 

local Section = Tabs.M:AddSection({Translator:traduzir("Resoluções Da Tela")}) 
Tabs.M:AddButton({Translator:traduzir("Resolução Normal"), function() 
    getgenv().Resolution = { [".gg/scripters"] = 1.0 } 
    local Camera = workspace.CurrentCamera 
    if getgenv().gg_scripters == nil then 
        game:GetService("RunService").RenderStepped:Connect( function() Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1) end ) 
    end 
    getgenv().gg_scripters = "Aori0001" 
end }) 
Tabs.M:AddButton({Translator:traduzir("Resolução 0.70"), function() 
    getgenv().Resolution = { [".gg/scripters"] = 0.70 } 
    local Camera = workspace.CurrentCamera 
    if getgenv().gg_scripters == nil then 
        game:GetService("RunService").RenderStepped:Connect( function() Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1) end ) 
    end 
    getgenv().gg_scripters = "Aori0001" 
end }) 
Tabs.M:AddButton({Translator:traduzir("Resolução 0.80"), function() 
    getgenv().Resolution = { [".gg/scripters"] = 0.80 } 
    local Camera = workspace.CurrentCamera 
    if getgenv().gg_scripters == nil then 
        game:GetService("RunService").RenderStepped:Connect( function() Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1) end ) 
    end 
    getgenv().gg_scripters = "Aori0001" 
end }) 
end 

-- ///////TABS - HH ///////-----------------
do 
    local Config = { 
        defaultSpeed = 16, 
        defaultJumpPower = 50, 
        defaultGravity = 196.2, 
        colorSpeed = 25, 
        updateInterval = 1, 
        statusUpdateInterval = 5 
    } 
    local PlayerStats = { 
        speedValue = Config.defaultSpeed, 
        jumpPower = Config.defaultJumpPower, 
        gravityValue = Config.defaultGravity 
    } 

    Tabs.H:AddSection({Translator:traduzir("Super Poderes")}) 

    local function validateNumber(value, defaultValue) 
        local number = tonumber(value) 
        return number and number or defaultValue 
    end 

    local function updateCharacterProperty(property, value) 
        local character = LocalPlayer.Character 
        if character and character:FindFirstChild("Humanoid") then 
            character.Humanoid[property] = value 
        end 
    end 

    local speedTextBox = Tabs.H:AddTextBox({ 
        Title = Translator:traduzir("Velocidade"), 
        Description = "Definir A Velocidade", 
        Default = tostring(Config.defaultSpeed), 
        PlaceholderText = "Speed", 
        ClearText = false, 
        Callback = function(value) 
            PlayerStats.speedValue = validateNumber(value, Config.defaultSpeed) 
            updateCharacterProperty("WalkSpeed", PlayerStats.speedValue) 
        end 
    }) 

    local jumpTextBox = Tabs.H:AddTextBox({ 
        Title = Translator:traduzir("Pulos"), 
        Description = Translator:traduzir("Definir Os Pulos"), 
        Default = tostring(Config.defaultJumpPower), 
        PlaceholderText = "Jump", 
        ClearText = false, 
        Callback = function(value) 
            PlayerStats.jumpPower = validateNumber(value, Config.defaultJumpPower) 
            updateCharacterProperty("JumpPower", PlayerStats.jumpPower) 
        end 
    }) 

    local gravityTextBox = Tabs.H:AddTextBox({ 
        Title = Translator:traduzir("Gravidade"), 
        Description = Translator:traduzir("Definir A Gravidade"), 
        Default = tostring(Config.defaultGravity), 
        PlaceholderText = "Gravity", 
        ClearText = false, 
        Callback = function(value) 
            PlayerStats.gravityValue = validateNumber(value, Config.defaultGravity) 
            workspace.Gravity = PlayerStats.gravityValue 
        end 
    }) 

    local resetButton = Tabs.H:AddButton({ 
        Translator:traduzir("Reseta "), 
        function() 
            PlayerStats.jumpPower = Config.defaultJumpPower 
            PlayerStats.speedValue = Config.defaultSpeed 
            PlayerStats.gravityValue = Config.defaultGravity 
            updateCharacterProperty("JumpPower", PlayerStats.jumpPower) 
            updateCharacterProperty("WalkSpeed", PlayerStats.speedValue) 
            workspace.Gravity = PlayerStats.gravityValue 
        end 
    }) 

    Tabs.H:AddSection({Translator:traduzir("Status Atualização")}) 
    local scoutTrack = Tabs.H:AddParagraph({Translator:traduzir("Dev: Kioshi Status")}) 
    task.spawn(function() 
        while true do 
            local scout = workspace:FindFirstChild("scout7ixs") 
            local texto = "" 
            if scout then 
                local hrpScout = scout:FindFirstChild("HumanoidRootPart") 
                local hrpLocal = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
                if hrpScout and hrpLocal then 
                    local distancia = math.floor((hrpScout.Position - hrpLocal.Position).Magnitude) 
                    texto = texto .. string.format("está no servidor | Distância <%d>", distancia) 
                else 
                    texto = texto .. "está no servidor | Distância ??>" 
                end 
            else 
                texto = texto .. "não está no servidor" 
            end 
            scoutTrack:Set(texto) 
            task.wait(Config.updateInterval) 
        end 
    end) 

    local tempoTrack = Tabs.H:AddParagraph({Translator:traduzir("Tempo De Uso De Script")}) 
    local tempoAtual = 0 
    task.spawn(function() 
        while true do 
            local horas = math.floor(tempoAtual / 3600) 
            local minutos = math.floor((tempoAtual % 3600) / 60) 
            local segundos = tempoAtual % 60 
            local formatado = string.format("%02d:%02d:%02d", horas, minutos, segundos) 
            tempoTrack:Set(" " .. formatado) 
            tempoAtual += Config.statusUpdateInterval 
            task.wait(Config.statusUpdateInterval) 
        end 
    end) 

    local fpsParagraph = Tabs.H:AddParagraph({ "Mostra Fps" }) 
    local lastUpdate = 0 
    local frameCount = 0 
    local currentFPS = 0 
    RunService.RenderStepped:Connect(function(dt) 
        frameCount += 1 
        lastUpdate += dt 
        if lastUpdate >= 1 then 
            currentFPS = frameCount 
            fpsParagraph:Set("FPS: " .. currentFPS) 
            frameCount = 0 
            lastUpdate = 0 
        end 
    end) 

    local playerCountParagraph = Tabs.H:AddParagraph({Translator:traduzir("Quantidade De Pessoas")}) 
    local function updatePlayerCount() 
        local count = #Players:GetPlayers() 
        playerCountParagraph:Set(" " .. count) 
    end 
    Players.PlayerAdded:Connect(updatePlayerCount) 
    Players.PlayerRemoving:Connect(updatePlayerCount) 
    updatePlayerCount() 

    Tabs.H:AddSection({Translator:traduzir("Basquete ")}) 
    local BNumber = 1000 
    local Toggle = Tabs.H:AddToggle({ 
        Name = Translator:traduzir("Arremesso de bolas V2"), 
        Description = Translator:traduzir("Telepkrt/Ball/Volta/Arremessa"), 
        Default = false 
    }) 
    Toggle:Callback(function(state) 
        if state then 
            local Player = game.Players.LocalPlayer 
            local Backpack = Player and Player:FindFirstChild("Backpack") 
            local Mouse = Player and Player:GetMouse() 
            local Character = Player and Player.Character 
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid") 
            local RootPart = Character and Character:FindFirstChild("HumanoidRootPart") 
            local Clone = workspace:FindFirstChild("WorkspaceCom") and workspace.WorkspaceCom:FindFirstChild("001_GiveTools") and workspace.WorkspaceCom["001_GiveTools"]:FindFirstChild("Basketball") 
            if not (Player and Backpack and Mouse and Character and Humanoid and RootPart and Clone) then 
                warn("Erro: alguma instÃ¢ncia necessÃ¡ria nÃ£o foi encontrada.") 
                return 
            end 
            local OldPos = RootPart.CFrame 
            for i = 1, BNumber do 
                task.wait() 
                RootPart.CFrame = Clone.CFrame 
                fireclickdetector(Clone:FindFirstChildOfClass("ClickDetector")) 
            end 
            task.wait() 
            RootPart.CFrame = OldPos 
            spawn(function() 
                while state do 
                    task.wait() 
                    for _, tool in ipairs(Character:GetChildren()) do 
                        if tool.Name == "Basketball" then 
                            task.wait(0.0003) 
                            args = { Mouse.Hit.p } 
                            tool:FindFirstChild("ClickEvent"):FireServer(unpack(args)) 
                        end 
                    end 
                end 
            end) 
        end 
    end) 

    Tabs.H:AddSection({Translator:traduzir("Sistema Lgbt")}) 
    local colorSpeed = Config.colorSpeed 
    Tabs.H:AddSlider({ 
        Name = Translator:traduzir("Velocidade das cores"), 
        Min = 1, 
        Max = 25, 
        Increase = 1, 
        Default = colorSpeed, 
        Callback = function(Value) 
            colorSpeed = Value 
        end 
    }) 

    local hairColors = { 
        Color3.new(1, 1, 0), Color3.new(0, 0, 1), Color3.new(1, 0, 1), Color3.new(1, 1, 1), 
        Color3.new(0, 1, 0), Color3.new(0.5, 0, 1), Color3.new(1, 0.647, 0), Color3.new(0, 1, 1) 
    } 
    local vibrantColors = { 
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), 
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255), 
        Color3.fromRGB(255, 165, 0), Color3.fromRGB(128, 0, 128), Color3.fromRGB(255, 20, 147) 
    } 
    local colors = { 
        "Bright red", "Lime green", "Bright blue", "Bright yellow", "Bright cyan", 
        "Hot pink", "Royal purple" 
    } 

    local isHairActive, isNameActive, isBioActive, toggleActive, rgbEnabled = false, false, false, false, false 

    Tabs.H:AddToggle({ 
        Name = Translator:traduzir("Cabelo lgbt"), 
        Description = Translator:traduzir("Mudar a cor de cabelo automático"), 
        Default = false, 
        Callback = function(value) isHairActive = value end 
    }) 
    Tabs.H:AddToggle({ 
        Name = Translator:traduzir("Nome lgbt"), 
        Description = Translator:traduzir("Mudar a cor do nome automático"), 
        Default = false, 
        Callback = function(value) isNameActive = value end 
    }) 
    Tabs.H:AddToggle({ 
        Name = Translator:traduzir("Bio lgbt"), 
        Description = Translator:traduzir("Mudar a cor da bio automático"), 
        Default = false, 
        Callback = function(value) isBioActive = value end 
    }) 
    Tabs.H:AddToggle({ 
        Name = Translator:traduzir("Rosas Lgbt"), 
        Description = Translator:traduzir("Muda a cor da rosa automaticamente"), 
        Default = false, 
        Callback = function(value) toggleActive = value end 
    }) 
    Tabs.H:AddToggle({ 
        Name = Translator:traduzir("Personagem Lgbt"), 
        Description = Translator:traduzir("Deixa seu personagem RGB automaticamente"), 
        Default = false, 
        Callback = function(value) rgbEnabled = value end 
    }) 

    task.spawn(function() 
        local iHair, iName, iBio, iChar = 1, 1, 1, 1 
        while true do 
            if isHairActive then 
                local hairArg = { "ChangeHairColor2", hairColors[iHair] } 
                ReplicatedStorage.RE:FindFirstChild("1Max1y"):FireServer(unpack(hairArg)) 
                iHair = iHair % #hairColors + 1 
            end 
            if isNameActive then 
                local nameArg = { "PickingRPNameColor", vibrantColors[iName] } 
                ReplicatedStorage.RE:FindFirstChild("1RPNam1eColo1r"):FireServer(unpack(nameArg)) 
                iName = iName % #vibrantColors + 1 
            end 
            if isBioActive then 
                local bioArg = { "PickingRPBioColor", vibrantColors[iBio] } 
                ReplicatedStorage.RE:FindFirstChild("1RPNam1eColo1r"):FireServer(unpack(bioArg)) 
                iBio = iBio % #vibrantColors + 1 
            end 
            if rgbEnabled then 
                local bodyArg = { colors[iChar] } 
                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeBodyColor"):FireServer(unpack(bodyArg)) 
                iChar = iChar % #colors + 1 
            end 
            if toggleActive then 
                local char = LocalPlayer.Character 
                local rosas = char and char:FindFirstChild("Roses") 
                if rosas and rosas:FindFirstChild("ToolSound") then 
                    local ids = { 
                        "rbxassetid://5210399458", 
                        "rbxassetid://5210414520", 
                        "rbxassetid://5216708760", 
                        "rbxassetid://5210414112" 
                    } 
                    for _, id in ipairs(ids) do 
                        local args = { "Roses", id } 
                        rosas.ToolSound:FireServer(unpack(args)) 
                        task.wait(0.1) 
                    end 
                end 
            end 
            task.wait(1 / colorSpeed) 
        end 
    end) 

    Tabs.H:AddSection({Translator:traduzir("Repetição De Nomes")}) 
    local Remote = ReplicatedStorage.RE:FindFirstChild("1RPNam1eTex1t") 
    local name1, name2, name3 = "", "", "" 
    local repeatNames = false 

    Tabs.H:AddTextBox({ 
        Title = Translator:traduzir("Nome"), 
        Description = Translator:traduzir("Primeiro Nome Da Repetição!"), 
        Default = "", 
        PlaceholderText = "Nick Aqui", 
        ClearText = false, 
        Callback = function(N) name1 = N end 
    }) 
    Tabs.H:AddTextBox({ 
        Title = Translator:traduzir("Nome"), 
        Description = Translator:traduzir("Segundo Nome Da Repetição!"), 
        Default = "", 
        PlaceholderText = "Nick Aqui", 
        ClearText = false, 
        Callback = function(N) name2 = N end 
    }) 
    Tabs.H:AddTextBox({ 
        Title = Translator:traduzir("Nome"), 
        Description = Translator:traduzir("Terceiro Nome Da Repetição!"), 
        Default = "", 
        PlaceholderText = "Nick Aqui", 
        ClearText = false, 
        Callback = function(N) name3 = N end 
    }) 

    local function getRandomColor() 
        return Color3.new(math.random(), math.random(), math.random()) 
    end 

    local RemoteEvent = ReplicatedStorage.RE:FindFirstChild("1RPNam1eColo1r") 
    local nameColorRunning = false 
    local function changeNameColor() 
        while nameColorRunning do 
            local randomColor = getRandomColor() 
            local args = { [1] = "PickingRPNameColor", [2] = randomColor } 
            RemoteEvent:FireServer(unpack(args)) 
            task.wait(0.5) 
        end 
    end 

    local Toggle = Tabs.H:AddToggle({ 
        Name = Translator:traduzir("NOME RGB"), 
        Description = Translator:traduzir("mudar a cor dos nomes automático"), 
        Default = false 
    }) 
    Toggle:Callback(function(Value) 
        nameColorRunning = Value 
        if nameColorRunning then 
            task.spawn(changeNameColor) 
        end 
    end) 

    local Toggle = Tabs.H:AddToggle({ 
        Name = Translator:traduzir("Reptir Nomes"), 
        Description = Translator:traduzir("Repitir nomes da textbox automaticamente"), 
        Default = false 
    }) 
    Toggle:Callback(function(R) 
        repeatNames = R 
        if R then 
            task.spawn(function() 
                while repeatNames do 
                    if Remote then 
                        Remote:FireServer("RolePlayName", name1) 
                        task.wait(1) 
                        Remote:FireServer("RolePlayName", name2) 
                        task.wait(1) 
                        Remote:FireServer("RolePlayName", name3) 
                        task.wait(1) 
                    end 
                end 
            end) 
        end 
    end) 

    Tabs.H:AddSection({Translator:traduzir("Nomes Ja feitos!")}) 
    local names = { 
        {"TINTALEY", " TINTALEY "}, 
        {"erro_426", " erro_246 "}, 
        {"Tralalero", " Tralalero "}, 
        {"VIGOR VIGOR VIGOR", " VIGOR VIGOR VIGOR "}, 
        {"HACKED", " HACKED "}, 
        {"ERESGAY", " ERESGAY "} 
    } 
    for _, name in ipairs(names) do 
        Tabs.H:AddButton({ 
            Name = "Nomes Feitos: " .. name[1], 
            Callback = function() 
                game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayName", name[2]) 
            end 
        }) 
    end 
end 

-- ///////TABS - PR///////-----------------
Tabs.PR:AddSection({Translator:traduzir("Proteções Local & Anti Lags")}) 
local Players = game:GetService("Players") 
local Workspace = game:GetService("Workspace") 
local player = Players.LocalPlayer 
local antiToolSit, antiCarSit, antiVehicleCollision = false, false, false 
local conns = {} 
local dripsActive = false 
local keywords = { "bomb", "soccer", "boat" } 
local carKeyword = "car" 
local wheelKeyword = "wheel" 

local function containsKeyword(name, list) 
    if typeof(name) ~= "string" then return false end 
    local lower = name:lower() 
    for _, word in ipairs(list) do 
        if lower:find(word) then return true end 
    end 
    return false 
end 

local function applyCollisionLogic(obj) 
    if not obj:IsA("BasePart") then return end 
    local name = obj.Name:lower() 
    if name:find(wheelKeyword) then return end 
    local isKeyword = containsKeyword(name, keywords) 
    local isCar = false 
    local parent = obj 
    while parent do 
        local pname = parent.Name:lower() 
        if pname:find(wheelKeyword) then return end 
        if pname:find(carKeyword) then 
            isCar = true 
            break 
        end 
        parent = parent.Parent 
    end 
    if isCar then 
        obj.CanCollide = not antiCarSit 
    elseif isKeyword then 
        obj.CanCollide = not antiVehicleCollision 
    end 
end 

local function fullScan() 
    for _, obj in ipairs(Workspace:GetDescendants()) do 
        applyCollisionLogic(obj) 
    end 
end 

local function dripsolutions() 
    if dripsActive then return end 
    dripsActive = true 
    fullScan() 
    table.insert(conns, Workspace.DescendantAdded:Connect(applyCollisionLogic)) 
end 

local function updateSitState() 
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid") 
    if hum then 
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, not (antiToolSit or antiCarSit)) 
    end 
end 

local function onCharacterAdded(char) 
    local hum = char:WaitForChild("Humanoid") 
    updateSitState() 
    table.insert(conns, hum.StateChanged:Connect(function(_, new) 
        if (antiToolSit or antiCarSit) and new == Enum.HumanoidStateType.Seated then 
            hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
        end 
    end)) 
end 

player.CharacterAdded:Connect(onCharacterAdded) 
if player.Character then 
    onCharacterAdded(player.Character) 
end 

local function handleToggle() 
    if antiToolSit or antiCarSit or antiVehicleCollision then 
        dripsolutions() 
    end 
    updateSitState() 
    fullScan() 
end 

local Toggle1 = Tabs.PR:AddToggle({ 
    Name = Translator:traduzir("Anti Tool"), 
    Description = Translator:traduzir("Impede sentar via Tool"), 
    Default = false 
}) 
Toggle1:Callback(function(Value) 
    antiToolSit = Value 
    handleToggle() 
end) 

local Toggle2 = Tabs.PR:AddToggle({ 
    Name = Translator:traduzir("Anti Car"), 
    Description = Translator:traduzir("Impede sentar em Carro"), 
    Default = false 
}) 
Toggle2:Callback(function(Value) 
    antiCarSit = Value 
    handleToggle() 
end) 

local Toggle3 = Tabs.PR:AddToggle({ 
    Name = Translator:traduzir("Anti Script"), 
    Description = Translator:traduzir("Proteção contra colisões de veículos/objetos"), 
    Default = false 
}) 
Toggle3:Callback(function(Value) 
    antiVehicleCollision = Value 
    handleToggle() 
end) 

local RunService = game:GetService("RunService") 
local AntiWeaponConn 
local AntiWeapon_Toggle = Tabs.PR:AddToggle({ 
    Name = Translator:traduzir("Anti Bug"), 
    Description = Translator:traduzir("Bug players/Bug Weapon/Protection rapidez"), 
    Default = false 
}) 
AntiWeapon_Toggle:Callback(function(enabled) 
    if AntiWeaponConn then 
        AntiWeaponConn:Disconnect() 
        AntiWeaponConn = nil 
    end 
    if enabled then 
        AntiWeaponConn = RunService.Stepped:Connect(function() 
            local cam = workspace.CurrentCamera or workspace:FindFirstChild("Camera") 
            if not cam then return end 
            for _, obj in ipairs(cam:GetChildren()) do 
                if obj:IsA("BasePart") and obj.Name == "water" then 
                    pcall(function() obj:Destroy() end) 
                end 
            end 
        end) 
    end 
end) 

local AntiChatSpy_Toggle = Tabs.PR:AddToggle({ 
    Name = Translator:traduzir("Anti ChatSpy"), 
    Description = Translator:traduzir("Impede que outros vejam seus chats "), 
    Default = false 
}) 
AntiChatSpy_Toggle:Callback(function(Value) 
    if Value then 
        local ChatSpy = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("ChatSpy") 
        if ChatSpy then ChatSpy.Disabled = true end 
    else 
        local ChatSpy = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("ChatSpy") 
        if ChatSpy then ChatSpy.Disabled = false end 
    end 
end) 

--[[ 
local Players = game:GetService("Players") 
local Workspace = game:GetService("Workspace") 
local RunService = game:GetService("RunService") 
local player = Players.LocalPlayer 
local antiToolSit, antiCarSit, antiVehicleCollision = false, false, false 
local conns = {} 
local keywords = { "bomb", "soccer", "boat" } 
local carKeyword = "car" 
local wheelKeyword = "wheel" 

local function containsKeyword(name, list) 
    if typeof(name) ~= "string" then return false end 
    local lower = name:lower() 
    for _, word in ipairs(list) do 
        if lower:find(word) then return true end 
    end 
    return false 
end 

local function applyCollisionLogic(obj) 
    if not obj:IsA("BasePart") then return end 
    local name = obj.Name:lower() 
    if name:find(wheelKeyword) then return end 
    local isKeyword = containsKeyword(name, keywords) 
    local isCar = false 
    local parent = obj 
    while parent do 
        local pname = parent.Name:lower() 
        if pname:find(wheelKeyword) then return end 
        if pname:find(carKeyword) then 
            isCar = true 
            break 
        end 
        parent = parent.Parent 
    end 
    if isCar then 
        obj.CanCollide = not antiCarSit 
    elseif isKeyword then 
        obj.CanCollide = not antiVehicleCollision 
    end 
end 

local function fullScan() 
    for _, obj in ipairs(Workspace:GetDescendants()) do 
        applyCollisionLogic(obj) 
    end 
end 

local function dripsolutions() 
    fullScan() 
    table.insert(conns, Workspace.DescendantAdded:Connect(applyCollisionLogic)) 
end 

local function updateSitState() 
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid") 
    if hum then 
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, not (antiToolSit or antiCarSit)) 
    end 
end 

local function onCharacterAdded(char) 
    local hum = char:WaitForChild("Humanoid") 
    updateSitState() 
    table.insert(conns, hum.StateChanged:Connect(function(_, new) 
        if (antiToolSit or antiCarSit) and new == Enum.HumanoidStateType.Seated then 
            hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
        end 
    end)) 
end 

player.CharacterAdded:Connect(onCharacterAdded) 
if player.Character then 
    onCharacterAdded(player.Character) 
end 

dripsolutions() 

local Toggle1 = Tabs.PR:AddToggle({ 
    Name = Translator:traduzir("Anti Tool"), 
    Description = Translator:traduzir("Impede sentar via Tool"), 
    Default = false 
}) 
Toggle1:Callback(function(Value) 
    antiToolSit = Value 
    updateSitState() 
    fullScan() 
end) 

[local Toggle2 = Tabs.PR:AddToggle({ 
    Name = Translator:traduzir("Anti Car"), 
    Description = Translator:traduzir("Impede sentar em Carro"), 
    Default = false 
}) 
Toggle2:Callback(function(Value) 
    antiCarSit = Value 
    updateSitState() 
    fullScan() 
end)] 

local Toggle3 = Tabs.PR:AddToggle({ 
    Name = Translator:traduzir("Anti Script"), 
    Description = Translator:traduzir("Proteção contra colisões de veículos/objetos"), 
    Default = false 
}) 
Toggle3:Callback(function(Value) 
    antiVehicleCollision = Value 
    updateSitState() 
    fullScan() 
end) 
]] 

Tabs.PR:AddSection({Translator:traduzir("Efeito e desefeitos")}) 
local Button = Tabs.PR:AddButton({Translator:traduzir("Anti Lag"), function() 
    local itemsToRemove = { 
        "Burger Tray", "Bomb", "Laptop", "Paper Bag", "Chips", "Ice Cream", 
        "Taser", "Basketball", "FireX", "Ladder", "Ghost Meter", "Clipboard", 
        "Stretcher", "Glock" 
    } 
end}) 