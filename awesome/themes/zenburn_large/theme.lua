-------------------------------------------
--        'Zenburn' awesome theme        --
--          By Adrian C. (anrxc)         --
--  Modified slightly by AlexandraAlter  --
-------------------------------------------

local fs = require('gears.filesystem')
local themes_path = fs.get_configuration_dir() .. 'themes/'
local dpi = require('beautiful.xresources').apply_dpi
local protected_call = require('gears.protected_call')

-- {{{ Main
local theme = protected_call(dofile, fs.get_themes_dir() .. 'zenburn/theme.lua')
-- }}}

-- {{{ Styles
theme.font = 'Source Code Pro 9'
theme.notification_icon_size = 32

-- {{{ Colors
theme.bg_focus, theme.bg_normal = theme.bg_normal, theme.bg_focus
theme.bg_urgent  = theme.bg_normal
-- }}}

-- {{{ Borders
-- }}}

-- {{{ Titlebars
theme.titlebar_bg = theme.bg_normal
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Windowbars
theme.wibar_height = dpi(22)
-- }}}
-- }}}

-- {{{ Widgets
-- }}}

-- {{{ Mouse finder
-- }}}

-- {{{ Menu
-- }}}

-- {{{ Icons
-- {{{ Taglist
-- }}}

-- {{{ Misc
-- }}}

-- {{{ Layout
theme.lain_icons         = fs.get_configuration_dir() .. 'lain/icons/layout/default/'
theme.layout_termfair    = theme.lain_icons .. 'termfair.png'
theme.layout_centerfair  = theme.lain_icons .. 'centerfair.png'
theme.layout_cascade     = theme.lain_icons .. 'cascade.png'
theme.layout_cascadetile = theme.lain_icons .. 'cascadetile.png'
theme.layout_centerwork  = theme.lain_icons .. 'centerwork.png'
theme.layout_centerworkh = theme.lain_icons .. 'centerworkh.png'
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = themes_path .. 'zenburn_large/titlebar/close_focus.png'
theme.titlebar_close_button_normal = themes_path .. 'zenburn_large/titlebar/close_normal.png'

theme.titlebar_ontop_button_focus_active  = themes_path .. 'zenburn_large/titlebar/ontop_focus_active.png'
theme.titlebar_ontop_button_normal_active = themes_path .. 'zenburn_large/titlebar/ontop_normal_active.png'
theme.titlebar_ontop_button_focus_inactive  = themes_path .. 'zenburn_large/titlebar/ontop_focus_inactive.png'
theme.titlebar_ontop_button_normal_inactive = themes_path .. 'zenburn_large/titlebar/ontop_normal_inactive.png'

theme.titlebar_sticky_button_focus_active  = themes_path .. 'zenburn_large/titlebar/sticky_focus_active.png'
theme.titlebar_sticky_button_normal_active = themes_path .. 'zenburn_large/titlebar/sticky_normal_active.png'
theme.titlebar_sticky_button_focus_inactive  = themes_path .. 'zenburn_large/titlebar/sticky_focus_inactive.png'
theme.titlebar_sticky_button_normal_inactive = themes_path .. 'zenburn_large/titlebar/sticky_normal_inactive.png'

theme.titlebar_floating_button_focus_active  = themes_path .. 'zenburn_large/titlebar/floating_focus_active.png'
theme.titlebar_floating_button_normal_active = themes_path .. 'zenburn_large/titlebar/floating_normal_active.png'
theme.titlebar_floating_button_focus_inactive  = themes_path .. 'zenburn_large/titlebar/floating_focus_inactive.png'
theme.titlebar_floating_button_normal_inactive = themes_path .. 'zenburn_large/titlebar/floating_normal_inactive.png'

theme.titlebar_maximized_button_focus_active  = themes_path .. 'zenburn_large/titlebar/maximized_focus_active.png'
theme.titlebar_maximized_button_normal_active = themes_path .. 'zenburn_large/titlebar/maximized_normal_active.png'
theme.titlebar_maximized_button_focus_inactive  = themes_path .. 'zenburn_large/titlebar/maximized_focus_inactive.png'
theme.titlebar_maximized_button_normal_inactive = themes_path .. 'zenburn_large/titlebar/maximized_normal_inactive.png'
-- }}}
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
