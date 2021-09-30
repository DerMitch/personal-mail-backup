#!/bin/bash
#
# Installs offlineimap (Python 3 version) to the specified directory.
#

TARGET=$1

if [[ "$TARGET" = "" || "$TARGET" = "-h" || "$TARGET" = "--help" ]]; then
    echo "usage: $0 [DIRECTORY]"
    echo
    echo "  Installs offlineimap to a certain directory."
    exit 1
fi

if [[ -d "$TARGET/.git" ]]; then
    echo "[*] Updating repository $TARGET"
    pushd "$TARGET" >/dev/null
        git pull
    popd >/dev/null
else
    echo "[*] Cloning repository to $TARGET"
    git clone --depth=1 git@github.com:OfflineIMAP/offlineimap3.git "$TARGET"
fi

# Add venv to gitignore to prevent issues later
if ! grep venv "$TARGET/.gitignore" >/dev/null; then
    echo "venv/" >> "$TARGET/.gitignore"
fi

# Setup a virtualenv (doesn't err if already exists)
echo "[*] Setting up virtualenv"
python3 -m venv "$TARGET/venv"

# Install requirements for offlineimap (they're not specified in setup.py...)
echo "[*] Installing dependencies"
"$TARGET/venv/bin/pip" install -r "$TARGET/requirements.txt"

# Activate the virtualenv to ensure the following commands use the right python
. "$TARGET/venv/bin/activate"


pushd "$TARGET" >/dev/null
    echo "[*] Building package"
    make clean && make

    echo "[*] Installing offlineimap to the virtualenv"
    python setup.py install
popd >/dev/null

echo
echo "Success! You can use offflinemap now by executing:"
echo
echo "  $TARGET/venv/bin/offlineimap"
echo
