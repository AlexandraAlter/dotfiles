setlocal equalprg=clang-format cino=N-s\ g0

nmap <buffer> <localleader>s :find %:t:r.cpp<CR>
nmap <buffer> <localleader>S :sf %:t:r.cpp<CR>
nmap <buffer> <localleader>h :find %:t:r.hpp<CR>
nmap <buffer> <localleader>H :sf %:t:r.hpp<CR>
