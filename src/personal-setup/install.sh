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

remote_user="$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)"
current_user="${remote_user:-root}"

user_home=$(cat /etc/passwd | grep "^$current_user" | cut -d: -f6)
user_shell=$(cat /etc/passwd | grep "^$current_user" | rev | cut -d/ -f1 | rev)

echo "Initializing $user_shell shell for $current_user"

case "$user_shell" in
  bash)
    echo 'eval "$(starship init bash)"' >> "$user_home/.bashrc"
    ;;
  pwsh)
    mkdir -p "$user_home/.config/powershell"
    echo "Invoke-Expression (&starship init powershell)" >> "$user_home/.config/powershell/profile.ps1"
    ;;
  *)
    echo "Cannot setup shell: $user_shell"
    ;;
esac
