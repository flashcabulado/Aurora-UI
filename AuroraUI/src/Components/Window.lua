local UserInputService = game:GetService("UserInputService")
local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)
local Gradients = require(script.Parent.Parent.Effects.Gradients)
local Shadows = require(script.Parent.Parent.Effects.Shadows)
local Textures = require(script.Parent.Parent.Effects.Textures)
local Tab = require(script.Parent.Tab)

local Window = {}
Window.__index = Window

function Window.new(library, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Window)
    self.Library = library
    self.Options = options or {}
    self.Tabs = {}
    self.Groups = {}
    self.Visible = true
    self.Minimized = false
    self.ScreenGui = library.ScreenGui
    self.Root = Utils.New("Frame", {
        Name = "AuroraWindow",
        AnchorPoint = self.Options.AnchorPoint or Vector2.new(0.5, 0.5),
        Position = self.Options.Position or UDim2.fromScale(0.5, 0.5),
        Size = self.Options.Size or UDim2.fromOffset(620, 430),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = self.Options.Acrylic == false and 0 or 0.12,
        ClipsDescendants = false,
        ZIndex = 10,
        Parent = self.ScreenGui
    }, {Utils.Corner(24), Utils.Stroke(theme.Border, 0.82, 1)})
    self.Scale = Utils.New("UIScale", {Scale = Utils.IsMobile() and (self.Options.MobileScale or 0.85) or 1, Parent = self.Root})
    if self.Options.Shadow ~= false then
        Shadows.Apply(self.Root, 64, 0.45)
    end
    local backgroundGlow = Utils.New("Frame", {Name = "Glow", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, 4, 1, 4), BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.86, ZIndex = 9, Parent = self.Root}, {Utils.Corner(26)})
    Gradients.Apply(backgroundGlow, theme.Accent, theme.AccentSecondary, 35)
    if self.Options.Noise ~= false then
        Textures.Noise(self.Root, 0.94)
    end
    self.Banner = Utils.New("Frame", {Name = "Banner", Size = UDim2.new(1, 0, 0, 104), BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.08, ZIndex = 11, Parent = self.Root}, {Utils.Corner(24)})
    Gradients.Apply(self.Banner, theme.Accent, theme.AccentSecondary, 25)
    local bannerImage = self.Options.Banner or "rbxassetid://0"
    if bannerImage ~= "" and bannerImage ~= "rbxassetid://0" then
        Utils.New("ImageLabel", {BackgroundTransparency = 1, Image = bannerImage, ImageTransparency = 0.15, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, ZIndex = 12, Parent = self.Banner}, {Utils.Corner(24)})
    end
    self.Header = Utils.New("Frame", {Name = "Header", Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 96), BackgroundTransparency = 1, ZIndex = 13, Parent = self.Root})
    local thumbnail = Utils.New("ImageLabel", {BackgroundColor3 = theme.Card, Image = self.Options.Thumbnail or "rbxassetid://0", ImageTransparency = (self.Options.Thumbnail and self.Options.Thumbnail ~= "rbxassetid://0") and 0 or 1, Position = UDim2.fromOffset(18, 18), Size = UDim2.fromOffset(54, 54), ZIndex = 14, Parent = self.Header}, {Utils.Corner(16), Utils.Stroke(theme.Border, 0.84, 1)})
    Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(84, 20), Size = UDim2.new(1, -210, 0, 28), Font = Enum.Font.GothamBold, TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, Text = self.Options.Title or "Aurora UI", ZIndex = 14, Parent = self.Header})
    Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(86, 50), Size = UDim2.new(1, -210, 0, 20), Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, TextTransparency = 0.12, Text = self.Options.Subtitle or "Premium Roblox Interface", ZIndex = 14, Parent = self.Header})
    self.CloseButton = Utils.New("TextButton", {AutoButtonColor = false, Text = "×", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 18), Size = UDim2.fromOffset(34, 34), Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = theme.Text, BackgroundColor3 = theme.Error, BackgroundTransparency = 0.22, ZIndex = 16, Parent = self.Header}, {Utils.Corner(999)})
    self.MinButton = Utils.New("TextButton", {AutoButtonColor = false, Text = "−", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -58, 0, 18), Size = UDim2.fromOffset(34, 34), Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = theme.Text, BackgroundColor3 = theme.Warning, BackgroundTransparency = 0.22, ZIndex = 16, Parent = self.Header}, {Utils.Corner(999)})
    self.Body = Utils.New("Frame", {Name = "Body", Position = UDim2.fromOffset(14, 108), Size = UDim2.new(1, -28, 1, -152), BackgroundTransparency = 1, ZIndex = 12, Parent = self.Root})
    self.Sidebar = Utils.New("ScrollingFrame", {Name = "Sidebar", Size = UDim2.new(0, 164, 1, 0), CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, BorderSizePixel = 0, BackgroundColor3 = theme.Background, BackgroundTransparency = 0.26, ZIndex = 13, Parent = self.Body}, {Utils.Corner(18), Utils.Padding(10), Utils.List(Enum.FillDirection.Vertical, 8)})
    self.Pages = Utils.New("Frame", {Name = "Pages", Position = UDim2.fromOffset(176, 0), Size = UDim2.new(1, -176, 1, 0), BackgroundColor3 = theme.Background, BackgroundTransparency = 0.36, ZIndex = 13, Parent = self.Body}, {Utils.Corner(18), Utils.Stroke(theme.Border, 0.92, 1)})
    self.Footer = Utils.New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 20, 1, -12), Size = UDim2.new(1, -40, 0, 20), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = self.Options.Footer or "AuroraUI • v1.0.0", ZIndex = 14, Parent = self.Root})
    self.Pill = Utils.New("TextButton", {Name = "AuroraPill", AutoButtonColor = false, Text = "✦  " .. (self.Options.Title or "Aurora UI"), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -24), Size = UDim2.fromOffset(210, 44), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = theme.Text, BackgroundColor3 = theme.Surface, Visible = false, ZIndex = 80, Parent = self.ScreenGui}, {Utils.Corner(999), Utils.Stroke(theme.Border, 0.78, 1)})
    Gradients.Apply(self.Pill, theme.Accent, theme.AccentSecondary, 0)
    if self.Options.Draggable ~= false then
        Utils.MakeDraggable(self.Header, self.Root)
    end
    self.MinButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    self.Pill.MouseButton1Click:Connect(function()
        self:Show()
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.KeyCode == (self.Options.ToggleKey or Enum.KeyCode.RightShift) then
            if self.Visible then self:Hide() else self:Show() end
        end
        if input.KeyCode == (self.Options.MinimizeKey or Enum.KeyCode.M) and self.Visible then
            self:Minimize()
        end
    end)
    Animation.Tween(self.Scale, Animation.Presets.Spring, {Scale = Utils.IsMobile() and (self.Options.MobileScale or 0.85) or 1})
    return self
