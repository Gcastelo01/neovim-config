return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      local ensure_installed = {
        "lua_ls",
        "basedpyright",
        "ruff",
      }

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
      })

      local lspconfig = require("lspconfig")
      -- VERSÃO NOVA E CORRETA (substitua a linha antiga por este bloco)

      -- Montando as 'capabilities' do cliente Neovim
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- (A LINHA MAIS IMPORTANTE)
      -- Diz aos servidores que esta é a nossa ordem de preferência para "réguas".
      -- A maioria dos servidores modernos escolherá a primeira da lista: "utf-8".
      capabilities.general.positionEncodings = { "utf-8", "utf-16" }

      -- Agora, junta as nossas capabilities (com a regra do utf-8)
      -- com as capabilities específicas do nvim-cmp para o autocompletar funcionar.
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)


      local servers = {
        lua_ls = {},
        basedpyright = {},
      }

      for server, config in pairs(servers) do
        -- Adiciona lógica que roda quando o LSP anexa a um buffer
        config.on_attach = function(client, bufnr)
          -- Habilita formatação com ruff ao salvar arquivos Python
          if client.name == "basedpyright" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  filter = function(c) return c.name == "ruff" end,
                  timeout_ms = 5000,
                })
              end,
            })
          end

          -- Atalhos comuns do LSP para ter funcionalidades de IDE
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "Ver documentação (Hover)" })
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "Ir para Definição" })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = "Ver Referências" })
          vim.keymap.set('n', '<leader>gl', vim.diagnostic.open_float, {buffer = bufnr, desc = "Ver diagnóstico flutuante"})
        end

        -- Define as 'capabilities' para o servidor
        config.capabilities = capabilities

        -- Ativa o servidor com as configurações definidas
        lspconfig[server].setup(config)
      end

    end,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    end
  }
}
