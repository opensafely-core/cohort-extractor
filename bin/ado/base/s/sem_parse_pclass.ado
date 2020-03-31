*! version 1.1.0  23may2011
program sem_parse_pclass, sclass
	version 12
	
	args spec optname

	local OPTS	SCOEf		///
			MCOEf		///
			SCONs		///
			MCONs 		///
			SERRvar		///
			MERRvar		///
			SMERrcov	///
			MEANex		///
			COVex
	
	local 0 `", `spec'"'
	capture noisily			///
	syntax [,	`OPTS'		///
			ALL		///
			NONE		///
	]
	local rc = _rc			
	if `rc' { 
		dis as err "in option `optname'()"
		exit `rc'
	}

	foreach opt of local OPTS {
		local lc = lower("`opt'")
		local alist `alist' `lc'
		local olist `olist' ``lc''
	}
	local nolist : list sizeof olist

	opts_exclusive "`none' `all'" `optname'
	if `nolist' {
		gettoken first : olist
		opts_exclusive "`none' `first'" `optname'
	}

	if "`all'" != "" | `nolist' == 0 {
		local olist : copy local alist
	}

	sreturn clear
	if "`none'" != "" {
		sreturn local pclass      none
		sreturn local pclass_out  `alist' 
	}
	else {
		sreturn local pclass      `olist' 
		sreturn local pclass_out  `:list alist - olist' 
	}
end

program sem_parse_pclass_error 
	args nopt spec optname
	
	if (`nopt'<=1) {
		exit
	}	
	
	dis as err "`spec' may not be combined with other pclass specifiers" 
	dis as err "in option `optname'()" 
	exit 198
end

exit
