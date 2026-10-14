--[[
    Floomp — Loader
    ASCII Terminal Design (Variant F)
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

local CONFIG = {
    BgTop        = Color3.fromRGB(10, 11, 16),
    BgBottom     = Color3.fromRGB(17, 19, 27),
    Panel        = Color3.fromRGB(17, 19, 27),
    Hover        = Color3.fromRGB(36, 41, 56),
    Accent       = Color3.fromRGB(145, 112, 255),
    AccentDark   = Color3.fromRGB(91, 65, 199),
    AccentGlow   = Color3.fromRGB(175, 148, 255),
    TextColor    = Color3.fromRGB(243, 244, 252),
    SubTextColor = Color3.fromRGB(142, 149, 169),
    OnlineColor  = Color3.fromRGB(112, 230, 170),
    ErrorColor   = Color3.fromRGB(255, 105, 125),
    Border       = Color3.fromRGB(47, 51, 69),
    FontCode     = Enum.Font.Code,
}

local BRAND_NAME = "Floomp"

-- ============ СПИСОК СКРИПТОВ ============
-- [PlaceId] = { name = "Название", url = "ссылка" }
local SCRIPTS = {
    [9872472334] = { name = "Evade",   url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/evade.lua" },
    [286090429]  = { name = "Arsenal", url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/arsenal.lua" },
    [1962086868] = { name = "Tower of Hell", url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/toh.lua" },
    [114234929420007] = { name = "BloxStrike",   url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/bloxstrike.lua" },
}

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
    return Create("UICorner", { CornerRadius = radius or UDim.new(0, 14), Parent = parent })
end

local function Stroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(0, 0, 0),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

-- ============ SCREENGUI ============

local ScreenGui = Create("ScreenGui", {
    Name = BRAND_NAME .. "Loader",
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

-- ============ LOADING SCREEN ============

local LoadingScreen = Create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = CONFIG.BgTop,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 500,
    Parent = ScreenGui,
})

local LoadingContainer = Create("Frame", {
    Size = UDim2.fromOffset(540, 200),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CONFIG.Panel,
    BorderSizePixel = 0,
    ZIndex = 501,
    Parent = LoadingScreen,
})
Corner(LoadingContainer, UDim.new(0, 8))
Stroke(LoadingContainer, CONFIG.Border, 1, 0.2)

-- логотип
local LoadingLogo = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(24, 20),
    Size = UDim2.new(1, -48, 0, 30),
    Text = "FLOOMP  //  SYSTEM LOADER",
    TextSize = 14,
    TextColor3 = CONFIG.Accent,
    Font = CONFIG.FontCode,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = LoadingContainer,
})

-- разделитель
local LoadingDivider = Create("Frame", {
    Position = UDim2.fromOffset(24, 56),
    Size = UDim2.new(1, -48, 0, 1),
    BackgroundColor3 = CONFIG.Border,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    ZIndex = 502,
    Parent = LoadingContainer,
})

-- ASCII-бар
local LoadingAsciiBar = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(24, 72),
    Size = UDim2.new(1, -48, 0, 28),
    Text = "[░░░░░░░░░░░░░░░░░░░░]  0%",
    TextSize = 18,
    TextColor3 = CONFIG.Accent,
    Font = CONFIG.FontCode,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = LoadingContainer,
})

-- статус (основная строка лога)
local StatusLabel = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(24, 108),
    Size = UDim2.new(1, -48, 0, 20),
    Text = "> initializing...",
    TextSize = 13,
    TextColor3 = CONFIG.SubTextColor,
    Font = CONFIG.FontCode,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = LoadingContainer,
})

-- имя игры (вторичная строка)
local GameLabel = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(24, 128),
    Size = UDim2.new(1, -48, 0, 20),
    Text = "",
    TextSize = 13,
    TextColor3 = CONFIG.AccentGlow,
    Font = CONFIG.FontCode,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 1,
    ZIndex = 502,
    Parent = LoadingContainer,
})

