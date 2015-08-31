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

-- Load Debian menu entries
require("debian.menu")

local vicious = require("vicious")

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
beautiful.init("/home/hrom/.config/awesome/theme.lua")
for s = 1, screen.count() do
	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "editor"
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
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
--if beautiful.wallpaper then
--    for s = 1, screen.count() do
--        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--    end
--end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, {layouts[1], layouts[3], layouts[3], layouts[3], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], })
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Separator
separator = wibox.widget.textbox()
separator:set_text(" :: ")
-- Spacer
spacer = wibox.widget.textbox()
spacer:set_text(" ")

-- { Keyboard map indicator and changer
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { "us", "de", "cz" , "ru"}
kbdcfg.current = 1  -- us is our default layout
--kbdcfg.widget = wibox.widget.textbox({align = "right" })
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current].. " ")
kbdcfg.switch = function (sel)
	if (sel == 0 or sel > #(kbdcfg.layout)) then 
	   kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
   else
	   kbdcfg.current = sel;
   end
   local t = " " .. kbdcfg.layout[kbdcfg.current] .. " "
   kbdcfg.widget:set_text(t)
   os.execute( kbdcfg.cmd .. t )
end

langmenu = { }
for i, lang in ipairs(kbdcfg.layout) do
	langmenu[i] = { lang , function () kbdcfg.switch(i) end}
end
mylangmenu = awful.menu( { items = langmenu } )

-- Mouse bindings
kbdcfg.widget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () kbdcfg.switch(0) end),
	awful.button({ }, 3, function () mylangmenu:toggle() end)
))
-- }


-- Network usage widget
local netwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.net)
vicious.register(netwidget, vicious.widgets.net,
		function (widget, args)
			if args["{eth0 carrier}"] == 1 then return '⌁<span color="#CC9393">' .. args["{eth0 down_kb}"] .. '</span> <span color="#7F9F7F">' .. args["{eth0 up_kb}"] .. '</span> kb'
			elseif args["{wlan0 carrier}"] == 1 then return '↯<span color="#CC9393">' .. args["{wlan0 down_kb}"] .. '</span> <span color="#7F9F7F">' .. args["{wlan0 up_kb}"] .. '</span> kb'
			else return '<span color="#CC9393">Wrong Carrier</span>'
			end
		end,3)

-- Wifi widget
local wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi, "${ssid} ${linp}%", 7, "wlan0")

-- Mixer widget
local mixerwidget = wibox.widget.textbox()
local mixerbar = awful.widget.progressbar()
local mixerbutton = wibox.widget.textbox()
mixerbutton:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn( "amixer set Master toggle")
		vicious.force({mixerwidget}) end),
	awful.button({ }, 4, function () awful.util.spawn( "amixer -c 0 set Master 5+")
		vicious.force({mixerbar}) end),
	awful.button({ }, 5, function () awful.util.spawn( "amixer -c 0 set Master 5-")
		vicious.force({mixerbar}) end)
	))
vicious.register(mixerwidget, vicious.widgets.volume, "$2", 1, "-c 0 Master")
mixerwidget:buttons(mixerbutton:buttons())
mixerbar:set_width(10):set_height(20)
mixerbar:set_vertical(true)
mixerbar:set_background_color("#494B4F")
mixerbar:set_border_color(nil)
mixerbar:set_color("#666666")
mixerbar:set_color({type = "linear", from  = {0,0}, to = {0, 20}, stops = { { 0, "#000000"}, {0.5, "#222222"}, {1, "#444444"}}})
mixerbar:buttons(mixerbutton:buttons())
vicious.register(mixerbar, vicious.widgets.volume, "$1", 1, "-c 0 Master")


