config := yea
init := echo

ifneq ($(init),echo)
override init := terraform
endif

.PHONY: all
all:
	$(init) init
	terraform apply
ifdef config
	$(MAKE) config_ssh
endif

.PHONY: config_ssh
config_ssh:
	bash scripts/config_ssh.sh -w

.PHONY: kill
kill:
	terraform destroy
	rm -f terraform*
