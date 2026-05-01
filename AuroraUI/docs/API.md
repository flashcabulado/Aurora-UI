# API

## AuroraUI:SetTheme(theme)

Aceita o nome de um preset ou uma tabela de cores.

Presets incluídos: `Dark`, `Ocean`, `Rose`.

## AuroraUI:GetTheme()

Retorna a tabela de tema atual.

## AuroraUI:CreateWindow(options)

Cria a janela principal.

Retorna um objeto `Window`.

## AuroraUI:Notify(options)

Cria uma notificação estilo iOS/macOS.

## Window:CreateTab(options)

Cria uma tab na sidebar.

## Window:SelectTab(tab)

Seleciona uma tab programaticamente.

## Window:Minimize()

Minimiza a janela e mostra o botão flutuante em formato pill.

## Window:Show()

Mostra a janela com animação.

## Window:Hide()

Esconde a janela e mostra o botão flutuante de reabertura.

## Window:Destroy()

Remove a janela e o botão flutuante.

## Tab:CreateSection(options)

Cria uma seção dentro da tab.

## Section:CreateButton(options)

Cria um botão animado com callback.

## Section:CreateToggle(options)

Cria um toggle estilo iPhone.

## Section:CreateSlider(options)

Cria um slider com valor mínimo, máximo, incremento e callback.

## Section:CreateDropdown(options)

Cria um dropdown animado.

## Section:CreateKeybind(options)

Cria um seletor de tecla customizável.

## Section:CreateTextBox(options)

Cria um campo de texto.

## Section:CreateSeparator(options)

Cria uma linha separadora visual.