end

function Window:GetGroupContainer(groupName)
    local theme = Theme.Get()
    if self.Groups[groupName] then
        return self.Groups[groupName].Container
    end
    local group = Utils.New("Frame", {Name = groupName, Size = UDim2.new(1, 0, 0, 56), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = self.Sidebar}, {Utils.List(Enum.FillDirection.Vertical, 6)})
    Utils.New("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -4, 0, 20), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = string.upper(groupName), Parent = group})
    local container = Utils.New("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = group}, {Utils.List(Enum.FillDirection.Vertical, 6)})
    self.Groups[groupName] = {Frame = group, Container = container}
    return container
end

function Window:CreateTab(options)
    local tab = Tab.new(self, options)
    table.insert(self.Tabs, tab)
    if not self.SelectedTab then
        self:SelectTab(tab)
    end
    return tab
end

function Window:SelectTab(tab)
    self.SelectedTab = tab
    for _, item in ipairs(self.Tabs) do
        item:SetSelected(item == tab)
    end
end

function Window:Hide()
    self.Visible = false
    self.Minimized = false
    Animation.Tween(self.Scale, Animation.Presets.Smooth, {Scale = 0.96})
    Animation.Tween(self.Root, Animation.Presets.Smooth, {BackgroundTransparency = 1})
    task.delay(0.18, function()
        if not self.Visible then
            self.Root.Visible = false
        end
    end)
    self.Pill.Visible = true
    self.Pill.Text = "✦  Open " .. (self.Options.Title or "Aurora UI")
end

function Window:Show()
    self.Visible = true
    self.Minimized = false
    self.Root.Visible = true
    self.Pill.Visible = false
    self.Scale.Scale = 0.96
    Animation.Tween(self.Scale, Animation.Presets.Spring, {Scale = Utils.IsMobile() and (self.Options.MobileScale or 0.85) or 1})
    Animation.Tween(self.Root, Animation.Presets.Smooth, {BackgroundTransparency = self.Options.Acrylic == false and 0 or 0.12})
end

function Window:Minimize()
    if self.Options.Minimizable == false then
        return
    end
    self.Visible = false
    self.Minimized = true
    Animation.Tween(self.Scale, Animation.Presets.Soft, {Scale = 0.72})
    Animation.Tween(self.Root, Animation.Presets.Smooth, {BackgroundTransparency = 1})
    task.delay(0.18, function()
        if self.Minimized then
            self.Root.Visible = false
            self.Pill.Visible = true
            self.Pill.Text = "✦  " .. (self.Options.Title or "Aurora UI")
        end
    end)
end

function Window:Destroy()
    if self.Root then self.Root:Destroy() end
    if self.Pill then self.Pill:Destroy() end
end

return Window
