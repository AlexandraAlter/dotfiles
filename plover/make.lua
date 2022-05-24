-- AlexandraAlter's Plover Dictionaries

local pl = require'plover'

local function gen_lua(mod_n, out_f)
  print('Lua: ' .. mod_n .. ' > ' .. out_f)
  local mod = require(mod_n)
  mod.build():write(out_f)
end

local function gen_json(in_f, out_f)
  print('JSON: ' .. in_f .. ' > ' .. out_f)
  pl.Dict:read_json(in_f):write(out_f)
end

local function gen_yaml(in_f, out_f)
  print('YAML: ' .. in_f .. ' > ' .. out_f)
  pl.Dict:read_yaml(in_f):write(out_f)
end

gen_yaml('control.yaml', 'out/control.json')
gen_yaml('formatting.yaml', 'out/formatting.json')
gen_lua('fingerspelling', 'out/fingerspelling.json')
gen_lua('numbers', 'out/numbers.json')
gen_lua('modifiers', 'out/modifiers.json')
gen_yaml('navigation.yaml', 'out/navigation.json')
gen_yaml('tabbing.yaml', 'out/tabbing.json')
gen_yaml('shortcuts.yaml', 'out/shortcuts.json')
gen_lua('symbols', 'out/symbols.json')
gen_yaml('punctuation.yaml', 'out/punctuation.json')
gen_lua('phrases', 'out/phrases.json')
gen_yaml('misstrokes.yaml', 'out/misstrokes.json')
gen_yaml('dict.yaml', 'out/dict.json')
