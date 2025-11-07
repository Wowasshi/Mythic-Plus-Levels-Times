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

        local timeFormatted = ("%02i:%02i:%02i"):format(timeLimit/60^2, timeLimit/60%60, timeLimit/60)
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

local function spellInTable(spellID)
    for _, v in pairs(L.dungeonTeleportSpellID) do
        if spellID == v then
            return true
        end
    end
    return false
end

local function updateCooldown(spellID) 
    for k, _ in pairs(L.regions.subRegion) do
        local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID)
        L.regions.subRegion[k].cooldown:Clear()
        L.regions.subRegion[k].cooldown:SetCooldown(spellCooldownInfo.startTime, spellCooldownInfo.duration)
    end
end

local function renderDungeons(arr, boundFrame)
    
    local sizeX = L.config.buttonSettings.buttonDimension.x
    local sizeY = L.config.buttonSettings.buttonDimension.y
    local spacing = L.config.buttonSettings.buttonDimension.spacing
    local borderWidth = L.config.buttonSettings.borderDimension.borderWidth
    local backdropInfo = L.config.buttonSettings.backdropInfo
    local timeRunner = PlayerGetTimerunningSeasonID()
    
    for k, maps in pairs(arr) do
        if L.regions.subRegion[k] == nil then
            L.regions.subRegion[k] = {
                buttonFrame = CreateFrame("Button", "MythicPlusTimesBar" .. k .. "Button", boundFrame, "InsecureActionButtonTemplate"),
                borderFrame = nil,
                text1 = nil,
                text2 = nil,
                text3 = nil,
                text4 = nil,
                icon = nil,
                cooldown = nil
            }
            L.regions.subRegion[k].borderFrame = CreateFrame("Frame", "BorderFrame" .. k, L.regions.subRegion[k].buttonFrame, "BackdropTemplate")
            L.regions.subRegion[k].text1 = L.regions.subRegion[k].buttonFrame:CreateFontString(nil, "OVERLAY")
            L.regions.subRegion[k].text2 = L.regions.subRegion[k].buttonFrame:CreateFontString(nil, "OVERLAY")
            L.regions.subRegion[k].text3 = L.regions.subRegion[k].buttonFrame:CreateFontString(nil, "OVERLAY")
            L.regions.subRegion[k].text4 = L.regions.subRegion[k].buttonFrame:CreateFontString(nil, "OVERLAY")
            L.regions.subRegion[k].icon = L.regions.subRegion[k].buttonFrame:CreateTexture(maps.name, "ARTWORK")
            L.regions.subRegion[k].cooldown = CreateFrame("Cooldown", "MyTeleportButtonCooldown" .. k, L.regions.subRegion[k].borderFrame, "CooldownFrameTemplate")
        end

        L.regions.subRegion[k].buttonFrame:SetSize(sizeX,sizeY)
        L.regions.subRegion[k].buttonFrame:SetFrameStrata("HIGH")
        L.regions.subRegion[k].buttonFrame:SetPoint("LEFT", boundFrame, "LEFT", ((k-1)*sizeX) + (k*(spacing+(borderWidth/2))),0)
        L.regions.subRegion[k].buttonFrame:RegisterForClicks("AnyUp", "AnyDown")
        L.regions.subRegion[k].buttonFrame:SetAttribute("type", "spell")
        L.regions.subRegion[k].buttonFrame:SetAttribute("spell", L.dungeonTeleportSpellName[maps.mapID])

        L.regions.subRegion[k].borderFrame:SetSize(sizeX + (borderWidth/2), sizeY + (borderWidth/2))
        L.regions.subRegion[k].borderFrame:SetPoint("CENTER", L.regions.subRegion[k].buttonFrame, "CENTER", 0, 0)
        L.regions.subRegion[k].borderFrame:SetFrameStrata("BACKGROUND")
        L.regions.subRegion[k].borderFrame:SetBackdrop(backdropInfo)
        local mySpellID = L.dungeonTeleportSpellID[maps.mapID]
        if (type(mySpellID) == "table") then
            local faction = UnitFactionGroup("player")
            if (faction == "Alliance" or faction == "Horde") then
                mySpellID = mySpellID[UnitFactionGroup("player")]
            end
        end
        local spellID = nil
        if type(mySpellID) == "number" then
            spellID = C_Spell.GetSpellIDForSpellIdentifier(mySpellID)
        end
        if not spellID then
            L.regions.subRegion[k].borderFrame:SetBackdropBorderColor(0,0,0,1)
            L.regions.subRegion[k].borderFrame:SetBackdropColor(0,0,0,1)
        else
            L.regions.subRegion[k].borderFrame:SetBackdropBorderColor(255/255,215/255,0/255,1)
            L.regions.subRegion[k].borderFrame:SetBackdropColor(255/255,215/255,0/255,1)
        end

        local c = L.colors[maps.level or 0]
        if maps.deplete then
            c = L.color_deplete
        end
        local r, g, b = c.r/255, c.g/255, c.b/255
        
        L.regions.subRegion[k].text1:SetFont(L.config.buttonSettings.textSettings.text1.font, L.config.buttonSettings.textSettings.text1.size, "OUTLINE")
        L.regions.subRegion[k].text1:SetPoint("TOP", L.regions.subRegion[k].buttonFrame, "TOP", 0, 8)
        L.regions.subRegion[k].text1:SetText(("%s"):format(maps.abbr))
        
        -- if not timeRunner or timeRunner == 0 then
        L.regions.subRegion[k].text2:SetFont(L.config.buttonSettings.textSettings.text2.font, L.config.buttonSettings.textSettings.text2.size, "OUTLINE")
        L.regions.subRegion[k].text2:SetPoint("CENTER", L.regions.subRegion[k].buttonFrame, "CENTER", 0, 8)
        L.regions.subRegion[k].text2:SetText(("%s"):format(maps.level or ""))
        L.regions.subRegion[k].text2:SetTextColor(r,g,b, 1)
        
        L.regions.subRegion[k].text3:SetFont(L.config.buttonSettings.textSettings.text3.font, L.config.buttonSettings.textSettings.text3.size, "OUTLINE")
        L.regions.subRegion[k].text3:SetPoint("BOTTOM", L.regions.subRegion[k].buttonFrame, "BOTTOM", 0, 4)
        L.regions.subRegion[k].text3:SetText(("%s"):format(maps.score or ""))
        L.regions.subRegion[k].text3:SetTextColor(r,g,b, 1)
        L.regions.subRegion[k].text4:SetFont(L.config.buttonSettings.textSettings.text4.font, L.config.buttonSettings.textSettings.text4.size, "OUTLINE")
        L.regions.subRegion[k].text4:SetPoint("BOTTOM", L.regions.subRegion[k].buttonFrame, "BOTTOM", 0, -18)
        L.regions.subRegion[k].text4:SetText(("%s"):format(maps.score or ""))
        L.regions.subRegion[k].text4:SetTextColor(r,g,b, 1)
        -- end
        
        L.regions.subRegion[k].icon:SetAllPoints()
        L.regions.subRegion[k].icon:SetTexture(maps.icon)

        if spellID then
            local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID)
            L.regions.subRegion[k].cooldown:SetAllPoints()
            L.regions.subRegion[k].cooldown:SetAttribute("spell", L.dungeonTeleportSpellName[maps.mapID])
            if spellCooldownInfo.isEnabled then
                L.regions.subRegion[k].cooldown:SetCooldown(spellCooldownInfo.startTime, spellCooldownInfo.duration, spellCooldownInfo.modRate)
                L.regions.subRegion[k].cooldown:SetHideCountdownNumbers(true)
            end
        end
        
        L.regions.subRegion[k].buttonFrame:Show()
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
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

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
    PVEFrame:HookScript("onShow",showFrame)
    PVEFrame:HookScript("onHide",hideFrame)
else 
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, addOn)
        if addOn == "Blizzard_PVEUI" then
            PVEFrame:HookScript("onShow",showFrame)
            PVEFrame:HookScript("onHide",hideFrame)
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

    if event == "SPELL_UPDATE_COOLDOWN" then
        local spellId = ...
        if spellInTable(spellId) then
            updateCooldown(spellId)
        end
    end
end)
