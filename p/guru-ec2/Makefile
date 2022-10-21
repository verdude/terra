config := yea
init := echo

ifneq ($(init),echo)
override init := terraform
endif

.PHONY: all
apply:
	$(init) init
	terraform apply --auto-approve
ifdef config
	$(MAKE) config_ssh
endif

.PHONY: config_ssh
config_ssh:
	expect scripts/expect.exp

.PHONY: kill
kill:
	terraform destroy
	rm -f terraform*

.PHONY: clean
clean:
	rm -f terraform*
