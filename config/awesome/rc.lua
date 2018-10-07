local gears =       require("gears")
local awful =       require("awful")
                    require("awful.autofocus")
local wibox =       require("wibox")
local beautiful =   require("beautiful")
local naughty =     require("naughty")
local lain =        require("lain")
local vicious =     require("vicious")

-----------------------------------------------------------------------------
-- {{{ Error handling
------------------------------------------------------------------------------
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
				 text = tostring(err) })
		in_error = false
	end)
end
-- }}}

beautiful.init(awful.util.getdir("config") .. "/themes/blueres/theme.lua")


terminal = "termite --config ~/.config/termite/config"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"
accent_color = "#327474"
secondary_color = "#3b4152"

awful.spawn.with_shell("~/.config/awesome/autorun.sh")

awful.layout.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.floating,
}

function ultiwidget (widg, props)
    local props = props or {}
    local real_widget = wibox.container.background(widg)
    if props.bg then
        real_widget.bg = props.bg
    end
    if props.fg then
        real_widget.fg = props.fg
    end
    if props.round then
        real_widget.shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, props.round)
        end
    end
    res = {
        {
            real_widget,
            bottom = props.bottom or 4,
            top = props.top or 4,
            left = props.left or 2,
            right = props.right or 2,
            widget = wibox.container.margin
        },
        layout = wibox.container.margin
    }
    return res
end


naughty.config.notify_callback = function(args)
	if args.icon then
		args.icon_size = 100
	end
	return args
end

mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock(" %a %d  %H:%M ", 60 )

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
    	if client.focus then
    		client.focus:move_to_tag(t)
    	end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
    	if client.focus then
    		client.focus:toggle_tag(t)
    	end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.screen.connect_for_each_screen(function(s)
-- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7" }, s, awful.layout.layouts[1])
    beautiful.taglist_spacing = "5"

    s.mylayoutbox = awful.widget.layoutbox(s)
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    local systray = wibox.widget.systray()
    beautiful.systray_icon_spacing = 0

    local separator = wibox.widget.textbox()
    separator.markup = '  '

    -- infos from mpris clients such asfour sea spotify and VLC
    -- based on https://github.com/acrisci/playerctl
    local mpris, mpris_timer = awful.widget.watch(
    	{ awful.util.shell, "-c", "playerctl status && playerctl metadata" },
    	2,
    	function(widget, stdout)
    		local escape_f  = require("awful.util").escape
    		local mpris_now = {
    			state        = "N/A",
    			artist       = "N/A",
    			title        = "N/A",
    			art_url      = "N/A",
    			album        = "N/A",
    			album_artist = "N/A"
    		}

    		mpris_now.state = string.match(stdout, "Playing") or
    		string.match(stdout, "Paused")  or "N/A"

    		for k, v in string.gmatch(stdout, "'[^:]+:([^']+)':[%s]<%[?'([^']+)'%]?>")
    			do
    				if     k == "artUrl"      then mpris_now.art_url      = v
    				elseif k == "artist"      then mpris_now.artist       = escape_f(v)
    				elseif k == "title"       then mpris_now.title        = escape_f(v)
    				elseif k == "album"       then mpris_now.album        = escape_f(v)
    				elseif k == "albumArtist" then mpris_now.album_artist = escape_f(v)
    				end
    			end

    				-- customize here
    			if mpris_now.state == "Playing" then widget:set_text("  " .. mpris_now.artist .. " - " .. mpris_now.title .. "  ")
                elseif mpris_now.state == "Paused" then widget:set_markup('<span bgcolor="' .. accent_color .. '">  ' .. mpris_now.artist .. " - " .. mpris_now.title .. '  </span>')
    			else
    				widget:set_text("")
    			end
    		end
    	)

    local bat = lain.widget.bat({
    	battery = "BAT1",
        ac = "ADP1",
        timeout = 5,
        settings = function()
            if bat_now.status ~= "N/A" then
                if bat_now.ac_status == 1 then
                    widget:set_markup('<span bgcolor="#3b7182"> ' .. bat_now.perc .. ' </span>')
                    return
                end
                widget:set_markup(" " .. bat_now.perc .. " ")
            else
                widget:set_markup('<span bgcolor="#3b7182"> ' .. bat_now.perc .. ' </span>')
            end
        end
    })

    local brightness = awful.widget.watch('sh -c "~/bin/show_brightness.sh"', 10)

    local cputemp = awful.widget.watch('sh -c "~/bin/cputemp.sh"', 60)

    local volume = lain.widget.pulse {
        timeout = 1,
        settings = function()
            vlevel = " " .. volume_now.left .. " - " .. volume_now.right .. " "
            if volume_now.muted == "yes" then
                widget:set_markup('<span bgcolor="' .. accent_color .. '">' .. vlevel .. '</span>')
            else
                widget:set_markup(vlevel)
            end
        end
    }

    local cal = lain.widget.calendar({
        icons = "",
        attach_to = { mytextclock },
        notification_preset = {
            font = "Roboto Mono Light for Powerline",
            bg = "#e8f8f8",
            fg = "#000000",
            position = "bottom_right",
        }
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 48 })

    -- Add widgets to the wibox
    s.mywibox:setup {
    	layout = wibox.layout.align.horizontal,
    	{ -- Left widgets
        	layout = wibox.layout.fixed.horizontal,
            ultiwidget(s.mylayoutbox, { top = 4, bottom = 4 }),
        	ultiwidget(s.mytaglist, { top = 4, bottom = 4 }),
    	},
        { -- Middle widget
            layout = wibox.container.place,
        	ultiwidget(mpris,            { bg = secondary_color, round = 3 })
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            ultiwidget(systray,          { bg = "#282c3a", left = 4, round = 2 }),
        	ultiwidget(mykeyboardlayout, { bg = secondary_color, left = 4, round = 2 }),
        	ultiwidget(cputemp,          { bg = secondary_color, left = 4, round = 2 }),
            ultiwidget(mytextclock,      { bg = secondary_color, left = 4, round = 2 }),
            ultiwidget(volume.widget,    { bg = secondary_color, left = 4, round = 2 }),
            ultiwidget(bat.widget,       { bg = secondary_color, left = 4, round = 2 }),
--            ultiwidget(brightness,       { bg = secondary_color, left = 4, round = 2 })
        },
    }
end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
awful.key({ modkey,           }, "Escape", awful.tag.history.restore,                             {description = "go back", group = "tag"} ),
-- Layout manipulation
awful.key({ modkey,           }, "Tab",    function () awful.client.focus.byidx( 1)  end,         {description = "focus next client", group = "client"}),
-- Standard program
awful.key({ modkey,           }, ",",      function() awful.spawn("playerctl previous")  end,	  {description = "spotify prev", group = "launcher"}),
awful.key({ modkey,           }, ".",      function() awful.spawn("playerctl next")  end,         {description = "spotify next", group = "launcher"}),
awful.key({ modkey,           }, "/",      function() awful.spawn("playerctl play-pause")  end,   {description = "spotify play", group = "launcher"}),
awful.key({ modkey,           }, "Return", function() awful.spawn(terminal) end,	              {description = "open a terminal", group = "launcher"}),
awful.key({ modkey,           }, "f",      function() awful.spawn(terminal .. " -e ranger") end,  {description = "ranger", group = "launcher"}),
awful.key({ modkey,           }, "c",      function() awful.spawn("firefox") end,	              {description = "firefox", group = "launcher"}),
awful.key({ "Control"         }, "space",  function() awful.spawn("rofi -show drun") end,         {description = "rofi", group = "launcher"}),
awful.key({ modkey, "Control" }, "r",      awesome.restart,	                                      {description = "reload awesome", group = "awesome"}),
awful.key({ modkey, "Shift"   }, "q",      awesome.quit,	                                      {description = "quit awesome", group = "awesome"}),
awful.key({ modkey,           }, "z",      function () awful.spawn("betterlockscreen -l") end,    {description = "lock", group = "awesome"}),
awful.key({ modkey,           }, "l",      function () awful.layout.inc(1)                 end,   {description = "select next", group = "layout"}),
awful.key({ modkey,           }, "Right",  function () awful.tag.incmwfact( 0.01)    end),
awful.key({ modkey,           }, "Left",   function () awful.tag.incmwfact(-0.01)    end),
awful.key({ modkey,           }, "Down",   function () awful.client.incwfact( 0.01)    end),
awful.key({ modkey,           }, "Up",     function () awful.client.incwfact(-0.01)    end)
)

