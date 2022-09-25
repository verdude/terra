.PHONY: plan
plan:
	terraform plan -out terraform-plan.txt

.PHONY: apply
apply:
	terraform apply
	$(MAKE) saveip

.PHONY: saveip
saveip:
	bash saveip.sh

.PHONY: clean
clean:
	rm -f terraform*
