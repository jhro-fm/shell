#!/usrbin/env bash
#
# author: jhro-fm
# date: 2019/10/15
# encoding: utf8
# usage:php网站检测nginx MySQL php 连通性







<?php
$link = mysqli_connect("localhost", "root", "(Hlions..1015)", "wordpress");#这写主机用户等等

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}

echo "Success: A proper connection to MySQL was made! The my_db database is great." . PHP_EOL;
echo "Host information: " . mysqli_get_host_info($link) . PHP_EOL;

mysqli_close($link);
?>
