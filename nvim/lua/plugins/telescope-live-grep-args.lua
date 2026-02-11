return {
  -- Snacks picker의 <leader>/ 비활성화
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>/", false },
    },
  },
  -- live_grep_args로 대체
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local telescope = require("telescope")
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup({
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --glob=" }),
              },
            },
          },
        },
      })

      telescope.load_extension("live_grep_args")
    end,
    keys = {
      {
        "<leader>/",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({ cwd = vim.fn.getcwd() })
        end,
        desc = "Live Grep (with args)",
      },
    },
  },
}
