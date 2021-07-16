#!/usr/bin/env bash
Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";
LOG_FILE="speedtest_result.log";

Check(){
    [[ $EUID -ne 0 ]] && echo -e "${RED}请使用 root 用户运行本脚本！${Font_Suffix}" && exit 1
    
    if [ -f /etc/redhat-release ]; then
        release="centos"
        elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
        elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
        elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
        elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
        elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
        elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    fi
    
    if  [ ! -e '/usr/bin/wget' ]; then
        echo "正在安装 Wget"
        if [ "${release}" == "centos" ]; then
            yum update > /dev/null 2>&1
            yum -y install wget > /dev/null 2>&1
        else
            apt-get update > /dev/null 2>&1
            apt-get -y install wget > /dev/null 2>&1
        fi
    fi
    
    if  [ ! -e './speedtest-cli/speedtest' ]; then
        echo "正在安装 Speedtest-cli"
        wget --no-check-certificate -qO speedtest.tgz "https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-$(uname -m)-linux.tgz" > /dev/null 2>&1
    fi
    mkdir -p speedtest-cli && tar zxvf speedtest.tgz -C ./speedtest-cli/ > /dev/null 2>&1 && chmod a+rx ./speedtest-cli/speedtest
}

Speedtest(){
    TempLog="speedtest_temp.log"
    
    if [ -n "$1" ];then
        speedtest-cli/speedtest -p no -s $1 --accept-license > $TempLog 2>&1
    else
        speedtest-cli/speedtest -p no --accept-license > $TempLog 2>&1
    fi
    
    is_upload=$(cat $TempLog | grep 'Upload')
    if [[ ${is_upload} ]]; then
        local Download="$(cat $TempLog | awk -F ' ' '/Download/{print $3}')          "
        local Upload="$(cat $TempLog | awk -F ' ' '/Upload/{print $3}')          "
        local Relatency=$(cat $TempLog | awk -F ' ' '/Latency/{print $2}')
        
        local nodeID="$1      "
        local nodeLocation="$2　　　　　　"
        local nodeISP=$3

        LANG=C
        
        temp=$(echo "${REDownload}" | awk -F ' ' '{print $1}')
        echo -e "${Font_Red}${nodeID:0:6}${Font_Yello}${nodeISP}${Font_Suffix}|${Font_Green}${nodeLocation:0:24}${Font_SkyBlue}↑ ${Upload:0:10} ${Font_Blue}↓ ${Download:0:10} ${Font_Pueple}${Relatency}${Font_Suffix}"
    else
        local cerror="ERROR"
    fi
}

Menu() {
    echo "Speedtest by Ookla"
    echo "项目地址 https://github.com/CoiaPrant/Speedtest"
    echo "全部节点列表:  https://git.io/superspeedList"
    echo "——————————————————————————————————————————————————————————"
    
    echo -e "  测速类型:    ${Font_Green}1.${Font_Suffix} 三网测速    ${Font_Green}2.${Font_Suffix} 取消测速"
    echo -ne "               ${Font_Green}3.${Font_Suffix} 电信节点    ${Font_Green}4.${Font_Suffix} 联通节点    ${Font_Green}5.${Font_Suffix} 移动节点"
    while :; do echo
        read -p "  请输入数字选择测速类型: " selection
        if [[ ! $selection =~ ^[1-5]$ ]]; then
            echo -ne "  ${Font_Red}输入错误${Font_Suffix}, 请输入正确的数字!"
        else
            break
        fi
    done
    
    [[ ${selection} == 2 ]] && exit 1
    echo "——————————————————————————————————————————————————————————"
    echo "ID    测速服务器信息       上传/Mbps   下载/Mbps   延迟/ms"
    
    if [[ ${selection} == 1 ]]; then
        Speedtest '' '默认' '本地'
        Test_CT;
        Test_CU;
        Test_CM;
    fi
    
    if [[ ${selection} == 3 ]]; then
        Test_CT;
    fi
    
    if [[ ${selection} == 4 ]]; then
        Test_CU;
    fi
    
    if [[ ${selection} == 5 ]]; then
        Test_CM;
    fi
    
    rm -rf speedtest*
    echo "——————————————————————————————————————————————————————————"
    
}

Test_CT() {
    Speedtest '3633' '上海' '电信'
    Speedtest '24012' '内蒙古呼和浩特' '电信'
    Speedtest '27377' '北京５Ｇ' '电信'
    Speedtest '29026' '四川成都' '电信'
    Speedtest '29071' '四川成都' '电信'
    Speedtest '17145' '安徽合肥５Ｇ' '电信'
    Speedtest '27594' '广东广州５Ｇ' '电信'
    Speedtest '27810' '广西南宁' '电信'
    Speedtest '27575' '新疆乌鲁木齐' '电信'
    Speedtest '26352' '江苏南京５Ｇ' '电信'
    Speedtest '5396' '江苏苏州５Ｇ' '电信'
    Speedtest '5317' '江苏连云港５Ｇ' '电信'
    Speedtest '7509' '浙江杭州' '电信'
    Speedtest '23844' '湖北武汉' '电信'
    Speedtest '29353' '湖北武汉５Ｇ' '电信'
    Speedtest '28225' '湖南长沙５Ｇ' '电信'
    Speedtest '3973' '甘肃兰州' '电信'
    Speedtest '19076' '重庆' '电信'
}

