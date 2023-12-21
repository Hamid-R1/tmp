#!/bin/bash

# Get CPU utilization
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Get memory utilization
MEMORY_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEMORY_FREE=$(grep MemFree /proc/meminfo | awk '{print $2}')
MEMORY_CACHED=$(grep "^Cached" /proc/meminfo | awk '{print $2}')
MEMORY_BUFFERS=$(grep "^Buffers" /proc/meminfo | awk '{print $2}')
MEMORY_USED=$((MEMORY_TOTAL - MEMORY_FREE - MEMORY_CACHED - MEMORY_BUFFERS))
MEMORY_USAGE=$((100 * MEMORY_USED / MEMORY_TOTAL))

# Get disk utilization
DISK_USAGE=$(df -h | awk '$NF=="/"{printf "%d\n", $5}')

# Get network utilization
NETWORK_USAGE=$(sar -n DEV 1 1 | grep "Average:" | grep -v "IFACE" | awk '{print $5}')

# Make a report for Node Health
echo -e "Node Health Report: \ncpu=$CPU_USAGE\nmemory=$MEMORY_USAGE\ndisk=$DISK_USAGE\nnetwork=$NETWORK_USAGE" > node_health_report.txt
