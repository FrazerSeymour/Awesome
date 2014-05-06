--  rc.lua
--  custom initialization for awesome windowmanager 3.4.13



-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")

--require("tyrannical")

-- Theme handling library
require("beautiful")

-- Notification library
require("naughty")

-- Freedesktop integration
-- FIXME for 3,5 since freedesktop is not compatabible
require("freedesktop.utils")
require("freedesktop.menu")
require("freedesktop.desktop")


-- use local keyword for awesome 3.5 compatability
-- calendar functions
local calendar2 = require("calendar2")
-- Extra widgets
local vicious = require("vicious")
-- to create shortcuts help screen
local keydoc = require("keydoc")


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
    awesome.add_signal("debug::error", function (err)
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
-- Themes define colours, icons, and wallpapers
-- Use personal theme if existing else goto default
do
    local user_theme, ut
    user_theme = awful.util.getdir("config") .. "/themes/theme.lua"
    ut = io.open(user_theme)
    if ut then
        io.close(ut)
        beautiful.init(user_theme)
    else
        print("Personal theme doesn't exist, falling back to openSUSE")
        beautiful.init("/usr/share/awesome/themes/openSUSE/theme.lua")
    end
end

awful.util.spawn_with_shell("xcompmgr -cF &")
awful.util.spawn_with_shell("wuala &")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or os.getenv("VISUAL") or "gvim"
editor_cmd = terminal .. " -e " .. editor

freedesktop.utils.terminal = terminal
freedesktop.utils.icon_theme = 'gnome'

-- Default modkey.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}



-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    names  = {"main", "vim", "web", "mail", "spare"},
    layout = {layouts[4], layouts[5], layouts[5],
            layouts[5], layouts[4]}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end


-- }}}


-- {{{ Accents
-- Contains the accent colour for each active client, indexed by PID.
accents = {}
-- }}}


-- {{{ Menu
-- Create a launcher widget and a main menu


top_menu = {
    { 'Applications',   	freedesktop.menu.new(),     			freedesktop.utils.lookup_icon({ icon = 'start-here' })  },
    { 'Logout',           	awesome.quit,                 			freedesktop.utils.lookup_icon({ icon = 'system-log-out'     }) },
    { 'Reboot System',   	'sudo /sbin/reboot', 		            freedesktop.utils.lookup_icon({ icon = 'reboot-notifier'    }) },
    { 'Shutdown System', 	'sudo /sbin/shutdown now --no-wall', 	freedesktop.utils.lookup_icon({ icon = 'system-shutdown'    }) }
}

mymainmenu = awful.menu.new({ items = top_menu, width = 150 })


mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu = mymainmenu })
-- }}}



-- desktop icons
for s = 1, screen.count() do
    freedesktop.desktop.add_applications_icons({screen = s, showlabels = true})
    freedesktop.desktop.add_dirs_and_files_icons({screen = s, showlabels = true})
end



-- {{{ Wibox
-- We need spacer and separator between the widgets
spacer = widget({type = "textbox"})
separator = widget({type = "textbox"})
spacer.text = " "
separator.text = "|"


-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

calendar2.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")

-- Create a systray
mysystray = widget({ type = "systray" })

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
                    awful.button({ }, 4, awful.tag.viewprev),
                    awful.button({ }, 5, awful.tag.viewnext)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ },   1,  function (c)
                                if c == client.focus then
                                    c.minimized = true
                                else
                                    if not c:isvisible() then
                                        awful.tag.viewonly(c:tags()[1])
                                    end
                                        -- This will also un-minimize
                                        -- the client, if needed
                                        client.focus = c
                                        c:raise()
                                end
                            end),
    awful.button({ },   3,  function ()
                                if instance then
                                    instance:hide()
                                    instance = nil
                                else
                                    instance = awful.menu.clients({ width=250 })
                                end
                            end),
    awful.button({ },   4,  function ()
                                 awful.client.focus.byidx(-1)
                                 if client.focus then client.focus:raise() end
                            end),
    awful.button({ },   5,  function ()
                                 awful.client.focus.byidx(1)
                                 if client.focus then client.focus:raise() end
                            end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)


    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],

        mytextclock,
        --separator,
        spacer,

        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}



-- these are needed by the keydoc a better solution would be to place them in theme.lua
-- but leaving them here also provides a mean to change the colors here ;)
beautiful.fg_widget_value="green"
beautiful.fg_widget_clock="gold"
beautiful.fg_widget_value_important="red"



-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}



