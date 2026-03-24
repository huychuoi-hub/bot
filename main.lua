local RunService = game:GetService("RunService")
local cloneref = (cloneref or clonereference or function(instance) return instance end)
local lp = game.Players.LocalPlayer

-- */ Load WindUI /* --
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- */ Khởi tạo Window /* --
local Window = WindUI:CreateWindow({
    Title = "VTD HUB | BRING ALL & MAX HITBOX",
    Folder = "VTD_BringConfig",
    Icon = "solar:users-group-two-rounded-bold",
    OpenButton = {
        Title = "Mở Menu",
        Enabled = true,
        Draggable = true,
    }
})

-- */ Cấu hình Global /* --
getgenv().Config = {
    BringEnabled = false,
    HitboxEnabled = false,
    AutoM1 = false,
    ToolName = "Tool1", -- Tên vật phẩm trong kho
    GomDistance = 3,    -- Khoảng cách gom trước mặt
    HitboxSize = 1000   -- Kích thước hitbox x1000
}

-- */ Logic xử lý chính (Main Loop) /* --
RunService.Stepped:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- 1. Logic Gom toàn bộ người chơi & Phóng to Hitbox
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            
            -- Gom người chơi về một điểm trước mặt bạn
            if getgenv().Config.BringEnabled then
                targetHRP.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -getgenv().Config.GomDistance)
            end
            
            -- Phóng to Hitbox của người bị gom
            if getgenv().Config.HitboxEnabled then
                targetHRP.Size = Vector3.new(getgenv().Config.HitboxSize, getgenv().Config.HitboxSize, getgenv().Config.HitboxSize)
                targetHRP.Transparency = 0.8
                targetHRP.BrickColor = BrickColor.new("Really red")
                targetHRP.CanCollide = false
            end
        end
    end

    -- 2. Logic Auto Equip & Nhấn M1
    if getgenv().Config.AutoM1 then
        local tool = char:FindFirstChild(getgenv().Config.ToolName) or lp.Backpack:FindFirstChild(getgenv().Config.ToolName)
        if tool then
            -- Ép cầm vật phẩm từ kho ra tay
            if tool.Parent == lp.Backpack then
                char.Humanoid:EquipTool(tool)
            end
            -- Nhấn chuột trái (M1)
            tool:Activate()
        end
    end
end)

-- */ Giao diện Menu /* --
local MainTab = Window:Tab({
    Title = "Gom & Diệt",
    Icon = "solar:bolt-bold",
})

local CombatSection = MainTab:Section({ Title = "Chức Năng Chính" })

CombatSection:Toggle({
    Title = "Bật Gom Người Chơi",
    Desc = "Hút toàn bộ server về phía trước mặt bạn",
    Value = false,
    Callback = function(state)
        getgenv().Config.BringEnabled = state
    end,
})

CombatSection:Toggle({
    Title = "Bật Hitbox x1000",
    Desc = "Phóng to vùng va chạm của đối thủ",
    Value = false,
    Callback = function(state)
        getgenv().Config.HitboxEnabled = state
        if not state then
            -- Reset hitbox khi tắt
            for _, p in pairs(game.Players:GetPlayers()) do
                pcall(function() p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1) end)
            end
        end
    end,
})

CombatSection:Toggle({
    Title = "Auto Equip & M1",
    Desc = "Tự lấy vật phẩm và chém liên tục",
    Value = false,
    Callback = function(state)
        getgenv().Config.AutoM1 = state
    end,
})

CombatSection:Input({
    Title = "Tên Vật Phẩm (Tool)",
    Value = "Tool1",
    Callback = function(val)
        getgenv().Config.ToolName = val
    end,
})

CombatSection:Slider({
    Title = "Kích thước Hitbox",
    Step = 10,
    Value = { Min = 2, Max = 1000, Default = 1000 },
    Callback = function(val)
        getgenv().Config.HitboxSize = val
    end,
})

-- */ Thông báo /* --
WindUI:Notify({
    Title = "VTD HUB",
    Content = "Script đã sẵn sàng gom mục tiêu!",
    Duration = 5
})
