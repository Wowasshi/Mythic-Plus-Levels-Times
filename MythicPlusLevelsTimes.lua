local _, addon = ...
local L = addon

----------- Blend Colors -----------
do
    local blend = function(cA, cB, t)
        local t1 = 1.0 - t
        return {
            r = (cA.r * t1) + (cB.r * t),
            g = (cA.g * t1) + (cB.g * t),
            b = (cA.b * t1) + (cB.b * t)
        }
    end
    
    -- find last (aka prev.) values
    local last = 0
    for i=0,40 do
        local c = L.colors[i]
        if c then
            last = i
        else
            L.colors[i] = {last = last}
        end
    end
    
    -- find next value
    for i=0,40 do
        local j = 40 - i
        
        local c = L.colors[j] or {}
        if c.r then
            last = j
        else
            c.next = last
        end
    end
    
    -- blend
    for i=0,40 do
        local c = L.colors[i]
        if c.last and c.next then
            local t = (i - c.last) / (c.next - c.last)
            local a = L.colors[c.last]
            local b = L.colors[c.next]
            L.colors[i] = blend(a, b, t)
            -- c.t = t
        end
    end
end

local sort_dungeons = function(map_table)
    
    -- 1) fetch score for each dungeon
    local map_scores = {};
    for _, mapID in ipairs(map_table) do
        
        local inTimeInfo, overtimeInfo = C_MythicPlus.GetSeasonBestForMap(mapID);
        local dungeonScore = 0; 
        if(inTimeInfo and overtimeInfo) then 
            local inTimeScoreIsBetter = inTimeInfo.dungeonScore > overtimeInfo.dungeonScore; 
            dungeonScore = inTimeScoreIsBetter and inTimeInfo.dungeonScore or overtimeInfo.dungeonScore; 
        elseif(inTimeInfo or overtimeInfo) then 
            dungeonScore = inTimeInfo and inTimeInfo.dungeonScore or overtimeInfo.dungeonScore;
        end
        map_scores[mapID] = dungeonScore
    end    
    
    -- 2) sort them!
    table.sort(map_table, function(a,b) 
            if map_scores[a] == 0 and map_scores[b] == 0 then
                return a > b
            else
                return map_scores[a] > map_scores[b]
            end
        end);
    return map_table
    
end

local main = function (arr, event, ...)
    
    if event == "PLAYER_ENTERING_WORLD" then
        local entering = ...
        if entering then
            if next(L.regions.subRegion) ~= nil then
                for k, v in pairs(L.regions.subRegion) do
                    L.regions.subRegion[k].buttonFrame:Hide()
                end
                L.dungeonStates = {}
            end
        end
        C_MythicPlus.RequestMapInfo()
        return 
    end
    
    local map_table = {}
    local timeRunner = PlayerGetTimerunningSeasonID()
    
    if timeRunner then
        map_table = L.legionRemixDungeonsMapIDs
    else
        map_table = C_ChallengeMode.GetMapTable()
    end
    
    if L.config.sortByScore then
       sort_dungeons(map_table)
    end
    
    for i=1, #map_table do
        local mapID = map_table[i]
        local alts, score = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(mapID)
        local name, _, timeLimit, icon = C_ChallengeMode.GetMapUIInfo(mapID)

        local timeFormatted = ("%02i:%02i:%02i"):format(timeLimit/60^2, timeLimit/60%60, timeLimit%60)
        if not timeRunner or timeRunner == 0 then
            arr[i] = {
                mapID = mapID,
                show = true,
                changed = true,
                name = name,
                icon = icon,
                level = 0,
                score = score or 0,
                deplete = false,
                duration = timeFormatted,
                timeLeft = "",
                bestTime = "",
                tooltip = name .. "\n",
                abbr = L.dungeonNames[mapID] or "",
            }
    
            for _, alt in pairs(alts or {}) do
                local state = arr[i]
                if alt.score == score then
                    state.level = alt.level
                end 
                if alt.overTime then
                    state.deplete = alt.overTime
                end
                
                state.bestTime = ("%02i:%02i:%02i"):format(alt.durationSec/60^2, alt.durationSec/60%60, alt.durationSec%60)
                state.tooltip = state.tooltip .. "\n" .. state.bestTime
                local tempTime = timeLimit - alt.durationSec
                
                state.timeLeft =  ("%02i:%02i"):format(tempTime/60, tempTime%60)
            end
        else 
            arr[i] = {
                mapID = mapID,
                show = true,
                changed = true,
                name = name,
                icon = icon,
                level = nil,
                score = nil,
                deplete = false,
                duration = nil,
                timeLeft = nil,
                bestTime = nil,
                tooltip = name .. "\n",
                abbr = L.dungeonNames[mapID] or "",
            }
        end
    end    
    
    return true
    