Test_CU() {
    Speedtest '21005' '上海' '联通'
    Speedtest '24447' '上海５Ｇ' '联通'
    Speedtest '5103' '云南昆明' '联通'
    Speedtest '5145' '北京' '联通'
    Speedtest '5505' '北京' '联通'
    Speedtest '9484' '吉林长春' '联通'
    Speedtest '2461' '四川成都' '联通'
    Speedtest '27154' '天津５Ｇ' '联通'
    Speedtest '5509' '宁夏银川' '联通'
    Speedtest '5724' '安徽合肥' '联通'
    Speedtest '5039' '山东济南' '联通'
    Speedtest '26180' '山东济南５Ｇ' '联通'
    Speedtest '26678' '广东广州５Ｇ' '联通'
    Speedtest '16192' '广东深圳' '联通'
    Speedtest '6144' '新疆乌鲁木齐' '联通'
    Speedtest '13704' '江苏南京' '联通'
    Speedtest '5485' '湖北武汉' '联通'
    Speedtest '26677' '湖南株洲' '联通'
    Speedtest '4870' '湖南长沙' '联通'
    Speedtest '4690' '甘肃兰州' '联通'
    Speedtest '4884' '福建福州' '联通'
    Speedtest '31985' '重庆' '联通'
    Speedtest '4863' '陕西西安' '联通'
}

Test_CM() {
    Speedtest '30154' '上海' '移动'
    Speedtest '25637' '上海５Ｇ' '移动'
    Speedtest '26728' '云南昆明' '移动'
    Speedtest '27019' '内蒙古呼和浩特' '移动'
    Speedtest '30232' '内蒙呼和浩特５Ｇ' '移动'
    Speedtest '30293' '内蒙古通辽５Ｇ' '移动'
    Speedtest '25858' '北京' '移动'
    Speedtest '16375' '吉林长春' '移动'
    Speedtest '24337' '四川成都' '移动'
    Speedtest '17184' '天津５Ｇ' '移动'
    Speedtest '26940' '宁夏银川' '移动'
    Speedtest '31815' '宁夏银川' '移动'
    Speedtest '26404' '安徽合肥５Ｇ' '移动'
    Speedtest '27151' '山东临沂５Ｇ' '移动'
    Speedtest '25881' '山东济南５Ｇ' '移动'
    Speedtest '27100' '山东青岛５Ｇ' '移动'
    Speedtest '26501' '山西太原５Ｇ' '移动'
    Speedtest '31520' '广东中山' '移动'
    Speedtest '6611' '广东广州' '移动'
    Speedtest '4515' '广东深圳' '移动'
    Speedtest '15863' '广西南宁' '移动'
    Speedtest '16858' '新疆乌鲁木齐' '移动'
    Speedtest '26938' '新疆乌鲁木齐５Ｇ' '移动'
    Speedtest '17227' '新疆和田' '移动'
    Speedtest '17245' '新疆喀什' '移动'
    Speedtest '17222' '新疆阿勒泰' '移动'
    Speedtest '27249' '江苏南京５Ｇ' '移动'
    Speedtest '21845' '江苏常州５Ｇ' '移动'
    Speedtest '26850' '江苏无锡５Ｇ' '移动'
    Speedtest '17320' '江苏镇江５Ｇ' '移动'
    Speedtest '25883' '江西南昌５Ｇ' '移动'
    Speedtest '17223' '河北石家庄' '移动'
    Speedtest '26331' '河南郑州５Ｇ' '移动'
    Speedtest '6715' '浙江宁波５Ｇ' '移动'
    Speedtest '4647' '浙江杭州' '移动'
    Speedtest '16503' '海南海口' '移动'
    Speedtest '28491' '湖南长沙５Ｇ' '移动'
    Speedtest '16145' '甘肃兰州' '移动'
    Speedtest '16171' '福建福州' '移动'
    Speedtest '18444' '西藏拉萨' '移动'
    Speedtest '16398' '贵州贵阳' '移动'
    Speedtest '25728' '辽宁大连' '移动'
    Speedtest '16167' '辽宁沈阳' '移动'
    Speedtest '17584' '重庆' '移动'
    Speedtest '26380' '陕西西安' '移动'
    Speedtest '29105' '陕西西安５Ｇ' '移动'
    Speedtest '29083' '青海西宁５Ｇ' '移动'
    Speedtest '26656' '黑龙江哈尔滨' '移动'
}

Check;
clear
Menu;