*! version 1.0.0  26jul2006
//  Returns the most highly nested object of the specified type in the
//  specified object.  
//
//  Usage:  _gs_rtmostofclass localname : classname object

program _gs_rtmostofclass
	version 10

	gettoken return    0      : 0
	gettoken colon     0      : 0
	gettoken classname object : 0

	local split : subinstr local object "." " " , all

//	if (`"`:word 1 of split'"' != `"`Global'"')  local try ".Global"

	foreach part of local split {
		local try `"`try'.`part'"'
		if 0``try'.isofclass `classname'' {
			local answer `"`try'"'
		}
	}
	local answer : subinstr local answer "." ""

	c_local `return' `"`answer'"'
end

