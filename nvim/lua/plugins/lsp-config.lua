return {
	{
		"williamboman/mason.nvim",
		opts = {				--- not calling config here because need nvim java
			registries = {		--- extra registeries to download jdtls
				"github:nvim-java/mason-registry",
				"github:mason-org/mason-registry",
			},
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},

		--				config = function()
		--						require("mason").setup()
		--				end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()		--- getting those lsp completions from completions.lua
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
		end,
	},
}
