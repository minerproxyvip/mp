#!/bin/bash
[[ $(id -u) != 0 ]] && echo -e "请使用root权限运行安装脚本" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "此脚本不支持该系统" && exit 1
fi

install() {

    $cmd update -y
    $cmd install curl wget screen supervisor  systemctl  net-tools -y

    if [ -d "/root/mp" ]; then
        echo -e "您已安装了该软件,如果确定没有安装,请输入rm -rf /root/mp" && exit 1
    fi
    if netstat -antpl | grep -q "mp"; then
        echo -e "检测到您已启动了 mp, 请关闭后再安装" && exit 1
    fi



    mkdir /root/mp

    wget https://github.com/minerproxyvip/mp/releases/download/v1.0/mp -O /root/mp/mp

    esac
    chmod 777 /root/mp/mp

    wget https://github.com/minerproxyvip/mp/blob/main/script/mp.conf -O /etc/supervisor/conf.d/mp.conf

    systemctl restart supervisor

    echo "如果没有报错则安装成功"
    echo "正在启动抽水中转软件..."

    sleep 1s
    cat /root/mp/config.yml
    echo "请记录您的token和端口 并打开 http://服务器ip:端口 访问web服务进行配置"    
}

uninstall() {
    read -p "是否确认删除mp[yes/no]：" flag
    if [ -z $flag ]; then
        echo "输入错误" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then            
            systemctl stop supervisor
            rm -rf /root/mp
            echo "卸载mp成功"
            rm /etc/supervisor/conf.d/mp.conf
            systemctl restart supervisor
        fi
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
echo "默认安装到/root/mp"
echo "======================================================="
install

 

