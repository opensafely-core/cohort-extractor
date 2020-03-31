*! version 1.1.6  16feb2015

/*
	mi import <extended_style> [...]

		<extended_style> = <style>
				  nhanes1
				  ice
		
*/

program mi_cmd_import
	version 11.0

	capture u_mi_assert_set
	if (_rc==0) {
		di as err "data already -mi set-"
		exit 459
	}

	gettoken style 0 : 0, parse(" ,[]()=")
	if ("`style'"=="") { 
		di as err "nothing found where import style expected"
		di as err "    syntax is {bf:mi import} {it:style} ..."
		display_import_styles_error
		/*NOTREACHED*/
	}

	local styleset 0
	if ("`style'"=="nhanes1") {
		local styleset 1 
	}
	else if ("`style'"=="ice") {
		local styleset 1
	}

	if (!`styleset') {
		capture u_mi_map_style style : `style'
		if (_rc) { 
			di as err "invalid import style `style'"
			display_import_styles_error
			/*NOTREACHED*/
		}
	}
	if (_N==0) {
		error 2000
	}
	mi_import_`style' `0'
	u_mi_curtime set
end

program display_import_styles_error
	di as smcl as err "{p 4 4 2}"
	di as smcl as err ///
	"import styles are {bf:wide}, {bf:mlong}, {bf:flong}, {bf:flongsep},"
	di as smcl as err "{bf:ice}, and {bf:nhanes1}"
	di as smcl as err "{p_end}"
	exit 198
end

/*
	mi import mlong,
		id(<varlist>) m(<varname>)
               [
		clear
		imputed(<varlist>)
		passive(<varlist>)
		DROP                        (drops id() and m())
		]

		<implist> := <nothing>
			     <varname> = <rhslist>

		<rhslist> := <rhsel> <rhslist>

		<rhsel>  :=  .
			     <varname>
*/


program mi_import_mlong
	syntax , ID(varlist) M(varname numeric) ///
		 [CLEAR IMPuted(varlist numeric) PASsive(varlist numeric) ///
		  DROP noLONGNAMESCHK /*undoc.*/ ]

	if (c(changed) & "`clear'"=="") {
		error 4
	}

	local imputed : list uniq imputed
	local passive : list uniq passive
	local bad : list imputed & passive
	if ("`bad'"!="") {
		local n : word count `bad'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "`variables'"
		di as smcl as err "`bad'"
		di as smcl as err "in both {bf:imputed()} and {bf:passive()}"
		di as smcl as err "{p_end}"
		exit
	}

	local mvar `m'

	preserve

	/* ------------------------------------------------------------ */
						/* check m id		*/
	sort `mvar' `id'
	capture by `mvar' `id': assert _N==1
	if (_rc) {
		di as smcl as err "{p}"
		di as smcl as err ///
	"variables (`mvar' `id') do not uniquely identify the observations"
		di as smcl as err "{p_end}"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err ///
		"at least one (`mvar' `id') value is duplicated"
		di as smcl as err "{p_end}"
		exit 459
	}
	quietly { 
		by `mvar': gen int _mi_m = 1 if _n==1
		replace _mi_m = 0 in 1
		replace _mi_m = sum(_mi_m)
		local M = _mi_m[_N]
		local user_m_min = `mvar'[1]
	}

	sort `id' _mi_m
	quietly {
		by `id': gen `c(obs_t)' _mi_id = 1 if _n==1
		replace _mi_id = sum(_mi_id)
		compress _mi_id 
	}
	sort _mi_id _mi_m
	capture by _mi_id: assert _mi_m==0 if _n==1
	if (_rc) {
		di as err as smcl "{p}"
		di as smcl as err "variable `id' has invalid values"
		di as smcl as err "{p_end}"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err "`id' takes on at least one value"
		di as smcl as err "if `mvar'>`user_m_min' that it does not"
		di as smcl as err "if `mvar'==`user_m_min'"
		di as smcl as err "{p_end}"
		exit 459 
	}
	sort _mi_m _mi_id
	gen byte _mi_miss = 0

	char _dta[_mi_style] "mlong"
	char _dta[_mi_M]     `M'
	char _dta[_mi_ivars]
	char _dta[_mi_pvars]
	char _dta[_mi_rvars]
	quietly count if _mi_m==0
	char _dta[_mi_N]     `=r(N)'
	quietly count if _mi_m>0
	char _dta[_mi_n]     `=r(N)'
	char _dta[_mi_marker] "_mi_ds_1"

	/* we now have certified _mi_m _mi_id and are sorted */

						/* check m id		*/
	/* ------------------------------------------------------------ */

	local ivars
	foreach el of local imputed {
		gettoken lhs rest : el
		local ivars `ivars' `lhs'
	}
	u_mi_chk_longvnames ///
		"`ivars'" "mi import mlong" "`longnameschk'" "imputation"
	char _dta[_mi_ivars] `ivars'
	
	local pvars
	foreach el of local passive {
		gettoken lhs rest : el
		local pvars `pvars' `lhs'
	}
	u_mi_chk_longvnames ///
		"`pvars'" "mi import mlong" "`longnameschk'" "passive"
	char _dta[_mi_pvars] `pvars'

	if ("`drop'"!="") {
		drop `id' `mvar'
	}
	u_mi_certify_data, acceptable proper
	restore, not
