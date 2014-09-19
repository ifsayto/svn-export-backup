require("xstr")
local uc = require("yl.urlcode")

svnpath=""
svnuser="user_xxx"
svnpsw="psw_xxx"
rnew="head"
rold=0

function read_cfg()
	local file = io.open("svn.cfg")
	if file then
		svnpath = file:read("*line")
		rold = file:read("*number")
		file:close()
	end
end
function write_cfg()
	local file = io.open("svn.cfg","w")
	if file then
		file:write(svnpath.."\n")
		file:write(rold.."\n")
		file:close()
	end
end

function retrieve_last()
	print("retrieve last svn log ...")
	cmd = "svn log -l 1 "..svnpath.." --username "..svnuser.." --password "..svnpsw.." > rnew.txt"
	os.execute(cmd)
end

function read_new()
	file = io.open("rnew.txt")
	while true do
		local line = file:read("*line")
		--print(xstr.charAt(line,0))
		if nil~=line and 'r'==xstr.charAt(line,0) then
			local tmps = string.split(line," ")
			rnew = string.gsub(tmps[1], "r", "")
			break
		end
	end
	file:close()
end


--io.read("*line")

function retrieve_diff_files()
	print("retrieve svn diff info ...")
	out = ''
	cmd = "svn diff -r "..rold..":"..rnew.." --summarize "..svnpath.." --username "..svnuser.." --password "..svnpsw.." >diff.txt"
	rsp = os.execute(cmd)
end

function retrieve_diff_files2()
	print("retrieve svn diff info2 ...")
	out = ''
	cmd = "svn diff -r "..rold..":"..rnew.." "..svnpath.." --username "..svnuser.." --password "..svnpsw.." >diff.txt"
	rsp = os.execute(cmd)
end

function export_first()
	cmd = "svn export --force --username "..svnuser.." --password "..svnpsw.." --ignore-externals "..svnpath.." ./"
	os.execute(cmd)
end


function export_diff_files()
	--while(diff:read("*line")
	diff=io.open('diff.txt','r')
	print("retrive svn diff files ...")
	while true do
		local line = diff:read("*line")
		local elem = string.split(line, " ")
		if not elem[2] then break end
		--print(elem[2])
		if nil~=strippath(elem[2]) then
			local tmp = string.gsub(elem[2], svnpath, ".")
			print(tmp)
			cmd2 = "svn export --depth files --force --username "..svnuser.." --password "..svnpsw.." --ignore-externals "..elem[2].." "..tmp
			os.execute(cmd2)
		end
	end
end

function decode_URI(s)
	local char, gsub, tonumber = string.char, string.gsub, tonumber
    local function _(hex) return char(tonumber(hex, 16)) end
        s = gsub(s, '%%(%x%x)', _)
        return s
end

function str_filter(str, filter)
	local pos = string.find(str, filter)
	if pos~=nil then
		return true
	end

	return false
end


function export_diff_files3()
	--while(diff:read("*line")
	diff=io.open('diff.txt','r')
	print("retrive svn diff files ...")
	local res_list = {}
	for line in diff:lines() do
		local pos = string.find(line, "tags")
		if pos==nil then
			res_list = {next = res_list,value = line}
		end
	end
	local l = res_list
	local ttt = io.open("ttt.txt","w")
	while l do
		--print(l.value)
		local elem = string.split(l.value, " ")
		if not elem[2] then break end
		--print(elem[2])
		local pos = string.find(elem[2], "tags")
		if "D"==elem[1] then
			print(l.value)
		elseif pos == nil then
			local url = elem[2]
			local tmp = string.gsub(elem[2], svnpath, ".")
			print(tmp)
			local local_path = stripfilename(tmp)
			print(local_path)
			if local_path then
				local_path = uc.de(local_path)
			else
				local_path = uc.de(tmp)
			end
			print(local_path)
			cmd2 = "svn export --depth files --force --username "..svnuser.." --password "..svnpsw.." --ignore-externals \""..url.."\" \""..local_path.."\""
			os.execute(cmd2)
		end
		l = l.next
	end
	ttt:close()
end

function export_diff_files2()
	--while(diff:read("*line")
	diff=io.open('diff.txt','r')
	print("export_diff_files2 ...")
	local idx = 0
	os.execute("echo new >rst.txt")
	while true do
		local line = diff:read("*line")
		if line~=nil then
			local p1,p2 = string.find(line, "Index: ")
			if p1==1 then
				local tmp = string.sub(line, p2+1)
				print(idx, tmp)
				cmd2 = "svn export --depth files --force --username "..svnuser.." --password "..svnpsw.." --ignore-externals "..svnpath.."/"..tmp.." ./"..tmp.." >>rst.txt"
				--print(cmd2)
				os.execute(cmd2)
				idx = idx+1
			end
		end
	end
end



--export_diff_files2()
--io.read("*line")

print("exoprt "..svnpath.." begin")
read_cfg()

if rold==0 then
	print("old: r"..rold, "new: r"..rnew)
	export_first()
else
	retrieve_last()
	read_new()
	print("old: r"..rold, "new: r"..rnew)
	--retrieve_diff_files()
	--export_diff_files()
	export_diff_files3()
	--retrieve_diff_files2()
	--export_diff_files2()
end

os.execute("rm rnew.txt")

write_cfg()
print("export end")

io.read("*line")
