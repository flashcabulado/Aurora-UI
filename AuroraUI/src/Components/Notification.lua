local Utils = require(script.Parent.Parent.Utils)
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Notification = {}
Notification.__index = Notification

function Notification.new(library, options)
    local theme = Theme.Get()
    local self = setmetatable({}, Notification)
    local kind = options.Type or "Info"
    local color = theme.Accent
    if kind == "Success" then color = theme.Success end
    if kind == "Warning" then color = theme.Warning end
    if kind == "Error" then color = theme.Error end
    self.Frame = Utils.New("Frame", {Name = "Notification", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 340, 0, 12), Size = UDim2.fromOffset(310, 82), BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.05, ZIndex = 100, Parent = library.NotificationHolder}, {Utils.Corner(18), Utils.Stroke(theme.Border, 0.86, 1)})
    Utils.New("Frame", {Position = UDim2.fromOffset(12, 14), Size = UDim2.fromOffset(6, 54), BackgroundColor3 = color, ZIndex = 101, Parent = self.Frame}, {Utils.Corner(999)})
    Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(28, 12), Size = UDim2.new(1, -44, 0, 22), Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Text, Text = options.Title or "AuroraUI", ZIndex = 101, Parent = self.Frame})
    Utils.New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(28, 35), Size = UDim2.new(1, -44, 0, 34), Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = theme.Subtext, Text = options.Content or "Notification", ZIndex = 101, Parent = self.Frame})
    Animation.Tween(self.Frame, Animation.Presets.Soft, {Position = UDim2.new(1, -12, 0, 12)})
    task.delay(options.Duration or 4, function()
        if self.Frame.Parent then
            local tween = Animation.Tween(self.Frame, Animation.Presets.Smooth, {Position = UDim2.new(1, 340, 0, 12), BackgroundTransparency = 1})
            tween.Completed:Wait()
            if self.Frame.Parent then
                self.Frame:Destroy()
            end
        end
    end)
    return self
end

return Notification
