local function run(msg, matches)
 if matches[1] == "getprofile" or matches[1] == "پروفایل" then
 local function dl_photo(arg,data)
 tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,'• Your ID : '..msg.sender_user_id_..' ') 
end
  tdcli_function ({ID =
 "GetUserProfilePhotos",user_id_ = 
msg.sender_user_id_,offset_ = 
matches[2],limit_ = 100000}, dl_photo, nil) 
end 
end 
return { 
patterns = { 
"^[!/#](getprofile) (%d+)$",
"^(پروفایل) (%d+)$"
},
run = run
}
