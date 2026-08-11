#!/usr/bin/env bash

set -Eeuo pipefail

readonly mode="${1:-}"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

[[ "$(id -un deploy)" == deploy ]] || fail "deploy user is missing"
id -nG deploy | grep -qw docker || fail "deploy user is not in the docker group"
id -nG deploy | grep -qw sudo || fail "deploy user is not in the sudo group"
[[ "$(stat -c '%U:%G:%a' /var/lib/ultrainfo)" == "deploy:deploy:750" ]] \
  || fail "/var/lib/ultrainfo ownership or mode is incorrect"

systemctl is-active --quiet docker || fail "Docker is not active"
systemctl is-enabled --quiet docker || fail "Docker is not enabled"
systemctl is-active --quiet fail2ban || fail "fail2ban is not active"
systemctl is-enabled --quiet unattended-upgrades || fail "unattended-upgrades is not enabled"

docker info >/dev/null || fail "Docker is unavailable"
swapon --show=NAME --noheadings | grep -Fxq /swapfile || fail "swapfile is not active"
ufw status | grep -Fq 'Status: active' || fail "UFW is not active"
for port in 22 80 443; do
  ufw status | grep -Eq "${port}/tcp[[:space:]]+ALLOW" || fail "UFW does not allow TCP ${port}"
done

if [[ "${mode}" != "--before-ssh-hardening" ]]; then
  sshd_configuration="$(sshd -T)"
  grep -Fqx 'passwordauthentication no' <<< "${sshd_configuration}" || fail "SSH password auth is enabled"
  grep -Fqx 'permitrootlogin no' <<< "${sshd_configuration}" || fail "root SSH is enabled"
  grep -Fqx 'x11forwarding no' <<< "${sshd_configuration}" || fail "SSH X11 forwarding is enabled"
  grep -Fqx 'maxauthtries 3' <<< "${sshd_configuration}" || fail "SSH MaxAuthTries is not 3"
  grep -Fqx 'allowusers deploy' <<< "${sshd_configuration}" || fail "SSH AllowUsers is not restricted"
fi

echo "PASS: ultrainfo host policy is satisfied"
