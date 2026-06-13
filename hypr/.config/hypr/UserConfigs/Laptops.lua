-- See https://wiki.hypr.land/Configuring/Keywords/ for more variable settings
-- These configs are mostly for laptops. This is addemdum to Keybinds.conf

local home = os.getenv("HOME")
local mainMod = "SUPER"
local scriptsDir = home .. "/.config/hypr/scripts"
local UserConfigs = home .. "/.config/hypr/UserConfigs"

-- for disabling Touchpad. hyprctl devices to get device name.
local Touchpad_Device = "asue1209:00-04f3:319f-touchpad"

hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --dec"), { repeating = true, locked = true }) -- decrease keyboard brightness
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --inc"), { repeating = true, locked = true }) -- increase keyboard brightness
hl.bind("XF86Launch1", hl.dsp.exec_cmd("rog-control-center")) -- ASUS Armory crate button
hl.bind("XF86Launch3", hl.dsp.exec_cmd("asusctl led-mode -n")) -- FN+F4 Switch keyboard RGB profile
hl.bind("XF86Launch4", hl.dsp.exec_cmd("asusctl profile -n")) -- FN+F5 change of fan profiles (Quite, Balance, Performance)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --dec"), { repeating = true, locked = true }) -- decrease monitor brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --inc"), { repeating = true, locked = true }) -- increase monitor brightness
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd(scriptsDir .. "/TouchPad.sh")) -- disable touchpad

-- Screenshot keybindings using F6 (no PrinSrc button)
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --now")) -- screenshot
hl.bind(mainMod .. " + SHIFT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --area")) -- screenshot (area)
hl.bind(mainMod .. " + CTRL + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in5")) -- screenshot (5 secs delay)
hl.bind(mainMod .. " + ALT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in10")) -- screenshot (10 secs delay)
hl.bind("ALT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --active")) -- screenshot (active window only)

local TOUCHPAD_ENABLED = true
hl.device({
    name = Touchpad_Device,
    enabled = TOUCHPAD_ENABLED,
})
-- Below are useful when you are connecting your laptop in external display
-- Suggest you edit below for your laptop display
-- From WIKI This is to disable laptop monitor when lid is closed.
-- consult https://wiki.hyprland.org/hyprland-wiki/pages/Configuring/Binds/#switches
--hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl keyword monitor \"eDP-1, preferred, auto, 1\""), { locked = true })
--hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl keyword monitor \"eDP-1, disable\""), { locked = true })


-- WARNING! Using this method has some caveats!! USE THIS PART WITH SOME CAUTION!
-- CONS of doing this, is that you need to set up your wallpaper (SUPER W) and choose wallpaper.
-- CAVEATS! Sometimes the Main Laptop Monitor DOES NOT have display that it needs to re-connect your external monitor
-- One work around is to ensure that before shutting down laptop, MAKE SURE your laptop lid is OPEN!!
-- Make sure to comment (put # on the both the bindl = , switch ......) above
-- NOTE: Display for laptop are being generated into LaptopDisplay.conf
-- This part is to be use if you do not want your main laptop monitor to wake up during say wallpaper change etc

--hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("echo \"monitor = eDP-1, preferred, auto, 1\" > " .. UserConfigs .. "/LaptopDisplay.conf"), { locked = true })
--hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("echo \"monitor = eDP-1, disable\" > " .. UserConfigs .. "/LaptopDisplay.conf"), { locked = true })

-- for laptop-lid action (to erase the last entry)
--hl.on("hyprland.start", function()
--    hl.exec_cmd("echo \"monitor = eDP-1, preferred, auto, 1\" > " .. home .. "/.config/hypr/UserConfigs/LaptopDisplay.conf")
--end)
