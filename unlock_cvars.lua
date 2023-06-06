local ConVar = ffi.typeof([[
	struct {
		char 		_pad[0x4];
		void* 		m_pNext;
		bool		m_bRegistered;
		const char* m_szName;
		const char* m_szDescription;
		int			m_nFlags;
	}*
]])

local CCvar = ffi.typeof([[
	struct {
		char _pad[0x30];
		void* m_pConvar;
	}*
]])

local convars = {}

local pCvar = ffi.cast(CCvar, Utils.CreateInterface("vstdlib.dll", "VEngineCvar007"))
local pConvar = ffi.cast(ConVar, pCvar.m_pConvar)

while pConvar ~= nil do
	local development = bit32.band(pConvar.m_nFlags, bit32.lshift(1, 1))
	local hidden = bit32.band(pConvar.m_nFlags, bit32.lshift(1, 4))
	
	convars[pConvar] = pConvar.m_nFlags
	
	if development ~= 0 then
		pConvar.m_nFlags = bit32.rshift(pConvar.m_nFlags, 1)
	end
	
	if hidden ~= 0 then
		pConvar.m_nFlags = bit32.rshift(pConvar.m_nFlags, 4)
	end
	
	pConvar = ffi.cast(ConVar, pConvar.m_pNext)
end

Cheat.RegisterCallback('destroy', function()
	for pConvar, nFlags in pairs(convars) do
	  pConvar.m_nFlags = nFlags
	end
end)