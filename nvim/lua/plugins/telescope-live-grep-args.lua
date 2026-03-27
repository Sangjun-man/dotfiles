return {
  -- Snacks picker의 <leader>/ 비활성화
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>/", false },
    },
  },
  -- telescope-live-grep-args 비활성화 (grug-far로 대체)
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    enabled = false,
  },
}
