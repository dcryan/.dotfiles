local lsp = require("lsp-zero")
local cmp = require("cmp")

lsp.preset("lsp-only")

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'pyright',
  'prismals',
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>gca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>gf", function() vim.lsp.buf.formatting() end, opts)


  -- Copied from ThePrimeagen
  -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.set_preferences({
  sign_icons = { }
})

lsp.setup_nvim_cmp({
  sources = {
    -- This one provides the data from copilot.
    {name = 'copilot'},

    --- These are the default sources for lsp-zero
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 3},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  mapping = lsp.defaults.cmp_mappings({
    ['<CR>'] = cmp.mapping.confirm({
      -- documentation says this is important.
      -- I don't know why.
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    })
  })
})

lsp.setup()

vim.api.nvim_create_autocmd(
"BufWritePre",
{
  pattern = "*.ts,*.tsx,*.js,*.jsx",
  command = "EslintFixAll",
})

