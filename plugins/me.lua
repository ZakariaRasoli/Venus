do
local function run(msg, matches)
  if matches[1]:lower() == 'me' or matches[1]:lower() == 'من' then
    if is_sudo(msg) then
	  send_document(get_receiver(msg), "./data/axs/sudo.webp", ok_cb, false)
      return "*• Firstname : `"..check_markdown(data.first_name_).."`\n*• Username :• `"..chack_markdown(msg.from.username).."`\n*• Your ID :* `"..msg.from.id.."*• Your Rank :* You're *SUDO!*"
    elseif is_admin(msg) then
	  send_document(get_receiver(msg), "./data/axs/admin.webp", ok_cb, false)
      return "*• Firstname : `"..check_markdown(data.first_name_).."`\n*• Username :• `"..chack_markdown(msg.from.username).."`\n*• Your ID :* `"..msg.from.id.."*• Your Rank :* You're *Admin!*"
    elseif is_owner(msg) then
	  send_document(get_receiver(msg), "./data/axs/owner.webp", ok_cb, false)
      return "*• Firstname : `"..check_markdown(data.first_name_).."`\n*• Username :• `"..chack_markdown(msg.from.username).."`\n*• Your ID :* `"..msg.from.id.."*• Your Rank :* You're the *Leader!*"
    elseif is_mod(msg) then
	  send_document(get_receiver(msg), "./data/axs/mod.webp", ok_cb, false)
      return "*• Firstname : `"..check_markdown(data.first_name_).."`\n*• Username :• `"..chack_markdown(msg.from.username).."`\n*• Your ID :* `"..msg.from.id.."*• Your Rank :* You're a *Moderator!*"
    else
	  send_document(get_receiver(msg), "./data/axs/mmbr.webp", ok_cb, false)
      return "*• Firstname : `"..check_markdown(data.first_name_).."`\n*• Username :• `"..chack_markdown(msg.from.username).."`\n*• Your ID :* `"..msg.from.id.."*• Your Rank :* You're just a *member!*"
    end
  end
end
return {
  patterns = {
    "^[!#/](me)$",
	"^(من)$"
    },
  run = run
}
end

--[[BY @ZakariaR:)]]