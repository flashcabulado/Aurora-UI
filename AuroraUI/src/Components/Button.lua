local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)
local Ripple = require(script.Parent.Parent.Effects.Ripple)

local Button = {}
Button.__index = Button

function Button.new(section, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Button)
    self.Options = options or {}
    self.Frame = Utils.New("TextButton", {
        Name = "Button",
        AutoButtonColor = false,
        Text = "",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = theme.Card,
        BackgroundTransparency = 0.08,
        ZIndex = 20,
        Parent = section.Container
    }, {Utils.Corner(16), Utils.Stroke(theme.Border, 0.9, 1), Utils.Padding(14)})
    Ripple.Apply(self.Frame, theme.Accent)
    local icon = Utils.New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.fromOffset(12, 14),
        Text = Utils.IconText(self.Options.Icon or "Sparkles"),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = theme.Accent,
        ZIndex = 22,
        Parent = self.Frame
    })
    local title = Utils.New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(52, 9),
        Size = UDim2.new(1, -70, 0, 22),
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = theme.Text,
        Text = self.Options.Title or "Button",
        ZIndex = 22,
        Parent = self.Frame
    })
    local desc = Utils.New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(52, 31),
        Size = UDim2.new(1, -70, 0, 18),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = theme.Subtext,
        Text = self.Options.Description or "",
        ZIndex = 22,
        Parent = self.Frame
    })
    self.Frame.MouseEnter:Connect(function()
        Animation.Tween(self.Frame, Animation.Presets.Smooth, {BackgroundTransparency = 0})
        Animation.Tween(icon, Animation.Presets.Smooth, {TextColor3 = theme.AccentSecondary})
    end)
    self.Frame.MouseLeave:Connect(function()
        Animation.Tween(self.Frame, Animation.Presets.Smooth, {BackgroundTransparency = 0.08})
        Animation.Tween(icon, Animation.Presets.Smooth, {TextColor3 = theme.Accent})
    end)
    self.Frame.MouseButton1Click:Connect(function()
        Animation.Press(self.Frame)
        Utils.SafeCallback(self.Options.Callback)
    end)
    return self
end

return Button
