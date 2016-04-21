#!/bin/bash

# core packages
sudo apt-get update
sudo locale-gen en_AU.UTF-8
sudo apt-get install -y git
sudo apt-get install -y subversion
sudo apt-get install -y vim
sudo apt-get install -y tmux
sudo apt-get install -y curl
sudo apt-get install -y wget
sudo apt-get install -y tree
sudo apt-get install -y ntp
sudo apt-get install -y unzip
sudo apt-get install -y zip
sudo apt-get install -y default-jre
sudo apt-get install -y build-essential g++
sudo apt-get install -y shellcheck # https://github.com/koalaman/shellcheck

# install system ruby but not the old version as rbenv builds require 2.0+ (not 1.9)
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev llvm # for ruby-build
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install -y ruby2.2
sudo apt-get install -y ruby2.2-dev

# set timezone
echo "Australia/Sydney" | sudo tee /etc/timezone
#echo "Europe/London" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

# create projects directory
mkdir ~/projects

# dot files
git clone https://github.com/jonbartlett/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
~/projects/dotfiles/link.sh
cat ~/projects/dotfiles/.bashrc_ubuntu >> ~/.bashrc

# fancy bash prompt
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

# rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo '#rbenv config' >> ~/.bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build # install ruby-build
rbenv install rbx-3.27
touch /home/vagrant/.rbenv/version
echo "rbx-3.27" >> /home/vagrant/.rbenv/version

# Vundle - Launch vim and run :PluginInstall
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# vim +PluginInstall +qall


