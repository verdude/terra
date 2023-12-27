config := yea
init := echo
pdir := $(shell pwd)
approve := -auto-approve

ifneq ($(init),echo)
override init := terraform
endif

.PHONY: all
all:
	$(init) init
	terraform apply $(approve)
ifdef config
	$(MAKE) config-ssh
endif

.PHONY: config-ssh
config-ssh:
	cd ../../ && expect scripts/expect.exp $(pdir) please-wait

.PHONY: kill
kill:
	terraform destroy -auto-approve
	rm -f terraform*
