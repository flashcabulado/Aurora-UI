local Gradients = {}

function Gradients.Apply(instance, colorA, colorB, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colorA),
        ColorSequenceKeypoint.new(1, colorB)
    })
    gradient.Rotation = rotation or 35
    gradient.Parent = instance
    return gradient
end

function Gradients.Text(instance, colorA, colorB)
    return Gradients.Apply(instance, colorA, colorB, 0)
end

return Gradients
