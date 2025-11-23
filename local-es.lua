local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- Default values
local SavedSpeed = 16
local SavedJump = 50

local function GetHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = SavedSpeed
    humanoid.JumpPower = SavedJump

    return humanoid
end

local humanoid = GetHumanoid()

player.CharacterAdded:Connect(function()
    humanoid = GetHumanoid()
end)

------------------------------------------------------------
-- Window
------------------------------------------------------------

local Window = Rayfield:CreateWindow({
    Name = "ALL Game Version 1.1",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By 🦌 Team Dear",
    ConfigurationSaving = false
})

-- 🎨 Theme system
local CurrentTheme = 1

local Themes = {
    -- Theme 1: Cyberpunk (Purple & Pink)
    [1] = {
        name = "Cyberpunk",
        TextColor = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(20, 10, 30),
        Topbar = Color3.fromRGB(40, 20, 60),
        Shadow = Color3.fromRGB(10, 5, 15),
        NotificationBackground = Color3.fromRGB(30, 15, 45),
        NotificationActionsBackground = Color3.fromRGB(255, 100, 200),
        TabBackground = Color3.fromRGB(80, 40, 120),
        TabStroke = Color3.fromRGB(120, 60, 180),
        TabBackgroundSelected = Color3.fromRGB(200, 100, 255),
        TabTextColor = Color3.fromRGB(255, 255, 255),
        SelectedTabTextColor = Color3.fromRGB(20, 10, 30),
        ElementBackground = Color3.fromRGB(35, 20, 50),
        ElementBackgroundHover = Color3.fromRGB(50, 30, 70),
        SecondaryElementBackground = Color3.fromRGB(25, 15, 40),
        ElementStroke = Color3.fromRGB(100, 50, 150),
        SecondaryElementStroke = Color3.fromRGB(80, 40, 120),
        SliderBackground = Color3.fromRGB(150, 50, 200),
        SliderProgress = Color3.fromRGB(200, 100, 255),
        SliderStroke = Color3.fromRGB(255, 150, 255),
        ToggleBackground = Color3.fromRGB(30, 15, 45),
        ToggleEnabled = Color3.fromRGB(200, 50, 255),
        ToggleDisabled = Color3.fromRGB(80, 40, 100),
        ToggleEnabledStroke = Color3.fromRGB(255, 100, 255),
        ToggleDisabledStroke = Color3.fromRGB(100, 50, 120),
        ToggleEnabledOuterStroke = Color3.fromRGB(150, 75, 180),
        ToggleDisabledOuterStroke = Color3.fromRGB(60, 30, 80),
        DropdownSelected = Color3.fromRGB(50, 30, 70),
        DropdownUnselected = Color3.fromRGB(30, 15, 45),
        InputBackground = Color3.fromRGB(30, 15, 45),
        InputStroke = Color3.fromRGB(120, 60, 180),
        PlaceholderColor = Color3.fromRGB(200, 150, 255)
    },

    -- Theme 2: Ocean Blue
    [2] = {
        name = "Ocean Blue",
        TextColor = Color3.fromRGB(240, 250, 255),
        Background = Color3.fromRGB(10, 25, 35),
        Topbar = Color3.fromRGB(15, 40, 55),
        Shadow = Color3.fromRGB(5, 15, 25),
        NotificationBackground = Color3.fromRGB(15, 35, 50),
        NotificationActionsBackground = Color3.fromRGB(100, 200, 255),
        TabBackground = Color3.fromRGB(30, 70, 100),
        TabStroke = Color3.fromRGB(50, 120, 160),
        TabBackgroundSelected = Color3.fromRGB(100, 200, 255),
        TabTextColor = Color3.fromRGB(240, 250, 255),
        SelectedTabTextColor = Color3.fromRGB(10, 25, 35),
        ElementBackground = Color3.fromRGB(20, 45, 65),
        ElementBackgroundHover = Color3.fromRGB(30, 60, 85),
        SecondaryElementBackground = Color3.fromRGB(15, 35, 50),
        ElementStroke = Color3.fromRGB(40, 100, 140),
        SecondaryElementStroke = Color3.fromRGB(30, 70, 100),
        SliderBackground = Color3.fromRGB(50, 150, 200),
        SliderProgress = Color3.fromRGB(100, 200, 255),
        SliderStroke = Color3.fromRGB(150, 220, 255),
        ToggleBackground = Color3.fromRGB(15, 35, 50),
        ToggleEnabled = Color3.fromRGB(0, 180, 255),
        ToggleDisabled = Color3.fromRGB(50, 80, 100),
        ToggleEnabledStroke = Color3.fromRGB(100, 220, 255),
        ToggleDisabledStroke = Color3.fromRGB(70, 100, 120),
        ToggleEnabledOuterStroke = Color3.fromRGB(80, 140, 180),
        ToggleDisabledOuterStroke = Color3.fromRGB(40, 60, 80),
        DropdownSelected = Color3.fromRGB(30, 60, 85),
        DropdownUnselected = Color3.fromRGB(15, 35, 50),
        InputBackground = Color3.fromRGB(15, 35, 50),
        InputStroke = Color3.fromRGB(50, 120, 160),
        PlaceholderColor = Color3.fromRGB(150, 200, 230)
    },

    -- Theme 3: Sunset
    [3] = {
        name = "Sunset",
        TextColor = Color3.fromRGB(255, 250, 240),
        Background = Color3.fromRGB(30, 15, 10),
        Topbar = Color3.fromRGB(50, 25, 15),
        Shadow = Color3.fromRGB(20, 10, 5),
        NotificationBackground = Color3.fromRGB(40, 20, 10),
        NotificationActionsBackground = Color3.fromRGB(255, 150, 80),
        TabBackground = Color3.fromRGB(100, 50, 30),
        TabStroke = Color3.fromRGB(150, 80, 50),
        TabBackgroundSelected = Color3.fromRGB(255, 150, 80),
        TabTextColor = Color3.fromRGB(255, 250, 240),
        SelectedTabTextColor = Color3.fromRGB(30, 15, 10),
        ElementBackground = Color3.fromRGB(45, 25, 15),
        ElementBackgroundHover = Color3.fromRGB(60, 35, 20),
        SecondaryElementBackground = Color3.fromRGB(35, 20, 10),
        ElementStroke = Color3.fromRGB(120, 60, 30),
        SecondaryElementStroke = Color3.fromRGB(90, 45, 25),
        SliderBackground = Color3.fromRGB(200, 100, 50),
        SliderProgress = Color3.fromRGB(255, 150, 80),
        SliderStroke = Color3.fromRGB(255, 180, 120),
        ToggleBackground = Color3.fromRGB(40, 20, 10),
        ToggleEnabled = Color3.fromRGB(255, 120, 50),
        ToggleDisabled = Color3.fromRGB(80, 50, 30),
        ToggleEnabledStroke = Color3.fromRGB(255, 160, 100),
        ToggleDisabledStroke = Color3.fromRGB(100, 60, 40),
        ToggleEnabledOuterStroke = Color3.fromRGB(150, 80, 50),
        ToggleDisabledOuterStroke = Color3.fromRGB(60, 35, 20),
        DropdownSelected = Color3.fromRGB(60, 35, 20),
        DropdownUnselected = Color3.fromRGB(40, 20, 10),
        InputBackground = Color3.fromRGB(40, 20, 10),
        InputStroke = Color3.fromRGB(150, 80, 50),
        PlaceholderColor = Color3.fromRGB(200, 150, 120)
    },

    -- Theme 4: Green Forest
    [4] = {
        name = "Green Forest",
        TextColor = Color3.fromRGB(240, 255, 245),
        Background = Color3.fromRGB(10, 25, 15),
        Topbar = Color3.fromRGB(15, 40, 25),
        Shadow = Color3.fromRGB(5, 15, 10),
        NotificationBackground = Color3.fromRGB(15, 35, 25),
        NotificationActionsBackground = Color3.fromRGB(100, 255, 150),
        TabBackground = Color3.fromRGB(30, 80, 50),
        TabStroke = Color3.fromRGB(50, 130, 80),
        TabBackgroundSelected = Color3.fromRGB(100, 255, 150),
        TabTextColor = Color3.fromRGB(240, 255, 245),
        SelectedTabTextColor = Color3.fromRGB(10, 25, 15),
        ElementBackground = Color3.fromRGB(20, 45, 30),
        ElementBackgroundHover = Color3.fromRGB(30, 60, 40),
        SecondaryElementBackground = Color3.fromRGB(15, 35, 25),
        ElementStroke = Color3.fromRGB(40, 100, 60),
        SecondaryElementStroke = Color3.fromRGB(30, 70, 45),
        SliderBackground = Color3.fromRGB(50, 180, 100),
        SliderProgress = Color3.fromRGB(100, 255, 150),
        SliderStroke = Color3.fromRGB(150, 255, 200),
        ToggleBackground = Color3.fromRGB(15, 35, 25),
        ToggleEnabled = Color3.fromRGB(0, 220, 120),
        ToggleDisabled = Color3.fromRGB(50, 80, 60),
        ToggleEnabledStroke = Color3.fromRGB(100, 255, 170),
        ToggleDisabledStroke = Color3.fromRGB(70, 100, 80),
        ToggleEnabledOuterStroke = Color3.fromRGB(80, 150, 110),
        ToggleDisabledOuterStroke = Color3.fromRGB(40, 60, 50),
        DropdownSelected = Color3.fromRGB(30, 60, 40),
        DropdownUnselected = Color3.fromRGB(15, 35, 25),
        InputBackground = Color3.fromRGB(15, 35, 25),
        InputStroke = Color3.fromRGB(50, 130, 80),
        PlaceholderColor = Color3.fromRGB(150, 230, 180)
    },

    -- Theme 5: Royal Gold
    [5] = {
        name = "Royal Gold",
        TextColor = Color3.fromRGB(255, 240, 200),
        Background = Color3.fromRGB(15, 15, 15),
        Topbar = Color3.fromRGB(25, 25, 25),
        Shadow = Color3.fromRGB(10, 10, 10),
        NotificationBackground = Color3.fromRGB(20, 20, 20),
        NotificationActionsBackground = Color3.fromRGB(255, 215, 100),
        TabBackground = Color3.fromRGB(60, 50, 30),
        TabStroke = Color3.fromRGB(120, 100, 50),
        TabBackgroundSelected = Color3.fromRGB(255, 215, 100),
        TabTextColor = Color3.fromRGB(255, 240, 200),
        SelectedTabTextColor = Color3.fromRGB(15, 15, 15),
        ElementBackground = Color3.fromRGB(30, 30, 30),
        ElementBackgroundHover = Color3.fromRGB(40, 40, 35),
        SecondaryElementBackground = Color3.fromRGB(20, 20, 20),
        ElementStroke = Color3.fromRGB(100, 85, 40),
        SecondaryElementStroke = Color3.fromRGB(70, 60, 30),
        SliderBackground = Color3.fromRGB(180, 150, 70),
        SliderProgress = Color3.fromRGB(255, 215, 100),
        SliderStroke = Color3.fromRGB(255, 235, 150),
        ToggleBackground = Color3.fromRGB(20, 20, 20),
        ToggleEnabled = Color3.fromRGB(255, 200, 50),
        ToggleDisabled = Color3.fromRGB(80, 70, 50),
        ToggleEnabledStroke = Color3.fromRGB(255, 225, 120),
        ToggleDisabledStroke = Color3.fromRGB(100, 85, 60),
        ToggleEnabledOuterStroke = Color3.fromRGB(150, 130, 70),
        ToggleDisabledOuterStroke = Color3.fromRGB(50, 45, 35),
        DropdownSelected = Color3.fromRGB(40, 40, 35),
        DropdownUnselected = Color3.fromRGB(20, 20, 20),
        InputBackground = Color3.fromRGB(20, 20, 20),
        InputStroke = Color3.fromRGB(120, 100, 50),
        PlaceholderColor = Color3.fromRGB(200, 180, 130)
    }
}

