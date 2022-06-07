-- Numbers, times, mathematics, units, etc
local numbers = {}

local pl = require'plover'

local extras = {
  ['THOEUB'] = '{^,000}',
  ['THOUZ'] = '{^000}',
  ['THO*UZ'] = '{,^000}',
  ['K-PL'] = 'km',
  ['K*PL'] = '{^km}',
  ['HA*F'] = '1/2',
  ['TPHA*F'] = '1/2',
  ['TH*EURD'] = '1/3',
  ['TPHUPBZ'] = '100',
  ['TWOUPB'] = '{200^}',
  ['THoi*PB'] = '{^000}',
  ['HUPB/HUPB'] = '{^00}',
  ['HUPBZ'] = '{^00}',
  ['KH-PL'] = '{^:00}',
  ['KHR-PL'] = '{^:00}',
}

-- TPWOUPB: '{200^}'
-- -FPLT/-9D: '{.}99'
-- 8/NAF/PWEU/1/1: '8 1/2 x 11'
-- A*E/0EU6/-S: "'60s"
-- A*E/0EU7/-S: "'70s"
-- A*E/50/-S: "'50s"
-- ĀP/PERS: '75%'
-- ERL/AE/0EU8: "early '80"
-- KHREURT: '{:}30'
-- oiL/PERS: '80%'
-- P-P/-L: '.8'
-- MEUD/A*E/0EU6/-S: "mid-'60s"
-- PHR*US/2: '+2'
-- SĒ*/ROE/PERS: '0%'
-- THUZ: '{&000}'
-- FARBGT/10: 'factor X'
-- FARBGT/7: 'factor VII'
-- FARBGT/8: 'factor VIII'
-- FARBGT/8/A*: 'factor VIIIa'
-- FARBGT/9: 'factor IX'

function numbers.build()
  local dict = pl.Dict:new{}

  for i = 0, 9 do
    dict:add({'#-', i}, i)
    dict:add({'#-', i, '-Z'}, i .. '000')
    dict:add({'#-', i, '/', 'W-B', '/', 'THUS'}, i .. ',000')
    dict:add({'#-', i, '/', 'PERS'}, i .. '0%')
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

  for i = 0, 6 do
    for j = 0, 5, 5 do
      local n = i * 10 + j
      local s = string.format('{^:%02u}', n)
      if i == j then
        dict:add({'#-', i, '-D', '-BG'}, s)
      elseif i < j then
        dict:add({'#-', i, '-EU', '-BG'}, s)
      else
        dict:add({'#-', i, j, '-BG'}, s)
      end
    end
  end

  for stroke, output in pairs(extras) do
    dict:add(stroke, output)
  end

  return dict
end

return numbers
