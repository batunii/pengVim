return {
	"nvim-treesitter/nvim-treesitter", --- this is for good highlighting of code
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			--				ensure_installed= {"lua", "javascript", "python", "java", "c", "html", "java"},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
