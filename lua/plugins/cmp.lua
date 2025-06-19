return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- Fontes de sugestões
    "hrsh7th/cmp-nvim-lsp", -- para o LSP
    "hrsh7th/cmp-buffer",   -- para palavras no buffer atual
    "hrsh7th/cmp-path",     -- para caminhos de arquivos

    -- Snippets
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets", -- uma ótima coleção de snippets
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Carrega os snippets da coleção "friendly-snippets"
    require("luasnip.loaders.from_vscode").lazy_load()
 
    cmp.setup({
      -- Prioriza snippets nas sugestões
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- Mapeamento de teclas (ESSENCIAL!)
      mapping = cmp.mapping.preset.insert({
        -- Navegar entre as sugestões
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        -- Confirmar uma sugestão
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- Rolar a documentação da sugestão
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        -- Fechar a janela de autocompletar
        ['<C-e>'] = cmp.mapping.abort(),
                -- Mapeamento para abrir a janela de snippets
        ['<C-l>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp.complete({ config = { sources = { { name = 'luasnip' } } } })
            end
        end,
      }),
      -- Ordem das fontes de sugestões
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
    end,
}
