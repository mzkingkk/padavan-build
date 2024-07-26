pre_path="/opt/vb1980_fix/"
aft_path="/opt/rt-n56u/"

main() {
    cp -arf ${pre_path}/Makefile ${aft_path}
    cp -arf ${pre_path}/ipt2socks ${aft_path}/trunk/user/
    cp -arf ${pre_path}/util-linux ${aft_path}/trunk/user/
    cp -arf ${pre_path}/lzma ${aft_path}/trunk/tools/

    cp -arf ${pre_path}/www/genxrayconfig.lua ${aft_path}/trunk/user/shadowsocks/ss/
    cp -arf ${pre_path}/www/Shadowsocks.asp ${aft_path}/trunk/user/www/n56u_ribbon_fixed/

    cp -arf ${pre_path}/xray/old_Makefile ${aft_path}/trunk/user/xray/Makefile
    cp -arf ${pre_path}/xray/Makefile ${aft_path}/trunk/user/xray/
    cp -arf ${pre_path}/xray/upx.min.xray ${aft_path}/trunk/user/xray/
}
main
