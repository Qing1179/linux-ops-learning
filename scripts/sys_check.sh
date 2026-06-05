#!/bin/bash
echo "==================================="
echo " centos 9 自动化巡检报告"
echo " 时间：$(date +"%Y-%m-%d %H:%M:%S")"
echo "==================================="

echo "[1] 内存使用情况 (可用)："
free -h | grep Mem | awk '{print $7}'

echo "[2]根目录磁盘余量"
df -h / | tail -n 1 |awk '{print $4}'
echo "==================================="
