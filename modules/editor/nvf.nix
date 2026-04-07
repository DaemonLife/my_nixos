{ config
, pkgs
, lib
, ...
}: {
  programs.nvf = {
    enable = true;
    defaultEditor = true;
    # enableManpages = true; # man 5 nvf. ERROR with old pkg prettier/prettierd!

    settings.vim = {
      options = {
        shiftwidth = 2;
        tabstop = 4;
        title = true;
        titlestring = "vi";
      };

      autocmds = [
        {
          event = [ "FileType" ];
          pattern = [ "markdown" ];
          # group = "UserSetup";
          desc = "Set spellcheck for Markdown";
          command = "setlocal spell";
          # once = true; # Run only once per session trigger. EXAMPLE
        }
      ];

      # Disable lspconfig error annoying message
      luaConfigPre =
        let
          msg = ''is deprecated, use vim.lsp.config'';
        in
        ''
          vim.notify = function(msg, level, opts)
            if type(msg) == "string" and msg:match("${msg}") then
              return
            end
            vim.api.nvim_echo({{msg}}, true, {})
          end
        '';

      lsp = {
        enable = true;
        formatOnSave = true;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        html.enable = true;
        # css.enable = true; # prettier error again
        lua.enable = true;
        bash.enable = true;
        markdown.enable = true;
        python.enable = true;
      };

      visuals = {
        # nvim-scrollbar.enable = true;
        # fidget-nvim.enable = true; # new notification window
        # cellular-automaton.enable = true; # fun animation
        indent-blankline = {
          enable = true;
          setupOpts.indent.char = "┆";
        };
      };

      ui = {
        # borders.enable = true;
        # colorizer = {
        # enable = true;
        # };
        # breadcrumbs = {
        #   enable = true;
        #   navbuddy.enable = true; # table of contents for code
        #   lualine.winbar.enable = false; # disable stupid top bar in lualine
        #   lualine.winbar.alwaysRender = false;
        # };
        # illuminate.enable = true; # for same words under the cursor
      };
      statusline.lualine = {
        enable = true;
        icons.enable = false;
        globalStatus = false;
        activeSection = {
          a = [ "'mode'" ];
          b = [ "{'filename', symbols = {modified = '~', readonly = 'READONLY'}}" ];
          c = [ "'branch'" "{'diff', symbols = {added = '+', modified = '~', removed = '-'}}" ];
          x = [ "'diagnostics'" "'encoding'" "'fileformat'" ];
          y = [ "'progress'" ];
          z = [ "'location'" ];
        };
      };

      notify.nvim-notify.enable = true;
      mini.comment.enable = true;

      autopairs.nvim-autopairs.enable = true;
      autocomplete = {
        nvim-cmp = {
          enable = true;
          setupOpts = {
            preselect = "none";
            completion.completeopt = "menu,menuone,noinsert,noselect";
          };
        };
      };
      snippets.luasnip.enable = true;
      diagnostics = {
        enable = true;
        nvim-lint.enable = true;
      };

      binds = {
        cheatsheet.enable = true;
        whichKey = {
          enable = true;
          setupOpts = {
            # “none”, “single”, “double”, “rounded”, “solid”, “shadow”
            win.border = "single";
            preset = "classic";
            # triggers_blacklist = {
            #   n = ["d" "y"];
            # };
          };
        };
      };

      git = {
        enable = true;
        gitsigns = {
          enable = true;
          # codeActions.enable = false;
        };
      };

      # minimap = {
      #   minimap-vim.enable = true;
      #   # codewindow.enable = true; # lighter, faster, and uses lua for configuration
      # };

      utility = {
        multicursors.enable = true;
        surround.enable = true;
        # images.image-nvim.enable = false;
        nvim-biscuits = {
          enable = true;
          setupOpts.cursor_line_only = true;
        };
      };

      notes = {
        todo-comments.enable = true;
      };

      # -------- EXTRA PLUGINS --------

      extraPlugins = with pkgs.vimPlugins; {
        # \/ standard plugin setup example
        # aerial = {
        #   package = aerial-nvim;
        #   setup = "require('aerial').setup {}";
        # };
      };

      lazy.plugins = {
        # \/ lazy plugin setup
        "zen-mode.nvim" = {
          package = pkgs.vimPlugins.zen-mode-nvim;
          setupModule = "zen-mode";
          setupOpts = {
            window = {
              backdrop = 1; # disable shadow
              width = 80; # max line lenght
            };
          };
          after = "print('Zen loaded')";

          # Explicitly mark plugin as lazy. You don't need this
          # if you define one of the trigger "events" below
          lazy = true;
          cmd = [ "ZenMode" ]; # load on command
          # event = ["BufEnter"]; # load on event (EXAMPLE!)
          # event = [{event = "User"; pattern = "LazyFile";}]; # LazyFile - alias for open any file
        };
      };

      # -------- KEYMAPS --------

      keymaps = [
        # --- disable space ---
        {
          action = "";
          key = "<space>";
          mode = [ "n" "v" ];
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
          mode = [ "n" ];
          silent = true;
          nowait = true;
          desc = "Redo";
        }

        # --- new clipboard control ---
        {
          action = ''"+yl'';
          key = "<leader>y";
          mode = [ "v" ];
          silent = true;
          nowait = true;
          desc = "cp to system";
        }
        {
          action = ''"+yyl'';
          key = "<leader>yy";
          mode = [ "n" ];
          silent = true;
          nowait = true;
          desc = "cp to system";
        }
        {
          action = ''"+pl'';
          key = "<leader>p";
          mode = [ "n" "v" ];
          silent = true;
          nowait = true;
          desc = "Paste from system slipboard";
        }
        {
          action = ''"+Pl'';
          key = "<leader>P";
          mode = [ "n" "v" ];
          silent = true;
          nowait = true;
          desc = "Paste from system slipboard";
        }
        {
          action = ''"+dl'';
          key = "<leader>d";
          mode = [ "v" ];
          silent = true;
          nowait = true;
          desc = "Cut to system";
        }
        {
          action = ''"+ddl'';
          key = "<leader>dd";
          mode = [ "n" ];
          silent = true;
          nowait = true;
          desc = "Cut line to system";
        }
        {
          action = ''"+xl'';
          key = "<leader>x";
          mode = [ "n" "v" ];
          silent = true;
          nowait = true;
          desc = "Cut to system";
        }

        # --- soft string jumping ---
        {
          action = "gj";
          key = "j";
          mode = [ "n" "v" ];
        }
        {
          action = "gk";
          key = "k";
          mode = [ "n" "v" ];
        }

        # --- zenmode plugin ---
        {
          action = ":ZenMode<CR>";
          key = "<leader>z";
          mode = [ "n" "v" ];
          silent = true;
          nowait = true;
        }

        # --- rus layout support ---
        {
          action = "q";
          key = "й";
          mode = [ "n" "v" ];
        }
        {
          action = "Q";
          key = "Й";
          mode = [ "n" "v" ];
        }
        {
          action = "w";
          key = "ц";
          mode = [ "n" "v" ];
        }
        {
          action = "W";
          key = "Ц";
          mode = [ "n" "v" ];
        }
        {
          action = "e";
          key = "у";
          mode = [ "n" "v" ];
        }
        {
          action = "E";
          key = "У";
          mode = [ "n" "v" ];
        }
        {
          action = "r";
          key = "к";
          mode = [ "n" "v" ];
        }
        {
          action = "R";
          key = "К";
          mode = [ "n" "v" ];
        }
        {
          action = "t";
          key = "е";
          mode = [ "n" "v" ];
        }
        {
          action = "T";
          key = "Е";
          mode = [ "n" "v" ];
        }
        {
          action = "y";
          key = "н";
          mode = [ "n" "v" ];
        }
        {
          action = "Y";
          key = "Н";
          mode = [ "n" "v" ];
        }
        {
          action = "u";
          key = "г";
          mode = [ "n" "v" ];
        }
        {
          action = "U";
          key = "Г";
          mode = [ "n" "v" ];
        }
        {
          action = "i";
          key = "ш";
          mode = [ "n" "v" ];
        }
        {
          action = "I";
          key = "Ш";
          mode = [ "n" "v" ];
        }
        {
          action = "o";
          key = "щ";
          mode = [ "n" "v" ];
        }
        {
          action = "O";
          key = "Щ";
          mode = [ "n" "v" ];
        }
        {
          action = "p";
          key = "з";
          mode = [ "n" "v" ];
        }
        {
          action = "P";
          key = "З";
          mode = [ "n" "v" ];
        }
        {
          action = "[";
          key = "х";
          mode = [ "n" "v" ];
        }
        {
          action = "{";
          key = "Х";
          mode = [ "n" "v" ];
        }
        {
          action = "a";
          key = "ф";
          mode = [ "n" "v" ];
        }
        {
          action = "A";
          key = "Ф";
          mode = [ "n" "v" ];
        }
        {
          action = "s";
          key = "ы";
          mode = [ "n" "v" ];
        }
        {
          action = "S";
          key = "Ы";
          mode = [ "n" "v" ];
        }
        {
          action = "d";
          key = "в";
          mode = [ "n" "v" ];
        }
        {
          action = "D";
          key = "В";
          mode = [ "n" "v" ];
        }
        {
          action = "f";
          key = "а";
          mode = [ "n" "v" ];
        }
        {
          action = "F";
          key = "А";
          mode = [ "n" "v" ];
        }
        {
          action = "g";
          key = "п";
          mode = [ "n" "v" ];
        }
        {
          action = "G";
          key = "П";
          mode = [ "n" "v" ];
        }
        {
          action = "h";
          key = "р";
          mode = [ "n" "v" ];
        }
        {
          action = "H";
          key = "Р";
          mode = [ "n" "v" ];
        }
        {
          action = "gj";
          key = "о";
          mode = [ "n" "v" ];
        }
        {
          action = "J";
          key = "О";
          mode = [ "n" "v" ];
        }
        {
          action = "gk";
          key = "л";
          mode = [ "n" "v" ];
        }
        {
          action = "K";
          key = "Л";
          mode = [ "n" "v" ];
        }
        {
          action = "l";
          key = "д";
          mode = [ "n" "v" ];
        }
        {
          action = "L";
          key = "Д";
          mode = [ "n" "v" ];
        }
        {
          action = ";";
          key = "ж";
          mode = [ "n" "v" ];
        }
        {
          action = ":";
          key = "Ж";
          mode = [ "n" "v" ];
        }
        {
          action = "z";
          key = "я";
          mode = [ "n" "v" ];
        }
        {
          action = "Z";
          key = "Я";
          mode = [ "n" "v" ];
        }
        {
          action = "x";
          key = "ч";
          mode = [ "n" "v" ];
        }
        {
          action = "X";
          key = "Ч";
          mode = [ "n" "v" ];
        }
        {
          action = "c";
          key = "с";
          mode = [ "n" "v" ];
        }
        {
          action = "C";
          key = "С";
          mode = [ "n" "v" ];
        }
        {
          action = "v";
          key = "м";
          mode = [ "n" "v" ];
        }
        {
          action = "V";
          key = "М";
          mode = [ "n" "v" ];
        }
        {
          action = "b";
          key = "и";
          mode = [ "n" "v" ];
        }
        {
          action = "B";
          key = "И";
          mode = [ "n" "v" ];
        }
        {
          action = "n";
          key = "т";
          mode = [ "n" "v" ];
        }
        {
          action = "N";
          key = "Т";
          mode = [ "n" "v" ];
        }
        {
          action = "m";
          key = "ь";
          mode = [ "n" "v" ];
        }
        {
          action = "M";
          key = "Ь";
          mode = [ "n" "v" ];
        }
        {
          action = ",";
          key = "б";
          mode = [ "n" "v" ];
        }
        {
          action = "<";
          key = "Б";
          mode = [ "n" "v" ];
        }
        {
          action = ".";
          key = "ю";
          mode = [ "n" "v" ];
        }
        {
          action = ">";
          key = "Ю";
          mode = [ "n" "v" ];
        }
        {
          action = "/";
          key = "я";
          mode = [ "n" "v" ];
        }
        {
          action = "?";
          key = "Я";
          mode = [ "n" "v" ];
        }
      ];
    };
  };
}
