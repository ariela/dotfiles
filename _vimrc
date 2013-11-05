# プラグイン管理
if has('vim_starting')
    set nocompatible               " Be iMproved
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'altercation/vim-colors-solarized'
filetype plugin indent on
NeoBundleCheck

# カラースキーマ設定
syntax enable
set background=dark
colorscheme solarized

