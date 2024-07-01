#!/usr/bin/bash

set -e
set -x

export TNAME="R2100"
path="/opt/rt-n56u"
start_time=$(date "+%Y-%m-%d %H:%M:%S")

function up_config() {
    cd ${path}/trunk
    config_path=configs/templates/${TNAME}.config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_MENTOHUST/d' ${config_path} #删除配置项MENTOHUST
    sed -i 's/CONFIG_FIRMWARE_ENABLE_IPV6=y/CONFIG_FIRMWARE_ENABLE_IPV6=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_EAP_PEAP=y/CONFIG_FIRMWARE_INCLUDE_EAP_PEAP=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_VLMCSD=y/CONFIG_FIRMWARE_INCLUDE_VLMCSD=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_HTOP=y/CONFIG_FIRMWARE_INCLUDE_HTOP=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_IPERF3=y/CONFIG_FIRMWARE_INCLUDE_IPERF3=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_MTR=y/CONFIG_FIRMWARE_INCLUDE_MTR=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_WIREGUARD=y/CONFIG_FIRMWARE_INCLUDE_WIREGUARD=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENVPN=y/CONFIG_FIRMWARE_INCLUDE_OPENVPN=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_XUPNPD=y/CONFIG_FIRMWARE_INCLUDE_XUPNPD=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_NAPT66=y/CONFIG_FIRMWARE_INCLUDE_NAPT66=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_TTYD=y/CONFIG_FIRMWARE_INCLUDE_TTYD=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_NANO=y/CONFIG_FIRMWARE_INCLUDE_NANO=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SOCAT=y/CONFIG_FIRMWARE_INCLUDE_SOCAT=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SRELAY=y/CONFIG_FIRMWARE_INCLUDE_SRELAY=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SRELAY=y/CONFIG_FIRMWARE_INCLUDE_SRELAY=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_LRZSZ=y/CONFIG_FIRMWARE_INCLUDE_LRZSZ=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_DOGCOM=y/CONFIG_FIRMWARE_INCLUDE_DOGCOM=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENSSL_EC=n/CONFIG_FIRMWARE_INCLUDE_OPENSSL_EC=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENSSL_EXE=n/CONFIG_FIRMWARE_INCLUDE_OPENSSL_EXE=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SFTP=n/CONFIG_FIRMWARE_INCLUDE_SFTP=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_TCPDUMP=n/CONFIG_FIRMWARE_INCLUDE_TCPDUMP=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_HTTPS=n/CONFIG_FIRMWARE_INCLUDE_HTTPS=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_CURL=y/CONFIG_FIRMWARE_INCLUDE_CURL=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_DROPBEAR=n/CONFIG_FIRMWARE_INCLUDE_DROPBEAR=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENSSH=n/CONFIG_FIRMWARE_INCLUDE_OPENSSH=y/g' ${config_path}
    echo -e 'CONFIG_FIRMWARE_INCLUDE_SHADOWSOCKS=y' >>${config_path}
    echo -e 'CONFIG_FIRMWARE_INCLUDE_XRAY=y' >>${config_path}
    cp -f ${config_path} .config
    cat .config | grep -v "#CONFIG" | grep "=y" >/tmp/build.config
    # 修改storage大小
    sed -i '/size_etc/s/6M/40M/g' /opt/rt-n56u/trunk/user/scripts/dev_init.sh
    #### 替换谷歌dns为腾讯dns
    sed -i '/8\.8\.8\.8/s/8\.8\.8\.8/119.29.29.29/g' /opt/rt-n56u/trunk/user/rc/net_wan.c
}

function pre_build() {
    cd ${path}/toolchain-mipsel
    ./dl_toolchain.sh
}

function do_build() {
    cd ${path}/trunk
    ./build_firmware_modify ${TNAME} 0
}

function aft_build() {
    cp -f /opt/rt-n56u/trunk/images/${TNAME}* /opt/
    end_time=$(date "+%Y-%m-%d %H:%M:%S")
    echo $start_time
    echo $end_time
}

function git_clean() {
    cd ${path}
    git checkout .
    git reset .
    git clean -dfx
    git status
}

git_clean
up_config
pre_build
do_build
aft_build