-- мигающий курсор
local LoadingCursor = Create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(24, 148),
    Size = UDim2.fromOffset(20, 20),
    Text = "▌",
    TextSize = 14,
    TextColor3 = CONFIG.Accent,
    Font = CONFIG.FontCode,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 502,
    Parent = LoadingContainer,
})

-- прогресс-линия снизу
local LoadingProgressTrack = Create("Frame", {
    Position = UDim2.fromOffset(24, 172),
    Size = UDim2.new(1, -48, 0, 2),
    BackgroundColor3 = CONFIG.Hover,
    BorderSizePixel = 0,
    ZIndex = 502,
    Parent = LoadingContainer,
})
Corner(LoadingProgressTrack, UDim.new(0, 2))

local LoadingProgressFill = Create("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = CONFIG.Accent,
    BorderSizePixel = 0,
    ZIndex = 503,
    Parent = LoadingProgressTrack,
})
Corner(LoadingProgressFill, UDim.new(0, 2))

-- ============ CURSOR BLINK ============

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

-- ============ ASCII BAR ============

local BAR_LENGTH = 20

local function buildAsciiBar(percent)
    percent = math.clamp(percent, 0, 100)
    local filled = math.floor((percent / 100) * BAR_LENGTH + 0.5)

    local bar = ""
    for i = 1, BAR_LENGTH do
        if i <= filled then
            bar = bar .. "▓"
        else
            bar = bar .. "░"
        end
    end

    return "[" .. bar .. "]  " .. tostring(math.floor(percent)) .. "%"
end

local function setProgress(value)
    value = math.clamp(value, 0, 100)
    LoadingAsciiBar.Text = buildAsciiBar(value)

    TweenService:Create(LoadingProgressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(value / 100, 0, 1, 0),
    }):Play()
end

local function setStatus(text, color)
    StatusLabel.Text = "> " .. text
    if color then StatusLabel.TextColor3 = color end
end

local function setGame(text)
    GameLabel.Text = "> " .. text
    TweenService:Create(GameLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
end

-- ============ HIDE LOADER ============

local function hideLoader()
    CursorActive = false

    local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(LoadingScreen, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingContainer, fadeInfo, {BackgroundTransparency = 1}):Play()

    for _, obj in ipairs(LoadingContainer:GetDescendants()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, fadeInfo, {TextTransparency = 1}):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, fadeInfo, {BackgroundTransparency = 1}):Play()
        elseif obj:IsA("UIStroke") then
            TweenService:Create(obj, fadeInfo, {Transparency = 1}):Play()
        end
    end

    task.wait(0.5)
    ScreenGui:Destroy()
end

-- ============ MAIN FLOW ============

task.wait(0.4)
setProgress(20)
setStatus("detecting game...", CONFIG.SubTextColor)
task.wait(0.5)

local placeId = game.PlaceId
local scriptInfo = SCRIPTS[placeId]

if not scriptInfo then
    setProgress(100)
    setStatus("unsupported game", CONFIG.ErrorColor)
    setGame("PlaceId: " .. placeId)
    task.wait(2.5)
    hideLoader()
    return
end

setProgress(45)
setGame(scriptInfo.name)
setStatus("preparing...", CONFIG.SubTextColor)
task.wait(0.5)

setProgress(65)
setStatus("downloading script...", CONFIG.AccentGlow)
task.wait(0.4)

local code = nil
local fetchOk, fetchErr = pcall(function()
    code = game:HttpGet(scriptInfo.url)
end)

if not fetchOk or not code or #code == 0 then
    setProgress(100)
    setStatus("download failed", CONFIG.ErrorColor)
    setGame("script unavailable")
    task.wait(2.5)
    hideLoader()
    return
end

setProgress(85)
setStatus("launching...", CONFIG.OnlineColor)
task.wait(0.3)

setProgress(100)
task.wait(0.3)

task.spawn(hideLoader)

task.wait(0.15)

local runOk, runErr = pcall(function()
    local fn = loadstring(code)
    if fn then
        fn()
    else
        error("loadstring returned nil")
    end
end)

if not runOk then
    warn("[Floomp] Script launch error:", runErr)
end
