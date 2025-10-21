SHELLCHECK_SRCS := forgeup forgeup_lib.sh $(shell find lib -name '*.sh') $(shell find config -name '*.conf')

lint:
	@shellcheck $(SHELLCHECK_SRCS)

test:
	@echo "No tests defined."

.PHONY: lint test
