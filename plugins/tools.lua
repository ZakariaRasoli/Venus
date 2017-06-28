--Begin Tools.lua :)
local SUDO = 139328010 -- put Your ID here! <===
function exi_files(cpath)
    local files = {}
    local pth = cpath
    for k, v in pairs(scandir(pth)) do
		table.insert(files, v)
    end
    return files
end

local function file_exi(name, cpath)
    for k,v in pairs(exi_files(cpath)) do
        if name == v then
            return true
        end
    end
    return false
end
local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
local function index_function(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 

local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

local function exi_file()
    local files = {}
    local pth = tcpath..'/data/document'
    for k, v in pairs(scandir(pth)) do
        if (v:match('.lua$')) then
            table.insert(files, v)
        end
    end
    return files
end

local function pl_exi(name)
    for k,v in pairs(exi_file()) do
        if name == v then
            return true
        end
    end
    return false
end

local function sudolist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = "🔰 *List of sudo users :*\n"
   else
 text = "🔰 _لیست سودو های ربات :_\n"
  end
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end

local function adminlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = '🔰 *List of bot admins :*\n'
   else
 text = "🔰 _لیست ادمین های ربات :_\n"
  end
		  	local compare = text
		  	local i = 1
		  	for v,user in pairs(_config.admins) do
			    text = text..i..'- '..(user[2] or '')..' ➣ ('..user[1]..')\n'
		  	i = i +1
		  	end
		  	if compare == text then
   if not lang then
		  		text = '☡ _No_ *admins* _available_'
      else
		  		text = '⚠ _ادمینی برای ربات تعیین نشده_'
           end
		  	end
		  	return text
    end

local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return 'No groups at the moment'
    end
    local message = '☡ List of Groups:\n*Use #join (ID) to join*\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id = name .. '\n(ID: ' ..group_id.. ')\n\n'
				if name:match("[\216-\219][\128-\191]") then
					group_info = i..' - \n'..group_name_id
				else
					group_info = i..' - '..group_name_id
				end
				i = i + 1
			end
        end
		message = message..group_info
    end
	return message
end

local function botrem(msg)
	local data = load_data(_config.moderation.data)
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	if redis:get('CheckExpire::'..msg.to.id) then
		redis:del('CheckExpire::'..msg.to.id)
	end
	if redis:get('ExpireDate:'..msg.to.id) then
		redis:del('ExpireDate:'..msg.to.id)
	end
	tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
end

local function warning(msg)
	local hash = "gp_lang:"..msg.to.id
	local lang = redis:get(hash)
	local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
	if expiretime == -1 then
		return
	else
	local d = math.floor(expiretime / 86400) + 1
        if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
			if lang then
				tdcli.sendMessage(msg.to.id, 0, 1, 'ا⚠ ز شارژ گروه 1 روز باقی مانده، برای شارژ مجدد با سودو ربات تماس بگیرید وگرنه با اتمام زمان شارژ، گروه از لیست ربات حذف وربات گروه را ترک خواهد کرد\nادمین اصلی : @ZakariaaR.', 1, 'md')
			else
				tdcli.sendMessage(msg.to.id, 0, 1, '☡ _Group 1 day remaining charge, to recharge the robot contact with the sudo. With the completion of charging time, the group removed from the robot list and the robot will leave the group._\nDeveloper : @ZakariaR', 1, 'md')
			end
		end
	end
end

local function action_by_reply(arg, data)
    local cmd = arg.cmd
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
    if cmd == "adminprom" then
local function adminprom_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is already an_ *admin*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات بود_", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _has been promoted as_ *admin*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _به مقام ادمین ربات منتصب شد_", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, adminprom_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "admindem" then
local function admindem_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
	local nameid = index_function(tonumber(data.id_))
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is not a_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات نبود_", 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _has been demoted from_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _از مقام ادمین ربات برکنار شد_", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, admindem_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "visudo" then
local function visudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات بود_", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _به مقام سودو ربات منتصب شد_", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, visudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "desudo" then
local function desudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات نبود_", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _از مقام سودو ربات برکنار شد_", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, desudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "⚠ _کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "☡ *User Not Found*", 0, "md")
      end
   end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local cmd = arg.cmd
if not arg.username then return false end
    if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
    if cmd == "adminprom" then
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is already an_ *admin*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات بود_", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _has been promoted as_ *admin*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _به مقام ادمین ربات منتصب شد_", 0, "md")
   end
end
    if cmd == "admindem" then
	local nameid = index_function(tonumber(data.id_))
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is not a_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات نبود_", 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _has been demoted from_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _از مقام ادمین ربات برکنار شد_", 0, "md")
   end
end
    if cmd == "visudo" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات بود_", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _به مقام سودو ربات منتصب شد_", 0, "md")
   end
end
    if cmd == "desudo" then
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات نبود_", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _از مقام سودو ربات برکنار شد_", 0, "md")
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "☡ *User Not Found*", 0, "md")
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local cmd = arg.cmd
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
    if cmd == "adminprom" then
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is already an_ *admin*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات بود_", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _has been promoted as_ *admin*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _به مقام ادمین ربات منتصب شد_", 0, "md")
   end
end 
    if cmd == "admindem" then
	local nameid = index_function(tonumber(data.id_))
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is not a_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات نبود_", 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _has been demoted from_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _از مقام ادمین ربات برکنار شد_", 0, "md")
   end
end
    if cmd == "visudo" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات بود_", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _به مقام سودو ربات منتصب شد_", 0, "md")
   end
end
    if cmd == "desudo" then
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "☡ _User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات نبود_", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "✅ _کاربر_ "..user_name.." *"..data.id_.."* _از مقام سودو ربات برکنار شد_", 0, "md")
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "⚠ _کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "☡ *User Not Found*", 0, "md")
      end
   end
end