end


/*
	mi import flong,
		id(<varlist>) m(<varname>)
               [
		clear
		imputed(<varlist>)
		passive(<varlist>)
		DROP                        (drops id() and m())
		]


*/


program mi_import_flong
	syntax , ID(varlist) M(varname numeric) ///
		 [CLEAR IMPuted(varlist numeric) PASsive(varlist numeric) ///
		  DROP noLONGNAMESCHK /*undoc.*/ ]

	if (c(changed) & "`clear'"=="") {
		error 4
	}

	local imputed : list uniq imputed
	local passive : list uniq passive
	local bad : list imputed & passive
	if ("`bad'"!="") {
		local n : word count `bad'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "`variables'"
		di as smcl as err "`bad'"
		di as smcl as err "in both {bf:imputed()} and {bf:passive()}"
		di as smcl as err "{p_end}"
		exit
	}

	local mvar `m'

	preserve

	/* ------------------------------------------------------------ */
						/* check m id		*/
	sort `mvar' `id'
	capture by `mvar' `id': assert _N==1
	if (_rc) {
		di as err as smcl "{p}"
		di as smcl as err ///
	"variables (`mvar' `id') do not uniquely identify the observations"
		di as smcl as err "{p_end}"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err ///
		"at least one (`mvar' `id') value is duplicated"
		di as smcl as err "{p_end}"
		exit 459
	}
	quietly { 
		by `mvar': gen int _mi_m = 1 if _n==1
		replace _mi_m = 0 in 1
		replace _mi_m = sum(_mi_m)
		local M = _mi_m[_N]
		local user_m_min = `mvar'[1]
	}

	sort `id' _mi_m
	quietly {
		by `id': gen `c(obs_t)' _mi_id = 1 if _n==1
		replace _mi_id = sum(_mi_id)
		compress _mi_id 
	}
	sort _mi_id _mi_m
	capture by _mi_id: assert _mi_m==0 if _n==1
	if (_rc) {
		di as err as smcl "{p}"
		di as smcl as err "variable `id' has invalid values"
		di as smcl as err "{p_end}"
		di as smcl as err "{p 4 4 2}"
		di as smcl as err "`id' takes on at least one value"
		di as smcl as err "if `mvar'>`user_m_min' that it does not"
		di as smcl as err "if `mvar'==`user_m_min'
		di as smcl as err "{p_end}"
		exit 459 
	}
	sort _mi_m _mi_id
	gen byte _mi_miss = 0

	char _dta[_mi_style] "flong"
	char _dta[_mi_M]     `M'
	char _dta[_mi_ivars]
	char _dta[_mi_pvars]
	char _dta[_mi_rvars]
	quietly count if _mi_m==0
	char _dta[_mi_N]     `=r(N)'
	char _dta[_mi_marker] "_mi_ds_1"

	/* we now have certified _mi_m _mi_id and are sorted */

						/* check m id		*/
	/* ------------------------------------------------------------ */

	local ivars
	foreach el of local imputed {
		gettoken lhs rest : el
		local ivars `ivars' `lhs'
	}
	u_mi_chk_longvnames ///
		"`ivars'" "mi import flong" "`longnameschk'" "imputation"
	char _dta[_mi_ivars] `ivars'
	
	local pvars
	foreach el of local passive {
		gettoken lhs rest : el
		local pvars `pvars' `lhs'
	}
	u_mi_chk_longvnames ///
		"`pvars'" "mi import flong" "`longnameschk'" "passive"
	char _dta[_mi_pvars] `pvars'

	if ("`drop'"!="") {
		drop `id' `mvar'
	}
	u_mi_certify_data, acceptable proper
	restore, not
end

program u_mi_import_dupmsg
	args dups
	local n : word count `dups'
	if (`n') {
		if (`n'==1) {
			local variables variable
			local each
		}
		else {
			local variables variables
			local each each
		}
		local variables = cond(`n'==1, "variable", "variables")
		if ("`dupsok'"=="") {
			di as smcl as err "{p}"
			di as smcl as err "`variables' `dups'"
			di as smcl as err "`each' referred to more than once"
			di as smcl as err "{p_end}"
			di as smcl as err "{p 4 4}"
			di as smcl as err ///
			   "specify option {bf:dupsok} if this is your intent"
			di as smcl as err "{p_end}"
			exit 198
		}
		else {
			di as smcl as txt "{p}"
			di as smcl "(`variables' `dups'"
			di as smcl "`each' referred to more than once)"
			di as smcl "{p_end}"
		}
	}
end


version 11
mata:

void u_fix_filesuffix(string scalar macname, string scalar fn, 
						string scalar sfx)
{
	st_local(macname, (pathsuffix(fn)=="" ? fn+sfx : fn))
}

