local pl = {}

local json = require'json'
local yaml = require'yaml'
local inspect = require'inspect'

-- Utility Functions

local function unique(stroke)
  local hash = {}
  local res = {}
  for _,v in ipairs(stroke) do
    if not hash[v] then
      table.insert(res, v)
      hash[v] = true
    end
  end
  return res
end

local function strip_hyphens(stroke)
  for i,v in ipairs(stroke) do
    if v ~= '-' then
      stroke[i] = string.gsub(v, '-', '')
    end
  end
  return stroke
end

local function count_non_hyphens(stroke)
  local non_hyphens = string.gsub(stroke, '-', '')
  return utf8.len(non_hyphens)
end

local function sort_non_hyphens(a, b)
  return count_non_hyphens(a) < count_non_hyphens(b)
end

local function sort_non_hyphens_reverse(a, b)
  return sort_non_hyphens(b, a)
end

local function partition(stroke)
  local res = {}
  local tail = {}
  table.insert(res, tail)
  for i, v in ipairs(stroke) do
    if v == '/' then
      tail = {}
      table.insert(res, tail)
    else
      table.insert(tail, v)
    end
  end
  return res
end

local function stringify(stroke)
  for i, v in ipairs(stroke) do
    stroke[i] = tostring(v)
  end
  return stroke
end

-- Keymaps

pl.Keymap = {}
pl.Keymap.__index = pl.Keymap

function pl.Keymap:new(o)
  local o = o or {}
  setmetatable(o, self)
  o.plain = o.plain or {}
  o.symbolic = o.symbolic or {}
  o.alias = o.alias or {}
  o.implicit_hyphens = o.implicit_hyphens or {}
  o['/'] = '/'
  o.plain['/'] = true
  return o
end

function pl.Keymap:find_hyphen(init)
  init = init or 0
  for i = init, #self do
    local k = self[i]
    if k == '-' or self.implicit_hyphens[k] then
      return i
    end
  end
  error('no hyphen, implicit or otherwise')
end

function pl.Keymap:find_raw(key)
  for i, k in ipairs(self) do
    if k == key then
      return i
    end
  end
  return nil
end

function pl.Keymap:find(key)
  if key == '-' then
    return self:find_hyphen()
  else
    return self:find_raw(key)
  end
end

function pl.Keymap:find_fuzzy(key, init)
  init = init or 1
  local pattern = '^%-?' .. key .. '%-?$'
  for i = init, #self do
    local k = self[i]
    if string.match(k, pattern) then
      return i, k
    end
  end
  return nil
end

function pl.Keymap:add_keys(keys)
  for _, key in ipairs(keys) do
    table.insert(self, key)
    self.plain[key] = true
    self[key] = key
  end
end

-- this is a bit of a hack for problems with ordering
-- plain keys considered 'symbolic' are ignored when
-- working out where aliases place in the key list
function pl.Keymap:add_symbolics(syms)
  for _, sym in ipairs(syms) do
    self.symbolic[sym] = true
  end
end

-- TODO actually use this
function pl.Keymap:add_feral(ferals)
  for _, feral in ipairs(ferals) do
    self.ferals[feral] = true
  end
end

function pl.Keymap:add_implicit_hyphens(ihs)
  for _, ih in ipairs(ihs) do
    self.implicit_hyphens[ih] = true
  end
end

function pl.Keymap:add_aliases(aliases)
  -- aliases that are subsets of each used to cause problems
  -- shorter aliases must come first, for aesthetics
  local alias_list = {}
  for alias, _ in pairs(aliases) do
    table.insert(alias_list, alias)
  end
  table.sort(alias_list, sort_non_hyphens)

  for _, alias in ipairs(alias_list) do
    local a_keys = aliases[alias]
    local pos = 0
    for _, k in ipairs(a_keys) do
      local i = self:find(k)
      if not i then
        error('alias contains keys not in the keymap')
      end
      if i > pos and not self.symbolic[k] then
        pos = i
      end
    end

    table.insert(self, pos, alias)
    self[alias] = a_keys
    self.alias[alias] = true
  end
end

