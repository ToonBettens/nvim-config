
.PHONY: clean-deps
clean-deps:
	@echo "Removing all embedded .git folders from deps/ ..."
	@find deps/ -type d -name ".git" | while read gitdir; do \
		echo "Removing: $$gitdir"; \
		rm -rf "$$gitdir"; \
	done
	@echo "All .git folders removed from deps/"
