local maths = {}

maths.factors = {8, 4, 2, 1}
function maths.defactor(num, lookup)
  local res = {}
  local i = num
  for _,f in ipairs(maths.factors) do
    if f <= i then
      table.insert(res, lookup[f])
      i = i - f
    end
  end
  if i ~= 0 then
    error('could not factor number: ' .. num)
  end
  return res
end

return maths
