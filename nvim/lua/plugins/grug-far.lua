return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    { "<leader>/", "<cmd>GrugFar<cr>", desc = "Search & Replace (grug-far)" },
    {
      "<leader>sw",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "Search current word",
    },
    {
      "<leader>/",
      function()
        require("grug-far").with_visual_selection()
      end,
      mode = "v",
      desc = "Search selection",
    },
  },
  opts = {
    engine = "ripgrep",
    -- 기본 제외 패턴 (Files Filter에 자동 적용)
    prefills = {
      filesFilter = "!node_modules/ !.git/ !dist/ !build/",
    },
  },
}
