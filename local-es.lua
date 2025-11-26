local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

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
-- Window Creation
------------------------------------------------------------

local Window = Fluent:CreateWindow({
    Title = "ALL Game Hub " .. Fluent.Version,
    SubTitle = "by 🦌 Team Dear",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "home" }),
    FE = Window:AddTab({ Title = "FE Scripts", Icon = "zap" }),
    Admin = Window:AddTab({ Title = "Admin", Icon = "shield" }),
    Hub = Window:AddTab({ Title = "Hub", Icon = "box" }),
    R6Troll = Window:AddTab({ Title = "R6 Troll", Icon = "smile" }),
    R15Troll = Window:AddTab({ Title = "R15 Troll", Icon = "smile" }),
    SaveScripts = Window:AddTab({ Title = "Save Scripts", Icon = "save" }),
    DeleteScripts = Window:AddTab({ Title = "Delete Scripts", Icon = "trash-2" }),
    Info = Window:AddTab({ Title = "Info", Icon = "info" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

------------------------------------------------------------
-- Script Storage System
------------------------------------------------------------

local ScriptCategories = {
    FE = {},
    Admin = {},
    Hub = {},
    R6Troll = {},
    R15Troll = {}
}

local SaveFileName = "FluentScriptHub_" .. tostring(game.PlaceId) .. ".json"

local function SaveScriptData()
    local success, result = pcall(function()
        if writefile then
            writefile(SaveFileName, HttpService:JSONEncode(ScriptCategories))
        end
    end)
    if not success then
        print("Failed to save scripts:", result)
    end
end

local function LoadScriptData()
    local success, result = pcall(function()
        if isfile and readfile and isfile(SaveFileName) then
            local data = HttpService:JSONDecode(readfile(SaveFileName))
            if data then
                ScriptCategories = data
                return true
            end
        end
        return false
    end)
    return success and result
end

local function ExecuteScript(scriptCode, scriptName)
    local success, err = pcall(function()
        loadstring(scriptCode)()
    end)
    
    if success then
        Fluent:Notify({
            Title = "Running Script",
            Content = "Running: " .. scriptName,
            Duration = 2
        })
    else
        Fluent:Notify({
            Title = "Error",
            Content = "Failed: " .. tostring(err),
            Duration = 3
        })
    end
end

local function AddScriptToCategory(category, name, desc, script)
    table.insert(ScriptCategories[category], {
        name = name,
        desc = desc,
        script = script
    })
    SaveScriptData()
end

local function RemoveScriptFromCategory(category, index)
    table.remove(ScriptCategories[category], index)
    SaveScriptData()
end

local function CreateScriptButton(tab, name, desc, script)
    tab:AddButton({
        Title = name,
        Description = desc or "Click to execute",
        Callback = function()
            ExecuteScript(script, name)
        end
    })
end

------------------------------------------------------------
-- Load saved data first
------------------------------------------------------------
local dataLoaded = LoadScriptData()

-- Initialize with default scripts if no data loaded
if not dataLoaded or #ScriptCategories.FE == 0 then
    ScriptCategories.FE = {
        {
            name = "Coolkid GUI",
            desc = "FE GUI with multiple features",
            script = [[loadstring(game:HttpGet('https://github.com/Angapo/repo/raw/refs/heads/main/hub/coolkid.lua'))()]]
        },
        {
            name = "FE Ultimate Trolling GUI",
            desc = "Ultimate trolling script",
            script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Angapo/repo/refs/heads/main/hub/FE%20Ultimate%20Trolling%20GUI%20Script.lua'))()]]
        }
    }
end

if not dataLoaded or #ScriptCategories.Admin == 0 then
    ScriptCategories.Admin = {
        {
            name = "Infinite Yield",
            desc = "Popular admin commands",
            script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source'))()]]
        },
        {
            name = "CMD Admin Script",
            desc = "Advanced command system",
            script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/lxte/cmd/main/main.lua'))()]]
        }
    }
end

if not dataLoaded or #ScriptCategories.Hub == 0 then
    ScriptCategories.Hub = {
        {
            name = "Noclip",
            desc = "Walk through walls",
            script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Angapo/repo/refs/heads/main/Noclipgui.lua'))()]]
        },
        {
            name = "ESP",
            desc = "See players through walls",
            script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Angapo/repo/refs/heads/main/esp.lua'))()]]
        }
    }
end

if not dataLoaded or #ScriptCategories.R6Troll == 0 then
    ScriptCategories.R6Troll = {
        {
            name = "Jerk Off Tool",
            desc = "R6 animation tool",
            script = [[loadstring(game:HttpGet('https://pastefy.app/slawnvcTT/raw'))()]]
        },
        {
            name = "FE Animation GUI",
            desc = "R6 animation player",
            script = [[loadstring(game:HttpGet('https://github.com/Angapo/repo/raw/refs/heads/main/r6-troll/FE-Animation-GUI.lua'))()]]
        }
    }
end

if not dataLoaded or #ScriptCategories.R15Troll == 0 then
    ScriptCategories.R15Troll = {
        {
            name = "Jerk Off Tool",
            desc = "R15 animation tool",
            script = [[loadstring(game:HttpGet('https://pastefy.app/YZoglOyJ/raw'))()]]
        },
        {
            name = "FE R15 Animation Player",
            desc = "R15 animation player",
            script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Angapo/repo/refs/heads/main/r15-troll/FE-R15-Animation-Player.lua'))()]]
        }
    }
end

SaveScriptData()

------------------------------------------------------------
-- Home Tab
------------------------------------------------------------

Tabs.Home:AddParagraph({
    Title = "Welcome!",
    Content = "Hello " .. player.Name .. "!\nWelcome to ALL Game Hub v2.0"
})

Tabs.Home:AddParagraph({
    Title = "Features",
    Content = "• All scripts are auto-saved\n• Save custom scripts to any tab\n• Delete scripts with confirmation\n• Clean and organized interface"
})

Tabs.Home:AddButton({
    Title = "Rejoin Server",
    Description = "Teleport back to current server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
})

Tabs.Home:AddButton({
    Title = "Convert R15 to R6",
    Description = "Change your character rig",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Angapo/repo/refs/heads/main/hub/r15-r6.lua", true))()
    end
})

------------------------------------------------------------
-- FE Tab
------------------------------------------------------------

Tabs.FE:AddParagraph({
    Title = "FE Scripts",
    Content = "Front-End scripts that work without admin"
})

for index, info in ipairs(ScriptCategories.FE) do
    CreateScriptButton(Tabs.FE, info.name, info.desc, info.script)
end

------------------------------------------------------------
-- Admin Tab
------------------------------------------------------------

Tabs.Admin:AddParagraph({
    Title = "Admin Scripts",
    Content = "Administrative command scripts"
})

for index, info in ipairs(ScriptCategories.Admin) do
    CreateScriptButton(Tabs.Admin, info.name, info.desc, info.script)
end

------------------------------------------------------------
-- Hub Tab
------------------------------------------------------------

Tabs.Hub:AddParagraph({
    Title = "Hub Scripts",
    Content = "General utility scripts"
})

for index, info in ipairs(ScriptCategories.Hub) do
    CreateScriptButton(Tabs.Hub, info.name, info.desc, info.script)
end

------------------------------------------------------------
-- R6 Troll Tab
------------------------------------------------------------

Tabs.R6Troll:AddParagraph({
    Title = "R6 Troll Scripts",
    Content = "Scripts for R6 character rigs"
})

for index, info in ipairs(ScriptCategories.R6Troll) do
    CreateScriptButton(Tabs.R6Troll, info.name, info.desc, info.script)
end

------------------------------------------------------------
-- R15 Troll Tab
------------------------------------------------------------

Tabs.R15Troll:AddParagraph({
    Title = "R15 Troll Scripts",
    Content = "Scripts for R15 character rigs"
})

for index, info in ipairs(ScriptCategories.R15Troll) do
    CreateScriptButton(Tabs.R15Troll, info.name, info.desc, info.script)
end

------------------------------------------------------------
-- Save Scripts Tab (New System)
------------------------------------------------------------

Tabs.SaveScripts:AddParagraph({
    Title = "Save Custom Scripts",
    Content = "Add your own scripts to any category"
})

local SaveScriptName = ""
local SaveScriptDesc = ""
local SaveScriptCode = ""
local SelectedCategory = "FE"

Tabs.SaveScripts:AddInput("SaveName", {
    Title = "Script Name",
    Default = "",
    Placeholder = "Enter script name...",
    Callback = function(value)
        SaveScriptName = value
    end
})

Tabs.SaveScripts:AddInput("SaveDesc", {
    Title = "Description",
    Default = "",
    Placeholder = "Enter description...",
    Callback = function(value)
        SaveScriptDesc = value
    end
})

Tabs.SaveScripts:AddInput("SaveCode", {
    Title = "Script Code",
    Default = "",
    Placeholder = "loadstring(game:HttpGet('URL'))()...",
    Callback = function(value)
        SaveScriptCode = value
    end
})

Tabs.SaveScripts:AddDropdown("CategoryDropdown", {
    Title = "Select Category",
    Values = {"FE", "Admin", "Hub", "R6Troll", "R15Troll"},
    Default = 1,
    Callback = function(value)
        SelectedCategory = value
    end
})

Tabs.SaveScripts:AddButton({
    Title = "Save Script",
    Description = "Add script to selected category",
    Callback = function()
        if SaveScriptName ~= "" and SaveScriptCode ~= "" then
            AddScriptToCategory(SelectedCategory, SaveScriptName, SaveScriptDesc, SaveScriptCode)
            Fluent:Notify({
                Title = "Script Saved",
                Content = "Saved '" .. SaveScriptName .. "' to " .. SelectedCategory .. "\nRejoin to see it in the list",
                Duration = 4
            })
            SaveScriptName = ""
            SaveScriptDesc = ""
            SaveScriptCode = ""
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Please enter script name and code!",
                Duration = 3
            })
        end
    end
})

