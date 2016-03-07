------------------------------------------------------------
-- openSUSE awesome theme based on awesome default theme --
------------------------------------------------------------

theme = {}

theme.font          = "sans 9"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#62a541"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/taglist/squarefw.png"
theme.taglist_squares_unsel = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/taglist/squarew.png"

theme.tasklist_floating_icon = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "nitrogen --set-scaled /home/Frazer/.config/awesome/Themes/TomorrowNightBrightTheme/background.png" }

-- You can use your own layout icons like this:
theme.layout_fairh = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/fairhw.png"
theme.layout_fairv = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/fairvw.png"
theme.layout_floating  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/floatingw.png"
theme.layout_magnifier = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/magnifierw.png"
theme.layout_max = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/maxw.png"
theme.layout_fullscreen = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/fullscreenw.png"
theme.layout_tilebottom = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/tilebottomw.png"
theme.layout_tileleft   = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/tileleftw.png"
theme.layout_tile = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/tilew.png"
theme.layout_tiletop = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/tiletopw.png"
theme.layout_spiral  = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/spiralw.png"
theme.layout_dwindle = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/layouts/dwindlew.png"

theme.awesome_icon = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/usr/share/awesome/icons/awesome16.png"
theme.opensuse_icon = "/home/Frazer/.config/awesome/themes/TomorrowNightBrightTheme/opensusegeeko.png"
return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
