local Animation = require(script.Parent.Parent.Animation)

local Ripple = {}

function Ripple.Apply(button, color)
    button.ClipsDescendants = true
    button.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local ripple = Instance.new("Frame")
        ripple.Name = "AuroraRipple"
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.fromOffset(input.Position.X - button.AbsolutePosition.X, input.Position.Y - button.AbsolutePosition.Y)
        ripple.Size = UDim2.fromOffset(0, 0)
        ripple.BackgroundColor3 = color or Color3.new(1, 1, 1)
        ripple.BackgroundTransparency = 0.78
        ripple.ZIndex = button.ZIndex + 4
        ripple.Parent = button
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        Animation.Tween(ripple, Animation.Presets.Smooth, {Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1})
        task.delay(0.35, function()
            if ripple.Parent then
                ripple:Destroy()
            end
        end)
    end)
end

return Ripple
