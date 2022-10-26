all:
	terraform apply

clean:
	rm -f terraform*

.PHONY: config_ssh
config-ssh:
	../guru-ec2/scripts/config_ssh.sh -s $$PWD -p "# guru-eb$$" -u "ec2-user"