end

-- Build a reverse lookup set for teleport spell IDs
local teleportSpellSet = {}
for _, v in pairs(L.dungeonTeleportSpellID) do
    if type(v) == "table" then
        for _, id in pairs(v) do teleportSpellSet[id] = true end
    else
        teleportSpellSet[v] = true
    end
end

local function updateCooldowns()
    local _, instanceType = GetInstanceInfo()
    local isMythicPlus = instanceType == "party" and C_ChallengeMode.GetActiveChallengeMapID() ~= nil

    if not isMythicPlus and not UnitAffectingCombat("player") then
        -- All teleport spells share a cooldown, so query any known one
        local spellID = next(teleportSpellSet)
        if not spellID then return end
        local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID)
        for k, _ in pairs(L.regions.subRegion) do
            local region = L.regions.subRegion[k]
            region.cooldown:Clear()
            region.cooldown:SetCooldown(spellCooldownInfo.startTime, spellCooldownInfo.duration)
        end
    end
end

local function renderDungeons(arr, boundFrame)

    local sizeX = L.config.buttonSettings.buttonDimension.x
    local sizeY = L.config.buttonSettings.buttonDimension.y
    local spacing = L.config.buttonSettings.buttonDimension.spacing
    local borderWidth = L.config.buttonSettings.borderDimension.borderWidth
    local backdropInfo = L.config.buttonSettings.backdropInfo
    local ts = L.config.buttonSettings.textSettings
    local font1, size1 = ts.text1.font, ts.text1.size
    local font2, size2 = ts.text2.font, ts.text2.size
    local font3, size3 = ts.text3.font, ts.text3.size
    local font4, size4 = ts.text4.font, ts.text4.size
    local _, instanceType = GetInstanceInfo()
    local isMythicPlus = instanceType == "party" and C_ChallengeMode.GetActiveChallengeMapID() ~= nil

    for k, maps in pairs(arr) do
        local region = L.regions.subRegion[k]
        if region == nil then
            region = {
                buttonFrame = CreateFrame("Button", "MythicPlusTimesBar" .. k .. "Button", boundFrame, "InsecureActionButtonTemplate"),
                borderFrame = nil,
                text1 = nil,
                text2 = nil,
                text3 = nil,
                text4 = nil,
                icon = nil,
                cooldown = nil
            }
            region.borderFrame = CreateFrame("Frame", "BorderFrame" .. k, region.buttonFrame, "BackdropTemplate")
            region.text1 = region.buttonFrame:CreateFontString(nil, "OVERLAY")
            region.text2 = region.buttonFrame:CreateFontString(nil, "OVERLAY")
            region.text3 = region.buttonFrame:CreateFontString(nil, "OVERLAY")
            region.text4 = region.buttonFrame:CreateFontString(nil, "OVERLAY")
            region.icon = region.buttonFrame:CreateTexture(maps.name, "ARTWORK")
            region.cooldown = CreateFrame("Cooldown", "MyTeleportButtonCooldown" .. k, region.borderFrame, "CooldownFrameTemplate")
            L.regions.subRegion[k] = region
        end

        region.buttonFrame:SetSize(sizeX,sizeY)
        region.buttonFrame:SetFrameStrata("HIGH")
        region.buttonFrame:SetPoint("LEFT", boundFrame, "LEFT", ((k-1)*sizeX) + (k*(spacing+(borderWidth/2))),0)
        region.buttonFrame:RegisterForClicks("AnyUp", "AnyDown")
        region.buttonFrame:SetAttribute("type", "spell")
        region.buttonFrame:SetAttribute("spell", L.dungeonTeleportSpellName[maps.mapID])

        region.borderFrame:SetSize(sizeX + (borderWidth/2), sizeY + (borderWidth/2))
        region.borderFrame:SetPoint("CENTER", region.buttonFrame, "CENTER", 0, 0)
        region.borderFrame:SetFrameStrata("BACKGROUND")
        region.borderFrame:SetBackdrop(backdropInfo)
        local mySpellID = L.dungeonTeleportSpellID[maps.mapID]
        if (type(mySpellID) == "table") then
            local faction = UnitFactionGroup("player")
            if (faction == "Alliance" or faction == "Horde") then
                mySpellID = mySpellID[faction]
            else
                mySpellID = nil
            end
        end
        local isSpellKnown = false
        if type(mySpellID) == "number" then
            isSpellKnown = C_SpellBook.IsSpellInSpellBook(mySpellID)
        end

        if isSpellKnown then
            region.borderFrame:SetBackdropBorderColor(255/255,215/255,0/255,1)
            region.borderFrame:SetBackdropColor(255/255,215/255,0/255,1)
        else
            region.borderFrame:SetBackdropBorderColor(0,0,0,1)
            region.borderFrame:SetBackdropColor(0,0,0,1)
        end

        local c = L.colors[maps.level or 0]
        if maps.deplete then
            c = L.color_deplete
        end
        local r, g, b = c.r/255, c.g/255, c.b/255

        region.text1:SetFont(font1, size1, "OUTLINE")
        region.text1:SetPoint("TOP", region.buttonFrame, "TOP", 0, 8)
        region.text1:SetText(("%s"):format(maps.abbr))

        region.text2:SetFont(font2, size2, "OUTLINE")
        region.text2:SetPoint("CENTER", region.buttonFrame, "CENTER", 0, 8)
        region.text2:SetText(("%s"):format(maps.level or ""))
        region.text2:SetTextColor(r,g,b, 1)

        region.text3:SetFont(font3, size3, "OUTLINE")
        region.text3:SetPoint("BOTTOM", region.buttonFrame, "BOTTOM", 0, 4)
        region.text3:SetText(("%s"):format(maps.score or ""))
        region.text3:SetTextColor(r,g,b, 1)
        region.text4:SetFont(font4, size4, "OUTLINE")
        region.text4:SetPoint("BOTTOM", region.buttonFrame, "BOTTOM", 0, -18)
        region.text4:SetText(("%s"):format(maps.timeLeft or ""))
        region.text4:SetTextColor(r,g,b, 1)

        region.icon:SetAllPoints()
        region.icon:SetTexture(maps.icon)

        if isSpellKnown and not isMythicPlus then
            local spellCooldownInfo = C_Spell.GetSpellCooldown(mySpellID)
            region.cooldown:SetAllPoints()
            region.cooldown:SetAttribute("spell", L.dungeonTeleportSpellName[maps.mapID])
            if not UnitAffectingCombat("player") and spellCooldownInfo.isEnabled then
                region.cooldown:SetCooldown(spellCooldownInfo.startTime, spellCooldownInfo.duration, spellCooldownInfo.modRate)
                region.cooldown:SetHideCountdownNumbers(true)
            end
        end

        region.buttonFrame:Show()
    end
