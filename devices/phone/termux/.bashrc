alias linux="proot-distro login --user user --termux-home debian"
alias la="ls -a"
alias sshd="`whereis sshd | awk '{ print $2 }'` -p 8025" 
alias vi="nvim"
alias q="exit; exit"

# Created by `pipx` on 2026-03-03 18:42:42
export PATH="$PATH:/data/data/com.termux/files/home/.local/bin"
