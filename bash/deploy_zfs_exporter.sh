#!/usr/bin/bash
ws=/opt/zfs_exporter
version=2.3.2
download_url=https://github.com/pdf/zfs_exporter/releases/download


download_binary(){
  cd $ws
  wget $download_url/v$version/zfs_exporter-$version.linux-amd64.tar.gz

}


install(){
  cd $ws
  tar -xzf ./zfs_exporter-$version.linux-amd64.tar.gz
  chmod 0755 zfs_exporter-$version.linux-amd64/zfs_exporter
  cp $ws/zfs_exporter-$version.linux-amd64/zfs_exporter /usr/local/bin/
 
}


create_systemd(){
cat <<EOF > /etc/systemd/system/zfs_exporter.service
[Unit]
Description=zfs_exporter
After=network-online.target

[Service]
Restart=always
RestartSec=5
TimeoutSec=5
User=root
Group=root
ExecStart=/usr/local/bin/zfs_exporter --collector.dataset-snapshot --collector.dataset-volume --collector.pool

[Install]
WantedBy=multi-user.target
EOF

}

systemd(){
    sudo systemctl daemon-reload
    sleep 3
    systemctl enable zfs_exporter.service
    sleep 2
    systemctl status zfs_exporter.service
}

check_metrics(){
    sleep 2
    curl localhost:9134/metrics
}


###MAIN
install
create_systemd
systemd
check_metrics
