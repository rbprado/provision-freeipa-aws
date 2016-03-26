#!/bin/bash

# It looks there is a bug at the freeipa installation.
# After some tries the installation goes fine.
# So to automatize it, I`ve made this bash script.

counter=0

while true; do
    echo "=================="
    date
    echo "Installing try: " $counter
    echo "=================="

    ipa-server-install -p {{ freeipa_pass }} -a {{ freeipa_pass }} --hostname {{ aws_public_dns.stdout }} -n {{ freeipa_domain }} -r {{ freeipa_realm }} --ip-address {{ ansible_default_ipv4.address }} -U

    if [ $? -eq 0 ]; then
        echo "=================="
        date
        echo "Finally installed after: $counter retries"
        echo "Please try access freeipa through: http://$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)/"
        echo "=================="
        exit 0
    else
        echo "=================="
        echo "Uninstalling"
        echo "=================="
        ipa-server-install --uninstall -U
    fi

    ((counter++))

done    