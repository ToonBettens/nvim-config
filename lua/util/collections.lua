local M = {}

-- Convert a list (array) to a set (table with keys as values, value = true)
function M.as_set(list)
  local s = {}
  for _, v in ipairs(list) do s[v] = true end
  return s
end

-- Convert a set (table) back to a list (array of keys)
function M.set_to_list(set)
  local out = {}
  for k in pairs(set) do table.insert(out, k) end
  return out
end

-- Membership check: is item in set?
function M.in_set(item, set)
  return set[item] ~= nil
end

-- Set algebra: union, difference, intersection
function M.set_union(a, b)
  local out = {}
  for k in pairs(a) do out[k] = true end
  for k in pairs(b) do out[k] = true end
  return out
end

function M.set_difference(a, b)
  local out = {}
  for k in pairs(a) do
    if not b[k] then out[k] = true end
  end
  return out
end

function M.set_intersection(a, b)
  local out = {}
  for k in pairs(a) do
    if b[k] then out[k] = true end
  end
  return out
end

-- Filter a list, returning a new list of items where pred(item) is true
function M.filter(list, pred)
  local out = {}
  for _, v in ipairs(list) do
    if pred(v) then table.insert(out, v) end
  end
  return out
end

-- Filter a set, returning a new set with only keys where pred(key) is true
function M.filter_set(set, pred)
  local out = {}
  for k in pairs(set) do
    if pred(k) then out[k] = true end
  end
  return out
end

return M
