let g:signify_vcs_list = [ 'git' ]
execute pathogen#infect()
syntax enable
se t_Co=256

autocmd FileType cpp setlocal ts=4 sts=4 sw=4
autocmd FileType java setlocal ts=4 sts=4 sw=4
autocmd FileType py setlocal ts=4 sts=4 sw=4

set ts=8
set sts=8
set sw=8

set number				" line numbering
"set mouse=a				" enable mouse
set incsearch			" incremental search
filetype plugin on		" filetype plugin
set autoindent			" auto indentation
set laststatus=2
set ruler
set lazyredraw 			" don't redraw when executing macros
set smartcase
set wildmenu
set backspace=2

nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

" dragvisuals keybindings
"vmap  <expr>  <LEFT>   DVB_Drag('left')
"vmap  <expr>  <RIGHT>  DVB_Drag('right')
"vmap  <expr>  <DOWN>   DVB_Drag('down')
"vmap  <expr>  <UP>     DVB_Drag('up')
"vmap  <expr>  D        DVB_Duplicate()

" tab navigation
nmap <C-l> :tabnext<CR>
nmap <C-k> :tabprevious<CR>
map <C-w> :tabclose<CR>

" no more > 80 col lines
"set colorcolumn=80

let g:highlighting = 0
function! Highlighting()
  if g:highlighting == 1 && @/ =~ '^\\<'.expand('<cword>').'\\>$'
    let g:highlighting = 0
    return ":silent nohlsearch\<CR>"
  endif
  let @/ = '\<'.expand('<cword>').'\>'
  let g:highlighting = 1
  return ":silent set hlsearch\<CR>"
endfunction
nnoremap <silent> <expr> <C-i> Highlighting()

let g:S = 0  "result in global variable S
function! Sum(number)
  let g:S = g:S + a:number
  return a:number
endfunction

command Mymake make! | copen

" leader bindings
let mapleader = ","

map <Leader>v :tabedit ~/.vimrc<cr>
map <Leader>e :tabedit
map <Leader>r :source ~/.vimrc<cr>
map <Leader>w :w<cr>
map <Leader>q :q<cr>
map <Leader>m :Mymake<cr>
map <Leader>c :copen<cr>
map <Leader>C :cw<cr>

autocmd FileType scheme map <buffer> <leader>o :w !racket<cr>

" delete trailing spaces in abbreviations
" stolen from vim manual
function! Eatchar()
	let c = nr2char(getchar())
	return (c =~ '\s') ? '' : c
endfunction

" abbreviations
iabbr fori for (i = 0; i < 10; i++) {<cr>}
iabbr forj for (j = 0; j < 10; j++) {<cr>}
iabbr for2 for (i = 0; i < 10; i++) {<cr><tab>for (j = 0; j < 10; j++) {<cr><right><cr><bs><esc>llo<tab>
iabbr javashit public class <C-R>=expand("%:r")<cr> {<cr><tab>public static void main(String[] args) {<cr><right><cr><bs><esc>llo<tab>
iabbr sop System.out.println("");<esc>2hi<C-R>=Eatchar()<cr>
iabbr sof System.out.printf("", );<esc>4hi<C-R>=Eatchar()<cr>
iabbr tryc try {<cr>} catch (Exception e) {<cr><tab>e.printStackTrace();<cr><bs>}<esc>lllo<tab>
iabbr #d #define
iabbr #i #include <><left><C-R>=Eatchar()<cr>
iabbr prf printf("\n");<esc>4hi<C-R>=Eatchar()<cr>
iabbr javapls ``` java<cr><cr>```

augroup templates
  au!
  " read in templates files
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/template.'.expand("<afile>:e")
augroup END

" NERDTree
map <C-e> :NERDTreeToggle<CR>

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

function! EasyInclude()
  "let curline = getline('.')
  normal! mm
  call inputsave()
  let name = input('include: ')
  normal! gg}
  call setline('.', name)
  call inputrestore()
  normal! i#include <
  normal! $a.h>
  normal! o
  normal! `m
endfunction

nnoremap <Leader>i :call EasyInclude()<cr>
inoremap <Leader>i <esc>:call EasyInclude()<cr>i

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" autocmds to automatically enter hex mode and handle file writes properly
if has("autocmd")
  " vim -b : edit binary using xxd-format!
  augroup Binary
    au!

    " set binary option for all binary files before reading them
    au BufReadPre *.bin,*.hex setlocal binary

    " if on a fresh read the buffer variable is already set, it's wrong
    au BufReadPost *
          \ if exists('b:editHex') && b:editHex |
          \   let b:editHex = 0 |
          \ endif

    " convert to hex on startup for binary files automatically
    au BufReadPost *
          \ if &binary | Hexmode | endif

    " When the text is freed, the next time the buffer is made active it will
    " re-read the text and thus not match the correct mode, we will need to
    " convert it again if the buffer is again loaded.
    au BufUnload *
          \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
          \   call setbufvar(expand("<afile>"), 'editHex', 0) |
          \ endif

    " before writing a file when editing in hex mode, convert back to non-hex
    au BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd -r" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif

    " after writing a binary file, if we're in hex mode, restore hex mode
    au BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd" |
          \  exe "set nomod" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
  augroup END
endif

" Use neocomplete
let g:neocomplete#enable_at_startup = 1
" Use smartcase
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return neocomplete#smart_close_popup() . "\<CR>"
	" For no inserting <CR> key.
	"return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"<C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

autocmd FileType asm NeoCompleteLock

let g:signify_vcs_list = [ 'git' ]

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