-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Custom Bindings
    keydoc.group("Custom"),
    awful.key({ modkey,             },  "v",        function ()
                                                        awful.util.spawn("gvim")
                                                        awful.tag.viewonly(tags[1][2])
                                                    end,                                    "Open gVim"),
    awful.key({ modkey,             },  "b",        function ()
                                                        awful.util.spawn("chromium")
                                                        awful.tag.viewonly(tags[1][3])
                                                    end,                                    "Open Browser"),
    awful.key({ modkey, "Shift"     },  "b",        function ()
                                                        awful.util.spawn("chromium --incognito")
                                                        awful.tag.viewonly(tags[1][3])
                                                    end,                                    "Open Incognito Browser"),
    awful.key({ modkey, "Shift"     },  "p",        function ()
                                                        awful.util.spawn("kdocker -d60 -n \"KeePass\" keepass")
                                                    end,                                    "Open and Dock Password Keeper"),
    awful.key({ modkey,             },  "w",        function ()
                                                        awful.tag.viewonly(tags[1][5])
                                                        awful.util.spawn("plasma-windowed org.kde.networkmanagement")
                                                    end,                                    "Open NetworkManager"),

    awful.key({                     },  "Print",    function ()
                                                        awful.util.spawn("ksnapshot")
                                                    end,                                    "PrintScreen Functionality."),
    awful.key({                     },  "#133",     function ()
                                                        mymainmenu:toggle()
                                                    end,                                    "'Windows' key toggles launcher."),
    awful.key({                     },  "XF86Calculator",   function ()
                                                                awful.util.spawn("kcalc")
                                                            end,                            "Calculator key opens KCalc."),
    awful.key({ modkey, "Shift"     },  "Tab",      function ()
                                                        awful.client.focus.byidx(-1)
                                                        if client.focus then client.focus:raise() end
                                                    end,                                    "Moves focus to previous client in tag."),

    -- Global Keys
    keydoc.group("Global Keys"),
    awful.key({ modkey,             },  "Left",     awful.tag.viewprev,                     "Previous Tag" ),
    awful.key({ modkey,             },  "Right",    awful.tag.viewnext,                     "Next tag" ),
    awful.key({ modkey,             },  "Escape",   awful.tag.history.restore,              "Clear Choice"),
    awful.key({ modkey,             },  "F1",       keydoc.display,                         "Display Keymap Menu"),

    awful.key({ modkey,             },  "j",        function ()
                                                        awful.client.focus.byidx( -1)
                                                        if client.focus then client.focus:raise() end
                                                    end,                                    "Raise focus"),
    awful.key({ modkey,             },  "k",        function ()
                                                        awful.client.focus.byidx(1)
                                                        if client.focus then client.focus:raise() end
                                                    end,                                    "Lower focus"),


    -- Layout manipulation
    keydoc.group("Layout manipulation"),
    awful.key({ modkey, "Shift"     },  "j",        function () 
                                                        awful.client.swap.byidx(  1)    
                                                    end,                                    "Swap with next window"),
    awful.key({ modkey, "Shift"     },  "k",        function ()
                                                        awful.client.swap.byidx( -1)
                                                    end,                                    "Swap with previous window "),
    awful.key({ modkey, "Control"   },  "j",        function ()
                                                        awful.screen.focus_relative( 1)
                                                    end,                                    "Relative focus increase" ),
    awful.key({ modkey, "Control"   },  "k",        function ()
                                                        awful.screen.focus_relative(-1)
                                                    end,                                    "Relative focus decrease"),
    awful.key({ modkey,             },  "u",        awful.client.urgent.jumpto,             "Jump to window "),
    awful.key({ modkey,             },  "Tab",      function ()
                                                        awful.client.focus.history.previous()
                                                        if client.focus then
                                                            client.focus:raise()
                                                        end
                                                    end,                                    "Cycle windows or windows style"),


    -- Standard program
    keydoc.group("Standard Programs"),
    awful.key({ modkey,             },  "Return",   function ()
                                                        awful.util.spawn(terminal)
                                                    end,                                    "Open terminal"),
    awful.key({ modkey, "Control"   },  "r",        awesome.restart,                        "Restart awesome"),
    awful.key({ modkey, "Shift"     },  "q",        awesome.quit,                           "Quit awesome"),

    awful.key({ modkey,             },  "l",        function ()
                                                        awful.tag.incmwfact( 0.05)
                                                    end,                                    "Increase window size"),
    awful.key({ modkey,             },  "h",        function () 
                                                        awful.tag.incmwfact(-0.05)
                                                    end,                                    "Decrease window size"),
    awful.key({ modkey, "Shift"     },  "h",        function () 
                                                        awful.tag.incnmaster( 1)
                                                    end,                                    "Increase master"),
    awful.key({ modkey, "Shift"     },  "l",        function () 
                                                        awful.tag.incnmaster(-1)
                                                    end,                                    "Decrease master"),
    awful.key({ modkey, "Control"   },  "h",        function ()
                                                        awful.tag.incncol( 1)
                                                    end,                                    "Increase column"),
    awful.key({ modkey, "Control"   },  "l",        function ()
                                                        awful.tag.incncol(-1)
                                                    end,                                    "Decrease column"),
    awful.key({ modkey,             },  "space",    function ()
                                                        awful.layout.inc(layouts,  1)
                                                    end,                                    "Cycle layout style forward"),
    awful.key({ modkey, "Shift"     },  "space",    function ()
                                                        awful.layout.inc(layouts, -1)
                                                    end,                                    "Cycle layout style reverse"),

    awful.key({ modkey, "Control"   },  "n",        awful.client.restore,                   "Client restore"),


    -- Prompt
    awful.key({ modkey              },  "r",        function ()
                                                        mypromptbox[mouse.screen]:run()
                                                    end,                                    "Run command"),

    -- this function below will enable ssh login as long as the remote host is defined in $HOME/.ssh/config
    -- else by give the remote host name at the prompt which will also work
    awful.key({ modkey,             },  "s",
              function ()
                  awful.prompt.run({ prompt = "ssh: " },
                  mypromptbox[mouse.screen].widget,
                  function(h) awful.util.spawn(terminal .. " -e slogin " .. h) end,
                  function(cmd, cur_pos, ncomp)
                      -- get hosts and hostnames
                      local hosts = {}
                      f = io.popen("sed 's/#.*//;/[ \\t]*Host\\(Name\\)\\?[ \\t]\\+/!d;s///;/[*?]/d' " .. os.getenv("HOME") .. "/.ssh/config | sort")
                      for host in f:lines() do
                          table.insert(hosts, host)
                      end
                      f:close()
                      -- abort completion under certain circumstances
                      if cur_pos ~= #cmd + 1 and cmd:sub(cur_pos, cur_pos) ~= " " then
                          return cmd, cur_pos
                      end
                      -- match
                      local matches = {}
                      table.foreach(hosts, function(x)
                          if hosts[x]:find("^" .. cmd:sub(1, cur_pos):gsub('[-]', '[-]')) then
                              table.insert(matches, hosts[x])
                          end
                      end)
                      -- if there are no matches
                      if #matches == 0 then
                          return cmd, cur_pos
                      end
                      -- cycle
                      while ncomp > #matches do
                          ncomp = ncomp - #matches
                      end
                      -- return match and position
                      return matches[ncomp], #matches[ncomp] + 1
                  end,
                  awful.util.getdir("cache") .. "/ssh_history")
              end,                                                                          "SSH login"),

    awful.key({ modkey              },  "x",        function ()
                                                        awful.prompt.run({ prompt = "Run Lua code: " },
                                                        mypromptbox[mouse.screen].widget,
                                                        awful.util.eval, nil,
                                                        awful.util.getdir("cache") .. "/history_eval")
                                                    end,                                    "Run lua command")
)



