*! version 1.0.0  06mar2009

program u_mi_imexport_fix_pre_suf
	version 11
	args prefix_name suffix_name colon  opname  string p_dflt s_dflt

	if (`"`string'"'=="") {
		c_local `prefix_name' "`p_dflt'"
		c_local `suffix_name' "`s_dflt'"
		exit
	}
	local n : word count `string'
	if (`n'!=2) {
		di as err `"`opname'(`string'): invalid syntax"'
		exit 198
	}
	gettoken prefix copy : string, parse(" ")
	gettoken suffix copy : copy,   parse(" ")

	if (`"`prefix'"' != "") {
		capture confirm name `prefix'
		if (_rc) {
			di as err `"`opname'(`string'): "`prefix'" invalid"
			exit 198
		}
	}
	
	if (`"`suffix'"' != "") {
		capture confirm name _`suffix'
		if (_rc) {
			di as err `"`opname'(`string'): "`suffix'" invalid"
			exit 198
		}
	}

	c_local `prefix_name' `prefix'
	c_local `suffix_name' `suffix'
end
