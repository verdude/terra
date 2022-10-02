p := ec2

.PHONY: plan
plan:
	$(MAKE) -C p/$(p) plan p=$(p)

.PHONY: apply
apply:
	$(MAKE) -C p/$(p) apply $(p)

.PHONY: lambda
lambda:
	$(MAKE) -C p/$(p) apply $(p)

.PHONY: clean
clean:
	rm -f terraform*

.PHONY: kill
kill:
	terraform destroy
	rm -f terraform*
