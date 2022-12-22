#!/bin/bash -e


echo
echo "=== azadrah.org ==="
echo "=== https://github.com/azadrah-org ==="
echo "=== Optimizing Shadowsocks Server (Ubuntu 22.04 and 20.04) ==="
echo
sleep 3

function exit_badly {
  echo "$1"
  exit 1
}

if [[ dist1=$(lsb_release -rs) == "18.04" ]] ; then exit_badly "This script is for Ubuntu 22.04 only: aborting (if you know what you're doing, try deleting this check)"
else
[[ $(id -u) -eq 0 ]] || exit_badly "Please re-run as root (e.g. sudo ./path/to/this/script)"
fi

DEBIAN_FRONTEND=noninteractive



echo
echo "=== Update System ==="
echo
sleep 1

apt-get -o Acquire::ForceIPv4=true update
apt-get -o Acquire::ForceIPv4=true install -y software-properties-common
add-apt-repository --yes universe
add-apt-repository --yes restricted
add-apt-repository --yes multiverse
apt-get -o Acquire::ForceIPv4=true install -y moreutils dnsutils tmux screen nano wget curl socat

echo
echo "=== Optimizing ==="
echo
sleep 1

grep -Fq 'azadrah-org' /etc/sysctl.conf || echo "
# https://github.com/azadrah-org
net.ipv4.ip_forward = 1
net.ipv4.ip_no_pmtu_disc = 1
fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen = 3
" >> /etc/sysctl.conf

grep -Fq 'azadrah-org' /etc/security/limits.conf || echo '
# https://github.com/azadrah-org
root    soft    nofile     51200
root    hard    nofile     51200
' >> /etc/security/limits.conf
ulimit -n 51200


echo
echo "=== Finished ==="
echo
sleep 1