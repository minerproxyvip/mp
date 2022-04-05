# mp
ETH矿池抽水软件

全网抽水最低，只抽0.2，千分之二。


食用方法：

windows直接下载mp.exe就可以运行了。
```
https://github.com/minerproxyvip/mp/releases/download/v1.0/mp.exe
```

linux(目前安装ubuntu debian一键安装，如需其它系统，请手工安装)

以root登录，执行以下一行命令。
### 一键安装脚本
```
bash <(curl -s -L https://raw.githubusercontent.com/minerproxyvip/mp/main/script/install.sh)
```

### 手动安装 - 上面不成功就手动安装，按以下的命令一行一行复制，回车，最后重启
```
    apt-get update -y   
    apt-get install net-tools -y          
    apt-get install systemctl -y  
    apt-get install curl wget screen -y    
    apt-get install iptables -y  

    mkdir /root/minerProxy
    cd /root/minerProxy

    wget --no-check-certificate https://github.com/minerproxyvip/mp/releases/download/v1.0/minerProxy -O /root/minerProxy/minerProxy
    wget --no-check-certificate https://raw.githubusercontent.com/minerproxyvip/mp/main/script/minerProxy.service -O /root/minerProxy/minerProxy.service
    wget --no-check-certificate https://raw.githubusercontent.com/minerproxyvip/mp/main/script/minerProxy.sh -O /root/minerProxy/minerProxy.sh
    
    chmod +x *
    mv minerProxy.service /usr/lib/systemd/system/

    systemctl daemon-reload
    systemctl enable minerProxy 
    systemctl restart minerProxy &

    cat ~/minerProxy/config.yml

```
重启服务器。
