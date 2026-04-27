{ pkgs, ... }: {
  home.packages = with pkgs; [
    # lang servers
    nil # nix
    bash-language-server

    # auto format servers
    nixpkgs-fmt # nix
    # nixfmt-rfc-style # official nix format style
    shfmt # bash

    # other
    shellcheck # bash
    vscode-langservers-extracted # html
    marksman # markdown
    ruff # python
    pyright # python
    pylyzer # python
    uwu-colors
  ];

  imports = [
    ./helix_rus_keymap.nix
  ];

  programs.helix = {
    enable = true;
    # defaultEditor = true;

    settings = {
      editor = {
        # Show currently open buffers, only when more than one exists.
        bufferline = "multiple";
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        lsp.display-messages = true;

        gutters = {
          layout = [
            "line-numbers"
            "diagnostics"
            "diff"
          ];
          line-numbers.min-width = 1;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        indent-guides = {
          character = "┆";
          render = true;
          skip-levels = 1;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "file-name"
          ];
        };

        soft-wrap = {
          enable = true;
          max-wrap = 25; # increase value to reduce forced mid-word wrapping
          max-indent-retain = 0;
          wrap-indicator = ""; # hide it
        };
      };

    }; # settings

    languages = {
      language-server.pyright.config.python.analysis.typeCheckingMode = "basic";
      language-server.ruff = {
        command = "ruff";
        args = [ "server" ];
      };

      language-server.pylyzer = {
        command = "pylyzer";
        args = [ "--server" ];
      };

      language = [
        {
          name = "nix";
          language-servers = [
            "nil"
            "uwu-colors"
          ];
          formatter.command = "nixpkgs-fmt";
          auto-format = true;
          indent = {
            tab-width = 2;
            unit = "	";
          };
        }
        {
          name = "python";
          language-servers = [
            "pyright"
            "ruff"
            "pylyzer"
            "uwu-colors"
          ];
          auto-format = true;
        }
        {
          name = "bash";
          language-servers = [
            "bash-language-server"
            "uwu-colors"
          ];
          auto-format = true;
          formatter = {
            command = "shfmt";
            args = [ "-i" "2" "-" ];
          };
        }
        {
          name = "markdown";
          language-servers = [
            "marksman"
            "uwu-colors"
          ];
          auto-format = true;
          formatter = {
            command = "prettier";
            # args = [ "--stdin-filepath" "file.md" ];
          };
        }
        {
          name = "html";
          language-servers = [
            "vscode-html-language-server"
            "uwu-colors"
          ];
          auto-format = true;
          formatter.command = "prettier";
        }
        {
          name = "css";
          auto-format = true;
          language-servers = [
            "vscode-css-language-server"
            "uwu-colors"
          ];
        }
      ];
    };
  }; # programs
}
# main

