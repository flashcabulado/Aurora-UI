local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local TextBoxComponent = {}
TextBoxComponent.__index = TextBoxComponent

function TextBoxComponent.new(section, options)
    local theme = Theme.Get()
    local self = setmetatable({}, TextBoxComponent)
    self.Options = options or {}
    self.Frame = Utils.New("Frame", {Name = "TextBox", Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = theme.Card, BackgroundTransparency = 0.08, ZIndex = 20, Parent = section.Container}, {Utils.Corner(16), Utils.Stroke(theme.Border, 0.9, 1)})
    local title = Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -28, 0, 22), Font = Enum.Font.GothamSemibold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, Text = self.Options.Title or "TextBox", ZIndex = 22, Parent = self.Frame})
    local box = Utils.New("TextBox", {ClearTextOnFocus = false, PlaceholderText = self.Options.Placeholder or "Type...", Text = self.Options.Default or "", Position = UDim2.fromOffset(14, 36), Size = UDim2.new(1, -28, 0, 26), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = theme.Text, PlaceholderColor3 = theme.Subtext, BackgroundColor3 = theme.Surface, ZIndex = 23, Parent = self.Frame}, {Utils.Corner(10), Utils.Padding(8, 8, 8, 0, 0)})
    box.Focused:Connect(function()
        Animation.Tween(box, Animation.Presets.Smooth, {BackgroundColor3 = theme.Card})
    end)
    box.FocusLost:Connect(function()
        Animation.Tween(box, Animation.Presets.Smooth, {BackgroundColor3 = theme.Surface})
        Utils.SafeCallback(self.Options.Callback, box.Text)
    end)
    return self
end

return TextBoxComponent
