set encoding=utf8
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
"set expandtab
"set noexpandtab
set smarttab
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.
set softtabstop=4
set modeline            " Enable modeline.
set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.
if !&scrolloff
    set scrolloff=7       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
    set sidescrolloff=10   " Show next 5 columns while side-scrolling.
endif
set display+=lastline
set nostartofline       " Do not jump to first character with page commands.
"set winbar=%f
"set laststatus=3 " Always show status bar
set statusline=%F%m%r%h%w%=\ [%Y]\ [%{&ff}]\ [%04l,%04v]\ [%p%%]\ [%L]
set updatetime=500 " Let plugins show effects after 500ms, not 4s
if has('mouse')
    set mouse=a
endif
set completeopt=menuone,noinsert " Don't let autocomplete affect usual typing habits
set completeopt-=preview
set hidden
set history=100
set autoread " Set to auto read when a file is changed from the outside
set wildmenu " Turn on the WiLd menu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set cmdheight=1   " Height of the command bar
set hid           " A buffer becomes hidden when it is abandoned
set mat=2         " How many tenths of a second to blink when matching brackets
set noerrorbells " No annoying sound on errors
set novisualbell
set t_vb=
set tm=500
set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
set cc=80               " Highlight column
set list                " Show problematic characters.
set hlsearch            " Highlight search results.
set ignorecase          " Make searching case-insensitive
set smartcase           " ... unless the query has capital letters.
set incsearch           " Incremental search.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).
set nobackup " Disable swap and backup
set noswapfile
set nowb
set lbr " Linebreak on 500 characters
set tw=500
set autoindent "Auto indent
set smartindent "Smart indent
set wrap "Wrap lines
set foldmethod=indent
set foldlevel=99
set t_Co=256 "256 color term

" show/hide statusline
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <S-h> :call ToggleHiddenAll()<CR>

" Reload config on savings
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim

autocmd BufEnter *.tpp :setlocal filetype=cpp " Add cpp syntax for .tpp files
autocmd FileType make set noexpandtab nosta
autocmd FileType md set expandtab nosta

au BufNewFile,BufRead *.js, *.html, *.css
            \ set tabstop=2
            \ set softtabstop=2
            \ set shiftwidth=2

let g:mapleader = ";"
inoremap ;; <esc>
nnoremap <leader>w :update<cr>

" Relative numbering
function! NumberToggle()
    if(&relativenumber == 1)
        set nornu
        set number
    else
        set rnu
    endif
endfunc
" Toggle between normal and relative numbering.
nnoremap <leader>r :call NumberToggle()<cr>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Get terminal get input focus when switching to terminal window
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" Easy switch between vims tab
nnoremap tc :tabnew<CR>
nnoremap td :tabclose<CR>
nnoremap tp :tabprev<CR>
nnoremap tn :tabnext<CR>

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Move in wrapped lines instead of jumping over them
nnoremap j gj
nnoremap k gk

" Edit files with permission even after opened
cmap w!! w !sudo tee %

" Current line highlithing
hi CursorLineNR cterm=bold
augroup CLNRSet
    autocmd! ColorScheme * hi CursorLineNR cterm=bold
augroup END

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

set lazyredraw
syntax sync minlines=128

" vp doesn't replace paste buffer
function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Autosave when focus is lost from window
au FocusLost * wa

" Send lines in range to hastebin.com and copy url to clipboard
command! -range -bar Haste <line1>,<line2>w !haste | xsel -b

" Neovim Terminal Colors
let g:terminal_color_0  = '#1d2021'
let g:terminal_color_1  = '#cc241d'
let g:terminal_color_2  = '#98971a'
let g:terminal_color_3  = '#d79921'
let g:terminal_color_4  = '#458588'
let g:terminal_color_5  = '#b16286'
let g:terminal_color_6  = '#689d6a'
let g:terminal_color_7  = '#a89984'
let g:terminal_color_8  = '#928374'
let g:terminal_color_9  = '#fb4934'
let g:terminal_color_10 = '#b8bb26'
let g:terminal_color_11 = '#fabd2f'
let g:terminal_color_12 = '#83a598'
let g:terminal_color_13 = '#d3869b'
let g:terminal_color_14 = '#8ec07c'
let g:terminal_color_15 = '#ebdbb2'

""" Quick windows close
nnoremap <C-q>h :Qh <CR>
nnoremap <C-q>j :Qj <CR>
nnoremap <C-q>k :Qk <CR>
nnoremap <C-q>l :Ql <CR>

""""""""""" plug
call plug#begin()

