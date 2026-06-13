local home = os.getenv("HOME")

hl.on("hyprland.start", function()
    hl.exec_cmd(home .. "/.config/hypr/initial-boot.sh")
end)

hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- Sourcing external config files
require("configs/Keybinds") -- Pre-configured keybinds

-- ## This is where you want to start tinkering 

require("UserConfigs/Startup_Apps") -- put your start-up packages on this file

require("UserConfigs/ENVariables") -- Environment variables to load

--require("UserConfigs/Monitors") -- Its all about your monitor config (old dots) will remove on push to main
--require("UserConfigs/WorkspaceRules") -- Hyprland workspaces (old dots) will remove on push to main

require("UserConfigs/Laptops") -- For laptop related

require("UserConfigs/LaptopDisplay") -- Laptop display related. You need to read the comment on this file

require("UserConfigs/WindowRules") -- all about Hyprland Window Rules and Layer Rules

require("UserConfigs/UserDecorations") -- Decorations config file

require("UserConfigs/UserAnimations") -- Animation config file

require("UserConfigs/UserKeybinds") -- Put your own keybinds here

require("UserConfigs/UserSettings") -- Main Hyprland Settings.

require("UserConfigs/01-UserDefaults") -- settings for User defaults apps

require("UserConfigs/UserPlugins")

-- nwg-displays
require("monitors")
require("workspaces")

require("hyprland-gui")
