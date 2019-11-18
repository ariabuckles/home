#!/bin/zsh
# Find the next user ID with dscl . -list /Users UniqueID
# Use 600 as a floor; as GUI-created users go into UIDs 500+
let userId=$(( $((dscl . -list /Users UniqueID | sed 's/[a-zA-Z_]* *//' && echo 600) | sort -rn | head -1) + 1 ))

if [[ -z "$1" ]]; then
  echo "Usage: sudo create-user.sh username"
  echo "Please specify a username"
  exit 2
fi

if id "$1" &>/dev/null; then
  echo "User $1 already exists; skipping"
  exit 0
fi

# https://apple.stackexchange.com/questions/226073/how-do-i-create-user-accounts-from-the-terminal-in-mac-os-x-10-11
# https://apple.stackexchange.com/questions/4814/can-user-accounts-be-managed-via-the-command-line
sudo mkdir "/Users/$1"
sudo dscl . -create "/Users/$1"
sudo dscl . -create "/Users/$1" UserShell /bin/zsh
sudo dscl . -create "/Users/$1" RealName "$1"
sudo dscl . -create "/Users/$1" UniqueID $userId
sudo dscl . -create "/Users/$1" PrimaryGroupID 20 # staff
sudo dscl . -create "/Users/$1" NFSHomeDirectory "/Users/$1"
sudo dscl . -create "/Users/$1" IsHidden 1

echo "User $1 created"
