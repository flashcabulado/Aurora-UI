local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AuroraUI = {
    Version = "3.0.0",
    Theme = {},
    Windows = {}
}

local DefaultTheme = {
    Background = Color3.fromRGB(238, 242, 248),
    Surface = Color3.fromRGB(248, 250, 255),
    Sidebar = Color3.fromRGB(232, 237, 247),
    Card = Color3.fromRGB(255, 255, 255),
    CardHover = Color3.fromRGB(242, 246, 255),
    Accent = Color3.fromRGB(118, 85, 255),
    AccentSecond = Color3.fromRGB(65, 180, 255),
    Text = Color3.fromRGB(26, 30, 42),
    Muted = Color3.fromRGB(96, 108, 128),
    Border = Color3.fromRGB(205, 214, 230),
    Success = Color3.fromRGB(22, 163, 74),
    Warning = Color3.fromRGB(217, 119, 6),
    Error = Color3.fromRGB(225, 70, 86)
}

for k, v in pairs(DefaultTheme) do
    AuroraUI.Theme[k] = v
end

local function merge(a, b)
    local c = {}
    for k, v in pairs(a or {}) do c[k] = v end
    for k, v in pairs(b or {}) do c[k] = v end
    return c
end

local function new(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function corner(p, r)
    return new("UICorner", {Parent = p, CornerRadius = UDim.new(0, r or 14)})
end

local function stroke(p, color, transparency, thickness)
    return new("UIStroke", {Parent = p, Color = color or AuroraUI.Theme.Border, Transparency = transparency or 0.25, Thickness = thickness or 1})
end

local function pad(p, l, r, t, b)
    return new("UIPadding", {Parent = p, PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or l or 0), PaddingTop = UDim.new(0, t or l or 0), PaddingBottom = UDim.new(0, b or t or l or 0)})
end

local function list(p, gap)
    return new("UIListLayout", {Parent = p, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, gap or 8)})
end

local function gradient(p, a, b, rot)
    return new("UIGradient", {Parent = p, Rotation = rot or 25, Color = ColorSequence.new(a or AuroraUI.Theme.Accent, b or AuroraUI.Theme.AccentSecond)})
end

local function label(p, text, size, color, font)
    return new("TextLabel", {Parent = p, BackgroundTransparency = 1, Text = text or "", Font = font or Enum.Font.GothamMedium, TextSize = size or 14, TextColor3 = color or AuroraUI.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = true})
end

local function button(p, text)
    return new("TextButton", {Parent = p, AutoButtonColor = false, BackgroundColor3 = AuroraUI.Theme.Card, Text = text or "", Font = Enum.Font.GothamMedium, TextSize = 14, TextColor3 = AuroraUI.Theme.Text})
end

local function hover(obj, normal, over)
    obj.MouseEnter:Connect(function()
        tween(obj, 0.14, {BackgroundColor3 = over or AuroraUI.Theme.CardHover})
    end)
    obj.MouseLeave:Connect(function()
        tween(obj, 0.14, {BackgroundColor3 = normal or AuroraUI.Theme.Card})
    end)
end

local function itemBase(parent, height)
    local f = button(parent, "")
    f.Size = UDim2.new(1, 0, 0, height or 56)
    f.BackgroundColor3 = AuroraUI.Theme.Card
    f.Text = ""
    corner(f, 14)
    stroke(f, AuroraUI.Theme.Border, 0.35, 1)
    pad(f, 12, 12, 6, 6)
    return f
end