/*
	a filenamelist is 

		<filenamelist> := <el> <filenamelist>

			 <el> := <stuff>{<list>}<stuff>
				 <stuff>{<list>}
				 {<list>}<stuff>
				 <filename>

		       <list> := #-#
                                 <stuff>,<list>

		      <stuff> := (not <nothing>)

	<el>s may be in quotes
*/
		

void u_filenamelist(string scalar localname)
{
	real scalar		i
	string rowvector	filenames
	string scalar		result

	filenames = tokens(st_local(localname))
	result   = ""
	for (i=1; i<=length(filenames); i++) { 
		result = result + " " + u_filenamelist_u(filenames[i])
	}
	st_local(localname, strtrim(result))
}

string scalar u_filenamelist_u(string scalar efn)
{
	real scalar      i, j, k, k1, k2
	string scalar	 lft, mid, rgt, result
	string scalar	 b, q, efn_q
	string rowvector p
	real scalar	 l1, l2

	q = `"""'
	b = " "
	efn_q = q+efn+q

	if ((l1 = strpos(efn, "{"))==0) return(efn_q)
	if ((l2 = strpos(efn, "}"))==0) return(efn_q) 
	if (l2<l1 | l2==l1+1) return(efn_q) 
	mid = bsubstr(efn, l1+1, l2-l1-1)
	lft  = bsubstr(efn, 1, l1-1)
	rgt  = bsubstr(efn, l2+1, .)
	if (lft=="" & rgt=="") return(efn_q) 

	p = (tokens(mid, " ,-"), "}")

	result = ""
	i = 1
	while (i<=length(p)) {
		if (p[i]=="}") return(strtrim(result))
		if (p[i]==",") i++
		if (p[i]=="}") return(efn_q)
		j = i+1
		if (p[j]=="," | p[j]=="}") { 
			result = result + b + q + lft + p[i] + rgt + q
			i = j
		}
		else if (p[j] =="-") {
			if ((k1=strtoreal(p[i] ))==.) return(efn_q)
			if ((k2=strtoreal(p[j+1]))==.) return(efn_q)
			if (k2<k1)                    return(efn_q)
			for (k=k1; k<=k2; k++) { 
				result = result + b + q + lft + 
					     strofreal(k) + rgt + q
			}
			i = j + 2
		}
	}
	return(strtrim(result))
}
end
	


/*
	mi import flongsep <name>,
		id(<varlist>) 
		using(<filelist>)
               [
		clear
		imputed(<varlist>)
		passive(<varlist>)
		msgusing(<list>)		(secret)
		]

		filelist := <filename> <filelist>
*/

program mi_import_flongsep
	gettoken name 0 : 0, parse(" ,[]()-")
	if ("`name'"=="," | "`name'"=="") { 
		di as err "nothing found where name expected"
		di as err "syntax is {bf:mi import flongsep} {it:name} ..."
		exit 198
	}
	confirm name `name'
	confirm new file `name'.dta

	syntax , ID(varlist) USING(string asis) 	///
		 [					///
			CLEAR				///
			IMPuted(varlist numeric) 	///
			PASsive(varlist numeric)	///
			MSGUSING(string asis)		///
		 ]
	if (c(changed) & "`clear'"=="") {
		error 4
	}

	local imputed : list uniq imputed
	local passive : list uniq passive
	local bad : list imputed & passive
	if ("`bad'"!="") {
		local n : word count `bad'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "`variables'"
		di as smcl as err "`bad'"
		di as smcl as err "in both {bf:imputed()} and {cmd:passive()}"
		di as smcl as err "{p_end}"
		exit
	}
	u_mi_chk_longvnames "`imputed'" "mi import flongsep" "" "imputation"
	u_mi_chk_longvnames "`passive'" "mi import flongsep" "" "passive"

	mata: u_filenamelist("using")
	local M : word count `using'
	if (`M'==0) { 
		di as smcl as err ///
			"too few filenames specified in option {cmd:using()}"
		exit 198
	}
	local newlist
	forvalues i=1(1)`M' {
		local basename : word `i' of `using'
		mata: u_fix_filesuffix("basename", "`basename'", ".dta")
		local newlist `"`newlist' "`basename'""'
	}
	local using `"`newlist'"'
	local badfiles
	local nbad 0
	forvalues i=1(1)`M' {
		local basename : word `i' of `using'
		capture confirm file `"`basename'"'
		if (_rc) { 
			local badfiles `badfiles' `basename'
			local ++nbad 
		}
	}
	if (`nbad') { 
		local files = cond(`nbad'==1, "file", "files")
		di as err as smcl "{p}"
		di as smcl as err "`files'"
		di as smcl as err "`badfiles'"
		di as smcl as err "not found"
		di as smcl as err "{p_end}"
		exit 601
	}

	novarabbrev mi_import_flongsep_u ///
		"`name'" "`id'" 	 ///
		`"`using'"' `"`msgusing'"' ///
		"`imputed'" "`passive'" 
end

