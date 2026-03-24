local RunService = game:GetService("RunService")
local cloneref = (cloneref or clonereference or function(instance) return instance end)

-- */ Tải Thư Viện WindUI /* --
local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    if ok then
        WindUI = result
    else
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end
end

-- */ Khởi Tạo Cửa Sổ /* --
local Window = WindUI:CreateWindow({
    Title = "VTD HUB | Hitbox & Combat",
    Folder = "VTDSettings",
    Icon = "solar:shield-warning-bold",
    OpenButton = {
        Title = "Mở Menu",
        Enabled = true,
        Draggable = true,
    }
})

-- */ Biến Cấu Hình /* --
getgenv().Config = {
    HitboxActive = false,
    HitboxSize = 10,
    AutoM1 = false,
    ToolName = "Tool1" -- Đặt tên Tool của bạn ở đây
}

-- */ Logic Hitbox & Auto M1 /* --
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Config.HitboxActive then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(getgenv().Config.HitboxSize, getgenv().Config.HitboxSize, getgenv().Config.HitboxSize)
                    hrp.Transparency = 0.7
                    hrp.BrickColor = BrickColor.new("Really blue")
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.AutoM1 then
            local lp = game.Players.LocalPlayer
            local tool = lp.Character:FindFirstChild(getgenv().Config.ToolName) or lp.Backpack:FindFirstChild(getgenv().Config.ToolName)
            
            if tool then
                -- Kiểm tra khoảng cách với mục tiêu gần nhất
                for _, target in ipairs(game.Players:GetPlayers()) do
                    if target ~= lp and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (lp.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                        -- Nếu hitbox chụm lại (khoảng cách gần) thì tự động đánh
                        if distance < (getgenv().Config.HitboxSize / 2 + 3) then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)

-- */ Giao Diện Người Dùng (Tabs) /* --
local MainTab = Window:Tab({
    Title = "Chiến Đấu",
    Icon = "solar:fire-bold",
})

local CombatSection = MainTab:Section({ Title = "Tính Năng Hitbox" })

CombatSection:Toggle({
    Title = "Bật Hitbox Lớn",
    Value = false,
    Callback = function(state)
        getgenv().Config.HitboxActive = state
        if not state then
            -- Reset lại hitbox khi tắt
            for _, p in pairs(game.Players:GetPlayers()) do
                pcall(function() p.Character.HumanoidRootPart.Size = Vector3.new(2,2,1) end)
            end
        end
    end,
})

CombatSection:Slider({
    Title = "Kích Thước Hitbox",
    Step = 1,
    Value = { Min = 2, Max = 50, Default = 10 },
    Callback = function(val)
        getgenv().Config.HitboxSize = val
    end,
})

CombatSection:Toggle({
    Title = "Auto M1 (Khi gần Hitbox)",
    Value = false,
    Callback = function(state)
        getgenv().Config.AutoM1 = state
    end,
})

-- */ Thông báo /* --
WindUI:Notify({
    Title = "Hệ Thống",
    Content = "Script đã tải thành công!",
    Duration = 3
})
