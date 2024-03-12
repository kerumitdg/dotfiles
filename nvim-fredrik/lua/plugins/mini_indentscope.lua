return {

  {
    "echasnovski/mini.indentscope",
    version = "*",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },
}