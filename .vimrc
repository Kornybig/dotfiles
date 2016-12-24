" OPTIONS FOR VIM
	set relativenumber
	set exrc
	set secure


" FOR TABS
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	set noexpandtab


" OPTIONS FOR MAXWIDTH
	set colorcolumn=110
	highlight ColorColumn ctermbg=darkgray

" For C-PROGRAMMING
augroup project
	autocmd!
	autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END


" For vundle
	set nocompatible
	filetype off
	
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
	
	" Plugins
	Plugin 'VundleVim/Vundle.vim'

	"Lighline
	Plugin 'itchyny/lightline.vim'

	" Sorrounding
	Plugin 'tpope/vim-surround'

	" EMMET PLUGIN
	Plugin 'mattn/emmet-vim'

	" L9
	Plugin 'vim-scripts/L9'
		
	" Fuzzyfinder
	Plugin 'vim-scripts/FuzzyFinder'
		"OPTIONS FOR FUZZYFINDER
		nnoremap <Leader>b :FufBuffer<cr>
		nnoremap <Leader>f :FufFile **/<cr>
	"YouCompleteMe
	Plugin 'Valloric/YouCompleteMe'

	"Theme-Plugin"
	Plugin 'kristijanhusak/vim-hybrid-material'
		"Options for Theme-Plugin
		let g:enable_bold_font = 1
		set background=dark
		colorscheme hybrid_material

	"NERDTREE PLUGIN
	Plugin 'scrooloose/nerdtree'
		"NERDTREE OPTIONS
		autocmd vimenter * NERDTree	"OPENS NERDTREE WHEN VIM STARTS
	call vundle#end()
	filetype plugin indent on