-- Memory usage widget
local memwidget = awful.widget.progressbar()
memwidget:set_width(10)
memwidget:set_height(20)
memwidget:set_vertical(true)
memwidget:set_background_color("#494B4F")
memwidget:set_border_color(nil)
memwidget:set_color("#666666")
memwidget:set_color({type = "linear", from  = {0,0}, to = {0, 20}, stops = { { 0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96"}}})

vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem,"$1", 10)

-- Cpu usage widget
local cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "Cpu:$1%", 2)

-- Baterry progressbar widget
local batwidget = awful.widget.progressbar()
batwidget:set_width(10):set_height(20):set_ticks_size(2)
batwidget:set_vertical(true):set_ticks(true)
batwidget:set_background_color("#494B4F")
batwidget:set_border_color(nil)
batwidget:set_color("#666666")
batwidget:set_color({type = "linear", from  = {0,0}, to = {0, 20}, stops = { { 0, "#AECF96"}, {0.5, "#88A175"}, {1, "#FF5656"}}})
-- Baterry widget
batterywidget = wibox.widget.textbox()
vicious.register(batterywidget, vicious.widgets.bat, "$1", 59, "BAT0")
vicious.register(batwidget, vicious.widgets.bat, "$2", 5, "BAT0")


-- Gmail widget
gmailwidget = wibox.widget.textbox()
--vicious.register(gmailwidget, vicious.widgets.gmail, "Mail:${count}${subject}[0]", 61)
vicious.register(gmailwidget, vicious.widgets.gmail, "Mail:${count}", 61)


-- Create a systray
mysystray = wibox.widget.systray()


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag)
					--Dont scroll tags
                    --awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    --awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
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
                                          end))
	--Dont scroll windows
    --                 awful.button({ }, 4, function ()
    --                                          awful.client.focus.byidx(1)
    --                                          if client.focus then client.focus:raise() end
    --                                      end),
    --                 awful.button({ }, 5, function ()
    --                                          awful.client.focus.byidx(-1)
    --                                          if client.focus then client.focus:raise() end
    --                                      end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)))
						   --Dont scroll layouts
                           --awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           --awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

        --s == 1 and mysystray or nil,
        --mytasklist[s],
        --layout = awful.widget.layout.horizontal.rightleft

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
	
	if s == 1 then right_layout:add(separator) end
	if s == 1 then right_layout:add(gmailwidget) end
	if s == 1 then right_layout:add(separator) end
	if s == 1 then right_layout:add(batwidget) end
	if s == 1 then right_layout:add(batterywidget) end
	if s == 1 then right_layout:add(separator) end
	if s == 1 then right_layout:add(cpuwidget) end
	if s == 1 then right_layout:add(separator) end
	if s == 1 then right_layout:add(wifiwidget) end
	if s == 1 then right_layout:add(netwidget) end
	if s == 1 then right_layout:add(separator) end
	if s == 1 then right_layout:add(memwidget) end
	if s == 1 then right_layout:add(separator) end
	if s == 1 then right_layout:add(mixerwidget) end
	if s == 1 then right_layout:add(mixerbar) end
	if s == 1 then right_layout:add(separator) end
	if s == 1 then right_layout:add(kbdcfg.widget) end
	if s == 1 then right_layout:add(separator) end
    if s == 1 then right_layout:add(mytextclock) end
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
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	--Togle mute
	awful.key({ }, "XF86AudioMute", function() awful.util.spawn( "amixer set Master toggle") end),
	--Volume up
	awful.key({ }, "XF86AudioRaiseVolume", function() awful.util.spawn( "amixer -c 0 set Master 5+") end),
	--Volume down
	awful.key({ }, "XF86AudioLowerVolume", function() awful.util.spawn( "amixer -c 0 set Master 5-") end),
	--Toggle mic-mute
	awful.key({ }, "XF86AudioMicMute", function() awful.util.spawn( "amixer -c 0 set Mic toggle") end),
	--Brightness Up
	awful.key({ }, "XF86MonBrightnessUp", function() awful.util.spawn( "xbacklight -inc 5") end),
	--Brightness Down
	awful.key({ }, "XF86MonBrightnessDown", function() awful.util.spawn( "xbacklight -dec 5") end),


    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    awful.key({ modkey,           }, "j",	function () awful.client.focus.global_bydirection("down") end),
    awful.key({ modkey,           }, "k",	function () awful.client.focus.global_bydirection("up") end),
    awful.key({ modkey,           }, "l",   function () awful.client.focus.global_bydirection("right") end),
    awful.key({ modkey,           }, "h",   function () awful.client.focus.global_bydirection("left") end),


    -- Layout manipulation
    --awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.bydirection("up")    end),
    --awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.bydirection("down")    end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.tag.incmwfact(0.05) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.tag.incmwfact(-0.05)    end),
	--TODO here??
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
	--TODO cycle all windows in tab
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

	-- Lock screen
    awful.key({ modkey,           }, "F12", function () awful.util.spawn("slock") end),
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

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
              end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      function (c) awful.client.movetoscreen(c, c.screen-1) end), 
    awful.key({ modkey,           }, "p",      function (c) awful.client.movetoscreen(c, c.screen+1) end),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
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
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
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
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
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
