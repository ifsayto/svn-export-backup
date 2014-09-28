require("xstr")
--url = require('url')
local uc = require("yl.urlcode")
local fs = require"yl.fs"

svnpath="" --"https://svn02/vc/chd_dev_share"--"https://svn02/vc/social_card_game"--"https://svn02/vc/order_and_chaos_2_ios"
svnuser="wenhui.zhu@gameloft.com"
svnpsw="Er201408"
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
		file:write(rnew.."\n")
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
	local all_num = 0
	for line in diff:lines() do
		local pos = string.find(line, "tags")
		if pos==nil then
			res_list = {next = res_list,value = line}
			all_num = all_num+1
		end
	end
	local l = res_list

	print("export....................")
	local ttt = io.open("svn.log","w+")

	local index = 1
	while l do
		--print(l.value)
		local elem = string.split(l.value, " ")
		if not elem[2] then break end
		local operate = elem[1]
		local url = elem[2]
		--print(elem[2])
		local pos = string.find(url, "tags")
		if "D"==operate then
			print(index.."/"..all_num)
			--print(l.value)
			local tmp = string.gsub(url, svnpath, ".")
			local local_path = uc.de(tmp)
			print("D", local_path)
			ttt:write("D   "..local_path.."\n")

			fs.remove(local_path)
		elseif pos == nil  then --and pos2==nil

			local tmp = string.gsub(url, svnpath, ".")
			local local_path = uc.de(tmp)
			local exist = io.open(local_path)
			if nil==exist or "M"==operate then
				if exist then
					--print("c", operate, local_path)
					--ttt:write("c   "..operate.."   "..local_path.."\n")
					exist:close()
				end
				--print(url)
				ttt:write(index.."/"..all_num.."   "..operate.."   "..local_path.."\n")
				print(index.."/"..all_num, operate, local_path)
				cmd2 = "svn export --depth files --force --username "..svnuser.." --password "..svnpsw.." --ignore-externals \""..url.."\" \""..local_path.."\""
				os.execute(cmd2)
			end
			index = index+1
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
	retrieve_diff_files()
	export_diff_files3()
end

os.execute("rm rnew.txt")

write_cfg()
print("export end")

io.read("*line")