Tabs.SaveScripts:AddParagraph({
    Title = "Instructions",
    Content = "1. Enter script name\n2. Enter description (optional)\n3. Paste your script code\n4. Select category (FE, Admin, Hub, R6, R15)\n5. Click 'Save Script'\n6. Rejoin to see your script"
})

------------------------------------------------------------
-- Delete Scripts Tab (New)
------------------------------------------------------------

Tabs.DeleteScripts:AddParagraph({
    Title = "Delete Scripts",
    Content = "Remove scripts from any category"
})

-- Function to create delete dialog
local function ShowDeleteConfirmation(categoryName, scriptIndex, scriptName)
    local dialog = Window:Dialog({
        Title = "Confirm Deletion",
        Content = "Are you sure you want to delete '" .. scriptName .. "'?\nThis action cannot be undone.",
        Buttons = {
            {
                Title = "Yes, Delete",
                Callback = function()
                    RemoveScriptFromCategory(categoryName, scriptIndex)
                    Fluent:Notify({
                        Title = "Script Deleted",
                        Content = "Deleted: " .. scriptName .. "\nRejoin to refresh the list",
                        Duration = 3
                    })
                end
            },
            {
                Title = "Cancel",
                Callback = function()
                    Fluent:Notify({
                        Title = "Cancelled",
                        Content = "Script was not deleted",
                        Duration = 2
                    })
                end
            }
        }
    })
