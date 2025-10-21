.PHONY: deps-sync package send deploy clean

CONFIG_PATH = .config/nvim
TARBALL = nvim-offline.tar.gz

deps-sync:
	@echo "Syncing MiniDeps plugins (update, clean, quit)..."
	nvim --headless -c 'autocmd User MiniDepsAllLaterLoaded ++once lua vim.cmd("DepsUpdate"); vim.cmd("DepsClean!"); vim.cmd("qa!")' > /dev/null

package: deps-sync
	@echo "Packaging Neovim config and plugins (excluding .git folders)..."
	tar czf /tmp/$(TARBALL) --exclude='.git' --exclude='.git/*' -C $(HOME)/$(CONFIG_PATH) .

send: package
	@if [ -z "$(REMOTE_ADDR)" ]; then \
	  echo "Error: REMOTE_ADDR must be set!"; exit 1; \
	fi
	@echo "Sending tarball to remote server..."
	scp $(TARBALL) $(REMOTE_ADDR):$(CONFIG_PATH)/$(TARBALL)

deploy: send
	@echo "Untarring on remote server..."
	ssh $(REMOTE_ADDR) "cd .config/nvim && tar xzf $(TARBALL)"
