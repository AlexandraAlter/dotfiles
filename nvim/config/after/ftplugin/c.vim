setlocal equalprg=clang-format cino=N-s\ g0

nmap <buffer> <localleader>s :find %:t:r.c<CR>
nmap <buffer> <localleader>S :sf %:t:r.c<CR>
nmap <buffer> <localleader>h :find %:t:r.h<CR>
nmap <buffer> <localleader>H :sf %:t:r.h<CR>
