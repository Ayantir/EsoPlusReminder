
local ADDON_NAME = "EsoPlusReminder"
local original_GetUnitBuffInfo = GetUnitBuffInfo

function GetUnitBuffInfo(unitTag, buffIndex)
	local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = original_GetUnitBuffInfo(unitTag, buffIndex)
	if unitTag == "player" and abilityId == 63601 and ESO_PLUS_REMINDER and ESO_PLUS_REMINDER[1] and ESO_PLUS_REMINDER[1] > GetTimeStamp() then
		timeStarted = GetFrameTimeSeconds()
		timeEnding = timeStarted + ESO_PLUS_REMINDER[1] - GetTimeStamp()
	end
	return buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer
end

local function OnAddonLoaded(_, addonName)

	local function RegisterESOPlusSubscription(arg)
		
		local currentTime = GetTimeStamp()
		local secondsSinceMidnight = GetSecondsSinceMidnight()
		local today = currentTime - secondsSinceMidnight
		
		if arg ~= "" then
			local days = string.gsub(arg, "[^%d]", "")
			days = tonumber(days)
			local target = 3600 * 24 * days
			ESO_PLUS_REMINDER = {today + target}
		else
			ESO_PLUS_REMINDER = {}
		end
	end
	
	if addonName == ADDON_NAME then
		SLASH_COMMANDS["/eso"] = RegisterESOPlusSubscription
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
	end
	
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)