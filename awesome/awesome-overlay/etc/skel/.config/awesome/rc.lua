--[[
    Cesious Awesome WM theme
    Created by Culinax
--]]

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
-- Vicious
local vicious = require("vicious")
-- Lain
local lain = require("lain")
-- freedesktop.org
local freedesktop = require('freedesktop')

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
beautiful.init(awful.util.getdir("config") .. "/themes/cesious/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
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
tags = {
  names  = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
  layout = { layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
freedesktop.utils.terminal = terminal
menu_items = freedesktop.menu.new()
myawesomemenu = {
   { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
   { "edit config", editor_cmd .. " " .. awesome.conffile, freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
   { "edit theme", editor_cmd .. " " .. awful.util.getdir("config") .. "/themes/cesious/theme.lua", freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
   { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
   { "quit", "oblogout", freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) }
}
table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
table.insert(menu_items, { "open terminal", terminal, freedesktop.utils.lookup_icon({icon = 'terminal'}) })
mymainmenu = awful.menu({ items = menu_items, theme = { width = 150 } })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
-- }}}

-- {{{ Wibox
markup      = lain.util.markup
darkblue    = theme.bg_focus
blue        = "#9EBABA"
red         = "#EB8F8F"

-- Separators
spacer = wibox.widget.textbox(" ")
seperator = wibox.widget.textbox(' <span color="' .. darkblue .. '">|</span> ')

-- Create a textclock widget
mytextclock = awful.widget.textclock("%A %d %B %H:%M ")
-- Show calendar when hovering over mytextclock
lain.widgets.calendar:attach(mytextclock)

cpu = wibox.widget.textbox()
vicious.register(cpu, vicious.widgets.cpu, '<span color="' .. blue .. '">CPU:</span> $1%', 2)

mem = wibox.widget.textbox()
vicious.register(mem, vicious.widgets.mem, '<span color="' .. blue .. '">RAM:</span> $1% ($2MB)', 5)

thermal  = wibox.widget.textbox()
vicious.register(thermal, vicious.widgets.thermal, '<span color="' .. blue .. '">Temp:</span> $1°C', 30, "thermal_zone0")

-- ALSA
vol = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            level = markup(red, volume_now.level .. "M")
        else
            level = volume_now.level .. "%"
        end
        widget:set_markup(markup(blue, "Vol: ") .. level)
    end
})
-- ALSA Mouse -- LeftClick=1 RightClick=3 ScrollUp=4 ScrollDown=5
vol:buttons(awful.util.table.join(
    awful.button({}, 1, function ()
        awful.util.spawn(awful.util.getdir("config") .. "/scripts/volume.sh mute")
        vol.update()
    end),
    awful.button({}, 3, function ()
        awful.util.spawn(terminal .. " -e alsamixer")
        vol.update()
    end),
    awful.button({}, 4, function ()
        awful.util.spawn(awful.util.getdir("config") .. "/scripts/volume.sh up")
        vol.update()
    end),
    awful.button({}, 5, function ()
        awful.util.spawn(awful.util.getdir("config") .. "/scripts/volume.sh down")
        vol.update()
    end)
))

-- Battery
bat = lain.widgets.bat({
    battery = "BAT0",
    settings = function()
        if bat_now.perc == "N/A" then
            perc = "AC"
        elseif tonumber(bat_now.perc) <= 15 then
            perc = markup(red, bat_now.perc .. "%")
        else
            perc = bat_now.perc .. "%"
        end
        widget:set_markup(markup(blue, "Bat: ") .. perc)
    end
})

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
    mywibox[s] = awful.wibox({ position = "top", height = "18", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(spacer)
    left_layout:add(mytaglist[s])
    left_layout:add(spacer)
    left_layout:add(mylayoutbox[s])
    left_layout:add(spacer)
    left_layout:add(mypromptbox[s])
    left_layout:add(spacer)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spacer)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(seperator)
    right_layout:add(vol)
    right_layout:add(seperator)
    right_layout:add(thermal)
    right_layout:add(seperator)
    right_layout:add(cpu)
    right_layout:add(seperator)
    right_layout:add(mem)
    right_layout:add(seperator)
    right_layout:add(bat)
    right_layout:add(seperator)
    right_layout:add(mytextclock)

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
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

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
    awful.key({ modkey,           }, "Return", function () awful.util.spawn_with_shell(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
--    awful.key({ modkey, "Shift"   }, "q", awesome.quit), -- Default M-S-q command, oblogout lets you choose what to do
    awful.key({ modkey, "Shift"   }, "q", function () awful.util.spawn_with_shell("oblogout") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
--    awful.key({ modkey }, "p", function() menubar.show() end) -- Default M-p command, dmenu is a better/faster alternative
    awful.key({ modkey }, "p", function () awful.util.spawn_with_shell("dmenu_run -h '18' -i -nb '" .. beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. "' -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus .. "' -fn 'Terminus:size=9'") end),

    -- Toggle wibox visibility
    awful.key({ modkey }, "b", function ()
     mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end), 

    -- Switch to specific layout
    awful.key({ modkey, "Control" }, "f", function () awful.layout.set(awful.layout.suit.floating) end),
    awful.key({ modkey, "Control" }, "t", function () awful.layout.set(awful.layout.suit.tile) end),
    awful.key({ modkey, "Control" }, "b", function () awful.layout.set(awful.layout.suit.tile.bottom) end),
    awful.key({ modkey, "Control" }, "s", function () awful.layout.set(awful.layout.suit.fair) end),
    awful.key({ modkey, "Control" }, "m", function () awful.layout.set(awful.layout.suit.max) end),

    -- Volume control (Script which uses 'volnoti' as notification)
    awful.key({ }, "XF86AudioRaiseVolume", function ()
        awful.util.spawn(awful.util.getdir("config") .. "/scripts/volume.sh up")
        vol.update() end),
    awful.key({ }, "XF86AudioLowerVolume", function ()
        awful.util.spawn(awful.util.getdir("config") .. "/scripts/volume.sh down")
        vol.update() end),
    awful.key({ }, "XF86AudioMute",        function ()
        awful.util.spawn(awful.util.getdir("config") .. "/scripts/volume.sh mute")
        vol.update() end),

    -- Brightness control (Script which uses 'volnoti' as notification) SYNTAX: up/down | percentage
    awful.key({ }, "XF86MonBrightnessUp",   function () awful.util.spawn_with_shell(awful.util.getdir("config") .. "/scripts/brightness.sh up") end),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn_with_shell(awful.util.getdir("config") .. "/scripts/brightness.sh down") end),

    -- Screen lock
    awful.key({ modkey, "Shift" }, "l", function () awful.util.spawn_with_shell("dm-tool lock") end),

    -- Screenshot
    awful.key({ }, "Print", function () awful.util.spawn_with_shell("scrot -e 'mv $f ~/Pictures/'") end),
    awful.key({ "Shift" }, "Print", function () awful.util.spawn_with_shell("scrot -s -e 'mv $f ~/Pictures/'") end),

    -- Applications
    awful.key({ modkey }, "d", function () awful.util.spawn_with_shell("dwb") end),
    awful.key({ modkey }, "t", function () awful.util.spawn_with_shell("spacefm") end)
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
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
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
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
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
                     buttons = clientbuttons,
                     size_hints_honor = false, -- Remove gaps between terminals
                     callback = awful.client.setslave } }, -- Open new clients as slave instead of master
    { rule_any = { class = {"mpv", "pinentry", "Oblogout", "Galculator"},
                   name = {"Event Tester"},
                   instance = {"plugin-container", "exe"} },
                   properties = { floating = true } },
    { rule_any = { name = {"Midori"} }, except = { role = "browser" }, properties = { floating = true } }
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

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
    oldspawn(s, false)
end
-- }}}

-- {{{ Run autostarting applications only once
function autostart(cmd, delay)
    delay = delay or 0
    awful.util.spawn_with_shell("pgrep -u $USER -x -f '" .. cmd .. "' || ( sleep " .. delay .. " && " .. cmd .. " )")
end

-- Autostart applications. The extra argument is optional, it means how long to
-- delay a command before starting it (in seconds).
autostart("compton -b", 1)
autostart("volnoti", 1)
autostart("clipit", 2)
autostart("spacefm -d", 2)
autostart("conky", 3)
-- }}}

-- {{{ Run .desktop files with dex
-- Because 'dex' is not an application, autostart("dex -ae Awesome") will always
-- execute every entry (which is unwanted).
local dex_output = io.popen("dex -ade Awesome")
for cmd in dex_output:lines() do
    autostart(cmd:gsub("Executing command: ", ""), 4)
end
dex_output:close()
-- }}}
