pre_path=$(dirname $0)
aft_path=$1

upx_min_xray='1.8.17.04'

main() {
    # cp -arf ${pre_path}/Makefile ${aft_path}/
    cp -arf ${pre_path}/tools/ipt2socks ${aft_path}/trunk/user/
    cp -arf ${pre_path}/tools/util-linux ${aft_path}/trunk/user/
    cp -arf ${pre_path}/tools/lzma ${aft_path}/trunk/tools/

    cp -arf ${pre_path}/tools/www/genxrayconfig.lua ${aft_path}/trunk/user/shadowsocks/ss/
    cp -arf ${pre_path}/tools/www/Shadowsocks.asp ${aft_path}/trunk/user/www/n56u_ribbon_fixed/

    # cp -arf ${pre_path}/tools/xray/old_Makefile ${aft_path}/trunk/user/xray/Makefile
    cp -arf ${pre_path}/tools/xray/Makefile ${aft_path}/trunk/user/xray/
    wget -O ${aft_path}/trunk/user/xray/upx.min.xray https://github.com/mzkingkk/xray-core-min/releases/download/v${upx_min_xray}/upx.min.xray
}
main
