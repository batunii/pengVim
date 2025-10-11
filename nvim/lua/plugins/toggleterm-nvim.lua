return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        -- You can configure your preferences here, e.g., direction and size
        direction = "horizontal",
        size = 20,
        open_mapping = [[<c-t>]], -- default toggle keybinding
      })
    end,
  },
}
