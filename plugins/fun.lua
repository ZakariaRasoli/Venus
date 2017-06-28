
--Begin Fun.lua By @VenusOfficial
--Special Thx To @ZakariaR
--------------------------------

local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
--------------------------------
local api_key = nil
local base_api = "https://maps.googleapis.com/maps/api"
--------------------------------
local function get_latlong(area)
	local api      = base_api .. "/geocode/json?"
	local parameters = "address=".. (URL.escape(area) or "")
	if api_key ~= nil then
		parameters = parameters .. "&key="..api_key
	end
	local res, code = https.request(api..parameters)
	if code ~=200 then return nil  end
	local data = json:decode(res)
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		lat  = data.results[1].geometry.location.lat
		lng  = data.results[1].geometry.location.lng
		acc  = data.results[1].geometry.location_type
		types= data.results[1].types
		return lat,lng,acc,types
	end
end
--------------------------------
local function get_staticmap(area)
	local api        = base_api .. "/staticmap?"
	local lat,lng,acc,types = get_latlong(area)
	local scale = types[1]
	if scale == "locality" then
		zoom=8
	elseif scale == "country" then 
		zoom=4
	else 
		zoom = 13 
	end
	local parameters =
		"size=600x300" ..
		"&zoom="  .. zoom ..
		"&center=" .. URL.escape(area) ..
		"&markers=color:red"..URL.escape("|"..area)
	if api_key ~= nil and api_key ~= "" then
		parameters = parameters .. "&key="..api_key
	end
	return lat, lng, api..parameters
end
--------------------------------
local function get_weather(location)
	print("Finding weather in ", location)
	local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
	local url = BASE_URL
	url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
	url = url..'&units=metric'
	local b, c, h = http.request(url)
	if c ~= 200 then return nil end
	local weather = json:decode(b)
	local city = weather.name
	local country = weather.sys.country
	local temp = ' دمـــــایـــــ شـــــهـــــر '..city..' هـــــمـــــ اکـــــنـــــونـــــ '..weather.main.temp..' درجـــــهـــــ ســـــلـــــســـــیـــــوســـــ مـــــیـــــبـــــاشـــــد\n_________________'
	local conditions = 'شـــــرایـــــطـــــ فـــــعـــــلـــــیـــــ آبـــــ و هـــــوا : '
	if weather.weather[1].main == 'Clear' then
		conditions = conditions .. 'آفـــــتـــــابـــــیـــــ☀'
	elseif weather.weather[1].main == 'Clouds' then
		conditions = conditions .. 'ابـــــریـــــ ☁☁'
	elseif weather.weather[1].main == 'Rain' then
		conditions = conditions .. 'بـــــارانـــــیـــــ ☔'
	elseif weather.weather[1].main == 'Thunderstorm' then
		conditions = conditions .. 'طـــــوفـــــانـــــیـــــ ☔☔☔☔'
	elseif weather.weather[1].main == 'Mist' then
		conditions = conditions .. 'مـــــهـــــ 💨'
	end
	return temp .. '\n' .. conditions
end
--------------------------------
local function calc(exp)
	url = 'http://api.mathjs.org/v1/'
	url = url..'?expr='..URL.escape(exp)
	b,c = http.request(url)
	text = nil
	if c == 200 then
    text = 'Result = '..b..'\n____________________'
	elseif c == 400 then
		text = b
	else
		text = 'Unexpected error\n'
		..'Is api.mathjs.org up?'
	end
	return text
end
--------------------------------
function exi_file(path, suffix)
    local files = {}
    local pth = tostring(path)
	local psv = tostring(suffix)
    for k, v in pairs(scandir(pth)) do
        if (v:match('.'..psv..'$')) then
            table.insert(files, v)
        end
    end
    return files
end
--------------------------------
function file_exi(name, path, suffix)
	local fname = tostring(name)
	local pth = tostring(path)
	local psv = tostring(suffix)
    for k,v in pairs(exi_file(pth, psv)) do
        if fname == v then
            return true
        end
    end
    return false
end
--------------------------------
function run(msg, matches) 
local Chash = "cmd_lang:"..msg.to.id
local Clang = redis:get(Chash)
	if (matches[1]:lower() == 'calc' and not Clang) or (matches[1]:lower() == 'ماشین حساب' and Clang) and matches[2] then 
		if msg.to.type == "pv" then 
			return 
       end
		return calc(matches[2])
	end
