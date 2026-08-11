#!/usr/bin/env bash

set -Eeuo pipefail

readonly phase="${1:-}"
readonly bootstrap_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly deploy_user="deploy"
readonly storage_directory="/var/lib/ultrainfo"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this bootstrap as root." >&2
  exit 1
fi

install_configuration() {
  local source_file="$1"
  local destination_file="$2"
  local mode="$3"

  install -D -o root -g root -m "${mode}" \
    "${bootstrap_directory}/${source_file}" "${destination_file}"
}

prepare_host() {
  export DEBIAN_FRONTEND=noninteractive

  apt-get update
  apt-get upgrade -y
  apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    docker.io \
    fail2ban \
    sudo \
    ufw \
    unattended-upgrades

  timedatectl set-timezone UTC

  if ! id "${deploy_user}" >/dev/null 2>&1; then
    useradd --create-home --shell /bin/bash --comment "Ultrainfo deployment user" "${deploy_user}"
  fi

  passwd --lock "${deploy_user}" >/dev/null
  usermod --append --groups docker,sudo "${deploy_user}"

  install -d -o "${deploy_user}" -g "${deploy_user}" -m 0700 "/home/${deploy_user}/.ssh"
  install -o "${deploy_user}" -g "${deploy_user}" -m 0600 \
    "${bootstrap_directory}/ultrainfo.pub" "/home/${deploy_user}/.ssh/authorized_keys"
  install -d -o "${deploy_user}" -g "${deploy_user}" -m 0750 "${storage_directory}"

  printf '%s\n' "${deploy_user} ALL=(ALL:ALL) NOPASSWD: ALL" \
    | install -o root -g root -m 0440 /dev/stdin "/etc/sudoers.d/90-${deploy_user}"
  visudo --check --file "/etc/sudoers.d/90-${deploy_user}"

  install_configuration docker-daemon.json /etc/docker/daemon.json 0644
  install_configuration fail2ban-sshd.local /etc/fail2ban/jail.d/sshd.local 0644
  install_configuration unattended-upgrades.conf /etc/apt/apt.conf.d/52ultrainfo-unattended-upgrades 0644
  install -D -o root -g root -m 0755 "${bootstrap_directory}/verify-host.sh" /usr/local/sbin/verify-ultrainfo-host

  if ! swapon --show=NAME --noheadings | grep -Fxq /swapfile; then
    if [[ ! -e /swapfile ]]; then
      fallocate --length 2G /swapfile
      chmod 0600 /swapfile
      mkswap /swapfile
    fi
    swapon /swapfile
  fi
  if ! grep -Fqx '/swapfile none swap sw 0 0' /etc/fstab; then
    printf '%s\n' '/swapfile none swap sw 0 0' >> /etc/fstab
  fi

  systemctl enable --now docker fail2ban unattended-upgrades
  systemctl restart docker fail2ban

  ufw default deny incoming
  ufw default allow outgoing
  ufw allow 22/tcp comment 'SSH'
  ufw allow 80/tcp comment 'HTTP'
  ufw allow 443/tcp comment 'HTTPS'
  ufw logging low
  ufw --force enable

  /usr/local/sbin/verify-ultrainfo-host --before-ssh-hardening
}

harden_ssh() {
  install_configuration sshd-hardening.conf /etc/ssh/sshd_config.d/00-ultrainfo-hardening.conf 0644
  sshd -t
  systemctl reload ssh
  rm -rf -- "${bootstrap_directory}"
}

case "${phase}" in
  prepare)
    prepare_host
    ;;
  harden-ssh)
    harden_ssh
    ;;
  *)
    echo "Usage: $0 prepare|harden-ssh" >&2
    exit 64
    ;;
esac
