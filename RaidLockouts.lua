---WIP fixing code to save resizing of the frame
-- Addon name and namespace
local addonName, addonNamespace = ...

-- Function to initialize settings
function InitializeSettings()
    if not RaidLockoutDB then
        RaidLockoutDB = {}
    end
    RaidLockoutDB.sliders = RaidLockoutDB.sliders or {50, 80, 50}
    RaidLockoutDB.checkboxes = RaidLockoutDB.checkboxes or {true, true, true, false, false}
    RaidLockoutDB.position = RaidLockoutDB.position or {point = "CENTER", relativeTo = "UIParent", relativePoint = "CENTER", xOfs = 20, yOfs = 0}
    RaidLockoutDB.frameSize = RaidLockoutDB.frameSize or {width = 300, height = 300}
    RaidLockoutDB.updateLayout = RaidLockoutDB.updateLayout or false
    RaidLockoutDB.alpha = RaidLockoutDB.alpha or 100
    RaidLockoutDB.scale = RaidLockoutDB.scale or 100
end

-- Initialize settings before creating the frame
InitializeSettings()

-- Create the main frame
local frame = CreateFrame("Frame", "RaidLockOutFrame", UIParent, "BackdropTemplate")
frame:SetSize(RaidLockoutDB.frameSize.width or 300, RaidLockoutDB.frameSize.height or 300)  -- Initial size (will be dynamically resized later)

-- Create a scroll frame
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -40)
scrollFrame:SetPoint("BOTTOMRIGHT", -35, 20)


-- Create a content frame for the scroll frame
local contentFrame = CreateFrame("Frame", nil, scrollFrame)
scrollFrame:SetScrollChild(contentFrame)
contentFrame:SetSize(frame:GetWidth() - 40, frame:GetHeight() - 50)

-- Clear existing anchors before setting a new one
frame:ClearAllPoints()

-- Set the new point
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)  -- Adjust the point and offsets as needed

frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
frame:SetBackdropColor(0, 0, 0, 1) -- Set initial backdrop transparency
frame:SetBackdropBorderColor(0, 0, 0, 1) -- Set border color to black
frame:SetMovable(true) -- Make the frame movable
frame:SetResizable(true) -- Make the frame resizable
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
-- This function is already defined later in the code, so it can be removed here.
frame:Hide()

-- Create a close texture
local closeTexture = frame:CreateTexture(nil, "ARTWORK")
closeTexture:SetSize(22, 22)
closeTexture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -7)
closeTexture:SetTexture("Interface\\AddOns\\RaidLockouts\\close.png")
closeTexture:SetTexCoord(0, 1, 0, 1)

-- Add highlighting and clicking features to the close texture
closeTexture:SetScript("OnEnter", function(self)
    self:SetVertexColor(1, 0, 0)
end)
closeTexture:SetScript("OnLeave", function(self)
    self:SetVertexColor(1, 1, 1)
end)
closeTexture:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
        RaidLockoutDB.position = {point = point, relativeTo = relativeTo and relativeTo:GetName() or "UIParent", relativePoint = relativePoint, xOfs = xOfs, yOfs}
        frame:Hide()
    end
end)

-- Create the settings frame
local settingsFrame = CreateFrame("Frame", "RaidLockoutSettingsFrame", UIParent, "BackdropTemplate")
settingsFrame:SetSize(180, 150)
settingsFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
settingsFrame:SetBackdropColor(0, 0, 0, 1)
settingsFrame:SetBackdropBorderColor(0, 0, 0, 1) -- Set border color to black
settingsFrame:SetMovable(true)
settingsFrame:EnableMouse(true)
settingsFrame:RegisterForDrag("LeftButton")
settingsFrame:SetScript("OnDragStart", settingsFrame.StartMoving)
settingsFrame:SetScript("OnDragStop", settingsFrame.StopMovingOrSizing)
settingsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -50) -- Default position in the center, offset down by 50
settingsFrame:Hide()

-- Title text for settings frame
local settingsTitle = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
settingsTitle:SetPoint("TOP", settingsFrame, "TOP", 0, -10)
settingsTitle:SetText("|cff00ff00Settings|r")

-- Add a settings texture to the main frame
local settingsTexture = frame:CreateTexture(nil, "ARTWORK")
settingsTexture:SetSize(24, 20)
settingsTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
settingsTexture:SetTexture("Interface\\AddOns\\RaidLockouts\\settings.png")
settingsTexture:SetTexCoord(0, 1, 0, 1)

