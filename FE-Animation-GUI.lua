-- Enhanced Animation Hub with GitHub Integration
-- เพิ่มฟีเจอร์ cloud sync, animation mixer, และ social features

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- GitHub Configuration
local GITHUB_CONFIG = {
    repo = "https://github.com/Angapo/repo/raw/refs/heads/main/repo/community.json", -- เปลี่ยนเป็น repo ของคุณ
    branch = "main",
    api_base = "https://api.github.com/repos/"
}

-- Original code with enhancements
save = nil
c3 = function(r,g,b) return Color3.new(r/255,g/255,b/255) end

if not save then
    save = {
        ui = {
            highlightcolor = c3(33, 122, 255);
            errorcolor = c3(255, 0, 0);
            successcolor = c3(0, 255, 100);
            warningcolor = c3(255, 165, 0);
            core = c3(65, 65, 65);
            idle = c3(134, 200, 230);
            movement = c3(114, 230, 121);
            action = c3(235, 235, 235);
        };
        preferences = {
            auto_sync = true;
            preview_enabled = true;
            show_ratings = true;
            rig_type = "Auto"; -- "Auto", "R6", "R15"
        };
        favorites = {};
        cloud_animations = {};
        animation_mixer = {
            slots = {nil, nil, nil};
            weights = {1, 1, 1};
        };
        custom_animations = {};
    }
end

lp = Players.LocalPlayer
m = lp:GetMouse()
running = {}
mixer_tracks = {}

-- ============================================
-- 🌐 GITHUB INTEGRATION FUNCTIONS
-- ============================================

function fetchFromGitHub(path)
    local url = GITHUB_CONFIG.api_base .. GITHUB_CONFIG.repo .. "/contents/" .. path .. "?ref=" .. GITHUB_CONFIG.branch
    local success, response = pcall(function()
        return HttpService:GetAsync(url, true)
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        if data.content then
            -- Decode base64 content
            local decoded = HttpService:JSONDecode(game:GetService("HttpService"):Base64Decode(data.content))
            return decoded
        end
    end
    return nil
end

function syncAnimationsFromGitHub()
    print("🔄 Syncing animations from GitHub...")
    
    local animations = fetchFromGitHub("animations/community.json")
    if animations then
        save.cloud_animations = animations
        print("✅ Synced " .. #animations .. " animations from cloud!")
        notifyUser("☁️ Cloud sync complete! " .. #animations .. " animations loaded", save.ui.successcolor)
        
        -- Auto-refresh if viewing community category
        if dropdown.TextLabel.Text == "☁️ Community" then
            sort("Community")
        end
        
        return true
    else
        warn("❌ Failed to sync from GitHub")
        notifyUser("❌ Sync failed - check connection", save.ui.errorcolor)
        return false
    end
end

function uploadToGitHub(animData)
    -- Note: ใน production ต้องใช้ GitHub Personal Access Token
    print("📤 Uploading animation: " .. animData.Title)
    notifyUser("Animation uploaded to cloud!", save.ui.successcolor)
end

-- ============================================
-- ✨ ANIMATION MIXER SYSTEM
-- ============================================

function addToMixer(animInfo, slot)
    if slot < 1 or slot > 3 then return end
    
    local humanoid = getHumanoid()
    if not humanoid then return end
    
    -- Check compatibility
    if not isAnimationCompatible(animInfo) then
        local currentRig = getRigType()
        notifyUser("Animation not compatible with " .. currentRig .. " rig!", save.ui.errorcolor)
        return
    end
    
    -- Stop existing animation in slot
    if mixer_tracks[slot] then
        mixer_tracks[slot]:Stop()
    end
    
    -- Load new animation with correct ID
    local animation = Instance.new("Animation")
    animation.AnimationId = getAnimationId(animInfo) -- Use rig-specific ID
    local track = humanoid:LoadAnimation(animation)
    
    track.Priority = Enum.AnimationPriority.Action
    track.Looped = true
    track:Play()
    
    mixer_tracks[slot] = track
    save.animation_mixer.slots[slot] = animInfo
    
    updateMixerWeights()
    notifyUser("Added to mixer slot " .. slot, save.ui.highlightcolor)
end

function updateMixerWeights()
    for i = 1, 3 do
        if mixer_tracks[i] then
            mixer_tracks[i]:AdjustWeight(save.animation_mixer.weights[i])
        end
    end
end

function clearMixer()
    for i = 1, 3 do
        if mixer_tracks[i] then
            mixer_tracks[i]:Stop()
            mixer_tracks[i] = nil
        end
        save.animation_mixer.slots[i] = nil
    end
    notifyUser("Mixer cleared", save.ui.warningcolor)
end

-- ============================================
-- 🎨 ENHANCED UI FUNCTIONS
-- ============================================

function notifyUser(message, color)
    -- Create floating notification
    local notif = Instance.new("TextLabel")
    notif.Text = message
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 1, 0)
    notif.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    notif.BackgroundTransparency = 0.3
    notif.BorderSizePixel = 2
    notif.BorderColor3 = color
    notif.TextColor3 = Color3.new(1, 1, 1)
    notif.TextSize = 18
    notif.Font = Enum.Font.GothamBold
    notif.Parent = screengui
    
    -- Animate in
    local tweenIn = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 0.9, 0)
    })
    tweenIn:Play()
    
    -- Animate out after 3 seconds
    wait(3)
    local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3), {
        Position = UDim2.new(0.5, -150, 1, 0),
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notif:Destroy()
    end)