clientkeys = awful.util.table.join(
    keydoc.group("Window management"),
    awful.key({ modkey,             },  "f",        function (c)
                                                        c.fullscreen = not c.fullscreen
                                                    end,                                    "Toggle fullscreen"),
    awful.key({ modkey, "Shift"     },  "c",        function (c) 
                                                        c:kill()
                                                    end,                                    "Kill window"),
    awful.key({ modkey, "Control"   },  "space",    awful.client.floating.toggle,           "Toggle floating"),
    awful.key({ modkey, "Control"   },  "Return",   function (c)
                                                        c:swap(awful.client.getmaster())
                                                    end,                                    "Swap to master"),
    awful.key({ modkey,             },  "o",        awful.client.movetoscreen,              "Move to screen" ),
    awful.key({ modkey, "Shift"     },  "r",        function (c)
                                                        c:redraw()
                                                    end,                                    "redraw window"),
    awful.key({ modkey,             },  "t",        function (c)
                                                        c.ontop = not c.ontop
                                                    end),
    awful.key({ modkey,             },  "n",        function (c)
                                                        -- The client currently has the input focus, so it cannot be
                                                        -- minimized, since minimized clients can't have the focus.
                                                        c.minimized = true
                                                    end,                                    "Minimize client"),
    awful.key({ modkey,             },  "m",        function (c)
                                                        c.maximized_horizontal = not c.maximized_horizontal
                                                        c.maximized_vertical   = not c.maximized_vertical
                                                    end,                                    "Maximize client")
)


-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber));
end


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
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
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_color,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },

    { rule = { instance = "exe" }, -- Changed to "exe" from "plugin-container"
        properties = { floating = true } },
    { rule = { class = "pinentry" },
        properties = { floating = true } },
    { rule = { class = "Kcalc" },
        properties = { floating = true } },
    { rule = { class = "gimp" },
        properties = { floating = true } },
    { rule = { class = "Gvim" } ,
        properties = { tag = tags[1][2] } },
    { rule = { class = "Chromium" },
        properties = { tag = tags[1][3] } },
    { rule = { class = "Kmail" },
        properties = { tag = tags[1][4] } },

}
-- }}}



-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
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

client.add_signal("new",        function(c)
                                    math.randomseed(os.date("%H%M%S"))
                                    num = math.random(7)
                                    accent = beautiful.accents[num]
                                    accents[c] = accent
                                end)
client.add_signal("focus",      function(c) c.border_color = accents[c] end)
client.add_signal("unfocus",    function(c) c.border_color = beautiful.border_normal end)
-- }}}
