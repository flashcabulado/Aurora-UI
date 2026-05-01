local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AuroraUI = {
    Version = "5.0.0",
    Theme = {},
    Windows = {},
    Flags = {},
    Controls = {}
}

local DefaultTheme = {
    Background = Color3.fromRGB(30, 34, 44),
    BackgroundTransparency = 0.03,
    Surface = Color3.fromRGB(38, 44, 58),
    SurfaceSoft = Color3.fromRGB(48, 55, 72),
    Sidebar = Color3.fromRGB(35, 40, 54),
    Card = Color3.fromRGB(48, 55, 72),
    CardHover = Color3.fromRGB(58, 66, 86),
    RobloxBlack = Color3.fromRGB(25, 27, 32),
    Accent = Color3.fromRGB(127, 92, 255),
    AccentSecond = Color3.fromRGB(65, 190, 255),
    Text = Color3.fromRGB(246, 248, 255),
    Muted = Color3.fromRGB(180, 190, 210),
    Minimize = Color3.fromRGB(255, 187, 68),
    Close = Color3.fromRGB(255, 118, 128),
    Success = Color3.fromRGB(72, 220, 155),
    Warning = Color3.fromRGB(255, 187, 68),
    Error = Color3.fromRGB(255, 118, 128)
}

for k, v in pairs(DefaultTheme) do
    AuroraUI.Theme[k] = v
end

local function hexToColor3(value)
    if typeof(value) == "Color3" then return value end
    if typeof(value) ~= "string" then return value end
    local h = value:gsub("#", "")
    if #h ~= 6 then return value end
    local r = tonumber(h:sub(1, 2), 16)
    local g = tonumber(h:sub(3, 4), 16)
    local b = tonumber(h:sub(5, 6), 16)
    if not r or not g or not b then return value end
    return Color3.fromRGB(r, g, b)
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

local function tween(obj, time, props, style, direction)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function corner(parent, radius)
    return new("UICorner", {Parent = parent, CornerRadius = UDim.new(0, radius or 14)})
end

local function pad(parent, l, r, t, b)
    return new("UIPadding", {Parent = parent, PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or l or 0), PaddingTop = UDim.new(0, t or l or 0), PaddingBottom = UDim.new(0, b or t or l or 0)})
end

local function list(parent, gap)
    return new("UIListLayout", {Parent = parent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, gap or 8)})
end

local function gradient(parent, a, b, rot)
    return new("UIGradient", {Parent = parent, Rotation = rot or 25, Color = ColorSequence.new(a or AuroraUI.Theme.Accent, b or AuroraUI.Theme.AccentSecond)})
end

local function label(parent, text, size, color, font)
    return new("TextLabel", {Parent = parent, BackgroundTransparency = 1, Text = text or "", Font = font or Enum.Font.GothamMedium, TextSize = size or 15, TextColor3 = color or AuroraUI.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = true})
end

local function button(parent, text)
    return new("TextButton", {Parent = parent, AutoButtonColor = false, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Card, Text = text or "", Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = AuroraUI.Theme.Text})
end

local function iconImage(parent, icon, size)
    if typeof(icon) == "number" then icon = "rbxassetid://" .. tostring(icon) end
    if typeof(icon) ~= "string" or not icon:find("rbxassetid://") then return nil end
    return new("ImageLabel", {Parent = parent, BackgroundTransparency = 1, Image = icon, ImageColor3 = AuroraUI.Theme.Muted, Size = UDim2.fromOffset(size or 18, size or 18), ScaleType = Enum.ScaleType.Fit})
end

local function hover(obj, normal, over)
    obj.MouseEnter:Connect(function()
        if obj:GetAttribute("Selected") then return end
        tween(obj, 0.14, {BackgroundColor3 = over or AuroraUI.Theme.CardHover})
    end)
    obj.MouseLeave:Connect(function()
        if obj:GetAttribute("Selected") then return end
        tween(obj, 0.14, {BackgroundColor3 = normal or AuroraUI.Theme.Card})
    end)
end

