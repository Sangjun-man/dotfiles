-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

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

-- 한글 IME 자동 전환 (im-select 사용, macOS 전용)
local im_select = "/opt/homebrew/bin/im-select"
local default_im = "com.apple.keylayout.ABC"

if vim.fn.executable(im_select) == 1 then
  -- InsertLeave/CmdlineEnter 시 저장할 이전 IME 상태
  local saved_im = default_im

  local im_group = vim.api.nvim_create_augroup("ImSelect", { clear = true })

  -- Insert 모드 나갈 때: 현재 IME 저장 후 영문으로 전환
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = im_group,
    callback = function()
      -- 현재 IME 상태 동기로 읽어야 정확함
      saved_im = vim.fn.system(im_select):gsub("\n", "")
      -- 영문으로 전환은 비동기로 (블로킹 방지)
      vim.fn.jobstart({ im_select, default_im })
    end,
  })

  -- Insert 모드 진입 시: 저장해둔 IME 상태 복원
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = im_group,
    callback = function()
      -- 이전에 한글이었을 때만 복원 (불필요한 im-select 호출 방지)
      if saved_im ~= default_im then
        vim.fn.jobstart({ im_select, saved_im })
      end
    end,
  })

  -- 커맨드라인 진입 시: 현재 IME 저장 후 영문으로 전환
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    group = im_group,
    callback = function()
      saved_im = vim.fn.system(im_select):gsub("\n", "")
      vim.fn.jobstart({ im_select, default_im })
    end,
  })

  -- 커맨드라인 나갈 때: 저장해둔 IME 상태 복원
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = im_group,
    callback = function()
      if saved_im ~= default_im then
        vim.fn.jobstart({ im_select, saved_im })
      end
    end,
  })
end
