#!/usr/bin/env bash
export ANSIBLE_CONFIG=$HOME/.dotfiles/tests/ansible.cfg
virtualmachine=""


while getopts ":kh" opt; do
  case ${opt} in
    k)
      KEEP=true
      ;;
    h)
      echo "Usage:"
      echo "    init.sh -h                      Display this help message."
      echo "    init.sh -k                      Keep virtualmachine running after test."
      echo "    init.sh test <Virtualmachine>   Exec test on <Virtualmachine>."
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

subcommand=$1; shift
case "$subcommand" in
  # Parse options to the install sub command
  test)
    virtualmachine=$1; shift  # Remove 'install' from the argument list

    shift $((OPTIND -1))
    ;;
esac


case "$virtualmachine" in
    Debian)
        VM="1027a12e-7989-426d-8b9c-b133dae2142e"
        OS="debian"
        ;;
    Darwin)
        VM="41cc114f-2b68-4cdf-a800-8a65e569d167"
        OS="osx"
        ;;
esac #SHCRADER

SNAPSHOT=$(VBoxManage snapshot $VM list | tail -n 1 | grep -o '\([0-9a-z]*-\)\{4\}[0-9a-z]*')

VBoxManage snapshot $VM restore $SNAPSHOT
VBoxManage startvm $VM --type headless

# BECAUSE COMPUTER IS 2 TRIGGER HAPPY FOR DEBIAN
sleep 10

if [ $OS == 'debian' ]; then
    # Sync time because snapshot is wierd and dont want to sync correctly
    # TODO: Create new snapshot where prompt for sudo is no need
    HOST=$(cat $HOME/.dotfiles/ansible/hosts.ini | grep debian | grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}')
    sshpass -p Password!1234 ssh -t olle@$HOST "echo Password!1234 | sudo -S chronyd -q 'server pool.ntp.org iburst'"
fi

cp $HOME/.dotfiles/tests/ansible_boiler.cfg $HOME/.dotfiles/tests/ansible.cfg

# -i '' because osx is special lady
sed -i '' -e s/@logfile@/$OS-$(date +%m-%d-%Y).log/g $HOME/.dotfiles/tests/ansible.cfg

ansible-playbook $HOME/.dotfiles/ansible/dotfiles.yaml \
    -i $HOME/.dotfiles/ansible/hosts.ini \
    --extra-vars "target=$OS" \
    --extra-vars "ansible_sudo_pass=Password!1234" \
    --limit $OS

if [[ $KEEP != true ]]; then
  VBoxManage controlvm $VM poweroff soft
fi

rm $HOME/.dotfiles/tests/ansible.cfg
