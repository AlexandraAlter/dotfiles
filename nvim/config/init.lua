-- vim: fileencoding=utf-8 foldmethod=marker fdl=0

-- Where a configuration section concerns a plugin, the name is in (parenthesis)

-- TODO: investigate ms-jpq/coq_nvim as an alternative to cmp
-- TODO: replace shoddy C/C++ alternate jumps with projectionist
-- TODO: investigate L3MON4D3/LuaSnip as an alternative to ultisnips
-- TODO: investigate tpope/vim-dispatch as an alternative to neomake
-- TODO: investigate tpope/vim-flagship as an alternative to lualine
-- TODO: evaluate harpoon and decide whether it's needed
-- TODO: fill out which-key with more bindings
-- TODO: evaluate norg against markdown

-- {{{ plugin overview
-- navigation:
--   targets (additional text objects, wellle)
--   telescope telescope-fzf-native
--   wordmotion (word motions, chaoren)
--   flash (search labels and character motions, folke)
--   vinegar (netrw extensions, tpope)
--   projectionist (project configuration, tpope)
-- editing:
--   easy-align (text alignment, junegunn)
--   sleuth (discover buffer options from file, tpope)
--   speeddating (better increment/decrement, tpope)
--   unimpaired (bracket mappings, tpope)
--   commentary (commenting, tpope)
--   surround (edit 'surrounding characters', tpope)
--   repeat (repeatable plugin commands, tpope)
--   abolish (word variant handling, tpope)
--   characterize (unicode character metadata, tpope)
-- completion:
--   cmp cmp-buffer cmp-cmdline cmp-lsp cmp-path (CMP completion kit, hrsh7th)
--   cmp-ultisnips (cmp/ultisnips integration, quangnguyen30192)
--   ultisnips (snippets, SirVer)
--   snippets (default snippets, honza)
-- tooling:
--   treesitter (treesitter configuration and abstraction, nvim-treesitter)
--   floaterm (floating terminals, voldikss)
--   neomake (asyncronous lint/make, neomake)
--   obsession (update session files, tpope)
--   tbone (TMUX integration, tpope)
--   eunuch (UNIX helpers, tpope)
--   fugitive (git wrapper, tpope)
-- UI:
--   which-key (bindings and popups, folke)
--   aurora (dark theme, ray-x)
--   lualine (status line, shadmansaleh)
--   web-devicons (icons for patched fonts, alex-cortis/kyazdani42)
-- filetypes:
--   apathy (set path for files, tpope)
--   jdaddy (json manipulation, tpope)
--   endwise (automatic endings, tpope)
--   ragtag (XML mappings, tpope)
--   janet (janet mappings, janet-lang)
--   godot (godot mappings, habamax)
-- libraries:
--   plenary (general lua, tjdevries)
-- other:
--   lspconfig (LSP quickstart, neovim)
--   sensible (general configuration, tpope)
-- unused:
--   harpoon (startup errors, ThePrimeagen)
--   leap (replaced by flash, ggandor)
--   neorg (difficult external dependencies, neorg)
-- }}}

local data = vim.fn.expand(vim.fn.stdpath('data'))
local state = vim.fn.expand(vim.fn.stdpath('state'))

local starting = vim.fn.has 'vim_starting' == 1

