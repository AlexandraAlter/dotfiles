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

gen_lua('numbers', 'out/numbers.json')
gen_lua('symbols', 'out/symbols.json')
gen_lua('modifiers', 'out/modifiers.json')
gen_lua('phrases', 'out/phrases.json')
gen_json('formatting.json', 'out/formatting.json')
gen_json('control.json', 'out/control.json')
gen_yaml('misstrokes.yaml', 'out/misstrokes.json')
gen_yaml('dict.yaml', 'out/dict.json')
