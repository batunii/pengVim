return {
	"nvimtools/none-ls.nvim", --- null_ls or none_ls is required so that formatters and linters can work like LSPs, this allows us to get even better completions and formatting.
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua, --- especially helpful for dynamic langs
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
--				null_ls.builtins.completion.spell,
				null_ls.builtins.formatting.prettier,
				--				null_ls.builtins.diagnostics.eslint_d,
			},
		})
	end,
}
