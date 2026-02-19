return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- sh 파일 포맷터 비활성화
      opts.formatters_by_ft.sh = {}
      opts.formatters_by_ft.bash = {}

      -- JS/TS: prettier 대신 eslint_d 사용 (.eslintrc 있을 때만)
      local js_ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
      for _, ft in ipairs(js_ft) do
        opts.formatters_by_ft[ft] = { "eslint_d" }
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.eslint_d = {
        condition = function(_, ctx)
          return vim.fs.find({
            ".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
            ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml",
            "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
          }, { path = ctx.filename, upward = true })[1]
        end,
      }
    end,
  },

  -- 허용된 파일타입 외에는 autoformat 비활성화 (LazyVim 방식)
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local allowed = {
            javascript = true, javascriptreact = true,
            typescript = true, typescriptreact = true,
            json = true, jsonc = true,
            css = true, html = true,
            lua = true, markdown = true,
          }
          if not allowed[vim.bo[ev.buf].filetype] then
            vim.b[ev.buf].autoformat = false
          end
        end,
      })
    end,
  },

  -- ESLint: 워크스페이스 설정 파일이 있을 때만 동작하도록 설정
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
      },
    },
  },
}
