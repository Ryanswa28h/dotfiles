-- This is a file where you put your own default apps, default search Engine etc

-- Set your default editor here uncomment and reboot to take effect.
-- NOTE, this will be automatically uncommented if you select neovim or vim to your default editor
--hl.env("EDITOR", "vim") --default editor

-- Define preferred text editor for the Quick Settings Menu (SUPER SHIFT E)
-- script will take the default EDITOR and nano as fallback
local edit = (os.getenv("EDITOR") or "neovim") .. "ss"

-- These two are for Keybinds.lua & Waybar Modules
local term = "kitty" -- Terminal
local files = "thunar"

-- Default Search Engine for ROFI Search (SUPER S)
local Search_Engine = "https://search.brave.com/search?q={}"
