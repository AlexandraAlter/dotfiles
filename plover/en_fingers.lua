-- Individual English letters
local fingers_en = {}

local pl = require'plover'

local alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

local overrides = {
  ['C'] = 'KR',
  ['CH'] = 'KH',
  ['Z'] = 'STKPW',
}

function fingers_en.build_one(dict, stroke, char)
    local upper = string.format('{&%s}', char)
    local lower = '{>}' .. string.lower(upper)
    local dashed = string.format('{^-%s}', char)
    dict:add({stroke, '*P'}, upper)
    dict:add({stroke, '*'}, lower)
    dict:add({stroke, '-RBGZ'}, dashed)
end

function fingers_en.build()
  local dict = pl.Dict:new{}

  for char in string.gmatch(alpha, '.') do
    if not overrides[char] then
      fingers_en.build_one(dict, char, char)
    end
  end

  for char, override in pairs(overrides) do
    fingers_en.build_one(dict, overrides[char], char)
  end

  return dict
end

return fingers_en
