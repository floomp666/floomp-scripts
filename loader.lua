--[[
    Floomp — Loader
    Fullscreen ASCII loader. Detects game by PlaceId, falls back to universal.
    Discord button in bottom-right corner.
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

local function Create(className, props, children)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, child in ipairs(children or {}) do child.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Corner(parent, radius)
    local r
    if type(radius) == "number" then
        r = UDim.new(0, radius)
    elseif typeof(radius) == "UDim" then
        r = radius
    else
        r = UDim.new(0, 8)
    end
    return Create("UICorner", { CornerRadius = r, Parent = parent })
end

-- ============ СПИСОК СКРИПТОВ ============
local SCRIPTS = {
    [9872472334]      = { name = "Evade",         url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/evade.lua" },
    [10324346056]      = { name = "Evade",         url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/evade.lua" },
    [10808838353]      = { name = "Evade",         url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/evade.lua" },
    [286090429]       = { name = "Arsenal",       url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/arsenal.lua" },
    [1962086868]      = { name = "Tower of Hell", url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/toh.lua" },
    [114234929420007] = { name = "BloxStrike",    url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/bloxstrike.lua" },
}

-- загружается, если PlaceId не найден в SCRIPTS
local DEFAULT_SCRIPT = {
    name = "Universal",
    url  = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/universal.lua",
}

-- ссылка на Discord
local DISCORD_URL = "https://discord.gg/VbPTEmhXwy"

-- ============ SCREENGUI ============
local ScreenGui = Create("ScreenGui", {
    Name = "FloompLoader",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
})

if gethui then
    ScreenGui.Parent = gethui()
else
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
end
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local THEME = {
    Background = Color3.fromRGB(10, 11, 16),
    Panel      = Color3.fromRGB(17, 19, 27),
    Card       = Color3.fromRGB(24, 27, 38),
    Hover      = Color3.fromRGB(36, 41, 56),
    Accent     = Color3.fromRGB(145, 112, 255),
    Border     = Color3.fromRGB(47, 51, 69),
    Text       = Color3.fromRGB(243, 244, 252),
    Muted      = Color3.fromRGB(142, 149, 169),
    Green      = Color3.fromRGB(112, 230, 170),
    Red        = Color3.fromRGB(255, 105, 125),
    Orange     = Color3.fromRGB(255, 190, 105),
}

-- ================================================================
-- FULLSCREEN LOADING
-- ================================================================

local LoadingScreen = Create("Frame", {
    Name = "LoadingScreen",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = THEME.Background,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ZIndex = 500,
    Parent = ScreenGui,
})

local Content = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(560, 220),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 501,
    Parent = LoadingScreen,
})

Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, 0, 0, 18),
    Text = "floomp@loader:~$  ./init.sh",
    TextSize = 12,
    TextColor3 = THEME.Muted,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = Content,
})

Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 30),
    Size = UDim2.new(1, 0, 0, 44),
    Text = "FLOOMP  //  LOADER",
    TextSize = 32,
    TextColor3 = THEME.Accent,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = Content,
})

Create("Frame", {
    Position = UDim2.fromOffset(0, 84),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = THEME.Border,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    ZIndex = 502,
    Parent = Content,
})

local LoadingAsciiBar = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 100),
    Size = UDim2.new(1, 0, 0, 28),
    Text = "[░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  0%",
    TextSize = 20,
    TextColor3 = THEME.Accent,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = Content,
})

local GameLabel = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 138),
    Size = UDim2.new(1, 0, 0, 22),
    Text = "",
    TextSize = 16,
    TextColor3 = THEME.Text,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = Content,
})

local LoadingHint = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 164),
    Size = UDim2.new(1, 0, 0, 18),
    Text = "> initializing...",
    TextSize = 12,
    TextColor3 = THEME.Muted,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = Content,
})

local LoadingHint2 = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 182),
    Size = UDim2.new(1, 0, 0, 18),
    Text = "",
    TextSize = 12,
    TextColor3 = THEME.Muted,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 1,
    ZIndex = 502,
    Parent = Content,
})

