-- Programatic Numbers/Times/Etc
local numbers = {}

local pl = require'plover'

local extras = {
  -- glued
  ['0D'] = '{&00}',
  ['0Z'] = '{&00}',
  ['THUZ'] = '{&000}',
  -- prefixes
  ['TWow.n'] = '{200^}',
  ['TPWow.n'] = '{200^}',
  -- suffixes
  ['HUNZ'] = '{^00}',
  ['HUN/HUN'] = '{^00}',
  ['THO*EUPB'] = '{^,000}',
  ['KHR-PL'] = '{^:00}',
  ['KH-PL'] = '{^:00}',
  ['KHREURT'] = '{:}30',
  -- spelled numbers
  ['TPHUPBZ'] = '100',
  ['TPHEFPBT'] = '197',
  ['TPHAEUPBT'] = '198',
  ['TPHOUZ'] = '1,000',
  ['1/THOEUB'] = '1,000',
  ['1/THO*EUPB'] = '1,000',
  ['TPHEFPBD'] = '1970',
  ['TPHAEUPBD'] = '1980',
  ['TPHEUPBD'] = '1990',
  ['TWOUZ'] = '2000',
  ['PWOUPBD'] = '2000',
}

local num_order = { 1, 2, 3, 4, 5, 0, 6, 7, 8, 9 }

function numbers.build()
  local dict = pl.Dict:new{}

  for i = 0, 9 do
    dict:add({'#-', i}, i)
    dict:add({'#-', i, '-D'}, i .. i)
    dict:add({'#-', i, '-Z'}, i .. '00')
    dict:add({'#-', i, '/', 'W-B', '/', 'THUS'}, i .. ',000')
    dict:add({'#-', i, '/', 'PERS'}, i .. '0%')
    dict:add({'#-', i, 0, 'S'}, '{&' .. i .. '0}{^s}')
    dict:add({'#-', i, 'DZ'}, '$' .. i .. '00')
    if i < 6 then
      dict:add({'#-', i, 'RBGS'}, '{&' .. i .. '}')
      dict:add({'#-', i, 0, 'S'}, '{&' .. i .. '0}{^s}')
    else
      dict:add({'#-', i, 'SKWR'}, '{&' .. i .. '}')
      dict:add({'#-', i, 0, 'EUS'}, '{&' .. i .. '0}{^s}')
    end
  end

  for i = 0, 9 do
    local ni = num_order[i]
    for j = i+1, 9 do
      local nj = num_order[j]
      dict:add({'#-', ni, nj}, ni .. nj)
      dict:add({'#-', ni, nj, '-E', '-U'}, nj .. ni)
      for k = j+1, 9 do
        local nk = num_order[k]
        dict:add({'#-', ni, nj, nk}, ni .. nj .. nk)
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

  for i = 0, 24 do
    local m10, m1 = i // 10, i % 10
    local s = i .. ':00'
    if m10 == m1 then
      dict:add({'#-', m10, 'K-D'}, s)
      dict:add({'#-', m10, '-BGD'}, s)
    elseif m10 < m1 then
      dict:add({'#-', m10, m1, 'EU', 'K-'}, s)
      dict:add({'#-', m10, m1, 'EU', '-BG'}, s)
    else
      dict:add({'#-', m10, m1, 'K-'}, s)
      dict:add({'#-', m10, m1, '-BG'}, s)
    end
  end

  for i = 0, 55, 5 do
    local m10, m1 = i // 10, i % 10
    local s = string.format('{^:%02u}', i)
    if m10 == m1 then
      dict:add({'#-', m10, '-D', '-BG'}, s)
      dict:add({'#-', m10, '-D', '*BG'}, s)
    elseif m10 < m1 then
      dict:add({'#-', m10, m1, '-EU', '-BG'}, s)
      dict:add({'#-', m10, m1, '-EU', '*BG'}, s)
    else
      dict:add({'#-', m10, m1, '-BG'}, s)
      dict:add({'#-', m10, m1, '*BG'}, s)
    end
  end

  for i = 15, 45, 15 do
    local s = string.format('{:}%02u', i)
    dict:add({'#-', i, '*U'}, s)
  end

  for stroke, output in pairs(extras) do
    dict:add(stroke, output)
  end

  return dict
end

return numbers
