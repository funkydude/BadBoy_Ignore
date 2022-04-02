std = "lua51"
max_line_length = false
codes = true
ignore = {
	"542", -- (W542) empty if branch
}
globals = {
	-- Main
	"BADBOY_IGNORE",
	"BadBoyLog",
	"C_BattleNet",
	"C_FriendList",
	"ChatFrame_AddMessageEventFilter",
	"GetRealmName",

	-- Options
	"BadBoy_IgnoreAddMiddle",
	"BadBoy_IgnoreAddText",
	"BadBoy_IgnoreRemoveMiddle",
	"BadBoy_IgnoreRemoveText",
	"BadBoyConfig",
	"BadBoyIgnoreConfigTitle",
	"CreateFrame",
	"GetLocale",
	"UIDropDownMenu_AddButton",

	-- Classic
	"BNGetGameAccountInfoByGUID",
}