-- {{{ general
vim.opt.encoding = 'utf-8'
vim.opt.compatible = false
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'
vim.opt.sidescrolloff = 24
vim.opt.timeoutlen = 500
--vim.opt.hidden = false
vim.opt.spell = false
vim.opt.spelllang = 'en_gb,cjk'
vim.opt.spellsuggest = 'best,9'
vim.opt.spellfile = data .. '/site/spell/en.utf-8.add'
vim.cmd [[command! SpellUpdate execute "mkspell!" &spellfile]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- -- (sensible)
-- sensible default settings

-- -- (obsession)
-- better session storage

-- }}}

-- {{{ keymaps / (which-key)
local wk = require('which-key')

if starting then
  wk.setup({
    presets = {
      windows = false, -- we bind these ourselves
    },
  })
end

-- pre-add groups, simple mappings, expanded mappings and proxies
wk.add({
  { '<Leader>f', group = 'file' },
  { '<Leader>fs', '<Cmd>write<CR>', desc = 'Save' },
  { '<Leader>fS', '<Cmd>wall<CR>', desc = 'Save All' },
  { '<Leader>fn', '<Cmd>new<CR>', desc = 'New' },

  -- { '<Leader>b', group = 'buffer' },
  { '<Leader>b', group = 'buffers', expand = function()
      return require('which-key.extras').expand.buf()
    end
  },
  { '<Leader>bf', '<Cmd>bfirst<CR>', desc = 'First' },
  { '<Leader>bl', '<Cmd>blast<CR>', desc = 'Last' },
  { '<Leader>bn', '<Cmd>bnext<CR>', desc = 'Next' },
  { '<Leader>bp', '<Cmd>bprevious<CR>', desc = 'Previous' },
  { '<Leader>bd', '<Cmd>bd<CR>', desc = 'Delete' },
  { '<Leader>bD', '<Cmd>BW<CR>', desc = 'Delete and Next' },

  { '<Leader>x', group = 'text', icon = { icon = '', color = 'cyan' } },
  { '<Leader>xS', '<Cmd>sort<CR>', desc = 'Sort' },

  { '<Leader>n', group = 'number' },

  { '<Leader>s', group = 'search' },
  { '<Leader>sc', '<Cmd>nohlsearch<CR>', desc = 'Clear' },

  -- icons: 󱖫  󰵅  󰓩 󰃤 󰙵 󰅇 󱅻  󰛔 󰈸    󰈔    󰈆 
  -- colors: 
  { '<Leader>j', group = 'jump' },
  { '<Leader>jd', '<Cmd>delmarks!<CR>', desc = 'Delete Marks' },
  { '<Leader>jD', '<Cmd>delmarks A-Z0-9<CR>', desc = 'Delete All Marks' },

  { '<Leader>r', group = 'run', icon = { icon = '', color = 'red' } },
  { '<Leader>rm', '<Cmd>make<CR>', desc = 'Make' },

  { '<Leader>a', group = 'app', icon = { icon = '', color = 'red' } },
  { '<Leader>l', group = 'lsp', icon = { icon = '', color = 'orange' } },
  { '<Leader>g', group = 'git' },
  { '<Leader>d', group = 'debug' },

  { '<Leader>t', group = 'toggle' },
  { '<Leader>tt', '<Cmd>TSBufToggle<CR>', desc = 'Treesitter' },
  { '<Leader>ts', '<Cmd>set spell!<CR>', desc = 'Spell' },
  { '<Leader>tw', '<Cmd>set wrap!<CR>', desc = 'Wrap' },

  { '<Leader>c', group = 'config', icon = { icon = '', color = 'cyan' } },
  { '<Leader>ce', '<Cmd>edit $MYVIMRC<CR>', desc = 'Edit' },
  { '<Leader>cr', '<Cmd>Reload<CR>', desc = 'Reload' },

  { '<Leader>h', group = 'help' },

  { '<Leader>q', group = 'quit' },
  { '<Leader>qq', '<Cmd>quitall<CR>', desc = 'Quit' },
  { '<Leader>qQ', '<Cmd>quit<CR>', desc = 'Quit This' },
  { '<Leader>qw', '<Cmd>wqall<CR>', desc = 'Write and Quit' },
  { '<Leader>qW', '<Cmd>wq<CR>', desc = 'Write and Quit This' },

  { '<Leader>w', proxy = '<c-w>', group = 'windows' },
  { '<C-w>', group = 'windows', expand = function()
      return require('which-key.extras').expand.win()
    end
  },

  { '<LocalLeader> =', 'm`gg=G``', desc = 'reformat' },
})

-- -- other keymaps
vim.keymap.set({'n', 'x'}, 'q', ',')
vim.keymap.set({'n', 'x'}, '\\', 'q')
vim.keymap.set({'n', 'x'}, '|', 'Q')
-- }}}

-- {{{ interface
if vim.fn.exists('g:neovide') then
  vim.opt.guifont = 'Fira Code,FiraCode Nerd Font:h12'
  vim.cmd [[command! FontDefault :set guifont=Fira\ Code,FiraCode\ Nerd\ Font:h12]]
  vim.cmd [[command! FontSSK :set guifont=sitelen\ seli\ kiwen\ mono\ juniko\ meso:h15]]
  vim.cmd [[command! FontFairfax :set guifont=Fairfax\ HD:h15]]
end
vim.opt.termguicolors = true

-- -- (aurora)
vim.g.aurora_italic = 1
vim.g.aurora_transparent = 1
vim.g.aurora_bold = 1
vim.g.aurora_darker = 0
if pcall(vim.cmd.colorscheme, 'aurora') then
  -- vim.api.nvim_set_hl(0, 'WhichKeyIconAzure', { link = '' })
  -- vim.api.nvim_set_hl(0, 'WhichKeyIconBlue', { link = '' })
  vim.api.nvim_set_hl(0, 'WhichKeyIconCyan', { link = 'Typedef' })
  vim.api.nvim_set_hl(0, 'WhichKeyIconGreen', { link = 'DiagnosticHint' })
  -- vim.api.nvim_set_hl(0, 'WhichKeyIconGrey', { link = '' })
  vim.api.nvim_set_hl(0, 'WhichKeyIconOrange', { link = 'Number' })
  vim.api.nvim_set_hl(0, 'WhichKeyIconPurple', { link = 'Include' })
  -- vim.api.nvim_set_hl(0, 'WhichKeyIconRed', { link = '' })
  vim.api.nvim_set_hl(0, 'WhichKeyIconYellow', { link = 'Constant' })
else
  vim.cmd.colorscheme('industry')
end

-- -- (lualine)
require('lualine').setup {
  options = {
    theme = 'auto',
  }
}

-- -- (characterize)
-- maps `ga`, adds `:Obsess`

-- }}}

-- {{{ navigation
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.foldopen = 'hor,insert,jump,mark,percent,quickfix,search,tag,undo'
vim.opt.foldenable = true
vim.g.markdown_folding = 1

vim.cmd [[command! BW :bn|:bd#]]

-- -- (flash)
-- maps normal `s`, `S`
-- maps operators `r`
-- maps visual/operators `R`
-- maps commandline `<C-s>`
local flash = require('flash')
flash.setup({
  labels = 'aoeuidhtns\',.pyfgcrl;qjkxbmwvz',
  modes = {
    char = {
      keys = { 'f', 'F', 't', 'T', ';', [','] = 'q' },
    },
  },
})

wk.add({
  { 's', flash.jump, desc = 'Flash', mode = { 'n', 'x', 'o' } },
  -- { 'S', flash.treesitter, desc = 'Flash Treesitter', mode = { 'n', 'x', 'o' } },
  { 'r', flash.remote, desc = 'Remote Flash', mode = 'o' },
  { 'R', flash.treesitter_search, desc = 'Treesitter Flash Search', mode = { 'x', 'o' } },
  { '<C-s>', flash.toggle, desc = 'Toggle Flash Search', mode = 'c' },
  { '<Leader>tS', flash.toggle, desc = 'Toggle Flash Search' },
})

-- -- (harpoon +plenary)
-- jump between marks/files/terminals
-- currently broken by changes to events
--local harpoon_mark = require('harpoon.mark')
--local harpoon_ui = require('harpoon.ui')
-- wk.add({
--   { 'h', harpoon_ui.toggle_quick_menu, desc = 'Harpoon Menu' },
--   { 'H', harpoon_mark.add_file, desc = 'Harpoon File' },
--   { 'n', harpoon_ui.nav_next, desc = 'Harpoon Next' },
--   { 'p', harpoon_ui.nav_prev, desc = 'Harpoon Prev' },
-- })

-- -- (targets)
-- adds text objects for bracket pairs, quotes, separators, arguments, any block, any quote
-- capitalised versions alter whitespace rules
-- versions with `n` or `l` target next/last instance
-- all rules use `a`, `i`, `A`, `I`, `?n`, `?l`

-- -- (wordmotion)
-- alters `w`, `b`, `e`, etc

-- }}}

-- {{{ editing

-- -- (easy-align)
-- adds `:EasyAlign`, `:LiveEasyAlign`
-- in the interactive prompt:
--   1-9/`*`/`**`/`-` alter options
--   `<C-F>`/`<C-I>`/`<C-L>`/`<C-R>`/`<C-D>`/`<C-U>`/`<C-G>`/`<C-A>`/`<Left>`/`<Right>`/`<Down>`/`<Enter>` alter alignment
--   `<C-/>`/`<C-X>` enters regex mode
vim.keymap.set({'v', 'n'}, 'gA', '<Plug>(EasyAlign)')

-- -- (surround)
-- maps normal `cs`, `ds`, `ys`, and visual `S`

-- -- (repeat)
-- maps `.`

-- -- (commentary)
-- maps `gc`

-- -- (abolish)
-- maps `cr`, adds `:Abolish`, `:Subvert`
wk.add({
  { 'xC', '<Plug>(abolish-coerce-word)', desc = 'Coerce Word' },
  { 'xc', '<Plug>(abolish-coerce)', desc = 'Coerce', mode = { 'n', 'v' } },
})

-- -- (speeddating)
-- maps `d<C-X>`, `d<C-A>`

-- }}}

-- {{{ filesystem
vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.backupdir:remove('.')
if not vim.fn.isdirectory(state .. '/backup') then
  vim.fn.mkdir(state .. '/backup')
end

-- -- files
vim.cmd [[command! -bar Reload source $MYVIMRC | echo 'Sourced' $MYVIMRC]]
vim.cmd [[command! -bar PackUpdate exe 'vert topleft new cd' stdpath('data') . '/site/pack | Git submodule update --remote --merge --recursive .']]

-- -- filetypes
vim.g.c_syntax_for_h = 1

-- -- treesitter
-- adds `:TSUpdate`, `:TSInstall`, `:TSModuleInfo`, and enable/disable commands
-- after updating, run `:TSUpdate`
require('nvim-treesitter.configs').setup {
  ensure_installed = {'c', 'lua', 'vim', 'vimdoc', 'query'},
  auto_install = false,
  highlight = {
    enable = true,
    -- additional_vim_regex_highlighting = false,
  }
}

-- -- (telescope +telescope-fzf-native +plenary +web-devicons)
-- adds `:Telescope`
-- after updating, run `make` in `telescope-fzf-native`
local telescope = require('telescope')
local telescope_builtins = require('telescope.builtin')
telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-h>'] = 'which_key',
      }
    }
  },
  extensions = {
    fzf = {}
  }
}
telescope.load_extension('fzf')

wk.add({
  icon = { icon = '', color = 'blue' },

  { '<Leader>ff', telescope_builtins.find_files, desc = 'Files' },
  { '<Leader>fr', telescope_builtins.oldfiles, desc = 'Recent' },

  { '<Leader>bb', telescope_builtins.buffers, desc = 'Buffers' },

  { '<Leader>hh', telescope_builtins.help_tags, desc = 'Tags' },
  { '<Leader>hm', telescope_builtins.man_pages, desc = 'Man Pages' },
  { '<Leader>hk', telescope_builtins.keymaps, desc = 'Keymaps' },
  { '<Leader>hf', telescope_builtins.filetypes, desc = 'Filetypes' },
  { '<Leader>hH', telescope_builtins.highlights, desc = 'Highlights' },

  { '<Leader>ca', telescope_builtins.autocommands, desc = 'Autocommands' },
  { '<Leader>co', telescope_builtins.vim_options, desc = 'Set Option' },

  { '<Leader>dq', telescope_builtins.quickfix, desc = 'Quickfix' },
  { '<Leader>dQ', telescope_builtins.quickfixhistory, desc = 'Quickfix History' },
  { '<Leader>dl', telescope_builtins.loclist, desc = 'Location List' },

  { '<Leader>gf', telescope_builtins.git_files, desc = 'Files' },
  { '<Leader>gc', telescope_builtins.git_commits, desc = 'Commits' },
  { '<Leader>gC', telescope_builtins.git_bcommits, desc = 'Buffer Commits' },
  { '<Leader>gb', telescope_builtins.git_branches, desc = 'Branches' },
  { '<Leader>gs', telescope_builtins.git_status, desc = 'Status' },
  { '<Leader>gS', telescope_builtins.git_stash, desc = 'Stash' },

  { '<Leader>lr', telescope_builtins.lsp_references, desc = 'References' },
  { '<Leader>lc', telescope_builtins.lsp_incoming_calls, desc = 'Incoming Calls' },
  { '<Leader>lC', telescope_builtins.lsp_outgoing_calls, desc = 'Outgoing Calls' },
  { '<Leader>ls', telescope_builtins.lsp_document_symbols, desc = 'Document Symbols' },
  { '<Leader>lw', telescope_builtins.lsp_workspace_symbols, desc = 'Workspace Symbols' },
  { '<Leader>lW', telescope_builtins.lsp_dynamic_workspace_symbols, desc = 'Dynamic Workspace Symbols' },
  { '<Leader>lg', telescope_builtins.diagnostics, desc = 'Diagnostics' },
  { '<Leader>li', telescope_builtins.lsp_implementations, desc = 'Implementations' },
  { '<Leader>ld', telescope_builtins.lsp_definitions, desc = 'Definitions' },
  { '<Leader>lt', telescope_builtins.lsp_type_definitions, desc = 'Type Definitions' },

  { '<Leader>rc', telescope_builtins.commands, desc = 'Commands' },
  { '<Leader>rC', telescope_builtins.command_history, desc = 'Command History' },
  { '<Leader>rt', telescope_builtins.resume, desc = 'Resume Telescope' },
  { '<Leader>rT', telescope_builtins.pickers, desc = 'Telescope' },

  { '<Leader>jj', telescope_builtins.marks, desc = 'Marks' },
  { '<Leader>jl', telescope_builtins.jumplist, desc = 'Jump List' },
  { '<Leader>jt', telescope_builtins.tags, desc = 'Tags' },
  { '<Leader>jT', telescope_builtins.current_buffer_tags, desc = 'Tags In File' },
  { '<Leader>jr', telescope_builtins.treesitter, desc = 'Treesitter Symbols' },

  { '<Leader>ss', telescope_builtins.live_grep, desc = 'Grep' },
  { '<Leader>sS', telescope_builtins.grep_string, desc = 'Grep Under Cursor' },
  { '<Leader>sh', telescope_builtins.search_history, desc = 'History' },
  { '<Leader>sf', telescope_builtins.current_buffer_fuzzy_find, desc = 'Search In File' },

  { '<Leader>xr', telescope_builtins.registers, desc = 'Registers' },
  { '<Leader>xs', telescope_builtins.spell_suggest, desc = 'Spellcheck' },
})

-- -- (projectionist)
-- adds `:A...`, `:P...`, `:ProjectDo`, and others

-- -- (vinegar) / netrw
-- maps `-`
-- within netrw, maps `I`, `gh`, `.`, `y.`, `~`
-- within netrw, vim adds `<C-^>`
vim.g.netrw_home = data
--vim.g.netrw_fastbrowse = 0

-- -- (eunuch)
-- adds Linux commands, `:Sudo...`, `:C...`, `:L...`, `:Wall`
wk.add({
  { '<Leader>fR', '<Cmd>call feedkeys(\':Rename \')<CR>', desc = 'Rename' },
  { '<Leader>fM', '<Cmd>call feedkeys(\':Move \')<CR>', desc = 'Move' },
  { '<Leader>fC', '<Cmd>call feedkeys(\':Chmod \')<CR>', desc = 'Chmod' },
  { '<Leader>fD', '<Cmd>call feedkeys(\':Mkdir \')<CR>', desc = 'Mkdir' },
  { '<Leader>fF', group = 'file sudo' },
  { '<Leader>fFe', '<Cmd>SudoEdit<CR>', desc = 'Edit' },
  { '<Leader>fFs', '<Cmd>SudoWrite<CR>', desc = 'Save' },
})

-- }}}

