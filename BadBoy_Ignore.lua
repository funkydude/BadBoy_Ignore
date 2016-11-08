
local BadBoyIsFriendly, find, tremove = BadBoyIsFriendly, string.find, table.remove
local names = {}

do
	local _, tbl = ...
	tbl.names = names
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(frame, _, addon)
	if addon ~= "BadBoy_Ignore" then return end
	if type(BADBOY_IGNORE) ~= "table" then
		BADBOY_IGNORE = {}
	end

	local BADBOY_IGNORE, realm = BADBOY_IGNORE, GetRealmName()
	realm = "-".. realm

	local filter = function(_,event,msg,player,_,_,_,flag,chanid,_,_,_,lineId,guid)
		if event == "CHAT_MSG_CHANNEL" and (chanid == 0 or type(chanid) ~= "number") then return end --Only scan official custom channels (gen/trade)
		if BadBoyIsFriendly("", flag, lineId, guid) then return end
		if not find(player, "-", nil, true) then
			player = player..realm
		end
		if BADBOY_IGNORE[player] then
			if BadBoyLog then BadBoyLog("Ignore", event, Ambiguate(player, "none"), msg) end
			return true
		else
			for i=1, #names do
				if names[i] == player then return end
				if i == 20 then
					tremove(names, 1)
				end
			end
			names[#names+1] = player
		end
	end
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)

	frame:SetScript("OnEvent", nil)
	frame:UnregisterEvent("ADDON_LOADED")
end)

