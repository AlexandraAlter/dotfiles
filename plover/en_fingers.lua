-- Individual English Letters
local fingers_en = {}

local pl = require'plover'

local norm_alpha = 'ABDEFGHIJKLMNOPQRSTUVWXY'

local overrides = {
  ['KR'] = 'C',
  ['KH'] = 'Ch',
  ['TKPWHR'] = 'Gl',
  ['SH'] = 'Sh',
  ['TH'] = 'Th',
  ['STKPW'] = 'Z',
  ['SAOE'] = 'Z',
}

function fingers_en.build_one(dict, stroke, char)
  local lchar = string.lower(char)

  dict:add({stroke, '*', '/SP-S'}, lchar)

  local upper = string.format('{&%s}', char)
  dict:add({stroke, '*P'}, upper)
  dict:add({stroke, '*DZ'}, upper)

  local u_dot = string.format('{&%s.}', char)
  dict:add({stroke, '*FPLT'}, u_dot)

  local dash_u = string.format('{^-%s}', char)
  dict:add({stroke, '-RBGZ'}, dash_u)

  local lower = string.format('{>}{&%s}', lchar)
  dict:add({stroke, '*'}, lower)
  dict:add({stroke, '#*'}, lower)
  dict:add({stroke, '*RBGS'}, lower)
  dict:add({stroke, '-RBGS'}, lower)

  local dot_l = string.format('{&.%s}', lchar)
  dict:add({stroke, '*PLD'}, dot_l)
  dict:add({stroke, '*PD'}, dot_l)

  local l_dash = string.format('{&.%s}', lchar)
  dict:add({stroke, '-PLT'}, l_dash)
  dict:add({stroke, '-FPL'}, l_dash)
end

function fingers_en.build()
  local dict = pl.Dict:new{}

  for char in string.gmatch(norm_alpha, '.') do
    fingers_en.build_one(dict, char, char)
  end

  for override, char in pairs(overrides) do
    fingers_en.build_one(dict, override, char)
  end

  return dict
end

return fingers_en
