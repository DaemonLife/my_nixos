{ pkgs, lib, config, ... }:
let
  conf = ''
    colors:
      body: none
      date: yellow
      tags: blue
      title: none
    default_hour: 9
    default_minute: 0
    editor: ${config.home.sessionVariables.EDITOR}
    encrypt: false
    highlight: true
    indent_character: '|'
    journals:
      default:
        journal: $HOME/.local/share/jrnl/journal.txt
      main:
        journal: /mnt/temp/jrnl/jrnl.txt
    linewrap: 79
    tagsymbols: '#@'
    template: false
    timeformat: '%Y-%m-%d %H:%M'
  '';
in
{

  programs.jrnl = {
    enable = true;
    # settings = {
    #   editor = "${config.home.sessionVariables.EDITOR}";
    #   journals = {
    #     default = "$HOME/.local/share/jrnl/journal.txt";
    #     main = "/mnt/temp/jrnl/jrnl.txt";
    #   };
    # };
  };

  home.activation.jrnl_config_deploy = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.config/jrnl 
    cd $HOME/.config/jrnl 
    echo "${conf}" > jrnl.yaml;
    # echo -n "version: `${pkgs.jrnl}/bin/jrnl --version | head -n 1 | awk '{print $2}'`" >> jrnl.yaml;
  '';
  #
}
