
local C_BattleNet, IsFriend, find, tremove = C_BattleNet, C_FriendList.IsFriend, string.find, table.remove
local issecretvalue = issecretvalue or function() return false end
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

	local filter = function(_,event,msg,player,_,_,_,flag,chanid,_,_,_,_,guid)
		if issecretvalue(player) then return end
		if event == "CHAT_MSG_CHANNEL" and (chanid == 0 or type(chanid) ~= "number") then return end -- Only scan official custom channels (gen/trade)
		if not guid then return end

		local isBnetFriend
		if C_BattleNet then -- Retail
			isBnetFriend = C_BattleNet.GetGameAccountInfoByGUID(guid)
		else -- XXX classic compat
			local _, bNetFriend = BNGetGameAccountInfoByGUID(guid)
			isBnetFriend = bNetFriend
		end

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
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", filter)

	frame:SetScript("OnEvent", nil)
	frame:UnregisterEvent("ADDON_LOADED")
end)

function capitalize(s)
    return (s:gsub("^%l", string.upper))
end

function SlashCmdList.BBIGNORE(msg)
	if msg == nil or msg == "" then
		print("[BadBoy] Player name is required")
		return
	end

    local player = capitalize(msg)
    if not find(player, "-", nil, true) then
        local realm = GetRealmName()
        player = player .. "-" .. realm
    end

	if BADBOY_IGNORE[player] then
		print("[BadBoy] " .. player .. " is already ignored")
		return
	end

    print("[BadBoy] Ignoring " .. player)
    BADBOY_IGNORE[player] = true
end
SLASH_BBIGNORE1 = "/bbi"

function SlashCmdList.BBUNIGNORE(msg)
	if msg == nil or msg == "" then
		print("[BadBoy] Player name is required")
		return
	end

    local player = capitalize(msg)
    if not find(player, "-", nil, true) then
        local realm = GetRealmName()
        player = player .. "-".. realm
    end

	if not BADBOY_IGNORE[player] then
		print("[BadBoy] " .. player .. " isn't ignored")
		return
	end

    print("[BadBoy] Unignoring " .. player)
    BADBOY_IGNORE[player] = nil
end
SLASH_BBUNIGNORE1 = "/bbu"
