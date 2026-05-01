local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer

local AuroraUI = {
    Version = "1.0.0",
    Windows = {},
    Theme = {}
}

local DefaultTheme = {
    Background = Color3.fromRGB(12, 14, 20),
    Surface = Color3.fromRGB(20, 24, 34),
    Card = Color3.fromRGB(28, 34, 46),
    Accent = Color3.fromRGB(124, 92, 255),
    AccentSecondary = Color3.fromRGB(0, 212, 255),
    Text = Color3.fromRGB(245, 247, 250),
    Subtext = Color3.fromRGB(150, 160, 175),
    Border = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(248, 113, 113)
}

for key, value in pairs(DefaultTheme) do
    AuroraUI.Theme[key] = value
end

local function merge(defaults, options)
    local output = {}
    for key, value in pairs(defaults) do
        output[key] = value
    end
    for key, value in pairs(options or {}) do
        output[key] = value
    end
    return output
end

local function tween(object, time, props, style, direction)
    local info = TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(object, info, props)
    t:Play()
    return t
end

local function make(className, props, children)
    local obj = Instance.new(className)
    for key, value in pairs(props or {}) do
        obj[key] = value
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

local function corner(parent, radius)
    return make("UICorner", {CornerRadius = UDim.new(0, radius or 16), Parent = parent})
end

local function stroke(parent, color, transparency, thickness)
    return make("UIStroke", {Color = color or AuroraUI.Theme.Border, Transparency = transparency or 0.85, Thickness = thickness or 1, Parent = parent})
end

local function gradient(parent, c1, c2, rotation)
    return make("UIGradient", {Color = ColorSequence.new(c1 or AuroraUI.Theme.Accent, c2 or AuroraUI.Theme.AccentSecondary), Rotation = rotation or 35, Parent = parent})
end

local function padding(parent, left, right, top, bottom)
    return make("UIPadding", {PaddingLeft = UDim.new(0, left or 0), PaddingRight = UDim.new(0, right or left or 0), PaddingTop = UDim.new(0, top or left or 0), PaddingBottom = UDim.new(0, bottom or top or left or 0), Parent = parent})
end

local function list(parent, direction, gap, align)
    return make("UIListLayout", {FillDirection = direction or Enum.FillDirection.Vertical, Padding = UDim.new(0, gap or 8), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = align or Enum.HorizontalAlignment.Left, Parent = parent})
end

local function textLabel(props)
    return make("TextLabel", merge({BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextColor3 = AuroraUI.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextSize = 14, TextWrapped = true}, props))
end

local function textButton(props)
    return make("TextButton", merge({AutoButtonColor = false, Font = Enum.Font.GothamMedium, TextColor3 = AuroraUI.Theme.Text, TextSize = 14, Text = "", BackgroundColor3 = AuroraUI.Theme.Card}, props))
end

local function card(parent, size)
    local f = make("Frame", {Parent = parent, BackgroundColor3 = AuroraUI.Theme.Card, BackgroundTransparency = 0.08, Size = size or UDim2.new(1, 0, 0, 58)})
    corner(f, 16)
    stroke(f, AuroraUI.Theme.Border, 0.9, 1)
    return f
end

local function labelPair(parent, title, desc)
    local holder = make("Frame", {Parent = parent, BackgroundTransparency = 1, Size = UDim2.new(1, -90, 1, 0)})
    list(holder, Enum.FillDirection.Vertical, 2)
    local t = textLabel({Parent = holder, Size = UDim2.new(1, 0, 0, 22), Text = title or "Element", TextSize = 14, Font = Enum.Font.GothamSemibold})
    local d = textLabel({Parent = holder, Size = UDim2.new(1, 0, 0, 28), Text = desc or "", TextSize = 12, TextColor3 = AuroraUI.Theme.Subtext})
    return holder, t, d
end

