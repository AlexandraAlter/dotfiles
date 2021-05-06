-- vim:fileencoding=utf-8:foldmethod=marker

-- {{{ Packages

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')

-- Widget and layout library
local wibox = require('wibox')

-- Theme handling library
local beautiful = require('beautiful')

-- Notification library
local naughty = require('naughty')

-- Application launcher library
local menubar = require('menubar')

-- Keybinding Help library
local hotkeys_popup = require('awful.hotkeys_popup')

-- Widgets
local st_w = 'streetturtle-widgets'
local st_battery_widget = require(st_w .. '.batteryarc-widget.batteryarc')
local st_brightness_widget = require(st_w .. '.brightnessarc-widget.brightnessarc')
local st_cpu_widget = require(st_w .. '.cpu-widget.cpu-widget')
local st_volume_widget = require(st_w .. '.volumearc-widget.volumearc')
local lain = require('lain')
local lain_h = require('lain.helpers')
local vicious = require('vicious')

-- Data formats
local json = require('lunajson')
-- }}}

-- {{{ Hostname
local hostname = io.popen('uname -n'):read()

local laptop = hostname == 'think-bell'
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = 'Oops, there were errors during startup!',
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal('debug::error', function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = 'Oops, an error happened!',
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. 'themes/zenburn_large/theme.lua')

-- This is used later as the default terminal and editor to run.
terminal = 'kitty'
editor = os.getenv('EDITOR') or 'vim'
editor_cmd = terminal .. ' -e ' .. editor

-- set the terminal for applications that require it
menubar.utils.terminal = terminal

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = 'Mod4'
local super = 'Mod4'
local alt = 'Mod1'
local shift = 'Shift'
local ctrl = 'Control'

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
  awful.layout.suit.floating,
  -- lain.layout.termfair
  -- lain.layout.termfair.center
  -- lain.layout.cascade
  -- lain.layout.cascade.tile
  -- lain.layout.centerwork
  -- lain.layout.centerwork.horizontal
}

my_tags = {
  names = { '-', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' },
  keys  = { '`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' },
}
-- }}}

-- {{{ Global helper functions
-- for mod+x usage
function see(...) naughty.notify{text=table.concat({...}, '\t')} end
-- }}}

-- {{{ Local helper functions
-- create a function that toggles a client's minimized state
local function client_toggle_min(c, sig_context)
  if c == client.focus then
    c.minimized = true
  else
    c:emit_signal('request::activate', sig_context, {raise = true})
  end
end

-- create a function that toggles a client's fullscreen state
local function client_toggle_fullscreen(c)
  c.fullscreen = not c.fullscreen
  c:raise()
end

-- create a function that toggles a client's maximized state
local function client_toggle_max(c)
  c.maximized = not c.maximized
  c:raise()
end

-- create a function that toggles a client's maximized vertical state
local function client_toggle_max_vert(c)
  c.maximized_vertical = not c.maximized_vertical
  c:raise()
end

-- create a function that toggles a client's maximized horizontal state
local function client_toggle_max_horiz(c)
  c.maximized_horizontal = not c.maximized_horizontal
  c:raise()
end

local function client_restore_and_focus(sig_context)
  local c = awful.client.restore()
  if c then -- focus restored client
    c:emit_signal('request::activate', sig_context, {raise = true})
  end
end

local function client_restore_and_fullscreen(sig_context)
  local c = awful.client.restore()
  if c then -- focus restored client
    c.maximized = true
    c:emit_signal('request::activate', sig_context, {raise = true})
  end
end

local function client_go_back()
  awful.client.focus.history.previous()
  if client.focus then
      client.focus:raise()
  end
end

-- move all clients to the opposite screen
local function screens_swap_all()
  for _, c in ipairs(client.get()) do
    local tags = gears.table.clone(c:tags())
    c:move_to_screen()
    for _, t in ipairs(tags) do
      c:toggle_tag(c.screen.tags[t.index])
    end
  end
  
  for s in screen do
    -- refresh the taglist here?
  end
end

local function prompt_lua()
  awful.prompt.run {
    prompt       = 'Run Lua code: ',
    textbox      = awful.screen.focused().my_widgets.prompt.widget,
    exe_callback = awful.util.eval,
    history_path = awful.util.get_cache_dir() .. '/history_eval'
  }
end

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
-- }}}

