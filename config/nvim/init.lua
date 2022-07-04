require'packer'.startup(function()
	use 'wbthomason/packer.nvim'
	use 'neovim/nvim-lspconfig'
	use {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
	use 'nvim-lualine/lualine.nvim'
	use 'lewis6991/gitsigns.nvim'
	use 'terrortylor/nvim-comment'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip'
	use 'LnL7/vim-nix'
end)

require'lualine'.setup{options={icons_enabled=false}}
require'nvim-treesitter.configs'.setup{
	highlight={enable=true,	additional_vim_regex_highlighting = false},
	indent={enable=true}
}
require'lspconfig'.pyright.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.rnix.setup{}
require('nvim_comment').setup({create_mappings=false})
require('gitsigns').setup()

vim.cmd[[ 
	hi SignColumn ctermbg=0 
	hi LineNr ctermbg=0
]]

--save file
vim.keymap.set('n', '<C-S>', ':w<CR>', {remap=false})
vim.keymap.set('i', '<C-S>', '<C-O>:w<CR>', {remap=false})

--other mappings
vim.keymap.set('n', '<C-/>', ':CommentToggle<CR>', {remap=false, silent=true})
vim.keymap.set('v', '<C-/>', ":'<,'>CommentToggle<CR>", {remap=false, silent=true})
vim.keymap.set('n', '<Space>p', '<cmd>lua vim.lsp.buf.formatting()<CR>', {remap=false})

--options
vim.go.clipboard = "unnamedplus"
vim.wo.number = true
vim.o.ignorecase = true
vim.o.smartcase = true


-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
require('cmp_nvim_lsp').update_capabilities(capabilities)


-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
