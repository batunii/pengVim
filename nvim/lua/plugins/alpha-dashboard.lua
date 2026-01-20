return {
	"goolord/alpha-nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")
		--require'alpha'.setup(require'alpha.themes.theta'.config)
		dashboard.section.header.val = {
"                @@@@@+*@@@@             ",
"              @@@=       #@@            ",
"           @#-     ===:    =@           ",
"           @=       @@=    =@           ",
"          @#-            --*@@@@       ____                        _           ",
"          @-         +%%%@      @     |  _ \\ ___ _ __   __ ___   _(_)_ __ ___  ",
"        @@-            :-@-      @    | |_) / _ \\ '_ \\ / _` \\ \\ / / | '_ ` _ \\ ",
"        @@           .....#@@@@@@     |  __/  __/ | | | (_| |\\ V /| | | | | | | ",
"        @@       -***@   #@@@         |_|   \\___|_| |_|\\__, | \\_/ |_|_| |_| |_|",
"        @@      *#          @@                         |___/                    ",
"        @@@-   %              +@        ",
"      @@@@ ..  %             #  -@@     ",
"     @@      %%@+---------        @@@   ",
"     @@@------@*@         @@-#______*@   ",

				}
		alpha.setup(dashboard.opts)
	end,
}
