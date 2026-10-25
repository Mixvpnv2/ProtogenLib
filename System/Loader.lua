--[[ System/Loader.lua ]]
local KeySystem = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Mixvpnv2/ProtogenLib/main/System/Key.lua"
))()

-- авто-вход
local saved = KeySystem:TrySaved()
if saved then
    local ok = KeySystem:LoadScript()
    if ok then return end
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local gui = Instance.new("ScreenGui")
gui.Name = "CatteLoader"
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ProtectGui(gui)
gui.Parent = CoreGui

-- фон
local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.fromScale(1, 1)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.4
backdrop.BorderSizePixel = 0
backdrop.Parent = gui

-- карточка
local card = Instance.new("Frame")
card.Name = "TargetBox"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.5)
card.Size = UDim2.fromOffset(320, 150)
card.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
card.BorderSizePixel = 0
card.Parent = gui

Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", card)
stroke.Color = Color3.fromRGB(0, 200, 180)
stroke.Thickness = 1.2
stroke.Transparency = 0.15

-- иконка слева
local icon = Instance.new("ImageLabel")
icon.Name = "IconGame"
icon.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
icon.Size = UDim2.fromOffset(56, 56)
icon.Position = UDim2.fromOffset(14, 16)
icon.Image = "rbxassetid://0" -- свой id если есть
icon.Parent = card
Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 8)

local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Color = Color3.fromRGB(40, 45, 55)
iconStroke.Thickness = 1

-- название
local nameGame = Instance.new("TextLabel")
nameGame.Name = "NameGame"
nameGame.BackgroundTransparency = 1
nameGame.Position = UDim2.fromOffset(82, 14)
nameGame.Size = UDim2.fromOffset(220, 22)
nameGame.Font = Enum.Font.GothamBold
nameGame.TextSize = 16
nameGame.TextXAlignment = Enum.TextXAlignment.Left
nameGame.TextColor3 = Color3.fromRGB(240, 240, 240)
nameGame.Text = "Universal"
nameGame.Parent = card

-- Risky
local risky = Instance.new("TextLabel")
risky.Name = "Risky"
risky.BackgroundTransparency = 1
risky.Position = UDim2.fromOffset(82, 38)
risky.Size = UDim2.fromOffset(220, 18)
risky.Font = Enum.Font.Gotham
risky.TextSize = 13
risky.TextXAlignment = Enum.TextXAlignment.Left
risky.TextColor3 = Color3.fromRGB(255, 70, 70)
risky.Text = "Risky : Yes"
risky.Parent = card

-- Template / подпись под иконкой
local template = Instance.new("TextLabel")
template.BackgroundTransparency = 1
template.Position = UDim2.fromOffset(14, 74)
template.Size = UDim2.fromOffset(56, 14)
template.Font = Enum.Font.Gotham
template.TextSize = 11
template.TextColor3 = Color3.fromRGB(140, 140, 140)
template.Text = "Template"
template.Parent = card

-- поле ключа
local keyBg = Instance.new("Frame")
keyBg.Size = UDim2.fromOffset(180, 26)
keyBg.Position = UDim2.fromOffset(82, 72)
keyBg.BackgroundColor3 = Color3.fromRGB(32, 34, 40)
keyBg.BorderSizePixel = 0
keyBg.Parent = card
Instance.new("UICorner", keyBg).CornerRadius = UDim.new(0, 6)

local keyBox = Instance.new("TextBox")
keyBox.Name = "PressKey"
keyBox.BackgroundTransparency = 1
keyBox.Size = UDim2.new(1, -12, 1, 0)
keyBox.Position = UDim2.fromOffset(6, 0)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 13
keyBox.TextColor3 = Color3.fromRGB(230, 230, 230)
keyBox.PlaceholderText = "Press Key"
keyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.Parent = keyBg

-- Time
local timeLabel = Instance.new("TextLabel")
timeLabel.Name = "Time"
timeLabel.BackgroundTransparency = 1
timeLabel.Position = UDim2.fromOffset(14, 118)
timeLabel.Size = UDim2.fromOffset(140, 16)
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 12
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
timeLabel.Text = "Time : LifeTime"
timeLabel.Parent = card

-- Inject
local inject = Instance.new("TextButton")
inject.Name = "Inject"
inject.Size = UDim2.fromOffset(90, 26)
inject.Position = UDim2.fromOffset(214, 112)
inject.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
inject.BorderSizePixel = 0
inject.Font = Enum.Font.GothamMedium
inject.TextSize = 13
inject.TextColor3 = Color3.fromRGB(240, 240, 240)
inject.Text = "Inject"
inject.AutoButtonColor = true
inject.Parent = card
Instance.new("UICorner", inject).CornerRadius = UDim.new(0, 6)

local injectStroke = Instance.new("UIStroke", inject)
injectStroke.Color = Color3.fromRGB(0, 180, 160)
injectStroke.Thickness = 1
injectStroke.Transparency = 0.3

local busy = false
local status = risky -- пишем статус сюда же

local function closeLoader()
    local t1 = TweenService:Create(card, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
    local t2 = TweenService:Create(backdrop, TweenInfo.new(0.25), { BackgroundTransparency = 1 })
    t1:Play()
    t2:Play()
    t2.Completed:Wait()
    gui:Destroy()
end

local function onInject()
    if busy then return end
    busy = true
    inject.Text = "..."
    status.TextColor3 = Color3.fromRGB(220, 200, 80)
    status.Text = "Checking..."

    local ok = KeySystem:Accept(keyBox.Text)
    if not ok then
        status.Text = "Risky : Invalid key"
        status.TextColor3 = Color3.fromRGB(255, 70, 70)
        inject.Text = "Inject"
        busy = false
        return
    end

    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(80, 220, 140)

    local loaded, err = KeySystem:LoadScript()
    if not loaded then
        status.Text = err or "Load failed"
        status.TextColor3 = Color3.fromRGB(255, 70, 70)
        inject.Text = "Inject"
        busy = false
        return
    end

    -- успех → лоадер пропадает
    closeLoader()
end

inject.MouseButton1Click:Connect(onInject)
keyBox.FocusLost:Connect(function(enter)
    if enter then onInject() end
end)
