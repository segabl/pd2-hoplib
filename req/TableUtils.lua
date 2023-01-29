---Merges all values from tbl2 into tbl1, replacing existing values in tbl1
---@param tbl1 table @table to union into
---@param tbl2 table @table to union from
---@param match_type? boolean @wether value types must match to be replaced
---@return table
function table.union(tbl1, tbl2, match_type)
	for k, v in pairs(tbl2) do
		if not match_type or tbl1[k] == nil or type(tbl1[k]) == type(v) then
			if type(v) == "table" then
				tbl1[k] = type(tbl1[k]) == "table" and tbl1[k] or {}
				table.union(tbl1[k], v, match_type)
			else
				tbl1[k] = v
			end
		end
	end
	return tbl1
end

---Replaces only existing values in tbl1 with values from tbl2
---@param tbl1 table @table to replace values in
---@param tbl2 table @table to take values from
---@param match_type? boolean @wether value types must match to be replaced
---@return table
function table.replace(tbl1, tbl2, match_type)
	for k, v in pairs(tbl2) do
		if type(tbl1[k]) == type(v) or not match_type and tbl1[k] ~= nil then
			if type(v) == "table" then
				tbl1[k] = type(tbl1[k]) == "table" and tbl1[k] or {}
				table.replace(tbl1[k], v, match_type)
			else
				tbl1[k] = v
			end
		end
	end
	return tbl1
end

---Calls a function for every non-table value, recurses function call for table values
---@param tbl table @table to run `func` on
---@param func function @function to run for each entry
---@return table
function table.recurse(tbl, func)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			table.recurse(v, func)
		else
			func(v, k)
		end
	end
	return tbl
end
