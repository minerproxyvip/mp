#!/bin/bash
[[ $(id -u) != 0 ]] && echo -e "请使用root权限运行安装脚本， 通过sudo su root切换再来运行" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "此脚本不支持该系统" && exit 1
fi



function check_sys() {
  if [[ -f /etc/redhat-release ]]; then
    release="centos"
  elif cat /etc/issue | grep -q -E -i "debian"; then
    release="debian"
  elif cat /etc/issue | grep -q -E -i "ubuntu"; then
    release="ubuntu"
  elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
  elif cat /proc/version | grep -q -E -i "debian"; then
    release="debian"
  elif cat /proc/version | grep -q -E -i "ubuntu"; then
    release="ubuntu"
  elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
  fi
  bit=$(uname -m)
  if test "$bit" != "x86_64"; then
    echo "请输入你的芯片架构，/386/armv5/armv6/armv7/armv8"
    read bit
  else
    bit="amd64"
  fi
}

function Installation_dependency() {
    if [[ ${release} == "centos" ]]; then
        yum update
        yum install -y wget      
    else
        apt-get update     
        apt install wget
    fi
}

function check_root() {
  [[ $EUID != 0 ]] && echo -e "${Error} 当前非ROOT账号(或没有ROOT权限)，无法继续操作，请更换ROOT账号或使用 ${Green_background_prefix}sudo su${Font_color_suffix} 命令获取临时ROOT权限（执行后可能会提示输入当前账号的密码）。" && exit 1
}





install() {

    ufw disable

    rm  /var/lib/dpkg/lock
    $cmd  clean
    rm /var/lib/dpkg/updates/*
    $cmd update -y
    
    $cmd install net-tools -y    
    # $cmd install supervisor -y  
    $cmd install systemctl -y  
    $cmd install curl wget screen -y    

    $cmd install iptables -y  

    sleep 2s

    systemctl stop minerProxy
    systemctl disable minerProxy
    

    mkdir /root/minerProxy
    cd /root/minerProxy

    wget --no-check-certificate https://github.com/minerproxyvip/mp/releases/download/v1.0/minerProxy  && chmod -R 777  minerProxy
    wget --no-check-certificate https://raw.githubusercontent.com/minerproxyvip/mp/main/script/minerProxy.service  && chmod -R 777 minerProxy.service && mv minerProxy.service /usr/lib/systemd/system
    wget --no-check-certificate https://raw.githubusercontent.com/minerproxyvip/mp/main/script/minerProxy.sh  && chmod -R 777 minerProxy.sh
    
        
    echo "正在启动软件，请稍候"
    
    nohup ~/minerProxy/minerProxy.sh &
    sleep 2s
    # systemctl daemon-reload
    sleep 2s
    systemctl enable minerProxy 
    sleep 2s
    # systemctl start minerProxy
    # sleep 2s
    sed -i 's/18888/18188/g'  ~/minerProxy/config.yml
    sed -i 's/18889/18188/g'  ~/minerProxy/config.yml
    # systemctl restart minerProxy
    
    echo "如果没有报错则安装成功"
    sleep 2s
    echo "如果安装不成功，则重启服务器后重新安装， 重启命令 reboot "
    sleep 2s
    echo "正在启动抽水中转软件...请稍等"
    sleep 2s
    echo "1，请进后台打开防火墙端口"
    sleep 2s
    echo "2，有的服务器需要检查ufw情况"    
    sleep 5s    
}


uninstall() {
    read -p "是否确认删除mp[yes/no]：" flag
    if [ -z $flag ]; then
        echo "输入错误" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then            
            systemctl stop mminerProxy
            systemctl disable minerProxy
            rm -rf /root/minerProxy
            echo "卸载mp成功"        
        fi
    fi
}


check_done() {
    if netstat -antpl | grep -q "minerProxy"; then
        echo -e "\n\n" 
        echo -e "-----------------------------------"
         echo -e "\n" 
        echo -e "安装成功，抽水软件已经在运行......" 
        echo -e "\n" 
        cat /root/minerProxy/config.yml
        echo "请记录您的token和端口 并打开 http://服务器ip:端口 访问web服务进行配置"    
         echo -e "\n" 
        echo -e "-----------------------------------"
        echo -e "\n" 
    else        
        echo -e "\n\n" 
        echo "安装不成功，请重启后重新安装"   
        echo "出现各种选择，请按 确认/OK"
        echo -e "\n\n" 
    fi      
}


start() {
    echo "启动抽水中转软件"
    systemctl start supervisor
}

restart() {
    echo "启动抽水中转软件"
    systemctl restart supervisor
}

 stop() {
    echo "关闭抽水中转软件"
    systemctl stop supervisor
}


change_limit(){
    num="n"
    if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root soft nofile 102400" >>/etc/security/limits.conf
        num="y"
    fi

    if [[ "$num" = "y" ]]; then
        echo "连接数限制已修改为102400,重启服务器后生效"
    else
        echo -n "当前连接数限制："
        ulimit -n
    fi
}

check_limit(){
    echo -n "当前连接数限制："
    ulimit -n
}

echo "======================================================="
echo "抽水中转一键安装工具"
echo "默认安装到/root/minerProxy"
echo "如果安装不成功，则重启服务器后重新安装"
echo "出现各种选择，请按 确认/OK"
echo "======================================================="
check_limit
change_limit
install
check_done

 