local function textBlock(parent, title, desc, rightSpace)
    local wrap = new("Frame", {Parent = parent, BackgroundTransparency = 1, Size = UDim2.new(1, -(rightSpace or 110), 1, 0)})
    list(wrap, 2)
    local t = label(wrap, title or "Element", 15, AuroraUI.Theme.Text, Enum.Font.GothamSemibold)
    t.Size = UDim2.new(1, 0, 0, 24)
    local d = label(wrap, desc or "", 13, AuroraUI.Theme.Muted, Enum.Font.GothamMedium)
    d.Size = UDim2.new(1, 0, 0, 28)
    return wrap
end

local function itemBase(parent, height)
    local row = button(parent, "")
    row.Size = UDim2.new(1, 0, 0, height or 62)
    row.BackgroundColor3 = AuroraUI.Theme.Card
    corner(row, 16)
    pad(row, 14, 14, 8, 8)
    return row
end

local Window = {}
Window.__index = Window
local Tab = {}
Tab.__index = Tab
local Section = {}
Section.__index = Section

function AuroraUI:SetTheme(theme)
    for k, v in pairs(theme or {}) do
        if k == "Primary" or k == "Main" or k == "Blue" or k == "Accent" then
            self.Theme.Accent = hexToColor3(v)
        elseif k == "Secondary" or k == "AccentSecond" then
            self.Theme.AccentSecond = hexToColor3(v)
        elseif self.Theme[k] ~= nil then
            self.Theme[k] = hexToColor3(v)
        end
    end
end

function AuroraUI:SetFlag(flag, value)
    if not flag then return end
    self.Flags[flag] = value
    local control = self.Controls[flag]
    if control and control.Set then
        control:Set(value, true)
    end
end

function AuroraUI:GetFlag(flag)
    return self.Flags[flag]
end

function AuroraUI:RegisterControl(flag, control)
    if not flag then return end
    self.Controls[flag] = control
end

function AuroraUI:SaveConfig(name)
    name = name or "AuroraUI_Config"
    local data = HttpService:JSONEncode(self.Flags)
    if writefile then
        writefile(name .. ".json", data)
        return true, data
    end
    self.LastConfig = data
    return false, data
end

function AuroraUI:LoadConfig(name)
    name = name or "AuroraUI_Config"
    local data
    if readfile and isfile and isfile(name .. ".json") then
        data = readfile(name .. ".json")
    else
        data = self.LastConfig
    end
    if not data then return false end
    local ok, decoded = pcall(function() return HttpService:JSONDecode(data) end)
    if not ok or typeof(decoded) ~= "table" then return false end
    for flag, value in pairs(decoded) do
        self:SetFlag(flag, value)
    end
    return true
end

