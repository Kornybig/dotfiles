#!/usr/bin/env bash
set -e

echo "[i] Ask for sudo password"
sudo -v

case "$(uname -s)" in
    Darwin)
        # install Command Line Tools
        if [[ ! -x /usr/bin/gcc ]]; then
          echo "[i] Install macOS Command Line Tools"
          xcode-select --install
        fi

        # install homwbrew
        if [[ ! -x /usr/local/bin/brew ]]; then
          echo "[i] Install Homebrew"
          ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi

        # install ansible
        if [[ ! -x /usr/local/bin/ansible ]]; then
            echo "[i] Install Ansible"
            brew install ansible
        fi
        ;;

    *)
        echo "[!] Unsupported OS"
        exit 1
        ;;
esac

# Run main playbook
echo "[i] Run Playbook"
ansible-playbook ansible/dotfiles.yaml --ask-become-pass
echo "[i] Done."


