{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    nil
    nixpkgs-fmt

    # image plugin support:
    luajitPackages.magick
    imagemagick
  ];

  programs.nixvim = with config.lib.stylix.colors; {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = { mapleader = " "; maplocalleader = " "; };

    # --- Plugins ---
    extraPlugins = with pkgs; [
      vimPlugins.nvim-biscuits # annotations at the end of a closing tag/bracket/parenthesis/etc
      vimPlugins.vim-table-mode # :help table-mode. <leader>tic <leader>tdc
    ];

    plugins = {
      treesitter = {
        enable = true; # need for nvim-biscuits
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
      nix.enable = true;
      # yazi.enable = true; # :Yazi

      image = {
        enable = true;
        settings = {
          processor = "magick_cli"; # "magick_cli" or "magick_rock"
          backend = "kitty";
          max_height = 12;
          max_width = 20;
          integrations.markdown = {
            enabled = true;
            only_render_image_at_cursor = true;
            only_render_image_at_cursor_mode = "inline"; # "popup" or "inline"
            floating_windows = true;
          };
        };
      };

      render-markdown = {
        enable = true;
        settings = {
          render_modes = true; # true mean all modes
          sign.enabled = false; # icon on number column
          bullet.icons = [ "- " "* " "- " ]; # list icons
          # indent = { enabled = true; icon = ""; };
          code = {
            width = "block";
            border = "thin"; # hide it is very annoying!!!
            # right_pad = 1;
            # left_pad = 1;
          };
          heading = {
            icons = [
              "# "
              "## "
              "### "
              "#### "
              "##### "
              "###### "
            ];
            backgrounds = [ "" ]; # disable color bg
          };
        };
      };

      colorizer.enable = true; # colors for hex code
      blink-indent = {
        enable = true;
        settings = {
          mappings = { goto_top = "[i"; goto_bottom = "]i"; };
          static = {
            enabled = true;
            # char = "│";
            highlights = [ "BlinkIndent" ];
          };
          scope = {
            enabled = true;
            # char = "│";
            highlights = [
              "BlinkIndentYellow"
              "BlinkIndentCyan"
              "BlinkIndentRed"
              "BlinkIndentGreen"
              "BlinkIndentViolet"
              "BlinkIndentOrange"
            ];
          };
        };
      };

      lualine = {
        enable = true; # statusline
        settings.options = {
          icons_enabled = false;
          section_separators = "";
          component_separators = "";
        };
      };

      mini = {
        enable = true;
        modules = {
          basics = { };
          comment = { };
          completion = { };
          surround = { };
          pairs = { };
          notify = { };
          git = { };
          diff = { };
          pick = { }; # like telescope
        };
      };

      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          html.enable = true;
          nil_ls = {
            enable = true; # nix language server
            settings = {
              nix.flake.autoArchive = true;
              formatting.command = [ "nixpkgs-fmt" ]; # autoformat
            };
          };
        };
      };

      lsp-format = { enable = true; lspServersToEnable = "all"; };
    };

    highlightOverride = {
      # line number column colors bg
      "LineNrAbove".bg = "#${base00}";
      # "CursorLineSign".bg = "#${base00}";
      "CursorLineNr".bg = "#${base01}";
      "SignColumn".bg = "#${base00}";
      "LineNr".bg = "#${base00}";
      "LineNrBelow".bg = "#${base00}";

      # line number column colors fg
      "LineNrAbove".fg = "#${base03}";
      "LineNr".fg = "#${base03}";
      "CursorLineNr".fg = "#${base04}";
      "LineNrBelow".fg = "#${base03}";

      # indent line colors
      "BlinkIndent".fg = "#${base01}";
      "BlinkIndentRed".fg = "#${base08}";
      "BlinkIndentOrange".fg = "#${base09}";
      "BlinkIndentYellow".fg = "#${base0A}";
      "BlinkIndentGreen".fg = "#${base0B}";
      "BlinkIndentViolet".fg = "#${base0E}";
      "BlinkIndentCyan".fg = "#${base0D}";
    };

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

      # Other settings
      cursorline = true; # Highlight the current line
      ruler = true; # Show line and column when searching
      swapfile = false; # Disable the swap file
      fileencoding = "utf-8"; # File-content encoding for the current buffer
      spell = true; # Highlight spelling mistakes (local to window)
      wrap = true;
      linebreak = true;
      scrolloff = 4;
      termguicolors = true; # like base16 color scheme for me
    };

    extraConfigVim = ''
      " enable title and setup
      set title
      set titlestring=nvim

      " transparent bg
      autocmd VimEnter * highlight Normal guibg=NONE ctermbg=NONE
    '';

    # Setups for some files 
    autoCmd = [
      { event = "VimEnter"; command = "setlocal spell spelllang=en,ru"; }
      { event = "FileType"; pattern = "nix"; command = "setlocal tabstop=2 shiftwidth=2"; }
    ];

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
      # disable numbers
      {
        action = ''
          <cmd>if &number | set nonumber norelativenumber | set signcolumn=no | else | set number relativenumber | set signcolumn=yes | endif<CR>
        '';
        key = "<leader>n";
        mode = [ "n" "v" ];
        options.remap = true;
      }
      {
        action = ''
          <cmd>if &number | set nonumber norelativenumber | set signcolumn=no | else | set number relativenumber | set signcolumn=yes | endif<CR>
        '';
        key = "<leader>т"; # ru
        mode = [ "n" "v" ];
        options.remap = true;
      }


      # mini search (like telescope)
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>lua MiniPick.builtin.files(nil,{source={cwd='~'}})<CR>"; # search in home
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>lua MiniPick.builtin.grep_live(nil,{source={cwd='~'}})<CR>"; # search in home
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Pick buffers<CR>";
        options.desc = "Live buffers";
      }
      {
        mode = "n";
        key = "<leader>аа"; # rus
        action = "<cmd>lua MiniPick.builtin.files(nil,{source={cwd='~'}})<CR>"; # search in home
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>ап"; # rus
        action = "<cmd>lua MiniPick.builtin.grep_live(nil,{source={cwd='~'}})<CR>"; # search in home
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>аи";
        action = "<cmd>Pick buffers<CR>";
        options.desc = "Live buffers";
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
