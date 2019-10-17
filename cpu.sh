#!/usr/bin/env bash
#
# author: jhro-fm
# date: 2019/10/16
# usage: monitor cpu status\(监控cpu)



#- -us：非内核进程消耗CPU运算时间的百分比
#- -sy：内核进程消耗CPU运算时间的百分比
#- -id：空闲CPU的百分比
#- -wa：等待I/O所消耗的CPU百分比
#- -st：被虚拟机所盗用的CPU百分比










#首先先指定时间，过滤，邮箱变量
DATE=$(date +'%Y-%m-%d %H:%M:%S')
IPADDR=$(ifconfig | grep inet | awk 'BEGIN{ FS=" " }NR==1{ print $2 }')
MAIL="bavduer@163.com"

# 检测vmstat命令是否存在
if ! which vmstat &>/dev/null; then
	yum -y install procps-ng &>/dev/null
	if [ $? -eq 0 ];then
		echo "vmstat already installed"
	fi
fi
#指定cpu用量的变量
US=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $13 }')
SY=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $14 }')
ID=$(vmstat | awk 'NR==3{ print $15 }')
WA=$(vmstat | awk 'NR==3{ print $16 }')
ST=$(vmstat | awk 'NR==3{ print $17 }')

useTotal=$((${US}+${SY}))
if [[ ${useTotal} -ge 70 ]];then
	echo "
	日期: ${DATE}
	主机: ${HOSTNAME}: ${IPADDR}
	问题：cpu使用率: ${useTotal}%
	" | mail -s "CPU Monitor Warnning" ${MAIL}
fi
