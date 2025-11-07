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
    [438] = "VP",   -- Vortex Pinnacle
    [456] = "ToT",   -- Throne of the Tides
    [507] = "GB",   -- Grim Batol

    -- MoP
    [2] = "TJS",    -- Temple of the Jade Serpent
    -- Warlords
    [165] = "SBG",  -- Shadowmoon Burial Grounds
    [166] = "GD",   -- Grimrail Depot
    [169] = "ID",   -- Iron Docks
    --Legion
    [198] = "DT",   -- Darkheart Thicket
    [199] = "BRH",  -- Blackrook Hold
    [200] = "HoV",  -- Halls of Valor
    [206] = "NL",   -- Neltharion's Lair
    [210] = "CoS",  -- Court of Stars
    [227] = "LOWR", -- Lower Karazhan
    [234] = "UPPR", -- Uppper Karazhan
    -- BFA
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
    [369] = "Yard",  -- Operation: Mechagon - JunkYard
    [370] = "Work",  -- Operation: Mechagon - Workshop
    -- Shadowmoon
    [375] = "MotS", -- Mists of Tirna Scythe
    [376] = "NW",   -- Necrotic Wake
    [377] = "DoS",  -- De Other Side
    [379] = "PF",   -- Plaugefall
    [380] = "SD",   -- Sanguine Depths
    [381] = "SoA",  -- Spires of Ascension
    [382] = "ToP",  -- Theater of Pain
    -- Dragonflight
    [399] = "RLP",  -- Ruby Life Pools
    [400] = "NO",   -- The Nokhud Offensive
    [401] = "AV",   -- The Azure Vaults
    [402] = "AA",   -- Algeth'ar Academy
    [405] = "BH",   -- Brackenhide Hollow
    [404] = "NELT", -- Neltharus
    [403] = "ULD",  -- Uldaman: Legacy of Tyr
    [406] = "HOI",  -- Hall of Infusion
    [463] = "Fall",  -- Dawn of the Infinite: Galakrond's Fall
    [464] = "Rise",  -- Dawn of the Infinite: Murozond's Rise
    -- TWW
    [500] = "RO",    -- The Rookery
    [501] = "SV",    -- The Stonevault
    [502] = "CoT",   -- City of Threads
    [504] = "DC",    -- Darkflame Cleft
    [506] = "CM",    -- Cinderbrew Meadery
    
    -- TWW S3
    [378] = "HoA",   -- Halls of Atonement
    [391] = "Strt",  -- Tazavesh: Streets of Wonder
    [392] = "Gmbt",  -- Tazavesh: So'Leah's Gambit
    [499] = "PotSF", -- Priory of the Sacred Flame    
    [503] = "AraK",  -- Ara-Kara, City of Echoes    
    [505] = "Dawn",  -- Dawnbreaker
    [525] = "OF",    -- Operation: Floodgate    
    [542] = "Dome",  -- Eco-Dome Al'dani  
    
    -- MID S1
    [161] = "Sky",    -- Skyreach
    [239] = "SotT",  -- Seat of the Triumvirate
    -- [556] = "PoS",   -- Pit of Saron
    -- [557] = "WS",    -- Windrunner Spire
    -- [558] = "MT",    -- Magister's Terrace
    -- [559] = "NPX",   -- Nexus-Point Xenas
    -- [560] = "MC",    -- Maisara Caverns
}

addon.legionRemixDungeonsMapIDs = {
    198,199,200,206,210,227,234,
}

