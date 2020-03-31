*! version 1.0.7  05may2016

/*
	mi reshape long <stubnames>, i(varlist) j(newvarname) [<options>]

	mi reshape wide <varnames> , i(varlist) j(varname)   [<options>]
*/

program mi_cmd_reshape
	version 11.0

	/* ------------------------------------------------------------ */
						/* parse		*/
	u_mi_assert_set
	capture noi parse_reshape type stubs iv jv missing reshapecmd : `"`0'"'
	if (_rc) {
		local rc = _rc
		if (`rc'!=1) {
			parse_reshape_msg
		}
		exit `rc'
	}
	if ("`type'"=="long" & "`missing'"!="") { /*undoc opt*/
		/* opt missing is only allowed with mi reshape wide */
		di as err "{p}option {bf:missing} is allowed only with"
		di as err "{bf:mi reshape wide}{p_end}"
		exit 198
	}
	u_mi_certify_data, acceptable
	checkiv "i()" "`iv'"
	checkiv "j()" "`jv'"
	checkstubs "`stubs'"
	/* ------------------------------------------------------------ */
	u_mi_xeq_on_tmp_flongsep:				///
		novarabbrev nobreak  mi_sub_reshape 		///
			`type' "`stubs'" "`iv'" "`jv'" ///
			`"`reshapecmd'"'
	u_mi_fixchars, proper
	if ("`type'"=="wide" & "`missing'"!="") {
		fix_ivars _dta[_mi_ivars]
		fix_ivars _dta[_mi_pvars]
	}
end


program parse_reshape
	args usertype userstubs useriv userjv missopt reshapecmd colon  orig

	gettoken type rest : orig, parse(" ,")
	if (!("`type'"=="wide" | "`type'"=="long")) {
		di as err "invalid syntax"
		exit 198
	}

	local stubs
	gettoken token rest : rest, parse(" ,")
	while ("`token'"!=",") { 
		if (`"`token'"'=="") {
			parse_ij_msg "" ""
/*
			di as err "option i() required"
			exit 198
*/
		}
		local stubs `stubs' `token'
		gettoken token rest : rest, parse(" ,")
	}
	local 0 `", `rest'"'
	syntax , i(varlist) j(string) [MISSing/*undoc*/ *]
	c_local `missopt' `missing'
	c_local `reshapecmd' `"reshape `type' `stubs', i(`i') j(`j') `options'"'
	parse_ij_msg "`i'" `"`j'"'
/*
	if ("`i'"=="") | `"`j'"'=="") {
		if ("`i'"=="" & "`j'"=="") {
			di as err "options {bf:i()} and {bf:j()} required"
		}
		else if ("`i'"=="") {
			di as err "option {bf:i()} required"
		}
		else {
			di as err "option {bf:j()} required"
		}
		di as err  "{p 4 4 2}"
		di as err  "Unlike {bf:reshape}, {bf:mi reshape} requires"
		di as err  ///
		"that {bf:i()} and {bf:j()} be specified; {bf: mi reshape}"
		di as err  ///
		"does not remember settings from previous {bf:mi reshape}"
		di as err  "commands."
		di as err  "{p_end}"
		exit 198
	}
*/

	gettoken jname : j 
	capture confirm name `jname'
	if (_rc) {
		di as err "option j() improperly specified"
		exit 198
	}
	if ("`type'"=="wide") { 
		novarabbrev confirm var `jname'
	}
	else {
		capture confirm new var `jname'
		if (_rc) { 
			di as err "variable `jname' already exists"
			exit 110
		}
	}

	c_local `usertype' `type'
	c_local `userstubs' `stubs'
	c_local `useriv'   `i'
	c_local `userjv'   `jname'
end

program parse_ij_msg
	args i j 
	if ("`i'" != "") {
		if (`"`j'"' != "") {
			exit
		}
	}

	if ("`i'"=="" & "`j'"=="") {
		di as err "  options {bf:i()} and {bf:j()} required"
	}
	else if ("`i'"=="") {
		di as err "  option {bf:i()} required"
	}
	else {
		di as err "  option {bf:j()} required"
	}
	di as err  "{p 6 6 2}"
	di as err  "Unlike {bf:reshape}, {bf:mi reshape} requires"
	di as err  ///
	"that {bf:i()} and {bf:j()} be specified; {bf: mi reshape}"
	di as err  ///
	"does not remember settings from previous {bf:mi reshape}"
	di as err  "commands."
	di as err  "{p_end}"
	exit 198