-- {{{ Autostarting
awful.spawn.with_shell(
  'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
  'xrdb -merge <<< "awesome.started:true";' ..
  -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
  'dex --environment Awesome --autostart --search-paths "${XDG_CONFIG_DIRS:-/etc/xdg}/autostart:${XDG_CONFIG_HOME:-~/.config}/autostart"'
)
-- }}}

-- {{{ Menu
my_menus = {}
my_submenus = {}

my_submenus.awesome = {
   { 'hotkeys', function () hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { 'edit config', editor_cmd .. ' ' .. awesome.conffile },
   { 'restart', awesome.restart },
   { 'quit', function () awesome.quit() end },
}

local scr_internal = 'eDP-1'
local scr_external = 'HDMI-2'
local function xrandr_cmd(int_opts, ext_opts)
  return 'xrandr ' ..
    ' --output ' .. scr_internal .. ' ' .. int_opts ..
    ' --output ' .. scr_external .. ' ' .. ext_opts
end

my_submenus.xrandr = {
  { 'External off', xrandr_cmd('--primary --auto', '--off') },
  { 'External dup', xrandr_cmd('--primary --auto', '--same-as ' .. scr_internal) },
  { 'External above', xrandr_cmd('--auto', '--primary --auto --above ' .. scr_internal) },
  { 'External below', xrandr_cmd('--auto', '--primary --auto --below ' .. scr_internal) },
  { 'External left', xrandr_cmd('--auto', '--primary --auto --left-of ' .. scr_internal) },
  { 'External right', xrandr_cmd('--auto', '--primary --auto --right-of ' .. scr_internal) },
}

my_submenus.layouts = {
  { 'a', '' },
}

my_submenus.lightdm = {
  { 'switch user', 'dm-tool switch-to-greeter' },
  { 'lock',        'light-locker-command -l' },
}

my_menus.main = awful.menu({
  items = {
    { 'awesome', my_submenus.awesome, beautiful.awesome_icon },
    { 'xrandr', my_submenus.xrandr },
    { 'lightdm', my_submenus.lightdm },
    { 'open terminal', terminal },
  },
})
-- }}}

-- {{{ Widget definition
my_widgets = {}

function my_widgets.prompt()
  return awful.widget.prompt()
end

function my_widgets.launcher()
  return awful.widget.launcher({ image = beautiful.awesome_icon, menu = my_menus.main })
end

local taglist_buttons = gears.table.join(
  awful.button({        }, 1, function (t) t:view_only() end),
  awful.button({ modkey }, 1, function (t) if client.focus then client.focus:move_to_tag(t) end end),
  awful.button({        }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function (t) if client.focus then client.focus:toggle_tag(t) end end),
  awful.button({        }, 4, function (t) awful.tag.viewnext(t.screen) end),
  awful.button({        }, 5, function (t) awful.tag.viewprev(t.screen) end)
)

function my_widgets.taglist(s)
  return awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }
end

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c) client_toggle_min(c, 'tasklist') end),
  awful.button({ }, 3, function () awful.menu.client_list({ theme = { width = 250 } }) end),
  awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
  awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

function my_widgets.tasklist(s)
  return awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }
end

function my_widgets.layoutbox(s)
  return awful.widget.layoutbox(s)
end

function my_widgets.systray()
  return {
    layout = awful.widget.only_on_screen,
    screen = 'primary',
    wibox.widget.systray(),
  }
end

function my_widgets.cpu()
  return st_cpu_widget({})
end

