vim.opt_local.equalprg = 'clang-format' 
vim.opt_local.cino = 'N-s g0' 

vim.keymap.set('n', '<localleader>s', ':find %:t:r.cpp<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>S', ':sf %:t:r.cpp<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>h', ':find %:t:r.hpp<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>H', ':sf %:t:r.hpp<CR>', { buffer = true })
