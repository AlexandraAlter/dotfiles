local files = {}

function files.get_extension(name)
  return string.match(name, '%.([^/]-)$')
end

function files.replace_extension(name, ext)
  return string.gsub(name, '%.(.*)$', '.' .. ext)
end

function files.split_filename(name)
  local res = {}
  for str in string.gmatch(name, '([^/]+)') do
    table.insert(res, str)
  end
  return res
end

function files.get_filename(name)
  local split = files.split_filename(name)
  return split[#split]
end

function files.get_directory(name)
  return string.match(name, '^.+/') or './'
end

return files
