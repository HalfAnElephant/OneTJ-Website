#!/usr/bin/env bash
set -euo pipefail

log() { echo -e "\n==> $*\n"; }

log "Install base packages"
sudo apt update
sudo apt install -y git curl ca-certificates build-essential

log "Install NVM + Node LTS"
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
. "$NVM_DIR/nvm.sh"
nvm install 24
nvm use 24
nvm alias default 24

log "Install pnpm"
npm i -g pnpm

if ! grep -q 'export NVM_DIR="\$HOME/.nvm"' "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" <<'EOF'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
EOF
fi

log "Install deps and build docs"
pnpm install
pnpm docs:build

log "Done. Output directory:"
echo "  docs/.vitepress/dist"
echo ""
echo "Next (choose one):"
echo "  1) Preview: pnpm docs:preview --host "
echo "  2) Deploy via nginx: copy dist to /var/www/..."
