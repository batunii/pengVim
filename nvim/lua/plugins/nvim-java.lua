return {
	"nvim-java/nvim-java",
	config = function()
		require("java").setup()
		local capabilities = require("cmp_nvim_lsp").default_capabilities() --- same from completions.lua and lsp-config.lua
		require("lspconfig").jdtls.setup({
			capabilities = capabilities,
		})
	end,
}
