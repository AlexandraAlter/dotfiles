-- vim:fileencoding=utf-8:foldmethod=marker

-- TODO: evaluate leap and decide whether to revert to sneak
-- TODO: evaluate harpoon and decide whether it's needed
-- TODO: fill out which-key with more bindings
-- TODO: evaluate norg against markdown

local data = vim.fn.expand(vim.fn.stdpath('data'))
local state = vim.fn.expand(vim.fn.stdpath('state'))

-- {{{ general
vim.opt.encoding = 'utf-8'
vim.opt.compatible = false
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'
vim.opt.spell = false
vim.opt.spelllang = 'en_gb,cjk'
vim.opt.spellsuggest = 'best,9'
vim.opt.spellfile = data .. '/site/spell/en.utf-8.add'

vim.cmd('command! SpellUpdate execute "mkspell!" &spellfile')

vim.opt.timeoutlen = 500

vim.g.mapleader = ' '
vim.g.maplocalleader = vim.api.nvim_replace_termcodes('<BS>', false, false, true)

-- -- sensible
-- sensible default settings

-- -- obsession
-- better session storage

-- }}}

-- {{{ interface
if vim.fn.exists('g:neovide') then
  vim.opt.guifont = 'Fira Code,Fira Code Nerd:h14'
end
vim.opt.termguicolors = true

-- -- aurora
vim.g.aurora_italic = 1
vim.g.aurora_transparent = 1
vim.g.aurora_bold = 1
vim.g.aurora_darker = 0
if not pcall(vim.cmd.colorscheme, 'aurora') then
  vim.cmd.colorscheme('industry')
end

-- -- lualine
require('lualine').setup {
  options = {
    theme = 'auto',
  }
}

-- -- characterize
-- maps `ga`, adds `:Obsess`

-- }}}

-- {{{ navigation
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.foldopen = 'hor,insert,jump,mark,percent,quickfix,search,tag,undo'
vim.opt.foldenable = true
vim.g.markdown_folding = 1

vim.cmd('command! BW :bn|:bd#')

-- -- leap
-- maps normal `s`, `S`, `gs`
-- maps visual/operators `s`, `S`, `x`, `X`
-- while seeking, `<Space>` and `<Tab>` select a group
--require('leap').add_default_mappings()
--vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward-to)')
--vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward-to)')
vim.keymap.set({'x', 'o'},      'x',  '<Plug>(leap-forward-till)')
vim.keymap.set({'x', 'o'},      'X',  '<Plug>(leap-backward-till)')
--vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')

-- -- harpoon (+plenary)
-- jump between marks/files/terminals
-- currently broken by changes to events
--local harpoon_mark = require('harpoon.mark')
--local harpoon_ui = require('harpoon.ui')

-- -- targets
-- adds text objects for bracket pairs, quotes, separators, arguments, any block, any quote
-- capitalised versions alter whitespace rules
-- versions with `n` or `l` target next/last instance
-- all rules use `a`, `i`, `A`, `I`, `?n`, `?l`

-- -- wordmotion
-- alters `w`, `b`, `e`, etc

-- }}}

-- {{{ editing

-- -- easy-align
-- adds `:EasyAlign`, `:LiveEasyAlign`
-- in the interactive prompt:
--   1-9/`*`/`**`/`-` alter options
--   `<C-F>`/`<C-I>`/`<C-L>`/`<C-R>`/`<C-D>`/`<C-U>`/`<C-G>`/`<C-A>`/`<Left>`/`<Right>`/`<Down>`/`<Enter>` alter alignment
--   `<C-/>`/`<C-X>` enters regex mode
vim.keymap.set({'v', 'n'}, 'gA', '<Plug>(EasyAlign)')

-- -- surround
-- maps normal `cs`, `ds`, `ys`, and visual `S`

-- -- repeat
-- maps `.`

-- -- commentary
-- maps `gc`

-- -- abolish
-- maps `cr`, adds `:Abolish`, `:Subvert`

-- -- speeddating
-- maps `d<C-X>`, `d<C-A>`

-- }}}

-- {{{ completion
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'

-- -- ultisnips (+snippets)
-- adds `:UltiSnipsEdit`, `:UltiSnipsAddFiletypes`
--vim.g.UltiSnipsExpandTrigger = '<Tab>'
--vim.g.UltiSnipsListSnippets = '<C-Tab>'
--vim.g.UltiSnipsJumpForwardsTrigger = '<C-j>'
--vim.g.UltiSnipsJumpBackwardsTrigger = '<C-k>'
--vim.g.UltiSnipsRemoveSelectModeMappings = 0

-- -- cmp (+cmp-*)
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

-- }}}

