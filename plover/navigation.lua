-- Programatic Navigation
local navigation = {}

local pl = require'plover'
local maths = require'maths'

local pfx = '¶-Z'

local extras = {
  ['FEŚC'] = '{#Escape}',

  ['b-ch'] = '{#BackSpace}',
  ['b*ch'] = '{#BackSpace}',
  ['W*FP'] = '{#BackSpace}',

  ['d*EL'] = '{#Delete}',

  ['TA*B'] = '{#Tab}{^}',
  ['TA*BT'] = '{#Alt_L(Tab Tab)}',

  ['R*R'] = '{#Return}{^}',
  ['SKW-BGS'] = '{#Return}{^}',

  ['STPH-R'] = '{#Left}{^}',
  ['STPH-P'] = '{#Up}{^}',
  ['STPH-B'] = '{#Down}{^}',
  ['STPH-G'] = '{#Right}{^}',
  ['STPH-RB'] = '{#Control_L(Left)}{^}',
  ['STPH-BG'] = '{#Control_L(Right)}{^}',
  ['TPW-R'] = '{#Alt_L(Left)}',
  ['TPW-G'] = '{#Alt_L(Right)}',
  ['SH-FT'] = '{#Control_L(Home)}{^}',
  ['SR-RS'] = '{#Control_L(End)}{^}',

  ['KHR*F'] = '{#Control_L(v)}',
  ['KHR*BG'] = '{#Control_L(k)}',
  ['KHR*T'] = '{#Control_L(w)}',
  ['KHR-BG'] = '{#Control_L(c)}',

  ['KPH*F'] = '{#Super_L(v)}',
  ['KPH*BG'] = '{#Super_L(k)}',
  ['KPH*T'] = '{#Super_L(w)}',
  ['KPH-BG'] = '{#Super_L(c)}',
}

local navs = {
  ['-R']  = 'left',
  ['-P']  = 'up',
  ['-B']  = 'down',
  ['-G']  = 'right',
  ['-FR']  = 'home',
  ['-LG']  = 'end',
  ['-FPL']  = 'page_up',
  ['-RBG']  = 'page_down',
  ['-F']  = 'escape',
  ['-L']  = 'tab',
  ['-FP']  = 'backspace',
  ['-PL']  = 'delete',
  ['-RB']  = 'space',
  ['-BG']  = 'return',
}

-- abuse the factoring code to make modifier masks
local modifier_keys = {
  [1] = 'W-',
  [2] = 'P-',
  [4] = 'R-',
  [8] = 'H-',
}
local modifier_outputs = {
  [1] = 'shift(',
  [2] = 'control(',
  [4] = 'alt(',
  [8] = 'super(',
}

local mods = {}
for i = 0, (4 ^ 2) - 1 do
  local keys = maths.defactor(i, modifier_keys)
  local outputs = maths.defactor(i, modifier_outputs)
  local starts = '{#' .. table.concat(outputs)
  local ends = string.rep(')', #outputs) .. '}{^}'
  mods[pl.keys:normalize(keys)] = {starts, ends}
end

function navigation.build()
  local dict = pl.Dict:new{}

  for mk,mod in pairs(mods) do
    for nk,nav in pairs(navs) do
      local out = mod[1] .. nav .. mod[2]
      dict:add({pfx, mk, nk}, out)
    end
  end

  -- functions via §#
  for i = 1, 12 do
    if i == 11 then
      dict:add({'§#-', '1K'}, '{^}{#F11}{^}')
    else
      dict:add({'§#-', i}, '{^}{#F' .. i .. '}{^}')
    end
  end

  -- functions via -KS or KW-
  for i = 1, 12 do
    if (i > 5 and i < 10) then
      dict:add({'#1KW', i}, '{^}{#F' .. i .. '}{^}')
    elseif i == 11 then
      dict:add({'#-KS', '1K'}, '{^}{#F11}{^}')
    else
      dict:add({'#-KS', i}, '{^}{#F' .. i .. '}{^}')
    end
  end

  for stroke, output in pairs(extras) do
    dict:add(stroke, output)
  end

  return dict
end

return navigation
