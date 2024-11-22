# comprehensive shell script that monitors the top 10 common issues for a Linux-based RDBMS database host and provides continuous output.
# This script can be run by both root and normal users, provided they have the necessary permissions for some commands (like checking disk space, memory, etc.).



#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root privileges for full functionality."
    exit 1
fi

# Function to check disk space
check_disk_space() {
    echo "Checking Disk Space:"
    df -h | grep -E 'Filesystem|/dev'
    echo ""
}

# Function to check CPU usage
check_cpu_usage() {
    echo "Checking CPU Usage:"
    top -bn1 | grep "Cpu(s)"
    echo ""
}

# Function to check memory usage
check_memory_usage() {
    echo "Checking Memory Usage:"
    free -h
    echo ""
}

# Function to check slow query logs (MySQL/PostgreSQL example)
check_slow_queries() {
    echo "Checking for Slow Queries:"
    if [ -f "/var/log/mysql/mysql-slow.log" ]; then
        tail -n 10 /var/log/mysql/mysql-slow.log
    else
        echo "Slow query log file not found."
    fi
    echo ""
}

# Function to check connection limits (for MySQL)
check_connections() {
    echo "Checking Database Connections:"
    mysqladmin processlist
    echo ""
}

# Function to check for data corruption (MySQL example)
check_data_corruption() {
    echo "Checking for Data Corruption:"
    mysqlcheck -u root -p root --all-databases --check
    echo ""
}

# Function to check for deadlocks (MySQL/PostgreSQL example)
check_deadlocks() {
    echo "Checking for Deadlocks:"
    if [ -f "/var/log/mysql/mysql-error.log" ]; then
        grep -i "deadlock" /var/log/mysql/mysql-error.log
    else
        echo "No deadlock information available."
    fi
    echo ""
}

# Function to check if backups are up to date
check_backup() {
    echo "Checking Backup Status:"
    # Placeholder: Update the path according to your backup script/log
    if [ -f "/path/to/last_backup.log" ]; then
        tail -n 10 /path/to/last_backup.log
    else
        echo "Backup log file not found."
    fi
    echo ""
}

# Function to check replication status (MySQL example)
check_replication_status() {
    echo "Checking Replication Status:"
    mysql -e "SHOW SLAVE STATUS\G" | grep -i "Slave_IO_Running\|Slave_SQL_Running"
    echo ""
}

# Function to check security vulnerabilities
check_security_vulnerabilities() {
    echo "Checking for Security Vulnerabilities:"
    # Placeholder: Add actual security scan, for example, using OpenVAS or similar
    echo "Run security scans (OpenVAS, Nmap, etc.) manually for detailed analysis."
    echo ""
}

# Function to check for index fragmentation
check_index_fragmentation() {
    echo "Checking for Index Fragmentation (MySQL Example):"
    mysql -e "SELECT table_schema,table_name,round(data_length/1024/1024,2) as data_MB FROM information_schema.tables WHERE table_schema = 'your_database';"
    echo ""
}

# Display instructions
echo "RDBMS Monitoring Script"
echo "Press [CTRL+C] to stop monitoring."
echo "------------------------------------"
echo ""

# Continuous monitoring loop
while true; do
    check_disk_space
    check_cpu_usage
    check_memory_usage
    check_slow_queries
    check_connections
    check_data_corruption
    check_deadlocks
    check_backup
    check_replication_status
    check_security_vulnerabilities
    check_index_fragmentation
    sleep 10
done