function AuroraUI:Notify(o)
    o = merge({Title = "AuroraUI", Content = "Loaded", Duration = 3}, o)
    local gui = self.Gui or new("ScreenGui", {Parent = PlayerGui, Name = "AuroraUI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    self.Gui = gui
    local holder = gui:FindFirstChild("Notifications") or new("Frame", {Parent = gui, Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 18), Size = UDim2.fromOffset(330, 520)})
    if not holder:FindFirstChildOfClass("UIListLayout") then list(holder, 10) end
    local card = new("Frame", {Parent = holder, BackgroundColor3 = AuroraUI.Theme.SurfaceSoft, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 82)})
    corner(card, 18)
    pad(card, 14, 14, 10, 10)
    local scale = new("UIScale", {Parent = card, Scale = 0.92})
    local title = label(card, o.Title, 15, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    title.Size = UDim2.new(1, 0, 0, 24)
    local body = label(card, o.Content, 13, AuroraUI.Theme.Muted)
    body.Position = UDim2.fromOffset(0, 29)
    body.Size = UDim2.new(1, 0, 0, 28)
    local bar = new("Frame", {Parent = card, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Accent, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 3)})
    corner(bar, 3)
    gradient(bar, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)
    tween(scale, 0.18, {Scale = 1})
    tween(bar, o.Duration, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
    task.delay(o.Duration, function()
        if card.Parent then
            tween(scale, 0.16, {Scale = 0.9})
            local out = tween(card, 0.16, {BackgroundTransparency = 1})
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

function Window:AskClose()
    if self.CloseDialog and self.CloseDialog.Parent then self.CloseDialog.Visible = true return end
    local dialog = new("Frame", {Parent = self.Gui, BackgroundColor3 = AuroraUI.Theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(300, 156), ZIndex = 20})
    self.CloseDialog = dialog
    corner(dialog, 22)
    pad(dialog, 16, 16, 16, 16)
    local s = new("UIScale", {Parent = dialog, Scale = 0.9})
    local title = label(dialog, "Fechar menu?", 18, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    title.Size = UDim2.new(1, 0, 0, 30)
    local desc = label(dialog, "Você quer esconder a interface agora?", 14, AuroraUI.Theme.Muted)
    desc.Position = UDim2.fromOffset(0, 34)
    desc.Size = UDim2.new(1, 0, 0, 38)
    local no = button(dialog, "Cancelar")
    no.Position = UDim2.new(0, 0, 1, -40)
    no.Size = UDim2.new(0.48, 0, 0, 38)
    no.BackgroundColor3 = AuroraUI.Theme.Card
    corner(no, 14)
    local yes = button(dialog, "Fechar")
    yes.Position = UDim2.new(0.52, 0, 1, -40)
    yes.Size = UDim2.new(0.48, 0, 0, 38)
    yes.BackgroundColor3 = AuroraUI.Theme.Close
    yes.TextColor3 = Color3.fromRGB(255, 255, 255)
    corner(yes, 14)
    tween(s, 0.18, {Scale = 1})
    no.MouseButton1Click:Connect(function() dialog.Visible = false end)
    yes.MouseButton1Click:Connect(function() dialog.Visible = false self:Hide() end)
end

function Window:Destroy()
    if self.Gui then self.Gui:Destroy() end
end

function Window:SelectTab(tab)
    for _, item in ipairs(self.Tabs) do
        local selected = item == tab
        item.Button:SetAttribute("Selected", selected)
        item.Page.Visible = selected
        if selected then
            tween(item.Button, 0.18, {BackgroundColor3 = AuroraUI.Theme.Accent})
            item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            if item.Icon then item.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255) end
        else
            tween(item.Button, 0.18, {BackgroundColor3 = AuroraUI.Theme.Card})
            item.Button.TextColor3 = AuroraUI.Theme.Text
            if item.Icon then item.Icon.ImageColor3 = AuroraUI.Theme.Muted end
        end
    end
    self.ActiveTab = tab
end

function Window:CreateTab(o)
    o = merge({Name = "Tab", Icon = nil, Group = "General"}, o)
    local tab = setmetatable({Window = self, Options = o, Sections = {}}, Tab)
    local group = self.Groups[o.Group]
    if not group then
        group = new("Frame", {Parent = self.Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), AutomaticSize = Enum.AutomaticSize.Y})
        list(group, 7)
        local g = label(group, string.upper(o.Group), 11, AuroraUI.Theme.Muted, Enum.Font.GothamBold)
        g.Size = UDim2.new(1, 0, 0, 16)
        self.Groups[o.Group] = group
    end
    local b = button(group, o.Name)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = AuroraUI.Theme.Card
    b.TextSize = 15
    b.TextXAlignment = Enum.TextXAlignment.Center
    corner(b, 14)
    local icon = iconImage(b, o.Icon, 17)
    if icon then
        icon.AnchorPoint = Vector2.new(0, 0.5)
        icon.Position = UDim2.new(0, 13, 0.5, 0)
        b.Text = "    " .. o.Name
    end
    hover(b, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
    local page = new("ScrollingFrame", {Parent = self.Pages, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), Visible = false, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 4, ScrollBarImageColor3 = AuroraUI.Theme.Accent})
    pad(page, 3, 7, 3, 8)
    list(page, 9)
    tab.Button = b
    tab.Page = page
    tab.Icon = icon
    b.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    table.insert(self.Tabs, tab)
    if not self.ActiveTab then self:SelectTab(tab) end
    return tab
end

function Tab:CreateSection(o)
    o = merge({Title = "Section", Description = "", Collapsible = true, DefaultOpen = true}, o)
    local section = setmetatable({Tab = self, Options = o, Open = o.DefaultOpen ~= false}, Section)
    local outer = new("Frame", {Parent = self.Page, BackgroundColor3 = AuroraUI.Theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 74), AutomaticSize = Enum.AutomaticSize.Y, ClipsDescendants = true})
    corner(outer, 18)
    local header = button(outer, "")
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 66)
    header.Text = ""
    pad(header, 14, 14, 8, 8)
    local title = label(header, o.Title, 16, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    title.Position = UDim2.fromOffset(0, 2)
    title.Size = UDim2.new(1, -42, 0, 24)
    local desc = label(header, o.Description, 13, AuroraUI.Theme.Muted)
    desc.Position = UDim2.fromOffset(0, 28)
    desc.Size = UDim2.new(1, -42, 0, 24)
    local arrow = label(header, section.Open and "^" or "v", 18, AuroraUI.Theme.Muted, Enum.Font.GothamBold)
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.Position = UDim2.new(1, -3, 0.5, 0)
    arrow.Size = UDim2.fromOffset(28, 28)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    local arrowScale = new("UIScale", {Parent = arrow, Scale = 1})
    local container = new("Frame", {Parent = outer, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 66), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = section.Open})
    pad(container, 10, 10, 0, 10)
    list(container, 8)
    section.Outer = outer
    section.Container = container
    section.Arrow = arrow
    header.MouseButton1Click:Connect(function()
        if o.Collapsible == false then return end
        section.Open = not section.Open
        tween(arrowScale, 0.09, {Scale = 0.78})
        task.delay(0.09, function() if arrowScale.Parent then tween(arrowScale, 0.13, {Scale = 1}) end end)
        if section.Open then
            container.Visible = true
            arrow.Text = "^"
            tween(outer, 0.16, {BackgroundColor3 = AuroraUI.Theme.SurfaceSoft})
            task.delay(0.12, function() if outer.Parent then tween(outer, 0.18, {BackgroundColor3 = AuroraUI.Theme.Surface}) end end)
        else
            arrow.Text = "v"
            tween(outer, 0.16, {BackgroundColor3 = AuroraUI.Theme.Surface})
            task.delay(0.12, function() if not section.Open then container.Visible = false end end)
        end
    end)
    table.insert(self.Sections, section)
    return section
