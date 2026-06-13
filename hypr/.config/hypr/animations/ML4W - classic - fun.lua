--
-- name "Classic"
-- credit https://github.com/mylinuxforwork/dotfiles

hl.config({
    animations = {
        enabled = true,
    },
})

-- ---- Beziers ----
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("slow",     { type = "bezier", points = { { 0.0, 0.85 }, { 0.3, 1.0 } } })
hl.curve("winOut",   { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })

-- ---- Animations ----
hl.animation({ leaf = "windows",       enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 7,  bezier = "winOut",   style = "popin 80%" })
hl.animation({ leaf = "border",        enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle",   enabled = true, speed = 100,bezier = "linear",   style = "loop" }) -- needed for rainbow borders rotation
hl.animation({ leaf = "fade",          enabled = true, speed = 7,  bezier = "slow" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 6,  bezier = "myBezier" })
