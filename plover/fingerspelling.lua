local fingerspelling = {}

local pl = require'plover'

local alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

local overrides = {
  ['C'] = 'KR',
  ['CH'] = 'KH',
  ['Z'] = 'STKPW',
}

function fingerspelling.build()
  local dict = pl.Dict:new{}

  for char in string.gmatch(alpha, '.') do
    local upper = string.format('{&%s}', char)
    local lower = '{>}' .. string.lower(upper)
    if not overrides[char] then
      dict:add({'*P', char}, upper)
      dict:add({'*', char}, lower)
    end
  end

  for char, override in pairs(overrides) do
    local upper = string.format('{&%s}', char)
    local lower = '{>}' .. string.lower(upper)
    dict:add({'*P', overrides[char]}, upper)
    dict:add({'*', overrides[char]}, lower)
  end

  return dict
end

return fingerspelling