function pl.Keymap:contains_implicit_hyphen(parts)
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
    if char == '/' then
      table.insert(res, char)
      last = 0
    elseif char == '-' then
      last = self:find_hyphen() - 1
    else
      local i, match = self:find_fuzzy(char, last + 1)
      if i == nil then
        error('bad stroke character: ' .. char .. ' in ' .. part)
      else
        table.insert(res, match)
        last = i
      end
    end
  end
  return res
end

function pl.Keymap:dealias(parts)
  local res = {}
  for _,v in ipairs(parts) do
    if self.plain[v] then
      -- plain key or split
      table.insert(res, self[v])
    elseif self.alias[v] then
      -- aliased key
      for _,key in ipairs(self[v]) do
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

function pl.Keymap:sort_keys_f(k1, k2)
  return function (k1, k2)
    return self:find(k1) < self:find(k2)
  end
end

function pl.Keymap:normalize(strokes)
  local s_type = type(strokes)
  if s_type == 'number' or s_type == 'string' then
    strokes = self:split(tostring(strokes))
  end
  if #strokes == 0 then
    return ''
  end
  strokes = partition(strokes)
  for i, stroke in ipairs(strokes) do
    stroke = stringify(stroke)
    stroke = self:dealias(stroke)
    stroke = unique(stroke)
    if not self:contains_implicit_hyphen(stroke) then
      table.insert(stroke, '-')
    end
    table.sort(stroke, self:sort_keys_f())
    stroke = strip_hyphens(stroke)
    stroke = table.concat(stroke)
    strokes[i] = stroke
  end
  return table.concat(strokes, '/')
end

-- Main Keymap

pl.keys = pl.Keymap:new{}

pl.keys:add_keys{
  '§-', '¶-', '#-',
  'S-', 'T-', 'K-', 'P-', 'W-', 'H-', 'R-',
  'A-', 'O-',
  '+-', '*', '-^',
  '-E', '-U',
  '-F', '-R', '-P', '-B', '-L', '-G', '-T', '-S', '-D', '-Z',
}

pl.keys:add_symbolics{
  '§-', '¶-', '#-', '+-', '*', '-^',
}

pl.keys:add_implicit_hyphens{
  'A-', 'O-', '+-', '*', '-^', '-E', '-U',
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
  ['Q-'] = {'K-', 'W-'}, -- fingerspelling only?
  ['X-'] = {'K-', 'P-'}, -- fingerspelling only?
  ['V-'] = {'S-', 'R-'},
  ['Z-'] = {'S-', '*'},
  ['SH-'] = {'S-', 'H-'},
  ['TH-'] = {'T-', 'H-'},
  ['CH-'] = {'K-', 'H-'},
  ['C-'] = {'K-'}, -- shortcut only

  ['-I'] = {'-E', '-U'},
  ['Ā'] = {'A-', '-E', '-U'},
  ['Ē'] = {'A-', 'O-', '-E'},
  ['Ī'] = {'A-', 'O-', '-E', '-U'},
  ['Ō'] = {'O-', '-E'},
  ['Ū'] = {'A-', 'O-', '-U'},
  ['EW'] = {'A-', 'O-', '-U'},
  ['AW'] = {'A-', '-U'},
  ['OI'] = {'O-', '-E', '-U'},
  ['OW'] = {'O-', '-U'},
  ['EA'] = {'A-', '-E'},
  ['OA-'] = {'A-', 'O-'},
  ['OO-'] = {'A-', 'O-'},

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
  ['-X'] = {'-B', '-G', '-S'},
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
  ['-6'] = {'#-', '-F'},
  ['-7'] = {'#-', '-P'},
  ['-8'] = {'#-', '-L'},
  ['-9'] = {'#-', '-T'},
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
  local norm = pl.keys:normalize(stroke)
  if not self.entries[norm] then
    self.entries[norm] = tostring(output)
  else
    local s = inspect(stroke) .. ' -> ' .. norm .. '\n'
    local o_o = 'old: ' .. inspect(self.entries[norm])
    local o_n = 'new: ' .. inspect(output)
    local o = o_o .. ' ' .. o_n
    print('warn: duplicate stroke: ' .. s .. o)
  end
end

return pl
