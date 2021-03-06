-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")

local menubar = require("menubar")

-- Streetturtle Plugins
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}



-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/frazer/theme.lua")
naughty.config.defaults.position = beautiful.naughty_position
naughty.config.defaults.margin = beautiful.naughty_margin
naughty.config.defaults.height = beautiful.naughty_height
naughty.config.defaults.width = beautiful.naughty_width
naughty.config.defaults.icon_size = beautiful.naughty_icon_size
naughty.config.presets.low.opacity = beautiful.naughty_opacity
naughty.config.presets.normal.opacity = beautiful.naughty_opacity
naughty.config.presets.critical.opacity = beautiful.naughty_opacity

-- Compilation will fail if I remove one of these, instead of using
-- magic strings.
TAGNAME_MAIN = "main"
TAGNAME_VIM = "vim"
TAGNAME_WEB = "web"
TAGNAME_TALK = "talk"
TAGNAME_SPARE = "spare"

volume_replace = 0
display_volume = function(arg)
    volume = io.popen("amixer sget Master | awk -F'[][]' '/dB/ { print \"Volume: \" $".. arg .." }'"):read()
    naughty.notify({ title = "ALSA",
                     text = volume,
                     icon = "/usr/share/icons/Vertex-Icons/apps/48/multimedia-volume-control.svg",
                     replaces_id = volume_replace})
end
brightness_replace = 1
display_brightness = function()
    brightness = io.popen("xbacklight -get | awk '{ printf \"Brightness: %.0f%%\", $0 }'"):read()
    naughty.notify({ title = "xbacklight",
                     text = brightness,
                     icon = "/usr/share/icons/Vertex-Icons/status/symbolic/display-brightness-symbolic.svg",
                     replaces_id = brightness_replace})
end


-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or os.getenv("VISUAL") or "gvim"
editor_cmd = terminal .. " -e " .. editor

-- Run scripts
run = awful.util.getdir("config") .. "/run "
run_once = awful.util.getdir("config") .. "/run_once "

-- Startups
--awful.util.spawn_with_shell(run_once .. "xscreensaver -no-splash &")
awful.util.spawn_with_shell(run_once .. "wicd-client -t &")

-- Default modkey.
modkey = "Mod4"

-- Query icons to speed up first menubar run.
menubar.menu_gen.lookup_category_icons = function() end

-- Table with my two most used layouts, spiral and max.
minlayouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max
}

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.magnifier
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tagDefinitions = {
    names  = {TAGNAME_MAIN, TAGNAME_VIM, TAGNAME_WEB, TAGNAME_TALK, TAGNAME_SPARE},
    layouts = {minlayouts[1], minlayouts[2], minlayouts[2], minlayouts[2], minlayouts[1]}
}
-- First three tags go on first screen.
for t = 1,3 do
    awful.tag.add(tagDefinitions.names[t], {
        layout      = tagDefinitions.layouts[t],
        screen      = 1,
        selected    = (t == 1)
    })
end
-- Last two tags go on last screen, if present.
-- location == 2 if number of screens is even, 1 if odd. Doesn't scale beyond two monitors.
local location = 2 - (screen.count() % 2)
for t = 4,5 do
    awful.tag.add(tagDefinitions.names[t], {
        layout      = tagDefinitions.layouts[t],
        screen      = location,
        selected    = (location == 2 and t == 4)
    })