local function textBlock(parent, title, desc, right)
    local wrap = new("Frame", {Parent = parent, BackgroundTransparency = 1, Size = UDim2.new(1, -(right or 100), 1, 0)})
    list(wrap, 1)
    local t = label(wrap, title or "Element", 14, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
    t.Size = UDim2.new(1, 0, 0, 23)
    local d = label(wrap, desc or "", 12, AuroraUI.Theme.Muted, Enum.Font.GothamMedium)
    d.Size = UDim2.new(1, 0, 0, 24)
    return wrap
end

local Window = {}
Window.__index = Window
local Tab = {}
Tab.__index = Tab
local Section = {}
Section.__index = Section

function AuroraUI:SetTheme(t)
    for k, v in pairs(t or {}) do
        self.Theme[k] = v
    end
end

function AuroraUI:Notify(o)
    o = merge({Title = "AuroraUI", Content = "Loaded", Duration = 3}, o)
    local gui = self.Gui or new("ScreenGui", {Parent = PlayerGui, Name = "AuroraUI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    self.Gui = gui
    local holder = gui:FindFirstChild("Notifications") or new("Frame", {Parent = gui, Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 14), Size = UDim2.fromOffset(290, 500)})
    if not holder:FindFirstChildOfClass("UIListLayout") then list(holder, 8) end
    local card = new("Frame", {Parent = holder, BackgroundColor3 = AuroraUI.Theme.Card, Size = UDim2.new(1, 0, 0, 76)})
    corner(card, 16)
    stroke(card, AuroraUI.Theme.Border, 0.25, 1)
    pad(card, 12, 12, 8, 8)
    local sc = new("UIScale", {Parent = card, Scale = 0.92})
    local title = label(card, o.Title, 14, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    title.Size = UDim2.new(1, 0, 0, 24)
    local body = label(card, o.Content, 12, AuroraUI.Theme.Muted)
    body.Position = UDim2.fromOffset(0, 28)
    body.Size = UDim2.new(1, 0, 0, 26)
    local bar = new("Frame", {Parent = card, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Accent, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 3)})
    corner(bar, 3)
    gradient(bar, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)
    tween(sc, 0.18, {Scale = 1})
    tween(bar, o.Duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
    task.delay(o.Duration, function()
        if card.Parent then
            local out = tween(card, 0.18, {BackgroundTransparency = 1})
            tween(sc, 0.18, {Scale = 0.9})
            out.Completed:Wait()
            card:Destroy()
        end
    end)
end

function Window:Show()
    self.Visible = true
    self.Main.Visible = true
    self.OpenButton.Visible = false
    tween(self.Scale, 0.22, {Scale = self.TargetScale})
    tween(self.Main, 0.22, {GroupTransparency = 0})
end

function Window:Hide()
    self.Visible = false
    tween(self.Scale, 0.16, {Scale = self.TargetScale * 0.96})
    local t = tween(self.Main, 0.16, {GroupTransparency = 1})
    t.Completed:Connect(function()
        if not self.Visible then self.Main.Visible = false end
    end)
end

function Window:Minimize()
    self:Hide()
    task.delay(0.15, function()
        self.OpenButton.Visible = true
        tween(self.OpenScale, 0.18, {Scale = 1})
    end)
end

function Window:Destroy()
    if self.Gui then self.Gui:Destroy() end
end

function Window:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = t == tab
        if t == tab then
            tween(t.Button, 0.16, {BackgroundColor3 = AuroraUI.Theme.Accent})
            t.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tween(t.Button, 0.16, {BackgroundColor3 = AuroraUI.Theme.Card})
            t.Button.TextColor3 = AuroraUI.Theme.Text
        end
    end
    self.ActiveTab = tab
end

function Window:CreateTab(o)
    o = merge({Name = "Tab", Icon = "◆", Group = "General"}, o)
    local tab = setmetatable({Window = self, Options = o, Sections = {}}, Tab)
    local group = self.Groups[o.Group]
    if not group then
        group = new("Frame", {Parent = self.Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), AutomaticSize = Enum.AutomaticSize.Y})
        list(group, 6)
        local g = label(group, string.upper(o.Group), 10, AuroraUI.Theme.Muted, Enum.Font.GothamBold)
        g.Size = UDim2.new(1, 0, 0, 15)
        self.Groups[o.Group] = group
    end
    local b = button(group, "  " .. tostring(o.Icon) .. "  " .. o.Name)
    b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = AuroraUI.Theme.Card
    b.TextXAlignment = Enum.TextXAlignment.Left
    corner(b, 12)
    stroke(b, AuroraUI.Theme.Border, 0.4, 1)
    hover(b, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
    local page = new("ScrollingFrame", {Parent = self.Pages, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), Visible = false, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = AuroraUI.Theme.Accent})
    pad(page, 2, 6, 2, 8)
    list(page, 8)
    tab.Button = b
    tab.Page = page
    b.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    table.insert(self.Tabs, tab)
    if not self.ActiveTab then self:SelectTab(tab) end
    return tab
end

function Tab:CreateSection(o)
    o = merge({Title = "Section", Description = ""}, o)
    local section = setmetatable({Tab = self, Options = o}, Section)
    local box = new("Frame", {Parent = self.Page, BackgroundColor3 = AuroraUI.Theme.Surface, Size = UDim2.new(1, 0, 0, 72), AutomaticSize = Enum.AutomaticSize.Y})
    corner(box, 18)
    stroke(box, AuroraUI.Theme.Border, 0.25, 1)
    pad(box, 10, 10, 10, 10)
    list(box, 7)
    local t = label(box, o.Title, 15, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    t.Size = UDim2.new(1, 0, 0, 20)
    if o.Description ~= "" then
        local d = label(box, o.Description, 12, AuroraUI.Theme.Muted)
        d.Size = UDim2.new(1, 0, 0, 18)
    end
    section.Container = box
    return section
end

function Section:CreateButton(o)
    o = merge({Title = "Button", Description = "", Icon = "Run", Callback = function() end}, o)
    local row = itemBase(self.Container, 56)
    textBlock(row, o.Title, o.Description, 85)
    local right = label(row, o.Icon, 12, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    right.AnchorPoint = Vector2.new(1, 0.5)
    right.Position = UDim2.new(1, -10, 0.5, 0)
    right.Size = UDim2.fromOffset(72, 24)
    right.TextXAlignment = Enum.TextXAlignment.Right
    hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
    row.MouseButton1Click:Connect(function()
        tween(row, 0.07, {Size = UDim2.new(1, -3, 0, 54)})
        task.delay(0.07, function() if row.Parent then tween(row, 0.1, {Size = UDim2.new(1, 0, 0, 56)}) end end)
        task.spawn(o.Callback)
    end)
    return row
end

function Section:CreateToggle(o)
    o = merge({Title = "Toggle", Description = "", Default = false, Callback = function() end}, o)
    local state = o.Default == true
    local row = itemBase(self.Container, 56)
    textBlock(row, o.Title, o.Description, 75)
    local track = new("Frame", {Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(48, 26), BackgroundColor3 = state and AuroraUI.Theme.Accent or Color3.fromRGB(210, 218, 232)})
    corner(track, 26)
    local thumb = new("Frame", {Parent = track, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.fromOffset(20, 20), Position = state and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3)})
    corner(thumb, 20)
    hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
    local function set(v)
        state = v
        tween(track, 0.16, {BackgroundColor3 = state and AuroraUI.Theme.Accent or Color3.fromRGB(210, 218, 232)})
        tween(thumb, 0.16, {Position = state and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3)})
        task.spawn(o.Callback, state)
    end
    row.MouseButton1Click:Connect(function() set(not state) end)
    return {Set = set, Get = function() return state end, Instance = row}
end

function Section:CreateSlider(o)
    o = merge({Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Callback = function() end}, o)
    local value = math.clamp(o.Default, o.Min, o.Max)
    local row = new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Card, Size = UDim2.new(1, 0, 0, 76)})
    corner(row, 14)
    stroke(row, AuroraUI.Theme.Border, 0.35, 1)
    pad(row, 12, 12, 7, 7)
    textBlock(row, o.Title, o.Description, 80)
    local vt = label(row, tostring(value), 12, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    vt.AnchorPoint = Vector2.new(1, 0)
    vt.Position = UDim2.new(1, -10, 0, 8)
    vt.Size = UDim2.fromOffset(70, 22)
    vt.TextXAlignment = Enum.TextXAlignment.Right
    local track = new("Frame", {Parent = row, BackgroundColor3 = Color3.fromRGB(215, 223, 238), Position = UDim2.new(0, 12, 1, -20), Size = UDim2.new(1, -24, 0, 6)})
    corner(track, 6)
    local fill = new("Frame", {Parent = track, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Accent, Size = UDim2.new((value - o.Min) / (o.Max - o.Min), 0, 1, 0)})
    corner(fill, 6)
    gradient(fill, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)
    local dragging = false
    local function setFromX(x)
        local alpha = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = o.Min + (o.Max - o.Min) * alpha
        value = math.floor(raw / o.Increment + 0.5) * o.Increment
        value = math.clamp(value, o.Min, o.Max)
        vt.Text = tostring(value)
        tween(fill, 0.06, {Size = UDim2.new((value - o.Min) / (o.Max - o.Min), 0, 1, 0)})
        task.spawn(o.Callback, value)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true setFromX(input.Position.X) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setFromX(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    return {Get = function() return value end, Instance = row}
end

function Section:CreateDropdown(o)
    o = merge({Title = "Dropdown", Description = "", Options = {}, Default = nil, Callback = function() end}, o)
    local selected = o.Default or o.Options[1] or "None"
    local row = itemBase(self.Container, 56)
    textBlock(row, o.Title, o.Description, 125)
    local vt = label(row, tostring(selected), 12, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    vt.AnchorPoint = Vector2.new(1, 0.5)
    vt.Position = UDim2.new(1, -10, 0.5, 0)
    vt.Size = UDim2.fromOffset(115, 24)
    vt.TextXAlignment = Enum.TextXAlignment.Right
    local menu = new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Card, Visible = false, ClipsDescendants = true, Size = UDim2.new(1, 0, 0, 0)})
    corner(menu, 14)
    stroke(menu, AuroraUI.Theme.Border, 0.35, 1)
    pad(menu, 7, 7, 7, 7)
    list(menu, 5)
    for _, opt in ipairs(o.Options) do
        local ob = button(menu, tostring(opt))
        ob.Size = UDim2.new(1, 0, 0, 32)
        ob.BackgroundColor3 = AuroraUI.Theme.Surface
        corner(ob, 10)
        hover(ob, AuroraUI.Theme.Surface, AuroraUI.Theme.CardHover)
        ob.MouseButton1Click:Connect(function()
            selected = opt
            vt.Text = tostring(opt)
            tween(menu, 0.15, {Size = UDim2.new(1, 0, 0, 0)})
            task.delay(0.15, function() menu.Visible = false end)
            task.spawn(o.Callback, opt)
        end)
    end
    row.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
        tween(menu, 0.18, {Size = UDim2.new(1, 0, 0, menu.Visible and (#o.Options * 37 + 14) or 0)})
    end)
    return {Get = function() return selected end, Instance = row}
end

function Section:CreateKeybind(o)
    o = merge({Title = "Keybind", Description = "", Default = Enum.KeyCode.F, Callback = function() end}, o)
    local key = o.Default
    local listening = false
    local row = itemBase(self.Container, 56)
    textBlock(row, o.Title, o.Description, 90)
    local kt = label(row, key.Name, 12, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    kt.AnchorPoint = Vector2.new(1, 0.5)
    kt.Position = UDim2.new(1, -10, 0.5, 0)
    kt.Size = UDim2.fromOffset(80, 24)
    kt.TextXAlignment = Enum.TextXAlignment.Right
    row.MouseButton1Click:Connect(function() listening = true kt.Text = "..." end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
            key = input.KeyCode
            kt.Text = key.Name
            listening = false
            return
        end
        if input.KeyCode == key then task.spawn(o.Callback) end
    end)
    return {Get = function() return key end, Instance = row}
end

function Section:CreateTextBox(o)
    o = merge({Title = "TextBox", Description = "", Placeholder = "Enter text...", Callback = function() end}, o)
    local row = new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Card, Size = UDim2.new(1, 0, 0, 84)})
    corner(row, 14)
    stroke(row, AuroraUI.Theme.Border, 0.35, 1)
    pad(row, 12, 12, 7, 7)
    textBlock(row, o.Title, o.Description, 0)
    local box = new("TextBox", {Parent = row, BackgroundColor3 = AuroraUI.Theme.Surface, Position = UDim2.new(0, 12, 1, -32), Size = UDim2.new(1, -24, 0, 26), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = AuroraUI.Theme.Text, PlaceholderText = o.Placeholder, PlaceholderColor3 = AuroraUI.Theme.Muted, Text = "", ClearTextOnFocus = false})
    corner(box, 9)
    stroke(box, AuroraUI.Theme.Border, 0.45, 1)
    box.FocusLost:Connect(function() task.spawn(o.Callback, box.Text) end)
    return box
end

function Section:CreateSeparator()
    return new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Border, BackgroundTransparency = 0.4, Size = UDim2.new(1, 0, 0, 1)})
end

function AuroraUI:CreateWindow(o)
    o = merge({Title = "Aurora UI", Subtitle = "Premium Roblox Interface", Footer = "AuroraUI • v3.0.0", Size = UDim2.fromOffset(520, 360), Position = UDim2.fromScale(0.5, 0.52), AnchorPoint = Vector2.new(0.5, 0.5), ToggleKey = Enum.KeyCode.RightShift, MinimizeKey = Enum.KeyCode.M, MobileScale = 0.72, Draggable = true}, o)
    local gui = self.Gui or new("ScreenGui", {Parent = PlayerGui, Name = "AuroraUI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    self.Gui = gui
    local isMobile = UserInputService.TouchEnabled
    local actualSize = o.Size
    if isMobile then actualSize = UDim2.fromOffset(math.min(o.Size.X.Offset, 520), math.min(o.Size.Y.Offset, 360)) end
    local main = new("CanvasGroup", {Parent = gui, AnchorPoint = o.AnchorPoint, Position = o.Position, Size = actualSize, BackgroundColor3 = AuroraUI.Theme.Background, BackgroundTransparency = 0, ClipsDescendants = true})
    corner(main, 22)
    stroke(main, AuroraUI.Theme.Border, 0.18, 1)
    local scale = new("UIScale", {Parent = main, Scale = (isMobile and o.MobileScale or 1) * 0.96})
    local targetScale = isMobile and o.MobileScale or 1
    local header = new("Frame", {Parent = main, BackgroundColor3 = AuroraUI.Theme.Surface, Size = UDim2.new(1, 0, 0, 74)})
    corner(header, 22)
    gradient(header, Color3.fromRGB(255, 255, 255), Color3.fromRGB(232, 238, 255), 0)
    local accentBar = new("Frame", {Parent = header, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Accent, Position = UDim2.new(0, 18, 1, -3), Size = UDim2.new(0, 120, 0, 3)})
    corner(accentBar, 3)
    gradient(accentBar, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)
    local title = label(header, o.Title, 21, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    title.Position = UDim2.fromOffset(18, 12)
    title.Size = UDim2.new(1, -120, 0, 28)
    local sub = label(header, o.Subtitle, 12, AuroraUI.Theme.Muted)
    sub.Position = UDim2.fromOffset(18, 40)
    sub.Size = UDim2.new(1, -120, 0, 20)
    local min = button(header, "—")
    min.AnchorPoint = Vector2.new(1, 0)
    min.Position = UDim2.new(1, -52, 0, 14)
    min.Size = UDim2.fromOffset(28, 28)
    min.BackgroundTransparency = 1
    min.TextColor3 = AuroraUI.Theme.Muted
    min.TextSize = 21
    local close = button(header, "×")
    close.AnchorPoint = Vector2.new(1, 0)
    close.Position = UDim2.new(1, -18, 0, 14)
    close.Size = UDim2.fromOffset(28, 28)
    close.BackgroundTransparency = 1
    close.TextColor3 = AuroraUI.Theme.Error
    close.TextSize = 22
    local body = new("Frame", {Parent = main, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 74), Size = UDim2.new(1, 0, 1, -104)})
    local sidebar = new("ScrollingFrame", {Parent = body, BackgroundColor3 = AuroraUI.Theme.Sidebar, BorderSizePixel = 0, Size = UDim2.new(0, 150, 1, 0), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0})
    pad(sidebar, 10, 10, 10, 10)
    list(sidebar, 8)
    local pages = new("Frame", {Parent = body, BackgroundTransparency = 1, Position = UDim2.fromOffset(160, 0), Size = UDim2.new(1, -170, 1, 0)})
    local footer = label(main, o.Footer, 10, AuroraUI.Theme.Muted)
    footer.Position = UDim2.new(0, 16, 1, -26)
    footer.Size = UDim2.new(1, -32, 0, 18)
    local open = button(gui, "Open Menu")
    open.Visible = false
    open.AnchorPoint = Vector2.new(0.5, 0)
    open.Position = UDim2.new(0.5, 0, 0, 16)
    open.Size = UDim2.fromOffset(138, 36)
    open.BackgroundColor3 = AuroraUI.Theme.Card
    open.TextColor3 = AuroraUI.Theme.Text
    open.TextSize = 13
    corner(open, 22)
    stroke(open, AuroraUI.Theme.Border, 0.22, 1)
    local openScale = new("UIScale", {Parent = open, Scale = 0.86})
    local w = setmetatable({Gui = gui, Main = main, Scale = scale, TargetScale = targetScale, OpenButton = open, OpenScale = openScale, Sidebar = sidebar, Pages = pages, Options = o, Tabs = {}, Groups = {}, Visible = true}, Window)
    min.MouseButton1Click:Connect(function() w:Minimize() end)
    close.MouseButton1Click:Connect(function() w:Hide() end)
    open.MouseButton1Click:Connect(function() w:Show() end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == o.ToggleKey then
            if w.Main.Visible then w:Hide() else w:Show() end
        elseif input.KeyCode == o.MinimizeKey then
            w:Minimize()
        end
    end)
    if o.Draggable then
        local dragging = false
        local dragStart
        local startPos
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = main.Position end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end
    tween(scale, 0.22, {Scale = targetScale})
    table.insert(self.Windows, w)
    return w
end

return AuroraUI