end

local frame = CreateFrame("Frame", "MythicPlusTimes" .. "Frame", UIParent)
frame:SetSize(50*8,100)
frame:SetPoint("BOTTOMLEFT", PVEFrame, "BOTTOMLEFT", 15,-130)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
frame:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")
frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")

local iconFrame = CreateFrame("Button", "MythicPlusTimesBar", frame, "InsecureActionButtonTemplate")
iconFrame:SetAllPoints()
iconFrame:Show()

frame:Hide()

local function hideFrame(self)
    frame:Hide()
end

local function showFrame(self)
    frame:Show()
end

local status, pveFrameLoaded = pcall(function() return PVEFrame end)

if status and pveFrameLoaded then
    PVEFrame:HookScript("OnShow",showFrame)
    PVEFrame:HookScript("OnHide",hideFrame)
else
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, addOn)
        if addOn == "Blizzard_PVEUI" then
            PVEFrame:HookScript("OnShow",showFrame)
            PVEFrame:HookScript("OnHide",hideFrame)
            self:UnregisterAllEvents()
        end
    end)
end

frame:SetScript("OnEvent", function(self, event, ...)    

    if event == "ADDON_LOADED" or event == "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE" or event == "PLAYER_ENTERING_WORLD" or event == "WEEKLY_REWARDS_UPDATE" then
        if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then  
            self:UnregisterEvent(event)
        end
        main(L.dungeonStates, event, ...)
        renderDungeons(L.dungeonStates, iconFrame)
    end

    if event == "SPELL_UPDATE_COOLDOWN" and self:IsShown() then
        updateCooldowns()
    end
end)
