local pl = {}

local json = require'json'
local yaml = require'yaml'
local inspect = require'inspect'

-- delimiter for multiple strokes
local STROKE_SPLIT = '/'
-- delimiter for breaks between lower-cased aliases
local STROKE_BREAK = '.'
-- delimiter for left-right keys
local STROKE_DASH = '-'

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

local function strip_dashes(stroke)
  for i,v in ipairs(stroke) do
    if v ~= STROKE_DASH then
      stroke[i] = string.gsub(v, STROKE_DASH, '')
    end
  end
  return stroke
end

local function count_non_dashes(stroke)
  local non_dashes = string.gsub(stroke, STROKE_DASH, '')
  return utf8.len(non_dashes)
end

local function sort_non_dashes(a, b)
  return count_non_dashes(a) < count_non_dashes(b)
end

local function sort_non_dashes_reverse(a, b)
  return sort_non_dashes(b, a)
end

local function partition(stroke)
  local res = {}
  local tail = {}
  table.insert(res, tail)
  for i, v in ipairs(stroke) do
    if v == STROKE_SPLIT then
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
  o.macro = o.macro or {}
  o.alias = o.alias or {}
  o.implicit_dashes = o.implicit_dashes or {}
  o[STROKE_SPLIT] = STROKE_SPLIT
  o.plain[STROKE_SPLIT] = true
  return o
end

function pl.Keymap:find_dash(init)
  init = init or 0
  for i = init, #self do
    local k = self[i]
    if k == STROKE_DASH or self.implicit_dashes[k] then
      return i
    end
  end
  error('no dash, implicit or otherwise')
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
  if key == STROKE_DASH then
    return self:find_dash()
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

function pl.Keymap:add_implicit_dashes(ihs)
  for _, ih in ipairs(ihs) do
    self.implicit_dashes[ih] = true
  end
end

function pl.Keymap:add_aliases(aliases)
  -- turn table-keyed entries into duplicate entries
  for k, v in pairs(aliases) do
    if type(k) == 'table' then
      for _, sk in ipairs(k) do
        aliases[sk] = v
      end
    end
  end
  for k, _ in pairs(aliases) do
    if type(k) == 'table' then
      aliases[k] = nil
    end
  end

  -- aliases that are subsets of each used to cause problems
  -- shorter aliases must come first, for aesthetics
  local alias_list = {}
  for alias, _ in pairs(aliases) do
    table.insert(alias_list, alias)
  end
  table.sort(alias_list, sort_non_dashes)

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

function pl.Keymap:contains_implicit_dash(parts)
  for _,v in ipairs(parts) do
    if self.implicit_dashes[v] then
      return true
    end
  end
  return false
end

local function split_iter(parts)
  local i = 1
  return function()
    local bracket_m, alias_m = string.match(parts, '^(%((%w+)%))', i)
    local lower_m = string.match(parts, '^%l+', i)
    local char_m = string.match(parts, '^' .. utf8.charpattern, i)
    if bracket_m then
      i = i + #bracket_m
      return alias_m
    elseif lower_m then
      i = i + #lower_m
      return string.upper(lower_m)
    elseif char_m then
      i = i + #char_m
      return char_m
    else
      return nil
    end
  end
end

-- break a string stroke up into its parts
function pl.Keymap:split(part)
  local res = {}
  local last = 0
  for char in split_iter(part) do
    if char == STROKE_SPLIT then
      table.insert(res, char)
      last = 0
    elseif char == STROKE_DASH then
      last = self:find_dash() - 1
    elseif char == STROKE_BREAK then
      -- do nothing
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

function pl.Keymap:repartition(strokes)
  local s_type = type(strokes)
  if s_type == 'number' or s_type == 'string' then
    return self:split(tostring(strokes))
  else
    local res = {}
    for _, v in ipairs(strokes) do
      local sp = self:split(tostring(v))
      for _, spv in ipairs(sp) do
        table.insert(res, spv)
      end
    end
    return res
  end
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
  strokes = self:repartition(strokes)
  if #strokes == 0 then
    return ''
  end
  strokes = partition(strokes)
  for i, stroke in ipairs(strokes) do
    stroke = stringify(stroke)
    stroke = self:dealias(stroke)
    stroke = unique(stroke)
    if not self:contains_implicit_dash(stroke) then
      table.insert(stroke, STROKE_DASH)
    end
    table.sort(stroke, self:sort_keys_f())
    stroke = strip_dashes(stroke)
    stroke = table.concat(stroke)
    strokes[i] = stroke
  end
  return table.concat(strokes, STROKE_SPLIT)
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

pl.keys:add_implicit_dashes{
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
  [{'Ū', 'EW'}] = {'A-', 'O-', '-U'},
  ['AW'] = {'A-', '-U'},
  ['OI'] = {'O-', '-E', '-U'},
  ['OW'] = {'O-', '-U'},
  ['EA'] = {'A-', '-E'},
  [{'OA-', 'OO-'}] = {'A-', 'O-'},

  ['-TH'] = {'*', '-T'},
  ['-N'] = {'-P', '-B'},
  ['-NK'] = {'*', '-P', '-B', '-G'},
  [{'-LCH', '-LJ'}] = {'-L', '-G'},
  ['-LK'] = {'*', '-L', '-G'},
  ['-CH'] = {'-F', '-P'},
  ['-M'] = {'-P', '-L'},
  ['-MP'] = {'*', '-P', '-L'},
  ['-SH'] = {'-R', '-B'},
  ['-K'] = {'-B', '-G'},
  ['-SHUN'] = {'-G', '-S'},
  [{'-KSHUN', '-X'}] = {'-B', '-G', '-S'},
  ['-RV'] = {'-F', '-R', '-B'},
  [{'-RCH', '-NCH'}] = {'-F', '-R', '-P', '-B'},
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

function pl.Dict:add_table(tbl, stack)
  stack = stack or {}
  local at_top = #stack == 0
  if not at_top then
    table.insert(stack, STROKE_SPLIT)
  end
  for stroke, subval in pairs(tbl) do
    if stroke == '' then
      -- special case for keyless strokes
      if at_top then
        error('blank key at top of table')
      end
      table.remove(stack)
      self:add(stack, subval)
      table.insert(stack, STROKE_SPLIT)
    else
      table.insert(stack, stroke)
      if type(subval) == 'table' then
        -- recurse into the inner table
        self:add_table(subval, stack)
      elseif type(subval) == 'string' then
        -- regular stroke
        self:add(stack, subval)
      else
        local loc = inspect(stack) .. stroke
        error('unexpected type at: ' .. loc)
      end
      table.remove(stack)
    end
  end
  if not at_top then
    table.remove(stack)
  end
end

function pl.Dict:read_yaml(fname)
  local f <close> = io.open(fname, 'r')
  if not f then
    error('no such file:' .. fname)
  end
  local top = yaml.load(f:read('a'))
  if type(top) ~= 'table' then
    error('yaml document is not a hash')
  end
  local dict = pl.Dict:new{}
  dict:add_table(top)
  return dict
end

function pl.Dict:read_json(fname)
  local f <close> = io.open(fname, 'r')
  if not f then
    error('no such file:' .. fname)
  end
  local top = json.decode(f:read('a'))
  if type(top) ~= 'table' then
    error('json document is not a hash')
  end
  local dict = pl.Dict:new{}
  dict:add_table(top)
  return dict
end

function pl.Dict:write(fname)
  local f <close> = io.open(fname, 'w')
  local entries = json.encode(self.entries, {sort = true})
  f:write(entries)
  f:flush()
end

return pl