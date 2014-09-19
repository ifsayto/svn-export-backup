--[[
	命名空间: xstr
	作者: apache(email: hqwemail@gmail.com; website: http://hi.baidu.com/hqwfreefly)
	版本号: 0.2 (from 0.1)
	创建日期: 2010-10-17
	函数列表: trim, capitalize, count, startswith, endswith, expendtabs, isalnum, isalpha, isdigit, islower, isupper,
			  join, lower, upper, partition, zfill, ljust, rjust, center, dir, help
	声明: 该软件为自由软件，遵循GPL协议。如果你需要为xstr增加函数，请在func_list中添加函数名，并在help函数中为其撰写帮助文档
	帮助: xstr:dir() 列出命名空间下的函数列表。xstr:help("func")查看func的帮助文档
	修改历史: 修改count函数的实现，使用gsub统计个数
--]]
xstr = {
	func_list = "trim, capitalize, count, startswith, endswith, expendtabs, isalnum, isalpha, isdigit, islower, isupper, join, lower, upper, partition, zfill, ljust, rjust, center, dir, help",
	--[[去除str中的所有空格。成功返回去除空格后的字符串，失败返回nil和失败信息]]
	trim = function (self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		str = string.gsub(str, " ", "")
		return str
	end,
	trim_ht = function(self, str)
	    if str == nil then
			return nil, "the string parameter is nil"
		end
	    return string.gsub(str, "^%s*(.-)%s*$", "%1")
	end,
	--[[将str的第一个字符转化为大写字符。成功返回转换后的字符串，失败返回nil和失败信息]]
	capitalize = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local ch = string.sub(str, 1, 1)
		local len = string.len(str)
		if ch < 'a' or ch > 'z' then
			return str
		end
		ch = string.char(string.byte(ch) - 32)
		if len == 1 then
			return ch
		else
			return ch .. string.sub(str, 2, len)
		end
	end,
	--[[统计str中substr出现的次数。from, to用于指定起始位置，缺省状态下from为1，to为字符串长度。成功返回统计个数，失败返回nil和失败信息]]
	count = function(self, str, substr, from, to)
		if str == nil or substr == nil then
			return nil, "the string or the sub-string parameter is nil"
		end
		from = from or 1
		if to == nil or to > string.len(str) then
			to = string.len(str)
		end
		local str_tmp = string.sub(str, from ,to)
		local n = 0
		_, n = string.gsub(str, substr, '')
		return n
	end,
	--[[判断str是否以substr开头。是返回true，否返回false，失败返回失败信息]]
	startswith = function(self, str, substr)
		if str == nil or substr == nil then
			return nil, "the string or the sub-stirng parameter is nil"
		end
		if string.find(str, substr) ~= 1 then
			return false
		else
			return true
		end
	end,
	--[[判断str是否以substr结尾。是返回true，否返回false，失败返回失败信息]]
	endswith = function(self, str, substr)
		if str == nil or substr == nil then
			return nil, "the string or the sub-string parameter is nil"
		end
		str_tmp = string.reverse(str)
		substr_tmp = string.reverse(substr)
		if string.find(str_tmp, substr_tmp) ~= 1 then
			return false
		else
			return true
		end
	end,
	--[[使用空格替换str中的制表符，默认空格个数为8。返回替换后的字符串]]
	expendtabs = function(self, str, n)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		n = n or 8
		str = string.gsub(str, "\t", string.rep(" ", n))
		return str
	end,
	--[[如果str仅由字母或数字组成，则返回true，否则返回false。失败返回nil和失败信息]]
	isalnum = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if not ((ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z') or (ch >= '0' and ch <= '9')) then
				return false
			end
		end
		return true
	end,
	--[[如果str全部由数字组成，则返回true，否则返回false。失败返回nil和失败信息]]
	isalpha = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if not ((ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z')) then
				return false
			end
		end
		return true
	end,
	--[[如果str全部由数字组成，则返回true，否则返回false。失败返回nil和失败信息]]
	isdigit = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch < '0' or ch > '9' then
				return false
			end
		end
		return true
	end,
	--[[如果str全部由小写字母组成，则返回true，否则返回false。失败返回nil和失败信息]]
	islower = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch < 'a' or ch > 'z' then
				return false
			end
		end
		return true
	end,
	--[[如果str全部由大写字母组成，则返回true，否则返回false。失败返回nil和失败信息]]
	isupper = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch < 'A' or ch > 'Z' then
				return false
			end
		end
		return true
	end,
	--[[使用substr连接str中的每个字符，返回连接后的新串。失败返回nil和失败信息]]
	join = function(self, str, substr)
		if str == nil or substr == nil then
			return nil, "the string or the sub-string parameter is nil"
		end
		local xlen = string.len(str) - 1
		if xlen == 0 then
			return str
		end
		local str_tmp = ""
		for i = 1, xlen do
			str_tmp = str_tmp .. string.sub(str, i, i) .. substr
		end
		str_tmp = str_tmp .. string.sub(str, xlen + 1, xlen + 1)
		return str_tmp
	end,
	--[[将str中的小写字母替换成大写字母，返回替换后的新串。失败返回nil和失败信息]]
	lower = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		local str_tmp = ""
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch >= 'A' and ch <= 'Z' then
				ch = string.char(string.byte(ch) + 32)
			end
			str_tmp = str_tmp .. ch
		end
		return str_tmp
	end,
	--[[将str中的大写字母替换成小写字母，返回替换后的新串。失败返回nil和失败信息]]
	upper = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		local str_tmp = ""
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch >= 'a' and ch <= 'z' then
				ch = string.char(string.byte(ch) - 32)
			end
			str_tmp = str_tmp .. ch
		end
		return str_tmp
	end,
	--[[将str以substr（从左向右查找）为界限拆分为3部分，返回拆分后的字符串。如果str中无substr则返回str, '', ''。失败返回nil和失败信息]]
	partition = function(self, str, substr)
		if str == nil or substr == nil then
			return nil, "the string or the sub-string parameter is nil"
		end
		local len = string.len(str)
		start_idx, end_idx = string.find(str, substr)
		if start_idx == nil or end_idx == len then
			return str, '', ''
		end
		return string.sub(str, 1, start_idx - 1), string.sub(str, start_idx, end_idx), string.sub(str, end_idx + 1, len)
	end,
	--[[在str前面补0，使其总长度达到n。返回补充后的新串，如果str长度已经超过n，则直接返回str。失败返回nil和失败信息]]
	zfill = function(self, str, n)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		if n == nil then
			return str
		end
		local format_str = "%0" .. n .. "s"
		return string.format(format_str, str)
	end,
	-----------------------------------------------------------------------------------------------------------------------------------------
	--[[设置str的位宽，默认的填充字符为空格。对齐方式为左对齐（rjust为右对齐，center为中间对齐）。返回设置后的字符串。失败返回nil和失败信息]]
	ljust = function(self, str, n, ch)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		ch = ch or " "
		n = tonumber(n) or 0
		local len = string.len(str)
		return string.rep(ch, n - len) .. str
	end,
	rjust = function(self, str, n, ch)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		ch = ch or " "
		n = tonumber(n) or 0
		local len = string.len(str)
		return str .. string.rep(ch, n - len)
	end,
	center = function(self, str, n, ch)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		ch = ch or " "
		n = tonumber(n) or 0
		local len = string.len(str)
		rn_tmp = math.floor((n - len) / 2)
		ln_tmp = n - rn_tmp - len
		return string.rep(ch, rn_tmp) .. str .. string.rep(ch, ln_tmp)
	end,

	-- return the character at the specified position
	-- Lua string starts from index 1, while AS String begins with 0
	charAt = function(self, index)
		if index >= 0 then
			return string.sub(self, index + 1, index + 1);
		else
			return string.sub(self, index, index);
		end
	end;

	charCodeAt = function(self, index)
	    local tmpchar;
	    if index >= 0 then
			tmpchar = string.sub(self, index + 1, index + 1);
		else
			tmpchar = string.sub(self, index, index);
		end
	    return string.byte(tmpchar);
	end,

	-- return a sub string
	-- @param head The start index of the sub string
	-- @param length The length of the sub string.
	substr = function(self, head, length)
		head = tonumber(head);
		if length == nil then
			length = string.len(self);
		elseif length < 0 then
			length = 0;
		end
		if head >= 0 then
			return string.sub(self, head + 1, head + length);
		else
			local tail = (head + length < 0) and (head + length - 1) or -1;
			return string.sub(self, head, tail);
		end
	end,

	substring = function(self, head, tail)
		if tail == nil then
			tail = string.len(self);
		elseif tail < 0 then
			tail = 0;
		end
		head = (head < 0) and 0 or head;
		if head > tail then
			head, tail = tail, head;
		end

		return string.sub(self, head + 1, tail);
	end;

	-- concatenate all strings to make a long one
	concat = function(self, ...)
		local result = self;
		for _, str in ipairs(arg) do
			result = result .. str;
		end
		return result;
	end;

	-- split the string by the delimiter to make an array
	split = function(self, delimiter)
		local pattern = "(.-)" .. delimiter;
		local result = new(flash.Array);
		local head, tail, lastIndex, s = 1, 0, 1;
		while true do
			head, tail, s = string.find(self, pattern, tail + 1);
			if head == nil then
				break;
			end
			result:push(s);
			lastIndex = tail + 1;
		end
		result:push(string.sub(self, lastIndex));
		return result;
	end;

	indexOf = function(self, str)
		local head, tail = string.find(self, str);
		if head ~= nil then
			return head - 1;
		else
			return -1;
		end;
	end;

	lastIndexOf = function(self, str)
		local head, tail, index = 0, 0, nil;
		while true do
			head, tail = string.find(self, str, tail + 1);
			if head == nil then
				break;
			end
			index = head - 1;
		end
		return index;
	end;

	--add by yangfeng
	replaceAll = function(self, pattern, arg)
		local ret = self;
		local a, b = string.find(self, pattern);
		while a~=nil and b~=nil do
			ret = string.sub(ret, 1, a-1) .. arg .. string.sub(ret, b + 1);
			a, b = string.find(ret, pattern);
		end;
		return ret;
	end;
	--added by zhulan
	replace = function(self, pattern, arg)
		local ret = self;
		local a, b = string.find(self, pattern);
		if a and b then
			ret = string.sub(self, 1, a-1) .. arg .. string.sub(self, b + 1);
		end;
		return ret;
	end;


	------------------------------------------------------------------------------------------------------------------------------------------
	--[[显示xstr命名空间的所有函数名]]
	dir = function(self)
		print(self.func_list)
	end,
	--[[打印指定函数的帮助信息, 打印成功返回true，否则返回false]]
	help = function(self, fun_name)
		man = {
			["trim"] = "xstr:trim(str) --> string | nil, err_msg\n  去除str中的所有空格，返回新串\n  print(xstr:trim(\"  hello wor ld \") --> helloworld",
			["capitalize"] = "xstr:capitalize(str) --> string | nil, err_msg\n  将str的首字母大写，返回新串\n  print(xstr:capitalize(\"hello\") --> Hello",
			["count"] = "xstr:count(str, substr [, from] [, to]) --> number | nil, err_msg\n  返回str中substr的个数, from和to用于指定统计范围, 缺省状态下为整个字符串\n  print(xstr:count(\"hello world!\", \"l\")) --> 3",
			["startswith"] = "xstr:startswith(str, substr) --> boolean | nil, err_msg\n  判断str是否以substr开头, 是返回true，否返回false\n  print(xstr:startswith(\"hello world\", \"he\") --> true",
			["endswith"] = "xstr:endswith(str, substr) --> boolean | nil, err_msg\n  判断str是否以substr结尾, 是返回true, 否返回false\n  print(xstr:endswith(\"hello world\", \"d\")) --> true",
			["expendtabs"] = "xstr:expendtabs(str, n) --> string | nil, err_msg\n  将str中的Tab制表符替换为n格空格，返回新串。n默认为8\n  print(xstr:expendtabs(\"hello	world\")) --> hello        world",
			["isalnum"] = "xstr:isalnum(str) --> boolean | nil, err_msg\n  判断str是否仅由字母和数字组成，是返回true，否返回false\n  print(xstr:isalnum(\"hello world:) 123\")) --> false",
			["isalpha"] = "xstr:isalpha(str) --> boolean | nil, err_msg\n  判断str是否仅由字母组成，是返回true，否返回false\n  print(xstr:isalpha(\"hello WORLD\")) --> true",
			["isdigit"] = "xstr:isdigit(str) --> boolean | nil, err_msg\n  判断str是否仅由数字组成，是返回true，否返回false\n  print(xstr:isdigit(\"0123456789\")) --> true",
			["islower"] = "xstr:islower(str) --> boolean | nil, err_msg\n  判断str是否全部由小写字母组成，是返回true，否返回false\n  print(xstr:islower(\"hello world\")) --> true",
			["isupper"] = "xstr:isupper(str) --> boolean | nil, err_msg\n  判断str是否全部由大写字母组成，是返回true，否返回false\n  print(xstr:isupper(\"HELLO WORLD\")) --> true",
			["join"] = "xstr:join(str, substr) --> string | nil, err_msg\n  使用substr连接str中的每个元素，返回新串\n  print(xstr:join(\"hello\", \"--\")) --> h--e--l--l--o",
			["lower"] = "xstr:lower(str) --> string | nil, err_msg\n  将str中的大写字母小写化，返回新串\n  print(xstr:lower(\"HeLLo WORld 2010\")) --> hello wold 2010",
			["upper"] = "xstr:upper(str) --> string | nil, err_msg\n  将str中的小写字母大写化，返回新串\n  print(xstr:upper(\"hello world 2010\")) --> HELLO WORLD 2010",
			["partition"] = "xstr:partition(str, substr) --> string, string, string | nil, err_msg\n  将str按照substr为界限拆分为3部分，返回拆分后的字符串\n  print(xstr:partition(\"hello*world\", \"wo\")) --> hello*	wo	rld",
			["zfill"] = "xstr:zfill(str, n) --> string | nil, err_msg\n  在str前补0，使其总长度为n。返回新串\n  print(xstr:zfill(\"100\", 5)) --> 00100",
			["ljust"] = "xstr:ljust(str, n, ch) --> string | nil, err_msg\n  按左对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:ljust(\"hello\", 10, \"*\")) --> *****hello",
			["rjust"] = "xstr:ljust(str, n, ch) --> string | nil, err_msg\n  按右对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:ljust(\"hello\", 10, \"*\")) --> hello*****",
			["center"] = "xstr:center(str, n, ch) --> string | nil, err_msg\n  按中间对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:center(\"hello\", 10, \"*\")) --> **hello***",
			["dir"] = "xstr:dir()\n  列出xstr命名空间中的函数",
			["help"] = "xstr:help(\"func\")\n  打印函数func的帮助文档\n  xstr:help(\"dir\") --> \nxstr:dir()\n  列出xstr命名空间中的函数",
		}
		print(man[fun_name])
	end,
}

function Split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function pr (t, name, indent)
    local tableList = {}
    function table_r (t, name, indent, full)
        local id = not full and name or type(name)~="number" and tostring(name) or '['..name..']'
        local tag = indent .. id .. ' = '
        local out = {}  -- result
        if type(t) == "table" then
            if tableList[t] ~= nil then
                table.insert(out, tag .. '{} -- ' .. tableList[t] .. ' (self reference)')
            else
                tableList[t]= full and (full .. '.' .. id) or id
                if next(t) then -- Table not empty
                    table.insert(out, tag .. '{')
                    for key,value in pairs(t) do
                        table.insert(out,table_r(value,key,indent .. '|  ',tableList[t]))
                    end
                    table.insert(out,indent .. '}')
                else table.insert(out,tag .. '{}') end
            end
        else
            local val = type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t)
            table.insert(out, tag .. val)
        end
        return table.concat(out, '\n')
    end
    return table_r(t,name or 'Value',indent or '')
end

function print_r (t, name)
    print(pr(t,name))
end


string.split = function(s, p)

    local rtlist= {}
	if nil==s then return rtlist end
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rtlist, w) end )
    return rtlist
end

printsplite = function(sl)
    for _, s in ipairs(sl) do
        print(s)
	end
end

function var_dump(data, max_level, prefix)
    if type(prefix) ~= "string" then
        prefix = ""
    end
    if type(data) ~= "table" then
        print(prefix .. tostring(data))
    else
        print(data)
        if max_level ~= 0 then
            local prefix_next = prefix .. "    "
            print(prefix .. "{")
            for k,v in pairs(data) do
                io.stdout:write(prefix_next .. k .. " = ")
                if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then
                    print(v)
                else
                    if max_level == nil then
                        var_dump(v, nil, prefix_next)
                    else
                        var_dump(v, max_level - 1, prefix_next)
                    end
                end
            end
            print(prefix .. "}")
        end
    end
end






--��ȡ·��
function stripfilename(filename)
         return string.match(filename, "(.+)/[^/]*%.%w+$") --*nix system
         --return string.match(filename, ��(.+)\\[^\\]*%.%w+$��) �� windows
 end
--��ȡ�ļ���
function strippath(filename)
         return string.match(filename, ".+/([^/]*%.%w+)$") -- *nix system
         --return string.match(filename, ��.+\\([^\\]*%.%w+)$��) �� *nix system
 end
--ȥ����չ��
function stripextension(filename)
         local idx = filename:match(".+()%.%w+$")
         if(idx) then
                 return filename:sub(1, idx-1)
         else
                 return filename
         end
 end
--��ȡ��չ��
function getextension(filename)
         return filename:match(".+%.(%w+)")
 end
