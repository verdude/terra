config := yea
init := echo
username :=

ifneq ($(init),echo)
override init := terraform
endif

.PHONY: all
apply:
	$(init) init
	terraform apply --auto-approve
ifdef config
	$(MAKE) config-ssh
endif

.PHONY: config-ssh
config-ssh:
	expect scripts/expect.exp

.PHONY: config-server
config-server:
ifdef username
	ssh gurub 'git clone --depth 1 https://github.com/verdude/random && random/setup.sh -zebg sudo -u $(username)'
endif

.PHONY: kill
kill:
	terraform destroy
	rm -f terraform*

.PHONY: clean
clean:
	rm -f terraform*