program mi_import_flongsep_u
	args name id using msgusing imputed passive

	if (`"`msgusing'"'=="") {
		local msgusing `"`using'"'
	}
	local M : word count `using'

	preserve

	/* ------------------------------------------------------------ */
						/* check id		*/
	sort `id'
	capture by `id': assert _N==1
	if (_rc) { 
		local n : word count `id'
		local variable = cond(`n'==1, "variable", "variables")
		local do = cond(`n'==1, "does", "do")
		di as err as smcl "{p}"
		di as smcl as err "`variables' `id'"
		di as smcl as err "`do' not uniquely identify the observations"
		di as smcl as err "in {it:m}=0"
		di as smcl as err "{p_end}"
		exit 459
	}
	tempfile base
	qui save "`base'"

	tempvar mervar
	forvalues m=1(1)`M' {
		local origfile : word `m' of `using'
		local msgorigfile : word `m' of `msgusing'
		qui use "`origfile'", clear 
		capture confirm var `id'
		if (_rc) { 
			di as smcl as err "{p}"
			di as smcl as err "file `msgorigfile'"
			di as smcl as err "is missing variable(s) `id'"
			di as smcl as err "{p_end}"
			exit 459
		}
		sort `id'
		capture by `id': assert _N==1
		if _rc { 
			di as smcl as err "{p}"
			di as smcl as err "variable(s) `id' do not uniquely"
			di as smcl as err "identify the obs in file `msgorigfile'"
			di as smcl as err "{p_end}"
			exit 459
		}
		check_numvars_exist "imputed" "`imputed'" "file `msgorigfile'"
		check_numvars_exist "passive" "`passive'" "file `msgorigfile'"
		qui merge 1:1 `id' using "`base'", sorted noreport nonotes ///
								gen(`mervar')
		qui count if `mervar'!=3
		if (r(N)) { 
			local n = r(N)
			local do = cond(`n'==1, "does", "do")
			di as smcl as err "{p}"
			di as smcl as err "`n' obs. in file `msgorigfile'"
			di as smcl as err "`do' not match"
			di as smcl as err "{p_end}"
			exit 459
		}
		drop `mervar'
		u_mi_zap_chars
		char _dta[_mi_style] "flongsep_sub"
		char _dta[_mi_name]  "`name'"
		char _dta[_mi_m]     `m'
		char _dta[_mi_marker] "_mi_ds_1"
		tempfile file`m'
		quietly {
			gen `c(obs_t)' _mi_id = _n
			compress _mi_id
			save "`file`m''"
			
		}
	}
	quietly {
		restore, preserve
		sort `id'
		gen `c(obs_t)' _mi_id = _n
		compress _mi_id
		gen byte _mi_miss = 0
		foreach v of local imputed {
			replace _mi_miss = 1 if `v'==.
		}
		u_mi_zap_chars
		char _dta[_mi_style] "flongsep"
		char _dta[_mi_name]  "`name'"
		char _dta[_mi_M]     `M'
		char _dta[_mi_N]     `=_N'
		char _dta[_mi_ivars] `imputed'
		char _dta[_mi_pvars] `passive'
		char _dta[_mi_rvars] 
		char _dta[_mi_marker] "_mi_ds_1"
		tempfile file0
		save "`file0'"
	}
	nobreak {
		capture noisily {
			quietly {
				forvalues m=1(1)`M' {
					use "`file`m''", clear 
					save _`m'_`name', replace
				}
				use "`file0'", clear 
				save `name', replace
			}
		}
		if (_rc) { 
			mata: u_mi_flongsep_erase("`name'", 0, 0)
		}
		else {
			restore, not
		}
	}
	u_mi_certify_data, acceptable proper
	u_mi_fixchars, proper
end

program check_numvars_exist 
	args word vars source

	if ("`vars'"=="") { 
		exit
	}

	capture confirm var `vars'
	if (_rc) {
		local badlist
		foreach v of local vars {
			capture confirm var `v'
			if (_rc) { 
				local badlist `badlist' `v'
			}
		}
		local n : word count `badlist'
		local variables = cond(`n'==1, "variable", "variables")
		local do       = cond(`n'==1, "does",     "do"       )
		di as err as smcl "{p}"
		di as smcl as err "`vartype' `variables'"
		di as smcl as err "`badlist'"
		di as smcl as err "`do' not exist in `source'"
		di as smcl as err "{p_end}"
		exit 459
	}

	capture confirm numeric var `vars'
	if (_rc) {
		local badlist
		foreach v of local vars {
			capture confirm numeric var `v'
			if (_rc) { 
				local badlist `badlist' `v'
			}
		}
		local n : word count `badlist'
		local variables = cond(`n'==1, "variable", "variables")
		local are      = cond(`n'==1, "is",       "are"      )
		di as err as smcl "{p}"
		di as smcl as err "`vartype' `variables'"
		di as smcl as err "`badlist'"
		di as smcl as err "`are' not numeric in `source'"
		di as smcl as err "{p_end}"
		exit 459
	}
end


