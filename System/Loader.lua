local SCRIPT_URL = "https://raw.githubusercontent.com/Mixvpnv2/CatteState/refs/heads/main/MainScripts/Main.lua"
local KEYS_URL = BASE .. "/keys"
local SAVE_PATH  = "CatteState/key.txt"

if getgenv().CatteInjected then
    print("You Used Scripts")
    return
end

local function httpGet(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    return ok and res or nil
end

local function fetchKeys()
    local body = httpGet(KEYS_URL)
    local list = {}
    if not body then return list end
    for line in body:gmatch("[^\r\n]+") do
        line = line:gsub("%s+", "")
        if line ~= "" and not line:find("^#") then
            list[line] = true
        end
    end
    return list
end

local function readSaved()
    if isfile and isfile(SAVE_PATH) then
        return readfile(SAVE_PATH)
    end
end

local function saveKey(key)
    if makefolder then pcall(makefolder, "CatteState") end
    if writefile then pcall(writefile, SAVE_PATH, key) end
end

local function isValid(key)
    if type(key) ~= "string" then return false end
    key = key:gsub("%s+", "")
    if key == "" then return false end
    return fetchKeys()[key] == true
end

local function loadScript()
    local src = httpGet(SCRIPT_URL)
    if not src then return false, "Fetch failed" end
    local fn, err = loadstring(src)
    if not fn then return false, err or "loadstring error" end
    task.spawn(fn)
    return true
end

do
    local saved = readSaved()
    if saved and isValid(saved) then
        if getgenv().CatteInjected then
            print("You Used Scripts")
            return
        end
        getgenv().CatteInjected = true
        if loadScript() then return end
        getgenv().CatteInjected = false
    end
end

local gameName = "No Name"
pcall(function()
    local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    if info and type(info.Name) == "string" and info.Name ~= "" then
        gameName = info.Name
    end
end)

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local Accent = Color3.fromRGB(0, 85, 255)
local Main = Color3.fromRGB(28, 28, 28)
local Background = Color3.fromRGB(20, 20, 20)
local Outline = Color3.fromRGB(50, 50, 50)
local FontColor = Color3.fromRGB(255, 255, 255)
local RiskColor = Color3.fromRGB(255, 50, 50)

local gui = Instance.new("ScreenGui")
gui.Name = "CatteLoader"
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ProtectGui(gui)
gui.Parent = CoreGui

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

local backdrop = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = gui,
})
TweenService:Create(backdrop, TweenInfo.new(0.2), { BackgroundTransparency = 0.45 }):Play()

local card = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(340, 150),
    BackgroundColor3 = Background,
    BorderColor3 = Outline,
    BorderMode = Enum.BorderMode.Inset,
    BorderSizePixel = 1,
    Parent = gui,
})

create("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = Accent,
    BorderSizePixel = 0,
    Parent = card,
})

local closeBtn = create("TextButton", {
    BackgroundTransparency = 1,
    Size = UDim2.fromOffset(22, 22),
    Position = UDim2.new(1, -26, 0, 6),
    Font = Enum.Font.Code,
    TextSize = 16,
    Text = "x",
    TextColor3 = Color3.fromRGB(160, 160, 160),
    AutoButtonColor = false,
    Parent = card,
})
closeBtn.MouseEnter:Connect(function()
    closeBtn.TextColor3 = RiskColor
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
end)

local iconBox = create("Frame", {
    Size = UDim2.fromOffset(52, 52),
    Position = UDim2.fromOffset(14, 16),
    BackgroundColor3 = Main,
    BorderColor3 = Outline,
    BorderMode = Enum.BorderMode.Inset,
    Parent = card,
})

create("ImageLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Image = "rbxassetid://6031280882",
    ScaleType = Enum.ScaleType.Fit,
    Parent = iconBox,
})

create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 72),
    Size = UDim2.fromOffset(52, 28),
    Font = Enum.Font.Code,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(160, 160, 160),
    Text = gameName,
    TextWrapped = true,
    TextYAlignment = Enum.TextYAlignment.Top,
    Parent = card,
})

create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(78, 14),
    Size = UDim2.fromOffset(230, 20),
    Font = Enum.Font.Code,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = FontColor,
    Text = "load scripts",
    Parent = card,
})

local status = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(78, 36),
    Size = UDim2.fromOffset(230, 16),
    Font = Enum.Font.Code,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = RiskColor,
    Text = "Risky : Yes",
    Parent = card,
})

local keyOuter = create("Frame", {
    Size = UDim2.fromOffset(190, 24),
    Position = UDim2.fromOffset(78, 64),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BorderColor3 = Color3.new(0, 0, 0),
    Parent = card,
})

local keyInner = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Main,
    BorderColor3 = Outline,
    BorderMode = Enum.BorderMode.Inset,
    Parent = keyOuter,
})

local keyBox = create("TextBox", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.fromOffset(6, 0),
    Font = Enum.Font.Code,
    TextSize = 13,
    TextColor3 = FontColor,
    PlaceholderText = "Press Key",
    PlaceholderColor3 = Color3.fromRGB(140, 140, 140),
    ClearTextOnFocus = false,
    Text = "",
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = keyInner,
})

create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 118),
    Size = UDim2.fromOffset(150, 16),
    Font = Enum.Font.Code,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = Color3.fromRGB(150, 150, 150),
    Text = "Time : LifeTime",
    Parent = card,
})

local injOuter = create("Frame", {
    Size = UDim2.fromOffset(96, 24),
    Position = UDim2.fromOffset(228, 114),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BorderColor3 = Color3.new(0, 0, 0),
    Parent = card,
})

local injInner = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Main,
    BorderColor3 = Outline,
    BorderMode = Enum.BorderMode.Inset,
    Parent = injOuter,
})

local inject = create("TextButton", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.Code,
    TextSize = 13,
    TextColor3 = FontColor,
    Text = "Inject",
    AutoButtonColor = false,
    Parent = injInner,
})

injOuter.MouseEnter:Connect(function()
    injInner.BorderColor3 = Accent
end)
injOuter.MouseLeave:Connect(function()
    injInner.BorderColor3 = Outline
end)

local busy = false

local function destroyGui()
    TweenService:Create(backdrop, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
    card:Destroy()
    task.delay(0.16, function()
        if gui then gui:Destroy() end
    end)
end

closeBtn.MouseButton1Click:Connect(function()
    destroyGui()
end)

local function submit()
    if busy then return end

    if getgenv().CatteInjected then
        print("You Used Scripts")
        status.Text = "Already used"
        status.TextColor3 = RiskColor
        return
    end

    busy = true
    inject.Text = "..."
    status.Text = "Checking..."
    status.TextColor3 = Color3.fromRGB(230, 200, 80)

    local key = keyBox.Text:gsub("%s+", "")
    if not isValid(key) then
        status.Text = "Invalid key"
        status.TextColor3 = RiskColor
        inject.Text = "Inject"
        busy = false
        return
    end

    saveKey(key)
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(80, 220, 140)

    getgenv().CatteInjected = true
    local ok, err = loadScript()
    if not ok then
        getgenv().CatteInjected = false
        status.Text = err or "Load failed"
        status.TextColor3 = RiskColor
        inject.Text = "Inject"
        busy = false
        return
    end

    destroyGui()
end

inject.MouseButton1Click:Connect(submit)
keyBox.FocusLost:Connect(function(enter)
    if enter then submit() end
end)