-- {{{ integration

-- -- (floaterm)
-- adds `:Floaterm...`
vim.g.floaterm_keymap_toggle = '<F5>'
vim.g.floaterm_keymap_new    = '<F6>'
vim.g.floaterm_keymap_prev   = '<F7>'
vim.g.floaterm_keymap_next   = '<F8>'
vim.g.floaterm_keymap_hide   = '<C-z>'
vim.g.floaterm_autoclose     = 1

wk.add({
  icon = { icon = '', color = 'red' },
  { '<Leader>aa', '<Cmd>call feedkeys(\':FloatermNew \')<CR>', desc = 'Terminal' },
  { '<Leader>as', '<Cmd>FloatermNew<CR>', desc = 'Shell' },
  { '<Leader>ar', '<Cmd>FloatermNew ranger<CR>', desc = 'Ranger' },
  { '<Leader>ap', '<Cmd>FloatermNew python<CR>', desc = 'Python' },
  { '<Leader>aj', '<Cmd>FloatermNew julia<CR>', desc = 'Julia' },
  { '<Leader>af', '<Cmd>FloatermToggle<CR>', desc = 'Floatterm Toggle' },
})

-- -- (neomake)
-- adds `:Neomake`
wk.add({
  icon = { icon = '', color = 'red' },
  { 'rn', '<Cmd>Neomake!<CR>', desc = 'Neomake' },
  { 'rN', '<Cmd>Neomake<CR>', desc = 'Neomake File' },
})

-- -- (tbone)
-- adds `:Tmux`, `:T...`
wk.add({
  icon = { icon = '', color = 'red' },
  { '<Leader>at', group = 'tmux' },
  { '<Leader>aT', '<Cmd>call feedkeys(\':Tmux \')<CR>', desc = 'Tmux Custom' },
  { '<Leader>ata', '<Cmd>Tattach<CR>', desc = 'Attach' },
  { '<Leader>aty', '<Cmd>Tyank<CR>', desc = 'Yank' },
  { '<Leader>atp', '<Cmd>Tput<CR>', desc = 'Put' },
  { '<Leader>atw', '<Cmd>Twrite<CR>', desc = 'Write' },
})

-- -- (fugitive)
-- adds `:Git`, `:G...`
wk.add({
  { '<Leader>gg', '<Cmd>call feedkeys(\':Git \')<CR>', desc = 'Git Custom' },
})

-- }}}