/*
	mi import nhanes1 <name>,
		id(<varlist>) 
		using(<filenamelist>)
               [
		clear
		nacode(<#>)			default nacode(0)
		obscode(<#>)			default obscode(1)
		impcode(<#>)			default impcode(2)

		impprefix(<string>)		default impprefix("" "")
		impsuffix(<string>)		default impsuffix(if mi)
		uppercase			uppercase prefix/suffix
		]

	a filenamelist is 

		<filenamelist> := <el> <filenamelist>

			 <el> := <stuff>{<list>}<stuff>
				 <stuff>{<list>}
				 {<list>}<stuff>
				 <filename>

		       <list> := #-#
                                 <stuff>,<list>

		      <stuff> := (not <nothing>)

	<el>s may be in quotes
*/

program mi_import_nhanes1

	/* ------------------------------------------------------------ */
						/* parse		*/

	gettoken name 0 : 0, parse(" ,[]()-")
	if ("`name'"=="," | "`name'"=="") { 
		di as err "nothing found where name expected"
		di as err "syntax is {bf:mi import nhanes1} {it:name} ..."
		exit 198
	}
	confirm name `name'
	confirm new file `name'.dta

	syntax , ID(varlist) USING(string asis) 	///
		 [ 					///
			CLEAR				///
			IMPCODE(real 2)			///
			IMPSUFfix(string asis)		///
			IMPPREfix(string asis)		///
			NACODE(real 0)			///
			OBSCODE(real 1)			///
			UPPERcase			///
		]

	if (c(changed) & "`clear'"=="") {
		error 4
	}

	local automatic "automatic"


	u_mi_imexport_fix_pre_suf if_p mi_p : impprefix `"`impprefix'"' ""  ""
	u_mi_imexport_fix_pre_suf if_s mi_s : impsuffix `"`impsuffix'"' "if" "mi"

	if ("`uppercase'"!="") {
		local if_p = strupper("`if_p'")
		local if_s = strupper("`if_s'")
		local mi_p = strupper("`mi_p'")
		local mi_s = strupper("`mi_s'")
	}

	if (`nacode' ==`obscode' |	///
	   `nacode' ==`impcode' |       ///
	   `obscode'==`impcode') {
		di as err as smcl "{p}
		di as smcl as err ///
			"{bf:obscode()}, {bf:impcode()}, and {bf:nacode()}"
		di as smcl as err "must be distinct numeric values"
		exit 198
	}

	
	get_varlist imputed : "`if_p'" "`if_s'"

	local imputed : list uniq imputed
	cap u_mi_chk_longvnames "`imputed'" "mi import nhanes1" "" "imputation"
	if (_rc) {
		di as err "{bf:mi import nhanes1}: long variable names detected"
		di as err "{p 4 4 2}Datasets contain imputation variables with"
		di as err "names longer than 29 characters.  "
		di as err "This is not allowed.{p_end}"
		exit 198
	}

	mata: u_filenamelist("using")
	local M : word count `using'
	if (`M'==0) { 
		di as smcl as err ///
			"too few filenames specified in option {bf:using()}"
		exit 198
	}
	local badfiles
	local nbad 0
	forvalues i=1(1)`M' {
		local basename : word `i' of `using'
		mata: u_fix_filesuffix("fullname", `"`basename'"', ".dta")
		capture confirm file `fullname'
		if (_rc) { 
			local badfiles `badfiles' `fullname'
			local ++nbad 
		}
	}
	if (`nbad') { 
		local files = cond(`nbad'==1, "file", "files")
		di as err as smcl "{p}"
		di as smcl as err "`files'"
		di as smcl as err "`badfiles'"
		di as smcl as err "not found"
		di as smcl as err "{p_end}"
		exit 601
	}
		
						/* parse		*/
	/* ------------------------------------------------------------ */
						/* warnings		*/
				
	
						/* warnings		*/
	/* ------------------------------------------------------------ */

	novarabbrev mi_import_nhanes1_u ///
		"`name'" "`id'" `"`using'"' "`imputed'" 	 ///
		"`if_p'" "`mi_p'"				 ///
		"`if_s'" "`mi_s'"				 ///
		`obscode' `impcode' `nacode'
end

