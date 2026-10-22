
local C_BattleNet, IsFriend, find, tremove = C_BattleNet, C_FriendList.IsFriend, string.find, table.remove
local issecretvalue = issecretvalue
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
	if not RegionalUniqueNamesEnabled or not RegionalUniqueNamesEnabled() then
		realm = "-".. realm
	else
		realm = ""
	end

	local filter = function(_,event,msg,player,_,_,_,flag,chanid,_,_,_,_,guid)
		if issecretvalue(player) then return end
		if event == "CHAT_MSG_CHANNEL" and (chanid == 0 or type(chanid) ~= "number") then return end -- Only scan official custom channels (gen/trade)
		if not guid then return end

		local isBnetFriend = C_BattleNet.GetGameAccountInfoByGUID(guid)
		if isBnetFriend or IsFriend(guid) or flag == "GM" or flag == "DEV" then return end
		if not find(player, "-", nil, true) then
			player = player..realm
		end
		if BADBOY_IGNORE[player] then
			if BadBoyLog then BadBoyLog("Ignore", event, player, msg) end
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
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_YELL", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_GUILD", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_OFFICER", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_PARTY", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_RAID", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_SAY", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
	ChatFrameUtil.AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", filter)

	frame:SetScript("OnEvent", nil)
	frame:UnregisterEvent("ADDON_LOADED")
end)