function my_widgets.laptop_temps()
  local files = {
    '/sys/devices/platform/coretemp.0/hwmon/hwmon8/temp1_input',
    '/sys/devices/platform/coretemp.0/hwmon/hwmon8/temp2_input',
    '/sys/devices/platform/coretemp.0/hwmon/hwmon8/temp3_input',
    '/sys/devices/platform/coretemp.0/hwmon/hwmon8/temp4_input',
    '/sys/devices/platform/coretemp.0/hwmon/hwmon8/temp5_input',
    '/sys/devices/virtual/thermal/thermal_zone0/temp',
    '/sys/devices/virtual/thermal/thermal_zone1/temp',
    '/sys/devices/virtual/thermal/thermal_zone2/temp',
    '/sys/devices/virtual/thermal/thermal_zone3/temp',
    '/sys/devices/virtual/thermal/thermal_zone4/temp',
    '/sys/devices/virtual/thermal/thermal_zone5/temp',
    '/sys/devices/virtual/thermal/thermal_zone6/temp',
    '/sys/devices/virtual/thermal/thermal_zone7/temp',
  }

  local temp = lain.widget.temp {
    timeout = 2,
    settings = function ()
      local count = 0
      local max = 0
      local sum = 0

      for i,f in ipairs(desktop_temps) do
        temp = tonumber(temp_now[f])
        count = count + (temp and 1 or 0)
        if temp and (temp > max) then
          max = temp
        end
        sum = sum + (temp or 0)
      end

      local avg = sum / count
      widget:set_markup(string.format('Temp: ~%.1f &lt;%.1f', avg, max))
    end
  }

  return temp.widget
end

function my_widgets.sensors_temps(args)
  args           = args or {}

  local temp     = { widget = args.widget or wibox.widget.textbox() }
  local timeout  = args.timeout or 30

  function temp.update()
    local file = assert(io.popen('sensors -j'))
    local sensors = json.decode(file:read('*all'))
    file:close()

    local temps = {
      sensors['nct6798-isa-0290'].SYSTIN.temp1_input,
      sensors['nct6798-isa-0290'].CPUTIN.temp2_input,
      sensors['k10temp-pci-00c3'].Tctl.temp1_input,
    }

    widget = temp.widget
    local count = 0
    local max = 0
    local sum = 0

    for i, temp in ipairs(temps) do
      count = count + (temp and 1 or 0)
      if temp and (temp > max) then
        max = temp
      end
      sum = sum + (temp or 0)
    end

    local avg = sum / count
    widget:set_markup(string.format('Temp: ~%.1f &lt;%.1f', avg, max))
  end

  lain_h.newtimer('thermal', timeout, temp.update)

  return temp
end

function my_widgets.temps(args)
  if laptop then
    return my_widgets.laptop_temps(args)
  else
    return my_widgets.sensors_temps(args)
  end
end

function my_widgets.volume()
  return st_volume_widget({
    get_volume_cmd = 'amixer -D pulse sget Master',
    inc_volume_cmd = 'amixer -D pulse sset Master 5%+',
    dec_volume_cmd = 'amixer -D pulse sset Master 5%-',
  })
end

function my_widgets.brightness()
  if not laptop then
    return nil
  end

  return st_brightness_widget({
    get_brightness_cmd = 'xbacklight -get',
    inc_brightness_cmd = 'xbacklight -inc 5',
    dec_brightness_cmd = 'xbacklight -dec 5',
  })
end

function my_widgets.battery()
  if not laptop then
    return nil
  end

  return st_battery_widget({
    display_notification = true
  })
end

function my_widgets.layout(s)
  local layoutbox = awful.widget.layoutbox(s)
  layoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
  ))
  return layoutbox
end

-- }}}

