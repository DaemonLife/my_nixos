{ config, pkgs, ... }: {

  home.packages = with pkgs; [ nil nixpkgs-fmt ];

  programs.nixvim = with config.lib.stylix.colors;
    {
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

        treesitter.enable = true; # need for nvim-biscuits
        render-markdown.enable = true;
        nix.enable = true;

        lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            html.enable = true;
            nil_ls = {
              # nix language server
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

        colorizer.enable = true; # colors for hex code

        comment = { enable = true; };

        nvim-autopairs.enable = true; # auto ""
        nvim-surround.enable = true; # auto "[text]"

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
              right = [
                [ "lineinfo" ]
                [ "percent" ]
                [ "fileformat" "fileencoding" "filetype" ]
              ];
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

      autoCmd = [
        # Setups for some files 
        {
          event = "VimEnter";
          command = "setlocal spell spelllang=en,ru";
        }
        {
          event = "FileType";
          pattern = "nix";
          command = "setlocal tabstop=2 shiftwidth=2";
        }
      ];

      highlightOverride = {
        # status bar 
        "LightlineLeft_active_0" = {
          bg = "#${base0D}";
          fg = "#${base00}";
        };
        "LightlineLeft_active_1" = {
          bg = "#${base01}";
          fg = "#${base03}";
        };
        "LightlineMiddle_active" = {
          bg = "#${base01}";
          fg = "#${base03}";
        };
        "LightlineRight_active_0" = {
          bg = "#${base01}";
          fg = "#${base03}";
        };
        "LightlineRight_active_1" = {
          bg = "#${base01}";
          fg = "#${base03}";
        };
        "LightlineRight_active_2" = {
          bg = "#${base01}";
          fg = "#${base03}";
        };

        # number bar
        "LineNrAbove" = { bg = "#${base00}"; fg = "#${base03}"; };
        "CursorLineNr" = { bg = "#${base00}"; fg = "#${base05}"; };
        "LineNrBelow" = { bg = "#${base00}"; fg = "#${base03}"; };
      };

      keymaps = [

        # disable 
        {
          action = "";
          key = "<leader>";
          mode = [ "v" ];
        }
        {
          action = "";
          # D is Super key
          key = "<D-Space>";
          mode = [ "i" ];
        }
        {
          action = "<leader>";
          key = " ";
        }

        # fixs for ru 
        {
          action = "<C-u>";
          key = "<C-г>";
        }
        {
          action = "<C-d>";
          key = "<C-в>";
        }

        # --- new redo ---
        {
          action = "<cmd>redo<CR><CR>";
          key = "U";
          options.desc = "Redo.";
        }
        # rus
        {
          action = "<cmd>redo<CR><CR>";
          key = "Г";
          options.desc = "Redo.";
        }
        # --- new redo ---

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
        # rus
        {
          action = ''"+yl'';
          key = "<leader>н";
          mode = [ "n" "v" ];
          options.desc = "Copy to system clipboard.";
        }
        {
          action = ''"+pl'';
          key = "<leader>з";
          mode = [ "n" "v" ];
          options.desc = "Paste from system clipboard.";
        }
        # --- new clipboard control ---

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
        # rus
        {
          action = "gcc";
          key = "<leader>с";
          mode = "n";
          options = {
            remap = true;
            desc = "Comment in normal mode.";
          };
        }
        {
          action = "gc";
          key = "<leader>с";
          mode = "v";
          options = {
            remap = true;
            desc = "Comment in visual mode.";
          };
        }
        # --- new comment control ---

        # --- soft string jumping ---
        {
          action = "gj";
          key = "j";
        }
        {
          action = "gk";
          key = "k";
        }
        # rus
        {
          action = "gj";
          key = "о";
        }
        {
          action = "gk";
          key = "л";
        }
        # --- soft string jumping ---

        # -- delete back word for rus ---
        {
          action = "<C-w>";
          key = "<C-ц>";
          mode = "i";
          options = {
            remap = true;
          };
        }
        # -- delete back word for rus ---
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
