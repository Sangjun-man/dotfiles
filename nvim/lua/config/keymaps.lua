-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Zoom toggle: 현재 창 최대화/복구
vim.keymap.set("n", "<leader>z", function()
  Snacks.zen.zoom()
end, { desc = "Zoom Window" })
