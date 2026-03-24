local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- */ BẢNG SETTING CỦA BẠN /* --
getgenv().Setting = {
    ["Team"] = "Pirates",
    ["Chat"] = {},
    ["Skip Race V4"] = true,
    ["Misc"] = {
        ["Enable Lock Bounty"] = false,
        ["Lock Bounty"] = {0, 300000000},
        ["Lock Camera"] = true,
        ["Enable Cam Farm"] = false,
        ["White Screen"] = false,
        ["FPS Boost"] = false,
        ["Random & Store Fruit"] = true
    },
    ["Item"] = {
        ["Melee"] = {["Enable"] = true, ["Z"] = {["Enable"] = true, ["Hold Time"] = 1}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0}, ["C"] = {["Enable"] = true, ["Hold Time"] = 0}},
        ["Blox Fruit"] = {["Enable"] = false, ["Z"] = {["Enable"] = true, ["Hold Time"] = 1.5}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0}, ["C"] = {["Enable"] = true, ["Hold Time"] = 0}, ["V"] = {["Enable"] = true, ["Hold Time"] = 0}, ["F"] = {["Enable"] = true, ["Hold Time"] = 0}},
        ["Sword"] = {["Enable"] = true, ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.3}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0.2}},
        ["Gun"] = {["Enable"] = false, ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.5}, ["X"] = {["Enable"] = true, ["Hold Time"] = 0.3}}
    }
}

-- */ KHỞI TẠO WINDOW /* --
local Window = WindUI:CreateWindow({
    Title = "VTD PREMIUM | WindUI",
    Icon = "solar:bolt-circle-bold",
    Folder = "VTD_Hub",
    OpenButton = {
        Enabled = true,
        Draggable = true,
    },
})

-- */ BIẾN HỖ TRỢ /* --
local SelectedPlayer = ""
local TargetDropdown

-- */ HÀM TỰ ĐỘNG CẦM VŨ KHÍ /* --
local function AutoEquip(category)
    local lp = game.Players.LocalPlayer
    for _, tool in pairs(lp.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == category or tool.Name:find(category)) then
            lp.Character.Humanoid:EquipTool(tool)
            return true
        end
    end
    return lp.Character:FindFirstChildOfClass("Tool") ~= nil
end

-- */ HÀM SPAM CHIÊU /* --
local function PressKey(key, holdTime)
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, key, false, game)
    if holdTime > 0 then task.wait(holdTime) end
    vim:SendKeyEvent(false, key, false, game)
end

-- */ TAB CHIẾN ĐẤU /* --
local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "solar:swords-bold",
})

local HuntSection = CombatTab:Section({ Title = "Player Hunter" })

-- Dropdown chọn người chơi
TargetDropdown = HuntSection:Dropdown({
    Title = "Chọn mục tiêu",
    Values = (function()
        local tbl = {}
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then table.insert(tbl, v.Name) end
        end
        return tbl
    end)(),
    Callback = function(val) SelectedPlayer = val end
})

-- Nút làm mới danh sách
HuntSection:Button({
    Title = "Làm mới danh sách",
    Icon = "solar:refresh-bold",
    Callback = function()
        local newList = {}
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer then table.insert(newList, v.Name) end
        end
        TargetDropdown:Refresh(newList)
    end
})

-- Toggle Bay đến + Spam
HuntSection:Toggle({
    Title = "Bay đến + Spam Tool & Skill",
    Value = false,
    Callback = function(state)
        _G.AutoKill = state
        task.spawn(function()
            while _G.AutoKill do
                pcall(function()
                    local target = game.Players:FindFirstChild(SelectedPlayer)
                    local lp = game.Players.LocalPlayer
                    if target and target.Character and lp.Character then
                        -- Bay đến
                        lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        
                        -- Thực hiện hành động theo Setting
                        for cat, conf in pairs(getgenv().Setting.Item) do
                            if conf.Enable then
                                AutoEquip(cat)
                                -- Spam 1-4
                                for i=1,4 do 
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, tostring(i), false, game)
                                    task.wait(0.01)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, tostring(i), false, game)
                                end
                                -- Spam Skills
                                for _, key in pairs({"Z","X","C","V","F"}) do
                                    if conf[key] and conf[key].Enable then
                                        PressKey(key, conf[key]["Hold Time"])
                                    end
                                end
                                -- Click
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,true,game,0)
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,false,game,0)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

-- */ TAB HỆ THỐNG /* --
local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "solar:settings-bold",
})

MiscTab:Toggle({
    Title = "FPS Boost",
    Value = getgenv().Setting.Misc["FPS Boost"],
    Callback = function(v) getgenv().Setting.Misc["FPS Boost"] = v end
})

MiscTab:Button({
    Title = "Destroy UI",
    Icon = "solar:trash-bin-trash-bold",
    Callback = function() Window:Destroy() end
})

-- Thông báo khi load xong
WindUI:Notify({
    Title = "VTD Hub Loaded",
    Content = "Sử dụng Menu để bắt đầu đi săn!",
    Duration = 5
})
