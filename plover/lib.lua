
local json = require'json'

local keys = {
  '§-', '¶-', '#-',
  'S-', 'T-', 'K-', 'P-', 'W-', 'H-', 'R-',
  'A-', 'O-',
  '+-', '-', '*', '-^',
  '-E', '-U',
  '-F', '-R', '-P', '-B', '-L', '-G', '-T', '-S', '-D', '-Z',
}

-- keys with 1-long aliases
local keys_1alias = {
  '§-', '¶-', '#-',
  'S-', 'J-', 'V-', 'Z-',
  'T-', 'D-', 'F-', 'N-', 'G-',
  'K-', 'Y-',
  'P-', 'B-', 'M-',
  'W-',
  'H-', 'L-',
  'R-',

  'A-',
  'O-',
  '+-', '-', '*', '-^',
  '-E', '-I',
  '-U',

  '-F',
  '-R',
  '-P', '-N', '-M', '-J',
  '-B', '-K',
  '-L',
  '-G',
  '-T',
  '-S',
  '-D',
  '-Z',
}

local implicit_hyphen_keys = {'A-', 'O-', '+-', '*', '-^', '-E', '-U'}

local aliases = {
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

function is_implicit_hyphen(part)
  for _,m in ipairs(implicit_hyphen_keys) do
    if part == m then
      return true
    end
  end
  return false
end

function has_implicit_hyphen(parts)
  for _,v in ipairs(parts) do
    if is_implicit_hyphen(v) then
      return true
    end
  end
  return false
end

function split(part)
  local res = {}
  local last = 0
  for p,c in utf8.codes(part) do
    --local char = string.sub(part, i, i)
    local char = utf8.char(c)

    if char == '-' then
      last = index(keys_1alias, '*')
      goto continue
    end

    for i = last + 1, #keys_1alias do
      local k = keys_1alias[i]
      if string.find(k, char, 1, true) then
        last = i
        table.insert(res, k)
        goto continue
      end
    end

    error('bad stroke character: ' .. char .. ' in ' .. part)

    ::continue::
  end

  return res
end

function dealias(parts)
  local res = {}
  for _,v in ipairs(parts) do
    if aliases[v] then
      -- aliased key
      for _,a in ipairs(aliases[v]) do
        table.insert(res, a)
      end
    elseif index(keys, v) then
      -- plain key
      table.insert(res, v)
    else
      -- compound key
      for _,s in ipairs(split(v)) do
        if aliases[s] then
          -- aliased split
          for _,a in ipairs(aliases[s]) do
            table.insert(res, a)
          end
        else
          -- plain split
          table.insert(res, s)
        end
      end
    end
  end
  return res
end

function unique(parts)
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

function strip_hyphens(parts)
  for i,v in ipairs(parts) do
    if v ~= '-' then
      parts[i] = string.gsub(v, '-', '')
    end
  end
  return parts
end

function index(tbl, val)
  for i,v in ipairs(tbl) do
    if v == val then
      return i
    end
  end
  return nil
end

function normalize(parts)
  if type(parts) == 'string' then
    parts = split(parts)
  end
  if #parts == 0 then
    return ''
  end
  parts = dealias(parts)
  parts = unique(parts)
  if not has_implicit_hyphen(parts) then
    table.insert(parts, '-')
  end
  table.sort(parts, function (a, b) return index(keys, a) < index(keys, b) end)
  parts = strip_hyphens(parts)
  return table.concat(parts)
end

Dict = {}
Dict.__index = Dict

function Dict:new(o)
  local o = o or {}
  setmetatable(o, self)
  o.entries = {}
  return o
end

function Dict:add(stroke, output)
  self.entries[normalize(stroke)] = output
end

function Dict:write(file)
  local entries = json.encode(self.entries)
  file:write(entries)
  file:flush()
end

