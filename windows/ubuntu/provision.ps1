# 冪等性はないので注意
# 実行後に編集が必要なファイルもある
cp $home\.gitconfig \\wsl$\Ubuntu\tmp\
wsl -- mv /tmp/.gitconfig ~/
# root/browserなどpathの変更が必要
cp $home\.gowlconfig \\wsl$\Ubuntu\tmp
wsl -- mv /tmp/.gowlconfig ~/

# pathの変更が必要かも..
cp -r $home\.ssh \\wsl$\Ubuntu\tmp\
wsl -- rm -rf ~/.ssh
wsl -- mv /tmp/.ssh ~/
wsl -- chmod 600 ~/.ssh/*

