/* -------------------------------------------------------------------- */
*! version 1.1.5  13feb2015

/*
	mi passive [, noupdate nopreserve nolongnameschk]: [<by>] <cmd>

	where
		<by>  := by <varlist> [(varlist)]:

		<cmd> := <generate> | <egen> | <replace>

           <generate> := generate [<type>] <varname> = <exp> [if]

	       <egen> := gen [<type>] <varname> = <eexp> [if] [, <options>]

	    <replace> := replace <varname> = <exp> [if] [, nopromote]

	-nolongnameschk- is undocumented
*/


program mi_cmd_passive
	version 11.0

	u_mi_assert_set
	mata: _parse_colon("hascolon", "rhscmd")
	if (!`hascolon') {
		di as err "invalid syntax; colon missing"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err "syntax is {bf:mi passive: ...}"
		di as smcl as err ///
		"or{bind:  }{bf: mi passive,} {it:options}{bf::} ..."
		di as smcl as err "{p_end}"
		exit 198
	}

	if ("`_dta[_mi_style]'"=="wide" | "`_dta[_mi_style]'"=="flongsep") {
		syntax [, noUPdate noPRESERVE ]
	}
	else {
		syntax [, noUPdate noPRESERVE noLONGNAMESCHK]
	}

	mi_passive_parse_by   byprefix sortvars 0   : `"`rhscmd'"'
	mi_passive_parse_cmd  cmd type varname rest : `"`0'"'
	u_mi_chk_longvnames "`varname'" "mi passive" "`longnameschk'" "passive"

	if ("`byprefix'"!="") {
		local colon ":"
	}

	mi_passive_`_dta[_mi_style]' 			///
		"`update'" "`preserve'" 		///
		"`byprefix'" "`colon'" "`sortvars'"	///
		"`cmd'" "`type'" "`varname'" `"`rest'"'
end