local function pre_process(msg)
	if msg.to.type ~= 'pv' then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		local data = load_data(_config.moderation.data)
		local gpst = data[tostring(msg.to.id)]
		local chex = redis:get('CheckExpire::'..msg.to.id)
		local exd = redis:get('ExpireDate:'..msg.to.id)
		if gpst and not chex and msg.from.id ~= SUDO and not is_sudo(msg) then
			redis:set('CheckExpire::'..msg.to.id,true)
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 86400, true)
			if lang then
				tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _گروه به مدت 1 روز شارژ شد. لطفا با سودو برای شارژ بیشتر تماس بگیرید. در غیر اینصورت گروه شما از لیست ربات حذف و ربات گروه را ترک خواهد کرد._\nسودو ربات : @ZakariaR', 1, 'md')
			else
				tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _Group charged 1 day. to recharge the robot contact with the sudo. With the completion of charging time, the group removed from the robot list and the robot will leave the group._\nOur Sudo : @ZakariaR', 1, 'md')
			end
		end
		if chex and not exd and msg.from.id ~= SUDO and not is_sudo(msg) then
			local text1 = '⚠ شارژ این گروه به اتمام رسید \n\nشناسه گروه :  <code>'..msg.to.id..'</code>\n\nدر صورتی که میخواهید ربات این گروه را ترک کند از دستور زیر استفاده کنید\n\n/leave '..msg.to.id..'\nبرای جوین دادن توی این گروه میتونی از دستور زیر استفاده کنی:\n/jointo '..msg.to.id..'\n_________________\nدر صورتی که میخواهید گروه رو دوباره شارژ کنید میتوانید از کد های زیر استفاده کنید...\n\n<b>برای شارژ 1 ماهه:</b>\n/plan 1 '..msg.to.id..'\n\n<b>برای شارژ 3 ماهه:</b>\n/plan 2 '..msg.to.id..'\n\n<b>برای شارژ نامحدود:</b>\n/plan 3 '..msg.to.id
			local text2 = '⚠ _شارژ این گروه به پایان رسید. به دلیل عدم شارژ مجدد، گروه از لیست ربات حذف و ربات از گروه خارج میشود._\nسودو ربات : @ZakariaR'
			local text3 = '☡ _Charging finished._\n\n*Group ID:*\n\n*ID:* `'..msg.to.id..'`\n\n*If you want the robot to leave this group use the following command:*\n\n`/Leave '..msg.to.id..'`\n\n*For Join to this group, you can use the following command:*\n\n`/Jointo '..msg.to.id..'`\n\n_________________\n\n_If you want to recharge the group can use the following code:_\n\n*To charge 1 month:*\n\n`/Plan 1 '..msg.to.id..'`\n\n*To charge 3 months:*\n\n`/Plan 2 '..msg.to.id..'`\n\n*For unlimited charge:*\n\n`/Plan 3 '..msg.to.id..'`'
			local text4 = '☡ _Charging finished. Due to lack of recharge remove the group from the robot list and the robot leave the group._\nOur Sudo : @ZakariaR'
			if lang then
				tdcli.sendMessage(SUDO, 0, 1, text1, 1, 'html')
				tdcli.sendMessage(msg.to.id, 0, 1, text2, 1, 'md')
			else
				tdcli.sendMessage(SUDO, 0, 1, text3, 1, 'md')
				tdcli.sendMessage(msg.to.id, 0, 1, text4, 1, 'md')
			end
			botrem(msg)
		else
			local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
			local day = (expiretime / 86400)
			if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
				warning(msg)
			end
		end
	end
end

local function run(msg, matches)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local Chash = "cmd_lang:"..msg.to.id
local Clang = redis:get(Chash)
 if tonumber(msg.from.id) == SUDO then
if ((matches[1] == "clear cache" and not Clang) or (matches[1] == "پاک کردن حافظه" and Clang)) then
     run_bash("rm -rf ~/.telegram-cli/data/sticker/*")
     run_bash("rm -rf ~/.telegram-cli/data/photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/animation/*")
     run_bash("rm -rf ~/.telegram-cli/data/video/*")
     run_bash("rm -rf ~/.telegram-cli/data/audio/*")
     run_bash("rm -rf ~/.telegram-cli/data/voice/*")
     run_bash("rm -rf ~/.telegram-cli/data/temp/*")
     run_bash("rm -rf ~/.telegram-cli/data/thumb/*")
     run_bash("rm -rf ~/.telegram-cli/data/document/*")
     run_bash("rm -rf ~/.telegram-cli/data/profile_photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/encrypted/*")
	 run_bash("rm -rf ./data/photos/*")
    return "✅ *All Cache Has Been Cleared*"
   end
if ((matches[1] == "visudo" and not Clang) or (matches[1] == "سودو" and Clang)) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="visudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="visudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="visudo"})
      end
   end
if ((matches[1] == "desudo" and not Clang) or (matches[1] == "حذف سودو" and Clang)) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="desudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="desudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="desudo"})
      end
   end
end
		if ((matches[1] == "config" and not Clang) or (matches[1] == "پیکربندی" and Clang)) and is_admin(msg) then
			return set_config(msg)
		end
