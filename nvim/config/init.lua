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
--

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
-- maps `s`, `S`, and `gs`
-- while seeking, `<Space>` and `<Tab>` select a group
require('leap').add_default_mappings()

-- -- harpoon (+plenary)
-- jump between marks/files/terminals
local harpoon_mark = require('harpoon.mark')
local harpoon_ui = require('harpoon.ui')

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
vim.g.UltiSnipsExpandTrigger = '<Nop>'
vim.g.UltiSnipsListSnippets = '<Nop>'
vim.g.UltiSnipsJumpForwardsTrigger = '<Nop>'
vim.g.UltiSnipsJumpBackwardsTrigger = '<Nop>'
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
    ['<C-e>'] = cmp.mapping.close(),
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
  plugins = {
    spelling = {
      enabled = true,
    }
  }
})

wk.register({
  a = {
    name = '+app',
    s = { '<Cmd>FloatermNew<CR>', 'Shell' },
    r = { '<Cmd>FloatermNew ranger<CR>', 'Ranger' },
    p = { '<Cmd>FloatermNew python<CR>', 'Python' },
    j = { '<Cmd>FloatermNew julia<CR>', 'Julia' },
    g = { '<Cmd>call feedKeys(\':Git \')<CR>', 'Git' },
    t = {
      name = '+tmux',
      a = { '<Cmd>Tattach<CR>', 'Attach' },
      y = { '<Cmd>Tyank<CR>', 'Yank' },
      p = { '<Cmd>Tput<CR>', 'Put' },
      w = { '<Cmd>Twrite<CR>', 'Write' },
    },
    T = { '<Cmd>call feedKeys(\':Tmux \')<CR>', 'Tmux' },
  },

  q = {
    name = '+quit',
    q = { '<Cmd>quitall<CR>', 'Quit' },
    Q = { '<Cmd>quit<CR>', 'Quit This' },
    w = { '<Cmd>wqall<CR>', 'Write and Quit' },
    W = { '<Cmd>wq<CR>', 'Write and Quit This' },
  },

  j = {
    name = '+jump',
    j = { '<Cmd>Telescope marks<CR>', 'Marks' },
    d = { '<Cmd>delmarks!<CR>', 'Delete Marks' },
    D = { '<Cmd>delmarks A-Z0-9<CR>', 'Delete All Marks' },
    h = { harpoon_ui.toggle_quick_menu, 'Harpoon Menu' },
    H = { harpoon_mark.add_file, 'Harpoon File' },
    n = { harpoon_ui.nav_next, 'Harpoon Next' },
    p = { harpoon_ui.nav_prev, 'Harpoon Prev' },
  },

  f = {
    name = '+file',
    f = { '<Cmd>Telescope find_files<CR>', 'Files' },
    r = { '<Cmd>Telescope oldfiles<CR>', 'Recent' },
    s = { '<Cmd>write<CR>', 'Save' },
    S = { '<Cmd>wall<CR>', 'Save All' },
    R = { '<Cmd>call feedkeys(\':Rename \')<CR>', 'Rename' },
    M = { '<Cmd>call feedkeys(\':Move \')<CR>', 'Move' },
    C = { '<Cmd>call feedkeys(\':Chmod \')<CR>', 'Chmod' },
    D = { '<Cmd>call feedkeys(\':Mkdir \')<CR>', 'Mkdir' },
    c = {
      name = '+config',
      e = { '<Cmd>edit $MYVIMRC<CR>', 'Edit' },
      r = { '<Cmd>Reload<CR>', 'Reload' },
    },
    F = {
      name = '+sudo',
      e = { '<Cmd>SudoEdit<CR>', 'Edit' },
      s = { '<Cmd>SUdoWrite<CR>', 'Save' },
    },
  },

  b = {
    name = '+buffer',
    b = { '<Cmd>Telescope buffers<CR>', 'Buffers' },
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
  },

  t = {
    name = '+toggle',
    t = { '<Cmd>FloatermToggle<CR>', 'Term' },
    t = { '<Cmd>TSBufToggle<CR>', 'Treesitter' },
    c = { '<Cmd>lua CmpToggle()<CR>', 'Completion' },
    s = { '<Cmd>set spell!<CR>', 'Spell' },
    w = { '<Cmd>set wrap!<CR>', 'Wrap' },
  },

  x = {
    name = '+text',
  },

  n = {
    name = '+number',
  },

  r = {
    name = '+run',
    m = { '<Cmd>make<CR>', 'Make' },
  },

  g = {
    name = '+git',
    g = { '<Cmd>call feedKeys(\':Git \')<CR>', 'Git' },
    f = { '<Cmd>Telescope git_files<CR>', 'Files' },
  },

  s = {
    name = '+search',
    s = { '<Cmd>Telescope live_grep<CR>', 'Grep' },
    S = { '<Cmd>Telescope grep_string<CR>', 'Grep Under Cursor' },
    c = { '<Cmd>nohlsearch<CR>', 'Clear' },
  },

  h = {
    name = '+help',
    h = { '<Cmd>Telescope help_tags<CR>', 'Tags' },
  },

  w = { '<Cmd>WhichKey <C-w><CR>', '+window' },
}, { prefix = '<leader>' })

wk.register({
  ['='] = { 'm`gg=G``', 'reformat' },
}, { prefix = '<localleader>' })

wk.register({
  name = 'window',

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
}, { prefix = '<C-w>' })

wk.register({
  name = 'z',

  u = {
    name = 'Undo',
    w = 'Undo zw',
    g = 'Undo zg',
    W = 'Undo zW',
    G = 'Undo zG',
  },
}, { prefix = 'z' })

-- }}}