-- {{{ Widget construction

my_widgets.global = {
  launcher = my_widgets.launcher(),
  systray = my_widgets.systray(),
  cpu = my_widgets.cpu(),
  temps = my_widgets.temps(),
  volume = my_widgets.volume(),
  brightness = my_widgets.brightness(),
  battery = my_widgets.battery(),
  textclock = wibox.widget.textclock(),
  keyboardlayout = awful.widget.keyboardlayout(),
}

function my_widgets.make_left(s)
  s.my_widgets = s.my_widgets or {}
  s.my_widgets.taglist = my_widgets.taglist(s)
  s.my_widgets.prompt = my_widgets.prompt()
  return {
    layout = wibox.layout.fixed.horizontal,
    my_widgets.global.launcher,
    s.my_widgets.taglist,
    s.my_widgets.prompt,
  }
end

function my_widgets.make_center(s)
  s.my_widgets.tasklist = my_widgets.tasklist(s)
  return s.my_widgets.tasklist
end

function my_widgets.make_right(s)
  s.my_widgets.layout = my_widgets.layout(s)
  return {
    layout = wibox.layout.fixed.horizontal, 
    my_widgets.global.systray,
    my_widgets.global.cpu,
    my_widgets.global.temps,
    my_widgets.global.volume,
    my_widgets.global.brightness,
    my_widgets.global.battery,
    my_widgets.global.textclock,
    my_widgets.global.keyboardlayout,
    s.my_widgets.layout,
  }
end

-- }}}