--------------------------------
	if (matches[1]:lower() == 'praytime' and not Clang) or (matches[1]:lower() == 'ساعات شرعی' and Clang) then
		if matches[2] then
			city = matches[2]
		elseif not matches[2] then
			city = 'Arbil'
		end
		local lat,lng,url	= get_staticmap(city)
		local dumptime = run_bash('date +%s')
		local code = http.request('http://api.aladhan.com/timings/'..dumptime..'?latitude='..lat..'&longitude='..lng..'&timezonestring=Asia/Tehran&method=7')
		local jdat = json:decode(code)
		local data = jdat.data.timings
		local text = 'شـــــهـــــر : '..city
		text = text..'\nاذانـــــ صـــــبـــــحـــــ : '..data.Fajr
		text = text..'\nطـــــلـــــوعـــــ آفـــــتـــــابـــــ : '..data.Sunrise
		text = text..'\nاذانـــــ ظـــــهـــــر : '..data.Dhuhr
		text = text..'\nغـــــروبـــــ آفـــــتـــــابـــــ : '..data.Sunset
		text = text..'\nاذانـــــ مـــــغـــــربـــــ : '..data.Maghrib
		text = text..'\nعـــــشـــــاء : '..data.Isha
		text = text..msg_caption
		return tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'html')
	end
--------------------------------
	if (matches[1]:lower() == 'tophoto' and not Clang) or (matches[1]:lower() == 'تبدیل به عکس' and Clang) and msg.reply_id then
		function tophoto(arg, data)
			function tophoto_cb(arg,data)
				if data.content_.sticker_ then
					local file = data.content_.sticker_.sticker_.path_
					local secp = tostring(tcpath)..'/data/sticker/'
					local ffile = string.gsub(file, '-', '')
					local fsecp = string.gsub(secp, '-', '')
					local name = string.gsub(ffile, fsecp, '')
					local sname = string.gsub(name, 'webp', 'jpg')
					local pfile = 'data/photos/'..sname
					local pasvand = 'webp'
					local apath = tostring(tcpath)..'/data/sticker'
					if file_exi(tostring(name), tostring(apath), tostring(pasvand)) then
						os.rename(file, pfile)
						tdcli.sendPhoto(msg.to.id, 0, 0, 1, nil, pfile, msg_caption, dl_cb, nil)
					else
						tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This sticker does not exist. Send sticker again._'..msg_caption, 1, 'md')
					end
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This is not a sticker._', 1, 'md')
				end
			end
            tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, tophoto_cb, nil)
		end
		tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_id }, tophoto, nil)
    end
--------------------------------
	if (matches[1]:lower() == 'tosticker' and not Clang) or (matches[1]:lower() == 'تبدیل به استیکر' and Clang) and msg.reply_id then
		function tosticker(arg, data)
			function tosticker_cb(arg,data)
				if data.content_.ID == 'MessagePhoto' then
					file = data.content_.photo_.id_
					local pathf = tcpath..'/data/photo/'..file..'_(1).jpg'
					local pfile = 'data/photos/'..file..'.webp'
					if file_exi(file..'_(1).jpg', tcpath..'/data/photo', 'jpg') then
						os.rename(pathf, pfile)
						tdcli.sendDocument(msg.chat_id_, 0, 0, 1, nil, pfile, msg_caption, dl_cb, nil)
					else
						tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This photo does not exist. Send photo again._', 1, 'md')
					end
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This is not a photo._', 1, 'md')
				end
			end
			tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, tosticker_cb, nil)
		end
		tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_id }, tosticker, nil)
    end
--------------------------------
	if (matches[1]:lower() == 'weather' and not Clang) or (matches[1]:lower() == 'اب و هوا' and Clang) then
		city = matches[2]
		local wtext = get_weather(city)
		if not wtext then
			wtext = 'مـــــکـــــانـــــ وارد شـــــدهـــــ صـــــحـــــیـــــحـــــ نـــــیـــــســـــتـــــ '
		end
		return wtext
	end
