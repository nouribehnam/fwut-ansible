#!/bin/bash
config_dir=/opt/firewall

for i in $(find "${config_dir}/helpers" -type f -iname "*.func"  | sort); do
        . "$i"
done

function clean {
        echo "Cleaning v4 rules ..."
        iptables-restore < ${config_dir}/rules/clean.rules
        echo "Cleaning v6 rules ..."
        ip6tables-restore < ${config_dir}/rules/cleanv6.rules
        echo "Cleaning sets ..."
        ipset flush
        for i in $(ipset list | grep Name | awk '{print $2}'); do ipset destroy $i; done
}

function __apply_ipsets {
        rc=0
        for i in $(find ${config_dir} -type f -iname "*.ipset" | sort); do
                echo "Applying $i ..."
                ipset restore -! -file $i
                if [ $? -ne 0 ]; then
                        rc=-1
                fi
        done
        return $rc
}

function __apply_iptables {
        rc=0
        for i in $(find ${config_dir} -type f -iname "*.v4.rules" | sort); do
                echo "Applying $i ..."
                iptables-restore -n < $i
                if [ $? -ne 0 ]; then
                        rc=-1
                fi
        done
        for i in $(find ${config_dir} -type f -iname "*.v6.rules" | sort); do
                echo "Applying $i ..."
                ip6tables-restore -n < $i
                if [ $? -ne 0 ]; then
                        rc=-1
                fi
        done

        return $rc
}

function __apply {
        __apply_ipsets
        __apply_iptables
}

function check {
       __apply_ipsets
        ts=0
        for i in $(find "${config_dir}" -type f -iname "*.v4.rules" | sort); do
                echo -n "checking $i ..."
                iptables-restore --test < $i
                rc=$?
                if [ $rc -ne 0 ]; then
                        ts=-1
                        echo Failed
                else
                        echo Ok
                fi
                
        done
        for i in $(find ${config_dir} -type f -iname "*.v6.rules" | sort); do
                echo -n "Checking $i ..."
                ip6tables-restore --test < $i
                rc=$?
                if [ $rc -ne 0 ]; then
                        ts=-1
                        echo Failed
                else
                        echo Ok
                fi
        done
        if [ $ts -ne 0 ]; then
                echo "Failed to validate firewall rules!"
                exit $ts
        else
                echo "All rules validated."
                exit 0
        fi
}

function reload {
        apply
}

function restart {
        apply
}

function start {
        apply
}

function apply {
        clean
        __apply
}

function stop {
        clean
}

function status {
    flags="-L -nvx --line-numbers"
    # VERBOSE=1
    if [ -z "$table" ]; then
        for table in $tables; do
            s2_log -f
            echo -e "$table Table"
            s3_log -f
            $IPT46 $flags -t $table
        done
        s2_log -f
        echo -e "IP Sets"
        s3_log -f
        ipset -L
    else
        $IPT46 $flags -t $table
    fi
}

if [ -z "$1" ]; then
        echo "You should specify an action {start|stop|check|status}"
else
        $1
fi
