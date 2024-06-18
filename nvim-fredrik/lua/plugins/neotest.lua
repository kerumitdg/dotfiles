return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",

      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",

      "nvim-neotest/nvim-nio",

      {
        "echasnovski/mini.indentscope",
        opts = function()
          -- disable indentation scope for the neotest-summary buffer
          vim.cmd([[
        autocmd Filetype neotest-summary lua vim.b.miniindentscope_disable = true
      ]])
        end,
      },
    },
    config = function(_, opts)
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      -- Erase log file.
      -- local filepath = require("neotest.logging"):get_filename()
      -- vim.notify("Erasing Neotest log file: " .. filepath, vim.log.levels.WARN)
      -- vim.fn.writefile({ "" }, filepath)

      -- Set up Neotest.
      require("neotest").setup(opts)

      -- Enable during Neotest adapter development only.
      -- vim.notify("Logging for Neotest enabled", vim.log.levels.TRACE)
      -- require("neotest.logging"):set_level(vim.log.levels.INFO)
    end,
    keys = require("config.keymaps").setup_neotest_keymaps(),
  },
}