" UI plugins
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'blueshirts/darcula'
Plug 'dracula/vim'
Plug 'crusoexia/vim-monokai'
Plug 'flazz/vim-colorschemes'
Plug 'mbbill/undotree'
Plug 'tpope/vim-characterize'
Plug 'ntpeters/vim-better-whitespace'
Plug 'lilydjwg/colorizer'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'tpope/vim-fugitive' " git wrapper
"Plug 'zenbro/mirror.vim'
"Plug 'mhinz/vim-startify'
"Plug 'dietsche/vim-lastplace'
"Plug 'tpope/vim-eunuch'
"Plug 'vim-scripts/quit-another-window'
"Plug 'pbrisbin/vim-mkdir'
"Plug 'ctrlpvim/ctrlp.vim' " fuzzy file,buff,ecc finder
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
"Plug 'tpope/vim-repeat'
Plug 'terryma/vim-smooth-scroll'
"Plug 'sunaku/vim-shortcut'
"Plug 'reedes/vim-wheel'
"Plug 'matze/vim-move'
"Plug 'tpope/vim-surround'
"Plug 'easymotion/vim-easymotion'
"Plug 'powerman/vim-plugin-viewdoc'
"Plug 'bkad/CamelCaseMotion'
"Plug 'tmhedberg/SimpylFold'
"Plug 'vim-scripts/YankRing.vim'
Plug 'Shougo/deoplete.nvim' , { 'do': ':UpdateRemotePlugins' }
"Plug 'zchee/deoplete-clang'
"Plug 'sebastianmarkow/deoplete-rust'
"Plug 'rust-lang/rust.vim'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'zchee/deoplete-jedi'
Plug 'vim-scripts/indentpython.vim'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'szw/vim-tags'
"Plug 'sheerun/vim-polyglot'
"Plug 'ludovicchabant/vim-gutentags'
Plug 'wvffle/vimterm'
Plug 'Chiel92/vim-autoformat'
Plug 'plasticboy/vim-markdown'
"Plug 'thinca/vim-quickrun'
"Plug 'lervag/vimtex'
"Plug 'godlygeek/tabular'
Plug 'itspriddle/vim-shellcheck'

call plug#end()

filetype plugin indent on
syntax on

set background=dark
colorscheme molokai
"colorscheme monokai
"colorscheme darcula
"colorscheme badwolf

""" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1

let b:usemarks         = 1
let b:cb_jump_on_close = 1

""" NerdTree config
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <silent> <Space> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1 " Show hidden file
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp'] " Ignore file
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ "Unknown"   : "?"
            \ }

""" Startify config
let g:startify_enable_unsafe = 0

""" vim-smooth-scroll config
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 2)<CR>
noremap <silent> <c-i> :call smooth_scroll#down(&scroll, 5, 2)<CR>

""" Cpp enhanced sintax highligthing
let g:cpp_class_scope_highlight = 1 " Highlighting of class scope
let g:cpp_experimental_simple_template_highlight = 1 " Hightlight template functions
let g:cpp_concepts_highlight = 1 " Highlighting of library concepts

""" Neoformat config
nmap <Leader>R :Neoformat<CR>
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1 " Enable tab to space conversion

""" Mirrors.vim config
" Add a mapping for pushing to the server
nmap <Leader>p :MirrorPush<CR>

""" vim-wheel config
let g:wheel#map#up   = '<m-y>'
let g:wheel#map#down = '<m-e>'

""" Vimterm config
nnoremap <F7> :call vimterm#toggle() <CR>
tnoremap <F7> <C-\><C-n>:call vimterm#toggle() <CR>

""" Undotree config
nnoremap <F5> :UndotreeToggle<cr>
" Focus undotree when showing it
let g:undotree_SetFocusWhenToggle = 1
" Add persistent undo history between files
if has("persistent_undo")
    set undodir=~/.cache/undodir/
    set undofile
endif

""" vim-better-whitespace config
autocmd BufEnter * EnableStripWhitespaceOnSave " Enable stripping on save
" Whitespaces color
highlight ExtraWhitespace ctermbg=darkred guibg=darkred

""" deoplete
let g:deoplete#enable_at_startup = 1

""" rust
let g:deoplete#sources#rust#rust_source_path='/usr/lib/rustlib/src/rust/src'
let g:deoplete#sources#rust#racer_binary='/usr/bin/racer'
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'
"let g:deoplete#sources#clang#libclang_path = '/usr/lib64/llvm/5/lib64/libclang.so'
"let g:deoplete#sources#clang#clang_header = '/usr/lib64/llvm/5/include/clang/'

""" golang
" go get -u github.com/nsf/gocode
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:go_fmt_command = "goimports"
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
let s:tlist_def_go_settings = 'go;g:enum;s:struct;u:union;t:type;' .
                           \ 'v:variable;f:function'

""" python
let g:python_recommended_style = 1
let g:python3_host_prog  = '/usr/bin/python3'
let g:python3_host_skip_check = 1
let g:formatter_yapf_style = 'pep8'

"noremap <F3> :Autoformat<CR>
"au BufWrite * :Autoformat
nnoremap <silent> <leader>b :TagbarToggle<CR>
nmap <F8> :TagbarToggle<CR>

function! MyOnBattery()
    return readfile('/sys/class/power_supply/AC/online') == ['0']
endfunction

"if MyOnBattery()
"  call neomake#configure#automake('w')
"  call deoplete#disable()
"else
"  call neomake#configure#automake('nw', 1000)
"  call deoplete#enable()
"endif

" ctrlp.vim
let g:ctrlp_map = '<c-p>' " after paste ctrl+p switch between clipboard and register
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = ''

"""" utilsnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-z>"
let g:UltiSnipsEditSplit = "vertical" " If you want :UltiSnipsEdit to split your window.

""" multi selection
let g:multi_cursor_use_default_mapping=1
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

let g:SimpylFold_docstring_preview=1