if is_sudo(msg) then
   		if ((matches[1]:lower() == 'add' and not Clang) or (matches[1] == "افزودن" and Clang)) and not redis:get('ExpireDate:'..msg.to.id) then
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 180, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id,true)
				end
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚙_گروه به مدت 3 دقیقه برای اجرای تنظیمات شارژ میباشد._', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚙_Group charged 3 minutes  for settings._', 1, 'md')
				end
		end
		if ((matches[1] == 'rem' and not Clang) or (matches[1] == "حذف گروه" and Clang)) then
			if redis:get('CheckExpire::'..msg.to.id) then
				redis:del('CheckExpire::'..msg.to.id)
			end
			redis:del('ExpireDate:'..msg.to.id)
		end
		if ((matches[1]:lower() == 'gid' and not Clang) or (matches[1] == "اطلاعات" and Clang)) then
			tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..msg.to.id..'`', 1,'md')
		end
		if ((matches[1] == 'leave' and not Clang) or (matches[1] == "خروج" and Clang)) and matches[2] then
			if lang then
				tdcli.sendMessage(matches[2], 0, 1, '⚠ ربات با دستور سودو از گروه خارج شد.\nبرای اطلاعات بیشتر با سودو تماس بگیرید.', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ ربات با موفقیت از گروه '..matches[2]..' خارج شد.', 1,'md')
			else
				tdcli.sendMessage(matches[2], 0, 1, '☡ _Robot left the group._\n*For more information contact The SUDO.*', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ *Robot left from under group successfully:*\n\n`'..matches[2]..'`', 1,'md')
			end
		end
		if ((matches[1]:lower() == 'charge' and not Clang) or (matches[1] == "شارژ" and Clang)) and matches[2] and matches[3] then
		if string.match(matches[2], '^-%d+$') then
			if tonumber(matches[3]) > 0 and tonumber(matches[3]) < 1001 then
				local extime = (tonumber(matches[3]) * 86400)
				redis:setex('ExpireDate:'..matches[2], extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id,true)
				end
				if lang then
					tdcli.sendMessage(SUDO, 0, 1, '✅ ربات در گروه '..matches[2]..' به مدت '..matches[3]..' روز تمدید گردید.', 1, 'md')
					tdcli.sendMessage(matches[2], 0, 1, '✅ ربات توسط ادمین به مدت `'..matches[3]..'` روز شارژ شد\nبرای مشاهده زمان شارژ گروه دستور /check استفاده کنید...',1 , 'md')
				else
					tdcli.sendMessage(SUDO, 0, 1, '✅ *Recharged successfully in the group:* `'..matches[2]..'`\n_Expire Date:_ `'..matches[3]..'` *Day(s)*', 1, 'md')
					tdcli.sendMessage(matches[2], 0, 1, '✅ *Robot recharged* `'..matches[3]..'` *day(s)*\n*For checking expire date, send* `/check`',1 , 'md')
				end
			else
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _تعداد روزها باید عددی از 1 تا 1000 باشد._', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _Expire days must be between 1 - 1000_', 1, 'md')
				end
			end
		end
		end
		if ((matches[1]:lower() == 'plan' and not Clang) or (matches[1] == "پلن" and Clang)) then 
		if matches[2] == '1' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			local timeplan1 = 2592000
			redis:setex('ExpireDate:'..matches[3], timeplan1, true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ پلن 1 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه تا 30 روز دیگر اعتبار دارد! ( 1 ماه )', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '✅ _ربات با موفقیت فعال شد و تا 30 روز دیگر اعتبار دارد!_', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ *Plan 1 Successfully Activated!\nThis group recharged with plan 1 for 30 days (1 Month)*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '✅ *Successfully recharged*\n*Expire Date:* `30` *Days (1 Month)*', 1, 'md')
			end
		end
		end
		if matches[2] == '2' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			local timeplan2 = 7776000
			redis:setex('ExpireDate:'..matches[3],timeplan2,true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, 0, 1, '✅ پلن 2 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه تا 90 روز دیگر اعتبار دارد! ( 3 ماه )', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '✅ ربات با موفقیت فعال شد و تا 90 روز دیگر اعتبار دارد! ( 3 ماه )', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ *Plan 2 Successfully Activated!\nThis group recharged with plan 2 for 90 days (3 Month)*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '✅ *Successfully recharged*\n*Expire Date:* `90` *Days (3 Months)*', 1, 'md')
			end
		end
		end
		if matches[2] == '3' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			redis:set('ExpireDate:'..matches[3],true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ پلن 3 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه به صورت نامحدود شارژ شد!', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '✅ ربات بدون محدودیت فعال شد ! ( نامحدود )', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ *Plan 3 Successfully Activated!\nThis group recharged with plan 3 for unlimited*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '✅ *Successfully recharged*\n*Expire Date:* `Unlimited`', 1, 'md')
			end
		end
		end
		end
		if ((matches[1]:lower() == 'jointo' and not Clang) or (matches[1] == "ورود به" and Clang)) and matches[2] then
		if string.match(matches[2], '^-%d+$') then
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ با موفقیت تورو به گروه '..matches[2]..' اضافه کردم.', 1, 'md')
				tdcli.addChatMember(matches[2], SUDO, 0, dl_cb, nil)
				tdcli.sendMessage(matches[2], 0, 1, '⚠ _سودو به گروه اضافه شد._', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '✅ *I added you to this group:*\n\n`'..matches[2]..'`', 1, 'md')
				tdcli.addChatMember(matches[2], SUDO, 0, dl_cb, nil)
				tdcli.sendMessage(matches[2], 0, 1, '☡ Sudo Joined!', 1, 'md')
			end
		end
		end
end
	if ((matches[1]:lower() == 'savefile' and not Clang) or (matches[1] == "ذخیره فایل" and Clang)) and matches[2] and is_sudo(msg) then
		if msg.reply_id  then
			local folder = matches[2]
            function get_filemsg(arg, data)
				function get_fileinfo(arg,data)
                    if data.content_.ID == 'MessageDocument' or data.content_.ID == 'MessagePhoto' or data.content_.ID == 'MessageSticker' or data.content_.ID == 'MessageAudio' or data.content_.ID == 'MessageVoice' or data.content_.ID == 'MessageVideo' or data.content_.ID == 'MessageAnimation' then
                        if data.content_.ID == 'MessageDocument' then
							local doc_id = data.content_.document_.document_.id_
							local filename = data.content_.document_.file_name_
                            local pathf = tcpath..'/data/document/'..filename
							local cpath = tcpath..'/data/document'
                            if file_exi(filename, cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(doc_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>فایل</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>File</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessagePhoto' then
							local photo_id = data.content_.photo_.sizes_[2].photo_.id_
							local file = data.content_.photo_.id_
                            local pathf = tcpath..'/data/photo/'..file..'_(1).jpg'
							local cpath = tcpath..'/data/photo'
                            if file_exi(file..'_(1).jpg', cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(photo_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>عکس</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>Photo</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
		                if data.content_.ID == 'MessageSticker' then
							local stpath = data.content_.sticker_.sticker_.path_
							local sticker_id = data.content_.sticker_.sticker_.id_
							local secp = tostring(tcpath)..'/data/sticker/'
							local ffile = string.gsub(stpath, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(stpath, pfile)
                                file_dl(sticker_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>استیکر</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>Sticker</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageAudio' then
						local audio_id = data.content_.audio_.audio_.id_
						local audio_name = data.content_.audio_.file_name_
                        local pathf = tcpath..'/data/audio/'..audio_name
						local cpath = tcpath..'/data/audio'
							if file_exi(audio_name, cpath) then
								local pfile = folder
								os.rename(pathf, pfile)
								file_dl(audio_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>صدای</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>Audio</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
							else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡_This file does not exist. Send file again._', 1, 'md')
								end
							end
						end
						if data.content_.ID == 'MessageVoice' then
							local voice_id = data.content_.voice_.voice_.id_
							local file = data.content_.voice_.voice_.path_
							local secp = tostring(tcpath)..'/data/voice/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(file, pfile)
                                file_dl(voice_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>صوت</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>Voice</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageVideo' then
							local video_id = data.content_.video_.video_.id_
							local file = data.content_.video_.video_.path_
							local secp = tostring(tcpath)..'/data/video/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(file, pfile)
                                file_dl(video_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>ویديو</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>Video</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageAnimation' then
							local anim_id = data.content_.animation_.animation_.id_
							local anim_name = data.content_.animation_.file_name_
                            local pathf = tcpath..'/data/animation/'..anim_name
							local cpath = tcpath..'/data/animation'
                            if file_exi(anim_name, cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(anim_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>تصویر متحرک</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>Gif</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
                    else
                        return
                    end
                end
                tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, get_fileinfo, nil)
            end
	        tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_to_message_id_ }, get_filemsg, nil)
        end
    end
	if msg.to.type == 'channel' or msg.to.type == 'chat' then
		if ((matches[1] == 'charge' and not Clang) or (matches[1] == "شارژ" and Clang)) and matches[2] and not matches[3] and is_sudo(msg) then
			if tonumber(matches[2]) > 0 and tonumber(matches[2]) < 1001 then
				local extime = (tonumber(matches[2]) * 86400)
				redis:setex('ExpireDate:'..msg.to.id, extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id)
				end
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '✅ ربات با موفقیت تنظیم شد\nمدت فعال بودن ربات در گروه به '..matches[2]..' روز دیگر تنظیم شد...', 1, 'md')
					tdcli.sendMessage(SUDO, 0, 1, '✅ ربات در گروه '..matches[2]..' به مدت `'..msg.to.id..'` روز تمدید گردید.', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '✅ ربات با موفقیت تنظیم شد\nمدت فعال بودن ربات در گروه به '..matches[2]..' روز دیگر تنظیم شد...', 1, 'md')
					tdcli.sendMessage(SUDO, 0, 1, '✅ ربات در گروه '..matches[2]..' به مدت `'..msg.to.id..'` روز تمدید گردید.', 1, 'md')
				end
			else
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '⚠ _تعداد روزها باید عددی از 1 تا 1000 باشد._', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _Expire days must be between 1 - 1000_', 1, 'md')
				end
			end
		end
		if ((matches[1]:lower() == 'check' and not Clang) or (matches[1] == "اعتبار" and Clang)) and is_mod(msg) and not matches[2] then
			local check_time = redis:ttl('ExpireDate:'..msg.to.id)
			year = math.floor(check_time / 31536000)
			byear = check_time % 31536000
			month = math.floor(byear / 2592000)
			bmonth = byear % 2592000
			day = math.floor(bmonth / 86400)
			bday = bmonth % 86400
			hours = math.floor( bday / 3600)
			bhours = bday % 3600
			min = math.floor(bhours / 60)
			sec = math.floor(bhours % 60)
			if not lang then
				if check_time == -1 then
					remained_expire = '🔰 _Unlimited Charging!_'
				elseif tonumber(check_time) > 1 and check_time < 60 then
					remained_expire = '🔰 _Expire until_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 60 and check_time < 3600 then
					remained_expire = '🔰 _Expire until_ '..min..' _min_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
					remained_expire = '🔰 _Expire until_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
					remained_expire = '🔰 _Expire until_ *'..day..'* _day_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
					remained_expire = '🔰 _Expire until_ *'..month..'* _month_ *'..day..'* _day_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 31536000 then
					remained_expire = '🔰 _Expire until_ *'..year..'* _year_ *'..month..'* _month_ *'..day..'* _day_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
				end
				tdcli.sendMessage(msg.to.id, msg.id_, 1, remained_expire, 1, 'md')
			else
				if check_time == -1 then
					remained_expire = '🔰 _گروه به صورت نامحدود شارژ میباشد!_'
				elseif tonumber(check_time) > 1 and check_time < 60 then
					remained_expire = '🔰 _گروه به مدت_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 60 and check_time < 3600 then
					remained_expire = '🔰 _گروه به مدت_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
					remained_expire = '🔰 _گروه به مدت_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
					remained_expire = '🔰 _گروه به مدت_ *'..day..'* _روز و_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
					remained_expire = '🔰 _گروه به مدت_ *'..month..'* _ماه_ *'..day..'* _روز و_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 31536000 then
					remained_expire = '🔰 _گروه به مدت_ *'..year..'* _سال_ *'..month..'* _ماه_ *'..day..'* _روز و_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				end
				tdcli.sendMessage(msg.to.id, msg.id_, 1, remained_expire, 1, 'md')
			end
		end
	end
	if ((matches[1] == 'check' and not Clang) or (matches[1] == "اعتبار" and Clang)) and is_mod(msg) and matches[2] then
		if string.match(matches[2], '^-%d+$') then
			local check_time = redis:ttl('ExpireDate:'..matches[2])
			year = math.floor(check_time / 31536000)
			byear = check_time % 31536000
			month = math.floor(byear / 2592000)
			bmonth = byear % 2592000
			day = math.floor(bmonth / 86400)
			bday = bmonth % 86400
			hours = math.floor( bday / 3600)
			bhours = bday % 3600
			min = math.floor(bhours / 60)
			sec = math.floor(bhours % 60)
			if not lang then
				if check_time == -1 then
					remained_expire = '🔰 _Unlimited Charging!_'
				elseif tonumber(check_time) > 1 and check_time < 60 then
					remained_expire = '🔰 _Expire until_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 60 and check_time < 3600 then
					remained_expire = '🔰 _Expire until_ '..min..' _min_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
					remained_expire = '🔰 _Expire until_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
					remained_expire = '🔰 _Expire until_ *'..day..'* _day_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
					remained_expire = '🔰 _Expire until_ *'..month..'* _month_ *'..day..'* _day_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
				elseif tonumber(check_time) > 31536000 then
					remained_expire = '🔰 _Expire until_ *'..year..'* _year_ *'..month..'* _month_ *'..day..'* _day_ *'..hours..'* _hour_ *'..min..'* _min_ *'..sec..'* _sec_'
				end
				tdcli.sendMessage(msg.to.id, msg.id_, 1, remained_expire, 1, 'md')
			else
				if check_time == -1 then
					remained_expire = '🔰 _گروه به صورت نامحدود شارژ میباشد!_'
				elseif tonumber(check_time) > 1 and check_time < 60 then
					remained_expire = '🔰 _گروه به مدت_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 60 and check_time < 3600 then
					remained_expire = '🔰 _گروه به مدت_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
					remained_expire = '🔰 _گروه به مدت_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
					remained_expire = '🔰 _گروه به مدت_ *'..day..'* _روز و_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
					remained_expire = '🔰 _گروه به مدت_ *'..month..'* _ماه_ *'..day..'* _روز و_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				elseif tonumber(check_time) > 31536000 then
					remained_expire = '🔰 _گروه به مدت_ *'..year..'* _سال_ *'..month..'* _ماه_ *'..day..'* _روز و_ *'..hours..'* _ساعت و_ *'..min..'* _دقیقه و_ *'..sec..'* _ثانیه شارژ میباشد_'
				end
				tdcli.sendMessage(msg.to.id, msg.id_, 1, remained_expire, 1, 'md')
			end
		end
		end
if ((matches[1] == "adminprom" and not Clang) or (matches[1] == "ادمین" and Clang)) and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="adminprom"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="adminprom"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="adminprom"})
      end
   end
if ((matches[1] == "admindem" and not Clang) or (matches[1] == "حذف ادمین" and Clang)) and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.to.id,cmd="admindem"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="admindem"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="admindem"})
      end
   end

if ((matches[1] == 'creategroup' and not Clang) or (matches[1] == "ساخت گروه" and Clang)) and is_admin(msg) then
local text = matches[2]
tdcli.createNewGroupChat({[0] = msg.from.id}, text, dl_cb, nil)
  if not lang then
return '✅ _Group Has Been Created!_'
  else
return '✅ _گروه ساخته شد!_'
   end
end

if ((matches[1] == 'createsuper' and not Clang) or (matches[1] == "ساخت سوپرگروه" and Clang)) and is_admin(msg) then
local text = matches[2]
tdcli.createNewChannelChat(text, 1, '@BeyondTeam', (function(b, d) tdcli.addChatMember(d.id_, msg.from.id, 0, dl_cb, nil) end), nil)
   if not lang then 
return '✅ _SuperGroup Has Been Created and_ [`'..msg.from.id..'`] _Joined To This SuperGroup._'
  else
return '✅ _سوپرگروه ساخته شد و_ [`'..msg.from.id..'`] _به گروه اضافه شد._'
   end
end

if ((matches[1] == 'tosuper' and not Clang) or (matches[1] == "تبدیل به سوپرگروه" and Clang)) and is_admin(msg) then
local id = msg.to.id
tdcli.migrateGroupChatToChannelChat(id, dl_cb, nil)
  if not lang then
return '✅ _Group Has Been Changed To SuperGroup!_'
  else
return '🔰 _گروه به سوپر گروه تبدیل شد!_'
   end
end

if ((matches[1] == 'import' and not Clang) or (matches[1] == "ورود لینک" and Clang)) and is_admin(msg) then
if matches[2]:match("^([https?://w]*.?telegram.me/joinchat/.*)$") or matches[2]:match("^([https?://w]*.?t.me/joinchat/.*)$") then
local link = matches[2]
if link:match('t.me') then
link = string.gsub(link, 't.me', 'telegram.me')
end
tdcli.importChatInviteLink(link, dl_cb, nil)
   if not lang then
return '✅ *Done!*'
  else
return '✅ *انجام شد!*'
  end
  end
end

if ((matches[1] == 'setbotname' and not Clang) or (matches[1] == "تغییر نام ربات" and Clang)) and is_sudo(msg) then
tdcli.changeName(matches[2])
   if not lang then
return '✅ _Bot Name Changed To:_ *'..matches[2]..'*'
  else
return '✅ _اسم ربات تغییر کرد به:_ \n*'..matches[2]..'*'
   end
end

if ((matches[1] == 'setbotusername' and not Clang) or (matches[1] == "تغییر یوزرنیم ربات" and Clang)) and is_sudo(msg) then
tdcli.changeUsername(matches[2])
   if not lang then
return '✅ _Bot Username Changed To:_ @'..matches[2]
  else
return '✅ _یوزرنیم ربات تغییر کرد به:_ \n@'..matches[2]..''
   end
end

if ((matches[1] == 'delbotusername' and not Clang) or (matches[1] == "حذف یوزرنیم ربات" and Clang)) and is_sudo(msg) then
tdcli.changeUsername('')
   if not lang then
return '✅ *Done!*'
  else
return '✅ *انجام شد!*'
  end
end

if ((matches[1] == 'markread' and not Clang) or (matches[1] == "" and Clang)) and is_sudo(msg) then
if ((matches[2] == 'on' and not Clang) or (matches[2] == "فعال" and Clang)) then
redis:set('markread','on')
   if not lang then
return '✅ _Markread >_ *ON*'
else
return '✅ _تیک دوم >_ *روشن*'
   end
end
if ((matches[2] == 'off' and not Clang) or (matches[2] == "غیرفعال" and Clang)) then
redis:set('markread','off')
  if not lang then
return '✅ _Markread >_ *OFF*'
   else
return '✅ _تیک دوم >_ *خاموش*'
      end
   end
end

if ((matches[1] == 'bc' and not Clang) or (matches[1] == "ارسال" and Clang)) and is_admin(msg) then
		local text = matches[2]
tdcli.sendMessage(matches[3], 0, 0, text, 0)	end

if ((matches[1] == 'broadcast' and not Clang) or (matches[1] == "ارسال به همه" and Clang)) and is_sudo(msg) then		
local data = load_data(_config.moderation.data)		
local bc = matches[2]			
for k,v in pairs(data) do				
tdcli.sendMessage(k, 0, 0, bc, 0)			
end	
end

  if is_sudo(msg) then
	if ((matches[1]:lower() == "sendfile" and not Clang) or (matches[1] == "ارسال فایل" and Clang)) and matches[2] and matches[3] then
		local send_file = "./"..matches[2].."/"..matches[3]
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 1, nil, send_file, msg_caption, dl_cb, nil)
	end
	if ((matches[1]:lower() == "sendplug" and not Clang) or (matches[1] == "ارسال پلاگین" and Clang)) and matches[2] then
	    local plug = "./plugins/"..matches[2]..".lua"
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 1, nil, plug, msg_caption, dl_cb, nil)
    end
  end

    if ((matches[1]:lower() == 'save' and not Clang) or (matches[1] == "ذخیره پلاگین" and Clang)) and matches[2] and is_sudo(msg) then
        if tonumber(msg.reply_to_message_id_) ~= 0  then
            function get_filemsg(arg, data)
                function get_fileinfo(arg,data)
                    if data.content_.ID == 'MessageDocument' then
                        fileid = data.content_.document_.document_.id_
                        filename = data.content_.document_.file_name_
						file_dl(document_id)
						sleep(1)
                        if (filename:lower():match('.lua$')) then
                            local pathf = tcpath..'/data/document/'..filename
                            if pl_exi(filename) then
                                local pfile = 'plugins/'..matches[2]..'.lua'
                                os.rename(pathf, pfile)
								tdcli.sendMessage(msg.to.id, msg.id_,1, '✅ <b>Plugin</b> <code>'..matches[2]..'</code> <b>Has Been Saved.</b>', 1, 'html')
                            else
                                tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _This file does not exist. Send file again._', 1, 'md')
                            end
                        else
                            tdcli.sendMessage(msg.to.id, msg.id_, 1, '☡ _This file is not Plugin File._', 1, 'md')
                        end
                    else
                        return
                    end
                end
                tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, get_fileinfo, nil)
            end
	        tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_to_message_id_ }, get_filemsg, nil)
        end
    end

if ((matches[1] == 'sudolist' and not Clang) or (matches[1] == "لیست سودو" and Clang)) and is_sudo(msg) then
return sudolist(msg)
    end
if ((matches[1] == 'chats' and not Clang) or (matches[1] == "لیست گروه ها" and Clang)) and is_admin(msg) then
return chat_list(msg)
    end
   if ((matches[1]:lower() == 'join' and not Clang) or (matches[1] == "افزودن" and Clang)) and is_admin(msg) and matches[2] then
	   tdcli.sendMessage(msg.to.id, msg.id, 1, '✅ I Invite you in '..matches[2]..'', 1, 'html')
	   tdcli.sendMessage(matches[2], 0, 1, "☡ Admin Joined!", 1, 'html')
    tdcli.addChatMember(matches[2], msg.from.id, 0, dl_cb, nil)
  end
		if ((matches[1] == 'rem' and not Clang) or (matches[1] == "حذف گروه" and Clang)) and matches[2] and is_admin(msg) then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   tdcli.sendMessage(matches[2], 0, 1, "☡ Group has been removed by admin command", 1, 'html')
    return '✅ _Group_ *'..matches[2]..'* _removed_'
		end
if ((matches[1] == 'venus' and not Clang) or (matches[1] == "ونوس" and Clang)) then
return tdcli.sendMessage(msg.to.id, msg.id, 1, _config.info_text, 1, 'html')
    end
if ((matches[1] == 'adminlist' and not Clang) or (matches[1] == "لیست ادمین" and Clang)) and is_admin(msg) then
return adminlist(msg)
    end
     if ((matches[1] == 'leave' and not Clang) or (matches[1] == "خروج" and Clang)) and is_admin(msg) then
  tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
   end
     if ((matches[1] == 'autoleave' and not Clang) or (matches[1] == "خروج خودکار" and Clang)) and is_admin(msg) then
local hash = 'auto_leave_bot'
--Enable Auto Leave
     if ((matches[2] == 'enable' and not Clang) or (matches[2] == "فعال" and Clang)) then
    redis:del(hash)
   return '✅ Auto leave has been enabled'
--Disable Auto Leave
     elseif ((matches[2] == 'disable' and not Clang) or (matches[2] == "غیرفعال" and Clang)) then
    redis:set(hash, true)
   return '✅ Auto leave has been disabled'
--Auto Leave Status
      elseif ((matches[2] == 'status' and not Clang) or (matches[2] == "موقعیت" and Clang)) then
      if not redis:get(hash) then
   return '☡ Auto leave is enable'
       else
   return '☡ Auto leave is disable'
         end
      end
   end


if matches[1] == "helptools" and not Clang and is_mod(msg) then
if not lang then
text = [[

_Sudoer And Admins Venus BOT Help :_

🔰 *!visudo* `[username|id|reply]`
_Add Sudo_

🔰 *!desudo* `[username|id|reply]`
_Demote Sudo_

🔰 *!sudolist *
_Sudo(s) list_

🔰 *!adminprom* `[username|id|reply]`
_Add admin for bot_

🔰 *!admindem* `[username|id|reply]`
_Demote bot admin_

🔰 *!adminlist *
_Admin(s) list_

🔰 *!leave *
_Leave current group_

🔰 *!autoleave* `[disable/enable]`
_Automatically leaves group_

🔰 *!creategroup* `[text]`
_Create normal group_

🔰 *!createsuper* `[text]`
_Create supergroup_

🔰 *!tosuper *
_Convert to supergroup_

🔰 *!chats*
_List of added groups_

🔰 *!join* `[id]`
_Adds you to the group_

🔰 *!rem* `[id]`
_Remove a group from Database_

🔰 *!import* `[link]`
_Bot joins via link_

🔰 *!setbotname* `[text]`
_Change bot's name_

🔰 *!setbotusername* `[text]`
_Change bot's username_

🔰 *!delbotusername *
_Delete bot's username_

🔰 *!markread* `[off/on]`
_Second mark_

🔰 *!broadcast* `[text]`
_Send message to all added groups_

🔰 *!bc* `[text] [GroupID]`
_Send message to a specific group_

🔰 *!sendfile* `[folder] [file]`
_Send file from folder_

🔰 *!sendplug* `[plug]`
_Send plugin_

🔰 *!save* `[plugin name] [reply]`
_Save plugin by reply_

🔰 *!savefile* `[address/filename] [reply]`
_Save File by reply to specific folder_

🔰 *!config*
_Set Owner and Admin Group_

🔰 *!clear cache*
_Clear All Cache Of .telegram-cli/data_

🔰 *!check*
_Stated Expiration Date_

🔰 *!check* `[GroupID]`
_Stated Expiration Date Of Specific Group_

🔰 *!charge* `[GroupID]` `[Number Of Days]`
_Set Expire Time For Specific Group_

🔰 *!charge* `[Number Of Days]`
_Set Expire Time For Group_

🔰 *!jointo* `[GroupID]`
_Invite You To Specific Group_

🔰 *!leave* `[GroupID]`
_Leave Bot From Specific Group_

🔰 _You can use_ *[!/#]* _at the beginning of commands._

🔰 `This help is only for sudoers/bot admins.`
 
🔰 *This means only the sudoers and its bot admins can use mentioned commands.*

*Good luck ;)*]]
tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
else

text = [[
_راهنمای ادمین و سودو های ربات ونوس :_

🔰 *!visudo* `[username|id|reply]`
_اضافه کردن سودو_

🔰 *!desudo* `[username|id|reply]`
_حذف کردن سودو_

🔰 *!sudolist *
_لیست سودو‌های ربات_

🔰 *!adminprom* `[username|id|reply]`
_اضافه کردن ادمین به ربات_

🔰 *!admindem* `[username|id|reply]`
_حذف فرد از ادمینی ربات_

🔰 *!adminlist *
_لیست ادمین ها_

🔰 *!leave *
_خارج شدن ربات از گروه_

🔰 *!autoleave* `[disable/enable/status]`
_خروج خودکار_

🔰 *!creategroup* `[text]`
_ساخت گروه ریلم_

🔰 *!createsuper* `[text]`
_ساخت سوپر گروه_

🔰 *!tosuper *
_تبدیل به سوپر گروه_

🔰 *!chats*
_لیست گروه های مدیریتی ربات_

🔰 *join* `[ID]`
_جوین شدن توسط ربات_

🔰 *!rem* `[GroupID]`
_حذف گروه ازطریق پنل مدیریتی_

🔰 *!import* `[link]`
_جوین شدن ربات توسط لینک_

🔰 *!setbotname* `[text]`
_تغییر اسم ربات_

🔰 *!setbotusername* `[text]`
_تغییر یوزرنیم ربات_

🔰 *!delbotusername* 
_پاک کردن یوزرنیم ربات_

🔰 *!markread* `[on/off]`
_تیک دوم_

🔰 *!broadcast* `[text]`
_فرستادن پیام به تمام گروه های مدیریتی ربات_

🔰 *!bc* `[text]` `[GroupID]`
_ارسال پیام مورد نظر به گروه خاص_

🔰 *!sendfile* `[cd]` `[file]`
_ارسال فایل موردنظر از پوشه خاص_

🔰 *!sendplug* `[plugname]`
_ارسال پلاگ مورد نظر_

🔰 *!save* `[plugname] [reply]`
_ذخیره کردن پلاگین_

🔰 *!savefile* `[address/filename] [reply]`
_ذخیره کردن فایل در پوشه مورد نظر_

🔰 *!config*
_اضافه کردن سازنده و مدیران گروه به مدیریت ربات_

🔰 *!clear cache*
_پاک کردن کش مسیر .telegram-cli/data_

🔰 *!check*
_اعلام تاریخ انقضای گروه_

🔰 *check* `[GroupID]`
_اعلام تاریخ انقضای گروه مورد نظر_

🔰 *!charge* `[GroupID]` `[days]`
_تنظیم تاریخ انقضای گروه مورد نظر_

🔰 *!charge* `[days]`
_تنظیم تاریخ انقضای گروه_

🔰 *!jointo* `[GroupID]`
_دعوت شدن شما توسط ربات به گروه مورد نظر_

🔰 *!leave* `[GroupID]`
_خارج شدن ربات از گروه مورد نظر_

🔰 *شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید*

🔰 _این راهنما فقط برای سودو ها/ادمین های ربات میباشد!_

🔰 `این به این معناست که فقط سودو ها/ادمین های ربات میتوانند از دستورات بالا استفاده کنند!`

*موفق باشید ;)*]]
tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
end