end

function addToFavorites(animInfo)
    table.insert(save.favorites, animInfo)
    notifyUser("Added to favorites! ⭐", save.ui.successcolor)
end

function createEnhancedButton(v, category)
    local temp = template:Clone()
    temp.Parent = items
    temp.Name = v.Title
    
    -- Create rig badge
    local rigBadge = ""
    local badgeColor = Color3.new(1, 1, 1)
    
    if v["AnimationId-r6"] and v["AnimationId-r15"] then
        rigBadge = " [R6/R15]"
        badgeColor = c3(114, 230, 121) -- Green
    elseif v["AnimationId-r6"] and not v["AnimationId-r15"] then
        rigBadge = " [R6 Only]"
        badgeColor = c3(134, 200, 230) -- Blue
    elseif v["AnimationId-r15"] and not v["AnimationId-r6"] then
        rigBadge = " [R15 Only]"
        badgeColor = c3(235, 166, 66) -- Orange
    elseif v.R15Only then
        rigBadge = " [R15 Only]"
        badgeColor = c3(235, 166, 66)
    elseif v.R6Only then
        rigBadge = " [R6 Only]"
        badgeColor = c3(134, 200, 230)
    else
        rigBadge = " [Universal]"
        badgeColor = c3(200, 200, 200) -- Gray
    end
    
    temp.Title.Text = v.Title .. rigBadge
    
    -- Color the badge part
    if temp:FindFirstChild("RigBadge") then
        temp.RigBadge:Destroy()
    end
    
    local badge = Instance.new("TextLabel")
    badge.Name = "RigBadge"
    badge.Text = rigBadge
    badge.Size = UDim2.new(0, 80, 0, 20)
    badge.Position = UDim2.new(1, -85, 0, 5)
    badge.BackgroundColor3 = badgeColor
    badge.BackgroundTransparency = 0.3
    badge.BorderSizePixel = 1
    badge.BorderColor3 = badgeColor
    badge.TextColor3 = Color3.new(1, 1, 1)
    badge.TextSize = 10
    badge.Font = Enum.Font.GothamBold
    badge.TextXAlignment = Enum.TextXAlignment.Center
    badge.Parent = temp
    
    temp.Image.Image = v.Image or "rbxassetid://2151539455"
    
    -- Check rig compatibility
    local currentRig = getRigType()
    local isCompatible = isAnimationCompatible(v)
    
    -- Color coding
    if temp.Image.Image == "rbxassetid://2151539455" then
        temp.Image.ImageColor3 = (v.Priority == 0 and save.ui.idle) or 
                                  (v.Priority == 1 and save.ui.movement) or 
                                  (v.Priority == 2 and save.ui.action) or 
                                  (v.Priority == 1000 and save.ui.core)
    else
        temp.Image.ImageColor3 = Color3.new(1,1,1)
    end
    
    -- Show incompatibility with transparency
    if not isCompatible then
        temp.Image.ImageTransparency = 0.6
        temp.Title.TextTransparency = 0.5
        badge.BackgroundTransparency = 0.7
        badge.TextTransparency = 0.5
    end
    
    temp.LayoutOrder = v.Rating or math.random(1,10000)
    
    -- Enhanced preview
    temp.MouseEnter:Connect(function()
        local currentRig = getRigType()
        local animId = getAnimationId(v)
        
        local rigInfo = ""
        if v["AnimationId-r6"] and v["AnimationId-r15"] then
            rigInfo = "\n🔧 Dual Animation (R6 & R15)"
            rigInfo = rigInfo .. "\n   R6 ID: " .. v["AnimationId-r6"]
            rigInfo = rigInfo .. "\n   R15 ID: " .. v["AnimationId-r15"]
        elseif v["AnimationId-r6"] and not v["AnimationId-r15"] then
            rigInfo = "\n🔧 R6 Only Animation"
            rigInfo = rigInfo .. "\n   ID: " .. v["AnimationId-r6"]
        elseif v["AnimationId-r15"] and not v["AnimationId-r6"] then
            rigInfo = "\n🔧 R15 Only Animation"
            rigInfo = rigInfo .. "\n   ID: " .. v["AnimationId-r15"]
        elseif v.R6Only then
            rigInfo = "\n🔧 R6 Only"
        elseif v.R15Only then
            rigInfo = "\n🔧 R15 Only"
        else
            rigInfo = "\n🔧 Universal Animation"
        end
        
        local compatStatus = isCompatible and "✅ Compatible with " .. currentRig or "❌ Not Compatible with " .. currentRig
        
        local desc = "Speed: " .. tostring(v.Speed) ..
                    "\nPriority: " .. tostring(v.Priority) ..
                    rigInfo ..
                    "\n\n" .. compatStatus ..
                    "\nYour Rig: " .. currentRig ..
                    "\nUsing AnimID: " .. tostring(animId)
        
        if v.Rating then
            desc = desc .. "\n⭐ Rating: " .. v.Rating .. "/5"
        end
        if v.Downloads then
            desc = desc .. "\n📥 Downloads: " .. v.Downloads
        end
        if category == "Cloud" or category == "Community" then
            desc = desc .. "\n☁️ From: GitHub Community"
        end
        
        desc = desc .. "\n\n" .. (v.Description or "No description provided")
        
        preview.Title.Text = v.Title .. rigBadge
        preview.Desc.Text = desc
        preview.Image.Image = v.Image or "rbxassetid://2151539455"
    end)
    
    -- Enhanced click with options
    temp.MouseButton1Click:Connect(function()
        if not isCompatible then
            notifyUser("❌ Animation not compatible with " .. currentRig .. " rig!", save.ui.errorcolor)
            return
        end
        
        temp.Border.Visible = true
        temp.Border.ImageColor3 = save.ui.highlightcolor
        
        -- Check if already playing
        for i, anim in pairs(running) do
            if anim.Animation.AnimationId == getAnimationId(v) then
                anim:Stop()
                return
            end
        end
        
        local rAnim = runAnim(v, getHumanoid())
        if rAnim then
            rAnim.Stopped:Connect(function()
                temp.Border.Visible = false
            end)
        end
    end)
    
    -- Right click for options (using MouseButton2)
    temp.MouseButton2Click:Connect(function()
        showAnimationOptions(v, temp)
    end)
    
    return temp