end

function Section:CreateButton(o)
    o = merge({Title = "Button", Description = "", Icon = "Run", Callback = function() end}, o)
    local row = itemBase(self.Container, 62)
    textBlock(row, o.Title, o.Description, 92)
    local right = label(row, o.Icon, 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    right.AnchorPoint = Vector2.new(1, 0.5)
    right.Position = UDim2.new(1, -12, 0.5, 0)
    right.Size = UDim2.fromOffset(78, 28)
    right.TextXAlignment = Enum.TextXAlignment.Right
    hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
    row.MouseButton1Click:Connect(function()
        tween(row, 0.07, {Size = UDim2.new(1, -3, 0, 60)})
        task.delay(0.07, function() if row.Parent then tween(row, 0.1, {Size = UDim2.new(1, 0, 0, 62)}) end end)
        task.spawn(o.Callback)
    end)
    return row
end

function Section:CreateToggle(o)
    o = merge({Title = "Toggle", Description = "", Default = false, Flag = nil, Callback = function() end}, o)
    local state = AuroraUI.Flags[o.Flag] ~= nil and AuroraUI.Flags[o.Flag] or o.Default == true
    local row = itemBase(self.Container, 62)
    textBlock(row, o.Title, o.Description, 82)
    local track = new("Frame", {Parent = row, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(52, 28), BackgroundColor3 = state and AuroraUI.Theme.Accent or AuroraUI.Theme.SurfaceSoft})
    corner(track, 28)
    local thumb = new("Frame", {Parent = track, BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.fromOffset(22, 22), Position = state and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3)})
    corner(thumb, 22)
    hover(row, AuroraUI.Theme.Card, AuroraUI.Theme.CardHover)
    local control = {}
    function control:Set(v, silent)
        state = v == true
        if o.Flag then AuroraUI.Flags[o.Flag] = state end
        tween(track, 0.16, {BackgroundColor3 = state and AuroraUI.Theme.Accent or AuroraUI.Theme.SurfaceSoft})
        tween(thumb, 0.16, {Position = state and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3)})
        if not silent then task.spawn(o.Callback, state) end
    end
    function control:Get() return state end
    control.Instance = row
    if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = state end
    row.MouseButton1Click:Connect(function() control:Set(not state) end)
    return control
