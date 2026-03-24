local RunService = game:GetService("RunService")
local cloneref = (cloneref or clonereference or function(instance) return instance end)

-- */ Load WindUI /* --
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- */ Khởi tạo Window /* --
local Window = WindUI:CreateWindow({
    Title = "VTD HUB | GOM HITBOX TẠI CHỖ",
    Folder = "VTD_GomAtMe",
    Icon = "solar:users-group-two-rounded-bold",
    OpenButton = {
        Title = "Mở Menu",
        Enabled = true,
        Draggable = true,
    }
})

-- */ Cấu hình Global /* --
getgenv().Config = {
    GomEnabled = false,
    AutoM1 = false,
    ToolName = "Tool1",
    GomDistance = 3 -- Khoảng cách gom trước mặt (3 studs)
}

-- */ Logic Gom Hitbox & Auto M1 /* --
RunService.Stepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- 1. Logic Gom toàn bộ người chơi về 1 chỗ (vị trí của mình)
        if getgenv().Config.GomEnabled then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    -- Vị trí đích: Ngay trước mặt bạn một khoảng nhỏ
                    local targetCFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -getgenv().Config.GomDistance)
                    
                    -- Ép toàn bộ Hitbox (HRP) của đối thủ về đó
                    player.Character.HumanoidRootPart.CFrame = targetCFrame
                end
            end
        end

        -- 2. Logic Auto Equip & Nhấn M1
        if getgenv().Config.AutoM1 then
            local tool = char:FindFirstChild(getgenv().Config.ToolName) or lp.Backpack:FindFirstChild(getgenv().Config.ToolName)
            if tool then
                -- Tự cầm tool nếu đang trong Backpack
                if tool.Parent == lp.Backpack then
                    char.Humanoid:EquipTool(tool)
                end
                -- Kích hoạt chém M1
                tool:Activate()
            end
        end
    end
end)

-- */ Giao diện Menu /* --
local MainTab = Window:Tab({
    Title = "Gom Mục Tiêu",
    Icon = "solar:ghost-bold",
})

local CombatSection = MainTab:Section({ Title = "Chức Năng Gom" })

CombatSection:Toggle({
    Title = "Bật Gom Người Chơi",
    Desc = "Hút tất cả đối thủ về 1 chỗ trước mặt bạn",
    Value = false,
    Callback = function(state)
        getgenv().Config.GomEnabled = state
    end,
})

CombatSection:Toggle({
    Title = "Auto M1 (Tool1)",
    Desc = "Tự cầm vũ khí và chém liên tục vào chỗ gom",
    Value = false,
    Callback = function(state)
        getgenv().Config.AutoM1 = state
    end,
})

CombatSection:Slider({
    Title = "Khoảng cách Gom",
    Step = 1,
    Value = { Min = 0, Max = 10, Default = 3 },
    Callback = function(val)
        getgenv().Config.GomDistance = val
    end,
})

CombatSection:Input({
    Title = "Tên Tool",
    Value = "Tool1",
    Callback = function(val)
        getgenv().Config.ToolName = val
    end,
})

-- */ Notify /* --
WindUI:Notify({
    Title = "VTD HUB",
    Content = "Đã sẵn sàng gom đối thủ về một chỗ!",
    Duration = 5
})
