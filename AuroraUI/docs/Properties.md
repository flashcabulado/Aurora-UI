# Properties

## Window

| Propriedade | Tipo | Padrão |
|---|---|---|
| Title | string | Aurora UI |
| Subtitle | string | Premium Roblox Interface |
| Footer | string | AuroraUI • v1.0.0 |
| Thumbnail | string | rbxassetid://0 |
| Banner | string | rbxassetid://0 |
| Size | UDim2 | UDim2.fromOffset(620, 430) |
| Position | UDim2 | UDim2.fromScale(0.5, 0.5) |
| AnchorPoint | Vector2 | Vector2.new(0.5, 0.5) |
| ToggleKey | Enum.KeyCode | RightShift |
| MinimizeKey | Enum.KeyCode | M |
| Theme | string/table | Dark |
| Acrylic | boolean | true |
| Noise | boolean | true |
| Shadow | boolean | true |
| Blur | boolean | true |
| MobileScale | number | 0.85 |
| Draggable | boolean | true |
| Closable | boolean | true |
| Minimizable | boolean | true |

## Tab

| Propriedade | Tipo |
|---|---|
| Name | string |
| Icon | string |
| Group | string |

## Section

| Propriedade | Tipo |
|---|---|
| Title | string |
| Description | string |

## Button

| Propriedade | Tipo |
|---|---|
| Title | string |
| Description | string |
| Icon | string |
| Callback | function |

## Toggle

| Propriedade | Tipo |
|---|---|
| Title | string |
| Description | string |
| Default | boolean |
| Callback | function(boolean) |

## Slider

| Propriedade | Tipo |
|---|---|
| Title | string |
| Description | string |
| Min | number |
| Max | number |
| Default | number |
| Increment | number |
| Callback | function(number) |

## Dropdown

| Propriedade | Tipo |
|---|---|
| Title | string |
| Description | string |
| Options | table |
| Default | any |
| Callback | function(value) |

## Keybind

| Propriedade | Tipo |
|---|---|
| Title | string |
| Description | string |
| Default | Enum.KeyCode |
| Callback | function |

## TextBox

| Propriedade | Tipo |
|---|---|
| Title | string |
| Description | string |
| Placeholder | string |
| Default | string |
| Callback | function(string) |

## Notification

| Propriedade | Tipo |
|---|---|
| Title | string |
| Content | string |
| Duration | number |
| Type | Info, Success, Warning, Error |
