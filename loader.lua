--[[
    Floomp — Loader
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

local CONFIG = {
    BgTop        = Color3.fromRGB(38, 42, 56),
    BgBottom     = Color3.fromRGB(22, 24, 34),
    Accent       = Color3.fromRGB(100, 160, 255),
    AccentDark   = Color3.fromRGB(64, 116, 200),
    AccentGlow   = Color3.fromRGB(140, 190, 255),
    TextColor    = Color3.fromRGB(240, 244, 250),
    SubTextColor = Color3.fromRGB(150, 158, 176),
    OnlineColor  = Color3.fromRGB(86, 220, 130),
    StrokeLight  = Color3.fromRGB(80, 88, 110),
    StrokeDark   = Color3.fromRGB(15, 16, 22),
    Font         = Enum.Font.Gotham,
    FontBold     = Enum.Font.GothamBold,
}

local BRAND_NAME = "Floomp"

-- ============ СПИСОК СКРИПТОВ ============
-- [PlaceId] = { name = "Название", url = "ссылка" }
local SCRIPTS = {
    [9872472334] = { name = "Evade",   url = "https://raw.githubusercontent.com/floomp666/floomp-scripts/refs/heads/main/evade.lua" },
    [286090429]  = { name = "Arsenal", url = "https://raw.githubusercontent.com/ТВОЙ_ЮЗЕР/floomp-scripts/main/arsenal.lua" },
    [2788229376] = { name = "Da Hood", url = "https://raw.githubusercontent.com/ТВОЙ_ЮЗЕР/floomp-scripts/main/dahood.lua" },
    [6516141723] = { name = "Doors",   url = "https://raw.githubusercontent.com/ТВОЙ_ЮЗЕР/floomp-scripts/main/doors.lua" },
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

local function Gradient(parent, color1, color2, rotation)
    return Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2),
        }),
        Rotation = rotation or 90,
        Parent = parent,
    })
end

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

local LoadingScreen = Create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(12, 14, 20),
    BorderSizePixel = 0,
    ZIndex = 500,
    Parent = ScreenGui,
})

local LoadingContainer = Create("Frame", {
    Size = UDim2.fromOffset(420, 200),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CONFIG.BgBottom,
    BorderSizePixel = 0,
    ZIndex = 501,
    Parent = LoadingScreen,
})
Corner(LoadingContainer, UDim.new(0, 16))
Stroke(LoadingContainer, CONFIG.StrokeLight, 1, 0.3)
Gradient(LoadingContainer, CONFIG.BgTop, CONFIG.BgBottom, 90)

Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.fromOffset(0, 22),
    BackgroundTransparency = 1,
    Font = CONFIG.FontBold,
    Text = BRAND_NAME,
    TextColor3 = CONFIG.AccentGlow,
    TextSize = 36,
    ZIndex = 502,
    Parent = LoadingContainer,
})

local StatusLabel = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.fromOffset(0, 66),
    BackgroundTransparency = 1,
    Font = CONFIG.Font,
    Text = "Определение игры...",
    TextColor3 = CONFIG.SubTextColor,
    TextSize = 13,
    ZIndex = 502,
    Parent = LoadingContainer,
})

local GameLabel = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.fromOffset(0, 88),
    BackgroundTransparency = 1,
    Font = CONFIG.FontBold,
    Text = "",
    TextColor3 = CONFIG.Accent,
    TextSize = 18,
    ZIndex = 502,
    Parent = LoadingContainer,
})

local LoadingBarBg = Create("Frame", {
    Size = UDim2.fromOffset(340, 8),
    Position = UDim2.new(0.5, -170, 0, 130),
    BackgroundColor3 = Color3.fromRGB(40, 44, 58),
    BorderSizePixel = 0,
    ZIndex = 502,
    Parent = LoadingContainer,
})
Corner(LoadingBarBg, UDim.new(1, 0))
Stroke(LoadingBarBg, CONFIG.StrokeDark, 1, 0.5)

