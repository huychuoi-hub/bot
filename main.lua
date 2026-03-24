local RunService = game:GetService("RunService")
local cloneref = (cloneref or clonereference or function(instance) return instance end)

-- */ Load WindUI /* --
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- */ Khởi tạo Window /* --
local Window = WindUI:CreateWindow({
    Title = "VTD PREMIUM | HITBOX GOM",
    Folder = "VTD_Configs",
    Icon = "solar:target-bold",
    OpenButton = {
        Title = "Mở VTD Hub",
        Enabled = true,
        Draggable = true,
    }
})

-- */ Cấu hình Global /* --
getgenv().Config = {
    HitboxEnabled = false,
    HitboxSize = 20,
    AutoM1 = false,
    ToolName = "Tool1" -- Thay đổi tên Tool của bạn ở đây
}

-- */ Logic Gom Hitbox & Auto M1 /* --
RunService.RenderStepped:Connect(function()
    if getgenv().Config.HitboxEnabled then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                -- Làm to hitbox để "gom" diện tích va chạm lại
                hrp.Size = Vector3.new(getgenv().Config.HitboxSize, getgenv().Config.HitboxSize, getgenv().Config.HitboxSize)
                hrp.Transparency = 0.8
                hrp.BrickColor = BrickColor.new("Really red")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end
        end
    end

    if getgenv().Config.AutoM1 then
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if char then
            -- Tìm Tool1 trong nhân vật (đang cầm trên tay)
            local tool = char:FindFirstChild(getgenv().Config.ToolName)
            if tool and tool:IsA("Tool") then
                -- Kiểm tra xem có ai gần đó không để nhấn M1
                for _, target in ipairs(game.Players:GetPlayers()) do
                    if target ~= lp and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                        -- Nếu đối thủ nằm trong vùng hitbox đã gom
                        if dist <= (getgenv().Config.HitboxSize / 2 + 5) then
                            tool:Activate() -- Tương ứng nhấn chuột trái (M1)
                        end
                    end
                end
            end
        end
    end
end)

-- */ Giao diện Menu /* --
local MainTab = Window:Tab({
    Title = "Main Cheats",
    Icon = "solar:fire-bold",
})

local CombatSection = MainTab:Section({ Title = "Hitbox & Combat" })

CombatSection:Toggle({
    Title = "Bật Gom Hitbox",
    Desc = "Làm to hitbox đối thủ để dễ đánh trúng",
    Value = false,
    Callback = function(state)
        getgenv().Config.HitboxEnabled = state
        if not state then
            -- Reset về mặc định khi tắt
            for _, p in pairs(game.Players:GetPlayers()) do
                pcall(function() p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1) end)
            end
        end
    end,
})

CombatSection:Slider({
    Title = "Kích thước Gom",
    Step = 1,
    Value = { Min = 2, Max = 100, Default = 20 },
    Callback = function(val)
        getgenv().Config.HitboxSize = val
    end,
})

CombatSection:Toggle({
    Title = "Auto M1 (Tool1)",
    Desc = "Tự động chém khi đối thủ trong tầm",
    Value = false,
    Callback = function(state)
        getgenv().Config.AutoM1 = state
    end,
})

CombatSection:Input({
    Title = "Tên Tool",
    Placeholder = "Nhập tên Tool1...",
    Value = "Tool1",
    Callback = function(val)
        getgenv().Config.ToolName = val
    end,
})

-- */ Notify /* --
WindUI:Notify({
    Title = "VTD Hub",
    Content = "Script đã sẵn sàng!",
    Duration = 5
})
