" Set filetype stuff to on {{{
filetype on
filetype plugin on
filetype indent on
" }}}

" Switch on syntax highlighting {{{
syntax enable
" }}}

" 1 important {{{

" behave very Vi compatible (not advisable)
set nocp

" }}}

" 2 moving around, searching and patterns {{{

" show match for partly typed search command
set is

" ignore case when using a search pattern
set ic

" override 'ignorecase' when pattern has upper case characters
set scs

" }}}

" 4 displaying text {{{

" number of screen lines to show around the cursor
set so=8

" long lines wrap
set nowrap

" string to put before wrapped screen lines
set sbr=+++

" do redraw while executing macros
set lz

" }}}

" 5 syntax, highlighting and spelling {{{

" highlight all matches for the last used search pattern
set hls

" columns to highlight
set cc=+1

" highlight spelling mistakes
set spell

" }}}

" 6 multiple windows {{{

" do unload a buffer when no longer shown in a window
set hid

" a new window is put below the current one
set sb

" a new window is put right of the current one
set spr

" }}}

" 10 GUI {{{

" list of font names to be used in the GUI
set gfn=Monospace\ 12

" list of flags that specify how the GUI works
set go=c

" }}}

" 12 messages and info {{{

" show (partial) command keys in the status line
set sc

" use a visual bell instead of beeping
set visualbell t_vb=

" }}}

" 14 editing text {{{

" line length above which to break a line
set tw=120

" }}}

" 15 tabs and indenting {{{

" number of spaces a <Tab> in the text stands for
set ts=4

" number of spaces used for each step of (auto)indent
set sw=4

" round to 'shiftwidth' for "<<" and ">>"
set sr

" expand <Tab> to spaces in Insert mode
set et

" }}}

" 17 diff mode {{{

" options for using diff mode
set diffopt=filler,horizontal,iwhite

" }}}

" 19 reading and writing files {{{

" don't write a backup file before overwriting a file
set nowb

" }}}

" 20 the swap file {{{

" use a swap file for this buffer
set noswf

" }}}

" 21 command line editing {{{

" key that triggers command-line expansion
set wc=<Tab>

" like 'wildchar' but can also be used in a mapping
set wcm=<C-Z>

" list of file name extensions that have a lower priority
set su=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" command-line completion shows a list of matches
set wmnu

" }}}

" Mappings and abbreviations {{{

let mapleader = ","
let maplocalleader = ","

nnoremap <space> ,
nnoremap <Leader>b :b 
nnoremap <Leader>f :find 
cnoremap jk <c-c>
inoremap jk <esc>

nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel

iabbrev adn and

" }}}

" Vimscript file settings {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Ruby file settings {{{
augroup filetype_ruby
	autocmd!

	autocmd FileType ruby colorscheme molokai

	autocmd FileType ruby setlocal expandtab
	autocmd FileType ruby setlocal shiftwidth=2
	autocmd FileType ruby setlocal softtabstop=2
	autocmd FileType ruby setlocal foldmethod=syntax
	autocmd FileType ruby setlocal nospell

	" program used for the ":make" command
	autocmd FileType ruby setlocal gp=git\ grep\ -n
    autocmd FileType ruby compiler rake

	" autocmd BufWritePre *.rb :normal gg=G
    " autocmd BufWritePre *.rb :normal ``

	autocmd FileType ruby nnoremap <buffer> <localleader>c I# 
	autocmd FileType ruby inoremap <buffer> <localleader>u <esc>bveUea
	autocmd FileType ruby inoremap <buffer> ' ''<left>
	autocmd FileType ruby inoremap <buffer> " ""<left>

	autocmd FileType ruby iabbrev <buffer> class class<esc>boend<esc>bkea
	autocmd FileType ruby iabbrev <buffer> def def<esc>boend<esc>bkea
	autocmd FileType ruby iabbrev <buffer> if if<esc>boend<esc>bkea
	autocmd FileType ruby iabbrev <buffer> while while<esc>boend<esc>bkea

augroup END
" }}}