local function addHover(button, normal, hover)
    button.MouseEnter:Connect(function()
        tween(button, 0.18, {BackgroundColor3 = hover or AuroraUI.Theme.Surface})
    end)
    button.MouseLeave:Connect(function()
        tween(button, 0.18, {BackgroundColor3 = normal or AuroraUI.Theme.Card})
    end)
end

local WindowMethods = {}
WindowMethods.__index = WindowMethods

local TabMethods = {}
TabMethods.__index = TabMethods

local SectionMethods = {}
SectionMethods.__index = SectionMethods

function AuroraUI:SetTheme(theme)
    for key, value in pairs(theme or {}) do
        self.Theme[key] = value
    end
end

function AuroraUI:Notify(options)
    options = merge({Title = "AuroraUI", Content = "Notification", Duration = 4, Type = "Info"}, options)
    local gui = self.ScreenGui
    if not gui then
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        gui = make("ScreenGui", {Name = "AuroraUINotifications", IgnoreGuiInset = true, ResetOnSpawn = false, Parent = playerGui})
        self.ScreenGui = gui
    end
    local holder = gui:FindFirstChild("AuroraNotifications") or make("Frame", {Name = "AuroraNotifications", Parent = gui, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 18), Size = UDim2.fromOffset(310, 600)})
    if not holder:FindFirstChildOfClass("UIListLayout") then
        list(holder, Enum.FillDirection.Vertical, 10, Enum.HorizontalAlignment.Right)
    end
    local item = card(holder, UDim2.new(1, 0, 0, 82))
    item.BackgroundTransparency = 0.04
    item.Position = UDim2.new(0, 50, 0, 0)
    item.BackgroundColor3 = AuroraUI.Theme.Surface
    local scale = make("UIScale", {Scale = 0.94, Parent = item})
    padding(item, 14, 14, 10, 10)
    local top = textLabel({Parent = item, Size = UDim2.new(1, 0, 0, 24), Text = options.Title, Font = Enum.Font.GothamBold, TextSize = 15})
    local body = textLabel({Parent = item, Position = UDim2.fromOffset(0, 28), Size = UDim2.new(1, 0, 0, 34), Text = options.Content, TextSize = 12, TextColor3 = AuroraUI.Theme.Subtext})
    local bar = make("Frame", {Parent = item, BackgroundColor3 = AuroraUI.Theme.Accent, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 3)})
    corner(bar, 3)
    gradient(bar, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecondary, 0)
    tween(scale, 0.25, {Scale = 1})
    tween(item, 0.25, {Position = UDim2.new(0, 0, 0, 0)})
    tween(bar, options.Duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
    task.delay(options.Duration, function()
        if item.Parent then
            tween(scale, 0.2, {Scale = 0.92})
            local out = tween(item, 0.2, {BackgroundTransparency = 1})
            out.Completed:Wait()
            item:Destroy()
        end
    end)
end

function WindowMethods:Show()
    self.Visible = true
    self.Main.Visible = true
    self.OpenPill.Visible = false
    tween(self.Scale, 0.25, {Scale = 1})
    tween(self.Main, 0.25, {GroupTransparency = 0})
end

function WindowMethods:Hide()
    self.Visible = false
    tween(self.Scale, 0.2, {Scale = 0.96})
    local t = tween(self.Main, 0.2, {GroupTransparency = 1})
    t.Completed:Connect(function()
        if not self.Visible then
            self.Main.Visible = false
        end
    end)
end

function WindowMethods:Minimize()
    if not self.Options.Minimizable then
        return
    end
    self:Hide()
    task.delay(0.18, function()
        self.OpenPill.Visible = true
        tween(self.PillScale, 0.24, {Scale = 1})
    end)
end

function WindowMethods:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
end

function WindowMethods:CreateTab(options)
    options = merge({Name = "Tab", Icon = "◆", Group = "General"}, options)
    local tab = setmetatable({Window = self, Options = options, Sections = {}}, TabMethods)
    local group = self.Groups[options.Group]
    if not group then
        group = make("Frame", {Parent = self.Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), AutomaticSize = Enum.AutomaticSize.Y})
        list(group, Enum.FillDirection.Vertical, 6)
        textLabel({Parent = group, Size = UDim2.new(1, 0, 0, 16), Text = string.upper(options.Group), TextSize = 10, TextColor3 = AuroraUI.Theme.Subtext, Font = Enum.Font.GothamBold})
        self.Groups[options.Group] = group
    end
    local button = textButton({Parent = group, BackgroundColor3 = AuroraUI.Theme.Card, BackgroundTransparency = 0.4, Size = UDim2.new(1, 0, 0, 36), Text = "  " .. tostring(options.Icon) .. "  " .. options.Name, TextXAlignment = Enum.TextXAlignment.Left})
    corner(button, 12)
    stroke(button, AuroraUI.Theme.Border, 0.92, 1)
    addHover(button, AuroraUI.Theme.Card, AuroraUI.Theme.Surface)
    local page = make("ScrollingFrame", {Parent = self.Pages, Name = options.Name, Visible = false, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3})
    padding(page, 4, 8, 4, 8)
    list(page, Enum.FillDirection.Vertical, 10)
    tab.Button = button
    tab.Page = page
    button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    table.insert(self.Tabs, tab)
    if not self.ActiveTab then
        self:SelectTab(tab)
    end
    return tab
