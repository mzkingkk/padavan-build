#!/usr/bin/bash

set -e
set -x

export TNAME="R2100"
path="/opt/rt-n56u"
start_time=$(date "+%Y-%m-%d %H:%M:%S")

up_config(){
    cd ${path}/trunk
    config_path=configs/templates/$TNAME.config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_MENTOHUST/d' $config_path #删除配置项MENTOHUST
    sed -i 's/CONFIG_FIRMWARE_ENABLE_IPV6=y/CONFIG_FIRMWARE_ENABLE_IPV6=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_EAP_PEAP=y/CONFIG_FIRMWARE_INCLUDE_EAP_PEAP=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_VLMCSD=y/CONFIG_FIRMWARE_INCLUDE_VLMCSD=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_HTOP=y/CONFIG_FIRMWARE_INCLUDE_HTOP=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_IPERF3=y/CONFIG_FIRMWARE_INCLUDE_IPERF3=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_MTR=y/CONFIG_FIRMWARE_INCLUDE_MTR=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_WIREGUARD=y/CONFIG_FIRMWARE_INCLUDE_WIREGUARD=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENVPN=y/CONFIG_FIRMWARE_INCLUDE_OPENVPN=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_XUPNPD=y/CONFIG_FIRMWARE_INCLUDE_XUPNPD=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_NAPT66=y/CONFIG_FIRMWARE_INCLUDE_NAPT66=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_TTYD=y/CONFIG_FIRMWARE_INCLUDE_TTYD=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_NANO=y/CONFIG_FIRMWARE_INCLUDE_NANO=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SOCAT=y/CONFIG_FIRMWARE_INCLUDE_SOCAT=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SRELAY=y/CONFIG_FIRMWARE_INCLUDE_SRELAY=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_MSD_LITE=y/CONFIG_FIRMWARE_INCLUDE_MSD_LITE=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_LRZSZ=y/CONFIG_FIRMWARE_INCLUDE_LRZSZ=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_DROPBEAR=n/CONFIG_FIRMWARE_INCLUDE_DROPBEAR=y/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_DOGCOM=y/CONFIG_FIRMWARE_INCLUDE_DOGCOM=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENSSL_EC=n/CONFIG_FIRMWARE_INCLUDE_OPENSSL_EC=y/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENSSL_EXE=y/CONFIG_FIRMWARE_INCLUDE_OPENSSL_EXE=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SFTP=n/CONFIG_FIRMWARE_INCLUDE_SFTP=y/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_TCPDUMP=n/CONFIG_FIRMWARE_INCLUDE_TCPDUMP=y/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_HTTPS=n/CONFIG_FIRMWARE_INCLUDE_HTTPS=y/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_CURL=y/CONFIG_FIRMWARE_INCLUDE_CURL=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENSSH=y/CONFIG_FIRMWARE_INCLUDE_OPENSSH=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SHADOWSOCKS=y/CONFIG_FIRMWARE_INCLUDE_SHADOWSOCKS=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_TROJAN=y/CONFIG_FIRMWARE_INCLUDE_TROJAN=n/g' $config_path
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SMARTDNS=y/CONFIG_FIRMWARE_INCLUDE_SMARTDNS=n/g' $config_path
    cp -f $config_path .config
    cat .config | grep -v "#CONFIG" | grep "=y" > /tmp/build.config
    # 修改storage大小
    sed -i '/size_etc/s/6M/40M/g' /opt/rt-n56u/trunk/user/scripts/dev_init.sh
    #### 替换谷歌dns为腾讯dns
    sed -i '/8\.8\.8\.8/s/8\.8\.8\.8/119.29.29.29/g' /opt/rt-n56u/trunk/user/rc/net_wan.c
}

# 修改默认dns
fix_dns() {
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/shared/defaults.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/dns-forwarder/dns-forwarder-1.2.1/hev-main.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/linux-4.4.x/drivers/net/wireless/mediatek/mt7615/embedded/common/cmm_profile.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/linux-4.4.x/drivers/net/wireless/mediatek/mt76x2/common/cmm_profile.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/linux-4.4.x/drivers/net/wireless/mediatek/mt76x3/common/cmm_profile.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/linux-4.4.x/drivers/net/wireless/mediatek/mt7915/embedded/common/cmm_profile.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/dnsmasq/dnsmasq-2.8x/src/option.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/iptables/iptables-1.8.7/extensions/generic.txlate
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/iptables/iptables-1.8.7/extensions/libxt_tcp.txlate
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/iptables/iptables-1.8.7/extensions/libxt_udp.txlate
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/miniupnpd/miniupnpd-2.x/netfilter/testiptcrdr.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/mtr/mtr-0.92/man/mtr-packet.8.in
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/mtr/mtr-0.92/test/cmdparse.py
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/mtr/mtr-0.92/test/probe.py
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/rc/net_wan.c
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/redsocks/redsocks-19b822e/debian/redsocks.conf
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/redsocks/redsocks-19b822e/redsocks.conf.example
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/redsocks/redsocks-19b822e/tests/conftest.py
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/wing/wing
    sed -i 's/8.8.8.8/119.29.29.29/g' ${path}/trunk/user/www/n56u_ribbon_fixed/Shadowsocks.asp
    
    grep -rn "8\.8\.8\.8" | grep -vE "html|\.md|CHANGELOG" | grep "8\.8\.8\.8"
}

pre_build(){
    cd ${path}/trunk/toolchain-mipsel
    ./dl_toolchain.sh
}

do_build(){
    cd ${path}/trunk
    ./build_firmware_modify $TNAME 0
}

aft_build(){
    cp -f /opt/rt-n56u/trunk/images/RM2100*.trx /opt/
    end_time=$(date "+%Y-%m-%d %H:%M:%S")
    echo $start_time
    echo $end_time
}

cd ${path}/trunk
git checkout .
git clean -dfx

up_config
# pre_build
# do_build
# aft_build