local function ApplyTheme(themeIndex)
    CurrentTheme = themeIndex
    Window.ModifyTheme(Themes[themeIndex])
    Rayfield:Notify({
        Title = "Theme Changed",
        Content = "Changed to " .. Themes[themeIndex].name,
        Duration = 2
    })
end

-- Apply default theme
Window.ModifyTheme(Themes[CurrentTheme])

------------------------------------------------------------
-- Home Tab
------------------------------------------------------------
local HomeTab = Window:CreateTab("Home", "home")

HomeTab:CreateLabel("Hello " .. player.Name .. "!")
HomeTab:CreateLabel("Welcome to ALL Game")
HomeTab:CreateLabel("Version 1.1")

HomeTab:CreateButton({
    Name = "Teleport to New Game",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
})

------------------------------------------------------------
-- Player Tab
------------------------------------------------------------

local PlayerTab = Window:CreateTab("Player", "scan-eye")

WalkSlider = PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {0, 999},
    Increment = 1,
    CurrentValue = SavedSpeed,
    Callback = function(value)
        SavedSpeed = value
        humanoid.WalkSpeed = value
    end
})

PlayerTab:CreateButton({
    Name = "Reset Walk Speed",
    Callback = function()
        SavedSpeed = 16
        humanoid.WalkSpeed = 16
        WalkSlider:Set(16)

        Rayfield:Notify({
            Title = "Reset",
            Content = "Walk speed reset to 16",
            Duration = 2
        })
    end
})

JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {0, 999},
    Increment = 1,
    CurrentValue = SavedJump,
    Callback = function(value)
        SavedJump = value
        humanoid.JumpPower = value
    end
})

PlayerTab:CreateButton({
    Name = "Reset Jump Power",
    Callback = function()
        SavedJump = 50
        humanoid.JumpPower = 50
        JumpSlider:Set(50)

        Rayfield:Notify({
            Title = "Reset",
            Content = "Jump power reset to 50",
            Duration = 2
        })
    end
})

------------------------------------------------------------
-- Hub Tab
------------------------------------------------------------

local HubTab = Window:CreateTab("Hub","library-big")

-- ⭐ Scripts stored directly in code
local AllScripts = {
    ["1"] = {
        name = "Noclip",
        script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Angapo/repo/refs/heads/main/Noclipgui.lua'))()]]
    },
    ["2"] = {
        name = "ESP",
        script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Angapo/repo/refs/heads/main/esp.lua'))()]]
    },
    -- Add more scripts here
}

for id, info in pairs(AllScripts) do
    HubTab:CreateButton({
        Name = info.name or tostring(id),
        Callback = function()
            if info.script then
                local success, err = pcall(function()
                    loadstring(info.script)()
                end)
                
                if success then
                    Rayfield:Notify({
                        Title = "Running Script",
                        Content = "Running: " .. (info.name or tostring(id)),
                        Duration = 2
                    })
                else
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Failed to run script",
                        Duration = 3
                    })
                end
            end
        end
    })
