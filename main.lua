-- FluentLikeUI.lua
local Library = {}

function Library:CreateWindow(opts)
    local Title = opts.Title or "Window"
    local Logo = opts.Logo
    local Size = opts.Size or UDim2.new(0,400,0,300)

    local player = game.Players.LocalPlayer
    local pg = player:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui", pg)
    ScreenGui.Name = "FluentUI_" .. Title
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = Size
    Main.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    Main.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Main.BorderSizePixel = 0
    Main.Name = "Main"
    Main.ClipsDescendants = true

    Main.Active = true
    Main.Draggable = true

    -- Header
    local Header = Instance.new("Frame", Main)
    Header.Name = "Header"
    Header.Size = UDim2.new(1,0,0,36)
    Header.BackgroundColor3 = Color3.fromRGB(30,30,30)

    if Logo then
        local img = Instance.new("ImageLabel", Header)
        img.Name = "Logo"
        img.Size = UDim2.new(0,28,0,28)
        img.Position = UDim2.new(0,8,0.5,-14)
        img.Image = Logo
        img.BackgroundTransparency = 1
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

    -- Body setup
    local Body = Instance.new("Frame", Main)
    Body.Name = "Body"
    Body.Position = UDim2.new(0,0,0,36)
    Body.Size = UDim2.new(1,0,1,-36)
    Body.BackgroundTransparency = 1

    -- Left tab list
    local TabList = Instance.new("Frame", Body)
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(0,0,1,0)
    TabList.AutomaticSize = Enum.AutomaticSize.X
    TabList.BackgroundTransparency = 1

    local TabContainer = Instance.new("UIListLayout", TabList)
    TabContainer.SortOrder = Enum.SortOrder.LayoutOrder
    TabContainer.Padding = UDim.new(0,4)

    local ContentFrame = Instance.new("Frame", Body)
    ContentFrame.Name = "Content"
    ContentFrame.Position = UDim2.new(0,TabList.AbsoluteSize.X,0,0)
    ContentFrame.Size = UDim2.new(1,-TabList.AbsoluteSize.X,1,0)
    ContentFrame.BackgroundTransparency = 1

    local window = {Tabs={}, Body=Body, TabList=TabList, Content=ContentFrame, Main=Main}
    window.__index = window

    function window:CreateTab(name)
        local tabbtn = Instance.new("TextButton", TabList)
        tabbtn.Name = name
        tabbtn.Text = name
        tabbtn.Font = Enum.Font.Gotham
        tabbtn.TextSize = 16
        tabbtn.AutoButtonColor = false
        tabbtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        tabbtn.TextColor3 = Color3.fromRGB(200,200,200)
        tabbtn.Size = UDim2.new(1, -8, 0, 30)
        tabbtn.MouseButton1Click:Connect(function()
            for _,v in pairs(self.Tabs) do
                v.Frame.Visible = false
                v.Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
            end
            self.Tabs[name].Frame.Visible = true
            tabbtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end)

        local tabFrame = Instance.new("Frame", ContentFrame)
        tabFrame.Name = name
        tabFrame.BackgroundTransparency = 1
        tabFrame.Size = UDim2.new(1,0,1,0)
        tabFrame.Visible = false

        if #self.Tabs==0 then
            tabFrame.Visible = true
            tabbtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end

        local tab = {Button=tabbtn, Frame=tabFrame, Count=0}
        self.Tabs[name] = tab

        function tab:CreateButton(txt, callback)
            local b = Instance.new("TextButton", tabFrame)
            b.Size = UDim2.new(1,-16,0,24)
            b.Position = UDim2.new(0,8,0,8 + tab.Count*30)
            b.BackgroundColor3 = Color3.fromRGB(60,60,60)
            b.Font = Enum.Font.Gotham
            b.Text = txt
            b.TextSize = 14
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.AutoButtonColor = false
            b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(80,80,80) end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(60,60,60) end)
            b.MouseButton1Click:Connect(callback)
            tab.Count = tab.Count + 1
        end

        function tab:CreateToggle(txt, default, callback)
            local row = Instance.new("Frame", tabFrame)
            row.Size = UDim2.new(1,-16,0,24)
            row.Position = UDim2.new(0,8,0,8 + tab.Count*30)
            row.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.7,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = txt
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
            btn.MouseButton1Click:Connect(function()
                default = not default
                btn.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
                btn.Text = default and "ON" or "OFF"
                callback(default)
            end)

            tab.Count = tab.Count + 1
        end

        return tab
    end

    return window
end

return Library
