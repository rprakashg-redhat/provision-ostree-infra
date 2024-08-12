#!/bin/bash
sudo dnf -y install ansible-core
sudo dnf -y install git-all
sudo dnf -y install podman

ansible-galaxy collection install -f git+https://github.com/redhat-cop/infra.osbuild --upgrade
ansible-galaxy collection install -f containers.podman --upgrade