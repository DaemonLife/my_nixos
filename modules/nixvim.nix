{ config, pkgs, ... }: {

  home.packages = with pkgs; [ nil nixpkgs-fmt ];

  programs.nixvim = with config.lib.stylix.colors; {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # --- Plugins ---
    extraPlugins = with pkgs; [
      vimPlugins.nvim-biscuits # annotations at the end of a closing tag/bracket/parenthesis/etc
    ];

    extraConfigLua = ''
      require("nvim-biscuits").setup({ cursor_line_only = true })
    '';

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
            settings.formatting.command = [
              "nixpkgs-fmt" # autoformat
            ];
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
        settings = { indent.char = "┆"; };
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
      langmap = # Russian language support
        "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz";
    };

    extraConfigVim = "";

    autoCmd = [
      # Setups for some files 
      {
        event = "FileType";
        pattern = [ "tex" "latex" "markdown" ];
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

      # disable space
      {
        action = "";
        key = "<space>";
      }
      {
        action = "";
        key = "<D-Space>";
        mode = "i";
      }

      # --- new redo ---
      {
        action = "<cmd>redo<CR><CR>";
        key = "U";
        options.desc = "Redo.";
      }
      {
        action = "";
        key = "<C-r>";
      }
      # --- new redo ---

      # --- new clipboard control ---
      {
        action = ''"+yl'';
        key = "<space>y";
        mode = [ "n" "v" ];
        options.desc = "Copy to system clipboard.";
      }
      {
        action = ''"+pl'';
        key = "<space>p";
        mode = [ "n" "v" ];
        options.desc = "Paste from system clipboard.";
      }
      # --- new clipboard control ---

      # --- new comment control ---
      {
        action = "gcc";
        key = "<space>c";
        mode = "n";
        options = {
          remap = true;
          desc = "Comment in normal mode.";
        };
      }
      {
        action = "gc";
        key = "<space>c";
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
      # --- soft string jumping ---

      # --- rus layout support ---
      # {
      #   action = "q";
      #   key = "й";
      # }
      # {
      #   action = "Q";
      #   key = "Й";
      # }
      # {
      #   action = "w";
      #   key = "ц";
      # }
      # {
      #   action = "W";
      #   key = "Ц";
      # }
      # {
      #   action = "e";
      #   key = "у";
      # }
      # {
      #   action = "E";
      #   key = "У";
      # }
      # {
      #   action = "r";
      #   key = "к";
      # }
      # {
      #   action = "R";
      #   key = "К";
      # }
      # {
      #   action = "t";
      #   key = "е";
      # }
      # {
      #   action = "T";
      #   key = "Е";
      # }
      # {
      #   action = "y";
      #   key = "н";
      # }
      # {
      #   action = "Y";
      #   key = "Н";
      # }
      # {
      #   action = "u";
      #   key = "г";
      # }
      # {
      #   action = "U";
      #   key = "Г";
      # }
      # {
      #   action = "i";
      #   key = "ш";
      # }
      # {
      #   action = "I";
      #   key = "Ш";
      # }
      # {
      #   action = "o";
      #   key = "щ";
      # }
      # {
      #   action = "O";
      #   key = "Щ";
      # }
      # {
      #   action = "p";
      #   key = "з";
      # }
      # {
      #   action = "P";
      #   key = "З";
      # }
      # {
      #   action = "[";
      #   key = "х";
      # }
      # {
      #   action = "{";
      #   key = "Х";
      # }
      # {
      #   action = "a";
      #   key = "ф";
      # }
      # {
      #   action = "A";
      #   key = "Ф";
      # }
      # {
      #   action = "s";
      #   key = "ы";
      # }
      # {
      #   action = "S";
      #   key = "Ы";
      # }
      # {
      #   action = "d";
      #   key = "в";
      # }
      # {
      #   action = "D";
      #   key = "В";
      # }
      # {
      #   action = "f";
      #   key = "а";
      # }
      # {
      #   action = "F";
      #   key = "А";
      # }
      # {
      #   action = "g";
      #   key = "п";
      # }
      # {
      #   action = "G";
      #   key = "П";
      # }
      # {
      #   action = "h";
      #   key = "р";
      # }
      # {
      #   action = "H";
      #   key = "Р";
      # }
      # {
      #   action = "gj";
      #   key = "о";
      # }
      # {
      #   action = "J";
      #   key = "О";
      # }
      # {
      #   action = "gk";
      #   key = "л";
      # }
      # {
      #   action = "K";
      #   key = "Л";
      # }
      # {
      #   action = "l";
      #   key = "д";
      # }
      # {
      #   action = "L";
      #   key = "Д";
      # }
      # {
      #   action = ";";
      #   key = "ж";
      # }
      # {
      #   action = ":";
      #   key = "Ж";
      # }
      # {
      #   action = "z";
      #   key = "я";
      # }
      # {
      #   action = "Z";
      #   key = "Я";
      # }
      # {
      #   action = "x";
      #   key = "ч";
      # }
      # {
      #   action = "X";
      #   key = "Ч";
      # }
      # {
      #   action = "c";
      #   key = "с";
      # }
      # {
      #   action = "C";
      #   key = "С";
      # }
      # {
      #   action = "v";
      #   key = "м";
      # }
      # {
      #   action = "V";
      #   key = "М";
      # }
      # {
      #   action = "b";
      #   key = "и";
      # }
      # {
      #   action = "B";
      #   key = "И";
      # }
      # {
      #   action = "n";
      #   key = "т";
      # }
      # {
      #   action = "N";
      #   key = "Т";
      # }
      # {
      #   action = "m";
      #   key = "ь";
      # }
      # {
      #   action = "M";
      #   key = "Ь";
      # }
      # {
      #   action = ",";
      #   key = "б";
      # }
      # {
      #   action = "<";
      #   key = "Б";
      # }
      # {
      #   action = ".";
      #   key = "ю";
      # }
      # {
      #   action = ">";
      #   key = "Ю";
      # }
      # {
      #   action = "/";
      #   key = "я";
      # }
      # {
      #   action = "?";
      #   key = "Я";
      # }
      # --- rus layout support ---
    ];
  };

}
