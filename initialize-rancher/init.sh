
ansible-playbook ../playbooks/rename_host.yml -i hosts.ini -K
ansible-playbook ../k3s-ansible/site.yml -i hosts.ini -K