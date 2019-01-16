#!/bin/bash

# fzf
if [ ! -e ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --key-bindings --completion --update-rc
else
  echo "[SKIP] fzfは既にインストール済みです"
fi

# pureline
if [ ! -e ~/pureline-inspired ]; then
  git clone https://github.com/tadashi-aikawa/pureline-inspired.git ~/pureline-inspired
  chown -R vagrant:vagrant ~/pureline-inspired
else
  echo "[SKIP] pureline-inspiredは既にインストール済みです"
fi

# dein
if [ ! -e ~/.cache/dein ]; then
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
  sh ./installer.sh ~/.cache/dein
else
  echo "[SKIP] deinは既にインストール済みです"
fi

# ssh
chmod 600 .ssh/id_rsa*

# sync
ln -snf /mnt/ubuntu/.bashrc           .bashrc.org
ln -snf /mnt/ubuntu/.vim              .vim
ln -snf /mnt/ubuntu/.vimrc            .vimrc
ln -snf /mnt/ubuntu/.vim-snippets     .vim-snippets
ln -snf /mnt/ubuntu/.tmux.conf        .tmux.conf
ln -snf /mnt/ubuntu/.inputrc          .inputrc


cat << 'EOF'
Please manually....

aws configure

vim
call dein#install()
EOF
