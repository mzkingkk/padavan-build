#!/usr/bin/bash
pre_path=$(dirname $0)
aft_path=$1

upx_min_xray='1.8.17.04'

comm() {
    cp -arf ${pre_path}/tools/lzma ${aft_path}/trunk/tools/

    # cp -arf ${pre_path}/tools/xray/old_Makefile ${aft_path}/trunk/user/xray/Makefile
    cp -arf ${pre_path}/tools/xray/Makefile ${aft_path}/trunk/user/xray/
    wget -O ${aft_path}/trunk/user/xray/upx.min.xray https://github.com/mzkingkk/xray-core-min/releases/download/v${upx_min_xray}/upx.min.xray
}

fun_TurBoTse() {
    # cp -arf ${pre_path}/tools/mksquashfs_xz ${aft_path}/trunk/tools/
    cp -arf ${pre_path}/tools/www.TurBoTse/genxrayconfig.lua ${aft_path}/trunk/user/shadowsocks/ss/
    cp -arf ${pre_path}/tools/www.TurBoTse/Shadowsocks.asp ${aft_path}/trunk/user/www/n56u_ribbon_fixed/

    cp -arf ${pre_path}/tools/queue/queue.h ${aft_path}/toolchain/
    sed -i '/cp -f /d' ${aft_path}/toolchain/Makefile
    sed -i '/Installing/ a\               cp -f $(TOPDIR)\/queue.h $(TOPDIR)\/toolchain-mipsel\/mipsel-linux-musl\/sysroot\/usr\/include\/sys\/; \\' ${aft_path}/toolchain/Makefile
    sed -i '/curl -fSsL -o/d' ${aft_path}/toolchain/Makefile
    sed -i '/sourceware.org/d' ${aft_path}/toolchain/Makefile
}

fun_vb1980() {
    cp -arf ${pre_path}/Makefile ${aft_path}/
    cp -arf ${pre_path}/tools/ipt2socks ${aft_path}/trunk/user/
    cp -arf ${pre_path}/tools/util-linux ${aft_path}/trunk/user/

    cp -arf ${pre_path}/tools/www.vb1980/genxrayconfig.lua ${aft_path}/trunk/user/shadowsocks/ss/
    cp -arf ${pre_path}/tools/www.vb1980/Shadowsocks.asp ${aft_path}/trunk/user/www/n56u_ribbon_fixed/
}
echo "path is ${aft_path}"
if [[ "${aft_path}" =~ "TurBoTse" ]]; then
    comm
    fun_TurBoTse
elif [[ "${aft_path}" =~ "vb1980" ]]; then
    comm
    fun_vb1980
else
    echo "输入不合法 TurBoTse|vb1980"
    echo "当前: ${action_for}"
fi
