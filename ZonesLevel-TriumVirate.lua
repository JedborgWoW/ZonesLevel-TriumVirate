ZR_VERSION_MAJOR = "1"
ZR_VERSION_MINOR = "0"
ZR_VERSION_PATCH = "0"

ZR_LEVELRANGES = {
    -- Kalimdor
    [1001] = { "Durotar", 1, 10 },
    [1002] = { "Mulgore", 1, 10 },
    [1003] = { "Teldrassil", 1, 10 },
    [1004] = { "Orgrimmar", 1, 10, true },
    [1005] = { "Azuremyst Isle", 1, 10 },
    [1006] = { "Bloodmyst Isle", 10, 17 },
    [1007] = { "Darkshore", 10, 17 },
    [1008] = { "The Barrens", 10, 21 },
    [1009] = { "Stonetalon Mountains", 11, 23 },
    [1010] = { "Ashenvale", 15, 26 },
    [1011] = { "Thousand Needles", 21, 30 },
    [1012] = { "Desolace", 26, 34 },
    [1013] = { "Dustwallow Marsh", 30, 39 },
    [1014] = { "Feralas", 34, 43 },
    [1015] = { "Tanaris", 34, 43 },
    [1016] = { "Azshara", 39, 48 },
    [1017] = { "Un'Goro Crater", 41, 48 },
    [1018] = { "Felwood", 41, 48 },
    [1019] = { "Winterspring", 46, 50 },
    [1020] = { "Silithus", 48, 50 },

    -- Eastern Kingdoms
    [2001] = { "Elwynn Forest", 1, 10 },
    [2002] = { "Eversong Woods", 1, 10 },
    [2003] = { "Dun Morogh", 1, 10 },
    [2004] = { "Tirisfal Glades", 1, 10 },
    [2005] = { "Ghostlands", 10, 17 },
    [2006] = { "Westfall", 10, 17 },
    [2007] = { "Loch Modan", 10, 17 },
    [2008] = { "Silverpine Forest", 10, 17 },
    [2009] = { "Redridge Mountains", 13, 21 },
    [2010] = { "Duskwood", 17, 26 },
    [2011] = { "Hillsbrad Foothills", 17, 26 },
    [2012] = { "Wetlands", 17, 26 },
    [2013] = { "Arathi Highlands", 26, 34 },
    [2014] = { "Alterac Mountains", 26, 34 },
    [2015] = { "Stranglethorn Vale", 26, 39 },
    [2016] = { "Badlands", 30, 39 },
    [2017] = { "Swamp of Sorrows", 30, 39 },
    [2018] = { "The Hinterlands", 34, 43 },
    [2019] = { "Searing Gorge", 34, 43 },
    [2020] = { "Blasted Lands", 41, 48 },
    [2021] = { "Burning Steppes", 43, 49 },
    [2022] = { "Western Plaguelands", 43, 49 },
    [2023] = { "Eastern Plaguelands", 46, 50 },
    [2024] = { "Deadwind Pass", 48, 50 },
    [2025] = { "Isle of Quel'Danas", 54, 56 },

    -- Outland
    [3001] = { "Hellfire Peninsula", 49, 51 },
    [3002] = { "Zangarmarsh", 49, 51 },
    [3003] = { "Terokkar Forest", 50, 52 },
    [3004] = { "Nagrand", 51, 53 },
    [3005] = { "Blade's Edge Mountains", 52, 54 },
    [3006] = { "Netherstorm", 53, 55 },
    [3007] = { "Shadowmoon Valley", 53, 55 },

    -- Northrend
    [4001] = { "Borean Tundra", 54, 56 },
    [4002] = { "Howling Fjord", 54, 56 },
    [4003] = { "Dragonblight", 54, 57 },
    [4004] = { "Grizzly Hills", 56, 58 },
    [4005] = { "Zul'Drak", 56, 58 },
    [4006] = { "Sholazar Basin", 57, 59 },
    [4007] = { "Crystalsong Forest", 57, 60 },
    [4008] = { "The Storm Peaks", 58, 60 },
    [4009] = { "Icecrown", 58, 60 },
}

ZR_COLORS = {
    Gray = { 0.50, 0.50, 0.50 },
    Green = { 0.25, 0.74, 0.25 },
    Yellow = { 1.0, 1.0, 0.0 },
    Orange = { 1.0, 0.50, 0.25 },
    Red = { 0.86, 0.13, 0.13 },
}

local zoneNameToID = {}
local zoneNameToRange = {}

local function buildZoneMaps()
    for id, data in pairs(ZR_LEVELRANGES) do
        local name = data[1]

        zoneNameToID[name] = id
        zoneNameToRange[name] = { data[2], data[3] }
    end
end

local function getZoneColor(zoneMin, zoneMax)
    local avg = floor((zoneMax - zoneMin) / 2) + zoneMin
    local diff = avg - UnitLevel("player")

    if diff > 4 then
        return ZR_COLORS.Red
    elseif diff > 2 then
        return ZR_COLORS.Orange
    elseif diff > -3 then
        return ZR_COLORS.Yellow
    elseif diff > -12 then
        return ZR_COLORS.Green
    else
        return ZR_COLORS.Gray
    end
end

local function updateZoneDisplay()
    if not WorldMapFrameAreaDescription then
        return
    end

    local areaName = nil

    if WorldMapFrame.areaName and WorldMapFrame.areaName ~= "" then
        areaName = WorldMapFrame.areaName
    elseif WorldMapFrameAreaLabel then
        local labelText = WorldMapFrameAreaLabel:GetText()

        if labelText and labelText ~= "" then
            areaName = labelText
        end
    end

    if not areaName or areaName == "" then
        WorldMapFrameAreaDescription:SetText("")

        return
    end

    local zoneID = zoneNameToID[areaName]

    if zoneID and ZR_LEVELRANGES[zoneID][4] and GetCurrentMapZone() ~= 0 then
        WorldMapFrameAreaDescription:SetText("")

        return
    end

    local range = zoneNameToRange[areaName]

    if range then
        local color = getZoneColor(range[1], range[2])

        WorldMapFrameAreaDescription:SetTextColor(color[1], color[2], color[3])
        WorldMapFrameAreaDescription:SetText("(" .. range[1] .. "-" .. range[2] .. ")")
    else
        WorldMapFrameAreaDescription:SetTextColor(1, 1, 1)
        WorldMapFrameAreaDescription:SetText("")
    end
end

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "ZonesLevel-TriumVirate" then
        WorldMapButton:HookScript("OnUpdate", updateZoneDisplay)
        buildZoneMaps()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