-- {{{ formats
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.makeprg = 'make'

-- -- (sleuth)
-- automatically sets various options

-- -- (endwise)
-- automatically ends certain constructs

-- -- (unimpaired)
-- maps `[...`, `]...`
-- common ex commands, line manipulation, option toggling, encode/decode

-- -- (apathy)
-- sets path-searching options for misc files

-- -- (ragtag)
-- xml file mappings
-- maps `<C-X>...`

-- -- (jdaddy)
-- json file mappings
-- maps `gqaj` (pretty print), `gwaj` (merge from clipboard) and `ij` variants
-- defines text object `aj`

-- -- (godot)
-- gdscript file features
-- adds `:Godot...`

-- -- (neorg)
-- neorg file features
-- require('neorg').setup {
--   load = {
--     ['core.defaults'] = {}
--   }
-- }

-- -- lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
-- lsp['eslint'].setup { capabilities = capabilities }
lspconfig.rust_analyzer.setup({})

-- }}}

-- {{{ completion
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'

-- -- (ultisnips +snippets)
-- adds `:UltiSnipsEdit`, `:UltiSnipsAddFiletypes`
--vim.g.UltiSnipsExpandTrigger = '<Tab>'
--vim.g.UltiSnipsListSnippets = '<C-Tab>'
--vim.g.UltiSnipsJumpForwardsTrigger = '<C-j>'
--vim.g.UltiSnipsJumpBackwardsTrigger = '<C-k>'
--vim.g.UltiSnipsRemoveSelectModeMappings = 0

-- -- (cmp +cmp-*)
local cmp = require('cmp')
local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')

cmp.setup({
  snippet = {
    expand = function(args) vim.fn['UltiSnips#Anon'](args.body) end,
  },

  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),

    ['<C-D>'] = cmp.mapping.scroll_docs(-4),
    ['<C-F>'] = cmp.mapping.scroll_docs(4),

    ['<C-N>'] = cmp.mapping.select_next_item(),
    ['<C-P>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),

    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(
      function(fallback)
        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
      end,
      { 'i', 's' }
    ),
    ['<S-Tab>'] = cmp.mapping(
      function(fallback)
        cmp_ultisnips_mappings.jump_backwards(fallback)
      end,
      { 'i', 's' }
    ),
    ['<C-E>'] = cmp.mapping.close(),
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'buffer', keyword_length = 3 },
  },
})

cmp.setup.cmdline('/', {
  completion = { autocomplete = false },
  sources = {
    { name = 'buffer', keyword_pattern = [=[[^[:blank:]].*]=] },
  },
})

cmp.setup.cmdline(':', {
  completion = { autocomplete = false },
  sources = {
    { name = 'path' },
    { name = 'cmdline' },
  },
})

local cmp_enabled = true
function CmpToggle()
  cmp_enabled = not cmp_enabled
  cmp.setup.buffer { enabled = cmp_enabled }
end

wk.add({
  { '<Leader>tc', CmpToggle, desc = 'Completion' },
})

-- }}}