--------------------------------
	if (matches[1]:lower() == 'time' and not Clang) or (matches[1]:lower() == 'ساعت' and Clang) then
		local url , res = http.request('http://irapi.ir/time/')
		if res ~= 200 then
			return "No connection"
		end
		local colors = {'blue','green','yellow','magenta','Orange','DarkOrange','red'}
		local fonts = {'mathbf','mathit','mathfrak','mathrm'}
		local jdat = json:decode(url)
		local url = 'http://latex.codecogs.com/png.download?'..'\\dpi{600}%20\\huge%20\\'..fonts[math.random(#fonts)]..'{{\\color{'..colors[math.random(#colors)]..'}'..jdat.ENtime..'}}'
		local file = download_to_file(url,'Venus.webp')
		tdcli.sendDocument(msg.to.id, 0, 0, 1, nil, file, msg_caption, dl_cb, nil)

	end
--------------------------------
	if (matches[1]:lower() == 'voice' and not Clang) or (matches[1]:lower() == 'تبدیل به صدا' and Clang) then
 local text = matches[2]
    textc = text:gsub(' ','.')
    
  if msg.to.type == 'pv' then 
      return nil
      else
  local url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text="..textc
  local file = download_to_file(url,'VenusBOT.mp3')
 				tdcli.sendDocument(msg.to.id, 0, 0, 1, nil, file, msg_caption, dl_cb, nil)
   end
end

 --------------------------------
	if (matches[1]:lower() == 'tr' and not Clang) or (matches[1]:lower() == 'ترجمه' and Clang) then 
		url = https.request('https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160119T111342Z.fd6bf13b3590838f.6ce9d8cca4672f0ed24f649c1b502789c9f4687a&format=plain&lang='..URL.escape(matches[2])..'&text='..URL.escape(matches[3]))
		data = json:decode(url)
		return 'زبـــــانـــــ : '..data.lang..'\nتـــــرجـــــمـــــهـــــ : '..data.text[1]..'\n____________________'..msg_caption
	end
--------------------------------
	if (matches[1]:lower() == 'short' and not Clang) or (matches[1]:lower() == 'لینک کوتاه' and Clang) then
		if matches[2]:match("[Hh][Tt][Tt][Pp][Ss]://") then
			shortlink = matches[2]
		elseif not matches[2]:match("[Hh][Tt][Tt][Pp][Ss]://") then
			shortlink = "https://"..matches[2]
		end
		local yon = http.request('http://api.yon.ir/?url='..URL.escape(shortlink))
		local jdat = json:decode(yon)
		local bitly = https.request('https://api-ssl.bitly.com/v3/shorten?access_token=f2d0b4eabb524aaaf22fbc51ca620ae0fa16753d&longUrl='..URL.escape(shortlink))
		local data = json:decode(bitly)
		local u2s = http.request('http://u2s.ir/?api=1&return_text=1&url='..URL.escape(shortlink))
		local llink = http.request('http://llink.ir/yourls-api.php?signature=a13360d6d8&action=shorturl&url='..URL.escape(shortlink)..'&format=simple')
		local text = ' 🌐لـــــیـــــنـــــکـــــ اصـــــلـــــیـــــ  :\n'..check_markdown(data.data.long_url)..'\n\nلینکهای کوتاه شده با 6 سایت کوتاه ساز لینک : \n》کـــــوتـــــاهـــــ شـــــدهـــــ بـــــا bitly :\n___________________________\n'..(check_markdown(data.data.url) or '---')..'\n___________________________\n》کـــــوتـــــاهـــــ شـــــدهـــــ بـــــا u2s :\n'..(check_markdown(u2s) or '---')..'\n___________________________\n》کـــــوتـــــاهـــــ شـــــدهـــــ بـــــا llink : \n'..(check_markdown(llink) or '---')..'\n___________________________\n》لینک کـــــوتـــــاهـــــ شـــــدهـــــ بـــــا yon : \nyon.ir/'..(check_markdown(jdat.output) or '---')..'\n____________________'..msg_caption
		return tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'html')
	end
--------------------------------
	if (matches[1]:lower() == 'sticker' and not Clang) or (matches[1]:lower() == 'استیکر' and Clang) then
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'Venus.webp')
		tdcli.sendDocument(msg.to.id, 0, 0, 1, nil, file, msg_caption, dl_cb, nil)
	end
--------------------------------
	if (matches[1]:lower() == 'عکس' and not Clang) or (matches[1]:lower() == 'عکس' and Clang) then
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'Venus.jpg')
		tdcli.sendPhoto(msg.to.id, 0, 0, 1, nil, file, msg_caption, dl_cb, nil)
	end


--------------------------------
if matches[1] == "helpfun" and not Clang then
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not lang then
helpfun_en = [[
*• Venus BOT Fun Help Commands :*

🔰 *!time*
_Get time in a sticker_

🔰 *!short* `[link]`
_Make short url_

🔰 *!voice* `[text]`
_Convert text to voice_

🔰 *!tr* `[lang] [word]`
_Translates FA to EN and EN to FA_
_Example:_
*!tr fa hi*

🔰 *!sticker* `[word]`
_Convert text to sticker_

🔰 *!photo* `[word]`
_Convert text to photo_

🔰 *!calc* `[number]`
Calculator

🔰 *!praytime* `[city]`
_Get Patent (Pray Time)_

🔰 *!tosticker* `[reply]`
_Convert photo to sticker_

🔰 *!tophoto* `[reply]`
_Convert text to photo_

🔰 *!weather* `[city]`
_Get weather_

_You can use_ *[!/#]* _at the beginning of commands._

*Good luck ;)*]]
else

