{ config, pkgs, lib, ... }: {

  home.packages = with pkgs; [ nil nixpkgs-fmt ];

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
      render-markdown.enable = true;
      colorizer.enable = true; # colors for hex code

      indent-blankline = {
        enable = true;
        settings = { indent.char = "│"; };
      };

      mini = {
        enable = true;
        # mockDevIcons = true;
        modules = {
          basics = { };
          comment = { };
          completion = { };
          surround = { };
          pairs = { };
          # animate = { };
          # icons = { };
          notify = { };
          # starter = { }; # start screen
          git = { };
          diff = { };
          pick = { }; # like telescope
          statusline = {
            enable = true;
            settings = {
              use_icons = false;
            };
            content.active.__raw = '' 
              function()
                local MiniStatusline = require('mini.statusline')

                local filetype = function()
                  local ft = vim.bo.filetype
                  return string.format('%s', ft)
                end

                local location = function(args)
                  if MiniStatusline.is_truncated(args.trunc_width) then
                    return '%02l|%02v'
                  end
                  return '%02l/%02L|%02v/%02{virtcol("$")-1}'
                end

                -- Use only HEAD name as summary string for GIT
                local format_summary = function(data)
                  local summary = vim.b[data.buf].minigit_summary
                  vim.b[data.buf].minigit_summary_string = summary.head_name or ""
                end
                local au_opts = { pattern = "MiniGitUpdated", callback = format_summary }
                vim.api.nvim_create_autocmd("User", au_opts)

                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120, icon = "" })
                local git           = MiniStatusline.section_git({ trunc_width = 40, icon = "" })
                local diff          = MiniStatusline.section_diff({ trunc_width = 75, icon = "" })
                local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75, icon = "",
                                      signs = {ERROR = 'x', WARN = '!', INFO = '?', HINT = '*'} })
                local filename      = MiniStatusline.section_filename({ trunc_width = 140, icon = "" })
                local location      = location({ trunc_width = 75, icon = "" })
                local search        = MiniStatusline.section_searchcount({ trunc_width = 75, icon = "" })
                
                return MiniStatusline.combine_groups({
                  { hl = mode_hl,                  strings = {mode:upper()}},
                  { hl = 'MiniStatuslineDevinfo',  strings = {git, diff}},
                  '%<', -- Mark general truncate point
                  { hl = 'MiniStatuslineFilename', strings = { filename } },
                  '%=', -- End left alignment
                  { hl = 'MiniStatuslineDevinfo',  strings = { filetype(), diagnostics } },
                  { hl = mode_hl,                  strings = { search, location } },
                })
              end
            '';
          };
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
