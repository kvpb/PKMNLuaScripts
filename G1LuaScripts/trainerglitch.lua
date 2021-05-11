local mbyte = memory.readbyte
local mword = memory.readword

local version = mword(0x14e)
local base_address
local atkdef
local spespc

if version == 0xc1a2 or version == 0x36dc or version == 0xd5dd or version == 0x299c then
	print("RBGY JPN game detected")
	base_address = 0xcfd8
elseif version == 0xe691 or version == 0xa9d then
	print("Red/Blue USA detected")
	base_address = 0xcff1
elseif version == 0x7c04 then
	print("Yellow USA detected")
	base_address = 0xcff0
elseif version == 0xd289 or version == 0x9c5e or version == 0xdc5c or version == 0xbc2e or version == 0x4a38 or version == 0xd714 or version == 0xfc7a or version == 0xa456 or version == 0x4940 or version == 0xa164 then
	print("Red/Blue EUR detected")
	base_address = 0xcff6
elseif version == 0x8f4e or version == 0xfb66 or version == 0x3756 or version == 0xc1b7 then
	print("Yellow EUR detected")
	base_address = 0xcff5
else
	print(string.format("Unknown version, code: %4x", version))
	print("Script stopped")
	return
end


function shiny(atkdef, spespc)
	if spespc == 0xAA then
		if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
			return true
		else
			return false
		end
	else
		return false
	end
end
--function shiny(atkdef, spespc) --function flawless(atkdef, spespc)
--	if spespc == 0xFF then
--		if atkdef == 0xFF then
--			return true
--		else
--			return false
--		end
--	else
--		return false
--	end
--end

local c = 0

state = savestate.create()
savestate.save(state)

while true do
	emu.frameadvance()
	savestate.save(state)
	i = 0
	while i < 250 do
		joypad.set(1, {B=true})
		vba.frameadvance()
		i = i + 1
	end
	atkdef = mbyte(base_address)
	spespc = mbyte(base_address + 1)
	c = c + 1
	if shiny(atkdef, spespc) then
		print("Shiny!!! Script stopped.")
		print("Counter:", c)
		print(string.format("Atk: %d", math.floor(atkdef / 16)))
		print(string.format("Def: %d", atkdef % 16))
		print(string.format("Spe: %d", math.floor(spespc / 16)))
		print(string.format("Spc: %d", spespc % 16))
		savestate.save(state)
		vba.pause()
		break
	else
		print(string.format(math.floor(atkdef / 16)), atkdef % 16, math.floor(spespc / 16), spespc % 16)
		savestate.load(state)
	end
end