
.PHONY: sync-local
sync-local:
	@echo "Syncing Neovim plugins (update, clean)..."
	nvim --headless -c "autocmd User MiniDepsAllLaterLoaded ++once lua vim.cmd('DepsUpdate'); vim.cmd('DepsClean!'); vim.cmd('qa!')" > /dev/null

.PHONY: sync-remote
sync-remote: sync-local
	@if [ -z "$(REMOTE)" ]; then \
	  echo "Error: REMOTE must be set!"; exit 1; \
	fi
	@echo "Syncing Neovim config to remote with rsync..."
	rsync -av --delete --exclude='*/.git/' --exclude='.git/' ~/.config/nvim/ $(REMOTE):~/.config/nvim/
