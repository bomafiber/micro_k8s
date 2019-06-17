#!/bin/bash

if [ ${#} -ne 1 ]; then
  echo "Usage: ${0} github_key_url" >&2
  exit 1
fi

echo "Setup ansible user"
/usr/sbin/useradd -d /home/ansible -c "Ansible" -m ansible
mkdir ~ansible/.ssh
/bin/chmod 0700 ~ansible/.ssh
curl -o ~ansible/.ssh/authorized_keys ${1}
/bin/chmod 0400 ~ansible/.ssh/authorized_keys
/bin/chown -Rh ansible:ansible /home/ansible
echo "ansible        ALL=(ALL)       NOPASSWD: ALL"  | sudo EDITOR='/usr/bin/tee -a' /usr/sbin/visudo

"Setup MicroK8s"
sudo snap install microk8s --classic
sudo snap alias microk8s.kubectl kubectl
echo "Waiting 60s..."
sleep 60
service_list="dns dashboard registry ingress storage"
for service in ${service_list}; do
  echo "Enabling ${service} ..."
  sudo microk8s.enable ${service}
  echo "Sleeping 20s..."
  sleep 20
done

echo "Enabling istio..."
echo N | sudo microk8s.enable istio

echo "Enabled the following services: ${service_list} istio"
echo "Finished!"