end

function Section:CreateSlider(o)
    o = merge({Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Flag = nil, Callback = function() end}, o)
    local value = tonumber(AuroraUI.Flags[o.Flag]) or math.clamp(o.Default, o.Min, o.Max)
    local row = new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Card, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 88)})
    corner(row, 16)
    pad(row, 14, 14, 8, 8)
    textBlock(row, o.Title, o.Description, 82)
    local vt = label(row, tostring(value), 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    vt.AnchorPoint = Vector2.new(1, 0)
    vt.Position = UDim2.new(1, -12, 0, 9)
    vt.Size = UDim2.fromOffset(76, 24)
    vt.TextXAlignment = Enum.TextXAlignment.Right
    local track = new("Frame", {Parent = row, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.SurfaceSoft, Position = UDim2.new(0, 14, 1, -24), Size = UDim2.new(1, -28, 0, 7)})
    corner(track, 7)
    local fill = new("Frame", {Parent = track, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Accent, Size = UDim2.new((value - o.Min) / (o.Max - o.Min), 0, 1, 0)})
    corner(fill, 7)
    gradient(fill, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)
    local control = {}
    function control:Set(v, silent)
        value = math.clamp(tonumber(v) or o.Min, o.Min, o.Max)
        value = math.floor(value / o.Increment + 0.5) * o.Increment
        vt.Text = tostring(value)
        if o.Flag then AuroraUI.Flags[o.Flag] = value end
        tween(fill, 0.08, {Size = UDim2.new((value - o.Min) / (o.Max - o.Min), 0, 1, 0)})
        if not silent then task.spawn(o.Callback, value) end
    end
    function control:Get() return value end
    control.Instance = row
    if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = value end
    local dragging = false
    local function setFromX(x)
        local alpha = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        control:Set(o.Min + (o.Max - o.Min) * alpha)
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
    return control
end

function Section:CreateDropdown(o)
    o = merge({Title = "Dropdown", Description = "", Options = {}, Default = nil, Flag = nil, Callback = function() end}, o)
    local selected = AuroraUI.Flags[o.Flag] or o.Default or o.Options[1] or "None"
    local row = itemBase(self.Container, 62)
    textBlock(row, o.Title, o.Description, 130)
    local vt = label(row, tostring(selected), 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    vt.AnchorPoint = Vector2.new(1, 0.5)
    vt.Position = UDim2.new(1, -12, 0.5, 0)
    vt.Size = UDim2.fromOffset(120, 28)
    vt.TextXAlignment = Enum.TextXAlignment.Right
    local menu = new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Card, BorderSizePixel = 0, Visible = false, ClipsDescendants = true, Size = UDim2.new(1, 0, 0, 0)})
    corner(menu, 16)
    pad(menu, 8, 8, 8, 8)
    list(menu, 6)
    local control = {}
    function control:Set(v, silent)
        selected = v
        vt.Text = tostring(v)
        if o.Flag then AuroraUI.Flags[o.Flag] = selected end
        if not silent then task.spawn(o.Callback, selected) end
    end
    function control:Get() return selected end
    control.Instance = row
    if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = selected end
    for _, opt in ipairs(o.Options) do
        local ob = button(menu, tostring(opt))
        ob.Size = UDim2.new(1, 0, 0, 36)
        ob.BackgroundColor3 = AuroraUI.Theme.Surface
        corner(ob, 12)
        hover(ob, AuroraUI.Theme.Surface, AuroraUI.Theme.CardHover)
        ob.MouseButton1Click:Connect(function()
            control:Set(opt)
            tween(menu, 0.15, {Size = UDim2.new(1, 0, 0, 0)})
            task.delay(0.15, function() menu.Visible = false end)
        end)
    end
    row.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
        tween(menu, 0.18, {Size = UDim2.new(1, 0, 0, menu.Visible and (#o.Options * 42 + 16) or 0)})
    end)
    return control
end

function Section:CreateKeybind(o)
    o = merge({Title = "Keybind", Description = "", Default = Enum.KeyCode.F, Flag = nil, Callback = function() end}, o)
    local keyName = AuroraUI.Flags[o.Flag] or o.Default.Name
    local key = Enum.KeyCode[keyName] or o.Default
    local listening = false
    local row = itemBase(self.Container, 62)
    textBlock(row, o.Title, o.Description, 92)
    local kt = label(row, key.Name, 13, AuroraUI.Theme.Accent, Enum.Font.GothamBold)
    kt.AnchorPoint = Vector2.new(1, 0.5)
    kt.Position = UDim2.new(1, -12, 0.5, 0)
    kt.Size = UDim2.fromOffset(82, 28)
    kt.TextXAlignment = Enum.TextXAlignment.Right
    local control = {}
    function control:Set(v, silent)
        if typeof(v) == "EnumItem" then key = v elseif Enum.KeyCode[v] then key = Enum.KeyCode[v] end
        kt.Text = key.Name
        if o.Flag then AuroraUI.Flags[o.Flag] = key.Name end
        if not silent then task.spawn(o.Callback, key) end
    end
    function control:Get() return key end
    control.Instance = row
    if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = key.Name end
    row.MouseButton1Click:Connect(function() listening = true kt.Text = "..." end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if listening and input.KeyCode ~= Enum.KeyCode.Unknown then control:Set(input.KeyCode) listening = false return end
        if input.KeyCode == key then task.spawn(o.Callback, key) end
    end)
    return control
end

function Section:CreateTextBox(o)
    o = merge({Title = "TextBox", Description = "", Placeholder = "Enter text...", Default = "", Flag = nil, Callback = function() end}, o)
    local value = AuroraUI.Flags[o.Flag] or o.Default
    local row = new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.Card, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 94)})
    corner(row, 16)
    pad(row, 14, 14, 8, 8)
    textBlock(row, o.Title, o.Description, 0)
    local box = new("TextBox", {Parent = row, BackgroundColor3 = AuroraUI.Theme.Surface, BorderSizePixel = 0, Position = UDim2.new(0, 14, 1, -36), Size = UDim2.new(1, -28, 0, 30), Font = Enum.Font.GothamMedium, TextSize = 14, TextColor3 = AuroraUI.Theme.Text, PlaceholderText = o.Placeholder, PlaceholderColor3 = AuroraUI.Theme.Muted, Text = tostring(value), ClearTextOnFocus = false})
    corner(box, 11)
    local control = {}
    function control:Set(v, silent)
        value = tostring(v or "")
        box.Text = value
        if o.Flag then AuroraUI.Flags[o.Flag] = value end
        if not silent then task.spawn(o.Callback, value) end
    end
    function control:Get() return box.Text end
    control.Instance = row
    if o.Flag then AuroraUI:RegisterControl(o.Flag, control) AuroraUI.Flags[o.Flag] = value end
    box.FocusLost:Connect(function() control:Set(box.Text) end)
    return control
