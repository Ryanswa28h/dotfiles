hl.config({
	animations = {
		enabled = true,
	},
})

-- ---- Beziers ----
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.00 } } })
hl.curve("slow", { type = "bezier", points = { { 0.0, 0.85 }, { 0.3, 1.0 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })

-- ---- Animations ----
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "winOut", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" }) -- needed for rainbow borders rotation
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "slow" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "myBezier", style = "slide" })

-- Layer / popup animations (covers rofi menus, notifications, etc.)
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "default", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 4, bezier = "default" })