-- {{{ (which-key) for missing default keymaps

-- <Leader>w CTRL-w
wk.add({
  preset = true,
  mode = { 'n', 'x' },
  { '<C-w>t', desc = 'Go to the top window' },
  { '<C-w>b', desc = 'Go to the bottom window' },
  { '<C-w>p', desc = 'Switch windows backwards' },
  { '<C-w>W', desc = 'Switch windows backwards' },
  { '<C-w>P', desc = 'Switch windows backwards' },
  { '<C-w>H', desc = 'Move window left' },
  { '<C-w>L', desc = 'Move window right' },
  { '<C-w>K', desc = 'Move window up' },
  { '<C-w>J', desc = 'Move window down' },
  { '<C-w>r', desc = 'Rotate windows downwards' },
  { '<C-w>R', desc = 'Rotate windows upwards' },
  { '<C-w>n', desc = 'New window' },
  { '<C-w>f', desc = 'Open file name in a window' },
  { '<C-w>d', desc = 'Open definition in a window' },
  { '<C-w>i', desc = 'Open identifier in a window' },
  { '<C-w>]', desc = 'Open tag in a window' },
  { '<C-w>}', desc = 'Open tag with a preview' },
  { '<C-w>^', desc = 'Open alternate file in a window' },
  { '<C-w>c', desc = 'Close a window' },
  { '<C-w>g', group = 'window-g' },
  { '<C-w>g<C-]>', desc = ':tjump in a window' },
  { '<C-w>g]', desc = ':tselect in a window' },
  { '<C-w>g}', desc = ':ptjump in a window' },
  { '<C-w>gf', desc = 'Open file name in a tab' },
  { '<C-w>gF', desc = 'Open file name and line number in a tab' },
  { '<C-w>gt', desc = 'Next tab' },
  { '<C-w>gT', desc = 'Previous tab' },
  { '<C-w>g<Tab>', desc = 'Last tab' },
  unpack(require('which-key.plugins.presets').windows),
})

-- zu
wk.add({
  { 'zu', group = 'z-undo' },
  { 'zuw', desc = 'Undo zw' },
  { 'zug', desc = 'Undo zg' },
  { 'zuW', desc = 'Undo zW' },
  { 'zuG', desc = 'Undo zG' },
})

-- }}}



