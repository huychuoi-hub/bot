local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Bảng Setting của bạn
getgenv().Setting = {
    ["Item"] = {
        ["Melee"] = {["Enable"] = true, ["Z"] = {["Enable"] = true, ["Hold Time"] = 1}, ["X"] = {["Enable"] = true, ["Hold Size"] = 0}, ["C"] = {["Enable"] = true, ["Hold Time"] = 0}},
        ["Sword"] = {["Enable"] = true, ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.3}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0.2}},
    }
}

local Window = WindUI:CreateWindow({
    Title = "VTD ULTRA FIX | AUTO COMBAT",
    Icon = "solar:bolt-circle-bold",
    Folder = "VTD_Hub",
    Size = UDim2.fromOffset(500, 400),
    OpenButton = { Enabled = true, Draggable = true },
})

local CombatTab = Window:Tab({ Title = "Combat", Icon = "solar:swords-bold" })
local HuntSection = CombatTab:Section({ Title = "Điều Khiển", Opened = true })

local SelectedPlayer = ""
local vim = game:GetService("VirtualInputManager")

-- HÀM ÉP CẦM TOOL (FIX LỖI KHÔNG CẦM)
local function ForceEquip()
    local lp = game.Players.LocalPlayer
    if not lp.Character:FindFirstChildOfClass("Tool") then
        local tool = lp.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            lp.Character.Humanoid:EquipTool(tool)
            task.wait(0.1) -- Đợi 1 chút để game nhận diện đã cầm đồ
        end
    end
end

-- HÀM NHẤN PHÍM CỰC MẠNH
local function ForceKey(key, hold)
    vim:SendKeyEvent(true, key, false, game)
    if hold and hold > 0 then task.wait(hold) end
    vim:SendKeyEvent(false, key, false, game)
end

-- UI
HuntSection:Toggle({
    Title = "BẬT TRUY ĐUỔI + SPAM TẤT CẢ",
    Value = false,
    Callback = function(state)
        _G.AutoKill = state
        if state then
            task.spawn(function()
                while _G.AutoKill do
                    pcall(function()
                        local target = game.Players:FindFirstChild(SelectedPlayer)
                        local lp = game.Players.LocalPlayer
                        
                        if target and target.Character and lp.Character then
                            -- 1. Dính chặt vào mục tiêu
                            lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            
                            -- 2. Kiểm tra và cầm Tool ngay lập tức
                            ForceEquip()
                            
                            -- 3. Click chuột trái (Đánh thường)
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)

                            -- 4. Spam phím 1-2-3-4 để đổi vũ khí liên tục
                            for i = 1, 4 do
                                ForceKey(tostring(i), 0)
                            end

                            -- 5. Spam chiêu theo Setting của bạn
                            for cat, conf in pairs(getgenv().Setting.Item) do
                                if conf.Enable then
                                    for _, key in pairs({"Z", "X", "C", "V"}) do
                                        if conf[key] and conf[key].Enable then
                                            ForceKey(key, conf[key]["Hold Time"])
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.05) -- Tốc độ cực nhanh
                end
            end)
        end
    end
})

local TargetDropdown = HuntSection:Dropdown({
    Title = "Chọn mục tiêu",
    Values = (function()
        local t = {}
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then table.insert(t, v.Name) end
        end
        return t
    end)(),
    Callback = function(v) SelectedPlayer = v end
})

HuntSection:Button({
    Title = "Làm mới danh sách",
    Callback = function()
        local t = {}
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then table.insert(t, v.Name) end
        end
        TargetDropdown:Refresh(t)
    end
})
