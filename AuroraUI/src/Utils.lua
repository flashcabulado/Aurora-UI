local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Utils = {}

function Utils.New(className, props, children)
    local instance = Instance.new(className)
    for key, value in pairs(props or {}) do
        instance[key] = value
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

function Utils.Corner(radius)
    return Utils.New("UICorner", {CornerRadius = UDim.new(0, radius or 16)})
end

function Utils.Stroke(color, transparency, thickness)
    return Utils.New("UIStroke", {
        Color = color or Color3.new(1, 1, 1),
        Transparency = transparency or 0.85,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

function Utils.Padding(all, left, right, top, bottom)
    return Utils.New("UIPadding", {
        PaddingLeft = UDim.new(0, left or all or 0),
        PaddingRight = UDim.new(0, right or all or 0),
        PaddingTop = UDim.new(0, top or all or 0),
        PaddingBottom = UDim.new(0, bottom or all or 0)
    })
end

function Utils.List(direction, padding, align, sortOrder)
    return Utils.New("UIListLayout", {
        FillDirection = direction or Enum.FillDirection.Vertical,
        Padding = UDim.new(0, padding or 8),
        HorizontalAlignment = align or Enum.HorizontalAlignment.Left,
        SortOrder = sortOrder or Enum.SortOrder.LayoutOrder
    })
end

function Utils.IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function Utils.GetPlayerGui()
    local player = Players.LocalPlayer
    return player:WaitForChild("PlayerGui")
end

function Utils.MakeDraggable(handle, target)
    local dragging = false
    local dragStart
    local startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Utils.SafeCallback(callback, ...)
    if typeof(callback) == "function" then
        task.spawn(callback, ...)
    end
end

function Utils.IconText(icon)
    local map = {
        Home = "⌂",
        Sparkles = "✦",
        Settings = "⚙",
        Player = "◉",
        Shield = "◆",
        Bell = "◔",
        Palette = "◈",
        Code = "⌘"
    }
    return map[icon] or tostring(icon or "•")
end

return Utils
