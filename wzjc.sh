#!/usr/bin/env bash
#
# author: jhro-fm
# date: 2019/10/15
# encoding: utf8
# usage:网站状态监控
# 












URLLIST=$(egrep "com|cn" ./wang.txt)#是为了grep出网址
for url in ${URLLIST}; do
  statuCode=$(curl -I --connect-timeout 3 -m 10 -s ${url} | grep "HTTP")#设置最大访问时间
  if [[ ${statuCode: 9: 3} -eq 200 ]] || [[ ${statuCode: 9: 3} -eq 302 ]];then#判断状态码
    echo "$(date +'%Y-%m-%d %H:%M:%S') - run monitor program ${url} is ok" >>/var/log/urlMonitor.log#如果正确就把输出到/var/log/urlMonitor.log里
  else
    echo "$(date +'%Y-%m-%d %H:%M:%S') - run monitor program ${url} is failed" >>/var/log/urlMonitor.log#如果错误也输出
    echo "[ERROR] ${url} Downtime! Please repair." | mail -s "warnning website" 18310381832@163.com#并发送文件给邮箱
  fi
done
