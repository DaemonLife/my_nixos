pkg update -y
pkg install -y binutils build-essential clang make git curl unzip libandroid-shmem

OCAML_VERSION=5.3.0

mkdir -p $HOME/tmp
curl -L https://github.com/ocaml/ocaml/releases/download/${OCAML_VERSION}/ocaml-${OCAML_VERSION}.tar.gz \
  -o "$HOME/tmp/ocaml.tar.gz"
tar xzf "$HOME/tmp/ocaml.tar.gz" -C "$HOME/tmp"
cd "$HOME/tmp/ocaml-${OCAML_VERSION}"

# Configure OCaml for Termux/Android
# Termux provides the $PREFIX variable.

# With error fix (read repo):
TARGET="aarch64-unknown-linux-android"
API=28
./configure --prefix=$PREFIX --disable-warn-error --without-afl CC="clang --target=${TARGET}${API}" LDFLAGS="-landroid-shmem"

# Build and install OCaml
make world
make install

UNISON_VERSION=2.53.8

mkdir -p $HOME/tmp
curl -L https://github.com/bcpierce00/unison/archive/refs/tags/v${UNISON_VERSION}.tar.gz -o "$HOME/tmp/unison.tar.gz"
tar xzf "$HOME/tmp/unison.tar.gz" -C "$HOME/tmp"
cd "$HOME/tmp/unison-${UNISON_VERSION}"

# Build and install Unison
# NATIVE=false tells the build system to use the OCaml bytecode compiler,
# which makes large syncs slower but is necessary for Termux.
make NATIVE=false
make NATIVE=false install

echo "DONE!!!"
echo "Also! If you encounter errors while running unison, try to use the options -ignorelocks (and possibly -perms=0, read repo)"