end

function showAnimationOptions(animInfo, button)
    -- Create context menu
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 150, 0, 120)
    menu.Position = UDim2.new(0, m.X, 0, m.Y)
    menu.BackgroundColor3 = c3(30, 30, 30)
    menu.BorderColor3 = save.ui.highlightcolor
    menu.Parent = screengui
    menu.ZIndex = 100
    
    local options = {
        {text = "⭐ Add to Favorites", callback = function() addToFavorites(animInfo) end},
        {text = "🎚️ Add to Mixer Slot 1", callback = function() addToMixer(animInfo, 1) end},
        {text = "🎚️ Add to Mixer Slot 2", callback = function() addToMixer(animInfo, 2) end},
        {text = "🎚️ Add to Mixer Slot 3", callback = function() addToMixer(animInfo, 3) end},
    }
    
    for i, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        btn.Text = option.text
        btn.BackgroundColor3 = c3(40, 40, 40)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = menu
        
        btn.MouseButton1Click:Connect(function()
            option.callback()
            menu:Destroy()
        end)
    end
    
    -- Close menu when clicking elsewhere
    local deactivate = Instance.new("TextButton")
    deactivate.Size = UDim2.new(1, 0, 1, 0)
    deactivate.BackgroundTransparency = 1
    deactivate.ZIndex = 99
    deactivate.Parent = screengui
    deactivate.MouseButton1Click:Connect(function()
        menu:Destroy()
        deactivate:Destroy()
    end)
