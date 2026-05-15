{
  flake.modules.nixos.editor_vim = {
    hm.programs.vim = {
      enable = true;
      settings = {
        # Indentation
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        # Search
        ignorecase = true;
        smartcase = true;
        # UI
        number = true;
        relativenumber = true;
        # Behaviour
        hidden = true;
        undofile = true;
        undodir = ["$HOME/.local/share/vim/undo"];
      };
      extraConfig = ''
        " Search
        set incsearch
        " UI
        set cursorline
        set showcmd
        set wildmenu
        set scrolloff=8
        set showmatch
        " Behaviour
        set autoread
        set backspace=indent,eol,start
        set clipboard=unnamedplus
        " No swap/backup clutter
        set noswapfile
        set nobackup
        set nowritebackup
        " Faster redraw
        set lazyredraw
        set ttyfast
        " Split naturally
        set splitbelow
        set splitright
        " Remove trailing whitespace on save
        autocmd BufWritePre * :%s/\s\+$//e
      '';
    };
  };
}