end

-- FE Scripts Section
if #ScriptCategories.FE > 0 then
    Tabs.DeleteScripts:AddParagraph({
        Title = "FE Scripts",
        Content = "Click to delete"
    })
    
    for index, info in ipairs(ScriptCategories.FE) do
        Tabs.DeleteScripts:AddButton({
            Title = "🗑️ " .. info.name,
            Description = info.desc or "Click to delete this script",
            Callback = function()
                ShowDeleteConfirmation("FE", index, info.name)
            end
        })
    end
end

-- Admin Scripts Section
if #ScriptCategories.Admin > 0 then
    Tabs.DeleteScripts:AddParagraph({
        Title = "Admin Scripts",
        Content = "Click to delete"
    })
    
    for index, info in ipairs(ScriptCategories.Admin) do
        Tabs.DeleteScripts:AddButton({
            Title = "🗑️ " .. info.name,
            Description = info.desc or "Click to delete this script",
            Callback = function()
                ShowDeleteConfirmation("Admin", index, info.name)
            end
        })
    end
end

-- Hub Scripts Section
if #ScriptCategories.Hub > 0 then
    Tabs.DeleteScripts:AddParagraph({
        Title = "Hub Scripts",
        Content = "Click to delete"
    })
    
    for index, info in ipairs(ScriptCategories.Hub) do
        Tabs.DeleteScripts:AddButton({
            Title = "🗑️ " .. info.name,
            Description = info.desc or "Click to delete this script",
            Callback = function()
                ShowDeleteConfirmation("Hub", index, info.name)
            end
        })
    end