end
tagTable = {
    [TAGNAME_MAIN] = awful.tag.find_by_name(nil, TAGNAME_MAIN),
    [TAGNAME_VIM] = awful.tag.find_by_name(nil, TAGNAME_VIM),
    [TAGNAME_WEB] = awful.tag.find_by_name(nil, TAGNAME_WEB),
    [TAGNAME_TALK] = awful.tag.find_by_name(nil, TAGNAME_TALK),
    [TAGNAME_SPARE] = awful.tag.find_by_name(nil, TAGNAME_SPARE),
}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = beautiful.wibox_height })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(ram_widget)
    right_layout:add(cpu_widget)
    right_layout:add(volume_widget)
    right_layout:add(battery_widget)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Custom Bindings
    awful.key({ modkey, "Shift"   },  "q",  function ()
                                                awful.util.spawn_with_shell(run .. "systemctl suspend-then-hibernate")
                                            end),

    awful.key({ modkey,           },  "v",  function ()
                                                awful.util.spawn_with_shell(run .. "gvim")
                                                awful.tag.viewonly(tagTable[TAGNAME_VIM])
                                            end),
    awful.key({ modkey,           },  "b",  function ()
                                                awful.util.spawn_with_shell(run .. "google-chrome-stable")
                                                awful.tag.viewonly(tagTable[TAGNAME_WEB])
                                            end),
    awful.key({ modkey, "Shift"   },  "b",  function ()
                                                awful.util.spawn_with_shell(run .. "google-chrome-stable --incognito")
                                                awful.tag.viewonly(tagTable[TAGNAME_WEB])
                                            end),

    awful.key({ modkey, "Shift"   },  "Tab",    function ()
                                                    awful.client.focus.byidx(-1)
                                                    if client.focus then client.focus:raise() end
                                                end),
    awful.key({                   },  "Print",  function ()
                                                    awful.util.spawn_with_shell(run .. "shutter --full --remove_cursor --exit_after_capture --no_session")
                                                end),
    awful.key({ modkey            },  "Print",  function ()
                                                    awful.util.spawn_with_shell(run .. "shutter --select  --remove_cursor --exit_after_capture --no_session")
                                                end),
    awful.key({                   },  "XF86Calculator", function ()
                                                            awful.util.spawn_with_shell(run .. "galculator")
                                                        end),
    awful.key({                   },  "XF86MonBrightnessUp", function ()
                                                            awful.util.spawn_with_shell(run .. "xbacklight -inc 7.5")
                                                            display_brightness()
                                                        end),
    awful.key({                   },  "XF86MonBrightnessDown", function ()
                                                            awful.util.spawn_with_shell(run .. "xbacklight -dec 7.5")
                                                            display_brightness()
                                                        end),
    awful.key({                   },  "XF86AudioRaiseVolume", function ()
                                                            awful.util.spawn_with_shell(run .. "amixer set Master 7.5%+")
                                                            display_volume("2")
                                                        end),
    awful.key({                   },  "XF86AudioLowerVolume", function ()
                                                            awful.util.spawn_with_shell(run .. "amixer set Master 7.5%-")
                                                            display_volume("2")
                                                        end),
    awful.key({                   },  "XF86AudioMute", function ()
                                                            awful.util.spawn_with_shell(run .. "amixer set Master toggle")
                                                            display_volume("5")
                                                        end),
    
    -- Global Keys
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn_with_shell(run .. terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(minlayouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, 1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Menubar
    awful.key({ modkey }, "r", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.find_by_name(nil, tagDefinitions.names[i])
                      if tag then
                          awful.tag.viewonly(tag)
                      end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.find_by_name(nil, tagDefinitions.names[i])
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.find_by_name(nil, tagDefinitions.names[i])
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    
    { rule = { instance = "exe" }, -- Changed to "exe" from "plugin-container"
        properties = { floating = true } },
    { rule = { class = "pinentry" },
        properties = { floating = true } },
    { rule = { class = "galculator" },
        properties = { floating = true } },
    { rule = { class = "gimp" },
        properties = { floating = true } },
    { rule = { class = "Gvim" } ,
        properties = { tag = tagTable[TAGNAME_VIM] } },
    { rule = { class = "Chrome" },
        properties = { tag = tagTable[TAGNAME_WEB] } },
    { rule = { class = "Evolution" },
        properties = { tag = tagTable[TAGNAME_TALK] } },
    { rule = { class = "Slack" },
        properties = { tag = tagTable[TAGNAME_TALK] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

-- {{{ Accents
-- Contains the accent colour for each active client, indexed by PID.
accents = {}
client.connect_signal("new",    function(c)
                                    math.randomseed(os.date("%H%M%S"))
                                    num = math.random(7)
                                    accent = beautiful.accents[num]
                                    accents[c] = accent
                                end)
client.connect_signal("focus", function(c) c.border_color = accents[c] end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
