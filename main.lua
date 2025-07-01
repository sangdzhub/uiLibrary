-- FluentLikeUI.lua (v2)
local Library = {}

function Library:CreateWindow(opts)
    local Title = opts.Title or "Window"
    local Logo = opts.Logo
    local Size = opts.Size or UDim2.new(0,400,0,300)

    local player = game.Players.LocalPlayer
    local pg = player:WaitForChild("PlayerGui")
    local SG = Instance.new("ScreenGui", pg)
    SG.Name = "FluentUI_" .. Title
    SG.ResetOnSpawn = false

    local Main = Instance.new("Frame", SG)
    Main.Size = Size
    Main.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    Main.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Main.BorderSizePixel = 0
    Main.Name = "Main"
    Main.ClipsDescendants = true
    Main.Active = true
    Main.Draggable = true

    local Header = Instance.new("Frame", Main)
    Header.Name = "Header"
    Header.Size = UDim2.new(1,0,0,36)
    Header.BackgroundColor3 = Color3.fromRGB(30,30,30)

    local logoBtn
    if Logo then
        logoBtn = Instance.new("ImageButton", Header)
        logoBtn.Name = "LogoBtn"
        logoBtn.Size = UDim2.new(0,28,0,28)
        logoBtn.Position = UDim2.new(0,8,0.5,-14)
        logoBtn.Image = Logo
        logoBtn.BackgroundTransparency = 1
        logoBtn.AutoButtonColor = false
    end

    local titleLabel = Instance.new("TextLabel", Header)
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = Logo and UDim2.new(0,44,0,0) or UDim2.new(0,8,0,0)
    titleLabel.Size = UDim2.new(1,-(Logo and 52 or 16),1,0)
    titleLabel.Text = Title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Body = Instance.new("Frame", Main)
    Body.Name = "Body"
    Body.Position = UDim2.new(0,0,0,36)
    Body.Size = UDim2.new(1,0,1,-36)
    Body.BackgroundTransparency = 1

    local TabList = Instance.new("Frame", Body)
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(0,120,1,0)
    TabList.BackgroundColor3 = Color3.fromRGB(35,35,35)

    local layout = Instance.new("UIListLayout", TabList)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,4)

    local Content = Instance.new("Frame", Body)
    Content.Name = "Content"
    Content.Position = UDim2.new(0,120,0,0)
    Content.Size = UDim2.new(1,-120,1,0)
    Content.BackgroundTransparency = 1

    local window = {Tabs={}, Main=Main, TabList=TabList, Content=Content}
    window.__index = window

    if logoBtn then
        logoBtn.MouseButton1Click:Connect(function()
            local target = TabList.Size.X.Offset > 0 and 0 or 120
            TabList:TweenSize(UDim2.new(0,target,1,0), "Out", "Quint", 0.3, true, function()
                Content:TweenPosition(UDim2.new(0,target,0,0), "Out", "Quint", 0.3, true)
            end)
        end)
    end

    function window:CreateTab(name)
        local btn = Instance.new("TextButton", TabList)
        btn.Name = name
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.TextColor3 = Color3.fromRGB(200,200,200)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.AutoButtonColor = false
        btn.Size = UDim2.new(1,-8,0,30)
        btn.LayoutOrder = #self.Tabs + 1

        local frame = Instance.new("Frame", Content)
        frame.Name = name
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(1,0,1,0)
        frame.Visible = false

        if #self.Tabs == 0 then
            frame.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end

        btn.MouseButton1Click:Connect(function()
            for _,tab in pairs(self.Tabs) do
                tab.Frame.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
            end
            frame.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end)

        local tab = {Button=btn, Frame=frame, Count=0}
        self.Tabs[name] = tab

        function tab:CreateButton(text, callback)
            local b = Instance.new("TextButton", frame)
            b.Size = UDim2.new(1,-16,0,24)
            b.Position = UDim2.new(0,8,0,8 + self.Count*30)
            b.BackgroundColor3 = Color3.fromRGB(60,60,60)
            b.Font = Enum.Font.Gotham
            b.Text = text
            b.TextSize = 14
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.AutoButtonColor = false
            b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(80,80,80) end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(60,60,60) end)
            b.MouseButton1Click:Connect(callback)
            self.Count += 1
        end

        function tab:CreateToggle(text, default, callback)
            local row = Instance.new("Frame", frame)
            row.Size = UDim2.new(1,-16,0,24)
            row.Position = UDim2.new(0,8,0,8 + self.Count*30)
            row.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.7,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.TextXAlignment = Enum.TextXAlignment.Left

            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(0,40,0,20)
            btn.Position = UDim2.new(1,-44,0,2)
            btn.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
            btn.Text = default and "ON" or "OFF"
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.AutoButtonColor = false
            btn.MouseButton1Click:Connect(function()
                default = not default
                btn.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
                btn.Text = default and "ON" or "OFF"
                callback(default)
            end)

            self.Count += 1
        end

        return tab
    end

    return window
end

return Library
