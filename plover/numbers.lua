
require'lib'

local numbers = {
  ['S-'] = '1',
  ['T-'] = '2',
  ['P-'] = '3',
  ['H-'] = '4',
  ['A-'] = '5',
  ['O-'] = '0',
  ['-F'] = '6',
  ['-P'] = '7',
  ['-L'] = '8',
  ['-T'] = '9',
}

local num_prefix = '#-'

function build_numbers()
  local dict = Dict:new{}

  for s,o in pairs(numbers) do
    dict:add({num_prefix, s}, o)
  end

  for s1,o1 in pairs(numbers) do
    for s2,o2 in pairs(numbers) do
      if o1 ~= o2 then
        dict:add({num_prefix, s1, s2}, o1 .. o2)
        dict:add({num_prefix, s1, s2, '-E', '-U'}, o2 .. o1)
      else
        dict:add({num_prefix, s1, '-D'}, o1 .. o1)
      end
    end
  end

  for s,o in pairs(numbers) do
    local th = 'th'
    if o == '1' then
      th = 'st'
    elseif o == '2' then
      th = 'nd'
    elseif o == '3' then
      th = 'rd'
    end
    dict:add({num_prefix, s, '*', '-T'}, o .. th)
  end

  return dict
end
