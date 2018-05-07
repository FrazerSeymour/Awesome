theme = {}

theme.font          = "SourceSansPro 11"

theme.bg_normal     = "#000000"
theme.bg_inactive   = "#2a2a2a"
theme.bg_focus      = "#4a4a4a"
theme.bg_urgent     = "#d54e53"
theme.bg_minimize   = theme.bg_normal

theme.fg_normal     = "#969896"
theme.fg_focus      = "#eaeaea"
theme.fg_urgent     = theme.fg_focus
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 1
theme.border_normal = theme.bg_normal
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.taglist_bg_normal = theme.bg_inactive
theme.tasklist_bg_normal = theme.bg_inactive

theme.accents = {"#d54e53", "#e78c45", "#e7c547", "#b9ca4a", "#70c0b1", "#7aa6da", "#c397db"}
theme.icon_theme = "Vertex-Icons"
theme.wallpaper = "~/.config/awesome/themes/frazer/background.png"

theme.wibox_height = 20

theme.naughty_position = "bottom_right"
theme.naughty_margin = 20
theme.naughty_icon_size = 48
theme.naughty_height = 88
theme.naughty_width = 500
theme.naughty_opacity = 0.80

-- Display the taglist squares
theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

-- You can use your own layout icons like this:
theme.layout_fairh = "/usr/share/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv = "/usr/share/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating  = "/usr/share/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max = "/usr/share/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "/usr/share/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral  = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
