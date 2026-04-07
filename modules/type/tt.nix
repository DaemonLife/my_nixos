{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    tt
  ];

  # home.file.".tst".text = with config.lib.stylix.colors; ''
  # '';

}

# command for using with custom language pack from
# https://github.com/monkeytypegame/monkeytype/tree/master/frontend/static/languages
#   cat russian.json | jq -r '.words[]' | tt -words - -notheme
# or
#   curl https://raw.githubusercontent.com/monkeytypegame/monkeytype/refs/heads/master/frontend/static/languages/russian_10k.json | jq -r '.words[]' | tt -words - -notheme
