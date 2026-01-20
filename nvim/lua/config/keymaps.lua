local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local keymap_api = vim.keymap.set
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "j", "k", opts)
keymap("n", "k", "j", opts)
keymap("n", "<C-Left>", "<C-w>h", opts)
keymap("n", "<C-Down>", "<C-w>j", opts)
keymap("n", "<C-Up>", "<C-w>k", opts)
keymap("n", "<C-Right>", "<C-w>l", opts)

--keymap("n", "<leader>e", ":Lex 30<cr>", opts)
keymap("n", "<leader>e", ":Neotree toggle filesystem left<CR>", {})
-- Resize with arrows
keymap("n", "<C-j>", ":resize +2<CR>", opts)
keymap("n", "<C-k>", ":resize -2<CR>", opts)
keymap("n", "<C-l>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-h>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<S-Right>", ":bnext<CR>", opts)
keymap("n", "<S-Left>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
--keymap("i", "jk", "<ESC>", opts)
keymap("i", "[", "[]<Left>", opts)
keymap("i", "{", "{}<Left>", opts)
keymap("i", "(", "()<Left>", opts)
keymap("i", "<", "<><Left>", opts)
keymap("i", '"', '""<Left>', opts)
keymap("i", "'", "''<Left>", opts)

--keymap("i", "{", "{}",opts)--
-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<C-Down>", ":m +1<CR>==", opts)
keymap("v", "<C-Up>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
--keymap("x", "K", ":move '>+1<CR>gv-gv", opts)
--keymap("x", "J", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<C-Down>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<C-Up>", ":move '<-2<CR>gv-gv", opts)

--- Better dir navigation ---
keymap("n", "<leader>cc", "<cmd>cd %:h <CR>", opts) --- change CWD to current dir


-- Terminal --
keymap("n", "<leader>tv", "<cmd>ToggleTerm size=20 direction=vertical<CR>", { desc = "Toggle vertical terminal" })
keymap("n", "<leader>th", "<cmd>ToggleTerm size=20 direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
keymap("n", "<leader>tf", "<cmd>ToggleTerm size=20 direction=float<CR>", { desc = "Toggle floating terminal" })
-- Better terminal navigation
keymap("t", "<ESC>", "<C-\\><C-n>", term_opts)
keymap("t", "<C-j>", "<cmd>resize +2 <CR>", term_opts)
keymap("t", "<C-k>", "<cmd>resize -2 <CR>", term_opts)
keymap("t", "<C-l>", "<cmd>vertical resize -2 <CR>", term_opts)
keymap("t", "<C-h>", "<cmd>vertical resize +2 <CR>", term_opts)

--keymap("n","<C-t>", "<cmd> belowright split | terminal <CR> i", term_opts)
--keymap("t","<C-t>", "<C-\\><C-n>:q<CR>", term_opts)
--keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
--keymap("t", "<C-k>", "<C-\\><C-N><C-w>j", term_opts)
--keymap("t", "<C-j>", "<C-\\><C-N><C-w>k", term_opts)
--keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- LSP Keymaps LUA --
keymap_api("n", "gH", vim.lsp.buf.hover, {})
keymap_api("n", "gI", vim.lsp.buf.implementation, {})
keymap_api("n", "gR", vim.lsp.buf.references, {})
keymap_api("n", "gS", vim.lsp.buf.signature_help, {})
keymap_api("n", "gd", vim.lsp.buf.definition, {})
keymap_api("n", "gD", vim.lsp.buf.declaration, {})
keymap_api("n", "<leader>ca", vim.lsp.buf.code_action, {})
keymap_api("n", "gF", vim.lsp.buf.format, {})
keymap_api("n", "gr", vim.lsp.buf.rename, {})
keymap("n", "gE", "<cmd>lua vim.diagnostic.open_float() <CR>", {})

--- Telescope ---
local builtin = require("telescope.builtin")
keymap_api("n", "<leader>ff", builtin.find_files, {})
keymap_api("n", "<leader>fg", builtin.live_grep, {})

--- lazygit ---
keymap("n", "<leader>gg", "<cmd>LazyGit <CR>", {desc='lazygit'})