local LoadingBarFill = Create("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = CONFIG.Accent,
    BorderSizePixel = 0,
    ZIndex = 503,
    Parent = LoadingBarBg,
})
Corner(LoadingBarFill, UDim.new(1, 0))
Gradient(LoadingBarFill, CONFIG.AccentGlow, CONFIG.AccentDark, 0)

local LoadingPercent = Create("TextLabel", {
    Size = UDim2.fromOffset(340, 20),
    Position = UDim2.new(0.5, -170, 0, 148),
    BackgroundTransparency = 1,
    Font = CONFIG.Font,
    Text = "0%",
    TextColor3 = CONFIG.TextColor,
    TextSize = 13,
    ZIndex = 502,
    Parent = LoadingContainer,
})

local function setProgress(value)
    value = math.clamp(value, 0, 100)
    TweenService:Create(LoadingBarFill, TweenInfo.new(0.25), {
        Size = UDim2.new(value / 100, 0, 1, 0),
    }):Play()
    LoadingPercent.Text = math.floor(value) .. "%"
end

local function setStatus(text, color)
    StatusLabel.Text = text
    if color then StatusLabel.TextColor3 = color end
end

task.wait(0.4)
setProgress(20)
setStatus("Определение игры...", CONFIG.SubTextColor)
task.wait(0.5)

local placeId = game.PlaceId
local scriptInfo = SCRIPTS[placeId]

if not scriptInfo then
    setProgress(100)
    setStatus("Игра не поддерживается", Color3.fromRGB(255, 80, 80))
    GameLabel.Text = "PlaceId: " .. placeId

    task.wait(2.5)

    local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(LoadingScreen, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LoadingContainer, fadeInfo, { BackgroundTransparency = 1 }):Play()
    for _, obj in ipairs(LoadingContainer:GetDescendants()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, fadeInfo, { TextTransparency = 1 }):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, fadeInfo, { BackgroundTransparency = 1 }):Play()
        elseif obj:IsA("UIStroke") then
            TweenService:Create(obj, fadeInfo, { Transparency = 1 }):Play()
        end
    end

    task.wait(0.55)
    ScreenGui:Destroy()
    return
end

setProgress(45)
GameLabel.Text = scriptInfo.name
setStatus("Подготовка к загрузке...", CONFIG.SubTextColor)
task.wait(0.5)

setProgress(65)
setStatus("Загрузка скрипта...", CONFIG.AccentGlow)
task.wait(0.4)

local code = nil
local fetchOk, fetchErr = pcall(function()
    code = game:HttpGet(scriptInfo.url)
end)

if not fetchOk or not code or #code == 0 then
    setProgress(100)
    setStatus("Ошибка загрузки", Color3.fromRGB(255, 80, 80))
    GameLabel.Text = "Скрипт недоступен"

    task.wait(2.5)

    local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(LoadingScreen, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LoadingContainer, fadeInfo, { BackgroundTransparency = 1 }):Play()
    for _, obj in ipairs(LoadingContainer:GetDescendants()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, fadeInfo, { TextTransparency = 1 }):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, fadeInfo, { BackgroundTransparency = 1 }):Play()
        elseif obj:IsA("UIStroke") then
            TweenService:Create(obj, fadeInfo, { Transparency = 1 }):Play()
        end
    end

    task.wait(0.55)
    ScreenGui:Destroy()
    return
end

setProgress(85)
setStatus("Запуск...", CONFIG.OnlineColor)
task.wait(0.3)

local function hideLoader()
    local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(LoadingScreen, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LoadingContainer, fadeInfo, {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(380, 180),
    }):Play()
    for _, obj in ipairs(LoadingContainer:GetDescendants()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, fadeInfo, { TextTransparency = 1 }):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, fadeInfo, { BackgroundTransparency = 1 }):Play()
        elseif obj:IsA("UIStroke") then
            TweenService:Create(obj, fadeInfo, { Transparency = 1 }):Play()
        end
    end
    task.wait(0.5)
    ScreenGui:Destroy()
end

setProgress(100)
task.wait(0.3)

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
