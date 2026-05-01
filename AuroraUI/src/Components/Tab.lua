local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)
local Section = require(script.Parent.Section)

local Tab = {}
Tab.__index = Tab

function Tab.new(window, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Tab)
    self.Window = window
    self.Options = options or {}
    self.Name = self.Options.Name or "Tab"
    self.Group = self.Options.Group or "General"
    self.Button = Utils.New("TextButton", {Name = self.Name .. "Button", AutoButtonColor = false, Text = "", Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = theme.Card, BackgroundTransparency = 1, ZIndex = 18, Parent = window:GetGroupContainer(self.Group)}, {Utils.Corner(12)})
    self.Icon = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.fromOffset(24, 38), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = theme.Subtext, Text = Utils.IconText(self.Options.Icon), ZIndex = 19, Parent = self.Button})
    self.Label = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(38, 0), Size = UDim2.new(1, -46, 1, 0), Font = Enum.Font.GothamSemibold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = self.Name, ZIndex = 19, Parent = self.Button})
    self.Page = Utils.New("ScrollingFrame", {Name = self.Name .. "Page", Visible = false, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 14, Parent = window.Pages}, {Utils.Padding(14), Utils.List(Enum.FillDirection.Vertical, 12)})
    self.Content = self.Page
    self.Button.MouseButton1Click:Connect(function()
        window:SelectTab(self)
    end)
    return self
end

function Tab:SetSelected(selected)
    local theme = Theme.Get()
    self.Page.Visible = selected
    Animation.Tween(self.Button, Animation.Presets.Smooth, {BackgroundTransparency = selected and 0.12 or 1, BackgroundColor3 = selected and theme.Accent or theme.Card})
    Animation.Tween(self.Icon, Animation.Presets.Smooth, {TextColor3 = selected and theme.Text or theme.Subtext})
    Animation.Tween(self.Label, Animation.Presets.Smooth, {TextColor3 = selected and theme.Text or theme.Subtext})
end

function Tab:CreateSection(options)
    return Section.new(self, options)
end

return Tab
