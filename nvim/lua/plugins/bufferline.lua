return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependecies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					indicator = {
						style = "underline",
					},
					diagonstics = "nvim-lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						return "(" .. count .. ")"
					end,
					always_show_bufferline = false,
					separator_style = "thick",
					hover = {
						enabled = true,
						delay = 200,
						reveal = { "close" },
					},
				},
			})
			vim.cmd("set termguicolors")
		end,
	},
}
