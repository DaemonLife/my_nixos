pkg update
pkg upgrade
pkg install neovim python openssh git -y
# pkg install proot-distro

# jrnl install
export ANDROID_API_LEVEL=29 # or 28
pkg install python-cryptography rust -y
pip install pipx
#pipx install cryptography # ?
pipx install jrnl 
jrnl; cd ~/.config/jrnl
echo "\nNow change journal path in jrnl config."