end

-- R6 Scripts Section
if #ScriptCategories.R6Troll > 0 then
    Tabs.DeleteScripts:AddParagraph({
        Title = "R6 Troll Scripts",
        Content = "Click to delete"
    })
    
    for index, info in ipairs(ScriptCategories.R6Troll) do
        Tabs.DeleteScripts:AddButton({
            Title = "🗑️ " .. info.name,
            Description = info.desc or "Click to delete this script",
            Callback = function()
                ShowDeleteConfirmation("R6Troll", index, info.name)
            end
        })
    end
end

-- R15 Scripts Section
if #ScriptCategories.R15Troll > 0 then
    Tabs.DeleteScripts:AddParagraph({
        Title = "R15 Troll Scripts",
        Content = "Click to delete"
    })
    
    for index, info in ipairs(ScriptCategories.R15Troll) do
        Tabs.DeleteScripts:AddButton({
            Title = "🗑️ " .. info.name,
            Description = info.desc or "Click to delete this script",
            Callback = function()
                ShowDeleteConfirmation("R15Troll", index, info.name)
            end
        })
    end
end

------------------------------------------------------------
-- Info Tab
------------------------------------------------------------

Tabs.Info:AddParagraph({
    Title = "Game Information",
    Content = string.format(
        "Game Name: %s\nGame ID: %d\nPlayer Name: %s\nPlayer ID: %d",
        game.Name,
        game.PlaceId,
        player.Name,
        player.UserId
    )
})

Tabs.Info:AddParagraph({
    Title = "Script Statistics",
    Content = string.format(
        "FE Scripts: %d\nAdmin Scripts: %d\nHub Scripts: %d\nR6 Scripts: %d\nR15 Scripts: %d\n\nTotal Scripts: %d",
        #ScriptCategories.FE,
        #ScriptCategories.Admin,
        #ScriptCategories.Hub,
        #ScriptCategories.R6Troll,
        #ScriptCategories.R15Troll,
        #ScriptCategories.FE + #ScriptCategories.Admin + #ScriptCategories.Hub + 
        #ScriptCategories.R6Troll + #ScriptCategories.R15Troll
    )
})

------------------------------------------------------------
-- Settings Tab
------------------------------------------------------------

local Themes = {
    "Dark",
    "Darker",
    "Light",
    "Rose",
    "Aqua"
}

Tabs.Settings:AddDropdown("ThemeDropdown", {
    Title = "UI Theme",
    Values = Themes,
    Default = 2,
    Callback = function(value)
        Fluent:SetTheme(value)
    end
})

Tabs.Settings:AddToggle("AcrylicToggle", {
    Title = "Acrylic Blur",
    Default = true,
    Callback = function(value)
        Window:SetAcrylic(value)
    end
})

Tabs.Settings:AddToggle("TransparencyToggle", {
    Title = "Window Transparency",
    Default = false,
    Callback = function(value)
        Window:SetTransparency(value and 0.5 or 1)
    end
})

Tabs.Settings:AddButton({
    Title = "Clear All Scripts",
    Description = "Delete all saved scripts (requires rejoin)",
    Callback = function()
        local dialog = Window:Dialog({
            Title = "Clear All Scripts",
            Content = "Are you sure you want to delete ALL scripts?\nThis will remove all custom scripts you've added.\nDefault scripts will be restored.",
            Buttons = {
                {
                    Title = "Yes, Clear All",
                    Callback = function()
                        ScriptCategories = {
                            FE = {},
                            Admin = {},
                            Hub = {},
                            R6Troll = {},
                            R15Troll = {}
                        }
                        SaveScriptData()
                        Fluent:Notify({
                            Title = "Scripts Cleared",
                            Content = "All scripts deleted. Rejoin to restore defaults.",
                            Duration = 5
                        })
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        Fluent:Notify({
                            Title = "Cancelled",
                            Content = "Scripts were not deleted",
                            Duration = 2
                        })
                    end
                }
            }
        })
    end
})

-- Setup SaveManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/configs")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Hub Loaded",
    Content = "ALL Game Hub v2.0 loaded successfully!",
    Duration = 3
})
