-- Numbers, times, mathematics, units, etc
local numbers = {}

local pl = require'plover'

local extras = {
  -- unknown
  ['NUNZ'] = '100',
  ['TWowN'] = '{200^}',
  ['TPWowN'] = '{200^}',
  ['THUZ'] = '{&000}',
  -- suffixes
  ['THoi*N'] = '{^000}',
  ['HUN/HUN'] = '{^00}',
  ['HUNZ'] = '{^00}',
  ['KH-M'] = '{^:00}',
  ['KHR-M'] = '{^:00}',
  ['KHREURT'] = '{^:30}',
  ['THOUZ'] = '{^000}',
  ['THOEUB'] = '{^,000}',
  ['THO*UZ'] = '{,^000}',
  -- decimals
  ['-FPLT/-9D'] = '{.}99',
  ['P-P/-L'] = '.8',
  -- fractions
  ['HA*F'] = '1/2',
  ['TPHA*F'] = '1/2',
  ['TH*IRD'] = '1/3',
  -- percentages
  ['ĀP/PERS'] = '80%',
  ['SĒ*/ROE/PERS'] = '0%',
  -- unknown
  ['PL*US/2'] = '+2',
  -- time periods
  ['A*E/50/-S'] = "'50s",
  ['A*E/0EU6/-S'] = "'60s",
  ['MID/A*E/0EU6/-S'] = "mid '60",
  ['A*E/0EU7/-S'] = "'70s",
  ['A*E/0EU8/-S'] = "'80s",
  ['ERL/AE/0EU8'] = "early '80",
  ['A*E/0EU9/-S'] = "'90s",
  -- units
  ['K-PL'] = 'km',
  ['K*PL'] = '{^km}',
}

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
