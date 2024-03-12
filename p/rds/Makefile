config := yea
init := echo
pdir := $(shell pwd)
approve := -auto-approve
username :=
wait := please

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
	cd ../../ && expect scripts/expect.exp $(pdir) $(wait)

.PHONY: config-server
config-server:
ifdef username
	ssh defub 'git clone --depth 1 https://github.com/verdude/random && random/setup.sh -zebg sudo -u $(username)'
endif


.PHONY: kill
kill:
	terraform destroy -auto-approve
	rm -f terraform*

.PHONY: clean
clean:
	rm -rf .terraform*