end

function Section:CreateSeparator()
    return new("Frame", {Parent = self.Container, BackgroundColor3 = AuroraUI.Theme.SurfaceSoft, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1)})
end

function AuroraUI:CreateWindow(o)
    o = merge({Title = "Aurora UI", Subtitle = "Premium Roblox Interface", Footer = "AuroraUI • v5.0.0", Size = UDim2.fromOffset(650, 450), Position = UDim2.fromScale(0.5, 0.52), AnchorPoint = Vector2.new(0.5, 0.5), ToggleKey = Enum.KeyCode.RightShift, MinimizeKey = Enum.KeyCode.M, MobileScale = 0.82, Draggable = true}, o)
    local gui = self.Gui or new("ScreenGui", {Parent = PlayerGui, Name = "AuroraUI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    self.Gui = gui
    local isMobile = UserInputService.TouchEnabled
    local main = new("CanvasGroup", {Parent = gui, AnchorPoint = o.AnchorPoint, Position = o.Position, Size = o.Size, BackgroundColor3 = AuroraUI.Theme.Background, BackgroundTransparency = AuroraUI.Theme.BackgroundTransparency, ClipsDescendants = true, BorderSizePixel = 0, GroupTransparency = 0})
    corner(main, 26)
    gradient(main, Color3.fromRGB(42, 48, 62), Color3.fromRGB(31, 35, 46), 45)
    local scale = new("UIScale", {Parent = main, Scale = (isMobile and o.MobileScale or 1) * 0.96})
    local targetScale = isMobile and o.MobileScale or 1
    local header = new("Frame", {Parent = main, BackgroundColor3 = AuroraUI.Theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 86)})
    gradient(header, Color3.fromRGB(55, 62, 80), Color3.fromRGB(43, 49, 64), 0)
    local accent = new("Frame", {Parent = header, BorderSizePixel = 0, BackgroundColor3 = AuroraUI.Theme.Accent, Position = UDim2.new(0, 22, 1, -4), Size = UDim2.new(0, 150, 0, 3)})
    corner(accent, 3)
    gradient(accent, AuroraUI.Theme.Accent, AuroraUI.Theme.AccentSecond, 0)
    local title = label(header, o.Title, 23, AuroraUI.Theme.Text, Enum.Font.GothamBold)
    title.Position = UDim2.fromOffset(22, 14)
    title.Size = UDim2.new(1, -140, 0, 30)
    local sub = label(header, o.Subtitle, 14, AuroraUI.Theme.Muted)
    sub.Position = UDim2.fromOffset(22, 46)
    sub.Size = UDim2.new(1, -140, 0, 22)
    local min = button(header, "")
    min.AnchorPoint = Vector2.new(1, 0)
    min.Position = UDim2.new(1, -58, 0, 24)
    min.Size = UDim2.fromOffset(17, 17)
    min.BackgroundColor3 = AuroraUI.Theme.Minimize
    corner(min, 17)
    local close = button(header, "")
    close.AnchorPoint = Vector2.new(1, 0)
    close.Position = UDim2.new(1, -28, 0, 24)
    close.Size = UDim2.fromOffset(17, 17)
    close.BackgroundColor3 = AuroraUI.Theme.Close
    corner(close, 17)
    local body = new("Frame", {Parent = main, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 86), Size = UDim2.new(1, 0, 1, -120)})
    local sidebar = new("ScrollingFrame", {Parent = body, BackgroundColor3 = AuroraUI.Theme.Sidebar, BackgroundTransparency = 0.08, BorderSizePixel = 0, Size = UDim2.new(0, 176, 1, 0), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0})
    pad(sidebar, 12, 12, 14, 14)
    list(sidebar, 9)
    local pages = new("Frame", {Parent = body, BackgroundTransparency = 1, Position = UDim2.fromOffset(188, 0), Size = UDim2.new(1, -200, 1, 0)})
    local footer = label(main, o.Footer, 12, AuroraUI.Theme.Muted)
    footer.Position = UDim2.new(0, 20, 1, -30)
    footer.Size = UDim2.new(1, -40, 0, 20)
    local open = button(gui, "Open Menu")
    open.Visible = false
    open.AnchorPoint = Vector2.new(0.5, 0)
    open.Position = UDim2.new(0.5, 0, 0, 16)
    open.Size = UDim2.fromOffset(180, 44)
    open.BackgroundColor3 = AuroraUI.Theme.RobloxBlack
    open.BackgroundTransparency = 0.12
    open.TextSize = 15
    corner(open, 24)
    gradient(open, Color3.fromRGB(31, 33, 39), Color3.fromRGB(20, 22, 27), 0)
    local openScale = new("UIScale", {Parent = open, Scale = 0.86})
    local w = setmetatable({Gui = gui, Main = main, Scale = scale, TargetScale = targetScale, OpenButton = open, OpenScale = openScale, Sidebar = sidebar, Pages = pages, Options = o, Tabs = {}, Groups = {}, Visible = true}, Window)
    min.MouseButton1Click:Connect(function() w:Minimize() end)
    close.MouseButton1Click:Connect(function() w:AskClose() end)
    open.MouseButton1Click:Connect(function() w:Show() end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == o.ToggleKey then if w.Main.Visible then w:Hide() else w:Show() end elseif input.KeyCode == o.MinimizeKey then w:Minimize() end
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