-- {{{ Screen setup
awful.screen.connect_for_each_screen(function (s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag(my_tags.names, s, awful.layout.layouts[1])

  s.my_bar = awful.wibar({ position = 'top', screen = s })
  s.my_bar:setup {
    layout = wibox.layout.align.horizontal,
    my_widgets.make_left(s),
    my_widgets.make_center(s),
    my_widgets.make_right(s),
  }
end)
-- }}}

-- {{{ Mouse bindings
local mbind_server = gears.table.join(
  awful.button({ }, 3, function () my_menus.main:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
)

root.buttons = mbind_server

local mbind_client = gears.table.join(
  awful.button({ }, 1, function (c)
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
  end),
  awful.button({ modkey }, 1, function (c)
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
      awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function (c)
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
      awful.mouse.client.resize(c)
  end)
)
-- }}}

-- {{{ Key bindings
local kbind_server = gears.table.join(
  awful.key({ modkey, }, 'F1',     hotkeys_popup.show_help,   {description = 'show help',     group='awesome'}),
  awful.key({ modkey, }, 'Left',   awful.tag.viewprev,        {description = 'view previous', group = 'tag'}),
  awful.key({ modkey, }, 'Right',  awful.tag.viewnext,        {description = 'view next',     group = 'tag'}),
  awful.key({ modkey, }, 'Up',     awful.tag.history.restore, {description = 'go back',       group = 'tag'}),

  awful.key({ modkey, }, 'j', function () awful.client.focus.byidx( 1) end,
            {description = 'focus next by index',     group = 'client'}),
  awful.key({ modkey, }, 'k', function () awful.client.focus.byidx(-1) end,
            {description = 'focus previous by index', group = 'client'}),

  awful.key({ modkey, }, 'w', function () my_menus.main:show() end,
            {description = 'show main menu', group = 'awesome'}),

  -- Layout manipulation
  awful.key({ modkey, shift }, 'j',   function () awful.client.swap.byidx(1) end,
            {description = 'swap with next client by index', group = 'client'}),
  awful.key({ modkey, shift }, 'k',   function () awful.client.swap.byidx(-1) end,
            {description = 'swap with previous client by index', group = 'client'}),
  awful.key({ modkey,       }, 'o',   function () awful.screen.focus_relative(1) end,
            {description = 'focus the next screen', group = 'screen'}),
  awful.key({ modkey, ctrl  }, 'o',   function () screens_swap_all() end,
            {description = 'focus the next screen', group = 'screen'}),
  awful.key({ modkey,       }, 'u',   awful.client.urgent.jumpto,
            {description = 'jump to urgent client', group = 'client'}),
  awful.key({ modkey,       }, 'Tab', function () client_go_back() end,
            {description = 'go back', group = 'client'}),

  -- Standard programs
  awful.key({ modkey,           }, 'Return', function () awful.spawn(terminal) end,
            {description = 'open a terminal', group = 'launcher'}),
  awful.key({ modkey, ctrl      }, 'r',      awesome.restart,
            {description = 'reload awesome', group = 'awesome'}),
  awful.key({ modkey, ctrl      }, 'q',      awesome.quit,
            {description = 'quit awesome', group = 'awesome'}),

  awful.key({ modkey,       }, 'l', function () awful.tag.incmwfact( 0.05) end,
            {description = 'increase master width factor', group = 'layout'}),
  awful.key({ modkey,       }, 'h', function () awful.tag.incmwfact(-0.05) end,
            {description = 'decrease master width factor', group = 'layout'}),
  awful.key({ modkey, shift }, 'h', function () awful.tag.incnmaster( 1, nil, true) end,
            {description = 'increase the number of master clients', group = 'layout'}),
  awful.key({ modkey, shift }, 'l', function () awful.tag.incnmaster(-1, nil, true) end,
            {description = 'decrease the number of master clients', group = 'layout'}),
  awful.key({ modkey, alt   }, 'h', function () awful.tag.incncol( 1, nil, true) end,
            {description = 'increase the number of columns', group = 'layout'}),
  awful.key({ modkey, alt   }, 'l', function () awful.tag.incncol(-1, nil, true) end,
            {description = 'decrease the number of columns', group = 'layout'}),

  -- Layouts
  awful.key({ modkey,       }, 'space', function () awful.layout.inc( 1) end,
            {description = 'select next', group = 'layout'}),
  awful.key({ modkey, shift }, 'space', function () awful.layout.inc(-1) end,
            {description = 'select previous', group = 'layout'}),

  awful.key({ modkey, shift }, 'n', function () client_restore_and_focus('key.unminimize') end,
            {description = 'restore minimized', group = 'client'}),
  awful.key({ modkey, shift }, 'f', function () client_restore_and_fullscreen('key.refullscreen') end,
            {description = 'restore minimized and fullscreen', group = 'client'}),

  -- Prompt
  awful.key({ modkey, shift }, 'p', function () awful.screen.focused().my_widgets.prompt:run() end,
            {description = 'run prompt', group = 'launcher'}),

  awful.key({ modkey }, 'x', function () prompt_lua() end,
            {description = 'lua execute prompt', group = 'awesome'}),

  -- Menubar
  awful.key({ modkey }, 'p', menubar.show,
            {description = 'show the menubar', group = 'launcher'}),

  -- Screenshot
  awful.key({ modkey, shift     }, 's', function () awful.util.spawn_with_shell('maim -s -u | xclip -selection clipboard -t image/png -i') end,
            {description = 'take a screenshot to clipboard', group = 'screenshot'}),
  awful.key({ modkey, alt       }, 's', function () awful.util.spawn_with_shell('maim -u | feh -') end,
            {description = 'take a screenshot to clipboard', group = 'screenshot'}),

  -- Brightness
  awful.key({ }, 'XF86MonBrightnessUp',   function () awful.util.spawn('xbacklight -inc 5') end,
            {description = 'increase brightness', group = 'perpiherals'}),
  awful.key({ }, 'XF86MonBrightnessDown', function () awful.util.spawn('xbacklight -dec 5') end,
            {description = 'decrease brightness', group = 'perpiherals'})
)

for i,k in ipairs(my_tags.keys) do
  local function gettag()
    --return client.focus.screen.tags[i]
    return awful.screen.focused().tags[i]
  end

  kbind_server = gears.table.join(kbind_server,
    awful.key({ modkey             }, k,
              function () if gettag() then gettag():view_only() end end),
    awful.key({ modkey, alt        }, k,
              function () if gettag() then awful.tag.viewtoggle(gettag()) end end),
    awful.key({ modkey, shift      }, k,
              function () if client.focus then client.focus:move_to_tag(gettag()) end end),
    awful.key({ modkey, alt, shift }, k,
              function () if client.focus then client.focus:toggle_tag(gettag()) end end)
  )
end

hotkeys_popup.widget.add_hotkeys({
  tag = {
    { modifiers = { modkey,            }, keys = { ['$/&amp;/7-8/#'] = 'view tag #n' }},
    { modifiers = { modkey, alt        }, keys = { ['$/&amp;/7-8/#'] = 'toggle tag #n' }},
    { modifiers = { modkey, shift      }, keys = { ['$/&amp;/7-8/#'] = 'set tag #n on client' }},
    { modifiers = { modkey, alt, shift }, keys = { ['$/&amp;/7-8/#'] = 'toggle tag #n on client' }},
  },
})

local kbind_client = gears.table.join(
  awful.key({ modkey,           }, 'f',      function (c) client_toggle_fullscreen(c) end,
            {description = 'toggle fullscreen', group = 'client'}),
  awful.key({ modkey, shift     }, 'c',      function (c) c:kill() end,
            {description = 'close', group = 'client'}),
  awful.key({ modkey, alt       }, 'space',  awful.client.floating.toggle,
            {description = 'toggle floating', group = 'client'}),
  awful.key({ modkey, alt       }, 'Return', function (c) c:swap(awful.client.getmaster()) end,
            {description = 'move to master', group = 'client'}),
  awful.key({ modkey, shift     }, 'o',      function (c) c:move_to_screen() end,
            {description = 'move to screen', group = 'client'}),
  awful.key({ modkey,           }, 't',      function (c) c.ontop = not c.ontop end,
            {description = 'toggle keep on top', group = 'client'}),
  awful.key({ modkey,           }, 'n',      function (c) c.minimized = true end,
            {description = 'minimize', group = 'client'}),
  awful.key({ modkey,           }, 'm',      function (c) client_toggle_max(c) end,
            {description = '(un)maximize', group = 'client'}),
  awful.key({ modkey, alt       }, 'm',      function (c) client_toggle_max_vert(c) end,
            {description = '(un)maximize vertically', group = 'client'}),
  awful.key({ modkey, shift     }, 'm',      function (c) client_toggle_max_horiz(c) end,
            {description = '(un)maximize horizontally', group = 'client'})
)

root.keys(kbind_server)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the 'manage' signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = kbind_client,
        buttons = mbind_client,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          'DTA',  -- Firefox addon DownThemAll.
          'copyq',  -- Includes session name in class.
          'pinentry',
        },

        class = {
          'Arandr',
          'Blueman-manager',
          'Gpick',
          'Kruler',
          'MessageWin',  -- kalarm.
          'Sxiv',
          'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
          'Wpa_gui',
          'veromix',
          'xtightvncviewer'},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          'Event Tester',  -- xev.
          'Steam Guard',
        },

        role = {
          'AlarmWindow',  -- Thunderbird's calendar.
          'ConfigManager',  -- Thunderbird's about:config.
          'pop-up',       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Fullscreen clients.
    { rule_any = {
        class = {
          'steam_app_881100', -- Noita
        },
      }, properties = { fullscreen = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { 'normal', 'dialog' }
      }, properties = { titlebars_enabled = true }
    },

    -- Ignore certain pop-up dialogues
    { rule = { instance = 'VelotypeAcademy', floating = true
      }, properties = { focusable = false }
    },

    -- Set Firefox to always map on the tag named '2' on screen 1.
    -- { rule = { class = 'Firefox' },
    --   properties = { screen = 1, tag = '2' } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal('request::titlebars', function (c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function ()
            c:emit_signal('request::activate', 'titlebar', {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function ()
            c:emit_signal('request::activate', 'titlebar', {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    -- we re-use the wibar's height, because it's what our icons are scaled for
    local titlebar = awful.titlebar(c, {size = beautiful.wibar_height})

    titlebar:setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = 'center',
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal('mouse::enter', function (c)
    c:emit_signal('request::activate', 'mouse_enter', {raise = false})
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)

client.connect_signal('focus', function (c) c.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function (c) c.border_color = beautiful.border_normal end)
-- }}}
