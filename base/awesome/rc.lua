-- vim: set foldmethod=marker:
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
local keydoc = require("keydoc")

-- Error handling {{{
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
end -- }}}

-- Variable definitions {{{
-- Themes define colours, icons, and wallpapers
theme = "summer.lua"
themedir = os.getenv("XDG_CONFIG_HOME") .. "/awesome/themes/"
beautiful.init(themedir .. theme)

-- This is used later as the default terminal and editor to run
terminal = "termite"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = editor

-- Default modkey
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.max,
} -- }}}

-- Wallpaper {{{
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end -- }}}

-- Tags {{{
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end -- }}}

-- Wibox {{{
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
                                                  instance = awful.menu.clients({ width=250 })
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
    mywibox[s] = awful.wibox({position = "top",
                              screen = s,
                              height = 20})

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end -- }}}

-- Mouse bindings {{{
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)) -- }}}

-- Key bindings {{{
-- Global keys {{{
globalkeys = awful.util.table.join(
awful.key({modkey}, "F1", keydoc.display),
keydoc.group("Movement"), -- {{{
awful.key({modkey}, "Escape", awful.tag.history.restore, "Revert to last tag configuration"),
awful.key({modkey}, "u", awful.client.urgent.jumpto, "Jump to urgent client"),
awful.key({modkey}, "w", function () awful.screen.focus(1) end, "Focus screen 1/2/3"),
awful.key({modkey}, "e", function () awful.screen.focus(2) end),
awful.key({modkey}, "r", function () awful.screen.focus(3) end),
awful.key({modkey, "Control" }, "n", awful.client.restore, "Restore random client"),
awful.key({modkey}, "Tab",
function ()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end, "Focus previous client"), -- }}}

keydoc.group("Layout Manipulation"), -- {{{
    awful.key({modkey}, "-", function () awful.tag.incmwfact(-0.05) end, "Decrease/increase master ratio"),
    awful.key({modkey}, "+", function () awful.tag.incmwfact(0.05) end),
    awful.key({modkey, "Shift"}, "-", function () awful.tag.incnmaster(-1) end,  "Fewer/more master clients"),
    awful.key({modkey, "Shift"}, "+", function () awful.tag.incnmaster(1) end),
    awful.key({modkey, "Control"}, "-", function () awful.tag.incncol(-1) end, "Fewer/more slave columns"),
    awful.key({modkey, "Control"}, "+", function () awful.tag.incncol( 1) end),
    awful.key({modkey}, ",", function () awful.layout.inc(layouts, -1) end, "Previous/next layout"),
    awful.key({modkey}, ".", function () awful.layout.inc(layouts, 1) end), -- }}}

    keydoc.group("Prompts and spawns"), -- {{{
        awful.key({modkey, "Control"}, "r", awesome.restart, "Restart Awesome"),
        awful.key({modkey, "Control"}, "q", awesome.quit, "Quit Awesome"),
        awful.key({modkey}, "y", function () awful.util.spawn(terminal) end, "Spawn terminal"),
        awful.key({modkey}, "x", function() menubar.show() end, "Menubar"),
        awful.key({modkey}, "r", function() awful.util.spawn(terminal .. " -e ranger") end, "Spawn file manager"), -- }}}

        keydoc.group("Music"), -- {{{
            awful.key({}, "XF86AudioMute", function() awful.util.spawn("pulseaudio-ctl mute") end, "Toggle mute"),
            awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("pulseaudio-ctl down") end, "Lower/raise volume"),
            awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("pulseaudio-ctl up") end) -- }}}
            )

            -- Bind all key numbers to tags.
            -- Be careful: we use keycodes to make it works on any keyboard layout.
            -- This should map on the top row of your keyboard, usually 1 to 9.
            for i = 1, 9 do
                globalkeys = awful.util.table.join(globalkeys,
                keydoc.group("Tag Operations"), -- {{{
                    awful.key({ modkey }, "#" .. i + 9,
                    function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                            awful.tag.viewonly(tag)
                        end
                    end, "Show only this tag"),
                    awful.key({ modkey, "Control" }, "#" .. i + 9,
                    function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                            awful.tag.viewtoggle(tag)
                        end
                    end, "Toggle view of this tag"),
                    awful.key({ modkey, "Shift" }, "#" .. i + 9,
                    function ()
                        if client.focus then
                            local tag = awful.tag.gettags(client.focus.screen)[i]
                            if tag then
                                awful.client.movetotag(tag)
                            end
                        end
                    end, "Set tag on client"),
                    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                    function ()
                        if client.focus then
                            local tag = awful.tag.gettags(client.focus.screen)[i]
                            if tag then
                                awful.client.toggletag(tag)
                            end
                        end
                    end, "Toggle tag on client")) -- }}}
                end
                -- }}}

-- Per-client keys {{{
clientkeys = awful.util.table.join(
    keydoc.group("Client Operations"), -- {{{
    awful.key({modkey}, "h", function (c) awful.client.focus.global_bydirection("left", c) end, "Move focus left/down/up/right"),
    awful.key({modkey}, "j", function (c) awful.client.focus.global_bydirection("down", c) end),
    awful.key({modkey}, "k", function (c) awful.client.focus.global_bydirection("up", c) end),
    awful.key({modkey}, "l", function (c) awful.client.focus.global_bydirection("right", c) end),
    awful.key({modkey, "Shift"}, "h", function (c) awful.client.swap.global_bydirection("left", c) end, "Move client left/down/up/right"),
    awful.key({modkey, "Shift"}, "j", function (c) awful.client.swap.global_bydirection("down", c) end),
    awful.key({modkey, "Shift"}, "k", function (c) awful.client.swap.global_bydirection("up", c) end),
    awful.key({modkey, "Shift"}, "l", function (c) awful.client.swap.global_bydirection("right", c) end),
    awful.key({modkey, "Shift"}, "w", function (c) awful.client.movetoscreen(c, 1) end, "Move to screen 1/2/3"),
    awful.key({modkey, "Shift"}, "e", function (c) awful.client.movetoscreen(c, 2) end),
    awful.key({modkey, "Shift"}, "r", function (c) awful.client.movetoscreen(c, 3) end),
    awful.key({modkey, "Shift"}, "x", function (c) c:kill() end, "Kill client"),
    awful.key({modkey, "Control"}, "Return", function (c) c:swap(awful.client.getmaster()) end, "Focus master"),
    awful.key({modkey}, "f", function (c) c.fullscreen = not c.fullscreen end, "Toggle fullscreen"),
    awful.key({modkey, "Shift"}, "f", awful.client.floating.toggle, "Toggle float"),
    awful.key({modkey}, "t", function (c) c.ontop = not c.ontop end, "Toggle top"),
    awful.key({modkey}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end, "Toggle maximize"),
    awful.key({modkey}, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end, "Minimize client") -- }}}
)

clientbuttons = awful.util.table.join(
    keydoc.group("Mouse"), -- {{{
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end, "Focus and raise client"),
    awful.button({ modkey }, 1, awful.mouse.client.move, "Move client"),
    awful.button({ modkey }, 3, awful.mouse.client.resize, "Resize client")) -- }}}
-- }}}

-- Set keys
root.keys(globalkeys) -- }}}

-- Rules {{{
awful.rules.rules = {
    -- All clients will match this rule
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "mpv" },
      properties = { floating = true } },
    -- Set Firefox to always map on screen 1, tag 1
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },
} -- }}}

-- Signals {{{
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
