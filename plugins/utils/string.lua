function Trim(str)
  return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
  -- return string.gsub(str, '[\t\n\r]+', '')
end

function StartWith(str, val)
  local len = #val
  return string.sub(str, 0, len) == val
end

function EndWith(str, val)
  local len = #val
  local strLen = #str
  return string.sub(str, strLen - len + 1, strLen) == val
end

function Concat(...)
  local origin = {...}
  local message = ''
  for _,v in pairs(origin) do
     message = message..tostring(v)..' '
  end
  return message
end

function IsUrl(url)
  -- 使用Lua正则表达式匹配URL
  local pattern = "^https?://[%w-_%.%?%.:/%+=&]+"
  return string.match(url, pattern) ~= nil
end
