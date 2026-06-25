local home = os.getenv("HOME")

hl.on("hyprland.start", function()
    hl.exec_cmd(home .. "/.config/hypr/initial-boot.sh")
end)

hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- Sourcing external config files
require("configs/Keybinds") -- Pre-configured keybinds

-- ## This is where you want to start tinkering 

require("configs/StartupApps") -- put your start-up packages on this file

require("configs/EnvVariables") -- Environment variables to load

--require("configs/Monitors") -- Its all about your monitor config
--require("configs/WorkspaceRules") -- Hyprland workspaces

require("configs/Laptops") -- For laptop related

require("configs/LaptopDisplay") -- Laptop display related. You need to read the comment on this file

require("configs/WindowRules") -- all about Hyprland Window Rules and Layer Rules

require("configs/Decorations") -- Decorations config file

require("configs/Animations") -- Animation config file

require("configs/Settings") -- Main Hyprland Settings.

require("configs/Defaults") -- settings for User defaults apps

require("configs/Plugins")

-- nwg-displays
require("monitors")
require("workspaces")

require("hyprland-gui")