-- Add highlighting and clicking features to the settings texture
settingsTexture:SetScript("OnEnter", function(self)
    self:SetVertexColor(0.5, 0.5, 1)
end)
settingsTexture:SetScript("OnLeave", function(self)
    self:SetVertexColor(1, 1, 1)
end)
settingsTexture:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        if settingsFrame:IsShown() then
            settingsFrame:Hide()
        else
            settingsFrame:ClearAllPoints()
            settingsFrame:SetPoint("LEFT", frame, "RIGHT", 10, 0) -- Positioned to the right of the main frame
            settingsFrame:Show()
        end
    end
end)

-- Add a close texture to the settings frame
local settingsCloseTexture = settingsFrame:CreateTexture(nil, "ARTWORK")
settingsCloseTexture:SetSize(24, 24)
settingsCloseTexture:SetPoint("TOPRIGHT", settingsFrame, "TOPRIGHT", -5, -5)
settingsCloseTexture:SetTexture("Interface\\AddOns\\RaidLockouts\\close.png")
settingsCloseTexture:SetTexCoord(0, 1, 0, 1)

-- Add highlighting and clicking features to the settings close texture
settingsCloseTexture:SetScript("OnEnter", function(self)
    self:SetVertexColor(1, 0, 0)
end)
settingsCloseTexture:SetScript("OnLeave", function(self)
    self:SetVertexColor(1, 1, 1)
end)
settingsCloseTexture:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        settingsFrame:Hide()
    end
end)

-- Add sliders to the settings frame
local alphaSlider = CreateFrame("Slider", "RaidLockoutAlphaSlider", settingsFrame, "OptionsSliderTemplate")
alphaSlider:SetPoint("TOP", settingsFrame, "TOP", 0, -40)
alphaSlider:SetMinMaxValues(0, 100)
alphaSlider:SetValueStep(1)
InitializeSettings()
alphaSlider:SetValue(RaidLockoutDB.alpha or 100)
alphaSlider:SetScript("OnValueChanged", function(self, value)
    frame:SetBackdropColor(0, 0, 0, value / 100)
    RaidLockoutDB.alpha = value
end)
_G[alphaSlider:GetName() .. 'Low']:SetText('0')
_G[alphaSlider:GetName() .. 'High']:SetText('100')
_G[alphaSlider:GetName() .. 'Text']:SetText('Alpha')

local scaleSlider = CreateFrame("Slider", "RaidLockoutScaleSlider", settingsFrame, "OptionsSliderTemplate")
scaleSlider:SetPoint("TOP", alphaSlider, "BOTTOM", 0, -40)
scaleSlider:SetMinMaxValues(25, 100)
scaleSlider:SetValueStep(1)
scaleSlider:SetValue(RaidLockoutDB.scale or 100)
scaleSlider:SetScript("OnValueChanged", function(self, value)
    settingsFrame:ClearAllPoints()
    settingsFrame:Hide() -- Hide settings frame during scaling
    frame:SetScale(value / 100)
    RaidLockoutDB.scale = value

    settingsFrame:Show() -- Show settings frame after scaling
end)
_G[scaleSlider:GetName() .. 'Low']:SetText('25')
_G[scaleSlider:GetName() .. 'High']:SetText('100')
_G[scaleSlider:GetName() .. 'Text']:SetText('Scale')

-- Add a resize texture to the bottom right corner of the frame
local resizeTexture = frame:CreateTexture(nil, "ARTWORK")
resizeTexture:SetSize(16, 16)
resizeTexture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
resizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeTexture:SetTexCoord(0, 1, 0, 1)

-- Add highlighting and clicking features to the resize texture
resizeTexture:SetScript("OnMouseDown", function(self)
    frame:StartSizing("BOTTOMRIGHT")
    self:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
end)
resizeTexture:SetScript("OnMouseUp", function(self)
    frame:StopMovingOrSizing()
    self:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    -- Save the new size to the database
    local width, height = frame:GetSize()
    RaidLockoutDB.frameSize = {width = width, height = height}
end)
resizeTexture:SetScript("OnEnter", function(self)
    self:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
end)
resizeTexture:SetScript("OnLeave", function(self)
    self:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
end)