local LoadingCursor = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 204),
    Size = UDim2.fromOffset(14, 18),
    Text = "▌",
    TextSize = 14,
    TextColor3 = THEME.Accent,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = Content,
})

local CursorActive = true
task.spawn(function()
    while CursorActive do
        if LoadingCursor and LoadingCursor.Parent then
            LoadingCursor.TextTransparency = 0
        end
        task.wait(0.5)
        if LoadingCursor and LoadingCursor.Parent then
            LoadingCursor.TextTransparency = 1
        end
        task.wait(0.5)
    end
end)

local BAR_LENGTH = 30

local function buildAsciiBar(percent)
    percent = math.clamp(percent, 0, 100)
    local filled = math.floor((percent / 100) * BAR_LENGTH + 0.5)
    local bar = ""
    for i = 1, BAR_LENGTH do
        if i <= filled then bar = bar .. "▓"
        else bar = bar .. "░" end
    end
    return "[" .. bar .. "]  " .. tostring(math.floor(percent)) .. "%"
end

local function setProgress(value)
    value = math.clamp(value, 0, 100)
    LoadingAsciiBar.Text = buildAsciiBar(value)
end

local function setStatus(hint, hint2, color)
    if hint then
        LoadingHint.Text = "> " .. hint
    end
    if hint2 then
        LoadingHint2.Text = "> " .. hint2
        LoadingHint2.TextTransparency = 0
    end
    if color then
        LoadingHint.TextColor3 = color
    end
end

local function setGame(text, color)
    GameLabel.Text = text or ""
    GameLabel.TextColor3 = color or THEME.Text
end

local function step(percent, hint, hint2, color, delay, gameText, gameColor)
    setProgress(percent)
    setStatus(hint, hint2, color)
    if gameText then
        setGame(gameText, gameColor)
    end
    task.wait(delay or 0.4)
end

local function hideLoader()
    CursorActive = false

    local fadeInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(LoadingScreen, fadeInfo, { BackgroundTransparency = 1 }):Play()

    for _, obj in ipairs(Content:GetDescendants()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, fadeInfo, { TextTransparency = 1 }):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, fadeInfo, { BackgroundTransparency = 1 }):Play()
        elseif obj:IsA("UIStroke") then
            TweenService:Create(obj, fadeInfo, { Transparency = 1 }):Play()
        end
    end

    task.wait(0.6)
end

-- ================================================================
-- DISCORD BUTTON
-- ================================================================

local DiscordButton = Create("Frame", {
    Name = "DiscordButton",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, 300, 1, -22),
    Size = UDim2.fromOffset(260, 56),
    BackgroundColor3 = THEME.Panel,
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    ZIndex = 510,
    Parent = ScreenGui,
})
Corner(DiscordButton, 12)
local discordStroke = Create("UIStroke", {
    Color = Color3.fromRGB(88, 101, 242),
    Thickness = 1,
    Transparency = 0.3,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = DiscordButton,
})

Create("Frame", {
    Position = UDim2.fromOffset(0, 10),
    Size = UDim2.new(0, 3, 1, -20),
    BackgroundColor3 = Color3.fromRGB(88, 101, 242),
    BorderSizePixel = 0,
    ZIndex = 511,
    Parent = DiscordButton,
})

local iconBox = Create("Frame", {
    Position = UDim2.fromOffset(14, 12),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = THEME.Card,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    ZIndex = 520,
    Parent = DiscordButton,
})
Corner(iconBox, 8)

Create("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(22, 22),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Image = "rbxassetid://15465699788",
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 521,
    Parent = iconBox,
})

Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(56, 10),
    Size = UDim2.new(1, -110, 0, 20),
    Text = "Join our Discord",
    TextSize = 14,
    TextColor3 = THEME.Text,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 511,
    Parent = DiscordButton,
})

Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(56, 30),
    Size = UDim2.new(1, -110, 0, 16),
    Text = "updates, support, scripts",
    TextSize = 11,
    TextColor3 = THEME.Muted,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 511,
    Parent = DiscordButton,
})

