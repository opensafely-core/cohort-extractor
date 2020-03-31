*! version 1.0.14  09sep2019

/* -------------------------------------------------------------------- */
						/* fp ...		*/
program fp, rclass 
	version 13
	local vv : di "version " string(_caller()) ", missing:"

	set prefix fp

	gettoken cmd rest : 0, parse(" <,")
	local l = strlen("`cmd'")

	if ("`cmd'"=="" | "`cmd'"==",") {
		`vv' fp_replay `0'
		// return add
		exit
	}

	if ("`cmd'" == bsubstr("generate", 1, max(3,`l'))) {
		fp_generate `rest'
		return add
		exit
	}

	if ("`cmd'"=="postest") {
		fp_postest `rest'
		return add
		exit
	}

	if ("`cmd'"=="predict") {
		fp_predict `rest'
		//return add
		exit
	}
	if ("`cmd'"=="plot") {
		fp_plot `rest'
		exit
	}

	if ("`cmd'"=="<") { 
		`vv' fp_prefix `0'
		exit
	}

	di as err "{bf:fp `cmd'}:  unknown {bf:fp} subcommand {bf:`cmd'}"
	exit 198
end

/* -------------------------------------------------------------------- */
						/* fp ...		*/

program fp_replay
	if (!inlist("`e(fp_cmd)'","fp, powers():","fp, search():")) {
		error 301 
		/*NOTREACHED*/
	}
	if ("`e(cmd)'" == "") {
		error 301
		/*NOTREACHED*/
	}

	di as res "{p 1 3 2}"
	di as res `"(`e(fp_cmdline)')"'
	di as res "{p_end}"
	if ("`e(fp_cmd)'" == "fp, powers():") { 
		`e(cmd)' `0'
		exit
	}
	syntax [, noCOMPARE *]
	mata: fp_replay(`"`options'"', "`compare'"=="")
end


program fp_predict
	if ("`e(fp_cmd)'" == "") {
		exit 301
	}
	// ensure that there are no interactions with other terms
	local a `e(fp_terms)'
	tempname b
	matrix `b' = e(b)
	local cfnames: colnames `b'
	local err {p 0 1 2}{bf:fp predict} not ///
			allowed when fractional polynomial ///
			terms are involved in interactions ///
			with other covariates{p_end}

	foreach lname of local a {
		foreach cfname of local cfnames {
			_ms_parse_parts `cfname'
			if (inlist("`r(type)'","interaction","product")) {
				local k = r(k_names)
				forvalues i = 1/`k' {
					if ("`r(name`i')'" == "`lname'") {
						di as error "`err'" 
			 			exit 498
					}
				}
			}
		}
	}
	syntax  newvarlist(min=1 max=1 numeric) [if] [in], ///
		[fp stdp EQuation(string)]

	if ("`fp'" != "" & "`stdp'" != "") {
		opts_exclusive "fp stdp"
		/*NOTREACHED*/
	}
	if ("`equation'" == "") {
		local equation #1
	}

	// parse equation
	tokenize `equation', parse(" #")
	if ("`1'" == "#") {
		capture local er = round(real(ltrim(rtrim("`2'"))),1) ///
					== real(ltrim(rtrim("`2'")))
		if (_rc | ("`er'" == "0")) {
			di as error "invalid {bf:equation()}"
			exit 198
		}
		local eqnames: coleq `b'
		local eqnames: list uniq eqnames
		local equation: word `2' of `eqnames'
		if "`equation'" == "_" {
			local equation 
		}
		else {
			local equation [`equation']
		}
	}
	else {
		local equation [`equation']
	}
	local predarg `fp'`stdp'
	local fpterms `e(fp_terms)'
	tempname matb
	matrix `matb' = e(b)	
	foreach lname of local fpterms {
		if ("`fpexp'" != "") {
			local fpexp `fpexp' + `equation'_b[`lname']*`lname'
		}
		else {
			local fpexp `equation'_b[`lname']*`lname'
		}
	}
	capture di `equation'_b[_cons]
	if !_rc {
		if ("`fpexp'" != "") {
			local fpexp `fpexp' + `equation'_b[_cons]
		}
		else {
			local fpexp `equation'_b[_cons]
		}
	}
	if ("`stdp'" == "") {
		gen `typlist' `varlist' = `fpexp' `if' `in'
		label variable `varlist' 
		mata: label_fp_pred_fp("`varlist'")
	}
	else {
		tempvar pnltmp
		predictnl `typlist' `pnltmp' = `fpexp' `if' `in' ///
			, se(`varlist') 
		mata: label_fp_pred_stdp("`varlist'")
	}	
end

program fp_plot, sortpreserve
syntax [if] [in] , Residuals(string) [EQuation(string) ///
		    LEGend(string asis) Level(cilevel) *]
	if ("`equation'" != "") {
		local equation equation(`equation')
	}
        _get_gropts , graphopts(`options')      ///
                getallowed(CIOPts PLOTOPts LINEOPts addplot)

        local addplot `"`s(addplot)'"'

	if ("`addplot'" != "") {
		preserve
	}	

        local options `"`s(graphopts)'"'
        local ciopts `"`s(ciopts)'"'
	local ciopts pstyle(ci) `ciopts'
	local plopts `"`s(plotopts)'"'
	local plopts pstyle(p1) `plopts'
        local lopts `"`s(lineopts)'"'
	local lopts lstyle(refline) `lopts'
        _check4gropts ciopts, opt(`ciopts')
        _check4gropts plotopts, opt(`plopts')
        _check4gropts lineopts, opt(`lopts')

	if ("`legend'" == "") {
		local legend legend(off)
	}
	else {
		local legend legend(`legend')
	}

	marksample touse
	tempvar component component_se resid cpr
	qui fp predict double `component' if `touse', fp `equation'
	qui fp predict double `component_se' if `touse', stdp `equation'
	if ("`residuals'" != "none") {
		qui predict double `resid' if `touse', `residuals'
		qui gen double `cpr' = `component' + `resid' if `touse'
		label variable `cpr' "Component+residual of `e(fp_variable)'"

	}
	else {
		local resid 0
	}
	
	tempname z lb ub
	scalar `z' = -invnorm(.5-`level'/200)
	qui gen double `lb' = `component' - `z'*`component_se' if `touse'
        qui gen double `ub' = `component' + `z'*`component_se' if `touse'
	local z: variable label `component'
	label variable `lb' "`level'% CI lower bound"
        label variable `ub' "`level'% CI upper bound"
	label variable `component' "Predictor"

	sort `e(fp_variable)', stable
	local depvar
	if ("`e(depvar)'" != "") {
		local depvar of `e(depvar)'
	}

	if ("`residuals'" != "none") {
		local sca (scatter `cpr'  `e(fp_variable)'	///
			if `touse',			///
			`plopts')			
		local laby ytitle("Component+residual `depvar'") 
	}
	else {
		local sca
		local laby ytitle("Component")
	}
	
	graph twoway 				///
		(rarea `lb' `ub' `e(fp_variable)'	///
			if `touse',			///
			`ciopts')			///
		`sca'					///
		(line `component' `e(fp_variable)'	///
			if `touse',			///
			`lopts')			///
		, `legend' 			///
		`laby' `options'
	if "`addplot'" != "" {
		restore
		version 8: graph addplot `addplot' ||
	}
	
end


/* -------------------------------------------------------------------- */
						/* fp ...: ...		*/

/*
	Syntax:

		fp <<term>> [, <options>]: <est_cmd>
                   -      -
*/

program fp_prefix, eclass

	/* ------------------------------------------------------------ */
	local fullcmd `"fp `0'"'
	/* ------------------------------------------------------------ */
						/* parse		*/
	mata: _parse_colon("hadcolon", "est_cmd")
	if (!`hadcolon') {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err "Colon not found."
		di as err "{p_end}"
		exit 198
	}

	syntax anything(id=term name=term everything) [, 	///
	/// estimation options:
		FP(numlist min=1 sort)				///
		POWers(numlist min=1 sort)			///
		DIMension(real 2)				///
	/// generate options:					
		REPLACE						///
		NOSCAle SCAle SCAlev(numlist min=2 max=2)       ///
		NOCENTer CENTer CENTerv(numlist min=1 max=1)	///
		CATZero						///
		ZERO						///
		ALL						///
	/// replay options:
	      noCOMPARE						///
	/// other options:
		CLASSIC						///
		* ]		// passed as display options to cmd
	parse_term termname varname : `"`term'"'
	// substitute termname for any possible abbreviations of varname
	// when fp <term> syntax used
	local f: subinstr local term "(" ""
	local le: length local term
	local lf: length local f
	if (`le' == `lf') {
		sub_full_term, 	enamemac("est_cmd") ///
				varname(`"`varname'"') ///
				estcmd(`"`est_cmd'"') 
		local termname `varname'
	}
						/* parse		*/
	/* ------------------------------------------------------------ */

	/* ------------------------------------------------------------ */
					/* process options   		*/

	if ((floor(`dimension') != `dimension') | `dimension' < 1) {
		error_dimension `dimension'
	}
					/* zero and catzero		*/
	if ("`zero'" != "" & "`catzero'" != "") {
		opts_exclusive "zero catzero"
		/*NOTREACHED*/
	}
					/* fracpoly() and powers()	*/

	if ("`fp'"!="" & "`powers'"!="") {
		error_fp_powers
		/*NOTREACHED*/
	}
	if ("`fp'"=="" & "`powers'"=="") {
		local powers "-2 -1 -.5 0 .5 1 2 3"
	}

					/* fp() and dimension()		*/
	if ("`fp'"!="") {
		if (`dimension'!=2) {
			error_fp_dimension
			/*NOTREACHED*/
		}
	}
	if ("`classic'" != "") {
		capture assert ///
	"`compare'`scale'`center'`scalev'`centerv'`noscale'`nocenter'" == ""
		if (_rc) {
			di as error "{p 0 1 2}cannot specify scaling or "
			di as error "centering options with {bf:classic}"
			di as error "{p_end}"
			exit 198
		}
		local scale scale
		local center center
		local compare nocompare
	}
					/* other options		*/

	process_scale s_a s_b isscale isautoscale : "`noscale'"  "`scale'" ///
		 "`scalev'"
	process_center c_mean iscenter : "`nocenter'" "`center'" "`centerv'"
					

					/* process options   		*/
	/* ------------------------------------------------------------ */
					/* verify est_cmd is allowed	*/
	verify_ecmd `est_cmd'
	if (`isautoscale' & "`zero'"!="") {
		error_scaling_zero
		/*NOTREACHED*/
	}
	if (`isautoscale' & "`catzero'"!="") {
		error_scaling_catzero
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */
					/* run command			*/
	capture noisily 					///
	mata: fp_prefix_cmd(					///
		     `"fullcmd"',				///	
		     "varstodrop",                              ///
		     "esttoodrop", 				///
		     "`termname'", 				///
		     "`varname'", 				///
		     "est_cmd", 				///
		     `dimension',				///
		     "`fp'", 					///
		     "`powers'", 				///
		     `s_a', `s_b',				///
		     `c_mean',					///
		     `iscenter',				///
		     `isscale',					///
		     "`compare'"=="", 				///
		     "`debug'"!="", 				///
		     "`log'"!="",				///
		     "`replace'"!="",				///
		     "`zero'"!="",				///
		     "`catzero'"!="",				///
		     "`all'"!="",				///
	             "`options'"							 	)
		
	/* ------------------------------------------------------------ */
					/* cleanup if error		*/
	if (_rc) {
		nobreak {
			local rc = _rc 
			foreach name of local varstodrop {
				capture drop `name'
			}
			if ("`esttodrop'" != "") {
				capture estimates drop `esttodrop'
				clear_ereturn
			}
			capture ereturn clear
		}
		exit `rc'
	}
	/* ------------------------------------------------------------ */
end


/*
	//called under <term> syntax 
	sub_full_term,  enamemac(est_cmd)    ///
			varname("varname")  ///
			estcmd("est_cmd") 
*/
program sub_full_term
	syntax, enamemac(string) varname(string) estcmd(string)

	tokenize `"`estcmd'"', parse("<> ")
	local i = 1
	local si = 1
	while "``i''" != "" {
		local j = `i'+1
		local k = `i'+2
		if("``i''" == "<" & "``k''" == ">") {
			unab f: ``j''
			if "`f'" == "`varname'"  {
				local sub_`si' ``j''
				local si = `si' + 1		
			}
			local i = `k'+1
		}
		else {
			local i = `i' + 1
		}		
	}
	local si = `si'-1
	forvalues i = 1/`si' {
		local estcmd: subinstr local estcmd ///
			"<`sub_`si''>" "<`varname'>", all
	}
		
	
	c_local `enamemac' "`estcmd'"

end


/*
	parse_term <termmac> <varnamemac> : "<term>"


		<term> := <<termname>>[(varname)]
			  -          -             (< > significant)
*/

program parse_term
	args termnamemac varnamemac colon input nothing
	assert `"`nothing'"' == ""
	assert `"`colon'"' == ":"

	local input = strtrim(`"`input'"')
	if (bsubstr(`"`input'"', 1, 1) != "<") {
		error_badterm `"`input'"'
		/*NOTREACHED*/
	}
	local i = strpos(`"`input'"', ">")
	if (`i'==0) {
		error_badterm `"`input'"'
		/*NOTREACHED*/
	}
	local termname = bsubstr(`"`input'"', 2, `i'-2)
	capture fvexpand `termname'
	if (!_rc) {
		if ("`r(fvops)'" == "true") {
			di as error ///
			"factor variables not allowed for {it:term}"
			exit 198
		}
	}
	capture _ms_parse_parts `termname'
	if (!_rc) {
		if ("`r(ts_op)'" != "") {
			di as error ///
			"time-series operators not allowed for {it:term}"
			exit 198
		}
	}
	if wordcount("`termname'") > 1 {
		di as error ///
		"{p 0 1 2} only one word may be specified for {it:term}" ///
		" in {bf:<}{it:term}{bf:>}{p_end}"
		exit 198
	}
	confirm name `termname'
	local rest = bsubstr(`"`input'"', `i'+1, .)
	if (`"`rest'"' == "") {
		unab varname : `termname'
		if ("`varname'"!="`termname'") {
			di as txt "{p 0 1 2}"
			di as txt "(note: term {bf:`termname'} assumed"
			di as txt "to correspond to"
			di as txt "varname {bf:`varname'})"
			di as txt "{p_end}"
		}
		c_local `termnamemac' "`termname'"
		c_local `varnamemac'  "`varname'"
		exit
	}

	if (bsubstr(`"`rest'"', 1, 1) != "(") {
		error_badterm `"`input'"'
		/*NOTREACHED*/
	}
	local i = strpos(`"`rest'"', ")")
	if (`i'==0 | bsubstr(`"`rest'"', `i'+1, .)!="") {
		error_badterm `"`input'"'
		/*NOTREACHED*/
	}

	local varname = bsubstr(`"`rest'"', 2, `i'-2)
	capture fvexpand `varname'
	if (!_rc) {
		if ("`r(fvops)'" == "true") {
			di as error ///
			"{p 0 1 2}factor variables not allowed for" ///
			" {it:varname} in {bf:<}{it:term}{bf:>(}" ///
			"{it:varname}{bf:)}{p_end}"
			exit 198
		}
	}
	capture _ms_parse_parts `varname'
	if (!_rc) {
		if ("`r(ts_op)'" != "") {
			di as error ///
			"{p 0 1 2}time-series operators not allowed" ///
			" for {it:varname} in {bf:<}{it:term}" ///
			"{bf:>(}{it:varname}{bf:)}{p_end}"
			exit 198
		}
	}
	unab varname : `varname'
	c_local `termnamemac' "`termname'"
	c_local `varnamemac'  "`varname'"
end	
	

/*

	process_scale s_a s_b isscale : "`noscale'" "`scale'" "`scalev'"

	Scaling is defined as 

		x_mod = (x+a)/b

	for constants a and b.

	We allow all the following options:

		scale		do automatic scaling 
				meaning figure out a and b

		noscale		do no scaling; i.e., a=0 and b=1

		scale(#_a #_b)  scale using these values

        -noscale- is the default.

	Caller parses as three separate options.
	This routine returns 

        Returned

                     scale       noscale      scale(#_a #_b)
                     ---------------------------------------
               s_a       .             0                #_a
               s_b       .             1                #_b
   	   isscale       1             0                  1
                     ---------------------------------------
*/

program process_scale 
	args s_a_name s_b_name is_scale_name is_auto_scale_name colon ///
		noscale scale scalev nothing

	assert "`colon'"==":"
	assert "`nothing'"==""

	local n = ("`scale'"!="") + ("`noscale'"!="") + ("`scalev'"!="")
	
        local isscale = !((`n' == 0) | "`noscale'" != "")
	local isauto  = ("`scale'"!="")
        c_local `is_scale_name' `isscale'
	c_local `is_auto_scale_name'  `isauto'

	/* ------------------------------------------------------------ */
					/* set default			*/
	if (`n'==0) {
		/* s_how is 2, automatic */
		c_local `s_a_name' 0
		c_local `s_b_name' 1
		exit
	}

	/* ------------------------------------------------------------ */
					/* only one option please	*/
	if (`n'!=1) { 
		error_process_scale
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */
					/* set according to option	*/
	if ("`scale'"!="") {
		c_local `s_a_name' .
		c_local `s_b_name' .
		exit
	}

	if ("`noscale'"!="") {
		c_local `s_a_name' 0
		c_local `s_b_name' 1
		exit
	}

	local a: word 1 of `scalev'
	local b: word 2 of `scalev'
	if ((`a'==.) | (`b'==.)) {
		error_scale_missing `a' `b'
		/*NOTREACHED*/
	}
	c_local `s_a_name' `a'
	c_local `s_b_name' `b'
end


/*

	process_center c_mean iscenter : "`nocenter'" "`center'" "`centerv'"

	Centering is a function of a "mean".

		center		do centering on mean of data

		noscale		default, no centering

		center(#_mean)  center using these values

	Centering is done after scaling. 

	Caller parses as three separate options.
	This routine returns 

        Returned

                     center      nocenter     center(#_mean)
                     ---------------------------------------
            c_mean       .             0             #_mean
	  iscenter       1              0                 1
                     ---------------------------------------
*/

program process_center
	args c_mean_name is_center_name colon nocenter center centerv nothing

	assert "`colon'"==":"
	assert "`nothing'"==""

	local n = ("`center'"!="") + ("`nocenter'"!="") + ("`centerv'"!="")

	local iscenter = !((`n' == 0) | "`nocenter'" != "")
	c_local `is_center_name' `iscenter'
	/* ------------------------------------------------------------ */
					/* set default			*/
	if (`n'==0) {
		/* s_how is 2, automatic */
		c_local `c_mean_name' 0
		exit
	}

	/* ------------------------------------------------------------ */
					/* only one option please	*/
	if (`n'!=1) { 
		error_process_center
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */
					/* set according to option	*/
	if ("`center'"!="") {
		c_local `c_mean_name' . 
		exit
	}

	if ("`nocenter'"!="") {
		c_local `c_mean_name' 0
		exit
	}
	c_local `c_mean_name' `centerv'
end

program verify_ecmd
	args cmd 
	local cmd: subinstr local cmd "," " ", all
        local cmd: subinstr local cmd ":" " ", all
	local cmd: word 1 of `cmd'
	if ("`cmd'"=="boxcox") {
		error_cmd_notallowed "boxcox"
		/*NOTREACHED*/
	}
	if ("`cmd'"=="nl") {
		error_cmd_notallowed "nl"
		/*NOTREACHED*/
	}
	if ("`cmd'"=="nlsur") {
		error_cmd_notallowed "nlsur"
		/*NOTREACHED*/
	}
	if ("`cmd'"=="stepwise") {
		error_cmd_notallowed "stepwise" pre
		/*NOTREACHED*/
	}
	if ("`cmd'"=="nestreg") {
		error_cmd_notallowed "nestreg" pre
		/*NOTREACHED*/
	}
	if ("`cmd'"=="mi") {
		error_cmd_notallowed "mi" pre
		/*NOTREACHED*/
	}
	if ("`cmd'"=="bootstrap") {
		error_cmd_notallowed "bootstrap" pre
		/*NOTREACHED*/
	}
        if ("`cmd'"=="jackknife") {
                error_cmd_notallowed "jackknife" pre
                /*NOTREACHED*/
        }
	if ("`cmd'"=="by") {
		error_cmd_notallowed "by" pre
		/*NOTREACHED*/
	}
	if ("`cmd'"=="statsby") {
		error_cmd_notallowed "statsby" pre
		/*NOTREACHED*/
	}
	if ("`cmd'"=="rolling") {
		error_cmd_notallowed "rolling" pre
		/*NOTREACHED*/
	}
	if ("`cmd'"=="svy") { 
		error_cmd_notallowed "svy" pre
		/*NOTREACHED*/
	}
end


program error_cmd_notallowed
	args cmd pre
	di as err "{bf:fp}: may not be combined with {bf:`cmd'}"
	di as err "{p 4 4 2}"
	if ("`pre'" != "") {
		di as err ///
      `""{bf:fp} ...{bf:: `cmd'}  ...{bf::} {it:est_cmd} ..." is not allowed."'
	}
	else {
		di as err ///
	      `""{bf:fp} ...{bf:: `cmd'}  ..." is not allowed."'
	}
	di as err "{p_end}"


	exit 190
end
	

program error_process_center
	di as err "{p 0 0 2}"
	di as err "may only specify one of"
	di as err ///
		"{bf:nocenter}, {bf:center}, or {bf:center(}{it:#_a #_b}{bf:)}"
	di as err "{p_end}"
	di as err "{p 4 4 2}"
	di as err "You specified two or more of the above options."
	di as err "Centering is a function of the mean of the" 
	di as err "fractional polynomial variable."
	di as err "If you specify no centering options, centering is not" 
	di as err "performed."
	di as err "The same happens if you specify {bf:nocenter}."
	di as err "If you specify {bf:center}, the mean is calculated"
	di as err "automatically and centering is performed."
	di as err "If you specify {bf:center(}{it:#_mean}{bf:)}, the"
	di as err "mean you specify is used for the centering."
	di as err "{p_end}"
	exit 198
end

program error_process_scale
	di as err "{p 0 0 2}"
	di as err "may only specify one of"
	di as err "{bf:noscale}, {bf:scale}, or {bf:scale(}{it:#_a #_b}{bf:)}"
	di as err "{p_end}"
	di as err "{p 4 4 2}"
	di as err "You specified two or more of the above options."
	di as err "Let {it:x} represent the fractional polynomial variable."
	di as err "Then the fractional polynomial is calculated on"
	di as err "({it:x}-{it:a})/{it:b}."  
	di as err "If you specify no scale options, {it:a}=0 and {it:b}=1."
	di as err "The same happens if you specify {bf:noscale}."
	di as err "If you specify {bf:scale}, {it:a} and"
	di as err "{it:b} are determined automatically."
	di as err "If you specify {bf:scale(}{it:#_a #_b}{bf:)}, the"
	di as err "values you specify are used."
	di as err 
	di as err "{p 4 4 2}"
	di as err "It is required that ({it:x}-{it:a})/{it:b} be > 0 in all"
	di as err "observations unless you also specify option {bf:zero}."
	di as err "{p_end}"
	exit 198
end
	

program error_scale_missing 
	args a b
	di as err "{bf:scale(`a' `b')} invalid"
	di as err "{p 4 4 2}"
	di as err "Values must be numeric and may not contain missing value."
	di as err "{p_end}"
	exit 198
end
	
program error_badterm 
	args contents
	di as err `"{bf:`contents'} invalid"'
	di as err "    The syntax for a {it:term} is"
	di as err 
	di as err "         {bf:<}{it:termname}{bf:>}"
	di as err 
	di as err "    or
	di as err 
	di as err ///
	"         {bf:<}{it:termname}{bf:>}{bf:(}{it:varname}{bf:)}"
	exit 198
end

program error_fp_powers
	di as err "options {bf:fp()} and {powers()} may not both be specified"
	di as err "{p 4 4 2}"
	di as err "{bf:powers()} specifies the powers to be searched among."
	di as err "{bf:fp()} specifies the fixed set of powers to be used."
	di as err "If you specify neither,"
	di as err "{bf:powers(-2 -1 -.5 0 .5 1 2 3)} is assumed."
	di as err "{p_end}"
	exit 198
end

program error_fp_dimension
	di as err "{p 0 0 2}"
	di as err "options {bf:fp()} and {bf:dimension()}"
	di as err "may not both be specified"
	di as err "{p_end}"
	di as err "{p 4 4 2}"
	di as err "You specified the dimension when you specified"
	di as err "{bf:fp()}."
	di as err "{p_end}"
	exit 198
end


program error_dimension
	args dimension 
	di as err "option {bf:dimension(`dimension')} invalid"
	di as err "{p 4 4 2}"
	di as err "{bf:dimension()}>0 required."
	di as err "{bf:dimension()} specifies the degree of the fractional"
	di as err "polynomial to be found."
	di as err "{p_end}"
	exit 198
end

program error_scaling_zero
	di as err "options {bf:scale} and {bf:zero} are invalid together"
	di as err "{p 4 4 2}"
	di as err "You may not specify option {bf:scale} "
	di as err "with option {bf:zero}."
	di as err "The {bf:scale} option eliminates negative and zero"
	di as err "values.  Option {bf:zero} says negative and zero"
	di as err "values are to be set to zero fractional polynomial values."
	di as err "{p_end}"
	exit 198
end

program error_scaling_catzero
	di as err "options {bf:scale} and {bf:catzero} are invalid together"
	di as err "{p 4 4 2}"
	di as err "You may not specify option {bf:scale} "
	di as err "with option {bf:catzero}."
	di as err "The {bf:scale} option eliminates negative and zero"
	di as err "values automatically.  Option {bf:catzero} says negative "
	di as err "and zero values are to be set to zero fractional polynomial"
	di as err " values, and that an indicator variable for negative and "
	di as err "zero values be added to the model."
	di as err "{p_end}"
	exit 198
end



						/* fp ...: ...		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
						/* fp generate ...	*/
/*
	fp generate [type stubname =] <varname>^(<numlist>) [if] [in] 
	[, <options>]
*/

program fp_generate, rclass
	local fullcmd fp generate `0'
	local generate
	tokenize `"`0'"', parse(" =")	 
	if ("`2'" == "=") {
		local generate `1'
		local typlist float
		macro shift 2
		local 0 `*'	
	}
	else if ("`3'" == "=") {
		local generate `2'
		local typlist `1'
		macro shift 3
		local 0 `*'
	}
	else {
		local s: subinstr local 1 "^" " "
		local s1: word 1 of `s'
		
		capture confirm variable `s1'
		if (_rc) {
			if ("`s'" == "`1'") {
				local s21: subinstr local 2 "^" " "
				local s2: word 1 of `s21'
			}
			else {
				local s2: word 2 of `s'
			}
			// check that s1 a type
			capture assert inlist("`s1'", ///
			"byte","int","long","float", "double")
			if (_rc) {
				capture assert "`s2'" != ""
				local rc = _rc
				capture confirm name `s2'
				local rc = _rc | `rc'
				if (_rc) {
					confirm variable `s1'
				}
				confirm numeric variable `s2'
				di as error "`s1' invalid type"
				exit 198
			}
			local typlist `1'			
			macro shift 
			local 0 `*'			
		}
		else {
			local typlist float
		}		
	}
	
        syntax anything(id="fractional powers" name=fps) 		///
                [if] [in]                                           	///
                [,                             			    	///
		REPLACE							///
		ZERO							///
                CATZero                                                 ///
                NOSCAle SCAle SCAlev(numlist min=2 max=2)       	///
                NOCENTer CENTer CENTerv(numlist min=1 max=1)    	///
                ]

        parse_fps varname powerlist : `"`fps'"'

			/* zero and catzero		*/
	if ("`zero'" != "" & "`catzero'" != "") {
		opts_exclusive "zero catzero"
		/*NOTREACHED*/
	}

        if ("`generate'" != "") {
                capture confirm name `generate'
                if (_rc) {
                        error_generate_invalid "`generate'"
                        /*NOTREACHED*/
                }
        }
        else {
                local generate `varname'
        }
	marksample touse
	qui replace `touse' = 0 if missing(`varname')
        process_scale s_a s_b isscale isautoscale : "`noscale'"  "`scale'" ///
		 "`scalev'"
        process_center c_mean iscenter : "`nocenter'" "`center'" "`centerv'"

	if (`isautoscale' & "`zero'"!="") {
		error_scaling_zero
		/*NOTREACHED*/
	}
	if (`isautoscale' & "`catzero'"!="") {
		error_scaling_catzero
		/*NOTREACHED*/
	}


	mata: fp_generate(                                      ///
		     "`typlist'",				///
		     "`generate'",				///	
                     "varstodrop",                              ///
                     "`varname'",                               ///
                     "`powerlist'",                             ///
                     `s_a', `s_b',                              ///
                     `c_mean',                                  ///
                     `iscenter',                                ///
                     `isscale',                                 ///
		     "`replace'"!="",				///
                     "`zero'"!="",                           	///
                     "`catzero'"!="",                           ///
		     "`touse'",					///
		     `"`fullcmd'"')	
	return add
end

                                                /* fp generate ...      */
/* -------------------------------------------------------------------- */


/*
	parse_fps <varname_mac> <powerlist_mac> : `"<fps>"'

		<fps>       := <varname>^(<powerlist>)
		<powerlist> := <numlist>

	returns <varname> and <powerlist> in respective macros.
*/

program parse_fps 
	args varname_name powerlist_name colon fps nothing
	assert "`colon'"  ==":"
	assert "`nothing'"==""

	local i = strpos("`fps'", "^")
	assert_true expr "`i'>1" `"`fps'"'
	local name = strtrim(bsubstr("`fps'",     1, `i'-1))
	unab name : `name'

	local rest = strtrim(bsubstr("`fps'", `i'+1, .))
	local c    = bsubstr("`rest'", 1, 1)
	assert_true expr `" "`c'"=="(" "' `"`fps'"'

	local rest = strtrim(bsubstr("`rest'", 2, .))
	local i    = strpos("`rest'", ")")
	assert_true expr "`i'>1" `"`fps'"'
	local nothing = strtrim(bsubstr("`rest'", `i'+1, .))
	assert_true expr `""`nothing'"=="""' `"`fps'"'
	local powerlist = strtrim(bsubstr("`rest'", 1, `i'-1))

	local 0 ", powers(`powerlist')"
	syntax [, POWERS(numlist min=1 sort)]

	c_local `varname_name'    `name'
	c_local `powerlist_name'  `powers'
end


/*
	assert_true expr "<expr>" "<fps>"
	assert_true cmd  "<cmd>"  "<fps>"

	assert <expr> is true or <cmd> has rc=0.
	If not, present error message containing <fps>.
*/
	
	
program assert_true
	args typ toassert fps

	if ("`typ'"=="expr") {
		if (!(`toassert')) {
			error_fps_invalid `"`fps'"'
			/*NOTREACHED*/
		}
	}
	else if ("`typ'"=="cmd") {
		capture `cmd'
		if (_rc) {
			error_fps_invalid `"`fps'"'
			/*NOTREACHED*/
		}
	}
	else {
		assert 0
		/*NOTREACHED*/
	}
end

program error_fps_invalid
	di as err "fractional-power expression invalid"
	di as err "    Syntax is"
	di as err _col(8) ///
	"{bf:fp generate} {it:varname}{bf:^(}{it:# #} ... {it:#}{bf:)} ..."
	di as err "{p 4 4 2}
	di as err `"The "{it:varname}{bf:^(}{it:# #} ... {it:#}{bf:)}" part"'
	di as err "is called a fractional-power expression."
	di as err "For example, the first part of an {bf:fp generate}"
	di as err "command might read,"
	di as err "{p_end}"
	di as err "{p 8 8 2}
	di as err "{bf:fp generate age^(0 2 2)} ..."
	di as err "{p_end}"
	di as err "{p 4 4 2}
	di as err "Type {bf:help fp}."
	di as err "{p_end}"
	exit 198
end
	

/* ==================================================================== */
				/* Mata MATA				*/

local RS	real scalar
local RR	real rowvector
local RC	real colvector
local RM	real matrix
local SS	string scalar
local SR	string rowvector
local SC	string colvector
local SM	string matrix

local boolean	real scalar
local 		True	1
local 		False	0

local Todo	real scalar
local 		Todo_fp		1
local		Todo_search	2


local Varstat	real 
local VarstatS	`Varstat' scalar
local VarstatR	`Varstat' rowvector
local 		Varstat_new		1
local		Varstat_dropable	2
local		Varstat_exists		3

local EvalMethod	real
local EvalMethodS	`EvalMethod' scalar
local EM_none		0
local EM_ll		1


local ProbName		fp_problemdf
local ProbS		struct `ProbName' scalar

local OpsName		fp_opsdf
local OpsS		struct `OpsName' scalar

local GenopsName	fp_gbenopsdf
local GenopsS		struct `GenopsName'

local RopsName		fp_ropsname
local RopsS		struct `RopsName' scalar

local ElementName	fp_elementdf
local ElementS		struct `ElementName' scalar

local FPvarName		fp_fpvardf
local FPvarS		struct `FPvarName' scalar

local CenterName	fp_centerdf
local CenterS		struct `CenterName' scalar

local ScaleName		fp_scaledf
local ScaleS		struct `ScaleName' scalar

local InitrunName	fp_initrundf
local InitrunS		struct `InitrunName' scalar

local PenumName		fp_penumdf
local PenumS		struct `PenumName' scalar

local StrategyName	fpstrategydf
local StrategyS		struct `StrategyName' scalar

local ModelName		fpmodeldf
local ModelS		struct `ModelName' scalar
local ModelC		struct `ModelName' colvector

local SresultsName	fpsresultsdf
local SresultsS		struct `SresultsName' scalar

local CMeterName	fpcmeterdf
local CMeterS		struct `CMeterName' scalar

local MaxElnameLen	(32-6)
local MaxNameLen	32

local MaxTerms		9


mata:

/* -------------------------------------------------------------------- */
				/* Structures				*/

/*
	ProbS:
*/

struct `ProbName' {
	`SS'		fullcmd			// for saving in e(fp_cmdline)

	`SS'		varstodrop_name		// macro name
	`SS'		esttodrop_name		// macro name

	`SS'		est_cmd			// <est_cmd> containing 
						//   bracketed element(s)
	`OpsS'		op			// options

	`ElementS'	el			// element definition

	`InitrunS'	initrun			// initial run results

	`StrategyS'	strat			// model-evaluation strategy
	`boolean'	iscenter		// is centering performed?
	`boolean'	isscale			// is scaling performed?
}
void ProbInit(`ProbS' prob)
{
	prob.fullcmd         = ""
	prob.varstodrop_name = ""
	prob.esttodrop_name  = ""
	prob.est_cmd         = ""
	prob.iscenter = `False'
	prob.isscale  = `False'
	OpsInit(prob.op)
	ElementInit(prob.el)
	InitrunInit(prob.initrun)
	StrategyInit(prob.strat)
}
void ProbPrint(`ProbS' prob)
{
	printf("---------------------------------------------- Prob BEGIN\n")
	printf("varstodrop_name = |%s|\n", prob.varstodrop_name) 
	printf("esttodrop_name  = |%s|\n", prob.esttodrop_name) 
	printf("varstodrop = |%s|\n", st_local(prob.varstodrop_name))
	printf("est_cmd = |%s|\n", prob.est_cmd)

	printf("Prob.op.*:\n") ; OpsPrint(prob.op)

	printf("Prob.el:\n")  ; ElementPrint(prob.el)

	printf("Prob.initrun:\n") ; InitrunPrint(prob.initrun)

	printf("Prob.strat:\n") ; StrategyPrint(prob.strat)

	printf("Prob.iscenter:|%g|\n",prob.iscenter)
        printf("Prob.isscale:|%g|\n",prob.isscale)

	printf("---------------------------------------------- Prob END\n")
}
	

	/*
	OpsS:
		option structure
	*/

struct `OpsName'
{
	`boolean'	log
	`boolean'	debug

	`boolean'	replace
	`boolean'	zero
	`boolean'	catzero
	`boolean'	all

	`RopsS'		r
}
void OpsInit(`OpsS' g)
{
	g.log = g.debug = g.replace = g.zero = g.all = `False'
	RopsInit(g.r)
}
void OpsPrint(`OpsS' g)
{
	printf("--------------------------------------------- GBLop BEGIN\n")
	printf("          op.log = %g\n", g.log)
	printf("        op.debug = %g\n", g.debug)
	printf("      op.replace = %g\n", g.replace)
	printf("      op.zero    = %g\n", g.zero)
        printf("      op.catzero    = %g\n", g.catzero)
        printf("      op.all        = %g\n", g.all)
	RopsPrint(g.r)
	printf("--------------------------------------------- GBLop END\n")
}



struct `RopsName'
{
	`boolean'	compare
	`SS'		estcmd_ops
}
void RopsInit(`RopsS' ro)
{
	ro.compare    = `False'
	ro.estcmd_ops = ""
}
void RopsPrint(`RopsS' ro)
{
	printf("    op.r.compare = %g\n", ro.compare)
	printf(" op.r.estcmd_ops = %s\n", ro.estcmd_ops)
}



	/* ------------------------------------------------------------ */
	/*
	ElementS: element structure

	Reminder concerning jargon; consider

		fp myelement(myvar): regress y x1 x2 <myelement> x3 ...

	Then define
		The ELEMENT is "myelement".
		The BRACKETED ELEMENT is "<myelement>"
		The ELEMENT VARIABLE or FRACTIONAL POLYNOMIAL VARIABLE or 
		    FP VARIABLE or FPVAR or just VARIABLE is "myvar".
		    Usually the FPVAR has the same name as the ELEMENT.
		The TERMS are "myvar_0", "myvar_1", "myvar_2," ...
		TERMS are substituted for BRACKETED ELEMENTS.
	*/

struct `ElementName' 
{
	`SS'		elname		// element name
	`SS'      	bracketed_elname

	`FPvarS'	v		// FP variable, name and views

	`ScaleS'	s		// scale parameters:  a and b
	`CenterS'	c		// center parameter:  mean

	`Todo'		todo		// `Todo_fp' or `Todo_search'
	`RR'		powers		// `Todo_search': powers to search
	`RR'		fp		//     `Todo_fp': powers to use 
	`RS'		dimension	//   `Todo_search': max dim of result
					//       `Todo_fp': length(fp)

	`SR'		termnames	//   term names 1, 2, ...
	`SS'		term0name	//   term_0's name
	`boolean'	zero		//   no indicator variable, but 
					//   zero out fractional polynomial 
					//   for nonpositive inputs 
	`RM'		Vterms		//   view onto terms
}
void ElementInit(`ElementS' el)
{
	el.elname           = "" 
	el.bracketed_elname = "<>"

	FPvarInit(el.v)
	ScaleInit(el.s)
	CenterInit(el.c)

	el.todo      = .
	el.dimension = .
	el.termnames = J(1, 0, "")
	el.term0name = ""
	el.zero      = `False'
	/* el.penum is not initialized until setup */
}
void ElementPrint(`ElementS' el)
{
	printf("---------------------------------------------- ELop BEGIN\n")
	printf("Element.elname  = |%s|\n", el.elname)
	printf("Element.<elname>= |%s|\n", el.bracketed_elname)

	FPvarPrint(el.v)

	ScalePrint(el.s)
	CenterPrint(el.c)

	printf("Element.powers:\n")   ; el.powers 
	printf("ELement.fp\n")        ; el.fp 

	printf("Element.todo    = %f (1=fp 2=search)\n", el.todo)
	printf("Element.dimension = %g\n", el.dimension)
	printf("Element.termnames:\n") 
	el.termnames
	printf("Element.term0name = %s\n", el.term0name)
	printf("Element.zero = %f\n",el.zero)
	printf("---------------------------------------------- ELop END\n")
}


struct `FPvarName'
{
	`SS'	name 			// name of original variable
	`SS'	name_mod		// name, modified (tempvar)
	`SS'	lnname_mod		// ln(name_mod) (tempvar)
	`SS'	rname_mod		// 1/name (tempvar)
	`RC'	V_e			// view onto "name_mod if e(sample)"
	`RC'	lnV_e			// view onto "lname_mod if e(sample)"
	`RC'	rV_e			// view onto "rname_mod if e(sample)"
}
void FPvarInit(`FPvarS' v)
{
	v.name       = "" 		// filled in by user
	v.name_mod   = st_tempname(1)
	v.lnname_mod = st_tempname(1)
	v.rname_mod  = st_tempname(1)

	/* v.V_e, v.lnV_e, and v.rV_e do not require initialization */
}
void FPvarPrint(`FPvarS' v)
{
	printf("--------------------------------------------- FPvar BEGIN\n")
	printf("v.name      = |%s|\n", v.name)
	printf("v.name_mod  = |%s|\n", v.name_mod)
	printf("v.lname_mod = |%s|\n", v.lnname_mod)
	printf("v.rname_mod = |%s|\n", v.rname_mod)
	pprintf("RC V_e, lnV_e, rV_e not listed\n")
	printf("--------------------------------------------- FPvar END\n")
}


struct `CenterName' 
{
	`boolean'	auto
	`RS'		mean 		//   mean for centering 
}
void CenterInit(`CenterS' c)
{
	c.auto = `False'
	c.mean = .
}
void CenterPrint(`CenterS' c)
{
	printf("Element.Center.auto = %f\n", c.auto)
	printf("Element.Center.mean = %12.0g\n", c.mean)
}

struct `ScaleName'
{
	`boolean'	auto
	`RS'		a, b		//   x_mod = (x+a)/b
}
void ScaleInit(`ScaleS' s)
{
	s.auto    = `False'
	s.a       = s.b     = .
}
void ScalePrint(`ScaleS' s)
{
	printf("Element.Scale.auto = %f\n", s.auto)
	printf("Element.Scale.a    = %12.0g\n", s.a)
	printf("Element.Scale.b    = %12.0g\n", s.b)
}
	

	/* ------------------------------------------------------------ */
	/*
	Initrun
	*/

struct `InitrunName'
{
	`boolean'	hasrun			// init run performed
	`RS'		e_N			// e(N)
	`RS'		sum_e_sample		// sum(e(sample))
	`SS'		esample_var		// tempvar containing e(sample)
	`SS'		lrt_nok			// comparison table explanation
						// for missing p-values when
						// likelihood ratio (deviance)
						// test can't be performed
}
void InitrunInit(`InitrunS' d)
{
	d.hasrun       = 0
	d.e_N          = . 
	d.sum_e_sample = .
	d.esample_var  = st_tempname(1)
	d.lrt_nok      = ""
	
}
void InitrunPrint(`InitrunS' initrun)
{
	printf("------------------------------------------- Initrun BEGIN\n")
	printf("Initrun.e_N          = %g\n",   initrun.e_N)
	printf("Initrun.sum_e_sample = %g\n",   initrun.sum_e_sample)
	printf("Initrun.esample_var  = |%s|\n", initrun.esample_var)
	printf("Initrun.lrt_nok   = |%s|\n", initrun.lrt_nok)
	printf("------------------------------------------- Initrun END\n")
}

	/* ------------------------------------------------------------ */


struct `StrategyName' 
{
	`EvalMethodS'	method		// how to compare fits
	`boolean'	has_e_N		// <est_cmd> produces e(N)
	`boolean'	has_e_rank	// <est_cmd> produces e(rank)
	`boolean'	regress_like	
}
void StrategyInit(`StrategyS' s)
{
	s.method       = `EM_none'
	s.has_e_N      = `False'
	s.has_e_rank   = `False' 
	s.regress_like = `False'
}
void StrategyPrint(`StrategyS' s)
{
	printf("------------------------------------------ Strategy BEGIN\n")
	printf("s.method       = %g\n", s.method)
	printf("s.has_N        = %g\n", s.has_e_N)
	printf("s.has_e_rank   = %g\n", s.has_e_rank)
	printf("s.regress_like = %g\n", s.regress_like)
	printf("------------------------------------------ Strategy END\n")
}

/*
	Modeling of fits
*/

struct `ModelName'
{
	`EvalMethodS'	method		// how to cmp fits (copy from strategy)
	`RS'		N		// # of obs.
	`RS'		p_total		// actual total # parameters fit
	`RS'		p_ourcount	// # parameters for term (by our count)
	`RS'		p_actual  	// # parameters for term (actual)
	`RR'		fp		// fractional powers
					
					// used by method==`EM_ll':
	`RS'		ll		// log-likelihood value
	`RS'		rmse		// for linear regression model
	`RS'		krs		// for mixed models
}
void ModelInit(`ModelS' t, `EvalMethodS' method)
{
	t.method     = method 
	t.N          = 0 
	t.p_total    = 0
	t.p_ourcount = 0 
	t.p_actual   = 0 
	// t.fp does not need initialization 

	t.ll     = c("mindouble")
	t.rmse 	 = .
	t.krs	 = .
}
void ModelPrint(`ModelS' t)
{
	printf("--------------------------------------------- Model BEGIN\n")
	printf("t.method     = %g\n", t.method)
	printf("t.N          = %g\n", t.N) 
	printf("t.p_total    = %g\n", t.p_total)
	printf("t.p_ourcount = %g\n", t.p_ourcount)
	printf("t.p_actual   = %g\n", t.p_actual)
	printf("t.fp:")
	t.fp
	printf("t.ll         = %15.0g\n", t.ll) 
        printf("t.rmse       = %15.0g\n", t.rmse)
	printf("t.krs	     = %15.0g\n", t.krs)    
	printf("--------------------------------------------- Model END\n")
}

struct `SresultsName'
{
	`RS'		dim, n
	`SS'		bestmodel_name
	`SS'		store_bestmodel_cmd
	`SS'		restore_bestmodel_cmd

	`ModelS'	mbest
	`ModelC'	models

	`boolean'	has_linear	// include a linear model in 
					// models

	`SS'		compare_type	// "chi2" or "F"
	`RC'		compare_df1		
	`RS'		compare_df2
	
	`RC'		compare_stat
	`RC'		compare_pval
	`RC'		dev		// deviance of each model
	`RC'		dev_diff
	`RC'		rmse		// for F test, regression Res. SD
}

void SresultsInit(`SresultsS' sr, `RS' dim, `ModelS' m_null, 
	`EvalMethodS' method, `boolean' has_linear)
{
	`RS'	i
	sr.has_linear            = has_linear
	sr.n                     = (sr.dim = dim) + 1 + sr.has_linear
	sr.bestmodel_name        = st_tempname(1)
	sr.store_bestmodel_cmd   = "estimates store "   + sr.bestmodel_name 
	sr.restore_bestmodel_cmd = "estimates restore " + sr.bestmodel_name

	sr.mbest     = m_null
	sr.models    = `ModelName'(sr.n, 1)
	sr.models[1] = m_null 
	for (i=2; i<=sr.n; i++) {
		ModelInit(sr.models[i], method)
	}

	sr.compare_pval = sr.compare_stat = sr.dev = sr.dev_diff = sr.rmse = 
		 J(sr.n, 1, .)
	sr.compare_type = "" 	
	sr.compare_df1 = J(sr.n,1,.)
	sr.compare_df2 = .
}
void SresultsPrint(`SresultsS' sr)
{
	`RS'	i

	printf("------------------------------------------ Sresults BEGIN\n")
	printf("sr.compare_type = %s\n", sr.compare_type)
	"sr.compare_df1" ; sr.compare_df1'
	"sr.compare_df2" ; sr.compare_df2
        "sr.rmse" ; sr.rmse'

	"sr.compare_pval:" ; sr.compare_pval'
	"sr.compare_stat:"  ; sr.compare_stat'

	printf("sr.mbest:\n")
	ModelPrint(sr.mbest)

	for (i=1; i<=sr.n; i++) {
		printf("sr.models[%g]:\n", i)
		ModelPrint(sr.models[i])
	}
	printf("sr.has_linear = %g\n",sr.has_linear)
	printf("------------------------------------------ Sresults END\n")
}

/*
	Completion Meter
*/

struct `CMeterName'
{
	`RS'	nextpercent
	`RS'	N			/* total number to do 	*/
	`RS'	n			/* # done so far	*/
}
void CMeterInit(`CMeterS' cm, `RS' N)
{
	cm.nextpercent = 2 
	cm.n           = 0
	cm.N           = N
	printf("{txt}(")
	displayflush()
}
void CMeterUpdate(`CMeterS' cm)
{
	`RS'	complete

	complete = floor(((++cm.n)*100)/cm.N)

	if (complete < cm.nextpercent) return 

	while (complete >= cm.nextpercent) {
		if (floor(cm.nextpercent/10) == cm.nextpercent/10) {
			printf("%g%s", cm.nextpercent, "%")
		}
		else 	printf(".")
		displayflush() 
		cm.nextpercent = cm.nextpercent + 2 
	}
	if (complete == 100) printf(")\n") 
}
void CMeterBreak(`CMeterS' cm)
{
	if (cm.nextpercent < 100) printf("\n")
}
	



					/* Structures			*/
/* -------------------------------------------------------------------- */
 


/* -------------------------------------------------------------------- */
					/* main routine 		*/

/*
	fp ...: ...

	Inputs:
		fullcmdmac
			macro name containing full fp command.

		varstodrop_name
			macro name to be defined; 
			will be set to variable names that 
			might need dropping if this routine exits with error
		esttodrop_name
			macro name to be defined;
			will be set to -estimates store- name that 
			might need dropping if this routine exits with error
		<others>
			see below

	To call this routine from Stata, code

		capture noi fp_prefix_cmd("0", "varstodrop", "esttodrop" ...)
		if (_rc) {
			local rc = _rc
			-drop- each varname in `varstodrop' if var exists
			_estimates drop- `esttodrop' if not blank
			exit `rc' 
		}
*/


void fp_prefix_cmd(
            `SS'      fullcmdmac,
	    `SS'      varstodrop_name,	
	    `SS'      esttodrop_name,
	    `SS'      termname,		// name of <term> (without brackets)
	    `SS'      varname, 		// name of term variable
	    `SS'      est_cmd_name, 	// est. cmd with bracketed term(s)
	    `RS'      dimension, 	// option: -dimension(#)-
	    `SS'      fp, 		// option: -fp()-
	    `SS'      powers, 		// option: -powers()-
	    `RS'      s_a, `RS' s_b, 	// option: a and b from -scale[()]-
	    `RS'      c_mean,		// option: mean from -center[()]-
	    `boolean' iscenter,		// option: center option specified
					//         with mean c_mean
	    `boolean' isscale,		// option: scale option specified	
	    `boolean' iscompare,	// option: -compare-
	    `boolean' isdebug,		// option: -debug-
	    `boolean' islog,		// option: -log-
	    `boolean' isreplace,	// option: -replace-
	    `boolean' iszero,		// option: -zero-
	    `boolean' iscatzero,	// option: -catzero-
	    `boolean' isall,		// option: -all-
	    `SS'      est_di_opts	// option: display options
	)
{
	`SS'		gen_all_cmd
	`ProbS'		pr
	/* ------------------------------------------------------------ */
					/* load Prob structure		*/
	ProbInit(pr)
	pr.iscenter = iscenter
	pr.isscale = isscale

	pr.fullcmd         = st_local(fullcmdmac)
	pr.varstodrop_name = varstodrop_name
	pr.esttodrop_name  = esttodrop_name

	pr.est_cmd             = st_local(est_cmd_name)

	pr.el.elname           = termname
	pr.el.bracketed_elname = "<" + termname + ">"
	pr.el.v.name           = varname

					/* -powers()-, -dimension()-	*/
					/* or 				*/
					/* -fp()-			*/
	if (fp=="") {
		pr.el.todo      = `Todo_search'
		pr.el.dimension = dimension 
		pr.el.powers    = strtoreal(tokens(powers))
		pr.op.r.compare  = iscompare 
	}
	else {
		pr.el.todo      = `Todo_fp'
		pr.el.fp        = strtoreal(tokens(fp))
		pr.el.dimension = length(pr.el.fp)
	}
					
					/* option -scale[()]		*/
	pr.el.s.a = s_a 
	pr.el.s.b = s_b
	pr.el.s.auto = (s_a==.)
					/* option -center[()]		*/
	pr.el.c.mean = c_mean 
	pr.el.c.auto = (c_mean==.)

					/* other options		*/
	pr.op.debug      = isdebug 
	pr.op.log        = islog 
	pr.op.replace    = isreplace
	pr.op.zero       = iszero 
	pr.el.zero	 = iszero
	pr.op.catzero	 = iscatzero
	pr.op.all	 = isall	
					/* load structure		*/
	/* ------------------------------------------------------------ */

	/* ------------------------------------------------------------ */
					/* setup 			*/
	fp_consistency_check(pr)
	fp_setup_termnames(pr.el, pr.op.catzero)
	fp_create_v_name_mod(pr.el.v)
        fp_perform_initrun(pr.initrun, pr.est_cmd, pr.el)
        fp_replay_u(est_di_opts, pr.op.r,`True')
	if (pr.el.todo == `Todo_search') {
		fp_set_strategy(pr.strat, pr.initrun, pr.est_cmd) 
	}
	st_eclear() 

	fp_drop_existing_termvars(pr.op.replace, pr.el.elname)
	fp_add_termnames_to_varstodrop(pr.varstodrop_name, pr.el) 
					/* all variables we will drop 
					   have been dropped, so we 
					   can create Views
					*/
	fp_setup_v_V(pr.el.v, pr.initrun)
	fp_perform_scaling(pr.el.v.V_e, pr.el.s) 
	fp_setup_centering(pr.el.c, pr.el.v.V_e, pr.el.s, iscenter)
	fp_assert_v_name_mod_okay(pr.el)
	fp_create_termvars(	pr.el.term0name, pr.el.termnames, ///
				pr.el.dimension, "double") 
	fp_fix_v_name_mod_0orneg(pr.el, pr.initrun)
	fp_setup_Vterms(pr.el, pr.initrun)
	fp_setup_v_lnname_mod_and_lnV(pr.el, pr.initrun,`True')
	fp_setup_v_rname_mod_and_rV(pr.el, pr.initrun,`True')

	/* ------------------------------------------------------------ */
					/* perform estimation task	*/

	if (pr.el.todo == `Todo_fp') {
		xeq_fp(pr)	
		fp_set_common_ereturn(pr)
		fp_replay_u(est_di_opts, pr.op.r,`False')
	}
	else {
		xeq_search(pr)
		fp_set_common_ereturn(pr)
		fp_replay_u(est_di_opts, pr.op.r,`False')
	}

	if (pr.op.all) {
		// quietly overwrite estimation sample with fp_generate
		gen_all_cmd = st_global("e(fp_gen_cmdline)")
		if (strlen(gen_all_cmd) == ///
			strlen(subinstr(gen_all_cmd,",",""))) {
			gen_all_cmd = gen_all_cmd + ", replace"
		}
		else {
			gen_all_cmd = gen_all_cmd + " replace"
		}
	        stata_must_run("fp:", gen_all_cmd, `False',"")		
	}
	/* ------------------------------------------------------------ */
}

// used to support fp generate main command
void fp_generate(
	    `SS'      stypename,
	    `SS'      termname,
            `SS'      varstodrop_name,
            `SS'      varname,          // name of term variable
            `SS'      fp,               // option: -fp()-
            `RS'      s_a, `RS' s_b,    // option: a and b from -scale[()]-
            `RS'      c_mean,           // option: mean from -center[()]-
            `boolean' iscenter,         // option: center option specified
                                        //         with mean c_mean
            `boolean' isscale,          // option: scale option specified
	    `boolean' isreplace,	// option: replace
	    `boolean' iszero,		// option: zero
            `boolean' iscatzero,        // option: -catzero-
	    `SS'      touse,	
	    `SS'      full_cmd		// fp generate command used
        )
{

        `ProbS'         pr
        /* ------------------------------------------------------------ */
                                        /* load Prob structure          */	
        ProbInit(pr)
        pr.iscenter = iscenter
        pr.isscale = isscale

        pr.varstodrop_name = varstodrop_name

	pr.el.elname           = termname
	pr.el.v.name           = varname

					/* -powers()-, -dimension()-	*/
					/* or 				*/
					/* -fp()-			*/

        pr.el.todo      = `Todo_fp'
        pr.el.fp        = strtoreal(tokens(fp))
        pr.el.dimension = length(pr.el.fp)

	pr.initrun.hasrun      = `True'
	pr.initrun.esample_var = touse
                                        /* option -scale[()]            */
        pr.el.s.a = s_a
        pr.el.s.b = s_b
        pr.el.s.auto = (s_a==.)
                                        /* option -center[()]           */
        pr.el.c.mean = c_mean
        pr.el.c.auto = (c_mean==.)

					/* other options		*/

        pr.op.replace    = isreplace
	pr.op.zero	 = iszero
        pr.el.zero       = iszero
        pr.op.catzero    = iscatzero

					/* load structure		*/
	/* ------------------------------------------------------------ */

	/* ------------------------------------------------------------ */
					/* setup 			*/

	fp_setup_termnames(pr.el, pr.op.catzero)
	fp_create_v_name_mod(pr.el.v)
        fp_drop_existing_termvars(pr.op.replace, pr.el.elname)
	fp_add_termnames_to_varstodrop(pr.varstodrop_name, pr.el) 

					/* all variables we will drop 
					   have been dropped, so we 
					   can create Views
					*/
        fp_setup_v_V(pr.el.v, pr.initrun)
        fp_perform_scaling(pr.el.v.V_e, pr.el.s)
        fp_setup_centering(pr.el.c, pr.el.v.V_e, pr.el.s, iscenter)
        fp_assert_v_name_mod_okay(pr.el)
        fp_create_termvars(	pr.el.term0name, pr.el.termnames, ///
				pr.el.dimension, stypename)
        fp_fix_v_name_mod_0orneg(pr.el, pr.initrun)

        fp_setup_Vterms(pr.el, pr.initrun)
        fp_setup_v_lnname_mod_and_lnV(pr.el, pr.initrun,`True')
        fp_setup_v_rname_mod_and_rV(pr.el, pr.initrun,`True')
        fill_in_fracpoly(pr.el.Vterms, pr.el.v, pr.el.fp, pr.el.c.mean)
	
        label_terms(pr.el.term0name, pr.el.termnames,
                        pr.el.v.name, pr.el.s, pr.el.c, pr.op, pr.el.fp,
                        full_cmd, pr.iscenter, pr.isscale, stypename)
	fp_set_rreturn(pr,full_cmd)
}




					/* main routine 		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* setup routines		*/

/*
	fp_set_rreturn(pr)
                        macro  r(fp_cmd)        <- set last
                        macro  r(fp_cmdline)           
                        macro  r(fp_variable)
                        macro  r(fp_zero)
                        macro  r(fp_catzero)
                        scalar r(fp_scale_a)
                        scalar r(fp_scale_b)
                        scalar r(fp_center_mean)
                        matrix r(fp_fp) 
*/
void fp_set_rreturn(`ProbS' pr, `SS' cmdline)
{
	/* ------------------------------------------------------------ */
					/* r(fp_fp)			*/
	st_mysetmatrix("r(fp_fp)", pr.el.fp,
				   "fp", 
				   pr.el.termnames[|1\length(pr.el.fp)|])
	/* ------------------------------------------------------------ */
					/* r(fp_cmdline)		*/
                                        /* e(fp_variable)               */
	st_global("r(fp_cmdline)",cmdline)
        st_global(  "r(fp_variable)",     pr.el.v.name)
        /* ------------------------------------------------------------ */
					/* r(fp_center_mean)		*/
					/* r(fp_scale_b)		*/
					/* r(fp_scale_a)		*/

	st_numscalar("r(fp_center_mean)", pr.el.c.mean)
	st_numscalar("r(fp_scale_b)",     pr.el.s.b)
	st_numscalar("r(fp_scale_a)",     pr.el.s.a)
	/* ------------------------------------------------------------ */

	/* ------------------------------------------------------------ */
					/* r(fp_catzero)		*/
					/* r(fp_zero)			*/
	if (pr.op.catzero) {
		st_global("r(fp_catzero)", "catzero")
	}
	if (pr.op.zero) {
		st_global("r(fp_zero)", "zero")
	}

	/* ------------------------------------------------------------ */
					/* r(fp_variable)		*/
	st_global(  "r(fp_variable)",     pr.el.v.name)
        /* ------------------------------------------------------------ */
	st_global("r(fp_terms)",
		strtrim(invtokens((pr.el.term0name,pr.el.termnames))))

}


/*
	fp_set_common_ereturn(pr)
			      --
		Sets
			macro  e(fp_cmd)	<- set last
			macro  e(fp_cmdline)
			macro  e(fp_terms)
			macro  e(fp_variable)
			macro  e(fp_gen_cmdline)
			macro  e(fp_zero)
			macro  e(fp_catzero)
			scalar e(fp_scale_a)
			scalar e(fp_scale_b)
			scalar e(fp_center_mean)
			matrix e(fp_fp)	
		
		Note that common ereturn does not mean contents are 
		the same, merely that names are the same.
*/

void fp_set_common_ereturn(`ProbS' pr)
{
	/* ------------------------------------------------------------ */
					/* e(fp_fp)			*/
	st_mysetmatrix("e(fp_fp)", pr.el.fp,
				   "fp", 
				   pr.el.termnames[|1\length(pr.el.fp)|])

	/* ------------------------------------------------------------ */
					/* e(fp_center_mean)		*/
					/* e(fp_scale_b)		*/
					/* e(fp_scale_a)		*/

	st_numscalar("e(fp_center_mean)", pr.el.c.mean)
	st_numscalar("e(fp_scale_b)",     pr.el.s.b)
	st_numscalar("e(fp_scale_a)",     pr.el.s.a)
	/* ------------------------------------------------------------ */

	/* ------------------------------------------------------------ */
					/* e(fp_catzero)		*/
					/* e(fp_zero)			*/
	if (pr.op.catzero) {
		st_global("e(fp_catzero)", "catzero")
	}
	if (pr.op.zero) {
		st_global("e(fp_zero)", "zero")
	}

	/* ------------------------------------------------------------ */
					/* e(fp_gen_cmdline)		*/

	st_global("e(fp_gen_cmdline)",  
		   make_fp_gen_cmd(pr.el.v.name, pr.el.fp, pr.el.s, pr.el.c, 
					         pr.op, "double")
		 )

	/* ------------------------------------------------------------ */
					/* e(fp_terms)			*/
	st_global("e(fp_terms)",
		strtrim(invtokens((pr.el.term0name,pr.el.termnames))))

	/* ------------------------------------------------------------ */
					/* e(fp_variable)		*/
					/* e(fp_cmdline)		*/


	st_global(  "e(fp_variable)",     pr.el.v.name)
	st_global(   "e(fp_cmdline)",     pr.fullcmd)

	/* ------------------------------------------------------------ */
					/* sign results			*/

	if (pr.el.todo == `Todo_fp') {
		st_global("e(fp_cmd)", "fp, powers():")
	}
	else {
		st_global("e(fp_cmd)", "fp, search():")
	}

	/* ------------------------------------------------------------ */
}


void fp_replay(`SS' estcmd_options, `boolean' compare)
{
	`RopsS'		ro

	RopsInit(ro)
	ro.compare = compare 

	fp_replay_u(estcmd_options, ro,`False')
}

	
void fp_replay_u(`SS' estcmd_options, `RopsS' r, `boolean' initrun)
{
	`RS'	rc
	`SS'	cmd

	if (!initrun & r.compare) {
		printf("{txt}\n")
		fp_replay_compare()
	}

	cmd = st_global("e(cmd2)") 
	if (cmd == "") {
		cmd = st_global("e(cmd)")
	}
	if (initrun) {
		cmd = "qui " + cmd
	}
	if (estcmd_options != "") cmd = cmd + ", " + estcmd_options
	if ((rc = _stata(cmd))) { 
		exit(rc) 
		/*NOTREACHED*/
	}
}


void fp_replay_compare()
{
	`RS'		i, cmiss
	`RM'		table, pws
	`RS'		ddof
	`boolean'	hasess
	`RS'		df, dev, devdif, pvals, ess
	`RS'		max
	`RC'		L
	`SS'		devfmt, devdiffmt, essfmt, ctest

	/* ------------------------------------------------------------ */
				/* load e() results			*/


	pws    = st_matrix("e(fp_compare_fp)")

	table  = st_matrix("e(fp_compare)")
	df     = 1
	dev    = 2
	devdif = 3
	pvals  = 4
	ess    = 5

	L      = st_matrix("e(fp_compare_length)")

	ddof   = st_numscalar("e(fp_compare_df2)")
	hasess = (ddof < .)

	/* ------------------------------------------------------------ */
				/* establish display formats		*/
			
	max = colmax(abs(table[., dev]))
	if (max < 10^4)      devfmt      = "%10.3f"
	else if (max < 10^6) devfmt = "%10.2f"
	else if (max < 10^8) devfmt = "%10.0f"
	else                 devfmt = "%10.0g"

	max = colmax(abs(table[., devdif]))
	if (max < 10^4)      devdiffmt = "%10.3f"
	else if (max < 10^6) devdiffmt = "%10.2f"
	else if (max < 10^8) devdiffmt = "%10.0f"
	else                 devdiffmt = "%10.0g"

	if (ddof<.) {
		max = colmax(abs(table[., ess]))
		if (max < 10^4)      essfmt = "%10.3f"
		else if (max < 10^6) essfmt = "%10.2f"
		else if (max < 10^8) essfmt = "%10.0f"
		else                 essfmt = "%10.0g"
	}


	/* ------------------------------------------------------------ */
				/* output table				*/

	printf("{txt}Fractional polynomial comparisons:\n")
	print_divider("{c TT}", hasess)
	printf("%12uds {c |}", abbrev(st_global("e(fp_variable)"), 12))
	printf("   df    Deviance")
	if (hasess) {
		printf("  Res. s.d.")
	}
	printf("   Dev. dif.   P(*)   Powers\n")
	print_divider("{c +}", hasess)
	

	for (i=1; i<=rows(table); i++) {
		printf("%12uds {c |}{res:%5.0f %10uds}", 
			leftstub(L[i]),
			table[i, df], 
			sprintf(devfmt, table[i, dev])
		      )
		if (hasess) {
			printf("{res: %10uds}", sprintf(essfmt, table[i, ess]))
		}
		printf("{res: %10uds %8uds   %-12uds}\n", 
			double_dash(devdiffmt, 
				table[i, devdif],0,i,rows(table)), 
			double_dash("%8.3f",  
				table[i, pvals],1,i,rows(table)), 
			fp_replay_compare_powers(pws[i,])
			)
	}
		
	print_divider("{c BT}", hasess)

	//if lrt test works 
	if ((st_global("e(lrt_nok)") == "") || hasess) {
		printf("{p 0 4 10}\n")
		printf("(*) P = sig. level of model with %s\n", 
			leftstub(L[rows(table)]))
		printf("based on\n") 
		if (!hasess) {
			printf("chi^2 of dev. dif.\n")
		}
		else {
			printf("F with\n")
			printf("%f denominator dof.\n", ddof)
		}
		printf("{p_end}\n")
		cmiss = missing(table[1..(rows(table)-1),pvals])
		ctest = (cmiss > 1 ? "tests" : "test")
	
		if (cmiss > 0) {
			printf("{p 0 4 10}\n") 
			printf("Model comparison ")
			printf(ctest) 
			printf(" {bf:xx} could not ")
			printf("be performed.")
			if (sum(table[1..(rows(table)-1),1]:<= ///
				table[rows(table),1])>0) {
				printf("  The VCE of model with %s", ///
					leftstub(L[rows(table)]))
				printf(" is not of sufficient rank ")
				printf("to perform ")
				if ("tests" == ctest) {
					printf("one or more of ")
				}
				printf(ctest)
				printf(" {bf:xx}.")
			}
			if (st_numscalar("e(fp_scale_b)")==1) {
				printf("  This is due to numerical ")
				printf("instability.  Try specifying ")
				printf("{bf:scale}.{p_end}\n")
			}		
		}
	}
	else {
                printf("{p 0 4 10}\n")
                printf("(*) deviance difference test not valid with ")
		printf(st_global("e(lrt_nok)"))
		printf("{p_end}\n")
	}
}

void print_divider(`SS' Tchar, `boolean' hasess)
{
	printf("{txt}%s%s", 13*"{c -}", Tchar)
	printf("%s\n", (hasess ? 65 : 54)*"{c -}")
}


`SS' leftstub(`RS' len_code)
{
	if (len_code==0) 		return("omitted") 
	else if (len_code==(-1))	return("linear")
	else				return(sprintf("m = %g", len_code))
	/*NOTREACHED*/
}
	

`SS' double_dash(`SS' fmt, `RS' v, `RS' p, `RS' i, `RS' n)
{
	if (!p | (i==n)) {
		return(v>=. ? "--" : sprintf(fmt, v))
	}
	else if (p & st_global("e(lrt_nok)") == "") {
		return(v>=. ? "xx" : sprintf(fmt, v))
	}
	else if (p) {
		return(v>=. ? "--" : sprintf(fmt, v))
	}	
}

`SS' fp_replay_compare_powers(`RR' p)
{
	`RS'	i
	`SS'	result
	
	result = ""
	for (i=1; i<=length(p); i++) {
		if (p[i]>=.) return(result)
		result = (result=="" ? "" : result+" ") + sprintf("%f", p[i])
	}
	return(result)
}

void fp_consistency_check(`ProbS' pr)
{
	if (strpos(pr.est_cmd, pr.el.bracketed_elname)==0) {
		error_est_cmd(pr.el.bracketed_elname)
		/*NOTREACHED*/
	}
}

/*
	fp_assert_v_name_mod_okay(el)
				  --
*/

void fp_assert_v_name_mod_okay(`ElementS' el)
{
	if ((el.term0name=="") & !el.zero) {
		if (colsum(el.v.V_e:<=0)) {
			error_V_contains_0orneg(el.v.name)
			/*NOTREACHED*/
		}
	}
}

/*			         __
	fp_fix_v_name_mod_0orneg(el, ir)
				 --  --

*/

void fp_fix_v_name_mod_0orneg(`ElementS' el, `InitrunS' ir)
{
	if ((el.term0name=="") & !el.zero) return 

	if (el.term0name!="") {
		/* replace term0name = (v.name_mod <= 0) if esample_var */
		stata_must_run("fp:", 
			sprintf("replace %s = (%s<=0) if %s", 
					el.term0name, el.v.name_mod, 
					ir.esample_var), `True', "")
	}

		/* replace v.name_mod = 0 if v.name_mod<0 & esample_var */
	stata_must_run("fp:", 
			sprintf("replace %s = 0 if %s<=0 & %s", 
				el.v.name_mod, el.v.name_mod, 
				ir.esample_var), `True', "")
}

/*
	fp_create_v_name_mod(pr)

	Create temporary variable containing duplicate of 
	fractional polynomial variable.
*/

void fp_create_v_name_mod(`FPvarS' v)
{
	(void) st_addvar("double", v.name_mod) 
	(void) st_nvar()
/*
        Fri May 24 09:34:12 CDT 2013
Why (void) st_nvar()?
        Answer:  So that e(sample) is moved to the end of the
                 data.  If e(sample) exists, the st_addvar() above
                 added the variable after e(sample).
                 Someday we should change the internal code so
                 that st_addvar() moves e(sample) to the end.
*/
	st_store(., v.name_mod, st_data(., v.name))
}

/*			   __
	fp_setup_termnames(el, op_catzero)
			   --  ----------

	Create variable names for containing terms. 
	These names are stored in el.termnames[], 
	and in el.term0name if op_catzero).
	The variables themselves are not created.
*/

void fp_setup_termnames(`ElementS' el, `boolean' op_catzero) 
{
	el.termnames = fp_make_termnames(el.elname, 
				(el.todo==`Todo_fp' ?
					length(el.fp) : el.dimension)    )
	if (op_catzero) {
		el.term0name = fp_make_termname(el.elname, 0)
	}
}


/*
	(void) fp_add_termnames_to_varstodrop(macro_name, el)
					      ----------  --

	Add to Stata local macro_name the termnames that will be 
	created.
*/

void fp_add_termnames_to_varstodrop(`SS' macro_name, `ElementS' el)
{
	`RS'	i

	if (el.term0name!="") {
		add_var_to_drop(macro_name, el.term0name)
	}
	for (i=1; i<=length(el.termnames); i++) {
		add_var_to_drop(macro_name, el.termnames[i])
	}
}


	
/*	 
	s = fp_make_termnames_u(basename, n)
			        --------  -

	Return n names for term based on basename. 
*/


`SR' fp_make_termnames(`SS' basename, `RS' n)
{
	`RS'	i
	`SR'	result
	result = J(1, n, "") 
	for (i=1; i<=n; i++) result[i] = fp_make_termname(basename, i)
	return(result)
}

`SS' fp_make_termname(`SS' basename, `RS' i)
{
	`RS'	l_basename, l_diff
	`SS'	result 
	`SS'	suffix

	l_basename = ustrlen(basename)
	result = ""
	suffix = sprintf("_%f", i)
	l_diff = `MaxNameLen' - (l_basename+bstrlen(suffix))
	result =       (
			    l_diff <= 0 ? 
			    usubstr(basename, 1, `MaxNameLen'+l_diff): basename
			) + suffix
	return(result)
}



/*
	(void) fp_drop_existing_termvars(replace, elname)
				         -------  ------

	Check whether termnames (and term0name) exist in data.
	If so, drop them (replace==`True') or issue error message.
*/

void fp_drop_existing_termvars(`boolean' replace, `SS' elname)
{
	`RS'	i
	`SR'	names, todrop

	names = (fp_make_termname(elname, 0), 
			fp_make_termnames(elname, `MaxTerms'))

	todrop = J(1, 0, "")
	for (i=1; i<=length(names); i++) {
		if (_st_varindex(names[i], 0)!=.) todrop = (todrop, names[i])
	}
	if (length(todrop)==0) return

	if (replace) {
		for (i=1; i<=length(todrop); i++) st_dropvar(todrop[i])
	}
	else {
		error_varnames_exist(todrop, `True')
		/*NOTREACHED*/
	}
}


/*
	(void) fp_create_termvars(basename, names, n, stype)
				  --------  -----  -  -----

	Create double term variable basename if basename!=""
	and create term variables names[].
*/


void fp_create_termvars(`SS' basename, `SR' names, `RS' n,stype)
{
	`RS'	i

	if (basename!="") (void) st_addvar("byte", basename)

	for (i=1; i<=n; i++) (void) st_addvar(stype, names[i])
}


/* 		__
	fp_setup_Vterms(el, ir)
			--  --

	Setup pr.el.Vterms to be a view onto pr.el.termnames
*/

void fp_setup_Vterms(`ElementS' el, `InitrunS' ir)
{
	if (ir.hasrun) st_view(el.Vterms, ., el.termnames, ir.esample_var)
	else           st_view(el.Vterms, ., el.termnames)
}


/*		     _
	fp_setup_v_V(v, ir)
		     -  --

	Create view (FPvar) v.V onto el.v.name_mod.
*/
	

void fp_setup_v_V(`FPvarS' v, `InitrunS' ir)
{
	if (ir.hasrun) st_view(v.V_e, ., v.name_mod, ir.esample_var)
	else 	       st_view(v.V_e, ., v.name_mod)
}


/*				      __
	fp_setup_v_lnname_mod_and_lnV(el, ir)
				      --  --

	Creates double variable el.v.lnname_mod and creates view onto it
	lnV_e. Fills lnV_e in with ln(V_e); in obs where ln(V_e)[]==., 
	lnV_e[]=0.
*/

void fp_setup_v_lnname_mod_and_lnV(`ElementS' el, `InitrunS' ir, /*
				   */ `boolean' first) 
{
	`RM'				mylnV
	pointer(`FPvarS') scalar	v

	v = &(el.v)			// synonym 

	if (first) {
		(void) st_addvar("double", el.v.lnname_mod) 
	}
	
	if (ir.hasrun) st_view(v->lnV_e, ., v->lnname_mod, ir.esample_var)
	else 	       st_view(v->lnV_e, ., v->lnname_mod)

	if ((el.term0name!="") | (el.zero == `True')) {
		mylnV = ln(v->V_e) 
		_editmissing(mylnV, 0) 
		v->lnV_e[,.] = mylnV
	}
	else {
		v->lnV_e[,.] = ln(v->V_e)
	}
}


void fp_setup_v_rname_mod_and_rV(`ElementS' el, `InitrunS' ir, /*
				*/ `boolean' first)
{
	`RM'	myrV
	
	if (first) {
		(void) st_addvar("double", el.v.rname_mod) 
	}
	
	if (ir.hasrun) st_view(el.v.rV_e, ., el.v.rname_mod, ir.esample_var)
	else 	       st_view(el.v.rV_e, ., el.v.rname_mod)

	if ((el.term0name!="") | (el.zero == `True')) {
		myrV = (el.v.V_e):^(-1) 
		_editmissing(myrV, 0) 
		el.v.rV_e[,.] = myrV
	}
	else {
		el.v.rV_e[,.] = (el.v.V_e):^(-1)
	}
}


void fp_setup_views(`ElementS' el, `InitrunS' ir)
{
	fp_setup_v_V(el.v,ir)
	fp_setup_Vterms(el,ir)
	fp_setup_v_rname_mod_and_rV(el,ir,`False')
	fp_setup_v_lnname_mod_and_lnV(el,ir,`False') 
}
	

/*			        _	    _
	fp_perform_scaling(`RC' V, `ScaleS' s)
				-           -

	    1.  Define s.a and s.b if s.auto
		It is assumed that V represents e(sample).

	    2.  Perform scaling on matrix V if required 
	        (if s.auto or user-specified values s.a and s.b).  
                If auto scaling is performed, it is assumed 
*/

void fp_perform_scaling(`RC' /*view okay*/ V, `ScaleS' s)
{
	`RC'	lrange

	if (s.auto) {
		V[.]   = V :+ (s.a  = getadjustment(V))
		lrange = log10(colmax(V) - colmin(V))
		s.b    = 10^(sign(lrange)*floor(abs(lrange)))
		V[.]   = V / s.b
	}
	else if (!(s.a==0 & s.b==1)) {
		V[.] = (V :+ s.a) / s.b
	}
}

`RS' getadjustment(`RC' /*view okay*/ V)
{
	`RS'	min, delta, n 
	`RC'	U

	min = colmin(V)

	U = uniqrows(V)
	n = length(U)
	delta = colmin( U[|2\n|] - U[|1\(n-1)|] )

	return((min <= 0 ? delta - min : 0))
}

/*			             -
	fp_setup_centering(`CenterS' c, `RC' V, `ScaleS' s, `boolean' iscenter)
			             -       _           _  

	Perform setup for centering:  
	if c.auto, record mean of V.
	Otherwise, if 	scale is specified or automatic, and 
			centering is specified, 
		adjust center based on scaling information
	It is assumed that V is a view onto the subset of observations in 
	e(sample).
*/

void fp_setup_centering(`CenterS' c, 
			`RC' /*view okay*/ V, 
			`ScaleS' s, 
			`boolean' iscenter) 
{
	if (c.auto) c.mean = mean(V:*(V:>=0))*length(V)/sum(V:>=0)
	else if (iscenter) {
		c.mean = (c.mean + s.a)/(s.b)
	}
}


/* -------------------------------------------------------------------- */

					

/* -------------------------------------------------------------------- */
					/* initrun			*/

/*			   __
	fp_perform_initrun(ir, est_cmd, el)
			   --  -------  --

	Perform initial estimation of model using the 
	fractional polynomial variable in original, as-is form.
*/


void fp_perform_initrun(`InitrunS' ir, `SS' est_cmd, `ElementS' el)
{
	`SS'		cmd
	`SS'		cmdname
	`RC'		esamp
	`SS'		vcetype
	`SS'		clustvar
	cmd = est_cmd
	substitute_elname(cmd, el.bracketed_elname, el.v.name)
	st_eclear()
	stata_must_run("fp:", cmd, `True',"") 
	cmdname = st_global("e(cmd2)")
	if (cmdname=="") {
		cmdname = st_global("e(cmd)")
		if(cmdname=="") {
			error_not_eclass(cmd)
			/*NOTREACHED*/
		}
	}
	if (st_matrix("e(V)")==J(0,0,.)) {
		errprintf("{p 0 0 2}\n")
		errprintf("estimation command {bf: ") 
		errprintf(cmdname)
		errprintf("} did not set {bf:e(V)}\n") 
		errprintf("{p_end}")
		exit(498)
	}

	vcetype = st_global("e(vcetype)")
        if (vcetype=="Jackknife") {
                stata("capture noi error_cmd_notallowed jackknife pre")
                exit(190)
        }
	if (vcetype=="Bootstrap") {
		stata("capture noi error_cmd_notallowed bootstrap pre")
		exit(190)
	}
	if (st_numscalar("e(ll)") == J(0,0,.)) {
		errprintf("{bf:e(ll)} not reported by "+cmd+"\n")
		exit(498)
	}
	if (st_global("e(clustvar)")!= "" & st_global("e(vce)")!="robust") {
		clustvar = st_global("e(clustvar)")
		ir.lrt_nok = " cluster("+clustvar+")"
	}	
	else if (vcetype=="Robust") {
		ir.lrt_nok = " robust variance estimation"
	}
	else if (st_global("e(crittype)") == "log pseudolikelihood") {
		ir.lrt_nok = " log pseudolikelihoods"
	}
	else if (st_global("e(wtype)")=="pweight") {
		ir.lrt_nok = " pweighted estimators"
	}


	stata_must_run("fp:", sprintf("generate byte %s = e(sample)", 
						ir.esample_var), `True', "")
	ir.e_N = st_numscalar("e(N)")
	pragma unset esamp 
	st_view(esamp, ., ir.esample_var)
	ir.sum_e_sample = colsum(esamp)
	ir.hasrun       = `True'
}

/*			_
	fp_set_strategy(s, ir, est_cmd)
			   --  -------
*/

void fp_set_strategy(`StrategyS' s, `InitrunS' ir, `SS' est_cmd)
{
	s.has_e_N      = (ir.e_N != .)
	s.has_e_rank   = (st_numscalar("e(rank)")!=J(0,0,.))
	s.regress_like = (st_numscalar("e(rmse)")!=J(0,0,.))
	if (st_numscalar("e(ll)")!=J(0,0,.)) s.method = `EM_ll'
	else {
		s.method = `EM_none'
		error_no_strategy(est_cmd)
		/*NOTREACHED*/
	}
}
		
					/* initrun			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* enumerating powers		*/

/*
How to use penum

	
	"BEGIN"
	PenumInit((prob.elptr[1])->penum, *(prob.elptr[1]))
	n = 0 
	while (penum_next(fp, (prob.elptr[1])->penum)==0) { 
			fp
			n = n + 1
	}
	n


	PenumInit((prob.elptr[1])->penum, *(prob.elptr[1]))
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
	(void) penum_next(fp, (prob.elptr[1])->penum) ; fp
*/

/*		  __
	PenumInit(pe, e)
		      -
	    Initializes pe for enumeration of Element e

		  _____              __  --
	(boolean) carry = penum_next(fp, pe)
					 --

	    Set `RR' fp to contain next power set. 
	    Returns:
		carry == `False' fp filled in and is a new power set
		      == `True'  if wrapped; pe is re-initialized to 
                                 do it all over again, and fp is
				 filled in with the first powerset.
*/


struct `PenumName'
{
	`Todo'	todo
	`RR'	powers
	`RR'	idx
	`RS'	dimension
}

void PenumInit(`PenumS' pe, `ElementS' e)
{
	pe.todo = e.todo 
	if (pe.todo == `Todo_fp') {
		pe.powers = e.fp		 
	}
	else {
		pe.powers    = e.powers		 
		pe.idx       = (0)
		pe.dimension = e.dimension
	}
}


`boolean' penum_next(`RR' fp, `PenumS' pe)
{
	if (pe.todo == `Todo_fp') {
		fp = pe.powers 
		return(`True')		/* carry */
	}
	return( penum_next_u(fp, pe, length(pe.idx)) )
}


`boolean' penum_next_u(`RR' fp, `PenumS' pe, `RS' pos)
{
	`RS'	i

	/* ------------------------------------------------------------ */
				/* add to term pos if we can        	*/
				/* and reset those to the right of us	*/
				/* if any				*/

	if (pe.idx[pos] < length(pe.powers)) {
		pe.idx[pos] = pe.idx[pos] + 1
		for (i=pos+1; i<=length(pe.idx); i++) pe.idx[i] = pe.idx[pos]
		fp = pe.powers[pe.idx]
		return(`False') 		/* no carry */
	}

	/* ------------------------------------------------------------ */
				/* back up a position 			*/

	if (pos-1 >= 1) return(penum_next_u(fp, pe, pos-1))

	/* ------------------------------------------------------------ */
				/* we can't add to term pos       	*/
				/* so we carry and let the carry 	*/
				/* operation handle the resetting of us	*/


	if (length(pe.idx) == pe.dimension) { 	/* we cannot carry ...  */
		pe.idx       = 0		
		(void) penum_next(fp, pe)
		return(`True')
	}

					/* we can carry			*/
	pe.idx = (0, pe.idx)
	return( penum_next_u(fp, pe, 1) )
}
					/* enumerating powers		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* utilities			*/

/*		         ______
	fill_in_fracpoly(Vterms, v, powers, c)
		                 -  ------  -

	Variables:
		Vterms		N x maxterms, terms to be filled in
		v.V_e		N x 1, value of fracpoly variable 
		v.lnV_e		N x 1, ln(V)_e (for speed)
		v.rV_e		N x 1, (V)_e^-1 (for zero)
		powers		1 x k, k = current # of powers <= maxterms
		c     		1 x 1 containing centering value or missing

	fill in Vterms[.,1], ..., Vterms[,.length(powers)] with V^(powers) 
	optionally allowing centering.  It is caller's responsibility 
	to supply lnV.  This is to speed execution on repeated calls.

	Vterms,_e V,_e and lnV _emay each be regular or View matrices.
*/


void fill_in_fracpoly(`RM' Vterms, 
		      `FPvarS' v,
		      `RR' powers, 
		      `RS' c)
{
	`RS'	i, lastp, basei, rep
	`RS'	p
	lastp = basei = rep = .
	if (c>=. | c==0) {		/* no centering			*/
		for (i=1; i<=length(powers); i++) { 
			if ( (p=powers[i]) != lastp) {
				rep        = 0 
				basei      = i 
				Vterms[,i] = genl_power(v, p, 0)
			}
			else 	{
				Vterms[,i] = Vterms[,basei] :* v.lnV_e:^(++rep)
			}
			lastp = p
		}
	}
	else {				/* centering			*/
		for (i=1; i<=length(powers); i++) {
			if ( (p=powers[i]) != lastp) {
				rep        = 0 
				basei      = i 
				Vterms[,i] = genl_power(v, p, c)
			}
			else {
				Vterms[,i] =((
					genl_power(
					v, p, 0) :* v.lnV_e:^(++rep)) 
					:- 
					((p ? c^p : ln(c))*(ln(c)^(rep)))
					)
			}
			lastp = p
		}
	}
}

`RM' genl_power(`FPvarS' v, `RS' p, `RS' c)
{
	if (c==0) {
		if (p>0) 	return(v.V_e:^p)
		if (p==0) 	return(v.lnV_e)
				return(v.rV_e :^ (-p))
	}
	else {
		if (p>0) 	return(v.V_e:^p :- c^p)
		if (p==0) 	return(v.lnV_e  :- ln(c))
				return(v.rV_e   :^ (-p) :- c^p)
	}
}

/* -------------------------------------------------------------------- */
					/* xeq_fp			*/
void xeq_fp(`ProbS' pr)
{
	`SS' cmd

	fill_in_fracpoly(pr.el.Vterms, pr.el.v, pr.el.fp, pr.el.c.mean)
	cmd = get_est_cmd(pr, pr.el.termnames) ; 

	printf("{p 0 3 2}\n")
	printf("{txt}-> {bf}%s{rm}\n", cmd)
	printf("{p_end}\n")
	stata_must_run("fp:", cmd, `True',"")
	label_terms(pr.el.term0name, pr.el.termnames, 
			pr.el.v.name, pr.el.s, pr.el.c, pr.op, pr.el.fp, 
			pr.fullcmd, pr.iscenter, pr.isscale,"double")
}

					/* xeq_fp()			*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* xeq_search()			*/

/*		   __
	xeq_search(pr)
		   --

	Search for best model.  
	This routine produces no output except for notes that normally 
	appear during the search process, and of course, error messages.

	This routine sets:

		current estimation model in memory to be best model

		various e() values

		pr.el.fp set to contain corresponding powers (to be stored in 
		e() by caller)
*/

	

void xeq_search(`ProbS' pr)
{
	`RS'		N_runs, n_run, i
	`CMeterS'	cm
	`ModelS' 	m_null, m
	`SresultsS'	sr
	`PenumS'	pen
	`RR'		p

	ModelInit(m_null, pr.strat.method) 
	fit_null_model(m_null, pr)
	SresultsInit(sr, pr.el.dimension, m_null, pr.strat.method, 
				has_linear_power(pr.el.powers)) 
	st_local(pr.esttodrop_name, sr.bestmodel_name)

		
	/* ------------------------------------------------------------ */
					/* count # of models		*/
	pragma unset p
	PenumInit(pen, pr.el) 
	for (N_runs=0; !penum_next(p, pen); N_runs++) ;
	printf("{txt}(fitting %g models)\n", N_runs)
	CMeterInit(cm, N_runs)
	

	/* ------------------------------------------------------------ */
					/* search			*/
	
	PenumInit(pen, pr.el) 
	ModelInit(m, pr.strat.method) 
	for (n_run=0; !penum_next(p, pen); n_run++) {
		fp_setup_views(pr.el,pr.initrun)
		fit_a_model(m, pr, p, m_null.p_total) 
		CMeterUpdate(cm)
		SresultsUpdate(sr, m, pr, p)
	}
	CMeterBreak(cm)
	// fill out lrt_nok if sd. parameters changed for mixed models
	if (sr.mbest.krs != .) {
		for(i=1; i <= sr.n;i++) {
			if (sr.mbest.krs != sr.models[i].krs) {
				pr.initrun.lrt_nok = ///
" null hypotheses on the boundary of the parameter space." + ///
"  The number of variance parameters differ between the compared models," + ///
" with the differing parameters set to zero in the null hypothesis." 
			}
		}
	}


	SresultsFinish(sr, pr.strat.regress_like,pr.initrun.lrt_nok)
	pr.el.fp = sr.mbest.fp
	fp_setup_views(pr.el,pr.initrun)
    fill_in_fracpoly(pr.el.Vterms, pr.el.v, pr.el.fp, pr.el.c.mean)
	
	/* ------------------------------------------------------------ */


	/* ------------------------------------------------------------ */
					/* post specific e() results	*/

	search_post_eresults(pr, sr)
	
	label_terms(pr.el.term0name, pr.el.termnames, 
			pr.el.v.name, pr.el.s, pr.el.c, pr.op, pr.el.fp, 
			pr.fullcmd, pr.iscenter,pr.isscale, "double")

	/* ------------------------------------------------------------ */
}

					/* xeq_search()			*/
/* -------------------------------------------------------------------- */

`boolean' has_linear_power(`RR' powers)
{
	`RS'	i

	for (i=1; i<=length(powers); i++) {
		if (powers[i] == 1) return(`True')
	}
	return(`False')
}
	
void search_post_eresults(`ProbS' pr, `SresultsS' sr)
{
	`RS'	i, l, j
	`RM'	fps
	`RM'	comparetable
	`RM'	L
//	`SS'	estname
					/* scalar e(fp_dimension)	*/
	st_numscalar("e(fp_dimension)", pr.el.dimension)

					/* matrix e(fp_powers)		*/
	st_matrix("e(fp_powers)", pr.el.powers)

					/* matrix e(fp_compare_fp)	*/
	fps = J(pr.el.dimension+1+sr.has_linear, pr.el.dimension, .)
	for(i=2+sr.has_linear; i<=sr.n; i++) {
		l = length(sr.models[i].fp) 
		for (j=1;j<=l;j++) fps[i,j] = sr.models[i].fp[j]
	}
	if (sr.has_linear) fps[2,1] = 1
	st_matrix("e(fp_compare_fp)", fps)


					/* matrix e(fp_compare_stat)	*/
	st_matrix("e(fp_compare_stat)", sr.compare_stat)

					/* matrix e(fp_compare_df1)	*/
					/* scalar e(fp_compare_df2)	*/
	st_matrix("e(fp_compare_df1)",sr.compare_df1)
	st_numscalar("e(fp_compare_df2)", sr.compare_df2)

					/* macro  e(fp_compare_type)	*/
	st_global("e(fp_compare_type)",sr.compare_type)

					/* matrix e(fp_compare)		*/
	comparetable = 
		(-sr.compare_df1 :+ (sr.mbest.p_actual+length(sr.mbest.fp)))


	comparetable = (comparetable, sr.dev, sr.dev_diff, sr.compare_pval) 
	if (sr.compare_type == "F") comparetable = (comparetable, sr.rmse) 

	st_matrix("e(fp_compare)", comparetable)

					/* matrix e(fp_compare_length)	*/
	L = (sr.has_linear ?
		(0\ -1\ 1::pr.el.dimension)
		:
		(0\ 1::pr.el.dimension)
	    )
	st_matrix("e(fp_compare_length)", L)
	st_global("e(lrt_nok)",pr.initrun.lrt_nok,"hidden")
//	estname = st_global("e(_estimates_name)")
//	st_global("e(_estimates_name)",estname,"hidden")
	st_global("e(_estimates_name)","")
}



/*		       __
	SresultsUpdate(sr, m, pr, p) 
		       --  -  --  -  

	Inputs:
		m	   model just estimated to be evaluated
		p	   fractional powers corresponding to m
		pr	   so we can access pr.strat.method
	Outputs
		sr	updated if m is better than best model so far
			also updated is -estimates store <bestname> results-.
*/


void SresultsUpdate(`SresultsS' sr, `ModelS' m, `ProbS' pr, `RR' p)
{
	`RS'	i
	if (pr.strat.method == `EM_ll') {
		i = length(p) + 1 + sr.has_linear*(p!=(1))
		if (m.ll > sr.models[i].ll) sr.models[i] = m
		i = length(p) + 1 + sr.has_linear
		if (m.ll > sr.models[i].ll) sr.models[i] = m
		if ((i == sr.n) && (m.ll >= sr.mbest.ll)) {
			sr.mbest = m 
			stata_must_run("fp:",
	         	sr.store_bestmodel_cmd, `True',"")
		}
	}
	else 	_error("method undefined")
}


/*		       __
	SresultsFinish(sr, regress_like)
		       --  ------------

	Performs
		-estimates restore <bestmodel>-
		updates sr
*/


void SresultsFinish(`SresultsS' sr, `boolean' regress_like, `SS' lrt_nok)
{
	`RS'	i
	`RS'	n_0	/* residual dof for less complex model */
	`RS'	n_1	/* residual dof for full model */
	stata_must_run("fp:", sr.restore_bestmodel_cmd, `True',"")
	if (regress_like) {
		sr.compare_type = "F"
                n_1 = (sr.mbest.N - sr.models[1].p_total - sr.mbest.p_actual
			-length(sr.mbest.fp))

	        for (i=1; i<= sr.n; i++) {
			n_0 = (sr.models[i].N - sr.models[1].p_total  - 
				sr.models[i].p_actual - 
				length(sr.models[i].fp))
			if (2 == i & sr.has_linear) {
	                       n_0 = (sr.models[i].N - sr.models[1].p_total  - 
                                                sr.models[i].p_actual)
			}
			sr.compare_stat[i] = ((n_1/(n_0-n_1)) *
				(exp((  2*sr.mbest.ll - 
					2*sr.models[i].ll)/sr.mbest.N)-1))
			sr.compare_pval[i] = -F(n_0-n_1, n_1, 
				sr.compare_stat[i])+1			
			sr.compare_df1[i] = n_0 - n_1
			sr.compare_df2 = n_1
			sr.dev[i] = -2*sr.models[i].ll
			sr.dev_diff[i] = 2*sr.mbest.ll - 2*sr.models[i].ll
			sr.rmse[i] = sr.models[i].rmse
		}
	}
	else {
		sr.compare_type = "chi2"
		for (i=1; i<= sr.n; i++) {
			if (lrt_nok == "") {
				sr.compare_stat[i] = ///
					2*sr.mbest.ll - 2*sr.models[i].ll
			}
			sr.dev_diff[i] = 2*sr.mbest.ll - 2*sr.models[i].ll
			sr.compare_df1[i] = (sr.mbest.p_actual+
					length(sr.mbest.fp)) - 
				        (sr.models[i].p_actual+
					length(sr.models[i].fp))
			if (2 == i & sr.has_linear) {
                                sr.compare_df1[i] = (sr.mbest.p_actual+
                                                length(sr.mbest.fp)) - 
                                                (sr.models[i].p_actual)
			}
			if (lrt_nok == "") {
				sr.compare_pval[i] = 			///
					-chi2(sr.compare_df1[i],	///
					 sr.compare_stat[i])+1
			}	
			sr.dev[i] = - 2*sr.models[i].ll
		}
	}
}


void fit_a_model(`ModelS' t, `ProbS' pr, `RR' p, `RS' p_total_null)
{
	`SS' cmd, pref  
	fill_in_fracpoly(pr.el.Vterms, pr.el.v, p, pr.el.c.mean)
	cmd = get_est_cmd(pr, pr.el.termnames[|1\length(p)|]) 
	pref = "When fitting the model with fractional powers (" + ///
		fp_replay_compare_powers(p) + "), "
	run_estcmd(pr, cmd, `True',pref)
	get_model_stats(t, pr.strat, length(p), p_total_null)
	t.fp = p
}
	
void fit_null_model(`ModelS' t, `ProbS' pr)
{
	`SS' 	tmpvar 
	`SS'	tmpret
	`SS'	cmd
	`RS'	rc
	`RS'	miss
	tmpvar = st_tempname(1) 
	tmpret = st_tempname(1)
	cmd = ///
	sprintf("qui gen byte %s = 0 if %s", tmpvar, pr.initrun.esample_var)
	stata_must_run("fp:", cmd, `True',"")
	stata("quietly capture " + sub_est_cmd(pr, tmpvar))
	stata_must_run("fp:",sprintf("qui scalar %s = _rc",tmpret),`True',"")
	rc = st_numscalar(tmpret)
	if (rc==412) {
		run_estcmd(pr, sub_est_cmd(pr, ""), `True', ///
			"When fitting the null model, ")
	}
	else {	
		run_estcmd(pr, sub_est_cmd(pr, tmpvar), `True', ///
			"When fitting the null model, ")
	}
	st_dropvar(tmpvar) 
	if (rc!=412) {
		get_model_stats(t, pr.strat, 0, 0)
	}
	else {
		if (st_numscalar("e(k)") == J(0,0,.)) {
			t.p_total = 0	
		}
		t.ll = st_numscalar("e(ll)")
		miss = (t.ll == J(0,0,.)) 
		if (!miss) {
			miss = (t.ll >=.)
		}
		if (miss) {
			errprintf(
			"{bf:e(ll)} unexpectedly missing in estimation run\n")
			exit(498)
			/*NOTREACHED*/
		}
		t.rmse = st_numscalar("e(rmse)")
		t.krs = st_numscalar("e(k_rs)")
		if (t.krs == J(0,0,.)) {
			t.krs = .
		}
		if (t.rmse == J(0,0,.)) {
			t.rmse = .
		}
	}
	t.p_actual = 0		
}

void run_estcmd(`ProbS' pr, `SS' cmd, `boolean' quietly, `SS' prefix)
{
	`RS'	rc
	stata_must_run("fp:", cmd, quietly,prefix)
	rc = _stata(
		sprintf("assert e(sample)==%s", pr.initrun.esample_var),
		1/*nooutput*/, 1/*nomacroexpand*/) 
	if (rc==0) return

	(void) _stata(sprintf("count if e(sample) & !%s", 
			pr.initrun.esample_var),
			1/*nooutput*/, 1/*nomacroexpand*/) 

	(void) _stata(sprintf("count if !e(sample) & %s", 
			pr.initrun.esample_var),
			1/*nooutput*/, 1/*nomacroexpand*/) 

	errprintf("{bf:e(sample)} changed across estimation runs\n")
	exit(498)
	/*NOTREACHED*/
}


void get_model_stats(`ModelS' t, `StrategyS' s, 
			`RS' p_ourcount, `RS' p_total_null)
{
	`boolean'  miss

	t.N          = get_no_obs(s)
	t.p_total    = get_rank(s)
	t.p_ourcount = p_ourcount 
	t.p_actual   = t.p_total - p_total_null 
	if (t.p_total>=.) {
	errprintf("{bf:e(rank)} unexpectedly missing in estimation run\n")
		exit(498)
		/*NOTREACHED*/
	}

	if (t.method == `EM_ll') {
		t.ll   = st_numscalar("e(ll)")
		miss = (t.ll == J(0,0,.)) 
		if (!miss) {
			miss = (t.ll >=.)
		}
		if (miss) {
			errprintf(
			"{bf:e(ll)} unexpectedly missing in estimation run\n")
			exit(498)
			/*NOTREACHED*/
		}
		t.rmse = st_numscalar("e(rmse)")
		t.krs = st_numscalar("e(k_rs)")
		if (t.krs == J(0,0,.)) {
			t.krs = .
		}
		if (t.rmse == J(0,0,.)) {
			t.rmse = .
		}
	}
}
	

`RS' get_no_obs(`StrategyS' s)
{
	if (s.has_e_N) return(st_numscalar("e(N)"))
	stata_must_run("fp:", "count if e(sample)", `True',"")
	return(st_numscalar("r(N)"))
}

`RS' get_rank(`StrategyS' s)
{
	if (!s.has_e_rank) {
		stata_must_run("fp:", "_post_vce_rank, checksize", `True',"")
	}
	return(st_numscalar("e(rank)"))
}
		

`SS' get_est_cmd(`ProbS' pr, `SR' termnames)
{
	if (pr.el.term0name=="") {
		return(sub_est_cmd(pr, invtokens(termnames)))
	}
	return(sub_est_cmd(pr, pr.el.term0name + " " + invtokens(termnames)))
}


`SS' sub_est_cmd(`ProbS' pr, `SS' tosub)
{
	return(subinstr(pr.est_cmd, pr.el.bracketed_elname, tosub))
}




/*
	label_terms(term0name, termnames, varname, s, c, op, fp)
         	    ---------  ---------  -------  -  -  --  --

	Inputs:
	    term0name     1x1  
	    termnames     1xN, N>=length(fp) (we care only about 1st k elements)
	    varname       1x1
	    s             1x1  ScaleS
	    c             1x1  CenterS
	    op		  1x1  OpS
            fp            1xk  fractional powers

	Add notes to variables term0name, termnames[1], ..., termnames[k]
	indicating what they contain. Text:

            1. term # of varname^(1 2 3 4) [if varname>0].
        or
	    1. term # of x^(1 2 3 4) [if x>0,] where x = mpg 
               [scaled | centered | scaled and centered.]

	    2. Scaling was {automatic|user specified}: x = (varname+a)/b
               where a=# and b=# (a=# and b=# in hex).

	    3. Centering was {automatic|user specified} with 
               mean=# (mean=# in hex).

	    4. set to 0 if <= 0

	    5. Fractional polynomial variables created by  <cmd>

	    6. Command to recreate in another dataset is <cmd>

	Also sets variable label to be "term # of varname^(powers)" 
	whether or not scaling or centering.
*/


void label_terms(`SS' term0name, `SR' termnames, 
		 `SS' varname, `ScaleS' s, `CenterS' c, `OpsS' op, `RR' fp,
		 `SS' fullcmd, `boolean' iscenter, `boolean' isscale, 
		 `SS' stype)
{
	`SS' 		text
	`RS'  		i
	`SS' 		text_powers
	`SS'		verb
	`SS'		chkisgen
	`boolean' 	has_s, has_c, has_sorc
	`boolean'	has_0, has_gen
	`RS'		num_notes

	has_s	 = isscale
	has_c    = iscenter
        has_sorc = has_s | has_c
	has_0    = op.zero | op.catzero
	chkisgen =bsubstr(strltrim(fullcmd),3,strlen(fullcmd))
	chkisgen = strltrim(chkisgen)
	chkisgen = bsubstr(chkisgen,1,3)
	has_gen = chkisgen == "gen"
	num_notes = has_s+has_c+has_0+1+(!has_gen)+1
	if (term0name != "") label_term0(term0name, varname, ///
					 termnames[1], num_notes)

	text_powers = "(" + invtokens(strofreal(fp)) + ")"


	for (i=1; i<=length(fp); i++) {
		/* ---------------------------------------------------- */
						/* set label		*/

		st_varlabel(termnames[i], 
			sprintf("term %g %s^%s", i, varname, text_powers))


		/* ---------------------------------------------------- */
						/* set note 		*/

			/* -------------------------------------------- */
						/* Note 1		*/
						/* fp term # of ...	*/
		text = sprintf("fp term %g of ", i)
		text = text + (has_sorc ? "x" : varname)
		text = text + "^" + text_powers
		if (has_sorc) {
			text = text + ", where x is " + varname + " "
			if (has_s & has_c) {
				text = text + "scaled and centered"
			}
			else if (has_s) text = text + "scaled"
			else	        text = text + "centered"
		}
		text = text + "."
		st_note(termnames[i], text)

			/* -------------------------------------------- */
						/* Notes 2 - 6		*/
						/* 2. Scaling was ...	*/
						/* 3. Centering was ... */
						/* 4. variables <=0	*/
						/* 5. created by ...	*/
						/* 6. to recreate ...	*/

		if (i==1) {
			if (has_s) { 
						/* 2. Scaling was ...	*/
				text = "Scaling was " + 
				     (s.auto ? "automatic" : "user specified") 

				text = text + ": x = (" + varname + "+a)/b " 
				text = text + sprintf("where a=%g and b=%g", 
								s.a, s.b)
				st_note(termnames[1], text)
			}
			if (has_c) {
						/* 3. Centering was ... */
				text = "Centering was " + 
				  (c.auto ? "automatic" : "user specified") 
				text = text + sprintf(
					" with mean = %g.",
					c.mean)		

				if (has_s) {
					text = text + 
				 	  sprintf(
					  "  In the original scale of") +
					  sprintf(
					  " the variable, the centering") +
					  sprintf(" mean=%g",s.b*c.mean-s.a)  
				}
				st_note(termnames[1], text)
			}


			if (has_0) {
						/* 4. variables <=0	*/
				if (length(termnames)==1) {
					text   = termnames[1]
					verb   = "was"
				}
				else if (length(termnames)==2) {
					text   = termnames[1] + " and " + 
						 termnames[2]
					verb   = "were"
				}
				else {
					text   = termnames[1] + " through " +
				         	termnames[length(termnames)]
					verb   = "were"
				}
				text = text + " " + verb
				text = text + " set to 0 if "
				text = text + varname + "<=0."
				st_note(termnames[1], text)
			}
						/* 5. created by ...	*/
						/*  <cmd>		*/
			text = "Fractional polynomial variables created by "
			text = text + "{bf:" + fullcmd + "}"

			st_note(termnames[1], text)
			chkisgen =bsubstr(strltrim(fullcmd),3,strlen(fullcmd))
			chkisgen = strltrim(chkisgen)
			chkisgen = bsubstr(chkisgen,1,3)
			if(chkisgen !="gen") {
				/* ---------------------------------------- */
						/* 6. to recreate ...	*/
				text ="To re-create the fractional polynomial"
				text = text + " variables, for instance, in"
				text = text + " another dataset, type "
				text = text + "{bf:" +
                                        make_fp_gen_cmd(varname, fp,
                                                        s, c, op, stype) +
                                        "}"
				st_note(termnames[1], text)
				/* --------------------------------------- */
			}
		}
		else {
			/* -------------------------------------------- */
						/* Note last on 2, ...	*/
			st_note(termnames[i], 
			    sprintf("See notes 2-%g on variable ",num_notes) +
			    termnames[1] + ".")
		}
	}
}

void label_term0(`SS' term0name, `SS' varname, `SS' termname, `RS' num_notes)
{
	if (term0name=="") return 
					/* place note		*/
	st_note(term0name, 
		sprintf("fp; indicator for %s<=0.", varname))
	st_note(term0name, sprintf("See notes 2-%g on variable ",num_notes) +
			    termname + ".") 
					/* label variable	*/
	st_varlabel(term0name, sprintf("I(%s<=0)", varname))
}


void st_note(`SS' varname, `SS' text)
{
	stata_must_run("fp:", 
			sprintf("notes %s: %s", varname, text), 
			`True',"")
}
	
`SS' make_fp_gen_cmd(`SS' varname, `RR' fp, 
			`ScaleS' s, `CenterS' c, `OpsS' op, `SS' stype)
{
	`SS'	cmd
	`SS'	ops
	`SS'	text_powers

	text_powers = "(" + invtokens(strofreal(fp)) + ")"

	cmd = sprintf("fp gen %s %s^%s", stype, varname, text_powers)

	ops = ""

	if (s.a!=0 | s.b!=1) {
		ops = sprintf("scale(%g %g)", s.a, s.b)

	}

	if (c.mean!=0) {
		if (s.a!=0 | s.b!=1) {
			ops = ops + " " + ///                        
			sprintf("center(%g)", s.b*(c.mean)-s.a)

		}
		else {
			ops = ops + " " + ///
			sprintf("center(%g)", c.mean)
		}
	}

	if (op.zero) ops = ops + " " + "zero"

	if (op.catzero) ops = ops + " " + "catzero"
	
	return(ops != "" ? cmd + ", " + strtrim(ops) : cmd)
}

/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* utilities			*/


/*	_
	s = st_local_and_zap(name)
			     ----

	st_local(name) followed by destruction of local macro
*/


`SS' st_local_and_zap(`SS' name)
{
	`SS'	toret

	toret = st_local(name)
	st_local(name, "")
	return(toret)
}

void label_fp_pred_fp(`SS' varname)
{
	`SS' cmd, text_powers
	`RR' fp_powers
	
	fp_powers = st_matrix("e(fp_fp)")
        text_powers = "(" + invtokens(strofreal(fp_powers)) + ")"
	cmd = "linear prediction, "+ st_global("e(fp_variable)")+"^"
	cmd = cmd + text_powers +", other covariates = 0" 	
	st_varlabel(varname,cmd) 
}

void label_fp_pred_stdp(`SS' varname)
{
	`SS' cmd, text_powers
	`RR' fp_powers
	
	fp_powers = st_matrix("e(fp_fp)")
        text_powers = "(" + invtokens(strofreal(fp_powers)) + ")"
	cmd = "Standard error of linear prediction, "
	cmd = cmd + st_global("e(fp_variable)")+"^"
	cmd = cmd + text_powers +", other covariates = 0" 	
	st_varlabel(varname,cmd) 
}

`VarstatR' st_variable_status(`SR' names)
{
	`RS'		i
	`VarstatR'	r

	r = J(1, length(names), .)
	for (i=1; i<=length(names); i++) {
		if (_st_varindex(names[i])>=.) r[i] = `Varstat_new'
		else {
			r[i] = (st_global(names[i]+"[created_by]") ? 
					`Varstat_dropable' : 
					`Varstat_exists')
		}
	}
	return(r)
}

void substitute_elname(`SS' cmd, `SS' elname, `SS' tosub)
{
	cmd = subinstr(cmd, elname, tosub, .)
}
	


void stata_must_run(`SS' id, `SS' cmd, `boolean' quietly, `SS' prefix)
{
	`RS'	rc 
	`SS'	cmdname
	cmdname = tokens(cmd)[1]
	rc = _stata(quietly ? "quietly " + cmd : cmd, 0, 1)
	if (rc==0) return
	if (rc==1) {
		exit(rc)
	}
	if (prefix == "When fitting the null model, ") {
		errprintf("{p 4 4 2}\n")
		errprintf(
		"%s{bf:%s} ran the command {bf:%s}", prefix, id, cmdname)
		errprintf(" and it produced the above error message.\n")
		errprintf("{p_end}\n")
		exit(rc)
	}
	errprintf("{p 4 4 2}\n")
	errprintf("%s{bf:%s} ran the command\n", prefix, id)
	errprintf("{p_end}\n")

	errprintf("{p 6 8 2}\n")
	errprintf(". {bf:%s}\n", cmd)
	errprintf("{p_end}\n")

	errprintf("{p 4 4 2}\n")
	errprintf("and it produced the above error message.\n")
	errprintf("{p_end}\n")
	exit(rc)
	/*NOTREACHED*/
}
	
				
					/* utilities			*/
/* -------------------------------------------------------------------- */
					/* utilities			*/



void add_var_to_drop(`SS' macname, `SS' varname)
{
	st_local(macname, strtrim(st_local(macname) + " " + varname))
}



void st_mysetmatrix(`SS' name, `RM' X, `SC' rowstr, `SR' colstr)
{
	`SM'	lbl

	st_matrix(name, X)

	if (rowstr != "") {
		lbl = J(rows(X), 2, "") 
		lbl[,2] = rowstr
		st_matrixrowstripe(name, lbl)
	}

	if (colstr != "") {
		lbl = J(cols(X), 2, "")
		lbl[,2] = colstr'
		st_matrixcolstripe(name, lbl)
	}
}

/*
        ----+----1----+----2-
	+1.0000000000000X+000
            |          |
            5         16
*/

`SS' shorthex(`RS' x)
{
	`SS'	s, last 
	`RS'	i

	if (x>=.) return(strtrim(printf("%g", x)))

	s = sprintf("%21x", x)
	for (i=16; i>=5 & bsubstr(s, i, 1)=="0"; --i) ;

	// edit out [i+1, 16]
	(void) i++ 
	if (i<=16) s = bsubstr(s, 1, i-1) + bsubstr(s, 17, .)

	last = bsubstr(s, -3, .)
	if (bsubstr(last, 1, 1)=="0") {
		s = bsubstr(s, 1, strlen(s)-3) + bsubstr(last, 2, .)
	}
	if (bsubstr(s, 1, 1)=="+") s = bsubstr(s, 2, .)
	return(s)
}


					/* utilities			*/
/* -------------------------------------------------------------------- */
					/* utilities			*/

void begin_error_comment()	errprintf("{p 4 4 2}\n")

void end_error_comment()	errprintf("{p_end}\n")


					/* utilities			*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* mata error messages		*/

void error_est_cmd(`SS' bracketed_elname)
{
	errprintf("estimation command does not contain %s\n", bracketed_elname)
	begin_error_comment()
	errprintf("The command to the right of the colon should contain\n")
	errprintf("one or more {bf:%s}.\n", bracketed_elname)
  	errprintf("The bracketed element names\n") 
	errprintf("are substituted with the variables for the fractional\n")
	errprintf("polynomial.\n") 
	end_error_comment()
	exit(198)
}


void error_varnames_exist(`SR' names, `boolean' inclreplop)
{
	`RS'	i, n 

	n = length(names) 
	errprintf("{p 0 0 2}\n")
	errprintf(n==1 ? "variable\n" : "variables\n") 
	for (i=1; i<=n; i++) errprintf("%s\n", names[i]) 
	errprintf("already ")
	errprintf(n==1 ? "exists\n" : "exist\n")
	errprintf("{p_end}\n")
	if (inclreplop) { 
		begin_error_comment()
		errprintf("Specify option {bf:replace} to\n")
		errprintf("allow dropping these variables.\n")
		end_error_comment()
	}
	exit(110) 
}

void error_fp_ran(`SS' cmd)
{
	errprintf("{p 4 4 2}\n")
	errprintf("{bf:fp:} ran the command\n")
	errprintf("\n")

	errprintf("{p 6 8 2}\n")
	errprintf(". {bf:%s}\n", cmd)
	errprintf("\n")

	errprintf("{p 4 4 2}\n")
}

void error_not_eclass(`SS' cmd)
{
	errprintf("command not e-class\n")
	error_fp_ran(cmd)
	errprintf("and it did not save estimation results in e().\n")
	errprintf("{p_end}\n")
	exit(301)
	/*NOTREACHED*/
}

void error_V_contains_0orneg(`SS' varname)
{
	errprintf("{bf:%s} incorrectly scaled\n", varname)
	begin_error_comment()
	errprintf("The variable on which fractional polynomial terms\n")
	errprintf("are to be calculated contains nonpositive values.\n")
	errprintf("You must rescale the variable by specifying option\n")
	errprintf("{bf:scale}, or specify option {bf:zero} or {bf:catzero}.\n")
	end_error_comment()
	exit(498)
}
	
void error_no_strategy(`SS' estcmd)
{
	`RS'		i 
	`boolean'	std

	std = `True' 
	i   = strpos(estcmd, " ")
	if (i==0) {
		i = strlen(estcmd)+1
		if (i>33) std = `False'
	}
	if (std) {
		errprintf("{p 0 0 2}\n")
		errprintf("estimation command ") 
		errprintf(bsubstr(estcmd, 1, i-1))
		errprintf(" did not set {bf:e(ll)}\n") 
		errprintf("{p_end}")
	}
	else {
		errprintf("estimation command did not set {bf:e(ll)}\n")
	}
	begin_error_comment()
	errprintf("{bf:fp} currently requires that the estimation command\n")
	errprintf("calculate the log-likelihood for fitted models.\n") 
	end_error_comment()
}



					/* mata error messages		*/

					/* Mata				*/
/* ==================================================================== */

end

