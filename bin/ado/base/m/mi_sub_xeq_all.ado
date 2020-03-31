*! version 1.0.4  25oct2011

program mi_sub_xeq_all, rclass
	local version : di "version " string(_caller()) ":"
	version 11
	args numlist rhscmds 

	local 0 `"`rhscmds'"'

	mata: u_mi_parse_xeq(`"`0'"')	// creates N and cmd1, ..., cmd`N'
	local M    `_dta[_mi_M]'
	local name `_dta[_mi_name]'

	local runcertify 0
	local nm : word count `numlist'
	forvalues im=1(1)`nm' {
		local m : word `im' of `numlist'
		di as txt
		di as smcl as txt "{it:m}=`m' data:"
		if (`m') {
			qui use _`m'_`name', clear 
		}
		else {
			mata: (void) st_updata(0)
		}
		local holdmarker `_dta[_mi_marker]'
		char _dta[_mi_marker]
		cap noi forvalues i=1(1)`N' {
			di as txt "-> " as res `"`cmd`i''"'
			`version' `cmd`i''
		}
		local rc = _rc
		char _dta[_mi_marker] `holdmarker'
		if `rc' {
			exit `rc'
		}
		if (`im'==`nm') {
			return add
		}
		local runcertify = `runcertify' + c(changed)
		if (`m'==0) { 
			qui save `name', replace
		}
		else {
			qui save _`m'_`name', replace
		}
	}
	qui use "`name'", clear 
	if (`runcertify') {
		qui u_mi_certify_data, acceptable proper sortok
		mata: (void) st_updata(1)
	}
end