-- {{{ filesystem
vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.backupdir:remove('.')
if not vim.fn.isdirectory(state .. '/backup') then
  vim.fn.mkdir(state .. '/backup')
end
vim.g.netrw_home = data

-- -- files
vim.cmd [[command! -bar Reload source $MYVIMRC | echo 'Sourced' $MYVIMRC]]
vim.cmd [[command! -bar PackUpdate exe 'vert topleft new cd' stdpath('data') . '/site/pack | Git submodule update --remote --merge --recursive .']]

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

-- -- telescope (+telescope-fzf-native +plenary +web-devicons)
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

-- -- projectionist
-- adds `:A...`, `:P...`, `:ProjectDo`, and others

-- -- vinegar
-- maps `-`
-- within netrw, maps `I`, `gh`, `.`, `y.`, `~`
-- within netrw, vim adds `<C-^>`

-- -- eunuch
-- adds Linux commands, `:Sudo...`, `:C...`, `:L...`, `:Wall`

-- }}}

-- {{{ integration

-- -- floaterm
-- adds `:Floaterm...`
vim.g.floaterm_keymap_toggle = '<F5>'
vim.g.floaterm_keymap_new    = '<F6>'
vim.g.floaterm_keymap_prev   = '<F7>'
vim.g.floaterm_keymap_next   = '<F8>'
vim.g.floaterm_keymap_hide   = '<C-z>'
vim.g.floaterm_autoclose     = 1

-- -- neomake
-- adds `:Neomake`

-- -- tbone
-- adds `:Tmux`, `:T...`

-- -- fugitive
-- adds `:Git`, `:G...`

-- }}}

-- {{{ formats
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.et = true
vim.opt.makeprg = 'make'

-- -- sleuth
-- automatically sets various options

-- -- endwise
-- automatically ends certain constructs

-- -- unimpaired
-- maps `[...`, `]...`
-- common ex commands, line manipulation, option toggling, encode/decode

-- -- apathy
-- sets path-searching options for misc files

-- -- ragtag
-- xml file mappings
-- maps `<C-X>...`

-- -- jdaddy
-- json file mappings
-- maps `gqaj` (pretty print), `gwaj` (merge from clipboard) and `ij` variants
-- defines text object `aj`

-- -- godot
-- gdscript file features
-- adds `:Godot...`

-- -- neorg
-- neorg file features
require('neorg').setup {
  load = {
    ["core.defaults"] = {}
  }
}

-- -- lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
-- lsp['eslint'].setup { capabilities = capabilities }

-- }}}

