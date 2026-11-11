#!/usr/bin/bash
set -e

if [ -f /etc/os-release ]; then
    . /etc/os-release
else
  echo "Error: Cannot detect distribution (no /etc/os-release)"
  exit 1
fi

echo "Installing packages for distribution: $ID"
case "$ID" in
  debian|ubuntu)
    echo "Installing starship"
    apt-get update --yes
    apt-get install --yes --no-install-recommends curl ca-certificates
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    ;;
  *)
    echo "Error: Unsupported distribution: $ID"
    exit 1
    ;;
esac

default_shell=$(cat /etc/passwd | grep "^$(whoami)" | rev | cut -d/ -f1 | rev)
echo "Initialising $default_shell shell"
case "$default_shell" in
  bash)
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
    ;;
  pwsh)
    mkdir ~/.config/powershell
    echo "Invoke-Expression (&starship init powershell)" >> ~/.config/powershell/profile.ps1
    ;;
  *)
    echo "Cannot setup shell: $target_shell"
    ;;
esac
