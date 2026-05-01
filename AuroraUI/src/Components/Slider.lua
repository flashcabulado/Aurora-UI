local UserInputService = game:GetService("UserInputService")
local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)
local Gradients = require(script.Parent.Parent.Effects.Gradients)

local Slider = {}
Slider.__index = Slider

function Slider.new(section, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Slider)
    self.Options = options or {}
    self.Min = self.Options.Min or 0
    self.Max = self.Options.Max or 100
    self.Increment = self.Options.Increment or 1
    self.Value = self.Options.Default or self.Min
    self.Frame = Utils.New("Frame", {Name = "Slider", Size = UDim2.new(1, 0, 0, 76), BackgroundColor3 = theme.Card, BackgroundTransparency = 0.08, ZIndex = 20, Parent = section.Container}, {Utils.Corner(16), Utils.Stroke(theme.Border, 0.9, 1)})
    local title = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -90, 0, 22), Font = Enum.Font.GothamSemibold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, Text = self.Options.Title or "Slider", ZIndex = 22, Parent = self.Frame})
    local valueLabel = Utils.New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 8), Size = UDim2.fromOffset(70, 22), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = theme.AccentSecondary, Text = tostring(self.Value), ZIndex = 22, Parent = self.Frame})
    local desc = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 30), Size = UDim2.new(1, -28, 0, 18), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = self.Options.Description or "", ZIndex = 22, Parent = self.Frame})
    local track = Utils.New("TextButton", {AutoButtonColor = false, Text = "", Position = UDim2.fromOffset(14, 56), Size = UDim2.new(1, -28, 0, 8), BackgroundColor3 = theme.Surface, ZIndex = 22, Parent = self.Frame}, {Utils.Corner(999)})
    local fill = Utils.New("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = theme.Accent, ZIndex = 23, Parent = track}, {Utils.Corner(999)})
    Gradients.Apply(fill, theme.Accent, theme.AccentSecondary, 0)
    local dragging = false
    local function snap(value)
        return math.clamp(math.floor((value / self.Increment) + 0.5) * self.Increment, self.Min, self.Max)
    end
    function self:Set(value)
        self.Value = snap(value)
        local alpha = (self.Value - self.Min) / (self.Max - self.Min)
        valueLabel.Text = tostring(self.Value)
        Animation.Tween(fill, Animation.Presets.Smooth, {Size = UDim2.fromScale(alpha, 1)})
        Utils.SafeCallback(self.Options.Callback, self.Value)
    end
    local function update(input)
        local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        self:Set(self.Min + (self.Max - self.Min) * alpha)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    self:Set(self.Value)
    return self
end

return Slider