-- Title text
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
title:SetPoint("TOP", frame, "TOP", 0, -10)
title:SetText("|cFFABD473Instance|r |cFF69CCF0Lockouts|r")

-- Content text
local content = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
content:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 0, 0)
content:SetWidth(contentFrame:GetWidth())
content:SetJustifyH("LEFT")

-- Ensure the frame size is saved when resizing stops
frame:SetScript("OnSizeChanged", function(self, width, height)
    RaidLockoutDB.frameSize = {width = width, height = height}
    contentFrame:SetSize(width - 40, height - 50)
    content:SetWidth(contentFrame:GetWidth())
end)

-- Set minimum and maximum sizes for the frame
frame:SetResizeBounds(200, 100, 800, 600)

-- Utility function to determine the client (Classic or Retail)
local function IsRetail()
    return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

-- Function to calculate the reset day of the week
local function GetResetDay(resetSeconds)
    local currentTime = time() -- Current Unix time
    local resetTime = currentTime + resetSeconds
    local weekday = date("%A", resetTime) -- Get the day of the week
    return weekday
end

-- Function to format remaining time into days, hours, and minutes
local function FormatTimeRemaining(reset)
    local days = math.floor(reset / 86400) -- Convert seconds to days
    local hours = math.floor((reset % 86400) / 3600) -- Convert remaining seconds to hours
    local minutes = math.floor((reset % 3600) / 60) -- Convert remaining seconds to minutes

    return string.format("%d days, %d hours, %d minutes", days, hours, minutes)
end

