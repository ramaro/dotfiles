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
paq { 'nvim-telescope/telescope-fzy-native.nvim' }
paq { 'hoob3rt/lualine.nvim' }
paq { 'kyazdani42/nvim-web-devicons' }   -- Needs patched font (like Hack Nerd) https://www.nerdfonts.com/font-downloads
paq { 'ryanoasis/vim-devicons' }
paq { 'akinsho/nvim-bufferline.lua' }
paq { 'lewis6991/gitsigns.nvim' }
paq { 'phaazon/hop.nvim' }
paq { 'folke/trouble.nvim' }
paq { 'onsails/lspkind-nvim' }
-- paq { 'kyazdani42/nvim-tree.lua' }
paq { 'b3nj5m1n/kommentary' }
paq { 'mhartington/formatter.nvim' }
-- paq { 'EdenEast/nightfox.nvim' }
paq { 'folke/tokyonight.nvim' }
paq { 'ThePrimeagen/git-worktree.nvim' }
paq { 'TimUntersberger/neogit' }
paq { 'sindrets/diffview.nvim' }
paq { 'mhinz/vim-startify' }

------- Colours and pretty things -----------
--[[ require('nightfox').load()
require('nightfox').setup({
  fox = "palefox",
}) ]]
cmd("colorscheme tokyonight")

require('telescope').setup()
require("telescope").load_extension("git_worktree")
require("telescope").load_extension("fzy_native")
require('neogit').setup()

require('gitsigns').setup{
  numhl = true,
  linehl = true,
  current_line_blame = true,
  current_line_blame_opts = { delay = 1000, position = 'rightalign' },
}

require('lualine').setup{
  options = {
    -- theme = "nightfox",
    theme = "tokyonight",
  },
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

---- Formatter ----
require('formatter').setup{
  filetype = {
    python = {
       function()
         return {
           exe = "black",
           args = {'-l', '99', '-'},
           stdin = true
         }
       end,
       function()
         return {
           exe = "isort",
           args = {'-'},
           stdin = true
         }
       end
    },
    yaml = {
      function()
        return {
          exe = "yamlfix",
          args = {'-'},
          stdin = true
        }
      end
    }
  }
}
-- Format filetypes on save
vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.py,*.yaml,*.yml FormatWrite
augroup END
]], true)


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
opt.wildmode = {'list', 'longest'}  -- Command-line completion mod


-------- LSP ---------------
local lsp = require('lspconfig')
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- lsp formatting isn't great or always supported comment for now and use formatter.vim instead
  --[[ vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>=', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()]]  -- PyLSP Format on save ]]
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.pylsp.setup{    --- Needs pip install pydocstyle python-lsp-server pyls-flake8
  on_attach = on_attach,
  capabilities = capabilities,
  configurationSources = {'flake8', 'pydocstyle'},  -- respect tool config files
  plugins = {
    flake8 = { enabled = true },
    pydocstyle = { enabled = true },
  }
}

lsp.yamlls.setup{  --- Needs yarn install -g yaml-language-server and .yarn/bin in PATH
  cmd = {'yaml-language-server', '--stdio'},
  filetypes = { 'yaml', 'yml' },
}

cmd("au BufRead,BufNewFile Dockerfile,Dockerfile.local set filetype=dockerfile")
lsp.dockerls.setup{
  filetypes = { "Dockerfile", "Dockerfile.local", "dockerfile" },
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
map('n', '<leader>ff', ':Telescope find_files<CR>')
map('n', '<leader>fg', ':Telescope live_grep<CR>')
map('n', '<leader>fs', ':Telescope grep_string<CR>')  -- needs ripgrep
map('n', '<leader>fb', ':Telescope file_browser<CR>')
map('n', '<leader>bf', ':Telescope buffers<CR>')
map('n', '<leader>bd', ':bd<CR>')
map('n', '<leader>gs', ':Telescope git_status<CR>')
map('n', '<leader>gl', ':Telescope git_commits<CR>')
map('n', '<leader>gb', ':Telescope git_branches<CR>')
map('n', '<leader>gg', ':Neogit<CR>')
map('n', '<leader>gr', ':!git rebase ')
map('n', '<leader>gd', ':DiffviewOpen master<CR>')
map('n', '<leader>gw', ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>")
map('n', '<leader>gn', ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>")
map('n', '<leader>/', ':HopPattern<CR>')
map('n', '<leader>j', ':HopWord<CR>')
map('n', '<leader>t', ':TroubleToggle<CR>')
map('n', '<leader>kc', ':!kapitan compile<CR>')
map('n', '<leader>vl', ':so ~/.config/nvim/init.lua<CR>')
map('n', '<leader>ve', ':e ~/.config/nvim/init.lua<CR>')


-- Map tab to the above tab complete functions
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
