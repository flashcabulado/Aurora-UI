local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AuroraUI = {
    Version = "2.0.0",
    Windows = {},
    Theme = {}
}

local Theme = {
    Background = Color3.fromRGB(24, 26, 34),
    Surface = Color3.fromRGB(34, 38, 50),
    SurfaceLight = Color3.fromRGB(44, 50, 66),
    Card = Color3.fromRGB(50, 57, 74),
    CardLight = Color3.fromRGB(62, 70, 90),
    Accent = Color3.fromRGB(132, 102, 255),
    AccentSecond = Color3.fromRGB(78, 205, 255),
    Text = Color3.fromRGB(250, 252, 255),
    Muted = Color3.fromRGB(190, 199, 216),
    Border = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(248, 113, 113)
}

for key, value in pairs(Theme) do
    AuroraUI.Theme[key] = value
end

local function applyTheme(t)
    for key, value in pairs(t or {}) do
        AuroraUI.Theme[key] = value
    end
end

local function merge(a, b)
    local c = {}
    for k, v in pairs(a or {}) do
        c[k] = v
    end
    for k, v in pairs(b or {}) do
        c[k] = v
    end
    return c
end

local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function tween(obj, duration, props, style, direction)
    local info = TweenInfo.new(duration or 0.22, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function corner(parent, r)
    return new("UICorner", {Parent = parent, CornerRadius = UDim.new(0, r or 16)})
end

local function stroke(parent, transparency, thickness)
    return new("UIStroke", {Parent = parent, Color = AuroraUI.Theme.Border, Transparency = transparency or 0.88, Thickness = thickness or 1})
end

local function pad(parent, l, r, t, b)
    return new("UIPadding", {Parent = parent, PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or l or 0), PaddingTop = UDim.new(0, t or l or 0), PaddingBottom = UDim.new(0, b or t or l or 0)})
end

local function list(parent, gap)
    return new("UIListLayout", {Parent = parent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, gap or 8)})
end

local function grad(parent, a, b, rot)
    return new("UIGradient", {Parent = parent, Rotation = rot or 35, Color = ColorSequence.new(a or AuroraUI.Theme.Accent, b or AuroraUI.Theme.AccentSecond)})
end

local function label(parent, text, size, color, font)
    return new("TextLabel", {Parent = parent, BackgroundTransparency = 1, Text = text or "", Font = font or Enum.Font.GothamMedium, TextSize = size or 14, TextColor3 = color or AuroraUI.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = true})
end

local function button(parent, text)
    return new("TextButton", {Parent = parent, AutoButtonColor = false, BackgroundColor3 = AuroraUI.Theme.Card, Text = text or "", Font = Enum.Font.GothamMedium, TextSize = 14, TextColor3 = AuroraUI.Theme.Text})
end

local function hover(obj, normal, over)
    obj.MouseEnter:Connect(function()
        tween(obj, 0.16, {BackgroundColor3 = over or AuroraUI.Theme.CardLight})
    end)
    obj.MouseLeave:Connect(function()
        tween(obj, 0.16, {BackgroundColor3 = normal or AuroraUI.Theme.Card})
    end)
end

local function makeCard(parent, height)
    local f = new("Frame", {Parent = parent, BackgroundColor3 = AuroraUI.Theme.Card, BackgroundTransparency = 0.02, Size = UDim2.new(1, 0, 0, height or 58)})
    corner(f, 16)
    stroke(f, 0.9, 1)
    return f
end

local function titleBlock(parent, title, desc, rightSpace)
    local wrap = new("Frame", {Parent = parent, BackgroundTransparency = 1, Size = UDim2.new(1, -(rightSpace or 110), 1, 0)})
    list(wrap, 2)
    local t = label(wrap, title or "Element", 14, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
    t.Size = UDim2.new(1, 0, 0, 22)
    local d = label(wrap, desc or "", 12, AuroraUI.Theme.Muted, Enum.Font.GothamMedium)
    d.Size = UDim2.new(1, 0, 0, 28)
    return wrap
end

local Window = {}
Window.__index = Window
local Tab = {}
Tab.__index = Tab
local Section = {}
Section.__index = Section

function AuroraUI:SetTheme(t)
    applyTheme(t)
end

function AuroraUI:Notify(o)
    o = merge({Title = "AuroraUI", Content = "Loaded", Duration = 4, Type = "Info"}, o)
    local gui = self.Gui or new("ScreenGui", {Parent = PlayerGui, Name = "AuroraUI", IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    self.Gui = gui
    local holder = gui:FindFirstChild("Notifications") or new("Frame", {Parent = gui, Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 18), Size = UDim2.fromOffset(320, 600)})
    if not holder:FindFirstChildOfClass("UIListLayout") then
        list(holder, 10)
    end
    local item = makeCard(holder, 84)
    item.BackgroundColor3 = AuroraUI.Theme.SurfaceLight
    pad(item, 14, 14, 10, 10)
    local s = new("UIScale", {Parent = item, Scale = 0.92})
    local title = label(item, o.Title, 15, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    title.Size = UDim2.new(1, 0, 0, 24)
    local body = label(item, o.Content, 12, AuroraUI.Theme.Muted)
    body.Position = UDim2.fromOffset(0, 28)
    body.Size = UDim2.new(1, 0, 0, 34)
    local bar = new("Frame", {Parent = item, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Accent, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 3)})
    corner(bar, 3)
    grad(bar, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)
    tween(s, 0.22, {Scale = 1})
    tween(bar, o.Duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
    task.delay(o.Duration, function()
        if item.Parent then
            tween(s, 0.18, {Scale = 0.9})
            local out = tween(item, 0.18, {BackgroundTransparency = 1})
            out.Completed:Wait()
            item:Destroy()
        end
    end)
end

function Window:Show()
    self.Visible = true
    self.Main.Visible = true
    self.OpenButton.Visible = false
    tween(self.Scale, 0.24, {Scale = self.TargetScale})
    tween(self.Main, 0.24, {GroupTransparency = 0})
end

function Window:Hide()
    self.Visible = false
    tween(self.Scale, 0.18, {Scale = self.TargetScale * 0.96})
    local t = tween(self.Main, 0.18, {GroupTransparency = 1})
    t.Completed:Connect(function()
        if not self.Visible then
            self.Main.Visible = false
        end
    end)
end

function Window:Minimize()
    if self.Options.Minimizable == false then
        return
    end
    self:Hide()
    task.delay(0.16, function()
        self.OpenButton.Visible = true
        tween(self.OpenScale, 0.22, {Scale = 1})
    end)
end

function Window:Destroy()
    self.Gui:Destroy()
end

function Window:SelectTab(tab)
    for _, item in ipairs(self.Tabs) do
        item.Page.Visible = item == tab
        if item == tab then
            tween(item.Button, 0.18, {BackgroundColor3 = AuroraUI.Theme.Accent, BackgroundTransparency = 0})
        else
            tween(item.Button, 0.18, {BackgroundColor3 = AuroraUI.Theme.Card, BackgroundTransparency = 0.2})
        end
    end
    self.ActiveTab = tab
end

function Window:CreateTab(o)
    o = merge({Name = "Tab", Icon = "◆", Group = "General"}, o)
    local tab = setmetatable({Window = self, Options = o, Sections = {}}, Tab)
    local group = self.Groups[o.Group]
    if not group then
        group = new("Frame", {Parent = self.Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), AutomaticSize = Enum.AutomaticSize.Y})
        list(group, 6)
        local g = label(group, string.upper(o.Group), 10, AuroraUI.Theme.Muted, Enum.Font.GothamBold)
        g.Size = UDim2.new(1, 0, 0, 16)
        self.Groups[o.Group] = group
    end
    local b = button(group, "  " .. tostring(o.Icon) .. "  " .. o.Name)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundTransparency = 0.2
    b.TextXAlignment = Enum.TextXAlignment.Left
    corner(b, 13)
    stroke(b, 0.92, 1)
    hover(b, AuroraUI.Theme.Card, AuroraUI.Theme.CardLight)
    local page = new("ScrollingFrame", {Parent = self.Pages, Name = o.Name, Visible = false, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3})
    pad(page, 4, 8, 4, 8)
    list(page, 10)
    tab.Button = b
    tab.Page = page
    b.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    table.insert(self.Tabs, tab)
    if not self.ActiveTab then
        self:SelectTab(tab)
    end
    return tab
end

function Tab:CreateSection(o)
    o = merge({Title = "Section", Description = ""}, o)
    local s = setmetatable({Tab = self, Options = o}, Section)
    local box = new("Frame", {Parent = self.Page, BackgroundColor3 = AuroraUI.Theme.Surface, BackgroundTransparency = 0.02, Size = UDim2.new(1, 0, 0, 82), AutomaticSize = Enum.AutomaticSize.Y})
    corner(box, 20)
    stroke(box, 0.88, 1)
    pad(box, 12, 12, 12, 12)
    list(box, 8)
    local t = label(box, o.Title, 16, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    t.Size = UDim2.new(1, 0, 0, 22)
    if o.Description ~= "" then
        local d = label(box, o.Description, 12, AuroraUI.Theme.Muted)
        d.Size = UDim2.new(1, 0, 0, 18)
    end
    s.Container = box
    table.insert(self.Sections, s)
    return s
end

function Section:CreateButton(o)
    o = merge({Title = "Button", Description = "", Icon = "Run", Callback = function() end}, o)
    local b = button(self.Container, "")
    b.Size = UDim2.new(1, 0, 0, 60)
    b.BackgroundColor3 = AuroraUI.Theme.Card
    corner(b, 16)
    stroke(b, 0.9, 1)
    pad(b, 12, 12, 7, 7)
    titleBlock(b, o.Title, o.Description, 90)
    local r = label(b, o.Icon, 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    r.AnchorPoint = Vector2.new(1, 0.5)
    r.Position = UDim2.new(1, -12, 0.5, 0)
    r.Size = UDim2.fromOffset(74, 28)
    r.TextXAlignment = Enum.TextXAlignment.Right
    hover(b, AuroraUI.Theme.Card, AuroraUI.Theme.CardLight)
    b.MouseButton1Click:Connect(function()
        tween(b, 0.08, {Size = UDim2.new(1, -4, 0, 58)})
        task.delay(0.08, function()
            if b.Parent then
                tween(b, 0.12, {Size = UDim2.new(1, 0, 0, 60)})
            end
        end)
        task.spawn(o.Callback)
    end)
    return b
end

function Section:CreateToggle(o)
    o = merge({Title = "Toggle", Description = "", Default = false, Callback = function() end}, o)
    local state = o.Default == true
    local row = button(self.Container, "")
    row.Size = UDim2.new(1, 0, 0, 60)
    corner(row, 16)
    stroke(row, 0.9, 1)
    pad(row, 12, 12, 7, 7)
    titleBlock(row, o.Title, o.Description, 86)
    local track = new("Frame", {Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(54, 30), BackgroundColor3 = state and AuroraUI.Theme.Accent or AuroraUI.Theme.SurfaceLight})
    corner(track, 30)
    local thumb = new("Frame", {Parent = track, Size = UDim2.fromOffset(24, 24), Position = state and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
    corner(thumb, 24)
    hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardLight)
    local function set(v)
        state = v
        tween(track, 0.18, {BackgroundColor3 = state and AuroraUI.Theme.Accent or AuroraUI.Theme.SurfaceLight})
        tween(thumb, 0.18, {Position = state and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3)})
        task.spawn(o.Callback, state)
    end
    row.MouseButton1Click:Connect(function()
        set(not state)
    end)
    return {Set = set, Get = function() return state end, Instance = row}
end

function Section:CreateSlider(o)
    o = merge({Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Callback = function() end}, o)
    local value = math.clamp(o.Default, o.Min, o.Max)
    local row = makeCard(self.Container, 82)
    pad(row, 12, 12, 8, 8)
    titleBlock(row, o.Title, o.Description, 90)
    local vt = label(row, tostring(value), 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    vt.AnchorPoint = Vector2.new(1, 0)
    vt.Position = UDim2.new(1, -12, 0, 8)
    vt.Size = UDim2.fromOffset(72, 24)
    vt.TextXAlignment = Enum.TextXAlignment.Right
    local track = new("Frame", {Parent = row, BackgroundColor3 = AuroraUI.Theme.SurfaceLight, Position = UDim2.new(0, 12, 1, -22), Size = UDim2.new(1, -24, 0, 7)})
    corner(track, 7)
    local fill = new("Frame", {Parent = track, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Accent, Size = UDim2.new((value - o.Min) / (o.Max - o.Min), 0, 1, 0)})
    corner(fill, 7)
    grad(fill, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)
    local dragging = false
    local function setFromX(x)
        local alpha = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = o.Min + (o.Max - o.Min) * alpha
        value = math.floor(raw / o.Increment + 0.5) * o.Increment
        value = math.clamp(value, o.Min, o.Max)
        vt.Text = tostring(value)
        tween(fill, 0.08, {Size = UDim2.new((value - o.Min) / (o.Max - o.Min), 0, 1, 0)})
        task.spawn(o.Callback, value)
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
    return {Get = function() return value end, Instance = row}
end

function Section:CreateDropdown(o)
    o = merge({Title = "Dropdown", Description = "", Options = {}, Default = nil, Callback = function() end}, o)
    local selected = o.Default or o.Options[1] or "None"
    local row = button(self.Container, "")
    row.Size = UDim2.new(1, 0, 0, 60)
    corner(row, 16)
    stroke(row, 0.9, 1)
    pad(row, 12, 12, 7, 7)
    titleBlock(row, o.Title, o.Description, 130)
    local vt = label(row, tostring(selected), 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    vt.AnchorPoint = Vector2.new(1, 0.5)
    vt.Position = UDim2.new(1, -12, 0.5, 0)
    vt.Size = UDim2.fromOffset(120, 28)
    vt.TextXAlignment = Enum.TextXAlignment.Right
    local menu = new("Frame", {Parent = self.Container, Visible = false, ClipsDescendants = true, BackgroundColor3 = AuroraUI.Theme.Card, BackgroundTransparency = 0.02, Size = UDim2.new(1, 0, 0, 0)})
    corner(menu, 16)
    stroke(menu, 0.9, 1)
    pad(menu, 8, 8, 8, 8)
    list(menu, 5)
    for _, opt in ipairs(o.Options) do
        local ob = button(menu, tostring(opt))
        ob.Size = UDim2.new(1, 0, 0, 34)
        ob.BackgroundColor3 = AuroraUI.Theme.SurfaceLight
        ob.BackgroundTransparency = 0.18
        corner(ob, 11)
        hover(ob, AuroraUI.Theme.SurfaceLight, AuroraUI.Theme.Accent)
        ob.MouseButton1Click:Connect(function()
            selected = opt
            vt.Text = tostring(opt)
            tween(menu, 0.16, {Size = UDim2.new(1, 0, 0, 0)})
            task.delay(0.16, function() menu.Visible = false end)
            task.spawn(o.Callback, opt)
        end)
    end
    row.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
        tween(menu, 0.2, {Size = UDim2.new(1, 0, 0, menu.Visible and (#o.Options * 39 + 16) or 0)})
    end)
    return {Get = function() return selected end, Instance = row}
end

function Section:CreateKeybind(o)
    o = merge({Title = "Keybind", Description = "", Default = Enum.KeyCode.F, Callback = function() end}, o)
    local key = o.Default
    local listening = false
    local row = button(self.Container, "")
    row.Size = UDim2.new(1, 0, 0, 60)
    corner(row, 16)
    stroke(row, 0.9, 1)
    pad(row, 12, 12, 7, 7)
    titleBlock(row, o.Title, o.Description, 100)
    local kt = label(row, key.Name, 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    kt.AnchorPoint = Vector2.new(1, 0.5)
    kt.Position = UDim2.new(1, -12, 0.5, 0)
    kt.Size = UDim2.fromOffset(92, 28)
    kt.TextXAlignment = Enum.TextXAlignment.Right
    row.MouseButton1Click:Connect(function()
        listening = true
        kt.Text = "..."
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
            key = input.KeyCode
            kt.Text = key.Name
            listening = false
            return
        end
        if input.KeyCode == key then
            task.spawn(o.Callback)
        end
    end)
    return {Get = function() return key end, Instance = row}
end

function Section:CreateTextBox(o)
    o = merge({Title = "TextBox", Description = "", Placeholder = "Enter text...", Callback = function() end}, o)
    local row = makeCard(self.Container, 88)
    pad(row, 12, 12, 8, 8)
    titleBlock(row, o.Title, o.Description, 0)
    local box = new("TextBox", {Parent = row, BackgroundColor3 = AuroraUI.Theme.SurfaceLight, Position = UDim2.new(0, 12, 1, -34), Size = UDim2.new(1, -24, 0, 28), Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = AuroraUI.Theme.Text, PlaceholderText = o.Placeholder, PlaceholderColor3 = AuroraUI.Theme.Muted, Text = "", ClearTextOnFocus = false})
    corner(box, 10)
    stroke(box, 0.9, 1)
    box.FocusLost:Connect(function()
        task.spawn(o.Callback, box.Text)
    end)
    return box
end

function Section:CreateSeparator()
    return new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Border, BackgroundTransparency = 0.9, Size = UDim2.new(1, 0, 0, 1)})
end

function AuroraUI:CreateWindow(o)
    o = merge({Title = "Aurora UI", Subtitle = "Premium Roblox Interface", Footer = "AuroraUI • v2.0.0", Size = UDim2.fromOffset(640, 440), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), ToggleKey = Enum.KeyCode.RightShift, MinimizeKey = Enum.KeyCode.M, MobileScale = 0.86, Draggable = true, Minimizable = true}, o)
    local gui = self.Gui or new("ScreenGui", {Parent = PlayerGui, Name = "AuroraUI", IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    self.Gui = gui
    local main = new("CanvasGroup", {Parent = gui, AnchorPoint = o.AnchorPoint, Position = o.Position, Size = o.Size, BackgroundColor3 = AuroraUI.Theme.Background, BackgroundTransparency = 0, ClipsDescendants = true})
    corner(main, 26)
    stroke(main, 0.82, 1)
    grad(main, AuroraUI.Theme.Background, AuroraUI.Theme.Surface, 45)
    local targetScale = UserInputService.TouchEnabled and o.MobileScale or 1
    local scale = new("UIScale", {Parent = main, Scale = targetScale * 0.96})
    local header = new("Frame", {Parent = main, BackgroundColor3 = AuroraUI.Theme.Surface, BackgroundTransparency = 0.03, Size = UDim2.new(1, 0, 0, 88)})
    grad(header, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 22)
    local shade = new("Frame", {Parent = header, BackgroundColor3 = Color3.fromRGB(10, 12, 18), BackgroundTransparency = 0.35, Size = UDim2.new(1, 0, 1, 0)})
    local title = label(header, o.Title, 23, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    title.Position = UDim2.fromOffset(22, 16)
    title.Size = UDim2.new(1, -145, 0, 30)
    local sub = label(header, o.Subtitle, 12, AuroraUI.Theme.Muted)
    sub.Position = UDim2.fromOffset(22, 48)
    sub.Size = UDim2.new(1, -145, 0, 20)
    local min = button(header, "—")
    min.AnchorPoint = Vector2.new(1, 0)
    min.Position = UDim2.new(1, -58, 0, 20)
    min.Size = UDim2.fromOffset(28, 28)
    min.BackgroundTransparency = 1
    min.TextSize = 22
    local close = button(header, "×")
    close.AnchorPoint = Vector2.new(1, 0)
    close.Position = UDim2.new(1, -22, 0, 20)
    close.Size = UDim2.fromOffset(28, 28)
    close.BackgroundTransparency = 1
    close.TextSize = 23
    close.TextColor3 = Color3.fromRGB(255, 215, 225)
    local body = new("Frame", {Parent = main, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 88), Size = UDim2.new(1, 0, 1, -122)})
    local sidebar = new("ScrollingFrame", {Parent = body, BackgroundColor3 = AuroraUI.Theme.Surface, BackgroundTransparency = 0.18, BorderSizePixel = 0, Size = UDim2.new(0, 176, 1, 0), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0})
    pad(sidebar, 12, 12, 12, 12)
    list(sidebar, 10)
    local pages = new("Frame", {Parent = body, BackgroundTransparency = 1, Position = UDim2.fromOffset(186, 0), Size = UDim2.new(1, -196, 1, 0)})
    local footer = label(main, o.Footer, 11, AuroraUI.Theme.Muted)
    footer.Position = UDim2.new(0, 18, 1, -30)
    footer.Size = UDim2.new(1, -36, 0, 20)
    local open = button(gui, "Open Menu")
    open.Visible = false
    open.AnchorPoint = Vector2.new(0.5, 0)
    open.Position = UDim2.new(0.5, 0, 0, 18)
    open.Size = UDim2.fromOffset(180, 42)
    open.BackgroundColor3 = AuroraUI.Theme.Surface
    open.BackgroundTransparency = 0.02
    open.TextSize = 14
    corner(open, 28)
    stroke(open, 0.82, 1)
    grad(open, AuroraUI.Theme.SurfaceLight, AuroraUI.Theme.Card, 20)
    local openScale = new("UIScale", {Parent = open, Scale = 0.82})
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
    tween(scale, 0.26, {Scale = targetScale})
    table.insert(self.Windows, w)
    return w
end

return AuroraUI