end

function WindowMethods:SelectTab(tab)
    for _, current in ipairs(self.Tabs) do
        current.Page.Visible = current == tab
        if current == tab then
            tween(current.Button, 0.2, {BackgroundColor3 = AuroraUI.Theme.Accent, BackgroundTransparency = 0.08})
        else
            tween(current.Button, 0.2, {BackgroundColor3 = AuroraUI.Theme.Card, BackgroundTransparency = 0.4})
        end
    end
    self.ActiveTab = tab
end

function TabMethods:CreateSection(options)
    options = merge({Title = "Section", Description = ""}, options)
    local section = setmetatable({Tab = self, Options = options}, SectionMethods)
    local box = make("Frame", {Parent = self.Page, BackgroundColor3 = AuroraUI.Theme.Surface, BackgroundTransparency = 0.08, Size = UDim2.new(1, 0, 0, 80), AutomaticSize = Enum.AutomaticSize.Y})
    corner(box, 18)
    stroke(box, AuroraUI.Theme.Border, 0.9, 1)
    padding(box, 12, 12, 12, 12)
    list(box, Enum.FillDirection.Vertical, 8)
    textLabel({Parent = box, Size = UDim2.new(1, 0, 0, 22), Text = options.Title, Font = Enum.Font.GothamBold, TextSize = 15})
    if options.Description and options.Description ~= "" then
        textLabel({Parent = box, Size = UDim2.new(1, 0, 0, 20), Text = options.Description, TextSize = 12, TextColor3 = AuroraUI.Theme.Subtext})
    end
    section.Container = box
    table.insert(self.Sections, section)
    return section
end

function SectionMethods:CreateButton(options)
    options = merge({Title = "Button", Description = "", Icon = "", Callback = function() end}, options)
    local btn = textButton({Parent = self.Container, Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = AuroraUI.Theme.Card})
    corner(btn, 16)
    stroke(btn, AuroraUI.Theme.Border, 0.9, 1)
    padding(btn, 12, 12, 7, 7)
    labelPair(btn, options.Title, options.Description)
    local icon = textLabel({Parent = btn, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(58, 28), Text = options.Icon ~= "" and options.Icon or "Run", TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = AuroraUI.Theme.Accent})
    addHover(btn, AuroraUI.Theme.Card, AuroraUI.Theme.Surface)
    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.08, {Size = UDim2.new(1, -4, 0, 56)})
        task.delay(0.08, function()
            if btn.Parent then
                tween(btn, 0.12, {Size = UDim2.new(1, 0, 0, 58)})
            end
        end)
        task.spawn(options.Callback)
    end)
    return btn
end

