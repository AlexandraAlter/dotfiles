local numbers = {}

local pl = require'plover'

function numbers.build()
  local dict = pl.Dict:new{}

  for i = 0, 9 do
    dict:add({'#-', i}, i)
  end

  for i = 0, 9 do
    for j = i, 9 do
      if i ~= j then
        dict:add({'#-', i, j}, i .. j)
        dict:add({'#-', i, j, '-E', '-U'}, j .. i)
      else
        dict:add({'#-', i, '-D'}, i .. i)
      end
    end
  end

  for i = 0, 9 do
    local th = 'th'
    if i == 1 then
      th = 'st'
    elseif i == 2 then
      th = 'nd'
    elseif i == 3 then
      th = 'rd'
    end
    dict:add({'#-', i, '*', '-T'}, i .. th)
  end

  return dict
end

return numbers