-- {{{ which-key
local wk = require('which-key')

wk.setup({
  presets = {
    windows = false, -- we bind these ourselves
  },
})

-- <leader>f
wk.register({
  name = '+file',
  f = { telescope_builtins.find_files, 'Files' },
  r = { telescope_builtins.oldfiles, 'Recent' },
  s = { '<Cmd>write<CR>', 'Save' },
  S = { '<Cmd>wall<CR>', 'Save All' },
  n = { '<Cmd>new<CR>', 'New' },
  R = { '<Cmd>call feedkeys(\':Rename \')<CR>', 'Rename' },
  M = { '<Cmd>call feedkeys(\':Move \')<CR>', 'Move' },
  C = { '<Cmd>call feedkeys(\':Chmod \')<CR>', 'Chmod' },
  D = { '<Cmd>call feedkeys(\':Mkdir \')<CR>', 'Mkdir' },
  F = {
    name = '+sudo',
    e = { '<Cmd>SudoEdit<CR>', 'Edit' },
    s = { '<Cmd>SUdoWrite<CR>', 'Save' },
  },
}, { prefix = '<leader>f' })

-- <leader>b
wk.register({
  name = '+buffer',
  b = { telescope_builtins.buffers, 'Buffers' },
  ['1'] = { '<Cmd>b1<CR>', 'Buffer 1' },
  ['2'] = { '<Cmd>b2<CR>', 'Buffer 2' },
  ['3'] = { '<Cmd>b3<CR>', 'Buffer 3' },
  ['4'] = { '<Cmd>b4<CR>', 'Buffer 4' },
  ['5'] = { '<Cmd>b5<CR>', 'Buffer 5' },
  ['6'] = { '<Cmd>b6<CR>', 'Buffer 6' },
  ['7'] = { '<Cmd>b7<CR>', 'Buffer 7' },
  ['8'] = { '<Cmd>b8<CR>', 'Buffer 8' },
  ['9'] = { '<Cmd>b9<CR>', 'Buffer 9' },
  ['0'] = { '<Cmd>b10<CR>', 'Buffer 10' },
  f = { '<Cmd>bfirst<CR>', 'First' },
  l = { '<Cmd>blast<CR>', 'Last' },
  n = { '<Cmd>bnext<CR>', 'Next' },
  p = { '<Cmd>bprevious<CR>', 'Previous' },
  d = { '<Cmd>bd<CR>', 'Delete' },
  D = { '<Cmd>BW<CR>', 'Delete and Next' },
}, { prefix = '<leader>b' })

-- <leader>x
wk.register({
  name = '+text',
  r = { telescope_builtins.registers, 'Registers' },
  C = { '<Plug>(abolish-coerce-word)', 'Coerce Word' },
  s = { telescope_builtins.spell_suggest, 'Spellcheck' },
}, { prefix = '<leader>x' })
wk.register({
  name = '+text',
  S = { '<Cmd>sort<CR>', 'Sort' },
  c = { '<Plug>(abolish-coerce)', 'Coerce' },
}, { prefix = '<leader>x', mode = {'n', 'v'} })

-- <leader>n
wk.register({
  name = '+number',
}, { prefix = '<leader>n' })

-- <leader>s
wk.register({
  name = '+search',
  s = { telescope_builtins.live_grep, 'Grep' },
  S = { telescope_builtins.grep_string, 'Grep Under Cursor' },
  h = { telescope_builtins.search_history, 'History' },
  f = { telescope_builtins.current_buffer_fuzzy_find, 'Search In File' },
  c = { '<Cmd>nohlsearch<CR>', 'Clear' },
}, { prefix = '<leader>s' })

-- <leader>j
wk.register({
  name = '+jump',
  j = { telescope_builtins.marks, 'Marks' },
  l = { telescope_builtins.jumplist, 'Jump List' },
  t = { telescope_builtins.tags, 'Tags' },
  T = { telescope_builtins.current_buffer_tags, 'Tags In File' },
  r = { telescope_builtins.treesitter, 'Treesitter Symbols' },
  d = { '<Cmd>delmarks!<CR>', 'Delete Marks' },
  D = { '<Cmd>delmarks A-Z0-9<CR>', 'Delete All Marks' },
  h = { harpoon_ui.toggle_quick_menu, 'Harpoon Menu' },
  H = { harpoon_mark.add_file, 'Harpoon File' },
  n = { harpoon_ui.nav_next, 'Harpoon Next' },
  p = { harpoon_ui.nav_prev, 'Harpoon Prev' },
}, { prefix = '<leader>j', mode = {'n', 'v'} })

-- <leader>r
wk.register({
  name = '+run',
  m = { '<Cmd>make<CR>', 'Make' },
  n = { '<Cmd>Neomake!<CR>', 'Neomake' },
  N = { '<Cmd>Neomake<CR>', 'Neomake File' },
  c = { telescope_builtins.commands, 'Commands' },
  C = { telescope_builtins.command_history, 'Command History' },
  t = { telescope_builtins.resume, 'Resume Telescope' },
  T = { telescope_builtins.pickers, 'Telescope' },
}, { prefix = '<leader>r', mode = {'n', 'v'} })

-- <leader>a
wk.register({
  name = '+app',
  a = { '<Cmd>call feedKeys(\':FloatermNew \')<CR>', 'Terminal' },
  s = { '<Cmd>FloatermNew<CR>', 'Shell' },
  r = { '<Cmd>FloatermNew ranger<CR>', 'Ranger' },
  p = { '<Cmd>FloatermNew python<CR>', 'Python' },
  j = { '<Cmd>FloatermNew julia<CR>', 'Julia' },
  g = { '<Cmd>call feedKeys(\':Git \')<CR>', 'Git' },
  T = { '<Cmd>call feedKeys(\':Tmux \')<CR>', 'Tmux' },
  t = {
    name = '+tmux',
    a = { '<Cmd>Tattach<CR>', 'Attach' },
    y = { '<Cmd>Tyank<CR>', 'Yank' },
    p = { '<Cmd>Tput<CR>', 'Put' },
    w = { '<Cmd>Twrite<CR>', 'Write' },
  },
}, { prefix = '<leader>a' })

-- <leader>l
wk.register({
  name = '+lsp',
  r = { telescope_builtins.lsp_references, 'References' },
  c = { telescope_builtins.lsp_incoming_calls, 'Incoming Calls' },
  C = { telescope_builtins.lsp_outgoing_calls, 'Outgoing Calls' },
  s = { telescope_builtins.lsp_document_symbols, 'Document Symbols' },
  w = { telescope_builtins.lsp_workspace_symbols, 'Workspace Symbols' },
  W = { telescope_builtins.lsp_dynamic_workspace_symbols, 'Dynamic Workspace Symbols' },
  g = { telescope_builtins.diagnostics, 'Diagnostics' },
  i = { telescope_builtins.lsp_implementations, 'Implementations' },
  d = { telescope_builtins.lsp_definitions, 'Definitions' },
  t = { telescope_builtins.lsp_type_definitions, 'Type Definitions' },
}, { prefix = '<leader>l' })

-- <leader>g
wk.register({
  name = '+git',
  g = { '<Cmd>call feedKeys(\':Git \')<CR>', 'Git' },
  f = { telescope_builtins.git_files, 'Files' },
  c = { telescope_builtins.git_commits, 'Commits' },
  C = { telescope_builtins.git_bcommits, 'Buffer Commits' },
  b = { telescope_builtins.git_branches, 'Branches' },
  s = { telescope_builtins.git_status, 'Status' },
  S = { telescope_builtins.git_stash, 'Stash' },
}, { prefix = '<leader>g' })

-- <leader>d
wk.register({
  name = '+debug',
  q = { telescope_builtins.quickfix, 'Quickfix' },
  Q = { telescope_builtins.quickfixhistory, 'Quickfix History' },
  l = { telescope_builtins.loclist, 'Location List' },
}, { prefix = '<leader>d' })

-- <leader>t
wk.register({
  name = '+toggle',
  t = { '<Cmd>FloatermToggle<CR>', 'Term' },
  t = { '<Cmd>TSBufToggle<CR>', 'Treesitter' },
  c = { CmpToggle, 'Completion' },
  s = { '<Cmd>set spell!<CR>', 'Spell' },
  w = { '<Cmd>set wrap!<CR>', 'Wrap' },
}, { prefix = '<leader>t' })

-- <leader>c
wk.register({
  name = '+config',
  e = { '<Cmd>edit $MYVIMRC<CR>', 'Edit' },
  r = { '<Cmd>Reload<CR>', 'Reload' },
  o = { telescope_builtins.vim_options, 'Set Option' },
  a = { telescope_builtins.autocommands, 'Autocommands' },
}, { prefix = '<leader>c' })

-- <leader>h
wk.register({
  name = '+help',
  h = { telescope_builtins.help_tags, 'Tags' },
  m = { telescope_builtins.man_pages, 'Man Pages' },
  k = { telescope_builtins.keymaps, 'Keymaps' },
  f = { telescope_builtins.filetypes, 'Filetypes' },
  H = { telescope_builtins.highlights, 'Highlights' },
}, { prefix = '<leader>h' })

-- <leader>q
wk.register({
  name = '+quit',
  q = { '<Cmd>quitall<CR>', 'Quit' },
  Q = { '<Cmd>quit<CR>', 'Quit This' },
  w = { '<Cmd>wqall<CR>', 'Write and Quit' },
  W = { '<Cmd>wq<CR>', 'Write and Quit This' },
}, { prefix = '<leader>q' })

-- <leader>w CTRL-w
local wk_window_group = {
  name = '+window',
  h = 'Go to the left window',
  l = 'Go to the right window',
  k = 'Go to the up window',
  j = 'Go to the down window',
  t = 'Go to the top window',
  b = 'Go to the bottom window',
  w = 'Next window',
  p = 'Previous window',
  W = 'Previous window',
  ['-'] = 'Decrease height',
  ['+'] = 'Increase height',
  ['<lt>'] = 'Decrease width',
  ['>'] = 'Increase width',
  ['='] = 'Equalize windows',
  ['_'] = 'Set height',
  ['|'] = 'Set width',
  H = 'Move window left',
  L = 'Move window right',
  K = 'Move window up',
  J = 'Move window down',
  P = 'Previous window',
  r = 'Rotate windows downwards',
  R = 'Rotate windows upwards',
  x = 'Exchange windows',
  n = 'New window',
  s = 'Split window',
  v = 'Split window vertically',
  T = 'Break out into a new tab',
  d = 'Jump to definition in a window',
  i = 'Jump to identifier in a window',
  f = 'Edit file name in a window',
  [']'] = 'Jump to tag in a window',
  ['}'] = 'Jump to tag with a preview',
  ['^'] = 'Edit alternate file in a window',
  o = 'Keep only this window',
  c = 'Close window',
  q = 'Quit window',
  g = {
    name = 'g',
    ['<C-]>'] = ':tjump in a window',
    [']'] = ':tselect in a window',
    ['}'] = ':ptjump in a window',
    f = 'Edit file name in a tab',
    F = 'Edit file name and line number in a tab',
    t = 'Next tab',
    T = 'Previous tab',
    ['<Tab>'] = 'Last tab',
  },
}
wk.register(wk_window_group, { prefix = '<C-w>', mode = {'n', 'v'} })
wk.register(wk_window_group, { prefix = '<leader>w', mode = {'n', 'v'} })
wk.register({
  w = { '<C-W>', '+window' },
}, { prefix = '<leader>', mode = {'n', 'v'} })

-- <localleader>
wk.register({
  ['='] = { 'm`gg=G``', 'reformat' },
}, { prefix = '<localleader>' })

-- zu
wk.register({
  name = 'Undo',
  w = 'Undo zw',
  g = 'Undo zg',
  W = 'Undo zW',
  G = 'Undo zG',
}, { prefix = 'zu' })

-- }}}