function SectionMethods:CreateToggle(options)
    options = merge({Title = "Toggle", Description = "", Default = false, Callback = function() end}, options)
    local state = options.Default == true
    local row = textButton({Parent = self.Container, Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = AuroraUI.Theme.Card})
    corner(row, 16)
    stroke(row, AuroraUI.Theme.Border, 0.9, 1)
    padding(row, 12, 12, 7, 7)
    labelPair(row, options.Title, options.Description)
    local track = make("Frame", {Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(52, 30), BackgroundColor3 = state and AuroraUI.Theme.Accent or AuroraUI.Theme.Surface})
    corner(track, 30)
    local thumb = make("Frame", {Parent = track, Size = UDim2.fromOffset(24, 24), Position = state and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
    corner(thumb, 24)
    addHover(row, AuroraUI.Theme.Card, AuroraUI.Theme.Surface)
    local function set(value)
        state = value
        tween(track, 0.2, {BackgroundColor3 = state and AuroraUI.Theme.Accent or AuroraUI.Theme.Surface})
        tween(thumb, 0.2, {Position = state and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3)})
        task.spawn(options.Callback, state)
    end
    row.MouseButton1Click:Connect(function()
        set(not state)
    end)
    return {Set = set, Get = function() return state end, Instance = row}
end

function SectionMethods:CreateSlider(options)
    options = merge({Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Callback = function() end}, options)
    local value = math.clamp(options.Default, options.Min, options.Max)
    local row = card(self.Container, UDim2.new(1, 0, 0, 76))
    padding(row, 12, 12, 8, 8)
    labelPair(row, options.Title, options.Description)
    local valueText = textLabel({Parent = row, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 8), Size = UDim2.fromOffset(70, 24), Text = tostring(value), TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = AuroraUI.Theme.Accent})
    local track = make("Frame", {Parent = row, BackgroundColor3 = AuroraUI.Theme.Surface, Position = UDim2.new(0, 12, 1, -20), Size = UDim2.new(1, -24, 0, 6)})
    corner(track, 6)
    local fill = make("Frame", {Parent = track, BackgroundColor3 = AuroraUI.Theme.Accent, Size = UDim2.new((value - options.Min) / (options.Max - options.Min), 0, 1, 0)})
    corner(fill, 6)
    gradient(fill, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecondary, 0)
    local dragging = false
    local function setFromX(x)
        local alpha = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = options.Min + (options.Max - options.Min) * alpha
        value = math.floor(raw / options.Increment + 0.5) * options.Increment
        value = math.clamp(value, options.Min, options.Max)
        local newAlpha = (value - options.Min) / (options.Max - options.Min)
        tween(fill, 0.08, {Size = UDim2.new(newAlpha, 0, 1, 0)})
        valueText.Text = tostring(value)
        task.spawn(options.Callback, value)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return {Set = function(v) value = math.clamp(v, options.Min, options.Max) end, Get = function() return value end, Instance = row}
end

function SectionMethods:CreateDropdown(options)
    options = merge({Title = "Dropdown", Description = "", Options = {}, Default = nil, Callback = function() end}, options)
    local selected = options.Default or options.Options[1] or "None"
    local row = textButton({Parent = self.Container, Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = AuroraUI.Theme.Card})
    corner(row, 16)
    stroke(row, AuroraUI.Theme.Border, 0.9, 1)
    padding(row, 12, 12, 7, 7)
    labelPair(row, options.Title, options.Description)
    local valueText = textLabel({Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(120, 28), Text = tostring(selected), TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = AuroraUI.Theme.Accent})
    local menu = make("Frame", {Parent = self.Container, Visible = false, BackgroundColor3 = AuroraUI.Theme.Card, BackgroundTransparency = 0.05, Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true})
    corner(menu, 14)
    stroke(menu, AuroraUI.Theme.Border, 0.9, 1)
    list(menu, Enum.FillDirection.Vertical, 4)
    padding(menu, 8, 8, 8, 8)
    for _, option in ipairs(options.Options) do
        local opt = textButton({Parent = menu, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = AuroraUI.Theme.Surface, BackgroundTransparency = 0.35, Text = tostring(option)})
        corner(opt, 10)
        addHover(opt, AuroraUI.Theme.Surface, AuroraUI.Theme.Accent)
        opt.MouseButton1Click:Connect(function()
            selected = option
            valueText.Text = tostring(option)
            tween(menu, 0.18, {Size = UDim2.new(1, 0, 0, 0)})
            task.delay(0.18, function() menu.Visible = false end)
            task.spawn(options.Callback, option)
        end)
    end
    row.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
        local h = menu.Visible and (#options.Options * 38 + 16) or 0
        tween(menu, 0.2, {Size = UDim2.new(1, 0, 0, h)})
    end)
    return {Get = function() return selected end, Instance = row}
