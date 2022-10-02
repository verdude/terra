.PHONY: all
apply:
	terraform apply
	$(MAKE) config_ssh

.PHONY: config_ssh
config_ssh:
	bash scripts/config_ssh.sh -w