end



program parse_reshape_msg
	di as smcl as err "   {bf:mi reshape} syntax is"

	di as smcl as err ///
"       {bf:mi reshape wide} {it:varname(s)}{bf:,  i}({it:varlist}{bf:) j(}{it:varname}{bf:)} ..."

	di as smcl as err ///
	"       {bf:mi reshape long} {it:stubname(s)}{bf:, i(}{it:varlist}{bf:) j(}{it:newvarname}{bf:)} ..."

end

program checkiv
	args opid iv
						/* i() not ivar or pvar */
	local vars `_dta[_mi_ivars]' `_dta[_mi_pvars]'
	local bad : list iv & vars
	if ("`bad'" != "") {
		local n : word count "`bad'"
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "`variables' `bad'"
		di as smcl as err "registered as imputed or passive; option"
		di as smcl as err ///
		"{bf:`opid'} may not contain imputed or passive variables"
		di as smcl as err "{p_end}"
		exit 198
	}

						/* i() may not be sysvars */
	local sys "_mi_m _mi_id _mi_miss"
	local bad : list iv & sys
	if ("`bad'" != "") {
		di as smcl as err "{p}"
		di as smcl as err ///
		"{bf:`opid'} may not contain system variables such as"
		di as smcl as err "{bf:_mi_m}, {bf:_mi_id}, or {bf:_mi_miss}"
		di as smcl as err "{p_end}"
		exit 198
	}
						/* i() not _#_...	*/
	capture has_n_ "`iv'"
	if (_rc) { 
		di as smcl as err ///
		"`opid' may not contain _{it:#}_{it:name} variables"
		exit 198
	}
end

program checkstubs 
	args stubs

	//check that stubs do not contain @
	if (`=strpos("`stubs'","@")') {
		di as smcl as err ///
			"{bf:mi reshape:} {it:stubs} may not contain {bf:@}"
		exit 198
	}

	capture has_n_ "`stubs'"
	if (_rc) { 
		di as smcl as err ///
			"{it:stubs} may not be of the form _{it:#}_{it:name}"
		di as smcl as err ///
			"   specify the names without the _{it:#}_ prefix"
		exit 198
	}
	capture check_registered_same errstub "`stubs'"
	if (_rc) {
		di as err "{bf:`errstub'}#: variable registration conflict;"
		di as err "{p 4 4 2}"
		di as err "All variables corresponding to the same {it:stub} "
		di as err "({bf:`errstub'}) must be registered the same, "
		di as err "as imputed, passive, or regular.{p_end}"
		exit 198
	}
end

program has_n_ 
	args list 

	foreach name of local list {
		if (bsubstr("`name'", 1, 1)=="_") {
			local subname = bsubstr("`name'", 2, .)
			local i = strpos("`subname'", "_")
			if (`i'>1) {
				local prob = bsubstr("`subname'", 1, `i'-1)
				capture confirm integer number `prob'
				if (_rc==0) {
					exit 198
				}
			}
		}
	}
end

program check_registered_same
	args errstub list 

	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
	foreach name of local list {
		local regexp "`name'[0-9]+ |`name'[0-9]+$"
		local cnt = regexm("`ivars'", "`regexp'")
		local cnt = `cnt' + regexm("`pvars'", "`regexp'")
		local cnt = `cnt' + regexm("`rvars'", "`regexp'")
		if (`cnt'>1) {
			c_local `errstub' "`name'"
			exit 198
		}
	}
end

program fix_ivars
	args charname
	local style : char _dta[_mi_style]
	if ("`style'"=="flong" | "`style'"=="mlong") {
		local iflong " & _mi_m==0"
	}
	// register only variables containing missing in m=0
	tokenize ``charname''
	local i 1
	while("``i''"!="") {
		qui count if ``i''==. `iflong'
		if r(N)!=0 {
			local new `new' ``i''		
		}
		local ++i
	}
	char `charname' `new'
end
