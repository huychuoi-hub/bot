local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- LOGO
local logo = Instance.new("TextButton")
logo.Parent = gui
logo.Size = UDim2.new(0,70,0,70)
logo.Position = UDim2.new(0.05,0,0.6,0)
logo.Text = "Z"
logo.Font = Enum.Font.Arcade
logo.TextSize = 35
logo.TextColor3 = Color3.fromRGB(0,170,255)
logo.BackgroundColor3 = Color3.fromRGB(255,255,255)
logo.BackgroundTransparency = 0.4
Instance.new("UICorner",logo).CornerRadius = UDim.new(1,0)

-- XOAY LOGO
task.spawn(function()
while true do
logo.Rotation += 2
task.wait(0.02)
end
end)

-- MENU GLASS
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,240,0,180)
frame.Position = UDim2.new(0.5,-120,0.5,-90)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.4
frame.Visible = false
Instance.new("UICorner",frame)

local stroke2 = Instance.new("UIStroke", frame)
stroke2.Color = Color3.fromRGB(0,170,255)

-- TITLE
local title2 = Instance.new("TextLabel",frame)
title2.Size = UDim2.new(1,0,0,40)
title2.BackgroundTransparency = 1
title2.Text = "Zeus Hub v2"
title2.Font = Enum.Font.Arcade
title2.TextSize = 24
title2.TextColor3 = Color3.fromRGB(0,170,255)

-- BUTTONS
local espButton = Instance.new("TextButton",frame)
espButton.Size = UDim2.new(0.8,0,0,35)
espButton.Position = UDim2.new(0.1,0,0.4,0)
espButton.Text = "ESP : OFF"
espButton.BackgroundTransparency = 0.3
Instance.new("UICorner",espButton)

local hitboxButton = Instance.new("TextButton",frame)
hitboxButton.Size = UDim2.new(0.8,0,0,35)
hitboxButton.Position = UDim2.new(0.1,0,0.7,0)
hitboxButton.Text = "HITBOX : OFF"
hitboxButton.BackgroundTransparency = 0.3
Instance.new("UICorner",hitboxButton)

-- DRAG FIX
local function dragify(Frame)
    local dragToggle = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    Frame.InputEnded:Connect(function()
        dragToggle = false
    end)
end

dragify(logo)
dragify(frame)

logo.MouseButton1Click:Connect(function()
frame.Visible = not frame.Visible
end)

-- TUYẾT
task.spawn(function()
while true do
if frame.Visible then
local snow = Instance.new("Frame")
snow.Parent = frame
snow.Size = UDim2.new(0,4,0,4)
snow.Position = UDim2.new(math.random(),0,-0.1,0)
snow.BackgroundColor3 = Color3.new(1,1,1)
snow.BorderSizePixel = 0
Instance.new("UICorner",snow).CornerRadius = UDim.new(1,0)

TweenService:Create(snow,TweenInfo.new(4),{
Position = UDim2.new(math.random(),0,1,0)
}):Play()

game:GetService("Debris"):AddItem(snow,4)
task.wait(0.1)
else
task.wait(0.3)
end
end
end)

-- BUTTON LOGIC
espButton.MouseButton1Click:Connect(function()
ESPEnabled = not ESPEnabled
espButton.Text = ESPEnabled and "ESP : ON" or "ESP : OFF"
end)

hitboxButton.MouseButton1Click:Connect(function()
HitboxEnabled = not HitboxEnabled
hitboxButton.Text = HitboxEnabled and "HITBOX : ON" or "HITBOX : OFF"
end)

-- APPLY ESP + HITBOX
local function apply(player)
if player == LocalPlayer then return end

local function setup(char)
local hrp = char:WaitForChild("HumanoidRootPart")

local highlight = Instance.new("Highlight")
highlight.Parent = char
highlight.FillTransparency = 1
highlight.OutlineColor = Color3.fromRGB(0,170,255)

local box = Instance.new("BoxHandleAdornment")
box.Parent = char
box.Adornee = hrp
box.Size = Vector3.new(4,6,2)
box.Color3 = Color3.fromRGB(0,170,255)
box.Transparency = 0.5
box.AlwaysOnTop = true

-- NAME 7 MÀU NHỎ
local billboard = Instance.new("BillboardGui")
billboard.Parent = char
billboard.Size = UDim2.new(0,100,0,30)
billboard.StudsOffset = Vector3.new(0,3,0)
billboard.AlwaysOnTop = true

local text = Instance.new("TextLabel")
text.Parent = billboard
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.Text = player.Name
text.TextSize = 14
text.Font = Enum.Font.Arcade

task.spawn(function()
local colors = {
Color3.fromRGB(255,0,0),
Color3.fromRGB(255,127,0),
Color3.fromRGB(255,255,0),
Color3.fromRGB(0,255,0),
Color3.fromRGB(0,0,255),
Color3.fromRGB(75,0,130),
Color3.fromRGB(148,0,211)
}

while text.Parent do
for _,c in pairs(colors) do
text.TextColor3 = c
task.wait(0.3)
end
end
end)

RunService.RenderStepped:Connect(function()
highlight.Enabled = ESPEnabled
box.Visible = ESPEnabled
billboard.Enabled = ESPEnabled

if HitboxEnabled then
hrp.Size = Vector3.new(20000,20000,20000)
hrp.Transparency = 0.5
hrp.CanCollide = false
else
hrp.Size = Vector3.new(2,2,1)
hrp.Transparency = 1
end
end)

end

if player.Character then
setup(player.Character)
end

player.CharacterAdded:Connect(setup)
end

for _,p in pairs(Players:GetPlayers()) do
apply(p)
end

Players.PlayerAdded:Connect(apply)
