-- ~/.config/nvim/lua/plugins/git.lua

return {
  -- GITSIGNS
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        -- Sinais que aparecem na lateral
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
        -- Ações ao clicar nos sinais
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navegação
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "Ir para o próximo hunk" })

          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "Ir para o hunk anterior" })

          -- Ações
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Git Stage Hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Git Reset Hunk" })
          map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git Stage Hunks" })
          map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git Reset Hunks" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Git Stage Buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Git Undo Stage Hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Git Reset Buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Git Preview Hunk" })
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Git Blame Line" })
        end,
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({})
      vim.keymap.set("n", "<leader>gg", function()
        require("neogit").open()
      end, { desc = "Abrir Neogit" })
    end,
  },
}
