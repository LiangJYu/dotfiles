" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible
set nocompatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
if has ('mouse')
  set mouse=a		" Enable mouse usage (all modes)
endif

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" everything after this is NOT Vim default
" set number          " display line numbers
set nu rnu
set numberwidth=6   " set width of line number column

set history=500
set showcmd

set hlsearch

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

set noerrorbells
set laststatus=2

set autoindent
filetype plugin indent on

set statusline=%F\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

set autoread

set foldmethod=indent

if !has('nvim')
    if has("mouse_sgr")
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    end
endif

set vb t_vb=        " no visual bell & flash

" Apply C++ syntax highligting to icc files
autocmd BufNewFile,BufRead *.icc set syntax=cpp

" Strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" set up tab labels with tab number, buffer name, number of windows
if exists("+showtabline")
  function! MyTabLine()
    let s = ''
    let wn = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= ' '
      let wn = tabpagewinnr(i,'$')

      let s .= (i== t ? '%#TabNumSel#' : '%#TabNum#')
      let s .= i
      if tabpagewinnr(i,'$') > 1
        let s .= '.'
        let s .= (i== t ? '%#TabWinNumSel#' : '%#TabWinNum#')
        let s .= (tabpagewinnr(i,'$') > 1 ? wn : '')
      end

      let s .= ' %*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let bufnr = buflist[winnr - 1]
      let file = bufname(bufnr)
      let buftype = getbufvar(bufnr, 'buftype')
      if buftype == 'nofile'
        if file =~ '\/.'
          let file = substitute(file, '.*\/\ze.', '', '')
        endif
      else
        let file = fnamemodify(file, ':p:t')
      endif
      if file == ''
        let file = '[No Name]'
      endif
      let s .= file

      " mod check
      let m = 0
      for b in tabpagebuflist(i)
        if getbufvar( b, "&modified" )
          let m += 1
        endif
      endfor
      if m > 0
        let s .= '[' . m . '+]'
      endif

      let s .= (i == t ? '%m' : '')
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    return s
  endfunction
  set stal=2
  set tabline=%!MyTabLine()
endif

set statusline+=%#warningmsg#
set statusline+=%*


" vimplug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'valloric/youcompleteme'
Plug 'yggdroot/indentline'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/syntastic'
Plug 'yegappan/grep'
Plug 'airblade/vim-gitgutter'
call plug#end()

" you complete me
let g:ycm_clangd_binary_path = "/use/bin/clangd"


" syntastic options
if get(g:, 'loaded_syntastic_plugin', 0)
  set statusline+=%{SyntasticStatuslineFlag()}
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_enable_signs = 1
  let g:syntastic_cpp_check_header = 1
  let g:syntastic_cpp_config_file = '.syntastic_cpp_config'
  let g:syntastic_cuda_check_header = 1
  let g:syntastic_cuda_config_file = '.syntastic_cuda_config'
endif
