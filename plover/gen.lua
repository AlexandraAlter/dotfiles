#!/usr/bin/env lua
-- AlexandraAlter's Plover Dictionaries
package.path = package.path .. ';./lib/?.lua'
package.cpath = package.cpath .. ';./lib/?.so'

local pl = require'plover'
local files = require'files'
local inspect = require'inspect'

local help = [[
Usage: gen.lua ...
Generate Plover dictionaries from Lua, JSON, or YAML.

  -h, --help          Print help
  -p, --print         Print the keymap
  -n, --no-defaults   Do not include default dictionaries
  -o, --output        Specify an output folder (defaults to 'out')
]]

local handlers = {}

function handlers.lua(mod_n, out_f)
  local mod = require(mod_n:gsub('%.lua$', ''))
  mod.build():write(out_f)
end

function handlers.json(in_f, out_f)
  pl.Dict:read_json(in_f):write(out_f)
end

function handlers.yaml(in_f, out_f)
  pl.Dict:read_yaml(in_f):write(out_f)
end

local defaults = {
  'fingerspelling.lua',
  'numbers.lua',
  'symbols.lua',
  'modifiers.lua',
  'phrases.lua',
  'control.yaml',
  'formatting.yaml',
  'navigation.yaml',
  'tabbing.yaml',
  'shortcuts.yaml',
  'punctuation.yaml',
  'misstrokes.yaml',
  'dict.yaml',
}

local use_defaults = true
local output_folder = nil
local dicts = {}

local i = 1
while i <= #arg do
  local this = arg[i]
  local nextthis = arg[i + 1]
  i = i + 1
  if this == '-h' or this == '--help' then
    print(help)
    os.exit()
  elseif this == '-p' or this == '--print' then
    print(inspect(pl.keys))
    os.exit()
  elseif this == '-n' or this == '--no-defaults' then
    use_defaults = false
  elseif this == '-o' or this == '--output' then
    output_folder = nextthis
    i = i + 1
  else
    table.insert(dicts, this)
  end
end

if use_defaults then
  for _, dict in ipairs(defaults) do
    table.insert(dicts, dict)
  end
end

if output_folder == nil then
  error('no output folder')
end

for _, dict in ipairs(dicts) do
  local ext = files.get_extension(dict)
  local out_f_end = files.replace_extension(files.get_filename(dict), 'json')
  local out_f = output_folder .. '/' .. out_f_end
  local handler = handlers[ext]
  if not handler then
    error('no handler capable of handling: ' .. dict)
  end
  print('writing ' .. dict .. ' to ' .. out_f)
  handler(dict, out_f)
end