end
if matches[1] == "راهنمای ابزار" and Clang and is_mod(msg) then
if not lang then
text = [[

_Sudoer And Admins Venus BOT Help :_

🔰 *سودو* `[username|id|reply]`
_Add Sudo_

🔰 *حذف سودو* `[username|id|reply]`
_Demote Sudo_

🔰 *لیست سودو *
_Sudo(s) list_

🔰 *ادمین* `[username|id|reply]`
_Add admin for bot_

🔰 *حذف ادمین* `[username|id|reply]`
_Demote bot admin_

🔰 *لیست ادمین *
_Admin(s) list_

🔰 *خروج *
_Leave current group_

🔰 *خروج خودکار* `[فعال/غیرفعال]`
_Automatically leaves group_

🔰 *ساخت گروه* `[متن]`
_Create normal group_

🔰 *ساخت سوپرگروه* `[متن]`
_Create supergroup_

🔰 *تبدیل به سوپرگروه *
_Convert to supergroup_

🔰 *لیست گروه ها*
_List of added groups_

🔰 *افزودن* `[id]`
_Adds you to the group_

🔰 *حذف گروه* `[id]`
_Remove a group from Database_

🔰 *ورود لینک* `[لینک]`
_Bot joins via link_

🔰 *تغییر نام ربات* `[متن]`
_Change bot's name_

🔰 *تغییر یوزرنیم ربات* `[متن]`
_Change bot's username_

🔰 *حذف یوزرنیم ربات *
_Delete bot's username_

🔰 *تیک دوم* `[فعال/غیرفعال]`
_Second mark_

🔰 *ارسال به همه* `[متن]`
_Send message to all added groups_

🔰 *ارسال* `[متن] [GroupID]`
_Send message to a specific group_

🔰 *ارسال فایل* `[مسیر] [اسم فایل]`
_Send file from folder_

🔰 *ارسال پلاگین* `[اسم پلاگین]`
_Send plugin_

🔰 *ذخیره پلاگین* `[اسم پلاگین] [reply]`
_Save plugin by reply_

🔰 *ذخیره فایل* `[مسیر/اسم فایل] [reply]`
_Save File by reply to specific folder_

🔰 *پیکربندی*
_Set Owner and Admin Group as Moderator_

🔰 *پاک کردن حافظه*
_Clear All Cache Of .telegram-cli/data_

🔰 *اعتبار*
_Stated Expiration Date_

🔰 *اعتبار* `[GroupID]`
_Stated Expiration Date Of Specific Group_

🔰 *شارژ* `[GroupID]` `[تعداد روز]`
_Set Expire Time For Specific Group_

🔰 *شارژ* `[تعداد روز]`
_Set Expire Time For Group_

🔰 *ورود به* `[GroupID]`
_Invite You To Specific Group_

🔰 *خروج* `[GroupID]`
_Leave Bot From Specific Group_

🔰 `This help is only for sudoers/bot admins.`
 
🔰 *This means only the sudoers and its bot admins can use mentioned commands.*

*Good luck ;)*]]
tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
else

