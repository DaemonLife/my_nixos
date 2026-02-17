{ ... }: {

  programs.git = {
    enable = true;
    settings = {
      # user.name = "DaemonLife";
      alias = {
        acp = ''!f() { git add .; git commit -m "$*"; git push && echo 'Push complited!'; }; f'';
      };
    };
  };

}

# If you have flake.lock error with pull run:
# git reset HEAD -- flake.lock
# git restore -- flake.lock
