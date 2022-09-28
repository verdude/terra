.PHONY: plan
plan:
	terraform plan -out terraform-plan.txt

.PHONY: apply
apply:
	terraform apply
	$(MAKE) config_ssh

.PHONY: config_ssh
config_ssh:
	bash scripts/config_ssh.sh -w

.PHONY: clean
clean:
	rm -f terraform*