program mi_passive_mlong
	args nopreserve noupdate  byprefix colon sortvars cmd type varname rest

	if ("`nopreserve'"=="") {
		local cancel_restore "restore, not"
		preserve
	}

	qui mi convert wide, `noupdate' clear
	mi_passive_wide 				///
		noupdate nopreserve			///
		"`byprefix'" "`colon'" "`sortvars'"	///
		"`cmd'" "`type'" "`varname'" `"`rest'"'

	qui mi convert mlong, noupdate clear
	`cancel_restore'
end


program mi_passive_wide
	args nopreserve noupdate  byprefix colon sortvars cmd type varname rest

	u_mi_certify_data, acceptable

	if ("`nopreserve'"=="") {
		local cancel_restore "restore, not"
		preserve
	}

	if ("`cmd'"!="replace") {
		qui gen `type' `varname' = . 
		local repllike 0
	}
	else {
		local repllike 1
	}
	mi_passive_register `varname'


	if (`repllike') {
		local fullcmd ///
			`"`byprefix'`colon' `cmd' `type' `varname' `rest'"'
	}
	else {
		tempvar togen 
		local fullcmd ///
			`"`byprefix'`colon' `cmd' `type' `togen' `rest'"'
	}

	// begin first we do on m=0
	if ("`sortvars'"!="") {
		sort `sortvars'
	}
	mi_passive_xeq "`cmd'" `"`fullcmd'"' `varname' "`togen'" 0
	// end first we do on m=0

	// now we do it on the rest 
	tempname tmp
	local M `_dta[_mi_M]'
	forvalues m=1(1)`M' {
		mata: u_mi_wide_swapvars(`m', "`tmp'")	// swap forward
		if ("`sortvars'"!="") {
			sort `sortvars'
		}
		mi_passive_xeq "`cmd'" `"`fullcmd'"' `varname' "`togen'" `m'
		mata: u_mi_wide_swapvars(`m', "`tmp'") // swap back
	}

	`cancel_restore'
end 



program mi_passive_flong
	args nopreserve noupdate  byprefix colon sortvars cmd type varname rest

	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')
	if ("`noupdate'"=="") {
		u_mi_certify_data, proper msgno(`msgno')
	}

	preserve

	if ("`sortvars'"!="") {
		local dosort sort `sortvars'
	}

	local repllike = ("`cmd'"=="replace")
	local fullcmd `"`byprefix'`colon' `cmd' `type' `varname' `rest'"'

	local M    `_dta[_mi_M]'
	capture noisily {
		forvalues m=0(1)`M' {
			di as smcl as txt "{it:m}=`m':"
			if (`m') {
				restore, preserve
			}
			qui keep if _mi_m==`m'
			`dosort'
			`fullcmd'
			tempfile t`m'
			qui save "`t`m''"
		}
	}
	nobreak {
		if (_rc) {
			exit `=_rc'
		}
		qui use "`t0'", clear 
		forvalues m=1(1)`M' {
			qui append using "`t`m''"
		}
		mi_passive_register `varname'
		restore, not
	}
end


program mi_passive_flongsep
	args nopreserve noupdate  byprefix colon sortvars cmd type varname rest

	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')
	if ("`noupdate'"=="") {
		u_mi_certify_data, proper msgno(`msgno')
	}

	if ("`nopreserve'"=="") {
		local cancel_restore "restore, not"
		preserve
	}

	if ("`sortvars'"!="") {
		local dosort sort `sortvars'
	}

	local repllike = ("`cmd'"=="replace")
	local fullcmd `"`byprefix'`colon' `cmd' `type' `varname' `rest'"'
	local name "`_dta[_mi_name]'"
	local M    `_dta[_mi_M]'
	capture noisily {
		forvalues m=0(1)`M' {
			if (`m') { 
				qui use _`m'_`name', clear 
			}
			di as smcl as txt "{it:m}=`m':"
			`dosort'
			`fullcmd'
			tempfile t`m'
			qui save "`t`m''"
		}
	}
	nobreak {
		if (_rc) {
			exit `=_rc'
		}
		qui use "`t0'", clear 
		`cancel_restore'
		qui save `name', replace
		forvalues m=1(1)`M' {
			copy "`t`m''" _`m'_`name'.dta, replace
		}
		mi_passive_register `varname'
	}
end


program mi_passive_xeq
	args cmd fullcmd varname tmpname m
	di as smcl as txt "{it:m}=`m':"
	if ("`cmd'"=="replace") {
		`fullcmd'
	}
	else {
		`fullcmd'
		drop `varname'
		rename `tmpname' `varname'
	}
end
		
		

program mi_passive_register
	args varname

	local pvars `_dta[_mi_pvars]'
	local in : list varname in pvars
	if (!`in') {
		local style `_dta[_mi_style]'
		if ("`style'"=="mlong" | "`style'"=="flong") {
			local longnameschk nolongnameschk
		}
		mi register passive `varname', `longnameschk'
	}
end
		

program mi_passive_parse_by
	args u_bycmd u_sortvars u_rest  colon  s

	local 0 `"`s'"'
	gettoken token 0 : 0, parse(" ,=()")
	if ("`token'"!="by") {
		c_local `u_bycmd'
		c_local `u_rest' `"`s'"'
		c_local `u_sortvars' 
		exit
	}
	mata: _parse_colon("hascolon", "rest")
	if (!`hascolon') {
		di as smcl as err "{bf:by} prefix not followed by colon"
		exit 198
	}
	c_local `u_rest' `"`rest'"'

	mata: mi_passive_split_varlist("left", "right", `"`0'"')

	local 0 `"`left'"'
	syntax varlist 
	local left `varlist'

	if ("`right'"!="") {
		local 0 `"`right'"'
		syntax varlist
		local right "`varlist'"
		c_local `u_bycmd'    `"by `left' (`right')"'
		c_local `u_sortvars' `left' `right'
	}
	else {
		c_local `u_bycmd'     `"by `left'"'
		c_local `u_sortvars' `left'
	}
end
	
