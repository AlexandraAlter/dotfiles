-- Programatic modifiers
local modifiers = {}

local pl = require'plover'
local maths = require'maths'

local pfx = '¶-D'
local num_pfx = '¶#-D'
local fun_pfx = '¶#*-D'
local sym_pfx = '¶*-D'

local alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

local overrides = {
  ['C'] = 'CR',
  ['Z'] = 'STKPW',
}

-- same as emily-symbols format, but modified for use on the left hand
local symbols = {
  ['TR'] = {'tab', 'delete', 'backspace', 'escape'},
  ['KPWR'] = {'up', 'left', 'right', 'down'},
  ['KPWHR'] = {'page_up', 'home', 'end', 'page_down'},
  [''] = {'', 'tab', 'return', 'space'},

  -- typable symbols
  ['HR'] = {'exclam', nil, 'notsign', 'exclamdown'},
  ['PH'] = {'quotedbl', nil, nil, nil},
  ['TKHR'] = {'numbersign', 'registered', 'copyright', nil},
  ['KPWH'] = {'dollar', 'euro', 'yen', 'sterling'},
  ['PWHR'] = {'percent', nil, nil, nil},
  ['SKP'] = {'ampersand', nil, nil, nil},
  ['H'] = {'apostrophe', nil, nil, nil},
  ['TPH'] = {'parenleft', 'less', 'bracketleft', 'braceleft'},
  ['KWR'] = {'parenright', 'greater', 'bracketright', 'braceright'},
  ['T'] = {'asterisk', 'section', nil, 'multiply'},
  ['K'] = {'plus', 'paragraph', nil, 'plusminus'},
  ['W'] = {'comma', nil, nil, nil},
  ['TP'] = {'minus', nil, nil, nil},
  ['R'] = {'period', 'periodcentered', nil, nil},
  ['WH'] = {'slash', nil, nil, 'division'},
  ['TK'] = {'colon', nil, nil, nil},
  ['WR'] = {'semicolon', nil, nil, nil},
  ['TKPW'] = {'equal', nil, nil, nil},
  ['TPW'] = {'question', nil, 'questiondown', nil},
  ['TKPWHR'] = {'at', nil, nil, nil},
  ['PR'] = {'backslash', nil, nil, nil},
  ['KPR'] = {'asciicircum', 'guillemotleft', 'guillemotright', 'degree'},
  ['KW'] = {'underscore', nil, nil, 'mu'},
  ['P'] = {'grave', nil, nil, nil},
  ['PW'] = {'bar', nil, nil, 'brokenbar'},
  ['TPWR'] = {'asciitilde', nil, nil, nil},
}

local variants = {
  [''] = 1,
  ['A'] = 2,
  ['O'] = 3,
  ['AO'] = 4,
}

local number_keys = {
  [1] = 'R-',
  [2] = 'W-',
  [4] = 'K-',
  [8] = 'S-',
}

local numbers = {}
for i = 0, 9 do
  local keys = maths.defactor(i, number_keys)
  numbers[pl.keys:normalize(keys)] = i
end

local functions = {}
for i = 1, 12 do
  local keys = maths.defactor(i, number_keys)
  functions[pl.keys:normalize(keys)] = 'F' .. i
end

-- abuse the factoring code to make modifier masks
local modifier_keys = {
  [1] = '-R',
  [2] = '-F',
  [4] = '-B',
  [8] = '-P',
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
  local ends = string.rep(')', #outputs) .. '}'
  mods[pl.keys:normalize(keys)] = {starts, ends}
end

function modifiers.build()
  local dict = pl.Dict:new{}

  for mk,mod in pairs(mods) do
    for char in string.gmatch(alpha, '.') do
      if not overrides[char] then
        local out = mod[1] .. string.lower(char) .. mod[2]
        dict:add({pfx, mk, char}, out)
      end
    end

    for char, override in pairs(overrides) do
      local out = mod[1] .. string.lower(char) .. mod[2]
      dict:add({pfx, mk, override}, out)
    end

    for sk,sym in pairs(symbols) do
      for vk,var in pairs(variants) do
        local v = sym[var]
        if v ~= nil then
          local out = mod[1] .. sym[var] .. mod[2]
          dict:add({sym_pfx, mk, sk, vk}, out)
        end
      end
    end

    for nk,num in pairs(numbers) do
      local out = mod[1] .. num .. mod[2]
      dict:add({num_pfx, mk, nk}, out)
    end

    for fk,fun in pairs(functions) do
      local out = mod[1] .. fun .. mod[2]
      dict:add({fun_pfx, mk, fk}, out)
    end
  end

  return dict
end

return modifiers
