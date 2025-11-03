local _, addon = ...

    

addon.regions = {
    subRegion = {}
}

addon.config = {
    sortByScore = true,
    buttonSettings = {
        buttonDimension = {
            x = 59,
            y = 59,
            spacing = 1
        },
        borderDimension = {
            borderWidth = 15
        },
        backdropInfo = {
            bgFile = "Interface/Tooltips/UI-Tooltip-Background", -- A tiled background texture
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",   -- The 8-slice edge texture
            edgeSize = 15,                                      -- The thickness of the border
            insets = { left = 2, right = 2, top = 2, bottom = 2 } -- Padding inside the border
        },
        textSettings = {
            text1 = {
                font = "Fonts\\FRIZQT__.TTF",
                size = 17,
            },
            text2 = {
                font = "Fonts\\FRIZQT__.TTF",
                size = 30,
            },
            text3 = {
                font = "Fonts\\FRIZQT__.TTF",
                size = 20,
            },
            text4 = {
                font = "Fonts\\FRIZQT__.TTF",
                size = 12,
            },
        }
    }
}

addon.dungeonStates = {}

addon.dungeonNames = {
    
    -- Cata
    [438] = "VP",
    [507] = "GB", -- Grim Batol
    
    -- MOP
    [2] = "TJS",
    
    -- WoD
    [165] = "SBG",
    [166] = "GD",
    [169] = "ID",
    
    -- Legion
    [200] = "HoV",
    [206] = "NL",
    [210] = "CoS",
    [227] = "LOWR",
    [234] = "UPPR",
    
    -- BFA
    [239] = "SotT",  -- Seat of the Triumvirate
    [244] = "AD",    -- Atal'Dazar
    [245] = "FH",    -- Freehold
    [246] = "TD",    -- Tol Dagor
    [247] = "ML",    -- The MOTHERLODE!!
    [248] = "WCM",   -- Waycrest Manor
    [249] = "KR",    -- Kings' Rest
    [250] = "ToS",   -- Temple of Sethraliss
    [251] = "UR",    -- The Underrot
    [252] = "SotS",  -- Shrine of the Storm
    [353] = "SoB",   -- Siege of Boralus
    [369] = "Yard",
    [370] = "Work",
    
    -- SL
    [375] = "MotS",
    [376] = "NW",
    [377] = "DoS",
    [378] = "HoA",
    [379] = "PF",
    [380] = "SD",
    [381] = "SoA",
    [382] = "ToP",
    [391] = "Strt",
    [392] = "Gmbt",
    
    -- DF
    [399] = "RLP",
    [400] = "NO",
    [401] = "AV",
    [402] = "AA",
    [405] = "BH",
    [404] = "NELT",
    [403] = "ULD",
    [406] = "HOI",
    
    -- TWW S1
    [499] = "PotSF", -- Priory of the Sacred Flame
    [500] = "RO",    -- The Rookery
    [501] = "SV",    -- The Stonevault
    [502] = "CoT",   -- City of Threads
    [503] = "AraK",  -- Ara-Kara, City of Echoes
    [504] = "DC",    -- Darkflame Cleft
    [505] = "Dawn",  -- Dawnbreaker
    [506] = "CM",    -- Cinderbrew Meadery
    
    -- TWW S2
    [499] = "PotSF", -- Priory of the Sacred Flame
    [500] = "RO",    -- The Rookery
    [504] = "DC",    -- Darkflame Cleft
    [506] = "CM",    -- Cinderbrew Meadery
    [525] = "OF",    -- Operation: Floodgate
    [247] = "ML",    -- The MOTHERLODE!!
    [382] = "ToP",   -- Theater of Pain
    [370] = "Work",  -- Operation: Mechagon - Workshop
    
    -- TWW S3
    [505] = "Dawn",  -- Dawnbreaker
    [391] = "Strt",  -- Tazavesh: Streets of Wonder
    [392] = "Gmbt",  -- Tazavesh: So'Leah's Gambit
    [499] = "PotSF", -- Priory of the Sacred Flame    
    [525] = "OF",    -- Operation: Floodgate    
    [378] = "HoA",   -- Halls of Atonement
    [542] = "Dome",  -- Eco-Dome Al'dani  
    [503] = "AraK",  -- Ara-Kara, City of Echoes    
}

addon.dungeonTeleportSpellName = {
    -- TWW S3
    [378] = "Path of the Sinful Soul",
    [391] = "Path of the Streetwise Merchant",
    [392] = "Path of the Streetwise Merchant",
    [499] = "Path of the Light's Reverence",
    [503] = "Path of the Ruined City",
    [505] = "Path of the Arathi Flagship",
    [525] = "Path of the Circuit Breaker",
    [542] = "Path of the Eco-Dome",

}
addon.dungeonTeleportSpellID = {
    -- TWW S3
    [378] = 354465,
    [391] = 367416,
    [392] = 367416,
    [499] = 445444,
    [503] = 445417,
    [505] = 445414,
    [525] = 1216786,
    [542] = 1237215,
}



addon.colors = {
    [0]  = {r=157, g=157, b=157}, -- Grey
    [5]  = {r=255, g=255, b=255}, -- Common
    [10] = {r=30, g=255, b=0}, -- Uncommon
    [15] = {r=93, g=156, b=217}, -- Rare (blue, adjusted),
    [20] = {r=185, g=116, b=232}, -- Epic (purple, adjusted)
    [25] = {r=255, g=128, b=0}, -- Leggy
    [28] = {r=226, g=104, b=168}, -- astounding
    [30] = {r=229, g=204, b=128}, -- artifact
    [32] = {r=0, g=204, b=255}, -- heirloom
    [36] = {r=255, g=0, b=0}, -- deadge
    [40] = {r=255, g=255, b=255}, -- deadge2
}

addon.color_deplete = {r=195, g=195, b=195}