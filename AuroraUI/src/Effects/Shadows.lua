local Shadows = {}

function Shadows.Apply(parent, radius, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "AuroraShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.new(1, radius or 42, 1, radius or 42)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.55
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = math.max(0, parent.ZIndex - 1)
    shadow.Parent = parent
    return shadow
end

return Shadows