end

function SectionMethods:CreateKeybind(options)
    options = merge({Title = "Keybind", Description = "", Default = Enum.KeyCode.F, Callback = function() end}, options)
    local key = options.Default
    local listening = false
    local row = textButton({Parent = self.Container, Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = AuroraUI.Theme.Card})
    corner(row, 16)
    stroke(row, AuroraUI.Theme.Border, 0.9, 1)
    padding(row, 12, 12, 7, 7)
    labelPair(row, options.Title, options.Description)
    local keyText = textLabel({Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(100, 28), Text = key.Name, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = AuroraUI.Theme.Accent})
    row.MouseButton1Click:Connect(function()
        listening = true
        keyText.Text = "..."
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
            key = input.KeyCode
            keyText.Text = key.Name
            listening = false
            return
        end
        if input.KeyCode == key then
            task.spawn(options.Callback)
        end
    end)
    return {Get = function() return key end, Instance = row}
end

function SectionMethods:CreateTextBox(options)
    options = merge({Title = "TextBox", Description = "", Placeholder = "Enter text...", Callback = function() end}, options)
    local row = card(self.Container, UDim2.new(1, 0, 0, 86))
    padding(row, 12, 12, 8, 8)
    labelPair(row, options.Title, options.Description)
    local box = make("TextBox", {Parent = row, BackgroundColor3 = AuroraUI.Theme.Surface, Position = UDim2.new(0, 12, 1, -34), Size = UDim2.new(1, -24, 0, 28), Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = AuroraUI.Theme.Text, PlaceholderText = options.Placeholder, PlaceholderColor3 = AuroraUI.Theme.Subtext, Text = "", ClearTextOnFocus = false})
    corner(box, 10)
    stroke(box, AuroraUI.Theme.Border, 0.9, 1)
    box.FocusLost:Connect(function()
        task.spawn(options.Callback, box.Text)
    end)
    return box
end