local discordClose = Create("TextButton", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -6, 0, 6),
    Size = UDim2.fromOffset(22, 22),
    BackgroundColor3 = THEME.Hover,
    Text = "×",
    TextSize = 16,
    TextColor3 = THEME.Muted,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 512,
    Parent = DiscordButton,
})
Corner(discordClose, 6)

local discordClick = Create("TextButton", {
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, -30, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
    ZIndex = 511,
    Parent = DiscordButton,
})

task.delay(0.2, function()
    TweenService:Create(DiscordButton, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -22, 1, -22),
    }):Play()
end)

discordClick.MouseEnter:Connect(function()
    TweenService:Create(DiscordButton, TweenInfo.new(0.2), {
        BackgroundColor3 = THEME.Card,
    }):Play()
    TweenService:Create(discordStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(115, 128, 255),
        Transparency = 0,
    }):Play()
end)
discordClick.MouseLeave:Connect(function()
    TweenService:Create(DiscordButton, TweenInfo.new(0.2), {
        BackgroundColor3 = THEME.Panel,
    }):Play()
    TweenService:Create(discordStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(88, 101, 242),
        Transparency = 0.3,
    }):Play()
end)

discordClick.Activated:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(DISCORD_URL) end
    end)
    pcall(function()
        game:GetService("GuiService"):OpenBrowserWindow(DISCORD_URL)
    end)
end)

discordClose.MouseEnter:Connect(function()
    TweenService:Create(discordClose, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(91, 39, 55),
        TextColor3 = THEME.Red,
    }):Play()
end)
discordClose.MouseLeave:Connect(function()
    TweenService:Create(discordClose, TweenInfo.new(0.2), {
        BackgroundColor3 = THEME.Hover,
        TextColor3 = THEME.Muted,
    }):Play()
end)

discordClose.Activated:Connect(function()
    TweenService:Create(DiscordButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 300, 1, -22),
        BackgroundTransparency = 1,
    }):Play()
    task.wait(0.35)
    if DiscordButton and DiscordButton.Parent then
        DiscordButton:Destroy()
    end
end)

-- ================================================================
-- ОПРЕДЕЛЕНИЕ ИГРЫ И ЗАГРУЗКА
-- ================================================================

step(15, "loading services", "userinput, http", THEME.Muted, 0.35, "", THEME.Text)
step(35, "detecting game", "placeid", THEME.Muted, 0.35, "", THEME.Text)

local placeId = game.PlaceId
local scriptInfo = SCRIPTS[placeId]
local isFallback = false

if scriptInfo then
    step(50, "game detected", "placeid → " .. scriptInfo.name, THEME.Accent, 0.5, scriptInfo.name, THEME.Accent)
else
    isFallback = true
    scriptInfo = DEFAULT_SCRIPT
    step(50, "unsupported", "universal fallback", THEME.Orange, 0.6, scriptInfo.name, THEME.Orange)
end

step(65, "fetching script", scriptInfo.name .. ".lua", THEME.Muted, 0.4, scriptInfo.name, isFallback and THEME.Orange or THEME.Accent)

local code = nil
local fetchOk = pcall(function()
    code = game:HttpGet(scriptInfo.url)
end)

if not fetchOk or not code or #code == 0 then
    step(100, "fetch failed", "script unreachable", THEME.Red, 2.5, scriptInfo.name, THEME.Red)
    hideLoader()
    return
end

step(85, "executing", "loadstring", THEME.Green, 0.4, scriptInfo.name, THEME.Green)
step(100, "ready", "floomp loaded", THEME.Green, 0.6, scriptInfo.name, THEME.Green)

task.spawn(hideLoader)

task.wait(0.15)

local runOk, runErr = pcall(function()
    local fn = loadstring(code)
    if fn then
        fn()
    else
        error("loadstring вернул nil")
    end
end)

if not runOk then
    warn("[Floomp] Ошибка запуска скрипта:", runErr)
end
