#! /bin/bash

# Try to decrypt key, exit on failure
gpg ./key/key.gpg 2>/dev/null || {
    echo "> Wrong passphrase" && exit
}

# Create a single line version to be used as symmetric encryption key in the future
cp ~/.ssh/key ~/.ssh/gpg-key && \
    echo $(tr -d '\n' < ~/.ssh/gpg-key) > ~/.ssh/gpg-key

# Setup and test connection to GitHub
mv ./key/key ~/.ssh/key
chmod 700 ~/.ssh/key
cp ./key/ssh-config ~/.ssh/config
ssh -T github.com

# Install Ansible
sudo apt update --yes
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible --yes

ansible-playbook ./playbook.yaml \
    -e "target=localhost"

# Run docker commands without sudo
sudo usermod -aG docker $USER
newgrp docker

# Setup git
git config --global user.name "Marvin Isaac"
git config --global user.email "4396841+marvinisaac@users.noreply.github.com"