-- Function to determine raid name color
local function GetRaidColor(name)
    if name:lower():find("molten core") then
        return "|cFFFF7D0A" -- Orange
    elseif name:lower():find("blackwing lair") then
        return "|cFF707070" -- Lighter Grey (Better contrast)
    elseif name:lower():find("ahn'quiraj") or name:lower():find("aq") then
        return "|cFF00FF00" -- Green
    elseif name:lower():find("naxxramas") then
        return "|cFF0070DD" -- Blue
    else
        -- Randomize light color for other raids
        local colors = {"|cFFFFA07A", "|cFF98FB98", "|cFFADD8E6", "|cFFFFFFE0", "|cFFFFB6C1", "|cFFE0FFFF"}
        return colors[math.random(#colors)]
    end
end

-- Function to update lockouts
local function UpdateLockouts()
    local raidLockoutText = "|cFFFFD100Raids:|r\n"
    local dungeonLockoutText = "|cFFFFD100Dungeons:|r\n"
    local hasRaids, hasDungeons = false, false

    for i = 1, GetNumSavedInstances() do
        local name, _, reset, _, _, _, _, _, _, difficulty = GetSavedInstanceInfo(i)
        reset = tonumber(reset)
        difficulty = tonumber(difficulty)

        -- Skip invalid entries
        if not IsRetail() and (difficulty == 1 or difficulty == 2) then
            -- Skip Normal and Heroic for Classic clients
        else
            local resetFormatted = FormatTimeRemaining(reset)
            local resetDay = reset and GetResetDay(reset) or "Unknown"

            -- Ensure we don't display "Unknown" for Classic's Normal difficulty
            local difficultyName = "Normal"
            if IsRetail() then
                if difficulty == 2 then
                    difficultyName = "Heroic"
                elseif difficulty == 3 then
                    difficultyName = "Mythic"
                elseif difficulty == 4 then
                    difficultyName = "Mythic+" -- For dungeons in Retail
                end
            end

            local raidColor = GetRaidColor(name or "Unknown Instance")

            local lockoutText = string.format(
                "%s%s (%s) - |cFFFF0000%s|r\n%s\n",
                raidColor,
                name or "Unknown Instance",
                difficultyName,
                resetDay,
                resetFormatted
            )

            if IsRetail() and (difficulty == 1 or difficulty == 2) then
                dungeonLockoutText = dungeonLockoutText .. lockoutText
                hasDungeons = true
            else
                raidLockoutText = raidLockoutText .. lockoutText
                hasRaids = true
            end
        end
    end

    local finalText = ""
    if hasRaids then finalText = finalText .. raidLockoutText .. "\n" end
    if IsRetail() and hasDungeons then finalText = finalText .. dungeonLockoutText .. "\n" end
    if finalText == "" then
        finalText = "No active lockouts."
    end

    content:SetText(finalText)

    -- Dynamically adjust the frame size based on the content
    local contentHeight = content:GetStringHeight()
    contentFrame:SetHeight(contentHeight)
    scrollFrame:UpdateScrollChildRect()
end

-- Update lockouts when the frame is shown
frame:SetScript("OnShow", UpdateLockouts)

-- Function to dynamically anchor the frame to the bottom of the Character Panel
local function AnchorToCharacterPanel()
    if not RaidLockoutDB.position.userMoved then
        local characterFrame = _G["CharacterFrame"]
        if (characterFrame) then
            frame:ClearAllPoints()
            frame:SetPoint("TOP", characterFrame, "BOTTOM", 0, -10) -- Anchored below the Character Panel
        end
    end
end

-- Hook into the Character Frame Show and Hide using the OnShow and OnHide events
if CharacterFrame then
    CharacterFrame:HookScript("OnShow", function()
        if not RaidLockoutDB.position.userMoved then
            AnchorToCharacterPanel() -- Ensure the frame is anchored below when Character Frame is shown
        end
        frame:Show() -- Show the lockout frame when the Character Frame is shown
    end)

    CharacterFrame:HookScript("OnHide", function()
        frame:Hide() -- Hide the lockout frame when the Character Frame is hidden
    end)
end

-- Restore frame position on load
if RaidLockoutDB.position.userMoved then
    local relativeTo = _G[RaidLockoutDB.position.relativeTo] or UIParent
    frame:ClearAllPoints()
    frame:SetPoint(RaidLockoutDB.position.point, relativeTo, RaidLockoutDB.position.relativePoint, RaidLockoutDB.position.xOfs, RaidLockoutDB.position.yOfs)
    frame:SetSize(RaidLockoutDB.frameSize.width, RaidLockoutDB.frameSize.height)
    content:SetWidth(RaidLockoutDB.frameSize.width - 30) -- Adjust content width to fit within the frame
    content:SetHeight(RaidLockoutDB.frameSize.height - 60) -- Adjust content height to fit within the frame
else
    AnchorToCharacterPanel()
end

-- Update the userMoved flag when the frame is moved
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    RaidLockoutDB.position = {point = point, relativeTo = relativeTo and relativeTo:GetName() or "UIParent", relativePoint = relativePoint, xOfs = xOfs, yOfs, userMoved = true}
    self:ClearAllPoints()
    self:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
end)

-- Function to reset the frame to the center of the screen
local function ResetFramePosition()
    RaidLockOutFrame:ClearAllPoints()
    RaidLockOutFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    RaidLockoutDB.position = {point = "CENTER", relativeTo = "UIParent", relativePoint = "CENTER", xOfs = 0, yOfs = 0, userMoved = true}
end

-- Slash command to show/hide the frame
SLASH_RAIDLOCKOUTS1 = "/raidlockouts"
SlashCmdList["RAIDLOCKOUTS"] = function(msg)
    if msg == "show" then
        RaidLockOutFrame:Show()
    elseif msg == "hide" then
        RaidLockOutFrame:Hide()
    elseif msg == "reset" then
        ResetFramePosition()
    else
        print("Usage:")
        print("/raidlockouts show - Show the frame")
        print("/raidlockouts hide - Hide the frame")
        print("/raidlockouts reset - Reset the frame position")
    end
end

-- Event handler for ADDON_LOADED and PLAYER_LOGOUT
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGOUT")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        -- Initialize settings
        InitializeSettings()
        -- Restore frame position, alpha, and scale on load
        local relativeTo = _G[RaidLockoutDB.position.relativeTo] or UIParent
        frame:ClearAllPoints()
        frame:SetPoint(RaidLockoutDB.position.point, relativeTo, RaidLockoutDB.position.relativePoint, RaidLockoutDB.position.xOfs, RaidLockoutDB.position.yOfs)
        frame:SetBackdropColor(0, 0, 0, RaidLockoutDB.alpha / 100)
        frame:SetScale(RaidLockoutDB.scale / 100)
        frame:SetSize(RaidLockoutDB.frameSize.width, RaidLockoutDB.frameSize.height)
    elseif event == "PLAYER_LOGOUT" then
        -- Save the current frame position and size on logout
        local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
        RaidLockoutDB.position = {point = point, relativeTo = relativeTo and relativeTo:GetName() or "UIParent", relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs, userMoved = true}
        local width, height = frame:GetSize()
        RaidLockoutDB.frameSize = {width = width, height = height}
    end
end)