helpfun_en = [[
_• راهنمای فان ربات ونوس_

🔰 *!time*
_دریافت ساعت به صورت استیکر_

🔰 *!short* `[link]`
_کوتاه کننده لینک_

🔰 *!voice* `[text]`
_تبدیل متن به صدا_

🔰 *!tr* `[lang]` `[word]`
_ترجمه متن فارسی به انگلیسی وبرعکس_
_مثال:_
_!tr en سلام_

🔰 *!sticker* `[word]`
_تبدیل متن به استیکر_

🔰 *!photo* `[word]`
_تبدیل متن به عکس_

🔰 *!calc* `[number]`
_ماشین حساب_

🔰 *!praytime* `[city]`
_اعلام ساعات شرعی_

🔰 *!tosticker* `[reply]`
_تبدیل عکس به استیکر_

🔰 *!tophoto* `[reply]`
_تبدیل استیکر‌به عکس_

🔰 *!weather* `[city]`
_دریافت اب وهوا_

*شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید*

موفق باشید ;)]]
end
return helpfun_en..msg_caption
end

if matches[1] == "راهنمای سرگرمی" and Clang then
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not lang then
helpfun_fa = [[
*• Venus BOT Fun Help Commands :*

🔰 *ساعت*
_Get time in a sticker_

🔰 *لینک کوتاه* `[لینک]`
_Make short url_

🔰 *تبدیل به صدا* `[متن]`
_Convert text to voice_

🔰 *ترجمه* `[زبان] [کلمه]`
_Translates FA to EN and EN to FA_
_Example:_
*ترجمه hi fa*

🔰 *استیکر* `[متن]`
_Convert text to sticker_

🔰 *عکس* `[متن]`
_Convert text to photo_

🔰 *ماشین حساب* `[معادله]`
_Calculator_

🔰 *ساعات شرعی* `[شهر]`
_Get Patent (Pray Time)_

🔰 *تبدیل به استیکر* `[ریپلی]`
_Convert photo to sticker_

🔰 *تبدیل به عکس* `[ریپلی]`
_Convert text to photo_

🔰 *اب و هوا* `[شهر]`
_Get weather_

*Good luck ;)*]]
else

helpfun_fa = [[
_• راهنمای فان ربات ونوس :_

🔰 *ساعت*
_دریافت ساعت به صورت استیکر_

🔰 *لینک کوتاه* `[لینک]`
_کوتاه کننده لینک_

🔰 *تبدیل به صدا* `[متن]`
_تبدیل متن به صدا_

🔰 *ترجمه* `[زبان]` `[متن]`
_ترجمه متن فارسی به انگلیسی وبرعکس_
_مثال:_
_ترجمه en سلام_

🔰 *استیکر* `[متن]`
_تبدیل متن به استیکر_

🔰 *استیکر* `[متن]`
_تبدیل متن به عکس_

🔰 *ماشین حساب* `[معادله]`
_ماشین حساب_

🔰 *ساعات شرعی* `[شهر]`
_اعلام ساعات شرعی_

🔰 *تبدیل به استیکر* `[ریپلی]`
_تبدیل عکس به استیکر_

🔰 *تبدیل به عکس* `[ریپلی]`
_تبدیل استیکر‌به عکس_

🔰 *اب و هوا* `[شهر]`
_دریافت اب وهوا_

موفق باشید ;)]]
end
return helpfun_fa..msg_caption
end

end
--------------------------------
return {               
	patterns = {
      "^[!/#](helpfun)$",
    	"^[!/#](weather) (.*)$",
		"^[!/](calc) (.*)$",
		"^[#!/](time)$",
		"^[#!/](tophoto)$",
		"^[#!/](tosticker)$",
		"^[!/#](voice) +(.*)$",
		"^[/!#]([Pp]raytime) (.*)$",
		"^[/!#](praytime)$",
		"^[!/]([Tt]r) ([^%s]+) (.*)$",
		"^[!/]([Ss]hort) (.*)$",
		"^[!/](photo) (.+)$",
		"^[!/](sticker) (.+)$",
        "^(راهنمای سرگرمی)$",
    	"^(اب و هوا) (.*)$",
		"^(ماشین حساب) (.*)$",
		"^(ساعت)$",
		"^(تبدیل به عکس)$",
		"^(تبدیل به استیکر)$",
		"^(تبدیل به صدا) +(.*)$",
		"^(ساعات شرعی) (.*)$",
		"^(ساعات شرعی)$",
		"^(ترجمه) ([^%s]+) (.*)$",
		"^(لینک کوتاه) (.*)$",
		"^(عکس) (.+)$",
		"^(استیکر) (.+)$"
		}, 
	run = run,
	}

--#by @VenuaOfficial :)
