return {
	{
		"williamboman/mason.nvim",
		opts = { --- not calling config here because need nvim java
			registries = { --- extra registeries to download jdtls
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
			--- testing clang stuff

			---
			local capabilities = require("cmp_nvim_lsp").default_capabilities() --- getting those lsp completions from completions.lua
			vim.lsp.config("lua_ls", { capabilities = capabilities })
			vim.lsp.enable("lua_ls")

			vim.lsp.config("lua_ls", { capabilities = capabilities })
			vim.lsp.enable("lua_ls")
			vim.lsp.config("pyright", { capabilities = capabilities })
			vim.lsp.enable("pyright")
			vim.lsp.config("ts_ls", { capabilities = capabilities })
			vim.lsp.enable("ts_ls")
			vim.lsp.config(
				"clangd",
				{ capabilities = capabilities, cmd = { "clangd", "--query-driver=/usr/bin/clang" } }
			)
			vim.lsp.enable("clangd")
			--		lspconfig.lua_ls.setup({
			--			capabilities = capabilities,
			--		})
			--			lspconfig.ts_ls.setup({
			--				capabilities = capabilities,
			--			})
			--			lspconfig.pyright.setup({
			--				capabilities = capabilities,
			--			})
			--			lspconfig.clangd.setup({
			--				capabilities = capabilities,
			--				cmd = {"clangd", "--query-driver=/usr/bin/clang"}
			--			})
			--			lspconfig.gopls.setup({
			--				capabilities = capabilities,
			--			})
		end,
	},
}
