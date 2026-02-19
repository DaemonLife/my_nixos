{ config, pkgs, ... }: {

  home.packages = with pkgs; [ nil nixpkgs-fmt ];

  programs.nixvim = with config.lib.stylix.colors; {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # --- Plugins ---
    extraPlugins = with pkgs; [
      vimPlugins.nvim-biscuits # annotations at the end of a closing tag/bracket/parenthesis/etc
      vimPlugins.vim-table-mode # :help table-mode. <leader>tic <leader>tdc
    ];

    plugins = {

      treesitter = {
        enable = true; # need for nvim-biscuits
        # highlight.enable = true;
        # indent.enable = true;
        # folding.enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          python
        ];
      };
      telescope.enable = true;
      nix.enable = true;
      render-markdown.enable = true;
      colorizer.enable = true; # colors for hex code
      comment.enable = true;
      nvim-autopairs.enable = true; # auto ""
      nvim-surround.enable = true; # auto "[text]"

      lsp = {
        enable = true;

        servers = {
          bashls.enable = true;
          html.enable = true;
          # nix language server
          nil_ls = {
            enable = true;
            settings = {
              nix.flake.autoArchive = true;
              formatting.command = [ "nixpkgs-fmt" ]; # autoformat
            };
          };
        };

      };

      # autocomplite
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };

      indent-blankline = {
        enable = true;
        # settings = { indent.char = "⁚"; };
        settings = { indent.char = "│"; };
      };

      lightline = {
        enable = true;
        settings = {
          active = {
            left = [ [ "mode" "paste" ] [ "readonly" "filename" "modified" ] ];
            right = [ [ "lineinfo" ] [ "percent" ] [ "fileformat" "fileencoding" "filetype" ] ];
          };
        };
      };

    };
    # --- Plugins ---

    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Search
      ignorecase = true;
      smartcase = true;
      incsearch = true; # show match for partly typed search command

      # Tab defaults (might get overwritten by an LSP server)
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 0;
      expandtab = true;
      smarttab = true;
      autoindent = true; # Do clever autoindenting

      # Highlight the current line
      cursorline = true;

      # Show line and column when searching
      ruler = true;

      # Start scrolling when the cursor is X lines away from the top/bottom
      scrolloff = 4;

      # Other settings
      swapfile = false; # Disable the swap file
      fileencoding = "utf-8"; # File-content encoding for the current buffer
      spell = true; # Highlight spelling mistakes (local to window)
      wrap = true;
      linebreak = true;
      termguicolors = true; # like base16 color scheme for me
    };

    extraConfigVim = "
        \" enable title and setup
        set title
        set titlestring=nvim

        \" transparent bg
        autocmd VimEnter * highlight Normal guibg=NONE ctermbg=NONE
      ";

    # Setups for some files 
    autoCmd = [
      { event = "VimEnter"; command = "setlocal spell spelllang=en,ru"; }
      { event = "FileType"; pattern = "nix"; command = "setlocal tabstop=2 shiftwidth=2"; }
    ];

    highlightOverride = {
      # status bar 
      "LightlineLeft_active_0" = { bg = "#${base0D}"; fg = "#${base00}"; };
      "LightlineLeft_active_1" = { bg = "#${base01}"; fg = "#${base03}"; };
      "LightlineMiddle_active" = { bg = "#${base01}"; fg = "#${base03}"; };
      "LightlineRight_active_0" = { bg = "#${base01}"; fg = "#${base03}"; };
      "LightlineRight_active_1" = { bg = "#${base01}"; fg = "#${base03}"; };
      "LightlineRight_active_2" = { bg = "#${base01}"; fg = "#${base03}"; };
      # number bar
      "LineNrAbove" = { bg = "#${base00}"; fg = "#${base03}"; };
      "CursorLineNr" = { bg = "#${base00}"; fg = "#${base05}"; };
      "LineNrBelow" = { bg = "#${base00}"; fg = "#${base03}"; };
    };

    keymaps = [
      { action = "<leader>"; key = " "; } # space is leader
      {
        action = ""; # don't make an annoying space 
        key = "<leader>"; 
        mode = [ "v" ];
      }
      {
        action = "";
        key = "<D-Space>"; # D is Super key
        mode = [ "i" ];
      }
      { action = "<C-u>"; key = "<C-г>"; } # rus up
      { action = "<C-d>"; key = "<C-в>"; } # rus down
      {
        action = "<C-w>";
        key = "<C-ц>"; # rus remove back word
        mode = "i";
        options.remap = true;
      }

      # telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>аа"; # rus
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>ап"; # rus
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }

      # --- new redo ---
      {
        action = "<cmd>redo<CR><CR>";
        key = "U";
        options.desc = "Redo.";
      }
      {
        action = "<cmd>redo<CR><CR>";
        key = "Г"; # rus
        options.desc = "Redo.";
      }

      # --- new clipboard control ---
      {
        action = ''"+yl'';
        key = "<leader>y";
        mode = [ "n" "v" ];
        options.desc = "Copy to system clipboard.";
      }
      {
        action = ''"+pl'';
        key = "<leader>p";
        mode = [ "n" "v" ];
        options.desc = "Paste from system clipboard.";
      }
      {
        action = ''"+yl'';
        key = "<leader>н"; # rus
        mode = [ "n" "v" ];
        options.desc = "Copy to system clipboard.";
      }
      {
        action = ''"+pl'';
        key = "<leader>з"; # rus
        mode = [ "n" "v" ];
        options.desc = "Paste from system clipboard.";
      }

      # --- new comment control ---
      {
        action = "gcc";
        key = "<leader>c";
        mode = "n";
        options = {
          remap = true;
          desc = "Comment in normal mode.";
        };
      }
      {
        action = "gc";
        key = "<leader>c";
        mode = "v";
        options = {
          remap = true;
          desc = "Comment in visual mode.";
        };
      }
      {
        action = "gcc";
        key = "<leader>с"; # rus
        mode = "n";
        options = {
          remap = true;
          desc = "Comment in normal mode.";
        };
      }
      {
        action = "gc";
        key = "<leader>с"; # rus
        mode = "v";
        options = {
          remap = true;
          desc = "Comment in visual mode.";
        };
      }

      # --- soft string jumping ---
      { action = "gj"; key = "j"; }
      { action = "gk"; key = "k"; }
      { action = "gj"; key = "о"; } # rus
      { action = "gk"; key = "л"; } # rus

    ];

    # extra plugin and ru keymap support
    extraConfigLua = ''
      require("nvim-biscuits").setup({ cursor_line_only = true })

      vim.opt.langmap = table.concat({
        "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
        "Ё;~",
        "ё;`",
        "№;#",
        "Х;[",
        "Ъ;]",
        "х;{",
        "ъ;}",
        "Ж;:",
        "ж;\;",
        "Э;\"",
        "э;'",
        "Б;<",
        "Ю;>",
        "б;\\,",
        "ю;.",
        ".;/",
        "\\,;?",
      }, ",")
    '';
  };

}
