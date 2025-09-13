# nvim-config

My preferred Neovim configuration, for neovim 0.11!


1. **Clone this repo into your Neovim config directory:**
   ```sh
   git clone https://github.com/ToonBettens/nvim-config ~/.config/nvim
   ```

2. **Open Neovim:**
   Plugins should install automatically on the first launch.

3. **Check health & debug dependencies:**
   Open Neovim and run: `checkhealth`
   This will highlight any missing requirements or issues (eg rg, fd, ...).

## Planned / To-Do

- Switch to the built-in package manager (`vim.pack`) after Neovim v0.12 is stable
- Try out the built-in completion engine when released
- Replace `mini.start` with `snack.dashboard`
- Improve terminal integration
- Set up a proper git workflow
- Add pickers for switching colorschemes and projects
- Create a minimal/portable config branch (`cfg`) for no-internet or reduced setup (no LSP, no AI, etc.)

