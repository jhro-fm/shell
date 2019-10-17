#!/usr/bin/env bash
#
# author: jhro-fm
# date: 2019/10/17
# usage: monitor memory status \(监控内存使用量)


#- total是总内存数
#- used是已经使用的内存数
#- free是空闲的内存数
#- shared是多个进程共享的内存总数
#- buffers是缓冲内存数
#- cached是缓存内存数


#先指定时间，过滤邮箱的变量

DATE=$(date +'%Y-%m-%d %H:%M:%S')
IPADDR=$(ifconfig | grep inet | awk 'BEGIN{ FS=" " }NR==1{ print $2 }')
MAIL="jhro-fm@163.com"

TOTAL=$(free -mw | awk 'NR==2{ print $2 }')
USE=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $3 }')
FREE=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $4 }')
CACHE=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $7 }')
useRate=$(echo "((${USE}+${CACHE})/${TOTAL})*100" | bc -ql)
freeRate=$(echo "(${FREE}/${TOTAL})*100" | bc -ql)

if [[ ${FREE} -le 100 ]];then
  echo "
	Date: ${DATE}
	Host: ${HOSTNAME}: ${IPADDR}
	Problem: 
		Memory using rate: ${useRate:0:5}%
		Memory free rate: ${freeRate:0:5}%
	" | mail -s "CPU Monitor Warnning" ${MAIL}
fi
