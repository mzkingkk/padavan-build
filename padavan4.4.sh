#!/usr/bin/bash
set -e
action_for=$1
export TNAME="R2100"
path=$(pwd)
start_time=$(date "+%Y-%m-%d %H:%M:%S")

SHELL_FOLDER=$(dirname "$0")

pre_install_rpm() {
    echo "start to install package"
    sudo apt-get update >/dev/null
    # python-docutils 是推荐安装的依赖，但测试了几台机器没这个包，就默认不装了
    sudo apt-get -y install unzip zip libtool-bin curl cmake gperf gawk flex bison xxd fakeroot \
        cpio gettext automake autopoint texinfo build-essential help2man \
        pkg-config zlib1g-dev libgmp3-dev libmpc-dev libmpfr-dev libncurses5-dev libltdl-dev wget \
        bc libssl-dev liblzma-dev >/dev/null
}

pre_install_golang() {
    if [ ! -f /usr/local/go/bin/go ]; then
        cd /opt
        wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz
        tar -C /usr/local -zxf go1.24.2.linux-amd64.tar.gz
        rm -rf go1.24.2.linux-amd64.tar.gz
        sed -i '/GOROOT/d' /etc/profile
        echo -e 'export GOROOT=/usr/local/go' >>/etc/profile
        echo -e 'export PATH=$PATH:$GOROOT/bin' >>/etc/profile
        source /etc/profile
        go env -w GOPROXY=https://goproxy.cn,direct
    fi
}

up_config() {
    cd ${path}/trunk
    config_path=configs/templates/${TNAME}.config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_MENTOHUST/d' ${config_path} #删除配置项MENTOHUST
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_MSD_LITE=y/CONFIG_FIRMWARE_INCLUDE_MSD_LITE=n/g' ${config_path}
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
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SMARTDNS=y/CONFIG_FIRMWARE_INCLUDE_SMARTDNS=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SFTP=y/CONFIG_FIRMWARE_INCLUDE_SFTP=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_TCPDUMP=n/CONFIG_FIRMWARE_INCLUDE_TCPDUMP=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_HTTPS=n/CONFIG_FIRMWARE_INCLUDE_HTTPS=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_CURL=n/CONFIG_FIRMWARE_INCLUDE_CURL=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_DROPBEAR=n/CONFIG_FIRMWARE_INCLUDE_DROPBEAR=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_OPENSSH=y/CONFIG_FIRMWARE_INCLUDE_OPENSSH=n/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_SHADOWSOCKS=n/CONFIG_FIRMWARE_INCLUDE_SHADOWSOCKS=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_XRAY=n/CONFIG_FIRMWARE_INCLUDE_XRAY=y/g' ${config_path}
    sed -i 's/CONFIG_FIRMWARE_INCLUDE_TROJAN=y/CONFIG_FIRMWARE_INCLUDE_TROJAN=n/g' ${config_path}
    sed -i '/CONFIG_FIRMWARE_MT7621_OC/s/0x312/0x362/g' ${config_path}
    cp -f ${config_path} .config
    cat .config | grep -v "#CONFIG" | grep "=y" >/tmp/build.config
    cat /tmp/build.config
    # 修改storage大小
    init_path='user/scripts/dev_init.sh'
    if [ -f user/scripts/files/sbin/dev_init.sh ]; then
        init_path='user/scripts/files/sbin/dev_init.sh'
    fi
    sed -i '/size_etc/s/6M/60M/g' ${init_path}
    #### 替换谷歌dns为腾讯dns
    wan_path='user/rc/net_wan.c'
    if [ -f user/rc/src/net_wan.c ]; then
        wan_path='user/rc/src/net_wan.c'
    fi
    sed -i '/8\.8\.8\.8/s/8\.8\.8\.8/119.29.29.29/g' ${wan_path}
    find ${path} -iname *.sh | xargs chmod +x
}

pre_build() {
    if [ -f ${path}/toolchain-mipsel/dl_toolchain.sh ]; then
        cd ${path}/toolchain-mipsel
        ./dl_toolchain.sh
    fi
}

do_build() {
    cd ${path}/trunk
    if [ -f ./build_firmware_modify ]; then
        ./build_firmware_modify ${TNAME} 0
    else
        cd ..
        make ${TNAME}
    fi
}

aft_build() {
    cp -f ${path}/trunk/images/*.trx /opt/
    end_time=$(date "+%Y-%m-%d %H:%M:%S")
    echo $start_time
    echo $end_time
}

git_clean() {
    cd ${path}
    git checkout ./
    git clean -dfx
    git status
}

if [[ "${action_for}" == "install" ]]; then
    pre_install_rpm
    pre_install_golang
elif [[ "${action_for}" == "clean" ]]; then
    git_clean
elif [[ "${action_for}" == "config" ]]; then
    up_config
elif [[ "${action_for}" == "fix" ]]; then
    chmod +x ${SHELL_FOLDER}/*.sh
    ${SHELL_FOLDER}/fix.sh ${path}
elif [[ "${action_for}" == "build" ]]; then
    pre_build
    do_build
    aft_build
else
    echo "输入不合法 install|clean|fix|config|build"
    echo "当前: ${action_for}"
fi