addon.dungeonTeleportSpellName = {
    [438] = "Path of Wind's Domain",   -- Vortex Pinnacle
    [456] = "Path of the Tidehunter", -- Throne of the Tides
    [507] = "Path of the Twilight Fortress",   -- Grim Batol
    [2] = "Path of the Jade Serpent",    --Temple of the Jade Serpent
    [165] = "Path of the Crescent Moon",  -- Shadowmoon Burial Grounds
    [166] = "Path of the Dark Rail",   -- Grimrail Depot
    [169] = "Path of the Iron Prow",   -- Iron Docks
    [200] = "Path of Proven Worth",  -- Halls of Valor
    [206] = "Path of the Earth-Warder",   -- Neltharion's Lair
    [210] = "Path of the Grand Magistrix",  -- Court of Stars
    [227] = "Path of the Fallen Guardian", -- Lower Karazhan
    [234] = "Path of the Fallen Guardian", -- Uppper Karazhan
    [198] = "Path of the Nightmare Lord",   -- Darkheart Thicket
    [199] = "Path of Ancient Horrors",  -- Blackrook Hold
    [244] = "Path of the Golden Tomb",    -- Atal'Dazar
    [245] = "Path of the Freebooter",    -- Freehold
    -- [246] = "Path of the ",    -- Tol Dagor
    [247] = "Path of the Azerite Refinery",    -- The MOTHERLODE!!
    [248] = "Path of Heart's Bane",   -- Waycrest Manor
    -- [249] = "Path of the ",    -- Kings' Rest
    -- [250] = "Path of the ",   -- Temple of Sethraliss
    [251] = "Path of Festering Rot",    -- The Underrot
    -- [252] = "Path of the ",  -- Shrine of the Storm
    [353] = "Path of the Besieged Harbor",   -- Siege of Boralus
    [369] = "Path of the Scrappy Prince",  -- Operation: Mechagon - JunkYard
    [370] = "Path of the Scrappy Prince",  -- Operation: Mechagon - Workshop
    [375] = "Path of the Misty Forest", -- Mists of Tirna Scithe
    [376] = "Path of the Courageous",   -- Necrotic Wake
    [377] = "Path of the Scheming Loa",  -- De Other Side
    [379] = "Path of the Plagued",   -- Plaugefall
    [380] = "Path of the Stone Warden",   -- Sanguine Depths
    [381] = "Path of the Ascendant",  -- Spires of Ascension
    [382] = "Path of the Undefeated",  -- Theater of Pain
    [399] = "Path of the Clutch Defender",  -- Ruby Life Pools
    [400] = "Path of the Windswept Plains",   -- The Nokhud Offensive
    [401] = "Path of the Arcane Secrets",   -- The Azure Vaults
    [402] = "Path of the Draconic Diploma",   -- Algeth'ar Academy
    [405] = "Path of the Rotting Woods",   -- Brackenhide Hollow
    [404] = "Path of the Obsidian Hoard", -- Neltharus
    -- [403] = "Path of the ",  -- Uldaman: Legacy of Tyr
    [406] = "Path of the Titanic Reservoir",  -- Hall of Infusion
    [463] = "Path of Twisted Time",  -- Dawn of the Infinite: Galakrond's Fall
    [464] = "Path of Twisted Time",  -- Dawn of the Infinite: Murozond's Rise
    [501] = "Path of the Corrupted Foundry",    -- The Stonevault
    [502] = "Path of Nerubian Ascension",   -- City of Threads
    [500] = "Path of the Fallen Stormriders",    -- The Rookery
    [504] = "Path of the Warding Candles",    -- Darkflame Cleft
    [506] = "Path of the Flaming Brewery",    -- Cinderbrew Meadery (this has two spells associated with it. Path of the Flaming Brewery and Path of the Waterworks)

    -- TWW S3
    [378] = "Path of the Sinful Soul",
    [391] = "Path of the Streetwise Merchant",
    [392] = "Path of the Streetwise Merchant",
    [499] = "Path of the Light's Reverence",
    [503] = "Path of the Ruined City",
    [505] = "Path of the Arathi Flagship",
    [525] = "Path of the Circuit Breaker",
    [542] = "Path of the Eco-Dome",

    -- MID S1
    -- [239] = "Path of Dark Dereliction",  -- Seat of the Triumvirate
    -- [556] = "Path of Unyielding Blight",   -- Pit of Saron
    -- [557] = "Path of the Windrunner",    -- Windrunner Spire
    -- [558] = "Path of Devoted Magistry",    -- Magister's Terrace
    -- [559] = "Path of Nexus-Point Xenas",   -- Nexus-Point Xenas [PH]
    -- [560] = "Path of the Maisara Caverns",    -- Maisara Caverns [PH]
    -- [161] = "Path of the Crowning Pinnacle",  -- Skyreach
}

addon.dungeonTeleportSpellID = {
    [2]   = 131204,
    [165] = 159899,
    [166] = 159900,
    [169] = 159896,
    [198] = 424163,
    [199] = 424153,
    [200] = 393764,
    [206] = 410078,
    [210] = 393766,
    [227] = 373262,
    [234] = 373262,
    [244] = 424187,
    [245] = 410071,
    -- [246] = 0 ,
    [247] = {
        ["Horde"] = 467555,
        ["Alliance"] = 467553,
    },
    [248] = 424167,
    -- [249] = 0 ,
    -- [250] = 0 ,
    [251] = 410074,
    -- [252] = 0 ,
    [353] = {
        ["Horde"] = 464256,
        ["Alliance"] = 445418,
    },
    [369] = 373274,
    [370] = 373274,
    [375] = 354464,
    [376] = 354462,
    [377] = 354468,
    [379] = 354463,
    [380] = 354469,
    [381] = 354466,
    [382] = 354467,
    [399] = 393256,
    [400] = 393262,
    [401] = 393279,
    [402] = 393273,
    -- [403] = 0 ,
    [404] = 393276,
    [405] = 393267,
    [406] = 393283,
    [438] = 410080,
    [456] = 424142,
    [463] = 424197,
    [464] = 424197,
    [500] = 445443,
    [501] = 445269,
    [502] = 445416,
    [504] = 445441,
    [506] = 445440, -- Path of the Flaming Brewery(445440) -- Path of the Waterworks(467546)
    [507] = 445424,
    -- TWW S3
    [378] = 354465,
    [391] = 367416,
    [392] = 367416,
    [499] = 445444,
    [503] = 445417,
    [505] = 445414,
    [525] = 1216786,
    [542] = 1237215,
    -- MID S1
    -- [161] = 1254557,  -- Skyreach
    -- [239] = 1254551,    -- Seat of the Triumvirate
    -- [556] = 1254556,   -- Pit of Saron
    -- [557] = 1254400,    -- Windrunner Spire
    -- [558] = 1254572,    -- Magister's Terrace
    -- [559] = 1254563,   -- Nexus-Point Xenas [PH]
    -- [560] = 1254559,    -- Maisara Caverns [PH]
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