program mi_import_nhanes1_u
	args name id using imputed        ///
	    if_p mi_p if_s mi_s	   ///
	    obscode impcode nacode

	local M : word count `using'

	preserve

	sort `id'
	capture by `id': assert _N==1
	if (_rc) {
		local n : word count `id' 
		local variables = cond(`n'==1, "variable", "variables")
		local do       = cond(`n'==1, "does"    , "do"       )
		di as smcl as err "{p}"
		di as smcl as err "`variables' `id' `do' not uniquely identify"
		di as smcl as err "obs. in {it:m}=0"
		di as smcl as err "{p_end}"
		exit 459
	}
	quietly {
		keep `id'
		tempfile baseids_dta
		save "`baseids_dta'"
	}
	
	tempvar mervar
	forvalues i=1(1)`M' {
		local input_dta : word `i' of `using'
		tempfile file`i'

		qui use "`input_dta'", clear 
	
		capture confirm var `id'
		if (_rc) {
			local n : word count `id' 
			local variables = cond(`n'==1, "variable", "variables")
			local do       = cond(`n'==1, "does"    , "do"       )
			di as smcl as err "{p}"
			di as smcl as err "id `variables' `id' not found"
			di as smcl as err "in `input_dta'.dta"
			di as smcl as err "{p_end}"
			exit 111
		}

		sort `id'
		capture by `id': assert _N==1
		if _rc {
			local n : word count `id' 
			local variables = cond(`n'==1, "variable", "variables")
			local do       = cond(`n'==1, "does"    , "do"       )
			di as smcl as err "{p}"
			di as smcl as err "`variables' `id' `do' not"
			di as smcl as err "obs. in `input_dta'.dta"
			di as smcl as err "{p_end}"
			exit 459
		}

		quietly merge 1:1 `id' using "`baseids_dta'", ///
			sorted noreport nonotes gen(`mervar')
		capture assert `mervar'==3
		if (_rc) { 
			di as smcl as err "{p}"
			di as smcl as err "observations do not match 1:1"
			di as smcl as err "in orig. and `input_dta'.dta"
			di as smcl as err "{p_end}"
			exit 459
		}
		drop `mervar'
		sort `id'

		foreach v of local imputed {
			capture confirm var `mi_p'`v'`mi_s'
			if (_rc) {
				di as smcl as err "{p}"
				di as smcl as err ///
					"imputed variable `mi_p'`v'`mi_s'"
				di as smcl as err "not found"
				di as smcl as err "in `input_dta'.dta"
				di as smcl as err "{p_end}"
				exit 111
			}
			capture confirm numeric var `mi_p'`v'`mi_s'
			if (_rc) {
				di as smcl as err "{p}"
				di as smcl as err ///
					"imputed variable `mi_p'`v'`mi_s'"
				di as smcl as err "not numeric"
				di as smcl as err "in `input_dta'.dta"
				di as smcl as err "{p_end}"
				exit 111
			}

			if ("`mi_p'"!="" | "`mi_s'"!="") {
				capture confirm new var `v'
				if (_rc) {
					di as smcl as err "{p}"
					di as smcl as err ///
						"variable `v' already exists"
					di as smcl as err ///
						"in `input_dta'.dta and so"
					di as smcl as err "imputed variable"
					di as smcl as err "`mi_p'`v'`mi_s'"
					di as smcl as err "cannot be renamed `v'"
					di as smcl as err "{p_end}"
					exit 110
				}
				rename `mi_p'`v'`mi_s' `v'
			}
		}

		qui save "`file`i''"
	}

	/* --------------------------------------- pull base values --- */
	quietly {
		use "`file1'", clear 
		keep `id' `imputed'
		tempfile imputedvars_dta
		save "`imputedvars_dta'"
	}
		
	restore, preserve
	sort `id'
	foreach v of local imputed {
		if ("`if_p'"!="" | "`if_s'"!="") {
			capture confirm new var `v'
			if (_rc) {
				di as smcl as err "{p}"
				di as smcl as err "variable `v' already exists"
				di as smcl as err "in orig. and so"
				di as smcl as err "imputed variable"
				di as smcl as err "`if_p'`v'`if_s'"
				di as smcl as err "cannot be renamed `v'"
				di as smcl as err "{p_end}"
				exit 110
			}
		}
	}
	quietly {
		merge 1:1 `id' using "`imputedvars_dta'", ///
				assert(match) nogen sorted noreport
		foreach v of local imputed {
			qui replace `v' = . if `if_p'`v'`if_s'==`impcode'
			qui replace `v' = .z if `if_p'`v'`if_s'==`nacode'
			drop `if_p'`v'`if_s'
		}
	}

	/* nacodes are set to .z in orig. data. Who knows how they 
	  are set in imputation datasets.  -mi import flongsep- would
	  fix the problem, but we do not want the user to see the 
          fix-up message.  Ergo, we will fix it
	*/

	if ("`imputed'"!="") {
		tempfile file0_dta
		qui save "`file0_dta'"
		quietly {
			keep `id' `imputed'
			foreach v of local imputed {
				rename `v' _0_`v'
			}
			save "`imputedvars_dta'", replace

			forvalues i=1(1)`M' {
				use "`file`i''", clear 
				merge 1:1 `id' using "`imputedvars_dta'", ///
					nogen assert(match) sorted noreport
				foreach v of local imputed {
					replace `v'=.z if _0_`v'==.z
				}
				drop _0_*
				save "`file`i''", replace
			}
		}
		use "`file0_dta'", clear 
	}


	/* ------------------------------------------------------------ */
					/* issue mi import flongsep	*/
	if ("`imputed'"!="") {
		local op_imputed "imputed(`imputed')"
	}

	local op_using "using("
	forvalues i=1(1)`M' {
		local op_using `"`op_using' "`file`i''""'
	}
	local op_using `"`op_using' )"'
	
	mi import flongsep `name', clear		///
		id(`id')				///
		`op_using'				///
		`op_imputed' 

	/* ------------------------------------------------------------ */
	restore, not