clientkeys = gears.table.join(
awful.key({ modkey, "Shift"    }, "f",
function (c)
	c.fullscreen = not c.fullscreen
	c:raise()
end,
	  {description = "toggle fullscreen", group = "client"}),
awful.key({ modkey,           }, "x",      function (c) c:kill()                         end,     {description = "close", group = "client"}),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,     {description = "move to master", group = "client"}),
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,     {description = "toggle keep on top", group = "client"}),
awful.key({ modkey,           }, "m",
function (c)
	c.maximized = not c.maximized
	c:raise()
end ,
	  {description = "(un)maximize", group = "client"}),

awful.key({ modkey, "Shift"   }, "Down",   function (c) c:relative_move(  0,   0,   0,  -20) end),
awful.key({ modkey, "Shift"   }, "Up",     function (c) c:relative_move(  0,   0,   0,   20) end),
awful.key({ modkey, "Shift"   }, "Left",   function (c) c:relative_move(  0,   0, -20,    0) end),
awful.key({ modkey, "Shift"   }, "Right",  function (c) c:relative_move(  0,   0,  20,    0) end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
	-- View tag only.
	awful.key({ modkey }, "#" .. i + 9,
	function ()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then
			tag:view_only()
		end
	end,
	{description = "view tag #"..i, group = "tag"}),
	-- Toggle tag display.
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function ()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then
			awful.tag.viewtoggle(tag)
		end
	end,
	{description = "toggle tag #" .. i, group = "tag"}),
	-- Move client to tag.
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end,
	{description = "move focused client to tag #"..i, group = "tag"}),
	-- Toggle tag on focused client.
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:toggle_tag(tag)
			end
		end
	end,
	{description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

clientbuttons = gears.table.join(
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
	screen = awful.screen.preferred,
	placement = awful.placement.no_overlap+awful.placement.no_offscreen
	}
       },

    -- Floating clients.
    { rule_any = {
	    instance = {
	    },
	        class = {
		    "Thunar",
            },

		    name = {  -- xev.
		    },
		    role = {
			    "AlarmWindow",  -- Thunderbird's calendar.
			    "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
		    }
	    }, properties = { floating = true,
	    placement = awful.placement.centered
    }
     },

     -- Add titlebars to normal clients and dialogs
     { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and
		not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)


client.connect_signal("property::fullscreen", function(c)
	if c.fullscreen then
		gears.timer.delayed_call(function()
			if c.valid then
				c:geometry(c.screen.geometry)
			end
		end)
	end
end)

-- }}}
