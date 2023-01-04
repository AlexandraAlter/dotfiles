-- Programatic navigation
local navigation = {}

local pl = require'plover'

local pfx = '¶-Z'

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

local factors = {8, 4, 2, 1}
local function defactor(num, lookup)
  local res = {}
  local i = num
  for _,f in ipairs(factors) do
    if f <= i then
      table.insert(res, lookup[f])
      i = i - f
    end
  end
  if i ~= 0 then
    error('could not factor number: ' .. num)
  end
  return res
end

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
  local keys = defactor(i, modifier_keys)
  local outputs = defactor(i, modifier_outputs)
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

  return dict
end

return navigation
