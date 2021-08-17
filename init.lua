-------- Helpers -------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options
cmd 'packadd paq-nvim'  -- Needs paq https://github.com/savq/paq-nvim

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------- Plugins -------------
local paq = require('paq-nvim').paq
paq { 'savq/paq-nvim', opt = true }      -- Let Paq manage itself
paq {'nvim-treesitter/nvim-treesitter'}
paq { 'neovim/nvim-lspconfig' }
paq { 'hrsh7th/nvim-compe' }
paq { 'nvim-lua/plenary.nvim'}
paq { 'nvim-telescope/telescope.nvim' }
paq { 'lifepillar/vim-solarized8' }
paq { 'hoob3rt/lualine.nvim' }
paq { 'kyazdani42/nvim-web-devicons' }   -- Needs patched font (like Hack Nerd) https://www.nerdfonts.com/font-downloads
paq { 'ryanoasis/vim-devicons' }
paq { 'akinsho/nvim-bufferline.lua' }
paq { 'lewis6991/gitsigns.nvim' }
paq { 'phaazon/hop.nvim' }
paq { 'folke/trouble.nvim' }
paq { 'onsails/lspkind-nvim' }
paq { 'kyazdani42/nvim-tree.lua' }

------- Colours and pretty things -----------
g.solarized_termcolors = 256
cmd('colorscheme solarized8')

require('gitsigns').setup{
  current_line_blame = true,
  current_line_blame_delay = 1000,
  current_line_blame_position = 'eol',
}

require('lualine').setup{
  theme = 'solarized_dark',
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff"},
    lualine_c = {"filename"},
    lualine_x = {
      {"diagnostics", sources = {"nvim_lsp"}},
      "encoding",
      "fileformat",
      "filetype"
    },
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },
}

require('hop').setup()
require('trouble').setup()
require('lspkind').init()
require("bufferline").setup{
  options = {
    indicator_icon = '>',
    show_buffer_close_icons = false,
    show_close_icon =  false,
  }
}


-------- Globals --------------
g.mapleader = " "                 -- Set space as leader key

-------- Options --------------
opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 2                  -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = 2                     -- Number of spaces tabs count for
-- opt.termguicolors = true            -- True color support
opt.wildmode = {'list', 'longest'}  -- Command-line completion mod


-------- LSP ---------------
local lsp = require('lspconfig')
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>=', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()]]  -- PyLSP Format of save
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.pylsp.setup{    --- Needs pip install pydocstyle python-lsp-server pyls-flake8 python-lsp-black pyls-isort
  on_attach = on_attach,
  capabilities = capabilities,
  plugins = {
    black = { enabled = true },
    flake8 = { enabled = true },
    isort = { enabled = true },
    pydocstyle = { enabled = true },
  }
}

opt.completeopt = 'menuone,noselect'
require('compe').setup{
  enabled = true,
  autocomplete = true,
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}

-- Utility functions for compe
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  else
    return t '<S-Tab>'
  end
end


------- Mappings -----------
map('n', '<leader>w', ':w<CR>')
map('n', '<leader>h', ':bp<CR>')
map('n', '<leader>l', ':bn<CR>')
map('n', '<leader>p', ':b#<CR>')
map('n', '<leader>f', ':Telescope find_files<CR>')
map('n', '<leader>b', ':Telescope buffers<CR>')
map('n', '<leader>/', ':HopPattern<CR>')
map('n', '<leader>j', ':HopWord<CR>')
map('n', '<leader>t', ':TroubleToggle<CR>')
map('n', '<leader>e', ':NvimTreeToggle<CR>')


-- Map tab to the above tab complete functiones
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })