local pl = {}

local json = require'json'
local yaml = require'yaml'

-- Utility Functions

local function unique(parts)
  local hash = {}
  local res = {}
  for _,v in ipairs(parts) do
    if not hash[v] then
      table.insert(res, v)
      hash[v] = true
    end
  end
  return res
end

local function strip_hyphens(parts)
  for i,v in ipairs(parts) do
    if v ~= '-' then
      parts[i] = string.gsub(v, '-', '')
    end
  end
  return parts
end

local function stringify(parts)
  for i,v in ipairs(parts) do
    parts[i] = tostring(v)
  end
  return parts
end

-- Keymaps

pl.Keymap = {}
pl.Keymap.__index = pl.Keymap

function pl.Keymap:new(o)
  local o = o or {}
  setmetatable(o, self)
  o.plain = o.plain or {}
  o.alias = o.alias or {}
  o.implicit_hyphens = o.implicit_hyphens or {}
  return o
end

function pl.Keymap:find(key)
  for i, k in ipairs(self) do
    if k == key then
      return i
    end
  end
  return nil
end

function pl.Keymap:add_keys(keys)
  for _, key in ipairs(keys) do
    table.insert(self, key)
    table.insert(self.plain, key)
    self[key] = key
  end
end

function pl.Keymap:add_aliases(aliases)
  for alias, keys in pairs(aliases) do
    local pos = 0
    for _, k in ipairs(keys) do
      local i = self:find(k)
      if not i then
        error('alias contains keys not in the keymap')
      end
      if i > pos then
        pos = i
      end
    end
    table.insert(self, pos + 1, alias)
    self[alias] = keys
  end
end

function pl.Keymap:add_implicit_hyphens(ihs)
  for _, ih in ipairs(ihs) do
    self.implicit_hyphens[ih] = true
  end
end

function pl.Keymap:has_implicit_hyphen(parts)
  for _,v in ipairs(parts) do
    if self.implicit_hyphens[v] then
      return true
    end
  end
  return false
end

local function split_iter(parts)
  local i = 1
  return function()
    if string.match(parts, '-', i, true) then
      i = i + 1
    end
    local bracket_m, alias_m = string.match(parts, '^(%((%w+)%))', i)
    local char_m = string.match(parts, '^' .. utf8.charpattern, i)
    if bracket_m then
      i = i + #bracket_m
      return alias_m
    elseif char_m then
      i = i + #char_m
      return char_m
    else
      return nil
    end
  end
end

function pl.Keymap:split(part)
  local res = {}
  local last = 0
  for char in split_iter(part) do
    for i = last + 1, #self do
      local k = self[i]
      if string.find(k, char, 1, true) then
        table.insert(res, k)
        last = i
        char = nil
        break
      end
    end

    if char ~= nil then
      error('bad stroke character: ' .. char .. ' in ' .. part)
    end
  end
  return res
end

function pl.Keymap:dealias(parts)
  local res = {}
  for _,v in ipairs(parts) do
    local lookup = self[v]
    if type(lookup) == 'string' then
      -- plain key
      table.insert(res, lookup)
    elseif type(lookup) == 'table' then
      -- aliased key
      for _,key in ipairs(lookup) do
        table.insert(res, key)
      end
    else
      -- compound key
      for _,s in ipairs(self:dealias(self:split(v))) do
        table.insert(res, s)
      end
    end
  end
  return res
end

function pl.Keymap:normalize(parts)
  local p_type = type(parts)
  if p_type == 'number' or p_type == 'string' then
    parts = self:split(tostring(parts))
  end
  if #parts == 0 then
    return ''
  end
  parts = stringify(parts)
  parts = self:dealias(parts)
  parts = unique(parts)
  if not self:has_implicit_hyphen(parts) then
    table.insert(parts, '-')
  end
  local function psort(a, b) return self:find(a) < self:find(b) end
  table.sort(parts, psort)
  parts = strip_hyphens(parts)
  return table.concat(parts)
end

-- Main Keymap

pl.keys = pl.Keymap:new{}

