vim.opt_local.equalprg = 'clang-format' 
vim.opt_local.cino = 'N-s g0' 

vim.keymap.set('n', '<localleader>s', ':find %:t:r.c<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>S', ':sf %:t:r.c<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>h', ':find %:t:r.h<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>H', ':sf %:t:r.h<CR>', { buffer = true })

local path = vim.fn.escape(vim.fn.escape(vim.fn.expand('%:p:h'), ' '), '\\ ')
vim.opt_local.path:prepend(path .. '/../**')