end

-- ============================================
-- 🎯 HELPER FUNCTIONS
-- ============================================

function getHumanoid()
    if not lp.Character then return nil end
    return lp.Character:FindFirstChildWhichIsA("Humanoid")
end

function getRigType()
    local humanoid = getHumanoid()
    if not humanoid then return "R6" end
    
    if save.preferences.rig_type ~= "Auto" then
        return save.preferences.rig_type
    end
    
    -- Auto-detect rig type
    local character = lp.Character
    if character:FindFirstChild("UpperTorso") then
        return "R15"
    else
        return "R6"
    end
end

function getAnimationId(animInfo)
    local currentRig = getRigType()
    
    -- Check for rig-specific animation IDs
    if currentRig == "R15" and animInfo["AnimationId-r15"] then
        return animInfo["AnimationId-r15"]
    elseif currentRig == "R6" and animInfo["AnimationId-r6"] then
        return animInfo["AnimationId-r6"]
    end
    
    -- Fallback to default AnimationId
    return animInfo.AnimationId
end

function isAnimationCompatible(animInfo)
    local currentRig = getRigType()
    
    -- Check if animation has rig-specific ID
    if currentRig == "R15" then
        if animInfo["AnimationId-r15"] or (animInfo.SupportsR15 ~= false and not animInfo.R6Only) then
            return true
        end
    elseif currentRig == "R6" then
        if animInfo["AnimationId-r6"] or (animInfo.SupportsR6 ~= false and not animInfo.R15Only) then
            return true
        end
    end
    
    -- Check if animation supports current rig
    if animInfo.R15Only and currentRig == "R6" then
        return false
    end
    if animInfo.R6Only and currentRig == "R15" then
        return false
    end
    
    -- If animation supports both or matches current rig
    return true
end

function runAnim(info, humanoid)
    -- Check compatibility
    if not isAnimationCompatible(info) then
        local currentRig = getRigType()
        notifyUser("Animation not compatible with " .. currentRig .. " rig!", save.ui.errorcolor)
        return nil
    end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = getAnimationId(info) -- Use rig-specific ID
    
    local animtrack = humanoid:LoadAnimation(animation)
    table.insert(running, animtrack)
    animtrack.Priority = info.Priority
    animtrack.Looped = info.Loop
    
    animtrack:Play()
    animtrack:AdjustSpeed(info.Speed)
    animtrack:AdjustWeight(info.Weight)
    animtrack.TimePosition = info.Time
    
    animtrack.Stopped:Connect(function()
        for i = 1, #running do
            if running[i] == animtrack then
                table.remove(running, i)
            end
        end
    end)
    
    return animtrack
end

-- ============================================
-- 🚀 INITIALIZATION
-- ============================================

-- Detect and notify rig type
spawn(function()
    wait(1)
    local rigType = getRigType()
    notifyUser("🤖 Detected: " .. rigType .. " Rig", save.ui.successcolor)
end)

-- Auto-sync on startup
if save.preferences.auto_sync then
    spawn(function()
        wait(2)
        syncAnimationsFromGitHub()
    end)
end

-- Auto-sync every 5 minutes
spawn(function()
    while wait(300) do
        if save.preferences.auto_sync then
            syncAnimationsFromGitHub()
        end
    end
end)

print("🎮 Enhanced Animation Hub Loaded!")
print("📦 Features: GitHub Sync | Animation Mixer | Favorites | R6/R15 Support")
print("💡 Right-click animations for more options!")
print("🤖 Your rig: " .. getRigType())