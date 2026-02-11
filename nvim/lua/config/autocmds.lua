-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Markdown: 기본적으로 concealment 비활성화 (``` 백틱 등 표시)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.wo.conceallevel = 0
  end,
})

-- Markdown concealment 토글 키바인딩
vim.keymap.set("n", "<leader>cc", function()
  if vim.wo.conceallevel > 0 then
    vim.wo.conceallevel = 0
    print("Conceal OFF (표시)")
  else
    vim.wo.conceallevel = 2
    print("Conceal ON (숨김)")
  end
end, { desc = "Toggle conceal" })