text = [[
_راهنمای ادمین و سودو های ربات ونوس_

🔰 *سودو* `[username|id|reply]`
_اضافه کردن سودو_

🔰 *حذف سودو* `[username|id|reply]`
_حذف کردن سودو_

🔰 *لیست سودو* 
_لیست سودو‌های ربات_

🔰 *ادمین* `[username|id|reply]`
_اضافه کردن ادمین به ربات_

🔰 *حذف ادمین* `[username|id|reply]`
_حذف فرد از ادمینی ربات_

🔰 *لیست ادمین* 
_لیست ادمین ها_

🔰 *خروج* 
_خارج شدن ربات از گروه_

🔰 *خروج خودکار* `[غیرفعال/فعال | موقعیت]`
_خروج خودکار_

🔰 *ساخت گروه* `[اسم انتخابی]`
_ساخت گروه ریلم_

🔰 *ساخت سوپرگروه* `[اسم انتخابی]`
_ساخت سوپر گروه_

🔰 *تبدیل به سوپرگروه*
_تبدیل به سوپر گروه_

🔰 *لیست گروه ها*
_لیست گروه های مدیریتی ربات_

🔰 *افزودن* `[ایدی گروه]`
_جوین شدن توسط ربات_

🔰 *حذف گروه* `[ایدی گروه]`
_حذف گروه ازطریق پنل مدیریتی_

🔰 *ورود لینک* `[لینک_]`
_جوین شدن ربات توسط لینک_

🔰 *تغییر نام ربات* `[اسم جدید ربات]`
_تغییر اسم ربات_

🔰 *تغییر یوزرنیم ربات* `[یوزر نیم جدید ربات]`
_تغییر یوزرنیم ربات_

🔰 *حذف یوزرنیم ربات* 
_پاک کردن یوزرنیم ربات_

🔰 *تیک دوم* `[فعال/غیرفعال]`
_تیک دوم_

🔰 *ارسال به همه* `[متن]`
_فرستادن پیام به تمام گروه های مدیریتی ربات_

🔰 *ارسال* `[متن]` `[ایدی گروه]`
_ارسال پیام مورد نظر به گروه خاص_

🔰 *ارسال فایل* `[cd]` `[file]`
_ارسال فایل موردنظر از پوشه خاص_

🔰 *ارسال پلاگین* `[اسم پلاگین]`
_ارسال پلاگ مورد نظر_

🔰 * ذخیره پلاگین* `[اسم پلاگین] [reply]`
_ذخیره کردن پلاگین_

🔰 *ذخیره فایل* `[address/filename] [reply]`
_ذخیره کردن فایل در پوشه مورد نظر_

🔰 *پیکربندی*
_اضافه کردن سازنده و مدیران گروه به مدیریت ربات_

🔰 *پاک کردن حافظه*
_پاک کردن کش مسیر .telegram-cli/data_

🔰 *اعتبار*
_اعلام تاریخ انقضای گروه_

🔰 *اعتبار* `[ایدی گروه]`
_اعلام تاریخ انقضای گروه مورد نظر_

🔰 *شارژ* `[ایدی گروه]` `[تعداد روز]`
_تنظیم تاریخ انقضای گروه مورد نظر_

🔰 *شارژ* `[تعداد روز]`
_تنظیم تاریخ انقضای گروه_

🔰 *ورود به* `[ایدی گروه]`
_دعوت شدن شما توسط ربات به گروه مورد نظر_

🔰 *خروج* `[ایدی گروه]`
_خارج شدن ربات از گروه مورد نظر_

🔰 *شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید*

🔰 _این راهنما فقط برای سودو ها/ادمین های ربات میباشد!_

🔰 `این به این معناست که فقط سودو ها/ادمین های ربات میتوانند از دستورات بالا استفاده کنند!`

*موفق باشید ;)*]]
tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
end