local SS	string scalar
local RS	real scalar
mata:
void mi_passive_split_varlist(`SS' left, `SS' right, `SS' s)
{
	`RS'	l

	l = strpos(s, "(")
	if (l) { 
		st_local(left,  bsubstr(s, 1, l-1))
		st_local(right, bsubstr(s, l, .))
	}
	else {
		st_local(left,  s)
		st_local(right, "")
	}
}
end

program mi_passive_parse_cmd
	args u_cmd u_stype u_varname u_rest  colon  s

	gettoken gencmd 0 : s, parse(" ,=()")
	local l = strlen("`gencmd'")
	if ("`gencmd'"==bsubstr("generate", 1, max(1,`l'))) {
		local gencmd = "generate"
		local allowstype 1
		local isnewvar   1
		local exptype exp
	}
	else if ("`gencmd'"=="egen") {
		local allowstype 1
		local isnewvar   1
		local exptype egenexp
	}
	else if ("`gencmd'"=="replace") {
		local allowstype 0
		local isnewvar   0
		local exptype exp
	}
	else if ("`gencmd'"=="") {
		error 198
	}
	else {
		di as smcl as err "{p}"
		di as smcl as err ///
		"{bf:`gencmd'} invalid {bf:mi passive} subcommand"
		di as smcl as err "{p_end}"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err ///
		"valid are {bf:generate}, {bf:egen}, and {bf:replace}"
		di as smcl as err "{p_end}"
		exit 198
	}
	/* ------------------------------------------------------------ */
	gettoken stype : 0, parse(" ,=()")
	storage_type_class class : "`stype'"
	if ("`class'"!="") {
		if (!`allowstype') { 
			di as smcl as err "{bf:mi `gencmd' `stype'} ... invalid"
			di as smcl as err "    storage type not allowed"
			exit 198
		}
		if ("`class'"!="numeric") { 
			di as err "passive variables must be numeric"
			exit 198
		}
		gettoken stype 0 : 0, parse(" ,=()")
	}
	else {
		local stype
	}
	/* ------------------------------------------------------------ */
	gettoken varname 0 : 0, parse(" ,=()")
	confirm name `varname'
	if (`isnewvar') {
		confirm new variable `varname'
	}
	else {
		unab varname : `varname'
		local pvars `_dta[_mi_pvars]'
		local in : list varname in pvars
		if (!`in') {
			di as err "existing variable `varname' not passive"
			exit 111
		}
	}
		
	/* ------------------------------------------------------------ */
	if ("`exptype'"=="exp") { 
		syntax =exp [if] [, *]
	}
	else {
		local old0 `"`0'"'
		gettoken equal 0 : 0, parse(" ,=()")
		if ("`equal'"!="=") {
			error 198
		}
		gettoken name 0 : 0, parse(" ,=()")
		capture confirm name `name'
		if _rc {
			di as smcl as err ///
			"unknown {bf:egen} function {bf:`name'()}"
			exit 198
		}
		gettoken parened 0 : 0, parse(" ,=()") match(paren)
		if ("`paren'"!="(") {
			error 198
		}
		syntax [if] [, *]
		local 0 `"`old0'"'
	}
	
	c_local `u_cmd'     `gencmd'
	c_local `u_stype'   `stype'
	c_local `u_varname' `varname'
	c_local `u_rest'    `"`0'"'
end


program storage_type_class
	args result colon type

	local type = bsubstr("`type'", 1, 20)
	if ("`type'"=="double" | 		///
	    "`type'"=="float"  |		///
	    "`type'"=="long"   |		///
	    "`type'"=="int"    |                ///
	    "`type'"=="byte")  {
		c_local `result' numeric
		exit
	}
	if (bsubstr("`type'", 1, 3)!="str") { 
		c_local `result' 
		exit
	}
	if ("`type'"=="str") { 
		c_local `result' string
		exit
	}
	local rest = bsubstr("`type'", 4, .)
	capture confirm integer number `rest'
	if (_rc==0) { 
		c_local `result' string
		exit
	}
	c_local `result' 
end