function SectionMethods:CreateSeparator(options)
    options = merge({Text = ""}, options)
    local sep = make("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Border, BackgroundTransparency = 0.9, Size = UDim2.new(1, 0, 0, 1)})
    return sep
end

function AuroraUI:CreateWindow(options)
    options = merge({Title = "Aurora UI", Subtitle = "Premium Roblox Interface", Footer = "AuroraUI • v1.0.0", Thumbnail = "", Banner = "", Size = UDim2.fromOffset(620, 430), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), ToggleKey = Enum.KeyCode.RightShift, MinimizeKey = Enum.KeyCode.M, Theme = "Dark", Acrylic = true, Noise = true, Shadow = true, Blur = true, MobileScale = 0.85, Draggable = true, Closable = true, Minimizable = true}, options)
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local gui = make("ScreenGui", {Name = "AuroraUI", IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = playerGui})
    self.ScreenGui = gui
    local main = make("CanvasGroup", {Parent = gui, AnchorPoint = options.AnchorPoint, Position = options.Position, Size = options.Size, BackgroundColor3 = AuroraUI.Theme.Background, BackgroundTransparency = 0.03, ClipsDescendants = true})
    corner(main, 24)
    stroke(main, AuroraUI.Theme.Border, 0.82, 1)
    gradient(main, AuroraUI.Theme.Background, AuroraUI.Theme.Surface, 45)
    local scale = make("UIScale", {Parent = main, Scale = UserInputService.TouchEnabled and options.MobileScale or 0.96})
    local header = make("Frame", {Parent = main, BackgroundColor3 = AuroraUI.Theme.Surface, BackgroundTransparency = 0.15, Size = UDim2.new(1, 0, 0, 84)})
    gradient(header, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecondary, 25)
    local headerShade = make("Frame", {Parent = header, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.55, Size = UDim2.new(1, 0, 1, 0)})
    local title = textLabel({Parent = header, Position = UDim2.fromOffset(22, 16), Size = UDim2.new(1, -150, 0, 30), Text = options.Title, Font = Enum.Font.GothamBold, TextSize = 22})
    local subtitle = textLabel({Parent = header, Position = UDim2.fromOffset(22, 46), Size = UDim2.new(1, -150, 0, 20), Text = options.Subtitle, TextSize = 12, TextColor3 = AuroraUI.Theme.Subtext})
    local min = textButton({Parent = header, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -58, 0, 18), Size = UDim2.fromOffset(34, 34), Text = "−", TextSize = 20, BackgroundColor3 = AuroraUI.Theme.Card, BackgroundTransparency = 0.25})
    corner(min, 12)
    local close = textButton({Parent = header, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 18), Size = UDim2.fromOffset(34, 34), Text = "×", TextSize = 20, BackgroundColor3 = AuroraUI.Theme.Error, BackgroundTransparency = 0.15})
    corner(close, 12)
    local body = make("Frame", {Parent = main, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 84), Size = UDim2.new(1, 0, 1, -118)})
    local sidebar = make("ScrollingFrame", {Parent = body, BackgroundColor3 = AuroraUI.Theme.Surface, BackgroundTransparency = 0.35, BorderSizePixel = 0, Size = UDim2.fromOffset(170, 1), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0})
    sidebar.Size = UDim2.new(0, 170, 1, 0)
    padding(sidebar, 12, 12, 12, 12)
    list(sidebar, Enum.FillDirection.Vertical, 10)
    local pages = make("Frame", {Parent = body, BackgroundTransparency = 1, Position = UDim2.fromOffset(180, 0), Size = UDim2.new(1, -190, 1, 0)})
    local footer = textLabel({Parent = main, Position = UDim2.new(0, 18, 1, -30), Size = UDim2.new(1, -36, 0, 20), Text = options.Footer, TextSize = 11, TextColor3 = AuroraUI.Theme.Subtext})
    local pill = textButton({Parent = gui, Visible = false, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -24), Size = UDim2.fromOffset(220, 46), Text = "AuroraUI  •  Abrir", BackgroundColor3 = AuroraUI.Theme.Surface, BackgroundTransparency = 0.04, TextSize = 14})
    corner(pill, 28)
    stroke(pill, AuroraUI.Theme.Border, 0.84, 1)
    gradient(pill, AuroraUI.Theme.Surface, AuroraUI.Theme.Card, 20)
    local pillScale = make("UIScale", {Parent = pill, Scale = 0.8})
    local window = setmetatable({Gui = gui, Main = main, Scale = scale, OpenPill = pill, PillScale = pillScale, Sidebar = sidebar, Pages = pages, Options = options, Tabs = {}, Groups = {}, Visible = true}, WindowMethods)
    min.MouseButton1Click:Connect(function() window:Minimize() end)
    close.MouseButton1Click:Connect(function() window:Hide() end)
    pill.MouseButton1Click:Connect(function() window:Show() end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == options.ToggleKey then
            if window.Main.Visible then window:Hide() else window:Show() end
        elseif input.KeyCode == options.MinimizeKey then
            window:Minimize()
        end
    end)
    if options.Draggable then
        local dragging = false
        local dragStart
        local startPos
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
    tween(scale, 0.28, {Scale = UserInputService.TouchEnabled and options.MobileScale or 1})
    table.insert(self.Windows, window)
    return window
end

return AuroraUI
