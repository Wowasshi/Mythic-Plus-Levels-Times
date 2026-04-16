local _, addon = ...
local L = addon

----------- Settings -----------

local defaults = {
    enableOverlay = false,
}

function L:LoadSettings()
    if not MPLTSettings then
        MPLTSettings = {}
    end
    for k, v in pairs(defaults) do
        if MPLTSettings[k] == nil then
            MPLTSettings[k] = v
        end
    end
    L.config.enableOverlay = MPLTSettings.enableOverlay
end

function L:SaveSetting(key, value)
    MPLTSettings[key] = value
    L.config[key] = value
end

----------- Slash Command -----------

SLASH_MPLT1 = "/mplt"
SlashCmdList["MPLT"] = function(msg)
    local cmd = strtrim(msg):lower()
    if cmd == "overlay" then
        local newVal = not L.config.enableOverlay
        L:SaveSetting("enableOverlay", newVal)
        print("|cff00ccffMPLT:|r Overlay " .. (newVal and "|cff00ff00enabled|r" or "|cffff0000disabled|r") .. ". Reopen the PVE panel to see changes.")
    elseif cmd == "options" or cmd == "config" then
        if L.optionsCategoryID then
            Settings.OpenToCategory(L.optionsCategoryID)
        end
    else
        print("|cff00ccffMythic Plus Levels & Times|r")
        print("  /mplt overlay - Toggle ChallengesFrame overlay (" .. (L.config.enableOverlay and "|cff00ff00on|r" or "|cffff0000off|r") .. ")")
        print("  /mplt options - Open the options panel")
    end
end

----------- Options Panel -----------

function L:SetupOptionsPanel()
    local category = Settings.RegisterVerticalLayoutCategory("Mythic Plus Levels & Times")

    local overlayVariable = "MPLT_enableOverlay"
    local overlaySetting = Settings.RegisterAddOnSetting(
        category,
        overlayVariable,
        "enableOverlay",
        MPLTSettings,
        Settings.VarType.Boolean,
        "Enable Overlay",
        defaults.enableOverlay
    )

    Settings.CreateCheckbox(category, overlaySetting, "When enabled, overlays dungeon info and teleport buttons on the Blizzard Challenges tab icons.")

    overlaySetting:SetValueChangedCallback(function(_, value)
        L.config.enableOverlay = value
    end)

    Settings.RegisterAddOnCategory(category)
    L.optionsCategoryID = category:GetID()
end
