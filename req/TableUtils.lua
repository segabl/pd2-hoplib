-- Merges all values from tbl2 into tbl1, replacing existing values in tbl1
function table.union(tbl1, tbl2)
	for k, v in pairs(tbl2) do
		if type(v) == "table" then
			tbl1[k] = type(tbl1[k]) =="table" and tbl1[k] or {}
			table.union(tbl1[k], v)
		else
			tbl1[k] = v
		end
	end
	return tbl1
end

-- Replaces only existing values in tbl1 with values from tbl2, if match_type is set, value types must match
function table.replace(tbl1, tbl2, match_type)
	for k, v in pairs(tbl2) do
		if type(tbl1[k]) == type(v) or not match_type and tbl1[k] ~= nil then
			if type(v) == "table" then
				tbl1[k] = type(tbl1[k]) =="table" and tbl1[k] or {}
				table.replace(tbl1[k], v, match_type)
			else
				tbl1[k] = v
			end
		end
	end
	return tlb1
end

-- Calls a function for every non-table value, recurses function call for table values
function table.recurse(tbl, func)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			table.recurse(v, func)
		else
			func(v, k)
		end
	end
	return tbl1
end
