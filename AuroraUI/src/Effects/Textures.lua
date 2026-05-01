local Textures = {}

function Textures.Noise(parent, transparency)
    local texture = Instance.new("ImageLabel")
    texture.Name = "AuroraNoise"
    texture.BackgroundTransparency = 1
    texture.Image = "rbxassetid://9968344105"
    texture.ImageTransparency = transparency or 0.92
    texture.ScaleType = Enum.ScaleType.Tile
    texture.TileSize = UDim2.fromOffset(128, 128)
    texture.Size = UDim2.fromScale(1, 1)
    texture.ZIndex = parent.ZIndex + 1
    texture.Parent = parent
    return texture
end

function Textures.Acrylic(parent, theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "AuroraAcrylic"
    overlay.BackgroundColor3 = theme.Surface
    overlay.BackgroundTransparency = 0.28
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.ZIndex = parent.ZIndex
    overlay.Parent = parent
    return overlay
end

return Textures
