# �p�����͂Ȃ��̂Œ���
# ���s��ɕҏW���K�v�ȃt�@�C��������
cp $home\.gitconfig \\wsl$\Ubuntu\tmp\
wsl -- mv /tmp/.gitconfig ~/
# root/browser�Ȃ�path�̕ύX���K�v
cp $home\.gowlconfig \\wsl$\Ubuntu\tmp
wsl -- mv /tmp/.gowlconfig ~/

# path�̕ύX���K�v����..
cp -r $home\.ssh \\wsl$\Ubuntu\tmp\
wsl -- rm -rf ~/.ssh
wsl -- mv /tmp/.ssh ~/
wsl -- chmod 600 ~/.ssh/*