end


program get_varlist 
	args toret colon  pre suf

	local 0 "`pre'?*`suf'"
	capture noi syntax varlist(numeric)
	if (_rc) {
		if (_rc!=111) {
			exit
		}
		if ("`pre'"=="") {
			local issuffix  1
			local el "`suf'"
			local suffixed suffixed
		}
		else {
			local issuffix 0
			local el "`pre'"
			local suffixed prefixed
		}
		if (lower("`el'")=="`el'") {
			local islower 1
			local alt = upper("`el'")
			local donot ""
		}
		else {
			local islower 0
			local alt = lower("`el'")
			local donot "do not"
		}

		di as err "{p 4 4 2}"
		di as err "No imputation-flag variables were found."
		di as err "Perhaps imputation flags are `suffixed'"
		di as err "with {bf:`alt'} rather than {bf:`el'}."
		di as err "If so, `donot' specify option"
		di as err "{bf:uppercase}."
		di as err "{p_end}"
		exit 111
	}
		
	local lsuf = bstrlen("`suf'")
	local lpre = bstrlen("`pre'")
	local vars
	foreach v of local varlist {
		local name = bsubstr("`v'", `lpre'+1, .)
		local name = bsubstr("`name'", 1, strlen("`name'")-`lsuf')
		local vars `vars' `name'
	}
	c_local `toret' `vars'
end
		
		

program fix_varlist
	args toret colon  varlist pre suf

	local vars
	if ("`pre'"=="" & "`suf'"=="") {
		unab vars : `v'
		c_local `toret' `vars'
	}
	local lpre = bstrlen("`pre'")
	local lsuf = bstrlen("`suf'")

	foreach v of local varlist {
		if ("`pre'"!="") {
			if ("`suf'"!="") {
				confirm var `pre'`v'`suf'
				local name `v'
			}
			else {
				unab name : `pre'*`v', max(1)
				local name = bsubstr("`name'", `lpre'+1, .)
			}
		}
		else {
			confirm var `v'`suf'
			local name `v'
		}
		confirm numeric var `v'
		local vars `vars' `v'
	}
	c_local `toret' `vars'
end

		


/*
	mi import wide [, 
		clear
		imputed(<implist>)
		passive(<implist>)
		dupsok			(same var. posted more than once)
		drop			(drop posted vars.; not recommended)
		]

		<implist> := <nothing>
			     <varname> = <rhslist>

		<rhslist> := <rhsel> <rhslist>

		<rhsel>  :=  .
			     <varname>
*/

program mi_import_wide
	syntax [, CLEAR IMPuted(string) PASsive(string) DUPSok DROP]

	if (c(changed) & "`clear'"=="") {
		error 4
	}

	parse_implist imputed M : "`imputed'" .  imputed ""
	parse_implist passive M : "`passive'" `M' passive imputed

	u_mi_import_getdups dups : `"`imputed' `passive'"'
	u_mi_import_dupmsg "`dups'"

	preserve
	mi set wide
	qui mi set M = `M'
	foreach el of local imputed {
		gettoken lhs rest : el
		mi register imputed `lhs'
		local i 1
		foreach v of local rest { 
			if ("`v'"!=".") {
				qui replace _`i'_`lhs' = `v'
				if ("`drop'"!="") {
					local in : list v in dups
					if (`in'==0) {
						drop `v'
					}
				}
			}
			local ++i
		}
	}
	foreach el of local passive {
		gettoken lhs rest : el
		mi register passive `lhs'
		local i 1
		foreach v of local rest { 
			if ("`v'"!=".") {
				qui replace _`i'_`lhs' = `v'
				if ("`drop'"!="") {
					local in : list v in dups
					if (`in'==0) {
						drop `v'
					}
				}
			}
			local ++i
		}
	}

	if ("'drop'"!="") {
		capture drop `dups'
	}
	u_mi_certify_data, acceptable proper
	u_mi_fixchars, proper
	restore, not
end



program parse_implist 
	args toretname userMname colon  implist origM opname prioropname

	local original "`implist'"
	local 0 `implist'

	local toret 
	local lhslist
	local M `origM'
	gettoken token 0 : 0, parse(" ,=.")
	while ("`token'"!="") {
		while ("`token'"==",") {
			gettoken token 0 : 0, parse(" ,=.")
		}
		unab lhs : `token'
		confirm numeric var `lhs'
		gettoken token 0 : 0, parse(" ,=.")
		u_mi_token_mustbe "`token'" "="
		local rhs
		gettoken token 0 : 0, parse(" ,=.")
		gettoken nexttoken : 0, parse(" ,=.")
		while ("`nexttoken'"!="=" & "`token'"!="") {
			if ("`token'"!=".") {
				unab var : `token'
				confirm numeric var `var'
			}
			else {
				local var .
			}
			local rhs `rhs' `var'
			gettoken token 0 : 0, parse(" ,=.")
			gettoken nexttoken : 0, parse(" ,=.")
		}
		local m : word count `rhs'
		if (`M'==.) {
			local M `m'
		}
		else if (`M'!=`m') { 
			local mvariables = cond(`M'==1, "variable", "variables")
			local cvariables = cond(`m'==1, "variable", "variables")

			di as smcl as err "{p}"
			di as smcl as err "`opname'(`original'):"
			di as smcl as err ///
				"inconsistent number of variables specified"
			di as smcl as err "{p_end}"
			di as smcl as err "{p 4 4 2}"
			if ("`prioropname'"!="") {
				di as smcl as err ///
					"in option {bf:`prioropname'()} you"
				di as smcl as err ///
					"specified `M' `mvariables' for each"
				di as smcl as err "{it:var}=,"
			}
			else {
				di as smcl as err "before `lhs'= you specified"
				di as smcl as err "`M' `mvariables' for each"
				di as smcl as err "{it:var}=,"
			}
			di as smcl as err "yet for `lhs'="
			di as smcl as err "you specified `m' `cvariables'"
			di as smcl as err "{p_end}"
			exit 198
		}
		local lhslist `lhslist' `lhs'
		local toret `"`toret' "`lhs' `rhs'""'
	}

	local lhslist : list dups lhslist
	if ("`lhslist'"!="") {
		local lhslist : list uniq lhslist
		local n : word count `lhslist'
		local variables = cont(`n'==1, "variable", "variables")
		local appears  = cont(`n'==1, "appears",  "appear")
		di as smcl as err "{p}"
		di as smcl as err "`variables' `lhslist'"
		di as smcl as err "`appear more than once on the left of the"
		di as smcl as err "equal sign in options"
		di as smcl as err "{bf:imputed()} and {bf:passive()}"
		di as smcl as err "{p_end}"
		exit 198
	}

	local M = cond(`M'==., 0, `M')
	c_local `toretname' `"`toret'"'
	c_local `userMname' `M'
end

program u_mi_import_getdups
	args toret colon  oplist

	local list
	foreach el of local oplist {
		gettoken lhs rhs : el
		local list `list' `rhs'
	}
	u_mi_duplicates mydups : "`list'"
	local period .
	local mydups : list mydups - period
	c_local `toret' `mydups'
end
		

program u_mi_duplicates
	args toret colon  list

	local uniq : list uniq list
	local dups : list list - uniq
	local dups : list uniq dups
	c_local `toret' `dups'
end



/*
	mi import ice,
		id(<varlist>) m(<varname>)
               [
		imputed(<varlist>)
		passive(<varlist>)
		DROP                        (drops id() and m())
		]


*/

program mi_import_ice
	syntax , ///
	[AUTOmatic CLEAR IMPuted(varlist numeric) PASsive(varlist numeric) ///
	noLONGNAMESCHK /*undoc.*/ ]

	if (c(changed) & "`clear'"=="") {
		error 4
	}

	local imputed : list uniq imputed
	local passive : list uniq passive
	local bad     : list imputed & passive
	if ("`bad'"!="") {
		local n : word count `bad'
		local variables = cond(`n'==1, "variable", "variables")
		di as err "{p 0 0 2}"
		di as err "`variables' {bf:`bad'} may not appear in both"
		di as err "{bf:imputed()} and {bf:passive()} options"
		di as err "{p_end}"
		exit 198
	}

	if ("`imputed'"!="") {
		local impop "imputed(`imputed')"
	}
	if ("`passive'"!="") {
		local pasop "passive(`passive')"
	}

	novarabbrev {
		preserve
		mi import flong, id(_mi) m(_mj) clear
		global S_FN
		char _dta[mi_ivar]		// sic
		char _dta[mi_id]		// sic
		drop _mi _mj
		sort _mi_m _mi_id
	}

	if ("`automatic'"=="") {
		if ("`imputed'"!="") {
			mi register imputed `imputed', `longnameschk'
		}
		if ("`passive'"!="") {
			mi register passive `passive', `longnameschk'
		}
		restore, not
		exit
	}

	qui count if _mi_m==0
	local N = r(N)
	if (`N')==0 { 
		restore, not
		exit
	}
	local Np1 = `N' + 1

	unab allvars : _all
	local combined : list imputed | passive
	local allvars : list allvars - combined

	novarabbrev {
		local implist 
		foreach v of local allvars {
			cap confirm string variable `v'
			if _rc==0 {
				continue
			}
			qui count if `v'==. in 1/`N'
			if (r(N)) {
				qui count if `v'[_mi_id]!=`v' & `v'[_mi_id]!=.
				if (r(N)==0) {
					local implist `implist' `v'
				}
			}
		}
		if ("`implist'"!="" | "`imputed'"!="") {
			mi register imputed `imputed' `implist', `longnameschk'
		}
		if ("`passive'"!="") {
			mi register passive `passive', `longnameschk'
		}
	}
	restore, not
end
