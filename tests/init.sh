#!/usr/bin/env bash

case "$1" in
    Debian)
        VM="1027a12e-7989-426d-8b9c-b133dae2142e"
        os="debian"
        ;;
    OSX)
	VM="41cc114f-2b68-4cdf-a800-8a65e569d167"
	os="osx"
        ;;
esac

SNAPSHOT=$(VBoxManage snapshot $VM list | tail -n 1 | grep -o '\([0-9a-z]*-\)\{4\}[0-9a-z]*')

VBoxManage snapshot $VM restore $SNAPSHOT
VBoxManage startvm $VM --type headless

# BECAUSE COMPUTER IZ 2 TRIGGER HAPPY FOR DEBIAN
sleep 10

ansible-playbook $HOME/.dotfiles/ansible/dotfiles.yaml \
    -i $HOME/.dotfiles/ansible/hosts.ini \
    --extra-vars "target=$os" \
    --extra-vars "ansible_sudo_pass=Password!1234" \
    --limit $os

VBoxManage controlvm $VM poweroff soft
