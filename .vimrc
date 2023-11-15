set number relativenumber
set tabstop=4

let mapleader = " "

" compile a latex file to pdf whenever saved. Poke mupdf that a new version of the file is available
" disabled for now because god forbid i have to write any latex anytime soon
" autocmd BufWritePost *.tex execute "!{pdflatex " . expand('%:p')." && pkill -HUP mupdf}" 

"insert a newline above / below cursor without entering insert mode. enter default is stoopid in insert mode lol
nnoremap <CR> o<Esc>
" This one seems impossible
" nnoremap <S-CR> O<Esc>
nnoremap <A-CR> O<Esc>

"reserve space for leader
nnoremap <SPACE> <Nop>

call plug#begin()
 
Plug 'morhetz/gruvbox'

call plug#end()

autocmd vimenter * ++nested colorscheme gruvbox
set background=dark    " Setting dark mode for gruvbox