end

------------------------------------------------------------
-- R6 troll
------------------------------------------------------------

local HubTab = Window:CreateTab("R6 troll","lollipop")

-- ⭐ Scripts stored directly in code
local AllScripts = {
    ["1"] = {
        name = "jerk off - tool",
        script = [[loadstring(game:HttpGet('https://pastefy.app/slawnvcTT/raw'))()]]
    },
    ["2"] = {
        name = "FE Animation GUI",
        script = [[loadstring(game:HttpGet('https://github.com/Angapo/repo/raw/refs/heads/main/r6-troll/FE-Animation-GUI.lua'))()]]
    },
    -- Add more scripts here
}

for id, info in pairs(AllScripts) do
    HubTab:CreateButton({
        Name = info.name or tostring(id),
        Callback = function()
            if info.script then
                local success, err = pcall(function()
                    loadstring(info.script)()
                end)
                
                if success then
                    Rayfield:Notify({
                        Title = "Running Script",
                        Content = "Running: " .. (info.name or tostring(id)),
                        Duration = 2
                    })
                else
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Failed to run script",
                        Duration = 3
                    })
                end
            end
        end
    })
end

------------------------------------------------------------
-- R15 troll
------------------------------------------------------------

local HubTab = Window:CreateTab("R15 troll","lollipop")

-- ⭐ Scripts stored directly in code
local AllScripts = {
    ["1"] = {
        name = "jerk off - tool",
        script = [[loadstring(game:HttpGet('https://pastefy.app/YZoglOyJ/raw'))()]]
    },
    ["2"] = {
        name = "ESP",
        script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Angapo/repo/refs/heads/main/esp.lua'))()]]
    },
    -- Add more scripts here
}

for id, info in pairs(AllScripts) do
    HubTab:CreateButton({
        Name = info.name or tostring(id),
        Callback = function()
            if info.script then
                local success, err = pcall(function()
                    loadstring(info.script)()
                end)
                
                if success then
                    Rayfield:Notify({
                        Title = "Running Script",
                        Content = "Running: " .. (info.name or tostring(id)),
                        Duration = 2
                    })
                else
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Failed to run script",
                        Duration = 3
                    })
                end
            end
        end
    })
end

------------------------------------------------------------
-- Info Tab
------------------------------------------------------------

local InfoTab = Window:CreateTab("Info", "badge-info")

InfoTab:CreateLabel("Game Name: " .. game.Name)
InfoTab:CreateLabel("Game ID: " .. tostring(game.PlaceId))
InfoTab:CreateLabel("Player Name: " .. player.Name)
InfoTab:CreateLabel("Player ID: " .. tostring(player.UserId))

------------------------------------------------------------
-- Settings Tab
------------------------------------------------------------

local SettingsTab = Window:CreateTab("Settings", "settings")

SettingsTab:CreateLabel("🎨 Theme Settings")

SettingsTab:CreateButton({
    Name = "💜 Cyberpunk (Purple & Pink)",
    Callback = function()
        ApplyTheme(1)
    end
})

SettingsTab:CreateButton({
    Name = "🌊 Ocean Blue",
    Callback = function()
        ApplyTheme(2)
    end
})

SettingsTab:CreateButton({
    Name = "🌅 Sunset",
    Callback = function()
        ApplyTheme(3)
    end
})

SettingsTab:CreateButton({
    Name = "🌲 Green Forest",
    Callback = function()
        ApplyTheme(4)
    end
})

SettingsTab:CreateButton({
    Name = "👑 Royal Gold",
    Callback = function()
        ApplyTheme(5)
    end
})