end
end

return { 
patterns = {                                                                   
"^[!/#](helptools)$", 
"^[!/#](config)$", 
"^[!/#](visudo)$", 
"^[!/#](desudo)$",
"^[!/#](sudolist)$",
"^[!/#](visudo) (.*)$", 
"^[!/#](desudo) (.*)$",
"^[!/#](adminprom)$", 
"^[!/#](admindem)$",
"^[!/#](adminlist)$",
"^[!/#](adminprom) (.*)$", 
"^[!/#](admindem) (.*)$",
"^[!/#](leave)$",
"^[!/#](autoleave) (.*)$", 
"^[!/#](venus)$",
"^[!/#](creategroup) (.*)$",
"^[!/#](createsuper) (.*)$",
"^[!/#](tosuper)$",
"^[!/#](chats)$",
"^[!/#](clear cache)$",
"^[!/#](join) (-%d+)$",
"^[!/#](rem) (-%d+)$",
"^[!/#](import) (.*)$",
"^[!/#](setbotname) (.*)$",
"^[!/#](setbotusername) (.*)$",
"^[!/#](delbotusername) (.*)$",
"^[!/#](markread) (.*)$",
"^[!/#](bc) +(.*) (-%d+)$",
"^[!/#](broadcast) (.*)$",
"^[!/#](sendfile) (.*) (.*)$",
"^[!/#](save) (.*)$",
"^[!/#](sendplug) (.*)$",
"^[!/#](savefile) (.*)$",
"^[!/#]([Aa]dd)$",
"^[!/#]([Gg]id)$",
"^[!/#]([Cc]heck)$",
"^[!/#]([Cc]heck) (-%d+)$",
"^[!/#]([Cc]harge) (-%d+) (%d+)$",
"^[!/#]([Cc]harge) (%d+)$",
"^[!/#]([Jj]ointo) (-%d+)$",
"^[!/#]([Ll]eave) (-%d+)$",
"^[!/#]([Pp]lan) ([123]) (-%d+)$",
"^[!/#]([Rr]em)$",
	"^(پیکربندی)$",
	"^(افزودن)$",
	"^(حذف گروه)$",
    "^(حذف گروه) (-%d+)$",	
    "^(راهنمای ابزار)$",
	"^(لیست سودو)$",
	"^(اطلاعات)$",
	"^(ساخت گروه) (.*)$",
	"^(ورود به) (-%d+)$",
	"^(ساخت گروه) (.*)$",
	"^(ساخت سوپرگروه) (.*)$",
	"^(ذخیره فایل) (.*)$",
	"^(سودو)$",
	"^(سودو) (.*)$",	
	"^(حذف سودو)$",
	"^(حذف سودو) (.*)$",	
	"^(ادمین)$",
	"^(حذف ادمین)$",
	"^(حذف ادمین) (.*)$",
	"^(ارسال فایل) (.*)$",
	"^(حذف یوزرنیم ربات) (.*)$",
    "^(تغییر یوزرنیم ربات) (.*)$",
	"^(تغییر نام ربات) (.*)$",
	"^(تبدیل به سوپرگروه)$",
	"^(ارسال به همه) (.*)$",
	"^(لیست گروه ها)$",
	"^(خروج)$",
	"^(خروج) (-%d+)$",	
	"^(ارسال پلاگین) (.*)$",
	"^(لیست ادمین)$",
	"^(خروج خودکار) (.*)$",
    "^(شارژ) (-%d+) (%d+)$",
    "^(شارژ) (%d+)$",	
    "^(پلن) ([123]) (-%d+)$",
    "^(اعتبار)$",
    "^(اعتبار) (-%d+)$",
    "^(ذخیره پلاگین) (.*)$",
    "^(تیک دوم) (.*)$",
    "^(ارسال) +(.*) (-%d+)$",
	"^(افزودن) (-%d+)$",
	"^(پاک کردن حافظه)$",
	"^(ونوس)$",
}, 
run = run, pre_process = pre_process
}
-- #End By @VenusOfficial
