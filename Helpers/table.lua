--------------------------------------------------------------------------------
-- BASICS
--------------------------------------------------------------------------------
READI.Helper.table = READI.Helper.table or {}
RD.hlp.tbl = READI.Helper.table
--------------------------------------------------------------------------------
--- A simple function to retrieve a key-value-pair out of a table based on a
--- callback function (similar to READI.Helper.table:Filter)
---@param tbl table
---@param handler function
function READI.Helper.table:Get(tbl, handler)
  for k,v in pairs(tbl) do
    if handler(k,v) then
      return k,v
    end
  end
  return nil
end
--------------------------------------------------------------------------------
--- A simple function to retrieve all keys out of a table 
---@param tbl table
function READI.Helper.table:Keys(tbl)
  local dst = {}

  if (type(tbl) or false) == "table" then
    for k,v in pairs(tbl) do
      table.insert(dst, k)
    end
  end
  return dst
end
--------------------------------------------------------------------------------
-- Check whether a given value is contained within a table
---@param needle string|number|boolean
---@param haystack table
function READI.Helper.table:Contains(needle, haystack)
  for k,v in pairs(haystack) do
    if haystack[k] == needle then
      return true
    end
  end
  return false
end
--------------------------------------------------------------------------------
--- Split a given table in chunks of a given size
---@param tbl table
---@param size number
function READI.Helper.table:Chunk(tbl, size)
  local i = 1
  local chunks = {}
  for i=1, #tbl, size do
    local _t = {}
    for x=1, size do
      _t[x] = tbl[i+x-1]
    end
    table.insert(chunks, _t)
  end

  return chunks
end
--------------------------------------------------------------------------------
--- A simple function to filter a given table based on a callback function
---@param tbl table
---@param handler function
function READI.Helper.table:Filter(tbl, handler)
  local out = {}
  for k, v in pairs(tbl) do
    if handler(v) then
      table.insert(out, v)
    end
  end
  return out
end
--------------------------------------------------------------------------------
--- A simple function to merge values of several source tables into one dist table 
---@param dst table : the table the other tables should be merged into
---@param args table : a variable number of tables to be merged into dst
function READI.Helper.table:Merge(dst, ...)
  if type(dst) ~= "table" then return {} end

  for _, src in ipairs({...}) do
    for k,v in pairs(src) do
      if type(v) == "table" and (type(dst[k] or false) == "table") then
        READI.Helper.table:Merge(dst[k], v)
      else
        dst[k] = v
      end
    end
  end
  return dst  
end
--------------------------------------------------------------------------------
--- A simple function to normalize a given table according to another (master)
--- The given table will be changed to represent the same set of keys
--- @param master table : The master table defining the set of keys
--- @param servant table : the table to be normalized
function READI.Helper.table:CleanUp(master, servant, exception)
  if type(master) ~= "table" then
    error("Oops, master table seems to be of a wrong type. Please provide a valid table.", 2)
  end
  for k,v in pairs(servant) do
    if not exception or k ~= exception then
      if (type(v) or false) == "table" then
        if master[k] ~= nil then
          servant[k] = READI.Helper.table:CleanUp(master[k], v)
        else
          servant[k] = nil
        end
      else
        if master[k] == nil then
          servant[k] = nil
        end
      end
    end
  end

  return servant
end
--------------------------------------------------------------------------------
function READI.Helper.table:Serialize(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0

  local tmp = string.rep("  ", depth)

  if name then
    if not string.match(name, '^\w*$') then
      name = string.gsub(name, "'", "\\'")
      name = "['"..name.."']"
    end
    tmp = tmp .. name .. " = "
  end

  if type(val) == "table" then
    tmp = tmp .. "{"..(not skipnewlines and "\n" or "")
    for k,v in pairs(val) do
      tmp = tmp..READI.Helper.table:Serialize(v,k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
    end
    tmp = tmp .. string.rep("  ", depth) .. "}"
  elseif type(val) == "number" then
    tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
    tmp = tmp .. format("%q", val)
  elseif type(val) == "boolean" then
    tmp = tmp .. (val and "true" or "false")
  else
    tmp = tmp .. "\"[inserializable data-type: " .. type(val) .. "]\""
  end

  return tmp
end
--------------------------------------------------------------------------------
--- a simple function to check if a series of nested tables exists
---@param tbl table : the table to verify
---@param key string : a string representation of a series of nested tables (e.g. "path.to.nested.tables")
function READI.Helper.table:VerifyDepth(tbl, key, lvl)
  lvl = (lvl or 0) + 1
  -- split the key string by its path separator
  local depths = READI.Helper.string:Split(key,".")
  -- return early if we reach the maximum depth of the key string
  if #depths == 0 then return true end
  -- recursive recall of the function for each level within the table
  if tbl[depths[1]] and tbl[depths[1]] ~= {} then
    -- remove the already checked level to prevent errors
    local _ = table.remove(depths,1)
    -- update the table to be given to the next function call
    tbl = tbl[_]
    -- return the result of the next levels check
    return READI.Helper.table:VerifyDepth(tbl, table.concat(depths,"."), lvl)
  end
  return false
end
--------------------------------------------------------------------------------
function READI.Helper.table:Dump(o, tbs, tb)
  tb = tb or 0
  tbs = tbs or '  '
  if type(o) == 'table' then
    local s = '{'
    if (next(o)) then s = s .. '\n' else return s .. '}' end
    tb = tb + 1
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. tbs:rep(tb) .. '[' .. k .. '] = ' .. READI.Helper.table:Dump(v, tbs, tb)
      s = s .. ',\n'
    end
    tb = tb - 1
    return s .. tbs:rep(tb) .. '}'
  else
    return tostring(o)
  end
end

function READI.Helper.table:Move(pattern, src, dst)
  for key,val in pairs(pattern) do
    if src[key] then
      if (type(val) or false) == "table" then
        dst[key] = CopyTable(src[key])
      else
        dst[key] = src[key]
      end
      src[key] = nil
    end
  end 
end