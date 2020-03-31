*! version 2.2.4  04feb2015
program svy_dreg
	version 8.0

/* Parse options. */

	if   "`e(svy_est)'" == "svy_est" {
		local vcaller : di "version " string(_caller()) ":"
		`vcaller' `e(cmd)' 0 syntax /* get options `s(dopts)'
					       and title `s(title)' */
		local title `s(title)'
		local dopts `s(dopts)'
	}
	else if "`e(svyml)'" == "svyml" {
		local title `e(title)'
		local dopts __all__
	}

	syntax [,		/*
	*/ Level(cilevel)	/*
	*/ Prob			/*
	*/ CI			/*
	*/ DEFF			/*
	*/ DEFT			/*
	*/ MEFF			/*
	*/ MEFT			/*
	*/ noHeader		/*
	*/ First		/*
	*/ NEQ(integer -1)	/*
	*/ *			/* _diparm/eform options
	*/ ]

	// parse `options'
	_get_eformopts , eformopts(`options') soptions allowed(`dopts')
	local eform `s(opt)'
	local col1 `s(str)'
	// `diparm' should only contain -diparm()- options
	local diparm `s(options)'
	_get_diparmopts , diparmopts(`diparm') level(`level') ///
		svy `prob' `ci' `deff' `deft' `meff' `meft'
	local diparm `s(diparm)'
	// default behavior
	if "`prob'`ci'`deff'`deft'`meff'`meft'"=="" {
		local prob "prob"
		local ci   "ci"
	}

/* Get estimates. */

	tempname t b V

	scalar `t' = invttail(e(df_r), (1-`level'/100)/2)
	matrix `b' = e(b)
	matrix `V' = e(V)
	if ("`first'" != "")	local neq 1
	if (`neq' > 0) {
		local eqnames : coleq `b'
		local uqnames : list uniq eqnames
		forval i = `=`neq'+1'/`:word count `uqnames'' {
			local eq : word `i' of `uqnames'
			local myeqnames : ///
				subinstr local eqnames `"`eq'"' "", all
			local eqnames `myeqnames'
		}
		local dim : word count `eqnames'
	}
	else	local dim = colsof(`b')

	if "`deff'"!="" {
		tempname Deff
		matrix `Deff' = e(deff)
	}
	if "`deft'"!="" {
		tempname Deft
		matrix `Deft' = e(deft)
	}
	if "`meff'`meft'"!="" {
		if `"`e(meft)'"'=="matrix" {
			tempname Meft
			matrix `Meft' = e(meft)
		}
		else {
			di as err	///
"meff and meft options must be specified when the model is fit"
			exit 198
		}
	}

/* Set up switches (" " or "*") for display of items. */

	local count 2

	if "`prob'"!="" {
		local PROB " "
		local count 3
	}
	else local PROB "*"
	if "`ci'"!="" {
		local CI " "
		local count = `count' + 2
	}
	else local CI "*"
	if "`deff'"!="" & `count' < 5 {
		local deff
		local DEFF " "
		local count = `count' + 1
	}
	else local DEFF "*"
	if "`deft'"!="" & `count' < 5 {
		local deft
		local DEFT " "
		local count = `count' + 1
	}
	else local DEFT "*"
	if "`meff'"!="" & `count' < 5 {
		local meff
		local MEFF " "
		local count = `count' + 1
	}
	else local MEFF "*"
	if "`meft'"!="" & `count' < 5 {
		local meft
		local MEFT " "
		local count = `count' + 1
	}
	else local MEFT "*"

/* Print out header. */

	if "`header'"=="" {
		svy_header , title(`title')
	}

	/* Were there constraints ? */
	tempname cns
	capture mat `cns' = get(Cns)
	if !_rc {
		matrix dispCns
	}

/* Print out column headers of table 1. */

	DashLine top 14
	local nword : word count `e(depvar)'
	if `nword'==1 {
		local depvar `e(depvar)'
	}
	capture {
		confirm integer number `e(k_aux)'
		confirm integer number `e(k_eq)'
	}
	if !_rc {
		if "`diparm'" != "" {
			local diparm diparm(__sep__) `diparm'
		}
		if (`e(k_eq)'-`e(k_aux)' > 1) {
			local depvar
		}
	}
	Colhead "`depvar'" `level' "`col1'" " " "`PROB'" "`CI'" /*
	*/ "`DEFF'" "`DEFT'" "`MEFF'" "`MEFT'"

/* Print out body of table 1. */

	DashLine mid 14

	global S_1 /* erase macro */
	global S_2 /* erase macro */
	forval i = 1/`dim' {
		Body			/*
		*/	`i'		/*
		*/	`b'		/*
		*/	`V'		/*
		*/	`t'		/*
		*/	"`Deff'"	/*
		*/	"`Deft'"	/*
		*/	"`Meft'"	/*
		*/	"`eform'"	/*
		*/	" "		/*
		*/	"`PROB'"	/*
		*/	"`CI'"		/*
		*/	"`DEFF'"	/*
		*/	"`DEFT'"	/*
		*/	"`MEFF'"	/*
		*/	"`MEFT'"	/*
		*/
	}

	if "`e(k_eq)'"=="" | "`e(k_eq)'"=="1" {
		Offset
	}

/* display back-transformed parameters */

	if "`eform'"=="" {
		_get_diparmopts , diparmopts(`diparm') execute
	}

	DashLine bot 14

/* See if there is more to print out. */

	if "`deff'`deft'`meff'`meft'"=="" {
		`vcaller' Footnote "`header'" "`Deff'"
		exit
	}

/* If here, we need to print out another table. */

	if "`deff'"!="" {
		local DEFF " "
	}
	else local DEFF "*"
	if "`deft'"!="" {
		local DEFT " "
	}
	else local DEFT "*"
	if "`meff'"!="" {
		local MEFF " "
	}
	else local MEFF "*"
	if "`meft'"!="" {
		local MEFT " "
	}
	else local MEFT "*"
	if "`obs'"!=""  {
		local OBS " "
	}
	else local OBS "*"
	if "`size'"!="" {
		local SIZE " "
	}
	else local SIZE "*"

/* Print out column headers of table 2. */

	di
	DashLine top 14
	Colhead "`depvar'" `level' "`eform'" * * * /*
	*/ "`DEFF'" "`DEFT'" "`MEFF'" "`MEFT'"

/* Print out body of table 2. */

	DashLine mid 14

	global S_1 /* erase macro */
	global S_2 /* erase macro */
	forval i = 1/`dim' {
		Body `i' `b' `V' `t' "`Deff'" "`Deft'" "`Meft'" "`eform'" /*
		*/ * * * "`DEFF'" "`DEFT'" "`MEFF'" "`MEFT'"
	}

	if "`e(k_eq)'"=="" {
		Offset
	}

	DashLine bot 14

	`vcaller' Footnote "`header'" "`Deff'"
end

program DashLine
	args typ col
	if "`typ'"=="straight" {
		di in smcl as txt "{hline 78}"
		exit
	}
	confirm integer number `col'
	if "`typ'"=="top" {
		local mid "{c TT}"
	}
	else if "`typ'"=="mid" {
		local mid "{c +}"
	}
	else	loca mid "{c BT}"

	local dash1 = `col' - 1 
	local dash2 = 78 - `col'
	di in smcl as txt "{hline `dash1'}`mid'{hline `dash2'}"
end

program Footnote
	args header deff
	if "`header'"=="" & `"`e(svy_est)'"'!="" {
		`e(cmd)' 0 footnote /* print special footnote, if any */
	}
	if "`e(fpc)'"!="" { /* print FPC note */
		di as txt "Finite population correction (FPC) assumes " /*
		*/ "simple random sampling without " _n /*
		*/ "replacement of PSUs within each stratum with no " /*
		*/ "subsampling within PSUs."

		if "`deff'"!="" {
			di as txt "Weights must represent population " /*
			*/ "totals for deff to be correct when" _n /*
                        */ "using an FPC.  Note: deft is invariant " /*
			*/ "to the scale of weights."

		}
	}
end

program Colhead
	args depvar level col1
	macro shift 3
	if   "`e(cmd)'"=="svymean" | "`e(cmd)'"=="svyratio" /*
	*/ | "`e(cmd)'"=="svytotal" {
		local col1 "Estimate"
	}
	if (`"`col1'"' == "") local col1 "Coef."
	local col1 : display %10s "`col1'"
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces ""
	if `cil' == 2 {
		local spaces "  "
	}
	`1' local head " `col1'   Std. Err."
	`2' local head "`head'      t    P>|t|  "
	`2' local s " "
`3' local head `"`head'`s'`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
	`3' local s " "
	`4' local head "`head'`s'      Deff"
	`4' local s " "
	`5' local head "`head'`s'      Deft"
	`5' local s " "
	`6' local head "`head'`s'      Meff"
	`6' local s " "
	`7' local head "`head'`s'      Meft"

	di in smcl as txt %12s abbrev("`depvar'",12) " {c |}" "`head'"
end

/* global macros:
     S_1 -- keeps track of the current equation name
*/
program Body, rclass
	args i b V t deff deft meft eform
	macro shift 8

	local s 2
	tempname v A

	local colname : colnames(`b')
	local coli : word `i' of `colname'

	if "`eform'"!="" {
		if "`coli'"=="_cons" {
			exit
		}
		local exp "exp"
		local eb "exp(`b'[1,`i'])*"
	}

/* Look at current equation name vs. last equation name. */

	if "`e(k_eq)'"!="" {
		tempname A
		matrix `A' = `b'[1,`i'..`i']
		local eqi : coleq(`A')

		// just in case e(k_aux) is a macro instead of a scalar
		capture confirm integer number `e(k_aux)'
		if _rc	local k_aux = 0
		else	local k_aux = `e(k_aux)'
		if !_rc {
			if `i' > colsof(`b') - `k_aux' {
				if "$S_1"!="__aux__" {
					Offset
					DashLine mid 14
					global S_1 __aux__
				}
				local coli "/`eqi'"
			}
		}
		if (`"`eqi'"'!=`"$S_1"' & `"$S_1"'!="__aux__") {
			if `i' > 1 {
				Offset
				DashLine mid 14
			}
			local reqns = e(k_eq) - `k_aux'
			if `reqns'!=1 {
				di in smcl as res /*
				*/ abbrev(`"`eqi'"',12) _col(14) as txt "{c |}"
			}
			global S_1 `"`eqi'"'
		}
	}

	if bsubstr("`coli'",1,1) != "/" { 
		di in smcl as txt %12s abbrev("`coli'",12) " {c |}" _c 
	}
	else di in smcl as txt %12s "`coli'" " {c |}" _c

	if `V'[`i',`i']==0 {
		if `b'[1,`i']==0 {
			di as res " (dropped)"
			exit
		}
		scalar `v' = .
	}
	else scalar `v' = `V'[`i',`i']

	`1' local body : di _s(2) %9.0g `exp'(`b'[1,`i']) _s(2) %9.0g /*
	*/		 `eb'sqrt(`v')
	`1' local s 2

	`2' local x : di _s(1) %8.2f `b'[1,`i']/sqrt(`v') /*
	*/  %8.3f tprob(e(df_r),`b'[1,`i']/sqrt(`v')) _s(2)
	`2' local body "`body'`x'"

	`3' local x : di _s(2) %9.0g `exp'(`b'[1,`i']-`t'*sqrt(`v')) /*
	*/		 _s(3) %9.0g `exp'(`b'[1,`i']+`t'*sqrt(`v'))
	`3' local body "`body'`x'"

	`4' local x : di _s(`s') %9.0g cond(`deff'[1,`i']!=0, /*
	*/                             `deff'[1,`i'],.)
	`4' local body "`body'`x'"
	`4' local s 2

	`5' local x : di _s(`s') %9.0g cond(`deft'[1,`i']!=0, /*
	*/                             `deft'[1,`i'],.)
	`5' local body "`body'`x'"
	`5' local s 2

	`6' local x : di _s(`s') %9.0g cond(`meft'[1,`i']!=0, /*
	*/                             `meft'[1,`i']^2,.)
	`6' local body "`body'`x'"
	`6' local s 2

	`7' local x : di _s(`s') %9.0g cond(`meft'[1,`i']!=0, /*
	*/                             `meft'[1,`i'],.)
	`7' local body "`body'`x'"
	`7' local s 2

	di as res "`body'"
end

/* global macros:
     S_2 -- keeps track of the current equation number
*/
program Offset /* display offset for given equation */
	global S_2 = $S_2 + 1
	if `"$S_2"'=="1" {
		local offset `e(offset)'`e(offset1)'
	}
	else local offset `e(offset$S_2)'
	if `"`offset'"'=="" {
		exit
	}
	if index("`offset'","ln(")!=0 {
		local varname "`offset'"
		local varname : subinstr local varname "ln(" ""
		local varname : subinstr local varname ")"   ""
		di in smcl as txt %12s abbrev("`varname'",12) /*
		*/ " {c |} (exposure)"
	}
	else {
		di in smcl as txt %12s abbrev("`offset'",12) /*
		*/ " {c |}   (offset)"
	}
end

exit
