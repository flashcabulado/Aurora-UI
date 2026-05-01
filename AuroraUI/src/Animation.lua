local TweenService = game:GetService("TweenService")

local Animation = {}

Animation.Presets = {
    Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Soft = TweenInfo.new(0.32, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
}

function Animation.Tween(instance, info, properties)
    local tween = TweenService:Create(instance, info or Animation.Presets.Smooth, properties)
    tween:Play()
    return tween
end

function Animation.Fade(root, target, info)
    for _, item in ipairs(root:GetDescendants()) do
        if item:IsA("GuiObject") then
            local props = {}
            if item:IsA("TextLabel") or item:IsA("TextButton") or item:IsA("TextBox") then
                props.TextTransparency = target
            end
            if item:IsA("ImageLabel") or item:IsA("ImageButton") then
                props.ImageTransparency = math.clamp(target, 0, 1)
            end
            if item.BackgroundTransparency < 1 then
                props.BackgroundTransparency = math.clamp(target, 0, 1)
            end
            if next(props) then
                Animation.Tween(item, info or Animation.Presets.Smooth, props)
            end
        elseif item:IsA("UIStroke") then
            Animation.Tween(item, info or Animation.Presets.Smooth, {Transparency = target})
        end
    end
end

function Animation.Press(instance)
    local scale = instance:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
    scale.Scale = scale.Scale == 0 and 1 or scale.Scale
    scale.Parent = instance
    Animation.Tween(scale, Animation.Presets.Fast, {Scale = 0.97})
    task.delay(0.11, function()
        if scale.Parent then
            Animation.Tween(scale, Animation.Presets.Spring, {Scale = 1})
        end
    end)
end

return Animation
