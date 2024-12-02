-- Set up path for lazy to set
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- if Lazy not present, clone and get It
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"https://github.com/folke/lazy.nvim",
		"--branch=stable", --latest stable
		lazypath,
	})
end

--prepend it to the path
vim.opt.rtp:prepend(lazypath)

--- files we need to load 
require("vim-cmd") --- load vim commands
require("lazy").setup("plugins") --- load plugins
require("config/keymaps") --- load keymaps