pl.keys:add_keys{
  '§-', '¶-', '#-',
  'S-', 'T-', 'K-', 'P-', 'W-', 'H-', 'R-',
  'A-', 'O-',
  '+-', '-', '*', '-^',
  '-E', '-U',
  '-F', '-R', '-P', '-B', '-L', '-G', '-T', '-S', '-D', '-Z',
}

pl.keys:add_aliases{
  ['D-'] = {'T-', 'K-'},
  ['B-'] = {'P-', 'W-'},
  ['L-'] = {'H-', 'R-'},
  ['F-'] = {'T-', 'P-'},
  ['M-'] = {'P-', 'H-'},
  ['N-'] = {'T-', 'P-', 'H-'},
  ['Y-'] = {'K-', 'W-', 'R-'},
  ['J-'] = {'S-', 'K-', 'W-', 'R-'},
  ['G-'] = {'T-', 'K-', 'P-', 'W-'},
  ['V-'] = {'S-', 'R-'},
  ['Z-'] = {'S-', '*'},
  ['SH-'] = {'S-', 'H-'},
  ['TH-'] = {'T-', 'H-'},
  ['CH-'] = {'K-', 'H-'},

  ['OO-'] = {'O-', '-E'},
  ['EE-'] = {'A-', 'O-', '-E'},
  ['AA-'] = {'A-', '-E', '-U'},
  ['UU-'] = {'A-', 'O-', '-U'},
  ['OI-'] = {'O-', '-E', '-U'},
  ['II-'] = {'A-', 'O-', '-E', '-U'},
  ['-I'] = {'-E', '-U'},

  ['-TH'] = {'*', '-T'},
  ['-N'] = {'-P', '-B'},
  ['-NK'] = {'*', '-P', '-B', '-G'},
  ['-LCH'] = {'-L', '-G'},
  ['-LJ'] = {'-L', '-G'},
  ['-LK'] = {'*', '-L', '-G'},
  ['-CH'] = {'-F', '-P'},
  ['-M'] = {'-P', '-L'},
  ['-MP'] = {'*', '-P', '-L'},
  ['-SH'] = {'-R', '-B'},
  ['-K'] = {'-B', '-G'},
  ['-SHUN'] = {'-G', '-S'},
  ['-KSHUN'] = {'-B', '-G', '-S'},
  ['-RV'] = {'-F', '-R', '-B'},
  ['-RCH'] = {'-F', '-R', '-B', '-P'},
  ['-NCH'] = {'-F', '-R', '-B', '-P'},
  ['-J'] = {'-P', '-B', '-L', '-G'},

  ['1-'] = {'#-', 'S-'},
  ['2-'] = {'#-', 'T-'},
  ['3-'] = {'#-', 'P-'},
  ['4-'] = {'#-', 'H-'},
  ['5-'] = {'#-', 'A-'},
  ['0-'] = {'#-', 'O-'},
  ['6-'] = {'#-', '-F'},
  ['7-'] = {'#-', '-P'},
  ['8-'] = {'#-', '-L'},
  ['9-'] = {'#-', '-T'},
}

pl.keys:add_implicit_hyphens{
  'A-', 'O-', '+-', '*', '-^', '-E', '-U'
}

-- Dictionaries

pl.Dict = {}
pl.Dict.__index = pl.Dict

function pl.Dict:new(o)
  local o = o or {}
  setmetatable(o, self)
  o.entries = {}
  return o
end

function pl.Dict:read_json(fname)
  local f <close> = io.open(fname, 'r')
  if not f then
    error('no such file:' .. fname)
  end
  local entries = json.decode(f:read('a'))
  local dict = pl.Dict:new{}
  for k, s in pairs(entries) do
    dict:add(k, s)
  end
  return dict
end

function pl.Dict:read_yaml(fname)
  local f <close> = io.open(fname, 'r')
  if not f then
    error('no such file:' .. fname)
  end
  local entries = yaml.load(f:read('a'))
  local dict = pl.Dict:new{}
  for k, s in pairs(entries) do
    dict:add(k, s)
  end
  return dict
end

function pl.Dict:write(fname)
  local f <close> = io.open(fname, 'w')
  local entries = json.encode(self.entries, {sort = true})
  f:write(entries)
  f:flush()
end

function pl.Dict:add(stroke, output)
  self.entries[pl.keys:normalize(stroke)] = tostring(output)
end

return pl
