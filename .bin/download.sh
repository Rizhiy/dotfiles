#!/bin/bash
set -e

rm -fr .dotfiles/

git clone --bare git@gitlab.com:rizhiy/.dotfiles.git $HOME/.dotfiles
config () {
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

backup_with_dir () {
  backup_dir=".config-backup"
  new_path="$backup_dir"/"$0"
  mkdir -p "$(dirname "$new_path")" && mv "$0" "$new_path"
}
export -f backup_with_dir # Required for xargs

if config checkout 2> /dev/null; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files.";
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -L1 bash -c 'backup_with_dir "$@"' 
  config checkout
fi;
config config status.showUntrackedFiles no
