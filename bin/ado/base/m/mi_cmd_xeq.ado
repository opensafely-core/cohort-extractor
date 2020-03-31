*! version 1.1.4  20jan2015

/*
	mi xeq: <cmd> [|| <cmd> [...]]
*/

program mi_cmd_xeq, rclass
	local version : di "version " string(_caller()) ":"
	version 11

	u_mi_assert_set

	mata: _parse_colon("hascolon", "rhscmds")
	if (!`hascolon') { 
		di as err "colon missing"
		di as smcl as err ///
		"    syntax is    {bf:mi xeq} [{it:numlist}]{bf::} ..."
		exit 198
	}
	if (`"`0'"' != "") {
		numlist `"`0'"', integer range(>=0 <=`_dta[_mi_M]') sort
		local numlist `r(numlist)'
		gettoken lastel numrest : numlist
		foreach el of local numrest {
			if (`el'==`lastel') {
				di as smcl as err ///
				"repeated {it:m} values not allowed"
				exit 198
			}
			local lestel `el'
		}
		local lastel
		local numrest
	}
	else {
		local numlist
		forvalues i=0(1)`_dta[_mi_M]' {
			local numlist `numlist' `i'
		}
	}

	chk_rhscmds_okay `rhscmds'

	if (`_dta[_mi_M]'==0) {
		local holdmarker `_dta[_mi_marker]'
		char _dta[_mi_marker]
		cap noi `version' mi_xeq_origonly `rhscmds'
		char _dta[_mi_marker] `holdmarker'
		if _rc {
			exit _rc
		}
	}
	else {
		`version' u_mi_xeq_on_tmp_flongsep: ///
			mi_sub_xeq_all "`numlist'" `"`rhscmds'"'
	}
	return add
end

program chk_rhscmds_okay
	mata: u_mi_parse_xeq(`"`0'"') // creates N and cmd1 ... cmd`N'
	forvalues i=1(1)`N' {
		chk_rhscmds_okay_u `cmd`i'''
	}
end

program chk_rhscmds_okay_u
	gettoken cmd : 0, parse(" ,:")
	chk_rhscmds_chklist bad fullcmd sub : `"`cmd'"'
	if (`bad') {
		di as err `"{bf:mi xeq} may not be used with {bf:`fullcmd'}"'
		if ("`sub'"!="") {
			di as err "    use {bf:`sub'} instead"
		}
		exit 119
	}
end

program chk_rhscmds_chklist 
	args mbad mcmd msub  colon  cmd
	c_local `mbad' 1
	c_local `mcmd' `"`cmd'"'
	c_local `msub' `"mi `cmd'"'

	local l = strlen(`"`cmd'"')
	if (`"`cmd'"'==bsubstr("append", 1, max(3,`l'))) {
		c_local `mcmd' "append"
		c_local `msub' "mi append"
		exit
	}
	if (`"`cmd'"'==bsubstr("merge", 1, max(3,`l'))) {
		c_local `mcmd' "merge"
		c_local `msub' "mi merge"
		exit
	}
	if (`"`cmd'"'=="expand") {
		exit
	}
	if (`"`cmd'"'=="reshape") {
		exit
	}
	if (`"`cmd'"'=="reshape") {
		exit
	}
	if (`"`cmd'"'=="stsplit") {
		exit
	}
	if (`"`cmd'"'=="stjoin") {
		exit
	}
	if (`"`cmd'"'=="svyset") {
		exit
	}
	if (`"`cmd'"'=="xtset") {
		exit
	}
	if (`"`cmd'"'=="tsset") {
		exit
	}
	if (`"`cmd'"'=="tset") {
		c_local `mcmd' "tsset"
		c_local `msub' "mi tsset"
		exit
	}
	if (`"`cmd'"'=="stset") {
		exit
	}
	if (`"`cmd'"'=="streset") {
		exit
	}
	if (`"`cmd'"'=="st") {
		exit
	}
	if (`"`cmd'"'=="collapse") {
		c_local `msub'
		exit
	}
	if (`"`cmd'"'=="contract") {
		c_local `msub'
		exit
	}
	if (`"`cmd'"'=="statsby") {
		c_local `msub'
		exit
	}
	c_local `mbad' 0
	c_local `mcmd'
	c_local `msub'
end


program mi_xeq_origonly, rclass
	local version : di "version " string(_caller()) ":"
	version 11
	mata: u_mi_parse_xeq(`"`0'"')	// creates N and cmd1, ..., cmd`N'
	u_mi_certify_data, acceptable proper
	preserve
	di as txt
	di as smcl as txt "{it:m}=0 data:"
	forvalues i=1(1)`N' { 
		di as txt "-> " as res `"`cmd`i''"'
		`version' `cmd`i''
	}
	return add
	restore, not
end
