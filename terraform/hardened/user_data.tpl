#!/usr/bin/env bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# Enable SSM
if [  "${ssm_enabled}" = "true" ]
then
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    systemctl status amazon-ssm-agent
else
    systemctl disable amazon-ssm-agent
    systemctl stop amazon-ssm-agent
    systemctl status amazon-ssm-agent
fi

${user_data}
