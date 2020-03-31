*! version 1.1.6  21oct2019
program discrim_estat_common, rclass
	version 10

// -estat- common commands for -discrim-

	if "`e(cmd)'" != "discrim" & "`e(cmd)'" != "candisc" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		// override default -estat summ-
		Summ `rest'
	}
	else if `"`key'"' == bsubstr("grsummarize",1,max(3,`lkey')) {
		GroupSumm `rest'
	}
	else if `"`key'"' == bsubstr("list",1,max(2,`lkey')) {
		List `rest'
	}
	else if `"`key'"' == bsubstr("classtable",1,max(5, `lkey')) {
		ClassTable `rest'
	}
	else if `"`key'"' == bsubstr("errorrate",1,max(3, `lkey')) {
		ErrRate `rest'
	}
	else {
		di as err `"subcommand {bf:estat} {bf:`key'} is unrecognized"'
		exit 321
	}

	return add
end

// Summarize estimation variables over estimation sample
program Summ, rclass
	syntax [, *]

	if "`e(groupvar)'" == "" {
		di as err "e(groupvar) not found"
		exit 321
	}
	if "`e(varlist)'" == "" {
		di as err "e(varlist) not found"
		exit 321
	}

	estat_summ (groupvar : `e(groupvar)') ///
		(variables : `e(varlist)'), `options'

	return add
end


// Produces count error rate table (table of proportion misclassified
// by group) or Posterior prob. error rate table
program ErrRate, rclass
	syntax [if] [in] [fw] [,		///
		CLass			/// regular (apparent/resub) error rate
		LOOclass		/// leave-one-out error rate
		COUnt			/// error count estimate
		PP(str)			/// posterior probability estimate
					///     PP(Stratified UNStratified)
		PP2			/// same as PP() with both args
		PRIors(string)		/// prior probs
		noPRIors2		/// suppress display of prior probs
		TIEs(string)		/// handling of ties
		TITle(string)		/// title for table
		noTOTal			/// suppress overall error rate
	/// undocumented options
		CVar(varname numeric)	/// user specified class. var
		PRVars(varlist numeric)	/// user specified post. prob. vars
		noLABELKEY		/// suppress label key
		]

    // Notes ===============================================================

	// Choice 1:  -class-, -looclass-, or (one of -cvar()- or -prvars()-)
	// (the default is -class-).
	// -cvar()- specifies a classification var instead of computing it
	// with -class- or -looclass-.  Likewise -prvars()- specifies posterior
	// probability vars instead of computing with -class- or -looclass-.
	// The true group variable is assumed to be in e(groupvar).

	// Choice 2:  -count- or -pp- (the default is -count-).  The optional
	// arguments to -pp()- are -stratified- and -unstratified-.  One or
	// both may be specified.  -pp- is equivalent to -pp(strat unstrat)-.

	// Huberty (1994) discusses "hit rates" which are 1 - "error rates".
	//
	// See pages 90-91 of
	// Huberty, Carl J.  1994.  Applied Discriminant Analysis.  Wiley

	marksample touse

    // Error check / set defaults ==========================================

	// Determine if we have -count- or -pp-
	if "`count'" != "" & `"`pp'`pp2'"' != "" {
		if `"`pp'"' != ""	     opts_exclusive "count pp()"
		if "`pp2'" != ""	     opts_exclusive "count pp"
	}
	if "`pp2'" != "" & `"`pp'"' != ""    opts_exclusive "pp pp()"
		// default to -count-
	if `"`pp'`pp2'`count'"' == ""	local count count
		// -pp- implies -pp(stratified unstratified)-
	if "`pp2'" != ""	local pp stratified unstratified
	ParsePP `pp'  // sets local ppstrat and ppunstrat as appropriate

	// Determine if we have -looclass-, -class-, or user specified
	opts_exclusive "`looclass' `class'"
	if "`looclass'`class'" != "" {
		if "`cvar'" != ""   opts_exclusive "`looclass'`class' cvar()"
		if "`prvars'" != "" opts_exclusive "`looclass'`class' prvars()"
	}
	// default to -class-
	if "`looclass'`class'`cvar'`prvars'" == ""   local class class

	if `"`pp'"' != "" & "`looclass'`class'`prvars'" == "" {
		di as err "option {bf:pp} requires option {bf:prvars()} " ///
			"if option {bf:cvar()} is specified"
		exit 198
	}
	if "`cvar'" != "" & `"`ties'"' != ""	opts_exclusive "cvar() ties()"

	ChkIfEInt N_groups
	local ng = e(N_groups)

	// Get default priors or check user specified priors
	tempname gpriors
	if `"`priors'"' == "" {
		ChkIfEMat grouppriors
		mat `gpriors' = e(grouppriors)
	}
	else {
		tempname gcnts
		ChkIfEMat groupcounts
		mat `gcnts' = e(groupcounts)
		discrim prog_utility priors `"`priors'"' `ng' `gcnts'
		mat `gpriors' = r(grouppriors)
		local priors priors(`priors')	// if it is to be passed on
	}

	if `"`ties'"' != ""	local tieopt `"ties(`ties')"'

	if "`looclass'" != "" 	local loo loo

    // Error count error rate estimates ====================================

	if "`count'" != "" {
		tempname cntmat ecvec totvec
		if "`weight'" != ""	local wgt `"[`weight'`exp']"'
		if "`cvar'" != ""	local cvopt cvar(`cvar')
		qui ClassTable `if' `in' `wgt',    ///
			`looclass' `class' `cvopt' /// loocl, class, or cvar()
			`priors' `tieopt'	   /// pass these along
			nocoltotals		   // won't need it

		mat `cntmat' == r(counts)

		if rowsof(`cntmat') != `ng' | ///
				!inlist(colsof(`cntmat'),`ng'+1,`ng'+2) {
			di as err ///
				"{p}program assumption failure: ClassTable " ///
				"returned a " rowsof(`cntmat') "x" ///
				colsof(`cntmat') "{p_end}"
			exit 9674
		}

		mat `totvec' = `cntmat'[1...,`= colsof(`cntmat')']
		mat `cntmat' = `cntmat'[1...,1..`= colsof(`cntmat')-1']

		// put title out now before any Notes
		if `"`title'"' == "" {
			if "`looclass'" != "" local LO "leave-one-out "
			local title "Error rate estimated by `LO'error count"
		}
		di
		di as text "`title'"

		if colsof(`cntmat') == `ng'+1 {
			tempname ucnt
			mat `ucnt' = J(1,`ng',1) * `cntmat'[1...,`ng'+1]
			local nnc `= `ucnt'[1,1]'
			di
			di as text "{p}Note: `nnc' " ///
				plural(`nnc', "observation") ///
				" " plural(`nnc', "was", "were") ///
				" not classified and " ///
				plural(`nnc',"is","are") ///
				" not included " ///
				"in the table{p_end}"

			// take away the unclassified from the totals
			mat `totvec' = `totvec' - `cntmat'[1...,`ng'+1]
			// drop the unclassified column
			mat `cntmat' = `cntmat'[1...,1..`ng']
		}

		mat `ecvec' = `totvec' - vecdiag(`cntmat')'
		mata: st_matrix("`ecvec'", st_matrix("`ecvec'") :/ ///
							st_matrix("`totvec'"))

		forvalues i = 1/`ng' {
			local cnm `cnm' group`i'
		}
		mat colnames `ecvec' = Error_rate
		if "`total'" != "nototal" {
			mat `ecvec' = `ecvec' \ (`gpriors' * `ecvec')
			mat rownames `ecvec' = `cnm' Total
			local lastc col
		}
		else {
			mat rownames `ecvec' = `cnm'
		}
		mat `ecvec' = `ecvec''		// want a row vector

		tempname dispmat
		mat `dispmat' = `ecvec'

		if "`priors2'" != "nopriors2" {
			if  "`total'" != "nototal" {
				mat `dispmat' = `dispmat' \ (`gpriors' , .z)
			}
			else {
				mat `dispmat' = `dispmat' \ `gpriors'
			}
			mat rownames `dispmat' = Error_rate Priors
			local lastr row
		}

		if "`lastr'`lastc'" != "" local lop `lop' last(`lastr' `lastc')
		local lop `lop' left top

		local holdcnm : colnames `dispmat'
		mata: _discrim_NameSub(`"`e(grouplabels)'"', "`holdcnm'", ///
					/// these will be set as local macros
					"newcnm", "cnlen", "anyus", "anyoth")
		local xopt "colnames(, underscore)"
		if `cnlen'>0 & `cnlen'<13 & !`anyoth' {
			mat colnames `dispmat' = `newcnm'
			mat coleq `dispmat' = `e(groupvar)'
			if `cnlen' < 9		local cnlen 9
			local xopt ///
			 `"widths(`cnlen') colnames(, eq(combined) underscore)"'
		}
		else if "`labelkey'" != "nolabelkey" {
			di
			discrim prog_utility groupheader, left(4)
		}

		_multiplemat_tab `dispmat', left(4) blank(.z) key(, off) ///
			rownames(, underscore)  lines(`lop') `xopt'

		// save r() results
		return matrix erate_count = `ecvec'
		return matrix grouppriors = `gpriors'

		exit
	}


    // Posterior Prob. error rate estimates ================================

	// take care of -if- and -in- and weights
	tempvar fw
	qui gen byte `fw' = 1 if `touse'
	if "`weight'" != "" {
		qui replace `fw' `exp' if `touse'
	}
	marksample touse
	qui summ `fw' if `touse', meanonly
	if r(sum) < 1 error 2000

	if "`looclass'" != "" {
		// no observations outside e(sample) are allowed with LOO
		// mark touse as zeros if needed
		qui replace `touse' = 0 if !e(sample)
		qui summ `fw' if `touse', meanonly
		if r(sum) < 1 {
			di as err ///
		    "observations restricted to e(sample) with option {bf:looclass}"
			error 2000
		}
	}

	ChkIfEVars groupvar 1
	ChkIfEMat groupvalues
	ChkIfEInt N_groups
	local ngps = e(N_groups)

	if "`class'`looclass'" != "" { // get group and prob. predictions
		tempvar cvar
		forvalues i=1/`ngps' {
			tempvar ttmpvv
			local prvars `prvars' `ttmpvv'
		}
		qui predict double `cvar' if `touse', ///
						`loo'class `priors' `tieopt'
		qui compress `cvar'
		qui predict double (`prvars') if `touse', `loo'pr `priors'
	}
	else {	// user supplied probability vars (and possibly class var)
		if `: list sizeof prvars' != `ngps' {
			di as err "option {bf:prvars()} invalid; `ngps' variables " ///
				"expected, `: list sizeof prvars' found"
			exit 198
		}
		if `"`cvar'"' == "" {	// user gave prvars but not cvar
			tempvar cvar
			discrim prog_utility assigngroup "`cvar'" ///
				"`prvars'" "`touse'" `"`ties'"'
		}
	}

	tempname erst erunst

	// Compute the estimates
	mata: _discrim_PprobErate("`cvar'", "`prvars'", "`touse'", "`fw'", ///
					"`gpriors'", "`erst'", "`erunst'")

	// Display results
	tempname dspmat

	local lop rows(gap)
	if "`ppstrat'" != "" {
		mat `dspmat' = nullmat(`dspmat') \ `erst'
	}
	if "`ppunstrat'" != "" {
		mat `dspmat' = nullmat(`dspmat') \ `erunst'
	}
	if "`priors2'" != "nopriors2" {
		mat `dspmat' = `dspmat' \ (`gpriors' , .z)
		local lastr row
	}
	if "`total'" == "nototal" {
		mat `dspmat' = `dspmat'[1...,1..`ngps']
		mat `erst'   = `erst'[1...,1..`ngps']
		mat `erunst' = `erunst'[1...,1..`ngps']
	}
	else	local lastc col
	if "`lastr'`lastc'" != ""    local lop `lop' last(`lastr' `lastc')
	local lop `lop' left top

	if `"`title'"' == "" {
		if "`looclass'" != ""	local LO "leave-one-out "
		local title ///
			"Error rate estimated from `LO'posterior probabilities"
	}
	di
	di as text "`title'"

	local holdcnm : colnames `dspmat'
	mata: _discrim_NameSub(`"`e(grouplabels)'"', "`holdcnm'", ///
				/// these will be set as local macros
				"newcnm", "cnlen", "anyus", "anyoth")
	local xopt "colnames(, underscore)"
	if `cnlen'>0 & `cnlen'<13 & !`anyoth' {
		mat colnames `dspmat' = `newcnm'
		mat coleq `dspmat' = `e(groupvar)'
		if `cnlen' < 9		local cnlen 9
		local xopt ///
			`"widths(`cnlen') colnames(, eq(combined) underscore)"'
	}
	else if "`labelkey'" != "nolabelkey" {
		di
		discrim prog_utility groupheader, left(4)
	}

	_multiplemat_tab `dspmat', left(4) blank(.z) key(, off) ///
			rownames(, title(Error Rate)) lines(`lop') `xopt'

	// Return results
	return matrix grouppriors   = `gpriors'
	return matrix erate_strat   = `erst'
	return matrix erate_unstrat = `erunst'
end

program ParsePP
	local 0 `", `0'"'
	syntax [, Stratified UNStratified]

	if "`stratified'" != ""		c_local ppstrat   ppstrat
	if "`unstratified'" != ""	c_local ppunstrat ppunstrat
end

// Summarize estimation vars over estimation sample by discrim grouping var
program GroupSumm, rclass
	// Just document syntax with:  n[(%fmt)] ... max[(%fmt)]
	syntax [,			 ///
		N Nformat(str)		 /// group sizes
		Mean Meanformat(str)	 /// group means
		MEDian MEDianformat(str) /// group medians
		SD SDformat(str)	 /// group std devs
		CV CVformat(str)	 /// group coef of variation = sd/mean
		SEMean SEMeanformat(str) /// group std err of mean = sd/sqrt(n)
		MIN MINformat(str)	 /// group mins
		MAX MAXformat(str)	 /// group maxs
		noTOTal			 /// suppress combined stats
		TRANspose		 /// switch role of rows and columns
			/// Undocumented option
		noLABELKEY		 /// suppress label key
		]

	// specifying <whatever>format() implies <whatever>
	if `"`nformat'"'	!= ""		local n		n
	if `"`meanformat'"'	!= ""		local mean	mean
	if `"`medianformat'"'	!= ""		local median	median
	if `"`sdformat'"'	!= ""		local sd	sd
	if `"`cvformat'"'	!= ""		local cv	cv
	if `"`semeanformat'"'	!= ""		local semean	semean
	if `"`minformat'"'	!= ""		local min	min
	if `"`maxformat'"'	!= ""		local max	max

	FormatChk `"`nformat'"'      n      blankok
	FormatChk `"`meanformat'"'   mean   blankok
	FormatChk `"`medianformat'"' median blankok
	FormatChk `"`sdformat'"'     sd     blankok
	FormatChk `"`cvformat'"'     cv     blankok
	FormatChk `"`semeanformat'"' semean blankok
	FormatChk `"`minformat'"'    min    blankok
	FormatChk `"`maxformat'"'    max    blankok

	local what `n' `mean' `median' `sd' `cv' `semean' `min' `max'

	local nstats : list sizeof what
	if `nstats' < 1 { // no stats specified; default to N and mean
		local n    n
		local mean mean
		local what n mean
		local nstats 2
	}

	ChkIfEInt N N_groups k
	local bigN = e(N)
	local grps = e(N_groups)
	local nvar = e(k)

	tempname fwt
	qui gen byte `fwt' = 1 if e(sample)
	if "`e(wexp)'`e(wtype)'" != "" {
		capture replace `fwt'`e(wexp)' if e(sample)
		if c(rc) {
			dis as err "weighting expression"
			dis as err "    `e(wexp)'"
			dis as err "cannot be evaluated"
			exit 111
		}
		local wt "[fw=`fwt']"
	}
	qui summ `fwt' if e(sample), meanonly
	if r(sum) != `bigN' { // complain if e(sample) is not available
		di as err "estimation sample no longer available"
		exit 321
	}

	tempname gvals nmat

	ChkIfEVars groupvar 1
	local grpvar `e(groupvar)'
	ChkIfEVars varlist `nvar'
	local vlist `e(varlist)'
	ChkIfEMat groupvalues
	mat `gvals' = e(groupvalues)

	ChkIfEMat groupcounts
	mat `nmat' = e(groupcounts)
	local cnames : colnames `nmat'

	if "`total'" != "nototal" { // add column with overall N
		mat `nmat' = `nmat' , `bigN'
		local cnames `cnames' Total
		mat colnames `nmat' = `cnames'

		local plus1 "+1"	// useful for later mat creations
	}

	tempname meanmat medianmat sdmat cvmat semeanmat minmat maxmat

	if "`n'" == "" local don "*"

	if "`mean'" != "" {
		mat `meanmat' = J(`nvar',`grps'`plus1',.)
		mat rownames `meanmat' = `vlist'
		mat colnames `meanmat' = `cnames'
	}
	else	local domean "*"
	if "`median'" != "" {
		mat `medianmat' = J(`nvar',`grps'`plus1',.)
		mat rownames `medianmat' = `vlist'
		mat colnames `medianmat' = `cnames'
		local detail detail
	}
	else 	local domedian "*"
	if "`sd'" != "" {
		mat `sdmat' = J(`nvar',`grps'`plus1',.)
		mat rownames `sdmat' = `vlist'
		mat colnames `sdmat' = `cnames'
	}
	else	local dosd "*"
	if "`cv'" != "" {
		mat `cvmat' = J(`nvar',`grps'`plus1',.)
		mat rownames `cvmat' = `vlist'
		mat colnames `cvmat' = `cnames'
	}
	else	local docv "*"
	if "`semean'" != "" {
		mat `semeanmat' = J(`nvar',`grps'`plus1',.)
		mat rownames `semeanmat' = `vlist'
		mat colnames `semeanmat' = `cnames'
	}
	else	local dosemean "*"
	if "`min'" != "" {
		mat `minmat' = J(`nvar',`grps'`plus1',.)
		mat rownames `minmat' = `vlist'
		mat colnames `minmat' = `cnames'
	}
	else	local domin "*"
	if "`max'" != "" {
		mat `maxmat' = J(`nvar',`grps'`plus1',.)
		mat rownames `maxmat' = `vlist'
		mat colnames `maxmat' = `cnames'
	}
	else	local domax "*"

	local row 0
	foreach v of local vlist {
		local ++row
		forvalues i = 1/`grps' {
			qui summ `v' `wt' if e(sample) & ///
				`grpvar' == `gvals'[1,`i'] , `detail'
			`domean'   mat `meanmat'[`row',`i']   = r(mean)
			`domedian' mat `medianmat'[`row',`i'] = r(p50)
			`dosd'     mat `sdmat'[`row',`i']     = r(sd)
			`docv'     mat `cvmat'[`row',`i']     = r(sd)/r(mean)
			`dosemean' mat `semeanmat'[`row',`i'] = r(sd)/sqrt(r(N))
			`domin'    mat `minmat'[`row',`i']    = r(min)
			`domax'    mat `maxmat'[`row',`i']    = r(max)
		}
	}

	if "`total'" != "nototal" { // add column with overall stat
		local i = `grps' + 1
		local row 0
		foreach v of local vlist {
			local ++row
			qui summ `v' `wt' if e(sample), `detail'
			`domean'   mat `meanmat'[`row',`i']   = r(mean)
			`domedian' mat `medianmat'[`row',`i'] = r(p50)
			`dosd'     mat `sdmat'[`row',`i']     = r(sd)
			`docv'     mat `cvmat'[`row',`i']     = r(sd)/r(mean)
			`dosemean' mat `semeanmat'[`row',`i'] = r(sd)/sqrt(r(N))
			`domin'    mat `minmat'[`row',`i']    = r(min)
			`domax'    mat `maxmat'[`row',`i']    = r(max)
		}
	}


	// set default format if needed
	if "`n'" != "" {
		mata: st_local("MAXn", strofreal(max(st_matrix("`nmat'"))))
		local tmp = ceil(log10(`MAXn'+1))
		if "`transpose'" != "" {
			if `tmp' < 3		local nfmt %2.0f
			else			local nfmt %`tmp'.0f
		}
		else {
			if `tmp' < 7		local nfmt %6.0f
			else			local nfmt %`tmp'.0f
		}
	}
	`domean'   if "`meanformat'"   == ""	local meanformat   %9.0g
	`domedian' if "`medianformat'" == ""	local medianformat %9.0g
	`dosd'     if "`sdformat'"     == ""	local sdformat     %9.0g
	`docv'     if "`cvformat'"     == ""	local cvformat     %9.0g
	`dosemean' if "`semeanformat'" == ""	local semeanformat %9.0g
	`domin'    if "`minformat'"    == ""	local minformat    %9.0g
	`domax'    if "`maxformat'"    == ""	local maxformat    %9.0g
	`don'      if "`nformat'"      == ""	local nformat      `nfmt'


	di
	di as text "Estimation sample " as res "`e(cmd)' `e(subcmd)'"
	di as text "Summarized by {bf:`grpvar'}"

	if `nstats' == 1 | (`nstats' == 2 & "`n'" != "") { // 1 stat or 2 and n
		tempname xx
		if "`transpose'" != "" {
			local tp "'"
		}
		if `nstats' == 2 {
			local what : word 2 of `what'
			mat `xx' = ``what'mat' \ `nmat'
			mat rownames `xx' = `: rownames ``what'mat'' N
			forvalues i=1/`nvar' {
				local rfmt `rfmt' ``what'format'
			}
			local rfmt `rfmt' `nformat'

			if "`total'" != "nototal" {
				local gdopts lines(left top last)
			}
			else {
				if "`transpose'" != "" {
					local gdopts lines(left top last(col))
				}
				else {
					local gdopts lines(left top last(row))
				}
			}

			if "`transpose'" != "" {
				local xdopts format(`rfmt', column)
			}
			else {
				local xdopts format(`rfmt', row)
			}
		}
		else {	// only 1 stat
			mat `xx' = ``what'mat'
			if "`what'" == "n" {
				mat rownames `xx' = N
			}
			if "`total'" != "nototal" {
				if "`transpose'" != "" {
					local gdopts lines(left top last(row))
				}
				else {
					local gdopts lines(left top last(col))
				}
			}
			local xdopts format(``what'format')
		}

		if "`transpose'" == "" {
			mat coleq `xx' = `grpvar'

			`domean'   local gdopts `gdopts' ///
			`domean'	 rownames(,title("Mean"))
			`domedian' local gdopts `gdopts' ///
			`domedian'	 rownames(,title("Median"))
			`dosd'     local gdopts `gdopts' ///
			`dosd'		 rownames(, title("Standard deviation"))
			`docv'     local gdopts `gdopts' rownames(, ///
			`docv'		title("Coef. of variation"))
			`dosemean' local gdopts `gdopts' rownames(, ///
			`dosemean'    title("Std. error of the mean"))
			`domin'    local gdopts `gdopts' rownames(,title("Min"))
			`domax'    local gdopts `gdopts' rownames(,title("Max"))
		}
		else {
			`domean'   local gdopts `gdopts' ///
			`domean'	 colnames(,title("Mean"))
			`domedian' local gdopts `gdopts' ///
			`domedian'	 colnames(,title("Median"))
			`dosd'     local gdopts `gdopts' ///
			`dosd'		 colnames(, title("Standard deviation"))
			`docv'     local gdopts `gdopts' colnames(, ///
			`docv'		title("Coefficient of variation"))
			`dosemean' local gdopts `gdopts' colnames(, ///
			`dosemean'    title("Standard error of the mean"))
			`domin'    local gdopts `gdopts' colnames(,title("Min"))
			`domax'    local gdopts `gdopts' colnames(,title("Max"))
		}
		local gdopts `gdopts' key(,off) left(2)

		local holdcnm : colnames `xx'
		mata: _discrim_NameSub(`"`e(grouplabels)'"',"`holdcnm'", ///
					/// these will be set as local macros
					"newcnm", "cnlen", "anyus", "anyoth")
		if "`tp'" == "" {
			local gdadd "colnames(, underscore)"
		}
		else {
			local gdadd "rownames(, underscore)"
		}
		if `cnlen'>0 & `cnlen'<13 & !`anyoth' {
			mat colnames `xx' = `newcnm'
			if "`tp'" == "" {
				local gdopts `"`gdopts' widths(`cnlen')"'
			}
			else {
				local gdadd ///
				    `"rownames(,title(`grpvar') underscore)"'
			}
		}
		else if "`labelkey'" != "nolabelkey" {
			di
			discrim prog_utility groupheader, left(2)
		}
		local gdopts `"`gdopts' `gdadd'"'

		_multiplemat_tab (`xx'`tp', `xdopts'), `gdopts'
	}
	else { // multiple stats requested

		// Build overall matrix to be displayed
		tempname xx

		// order to show stats
		local order mean median sd cv semean min max

		local row 0
		foreach v of local vlist {
			local ++row
			foreach item of local order {
				if "`item'" == "mean" & "`mean'" != "" {
					mat `xx' = nullmat(`xx') \ ///
							`meanmat'[`row',1...]
					local rnm `rnm' `v':Mean
					local rfmt `rfmt' `meanformat'
				}
				if "`item'" == "median" & "`median'" != "" {
					mat `xx' = nullmat(`xx') \ ///
							`medianmat'[`row',1...]
					local rnm `rnm' `v':Median
					local rfmt `rfmt' `medianformat'
				}
				if "`item'" == "sd" & "`sd'" != "" {
					mat `xx' = nullmat(`xx') \ ///
							`sdmat'[`row',1...]
					local rnm `rnm' `v':Std_dev
					local rfmt `rfmt' `sdformat'
				}
				if "`item'" == "cv" & "`cv'" != "" {
					mat `xx' = nullmat(`xx') \ ///
							`cvmat'[`row',1...]
					local rnm `rnm' `v':Coef_of_var
					local rfmt `rfmt' `cvformat'
				}
				if "`item'" == "semean" & "`semean'" != "" {
					mat `xx' = nullmat(`xx') \ ///
							`semeanmat'[`row',1...]
					local rnm `rnm' `v':SE_mean
					local rfmt `rfmt' `semeanformat'
				}
				if "`item'" == "min" & "`min'" != "" {
					mat `xx' = nullmat(`xx') \ ///
							`minmat'[`row',1...]
					local rnm `rnm' `v':Min
					local rfmt `rfmt' `minformat'
				}
				if "`item'" == "max" & "`max'" != "" {
					mat `xx' = nullmat(`xx') \ ///
							`maxmat'[`row',1...]
					local rnm `rnm' `v':Max
					local rfmt `rfmt' `maxformat'
				}
			}
		}

		if "`n'" != "" {
			mat `xx' = nullmat(`xx') \ `nmat'
			local rnm `rnm' _:N
			local rfmt `rfmt' `nformat'
		}

		mat rownames `xx' = `rnm'

		if "`transpose'" == "" {
			mat coleq `xx' = `grpvar'
		}

		local what col
		if "`transpose'" != "" {
			mat `xx' = `xx''
			local what row
		}

		// Set table global display options in gdopts
		if "`total'" != "nototal" {
			if "`transpose'" != "" {
				local gdopts lines(left top eq last(row))
			}
			else {
				local gdopts lines(left top eq last(column))
			}
		}
		else {
			local gdopts lines(left top eq)
		}
		local gdopts `gdopts' key(,off) left(2)

		// Set table matrix x specific options in xdopts
		if "`transpose'" != "" {
			local xdopts `xdopts' format(`rfmt', column)
			local xdopts `xdopts' ///
				colnames(, underscore eq(bind combined))
		}
		else {
			local xdopts `xdopts' format(`rfmt', row)
			local xdopts `xdopts' rownames(, underscore)
			local xdopts `xdopts' ///
					colnames(, eq(combined) underscore)
		}

		local holdnm : `what'names `xx'
		mata: _discrim_NameSub(`"`e(grouplabels)'"',"`holdnm'", ///
					/// these will be set as local macros
					"newnm", "nmlen", "anyus", "anyoth")
		if "`what'" == "row" {
			local gdadd "rownames(, underscore)"
		}
		if `nmlen'>0 & `nmlen'<13 & !`anyoth' {
			mat `what'names `xx' = `newnm'
			if "`what'" == "col" {
				local gdopts `"`gdopts' widths(`nmlen')"'
			}
			else {
				local gdadd ///
				    `"rownames(,title(`grpvar') underscore)"'
			}
		}
		else if "`labelkey'" != "nolabelkey" {
			di
			discrim prog_utility groupheader, left(2)
		}
		local gdopts `"`gdopts' `gdadd'"'

		_multiplemat_tab (`xx', `xdopts'), `gdopts'
	}


	// Return results
		   return matrix count  = `nmat'
	`domean'   return matrix mean   = `meanmat'
	`domedian' return matrix median = `medianmat'
	`dosd'     return matrix sd     = `sdmat'
	`docv'     return matrix cv     = `cvmat'
	`dosemean' return matrix semean = `semeanmat'
	`domin'    return matrix min    = `minmat'
	`domax'    return matrix max    = `maxmat'
end

// List classification results
program List, rclass
	syntax [if] [in] [,		///
		MISclassified		/// only display misclassified obs
		CLassification(str)	/// classification section options
			/// LOOclass noClass NOTrue
			/// FORmat() noLabels
			/// undocumented: NONe CVar() LCVar() Group()
		NOVARlist		/// default, for completeness
		VARlist2         	/// show varlist doc as VARlist
		VARlist(str)		/// varlist section options
			/// First Last FORmat()
			/// undocumented: NONe
		PRobabilities(str)	/// probability section options
			/// noPr LOOpr FORmat()
			/// undocumented: NONe prvar() lprvar()
		NOWEights		/// no weights
		Weight(str)		/// weights (format)
		Weight2			/// weights (default format)
					/// document as weight
		NOOBS			/// do not show observation #s
		OBS			/// force show observation #s
		Id(str)			/// id/index variable
			/// varname FORmat()
		PRIors(passthru)	/// prior probs
		TIEs(passthru)		/// ties
		SEParator(int 5)	/// horizontal separators in table
	/// leave these next ones undocumented
		PREDOPTs(str)		/// options to send through to predict
		NOClassification	/// no classification variable
		CLassification2		/// show classif.,  default opts
		NOPRobabilities		/// no probabilities
		PRobabilities2		/// probabilities, default opts.
	]

	local noweight `noweights'	// to match documentation
	local sep `separator'

	local holdweight `weight'
	local weight
	marksample holdtouse, novarlist

/* FIRST goes varlist, since syntax will wipe it out elsewise */
/* and hold weight since that will get wiped by syntax */

	if "`novarlist'" != "" & "`varlist'`varlist2'" != "" {
		di as err "options {bf:novarlist} and {bf:varlist} may not be specified together"
		exit 198
	}
	if `"`varlist'`varlist2'"' != "" {
		local hvar `varlist'
		local 0 `varlist'
		capture syntax [anything] [, FORMat1(str)] 
		if _rc {
			di as err "option {bf:varlist()}: invalid syntax"
			exit _rc
		}
		local 0 , `anything'
		capture syntax [, First Last NONe FORmat(str)]
		if _rc {
			di as err "option {bf:varlist()}: invalid syntax"
			exit _rc
		}
		opts_exclusive "`first' `last' `none'" varlist
		local varsfirst varsfirst
		if "`last'" != "" {
			local varslast varslast
			local varsfirst
		}
		if "`none'" != "" local novarlist novarlist
		if "`format'" != "" & "`format1'" != "" {
			di as err "option {bf:varlist()}: suboption {bf:format()} may be specified " ///
				"only once"
			exit 198
		}
		if "`format1'" != "" {
			local format `format1'
		}
		if `"`format'"' != "" {
			if "`none'" != "" {
				di as error "option {bf:varlist()}: suboption {bf:format()} not valid " ///
					"with suboption {bf:none}"
				exit 198
			}
			FormatChk `format' varlist
			local varfmt `format'
		}
	}
	else {
		local novarlist novarlist
	}

/* Next work on classification */
	if ("`classification'"!= "" | "`classification2'" != "")	///
			 & "`noclassification'" != "" {
		di as err "options {bf:classification} and {bf:noclassification} may not " ///
			"be specified together"
		exit 198
	}
	if "`noclassification'"== "" {
		local 0 `classification'
		capture syntax [anything] [, FORmat1(str)]
		if _rc {
			di as err "option {bf:classification()}: invalid syntax"
			exit _rc
		}
		local 0 , `anything'
		capture syntax [, NONe LOOclass noClass NOTrue noStar ///
			Group(varname numeric) CVar(varname numeric) ///
			LCVar(varname numeric) FORmat(str) noLabels]
		if _rc {
			di as err "option {bf:classification()}: invalid syntax"
			exit _rc
		}
		if "`notrue'" != "" {	// rest of code uses `nogroup'
			local nogroup nogroup
			local notrue
		}
		local copt `looclass' `group' `cvar'
		if "`copt'" != "" & "`none'" != "" {
			di as err "{p}option {bf:classification()}: suboption {bf:none} may not be "	///
				"specified with suboptions {bf:looclass}, {bf:group()}, or {bf:cvar()}{p_end}"
			exit 198
		}
		if "`looclass'" != "" & "`lcvar'" != "" {
			di as err "{p}option {bf:classification()}: suboption {bf:looclass} may not be " ///
				"specified with suboption {bf:lcvar()}{p_end}"
			exit 198
		}
		if "`lcvar'" != "" {
			local looclass looclass
		}
		if "`class'"=="noclass" & "`nogroup'"!="" & "`looclass'"=="" {
			local none none
		}
		if "`none'" != "" & "`nogroup'" != "" {
			local skipclass skipclass
		}
		if "`class'" == "noclass" | "`none'" != "" {
			local classification noclassification
		}
		if "`group'" != "" & `"`nogroup'"' != "" {
			di as err "{p}option {bf:classification()}: suboption {bf:group()} may not be " ///
				"specified with suboption {bf:notrue}{p_end}"
			exit 198
		}
		if `"`nogroup'"' != "" | "`star'" == "nostar" {
			local nocstar nocstar
		}
		if "`group'" =="" & "`nogroup'" == "" {
			local group `e(groupvar)'
			if "`group'" == "" {
				local nogroup nogroup
				local nocstar nocstar
			}
		}
		if "`format'" != "" & "`format1'" != "" {
			di as err "{p}option {bf:classification()}: suboption {bf:format()} may be " ///
				"specified only once{p_end}"
			exit 198
		}
		if "`format1'" != "" {
			local format `format1'
		}
		if "`format'" != "" {
			if "`none'" != "" {
				di as err "{p}option {bf:classification()}: suboption {bf:format()} "	///
					"may not be specified with suboption {bf:none}{p_end}"
				exit 198
			}
			FormatChk `format' classification
			local clfmt `format'
		}
	}
	else local classification noclassification

/* Next probabilities */
	if ("`probabilities'"!= "" | "`probabilities2'" != "")	///
			 & "`noprobabilities'" != "" {
		di as err "options {bf:probabilities} and {bf:noprobabilities} may not " ///
			"be specified together"
		exit 198
	}
	if "`noprobabilities'"== "" {
		local 0 `probabilities'
		capture syntax [anything] [, FORMat1(str)]
		if _rc {
			di as err "option {bf:probabilities()}: invalid syntax"
			exit _rc
		}
		local 0 , `anything'
		capture syntax [, NONe LOOpr noPr 		///
			PRVars(varlist numeric)	LPRVars(varlist numeric) ///
			FORmat(str)]
		if _rc {
			di as err "option {bf:probabilities()}: invalid syntax"
			exit _rc
		}
		local popt `loopr' `prvars' `lprvars'
		if "`popt'" != "" & "`none'" != "" {
			di as err "{p}option {bf:probabilities()}: suboption {bf:none} may not be "  ///
				"specified with suboptions {bf:loopr}, {bf:prvars()}, or {bf:lprvars()}{p_end}"
			exit 198
		}
		if "`loopr'" !="" & "`lprvars'"!="" {
			di as err "{p}option {bf:probabilities()}: suboption {bf:loopr} may not be " ///
				"specified with suboption {bf:lprvars()}{p_end}"
			exit 198
		}
		if "`lprvars'"!= "" {
			local loopr loopr
		}
		if "`none'" != "" {
			local pr nopr
		}
		if "`format'" != "" & "`format1'" != "" {
			di as err "{p}option {bf:probabilities()}: suboption {bf:format()} may be " ///
				"specified only once{p_end}"
			exit 198
		}
		if "`format1'" != "" {
			local format `format1'
		}
		if "`format'" != "" {
			if "`none'" != "" {
				di as err "{p}option {bf:probabilities()}: suboption {bf:format()} " ///
					"may not be specified with suboption {bf:none}{p_end}"
				exit 198
			}
			FormatChk `format' probabilities
			local prfmt `format'
			local lprfmt `format'
		}
	}
	else local pr nopr

/* Next weight */
	local weight `holdweight'
	if ("`weight2'" != "" | "`weight'" != "")& "`noweight'" != "" {
		di as err "options {bf:weight} and {bf:noweights} may not be specified together"
		exit 198
	}
	if `"`weight'`weight2'"' == "" & `"`e(wtype)'"' == "" {
		// User did not specify -weight()- or -weight-
		// and there was no weights used in the discrim model
		local noweight noweight
	}
	if "`noweight'" == "" {
		local 0 `weight'
		capture syntax [anything] [, FORmat1(str)]
		if _rc {
			di as err "option {bf:weight()}: invalid syntax"
			exit _rc
		}
		local 0, `anything'
		capture syntax [, NONe FORmat(str)]
		if _rc {
			di as err "option {bf:weight()}: invalid syntax"
			exit 198
		}
		if "`none'" != "" {
			local weight noweight
		}
		else {
			local weight weight
			if "`varsfirst'`varslast'" == "" {
				local varsfirst varsfirst
			}
		}
		if "`format1'" != "" & "`format'" != "" {
			di as err "option {bf:weight()}: suboption {bf:format()} may be specified " ///
				"only once"
			exit 198
		}
		if "`format1'" != "" {
			local format `format1'
		}
		if "`format'" != "" {
			if "`none'" != "" {
				di as err "{p}option {bf:weight()}: suboption {bf:format()} " ///
					"may not be specified with suboption {bf:none}{p_end}"
				exit 198
			}
			FormatChk `format' weight
			local wtfmt `format'
		}
	}
	else {
		local weight noweight
	}
	local holdweight `weight'  /* otherwise can be wiped by syntax */
	opts_exclusive "`obs' `noobs'"
	if "`id'" != "" {
		local 0 `id'
		capture syntax anything [, FORmat1(str)]
		if _rc {
			if "`anything'" == "" {
				di as err ///
					"option {bf:id()}: {it:varname} required"
			}
			else {
				di as err "option {bf:id()}: invalid syntax"
			}
			exit 198
		}
		local 0, `anything'
		syntax [, FORmat(str) *]
		local idvar `options'
		if "`format1'" != "" & "`format'" != "" {
			di as err "option {bf:id()}: suboption {bf:format()} may be specified only once"
			exit 198
		}
		if "`format1'" != "" {
			local format `format1'
		}
		if "`format'" != "" {
			FormatChk `format' id
			local idfmt `format'
		}
		capture confirm variable `idvar'
		if _rc {
			di as err "option {bf:id()}: {it:varname} required"
			exit 198
		}
		if "`obs'" == "" {
			local noobs noobs
		}
	}

	local weight
	local varlist `e(varlist)'
	local if if `holdtouse'
	local in
	marksample touse

	qui count if `touse'
	if r(N) < 1		exit		// nothing to list

	local weight `holdweight' /* one more syntax statement coming */
	local cols 0

/* ==== Key to stuff ====
   foreach w of (id v gr pr lpr)
	wSuperTitle 	Super Title
	wcolw 		total width for chunk w
	wcolwAcc	width list
	wcolstart	# of first column
	wcolT		col. titles accumulator (above wcolt)
	wcolt 		column titles accumulator
	wcpad 		cpad accumulator
	wcolf 		numeric format accumulator
	wcolv 		variable name accumulator
	wncols 		number of cols in chunk w
	wcolws 		width accumulator with | seps
	wcolsfmt 	string format accumulator (section gr mostly)
	wcoltfmt	title format accumulator
	wcolsend	# of first column

	ZZZ is ignored in the tab output.

    ==================================================*/

/* ==========  id variables ================== */
	local idcolw 0
	local idncols 0
	local N = _N
	local linesize `c(linesize)'
	if `"`noobs'"' != "noobs" | "`obs'" != ""{
		tempname obs
		qui gen `c(obs_t)' `obs' = _n if `touse'
		if `N'< 1000 {
			local fmt %4.0f
			local wid 5
		}
		else if `N' < 100000 {
			local fmt %6.0f
			local wid 7
		}
		else {
			local fmt %10.0g
			local wid 11
		}
		local idcolt `"`idcolt' "Obs.""'
		local idcpad `idcpad' 0
		local idcolf `idcolf' `fmt'
		local idcolv `idcolv' `obs'
		local idncols 1
		local idcolws `idcolws' `wid'
		local tmp = `wid'
		local idcolw = `idcolw' + `tmp'
		local idcolwAcc `idcolwAcc' `tmp'
		local idcolsfmt `idcolsfmt' .
		local idSuperTitle `"`idSuperTitle' ZZZ"'
		local idcolT `idcolT' ZZZ
		local idcoltfmt `idcoltfmt' %`wid's
		local pad 1
	}
	if "`idvar'" != "" {
		local type : type `idvar'
		if "`idfmt'" != "" {
			confirm format `idfmt'
			if bsubstr("`type'",1,3) == "str" {
				confirm string format `idfmt'
			}
			local fmt `idfmt'
		}
		else {
			local fmt : format `idvar'
		}
		_nostrl nostrl : `idvar'
		if `nostrl' {
			di as err as smcl "type mismatch"
			di as err as smcl "{p 4 4 2}"
			di as err as smcl "{help data_types:strLs} not allowed with this command."
			di as err as smcl "{p_end}"
			exit 109
		}
		if bsubstr("`type'",1,3) == "str" {
			local sfmt `fmt'
			tokenize `fmt', parse("%s")
			confirm number `2'
			tempname idvar2
			qui gen `idvar2' = abbrev(`idvar',`2') if `touse'
			local n = bsubstr("`: type `idvar2''",4,.)
			local ++n
			local fmt %`n's
			local sfmt %`n's
			local idvar `idvar2'
		}
		else local sfmt .
		FormatTool `fmt' 4 `pad'
		local wid `s(wid)'
		local pad `s(pad)'
		local idcolt `"`idcolt' "ID ""'
		local idcpad `idcpad' `pad'
		local idcolf `idcolf' `fmt'
		local idcolv `idcolv' `idvar'
		local ++idncols
		local idcolws `idcolws' `wid'
		local tmp = `wid'
		local idcolw = `idcolw' + `tmp'
		local idcolwAcc `idcolwAcc' `tmp'
		local idcolsfmt `idcolsfmt' `sfmt'
		local idcoltfmt `idcoltfmt' %`wid's
		local idSuperTitle `"`idSuperTitle' ZZZ"'
		local idcolT `idcolT' ZZZ
	}

/* ==========  input variables ================== */
	local vcolw 0
	local vncols 0
	local min 5
	if `"`weight'"'=="" & "`e(wexp)'"=="" {
		local weight noweight
	}
	if `"`weight'"' != "noweight" {
		local vSuperTitle `"" Data ""'
		local wid 5
		if `"`novarlist'"' != "" {
			local wid 6
			local vSuperTitle ZZZ
		}
		tempvar fw
		qui gen `fw' = 1 if `touse'
		if "`e(wexp)'" != "" {
			local weight weight
			qui replace `fw' `e(wexp)' if `touse'
		}
		if "`wtfmt'" != "" {
			confirm format `wtfmt'
			local fmt `wtfmt'
		}
		else {
			capture assert `fw' < 1000
			if _rc == 0 {
				local fmt %3.0f
			}
			else {
				capture assert `fw' < 100000
				if _rc == 0 {
					local fmt %5.0f
					local wid 5
				}
				else local fmt %8.0g
				local wid 8
			}
		}

		FormatTool `fmt' `wid' 0
		local wid `s(wid)'
		local pad `s(pad)'
		if `wid' > 5 	local dot "."
		local vcolt `"`vcolt' " Freq`dot'""'
		local vcpad `vcpad' `pad'
		local vcolf `vcolf' `fmt'
		local vcolv `vcolv' `fw'
		local ++vncols
		local vcolws `vcolws' `wid'
		local vcolw = `wid'
		local vcolwAcc = `vcolw'
		local vcolsfmt `vcolsfmt' .
		local vcolT `vcolT' ZZZ
		local vcoltfmt `vcoltfmt' %-`wid's
		local vcolt2fmt `vcoltfmt'
	}
	if "`novarlist'" =="" {
		if `"`vSuperTitle'"' == "" {
			local vSuperTitle `"" Data""'
		}
		else {
			local vSuperTitle `"`vSuperTitle' ZZZ"'
		}
		local vars `e(varlist)'
		ProcessVars `vars', varfmt(`varfmt')  vars min(`min')	///
			 `labels' title(`vars')
		local m `s(nvar)'
		local wids `s(wids)'
		local pads `s(pads)'
		local titles `"`s(titles)'"'
		local fmts `s(fmts)'
		forvalues i=1/`m' {
			local wid : word `i' of `wids'
			local pad : word `i' of `pads'
			local vcolt `"`vcolt' `"`: word `i' of `titles''"'"'
			local vcpad `vcpad' `pad'
			local vcolf `vcolf' `: word `i' of `fmts''
			local vcolv `vcolv' `: word `i' of `vars''
			local ++vncols
			if `i'==1 & "`weight'"=="noweight" {
				local vcolws `vcolws' `wid'
			}
			else if `i'==`m' {
				local vcolws `vcolws' `wid'
			}
			else {
				local vcolws `vcolws' `wid'
			}
			local vcolw = `vcolw' + `wid'
			local vcolwAcc `vcolwAcc' `wid'
			local vcolsfmt `vcolsfmt' .
			local vcolT `vcolT' ZZZ
			if `i'==1  {
				local vSuperTitle `"`vSuperTitle'"'
				local vcoltfmt `vcoltfmt' %`wid's
				local vcolt2fmt `vcolt2fmt' %-`wid's
			}
			else{
				local vSuperTitle `"`vSuperTitle' ZZZ"'
				local vcoltfmt `vcoltfmt' %`wid's
				local vcolt2fmt `vcolt2fmt' %`wid's
			}
		}
	}

/* ==========  Group & class variables ================== */
	local grcolw 0
	local grncols 0
	if "`skipclass'" == "" {
		local grSuperTitle `"" Classification ""'
		local min 16
		local classpad 1
		if "`nogroup'" == "" {
			local title `"  True "'
			local title `""`title'""'
			local min 8
			if (("`cvar'"!="" | "`classification'" != 	///
				"noclassification") & ("`looclass'" != "" )) {
				local min 6
				local classpad 1
			}
			if "`cvar'" == "" & "`classification'" ==	///
				"noclassification" & "`looclass'" == "" {
				local grSuperTitle `"" Group ""'
				local title ZZZ
				local min 7
			}
		}
		else if (("`cvar'"!="" | "`classification'" != 	///
			"noclassification") & ("`looclass'" != "" )) {
			local min 8
			local classpad 1
		}
		else {
			local grSuperTitle `"" Class. ""'
			local title ZZZ
			local min 8
		}
		if strpos("`clfmt'","s") > 0 {
			local clsfmt `clfmt'
			tokenize "`clsfmt'", parse("%.s")
			capture confirm number `2'
			if _rc==0 {
				local min = max(`min',`2')
			}
		}
		else local clsfmt %`min's
		if "`clfmt'" == "" {
			local clfmt %5.0f
		}
		if `"`nogroup'"'=="" {
			if "`group'" != "" {
				local grvar `group'
			}
			else {
				local grvar `e(groupvar)'
				capture confirm numeric variable `e(groupvar)'
				if _rc {
					di as err ///
					   "e(groupvar) not a numeric variable"
					exit 459
				}
			}
			local ogrvar `grvar'
			local vlab : value label `grvar'
			if `"`labels'"' != "nolabels" & "`vlab'" != "" {
				tempvar gr2
				qui decode `grvar' if `touse', ///
					generate(`gr2') maxlength(`min')
				local grvar `gr2'
				local clfmt %`min's
				local holdmin `min'
			}
			local fmt `clfmt'
			FormatTool `clfmt' `min' 1
			local wid `s(wid)'
			local pad `s(pad)'
			local grcolT `"`grcolT' ZZZ"'
			local grcolt `"`grcolt' `title'"'
			local grcpad `grcpad' `pad'
			local grcolf `grcolf' `clfmt'
			local ++grncols
			local grcolws `wid'
			local tmp = `wid'
			local grcolw = `grcolw' + `tmp'
			local grcolsfmt `grcolsfmt' `clsfmt'
			local grcoltfmt `grcoltfmt' %`wid's
			local grcolv `grcolv' `grvar'
		}
		if `"`cvar'"' != "" {
			local classification noclassification
			local cltitle `""`cvar' ""'
			if "`nocstar'" == "" & "`nogroup'" != "" & ///
							"`looclass'" == "" {
				local grcolT `"`grcolT' ZZZ ZZZ"'
			}
			else if "`nocstar'" != "" & "`nogroup'" != "" &	///
							"`looclass'" == "" {
				local grcolT `"`grcolT' ZZZ"'
			}
			else if "`nocstar'" == "" {
				local grcolT `"`grcolT' "Class. " ZZZ"'
			}
			else {
				local grcolT `"`grcolT' "Class. " "'
			}
		}
		if `"`classification'"'!="noclassification" {
			tempname cvar
			qui predict long `cvar' if `touse' , ///
				classification `ties' `priors' `predopts'
			local cltitle `""Class. ""'
			if "`nocstar'" == "" {
				local grcolT `"`grcolT' ZZZ ZZZ"'
			}
			else {
				local grcolT `"`grcolT' ZZZ"'
			}
		}
		local starcount 0
		if "`cvar'" != "" {
			local ocvar `cvar'
			if `"`labels'"' != "nolabels" & "`vlab'" != ""{
				label values `cvar' `vlab'
				tempname cv2
				qui decode `cvar' if `touse', ///
					generate(`cv2') maxlength(`min')
				local cvar `cv2'
			}
			if "`nocstar'" == "" {
				tempname cstar
				qui gen str1 `cstar' = " "  if `touse'
				qui replace `cstar' = "*" if 		///
					`cvar' != `grvar' & `touse' &	///
					 !missing(`grvar') & !missing(`cvar')
				qui count if `cvar' != `grvar' & `touse' & ///
					 !missing(`grvar') & !missing(`cvar')
				local starcount = `starcount' + r(N)
			}
			FormatTool `clfmt' `min' `classpad'
			local wid `s(wid)'
			local pad `s(pad)'
			if "`nocstar'" == "" {
				local grcolt `"`grcolt' `cltitle' ZZZ"'
				local grcpad `grcpad' `pad' 0
				local grcolf `grcolf' `clfmt' .
				local grcolv `grcolv' `cvar' `cstar'
				local grncols = `grncols' + 2 // cstar variable
				local grcolws `grcolws' `wid' 2
				local grcolw = `grcolw' + `wid' + 2
				local grcolsfmt `grcolsfmt' `clsfmt' %2s
				local grcoltfmt `grcoltfmt' %`wid's %2s
				if "`nogroup'" != "" {
					local grSuperTitle ///
						`"`grSuperTitle' ZZZ"'
				}
				else local grSuperTitle ///
						`"`grSuperTitle' ZZZ ZZZ"'
				local grcolwAcc `grcolwAcc' `wid' 2
			}
			else {
				local grcolt `"`grcolt' `cltitle'"'
				local grcpad `grcpad' `pad'
				local grcolf `grcolf' `clfmt'
				local grcolv `grcolv' `cvar'
				local grncols = `grncols' + 1
				local grcolws `grcolws' `wid'
				local grcolw = `grcolw' + `wid'
				local grcolsfmt `grcolsfmt' `clsfmt'
				local grcoltfmt `grcoltfmt' %`wid's
				if "`nogroup'" != "" {
					local grSuperTitle `"`grSuperTitle'"'
				}
				else local grSuperTitle `"`grSuperTitle' ZZZ"'
				local grcolwAcc `grcolwAcc' `wid'
			}
		}
		if `"`looclass'"'!= "" {
			if "`lcvar'" == "" {
				tempname lcvar
				qui predict long `lcvar' if `touse' , ///
					looclass `ties' `priors' `predopts'
				if "`nocstar'"=="" {
					local cltitle LOO Cl.
				}
				else {
					local cltitle LOO Cl
				}
			}
			else local cltitle `lcvar'
			local olcvar `lcvar'
			if `"`labels'"' != "nolabels" & "`vlab'" != ""{
				label values `lcvar' `vlab'
				tempname cv2
				qui decode `lcvar' if `touse', ///
					generate(`cv2') maxlength(`min')
				local lcvar `cv2'
			}
			if "`nocstar'"=="" {
				tempname lcstar
				qui gen str1 `lcstar' = " " if 		///
						`lcvar' == `grvar' & `touse'
				qui replace `lcstar' = "*" if		///
					`lcvar' != `grvar' & `touse' &	///
							!missing(`grvar') ///
							& !missing(`lcvar')
				qui count if `lcvar' != `grvar' &	///
							!missing(`grvar') ///
							& `touse' ///
							& !missing(`lcvar')
				local starcount = `starcount' + r(N)
			}
			FormatTool `clfmt' `min' `classpad'
			local wid `s(wid)'
			local pad `s(pad)'
			local colwT = `colwT' + `wid'
			if "`nocstar'" == "" {
				local grcolt `"`grcolt' "`cltitle' " ZZZ"'
				local grcpad `grcpad' `pad' 0
				local grcolf `grcolf' `clfmt' .
				local grcolv `grcolv' `lcvar' `lcstar'
				local grncols = `grncols' + 2 // lcstar variable
				local grcolws `grcolws' `wid' 2
				local tmp = 2
				local grcolw = `grcolw' + `wid' + `tmp'
				local grcolsfmt `grcolsfmt' `clsfmt' %2s
				local grcoltfmt `grcoltfmt' %`wid's %2s
				if "`nogroup'" != "" & "`classification'" ///
						== "noclassification" {
					local grSuperTitle ///
						`"`grSuperTitle' ZZZ"'
				}
				else {
					local grSuperTitle ///
						`"`grSuperTitle' ZZZ ZZZ"'
				}
			}
			else {
				local grcolt `"`grcolt' "`cltitle' ""'
				local grcpad `grcpad' `pad'
				local grcolf `grcolf' `clfmt'
				local grcolv `grcolv' `lcvar'
				local grncols = `grncols' + 1
				local grcolws `grcolws' `wid'
				local grcolw = `grcolw' + `wid'
				local grcolsfmt `grcolsfmt' `clsfmt'
				local grcoltfmt `grcoltfmt' %`wid's
				if "`nogroup'" != "" & "`classification'" ///
						== "noclassification" {
					local grSuperTitle `"`grSuperTitle'"'
				}
				else {
					local grSuperTitle ///
						`"`grSuperTitle' ZZZ"'
				}
			}
		}
		if `starcount' > 0 {
			local grnote "* indicates misclassified observations"
		}
	}

// Now handle misclassified option
	if `"`misclassified'"' != "" {
		local holdweight `weight'
		local weight
		if "`grvar'" == "" & "`e(groupvar)'" == "" {
			di as err ///
			    "option {bf:misclassified} requires a group variable"
			exit 459
		}
		if "`cvar'" == "" & "`lcvar'" == "" {
			// currently have no classification, so get one
			tempname cvar
			qui predict long `cvar' if `touse' , ///
				classification `ties' `priors' `predopts'
		}
		else {
			local cvar `ocvar'
			local lcvar `olcvar'
		}
		local gp `ogrvar'
		if "`gp'" == "" {
			local gp `e(groupvar)'
			confirm variable `gp'
		}
		local oldtouse `touse'
		local if if `oldtouse' & 
		if "`cvar'" != "" {
			confirm variable `cvar'
			local if  `if' (`cvar' != `gp'
		}
		if "`lcvar'" != "" {
			confirm variable `lcvar'
			if "`cvar'" == "" {
				local if `if' (`lcvar' != `gp'
			}
			else local if `if' | `lcvar' != `gp'
		}
 		local if `if')
		tempvar newtouse
		mark `newtouse' `if'
		qui count if `newtouse'
		if r(N) ==0 exit
		local touse `newtouse'
		local weight `holdweight'
	}


/* ================PR variables ===================*/
	local prcolw 0
	local prncols 0
	local titles
	if "`prvars'" != "" {
		local pr nopr
		local titles title(`prvars')
	}
	if "`pr'" != "nopr" {
		local ng `e(N_groups)'
		forvalues i = 1/`ng' {
			tempname prvar`i'
			local prvars `prvars' `prvar`i''
		}
		qui predict double `prvars' if `touse', pr `ties' `priors' ///
			`predopts'
	}
	if "`prvars'" != "" {
		if "`prfmt'" == "" {
			local prfmt %6.4f
		}
		local prSuperTitle `" Probabilities"'
		local prSuperTitle `""`prSuperTitle'""'
		local min 15
		ProcessVars `prvars', varfmt(`prfmt')  pr min(`min') 	///
			`labels' `titles'
		local m `s(nvar)'
		local wids `s(wids)'
		local pads `s(pads)'
		local titles `"`s(titles)'"'
		local fmts `s(fmts)'
		local prcolw 1
		forvalues i=1/`m' {
			local ++cols
			local wid : word `i' of `wids'
			local pad : word `i' of `pads'
			local colwT = `colwT' + `wid'
			local prcolT `prcolT' ZZZ
			local prcolt `"`prcolt' `"`:word `i' of `titles''"'"'
			local prcpad `prcpad' `pad'
			local prcolf `prcolf' `: word `i' of `fmts''
			local prcolv `prcolv' `: word `i' of `prvars''
			local ++prncols
			if `i'==1 {
				local prcolws `wid'
			}
			else if `i'==`m' {
				local prcolws `prcolws' `wid'
			}
			else {
				local prcolws `prcolws' `wid'
			}
			local prcolw = `prcolw' + `wid'
			local prcolsfmt `prcolsfmt' .
			local prcoltfmt `prcoltfmt' %`wid's
			if `i'==1 {
				local tmp = `wid' + 1
				local prcolwAcc `prcolwAcc' `tmp'
			}
			else {
				local prSuperTitle `"`prSuperTitle' ZZZ"'
				local tmp `wid'
				if `i'==`m' {
					local tmp = `tmp' + 1
				}
				local prcolwAcc `prcolwAcc' `tmp'
			}

		}
	}
/* =============== loopr ============== */
	local lprcolw 0
	local lprncols 0
	if "`loopr'" != "" {
		if "`lprvars'" == "" {
			local ng `e(N_groups)'
			forvalues i = 1/`ng' {
				tempname lprvar`i'
				local lprvar `lprvar' `lprvar`i''
			}
			qui predict double `lprvar' if `touse', loopr 	///
				`ties' `priors' `predopts'
			local titles
		}
		else{
			 local lprvar `lprvars'
			 local titles title(`lprvars')
		}
	}
	if `"`lprfmt'"' == "" {
		local lprfmt %6.4f
	}
	if "`lprvar'"!= "" {
		local lprSuperTitle `" LOO Probabilities "'
		local lprSuperTitle `""`lprSuperTitle'""'
		local min 20
		ProcessVars `lprvar', varfmt(`lprfmt') pr min(`min')	///
			 `labels' `titles'
		local m `s(nvar)'
		local wids `s(wids)'
		local pads `s(pads)'
		local titles `"`s(titles)'"'
		local fmts `s(fmts)'
		local lprcolw 0
		forvalues i=1/`m' {
			local ++cols
			local wid : word `i' of `wids'
			local pad : word `i' of `pads'
			local colwT = `colwT' + `wid'
			local lprcolT `lprcolT' ZZZ
			local lprcolt `"`lprcolt' `"`: word `i' of `titles''"'"'
			local lprcpad `lprcpad' `pad'
			local lprcolf `lprcolf' `: word `i' of `fmts''
			local lprcolv `lprcolv' `: word `i' of `lprvar''
			local ++lprncols
			local lprcolws `lprcolws' `wid'
			local lprcolw = `lprcolw' + `wid'
			local lprcolsfmt `lprcolsfmt' .
			if `i'==1 {
				local lprcoltfmt `lprcoltfmt' %`wid's
				local lprcolt2fmt `lprcolt2fmt' %-`wid's
				local tmp = `wid' + 1
				local lprcolwAcc `lprcolwAcc' `tmp'
			}
			else {
				local lprcoltfmt `lprcoltfmt' %`wid's
				local lprcolt2fmt `lprcolt2fmt' %`wid's
				local tmp `wid'
				if `i'==`m' {
					local tmp = `tmp' + 1
				}
				local lprcolwAcc `lprcolwAcc' `tmp'
				local lprSuperTitle `"`lprSuperTitle' ZZZ"'
			}
		}
	}

/*============ Now put it all out ===========*/
	if `"`varsfirst'"' != "" {
		local sections v gr pr lpr
	}
	else {
		local sections gr pr lpr v
	}

	// This shouldn't happen, if it does, the identifier was too big
	//	and the user needs to cut it down.

	capture assert `idcolw' < `linesize'
	if _rc {
		di as err "variable identification information " ///
			"is longer than linesize"
		exit 459
	}

	local SuperTitle `"`idSuperTitle'"'
	local ctitle `"`idcolt'"'
	local ctitle2 `"`idcolT'"'
	local cpad `idcpad'
	local cfmt `idcolf'
	local ctfmt `idcoltfmt'
	if `"`idcolt2fmt'"' != "" {
		local ct2fmt `idcolt2fmt'
	}
	else {
		local ct2fmt `idcoltfmt'
	}
	local csfmt `idcolsfmt'
	local cvars `idcolv'
	local ncols = `idncols'
	local cwids |`idcolws'|
	local totwid = `idcolw'+2

	local secno 0
	local last
	local lm 0 // left margin
	noi di "" // blank line
	tempname tab
	.`tab' = ._tab.new
	foreach sec of local sections {
		local ++secno
		if ``sec'colw'==0 {
			local new1 = 0
		}
		else {
			local new1 = ``sec'colw' + `lm' + 1 
		}
		/* if this section plus the id stuff is too much then we are
			going to have to output it column by column ...  */
		if `idcolw' + ``sec'colw' + `lm' + 2 >= `linesize' {
			local cwids `cwids'|
			forv i = 1/``sec'ncols' {
				local totwid = `totwid' +	///
					 `: word `i' of ``sec'colwAcc''
				if `totwid' + `lm' + 2>=`linesize' {
				// put out what we've got now
				_tab_out, tab(`tab') sep(`sep') lm(`lm') ///
					ccol(`ncols') ctitles(`"`ctitle'"') ///
					ctitle2(`"`ctitle2'"') cpad(`cpad') ///
					cwid(`cwids'|) cnfmt(`cfmt')	///
					ctfmt(`ctfmt') ct2fmt(`ct2fmt')	///
					csfmt(`csfmt')	cvars(`cvars')	///
					csup(`"`SuperTitle'"')		///
					cnote(`"`cnote'"')			///
					touse(`touse')
					// start accumulating for next
					// id stuff goes out each time
					.`tab' = ._tab.new
					local alreadyout alreadyout
					local SuperTitle `"`idSuperTitle'"'
					local ctitle `"`idcolt'"'
					local ctitle2 `"`idcolT'"'
					local cpad `idcpad'
					local cfmt `idcolf'
					local ctfmt `idcoltfmt'
					if "`idcolt2fmt'" != "" {
						local ct2fmt `idcolt2fmt'
					}
					else local ct2fmt `idcoltfmt'
					local csfmt `idcolsfmt'
					local cvars `idcolv'
					local ncols = `idncols'
					local cwids |`idcolws'|
					local totwid = `idcolw' + ///
					 	`: word `i' of ``sec'colwAcc''
					if `"``id'note'"' != "" {
						local cnote `"`"``id'note'"'"'
					}
					else {
						local cnote
					}
				}
				local SuperTitle 	///
			`"`SuperTitle' "`:word `i' of ``sec'SuperTitle''""'
				local ctitle		///
				`"`ctitle' "`:word `i' of ``sec'colt''""'
				local ctitle2		///
				`"`ctitle2' `:word `i' of ``sec'colT''"'
				local cpad `cpad' `: word `i' of ``sec'cpad''
				local cfmt `cfmt' `: word `i' of ``sec'colf''
				local ctfmt `ctfmt' 	///
					`: word `i' of ``sec'coltfmt''
				if "``sec'colt2fmt'" != "" {
					local ct2fmt `ct2fmt' 	///
						`:word `i' of ``sec'colt2fmt''
				}
				else {
					local ct2fmt `ct2fmt' 	///
						`:word `i' of ``sec'coltfmt''
				}
				local csfmt `csfmt'	///
					`: word `i' of ``sec'colsfmt''
				local cvars `cvars' `: word `i' of ``sec'colv''
				local ++ncols
				local cwids `cwids'	///
					`: word `i' of ``sec'colws''
				if `i' == 1 { // indentation off
			if `"`cnote'"' != "" {
				if `"``sec'note'"' != "" {
					local cnote `"`cnote' `"``sec'note'"'"'
				}
			}
			else {
				if `"``sec'note'"' != "" {
					local cnote `"`"``sec'note'"'"'
				}
			}
				} // indentation back
			}
		}
		else if `totwid' + `new1' >= `linesize' {
			// next section will fit with id info,
			// but if we add it first, it'll be too long
			// So: put out what we've got now, since next accum
			// would be too much
			_tab_out, tab(`tab') sep(`sep') lm(`lm')	///
				ccol(`ncols') ctitles(`"`ctitle'"')	///
				ctitle2(`"`ctitle2'"') cpad(`cpad')	///
				cwid(`cwids'|) cnfmt(`cfmt') 		///
				ctfmt(`ctfmt') ct2fmt(`ct2fmt') 	///
				csfmt(`csfmt')	cvars(`cvars')		///
				csup(`"`SuperTitle'"') cnote(`"`cnote'"') 	///
				touse(`touse')
			// start accumulating again
			// id stuff goes out each time plus stuff from this
			.`tab' = ._tab.new
			local alreadyout alreadyout
			local SuperTitle `"`idSuperTitle' ``sec'SuperTitle'"'
			local ctitle `"`idcolt' ``sec'colt'"'
			local ctitle2 `"`idcolT' ``sec'colT'"'
			local cpad `idcpad' ``sec'cpad'
			local cfmt `idcolf' ``sec'colf'
			local ctfmt `idcoltfmt' ``sec'coltfmt'
			if `"`idcolt2fmt'"'!="" {
				local ct2fmt `idcolt2fmt'
			}
			else local ct2fmt `idcoltfmt'
			if "``sec'colt2fmt'" != "" {
				local ct2fmt `ct2fmt' ``sec'colt2fmt'
			}
			else local ct2fmt `ct2fmt' ``sec'coltfmt'
			local csfmt `idcolsfmt'	``sec'colsfmt'
			local cvars `idcolv' ``sec'colv'
			local ncols = `idncols' + ``sec'ncols'
			local cwids |`idcolws'| ``sec'colws'
			if `"``id'note'"' != "" {
				local cnote `"`"``id'note'"'"'
			}
			else {
				local cnote
			}
			if `"`cnote'"' != "" {
				if `"``sec'note'"' != "" {
					local cnote `"`cnote' `"``sec'note'"'"'
				}
			}
			else {
				if `"``sec'note'"' != "" {
					local cnote `"`"``sec'note'"'"'
				}
			}
			local totwid = `idcolw' + ``sec'colw' + 1
		}
		else { // we are just adding on to what we already had
			local SuperTitle `"`SuperTitle' ``sec'SuperTitle'"'
			local ctitle `"`ctitle' ``sec'colt'"'
			local ctitle2 `"`ctitle2' ``sec'colT'"'
			local cpad `cpad' ``sec'cpad'
			local cfmt `cfmt' ``sec'colf'
			local ctfmt `ctfmt' ``sec'coltfmt'
			if "``sec'colt2fmt'" != "" {
				local ct2fmt `ct2fmt' ``sec'colt2fmt'
			}
			else local ct2fmt `ct2fmt' ``sec'coltfmt'
			local csfmt `csfmt'	``sec'colsfmt'
			local cvars `cvars' ``sec'colv'
			local ncols = `ncols' + ``sec'ncols'
			local cwids `cwids' |``sec'colws'
			local totwid = `totwid' + ``sec'colw' + 1
			if `"`cnote'"' != "" {
				if `"``sec'note'"' != "" {
					local cnote `"`cnote' `"``sec'note'"'"'
				}
			}
			else {
				if `"``sec'note'"' != "" {
					local cnote `"`"``sec'note'"'"'
				}
			}
		}
	}
// Now put out whatever hasn't gone out already.
if ("`alreadyout'" == "alreadyout" & `"`ctitle'"' != `"`idcolt' "') ///
	| "`alreadyout'" =="" {
	_tab_out, tab(`tab') sep(`sep') lm(`lm') ccol(`ncols')	///
		ctitles(`"`ctitle'"') ctitle2(`"`ctitle2'"') 	///
		cpad(`cpad') cwid(`cwids'|) cnfmt(`cfmt') 	///
		ctfmt(`ctfmt') ct2fmt(`ct2fmt') csfmt(`csfmt')	///
		cvars(`cvars') csup(`"`SuperTitle'"')		///
		cnote(`"`cnote'"') touse(`touse')
}
end

program _tab_out
	syntax	[, TAB(str)	/// tab identifier
		SEP(int 5)	/// separators every 5 lines
		LM(int 0)	/// left margin
		CCol(int 0)	/// # of columns
		ctitles(str)	/// column titles
		ctitle2(str)	/// column titles (above previous)
		CPad(str)	/// column padding
		CWids(str)	/// column widths and separators
		CNFmt(str)	/// column number format
		CTFmt(str)	/// column title (%s) format
		CT2fmt(str)	/// 2nd title format for SuperTitle
		CSFmt(str)	/// string format %s for columns
		CVars(str)	/// column variables
		CSUPtitle(str)	/// supertitle
		CNOTE(str)	/// footnotes
		TOuse(varname)	/// touse variable
		]

	forv i = 1/`ccol' {
		local ignore `ignore' ZZZ
	}
	.`tab'.reset, columns(`ccol') lmargin(`lm') separator(`sep')
	.`tab'.ignore `ignore'
	.`tab'.width `cwids'
	.`tab'.titlefmt `ct2fmt'
	.`tab'.strfmt `csfmt'
	.`tab'.numfmt `cnfmt'
	.`tab'.pad `cpad'
	.`tab'.sep, top
	.`tab'.titles `csuptitle'
	foreach word in  `csuptitle' {
		local blank `blank' ZZZ
	}
	.`tab'.titles `blank'
	.`tab'.titlefmt `ctfmt'
	if strpos(`"`ctitle2'"', "Class.") > 0 {
		.`tab'.titles `ctitle2'
	}
	.`tab'.titles `ctitles'
	.`tab'.sep, middle
	local N = _N
	forv i = 1/`N' {
		if `touse'[`i'] == 1 {
			local tabrow .`tab'.row
			foreach v of local cvars {
				local tabrow `tabrow' `v'[`i']
			}
			`tabrow'
		}
	}
	.`tab'.sep, bottom
	if `"`cnote'"' != "" {
		foreach note of local cnote {
			di `"`note'"'
		}
	}
	di ""
end

// Classification Table
program ClassTable, rclass
	syntax [if] [in] [fw]  [, 	///
		CLass			///
		LOOclass		///
		PRIors(passthru)	///
		TIEs(passthru)		///
		TITle(passthru)		///
		PROBabilities		///
		noPERcents		///
		NOPRIors		///
		noTotals		///
		noROWTotals		///
		noCOLTotals		///
	/// The following are undocumented options
		noGRANDTotal		///
		CVar(varname numeric)	/// classified variable
		PRVars(varlist numeric)	/// posterior probability vars
		noLABELKEY		/// suppress label key
		NOUPdate		/// adv. opt with -looclass- & knn only
	]

	opts_exclusive "`class' `looclass'"

	if "`probabilities'" != "" {
		// row totals and percents are turned off with avg post. probs
		local rowtotals norowtotals
		local percents  nopercents
	}

	local passon `totals' `rowtotals' `coltotals' `grandtotal' `percents'
	local passon `passon' `labelkey'
	if "`looclass'" != ""	local passon `"`passon' clprefix("LOO ")"'

	local isresub 0
	if "`looclass'" == "" {
		marksample tmptouse
		capture assert `tmptouse' == 0 if !e(sample)
		if c(rc) == 0	local isresub 1
		drop `tmptouse'
	}

	local fw [`weight'`exp']

	if "`cvar'" != "" {
		local grpvar `cvar'
	}

	if "`prvars'" != "" & "`probabilities'" == "" {
		di as err "option {bf:prvars()} allowed only with option {bf:probabilities}"
		exit 198
	}

	// assumption here that e(groupvar) is the true group.  For out-of-
	// sample predictions, the user should have a variable with true
	// group labels named the same as was used in the -discrim- call.
	local truegrpvar `e(groupvar)'
	confirm numeric variable `truegrpvar'

	if `"`grpvar'"' != "" & "`class'" != "" {
		di as error "options {bf:class} and {bf:cvar()} may not be specified together"
		exit 198
	}

	if `"`grpvar'"' != "" & "`looclass'" != "" {
		di as error "options {bf:looclass} and {bf:cvar()} may not be specified together"
		exit 198
	}

	if `"`looclass'"' != "" {
		if `"`if'"' != "" {
			local if `if' & e(sample)
		}
		else local if if e(sample)
	}
	if `"`noupdate'"'!= "" & "`e(subcmd)'" != "knn" {
		di as error "option {bf:noupdate} only valid with command {bf:discrim knn}"
		exit 198
	}
	if `"`noupdate'"'!= "" & "`e(mahalanobis)'" == "" {
		di as error "option {bf:noupdate} only valid with Mahalanobis distance"
		exit 198
	}
	if `"`looclass'"' =="" & "`noupdate'"!="" {
		di as error "option {bf:noupdate} only valid with option {bf:looclass}"
		exit 198
	}

	if "`cvar'" != "" {
		/* check that cvar looks like a class. variable for discrim */
		//==================================================//
		marksample touse, novarlist
		discrim prog_utility groups `cvar' `touse'
		tempname ng gvals tgvals
		scalar `ng' = r(N_groups)
		if `ng' > e(N_groups) {
			di as err "{p}variable {bf:`cvar'} not a classification" ///
			    " variable for this discriminant analysis{p_end}"
			exit 459
		}
		matrix `gvals' = r(groupvalues)
		matrix `tgvals' = e(groupvalues)
		mata: _discrim_gvalchk("`gvals'", "`tgvals'", "`cvar'")
		//==================================================//
		if `"`priors'"' != "" & `"`nopriors'"' != "" {
			di as error "{p}when option {bf:cvar()} is specified, option {bf:priors} "	///
				"may not be specified with option {bf:nopriors}{p_end}"
			exit 198
		}
		if `"`priors'"' == "" {
			local nopriors nopriors
		}
	}

	local passon `passon' `priors' `nopriors'

	if `"`looclass'"' != "" & `"`title'"' == "" {
		if "`probabilities'" != "" {
			local title ///
      title(Leave-one-out average-posterior-probabilities classification table)
		}
		else {
			local title title(Leave-one-out classification table)
		}
	}
	else if `"`cvar'"' != "" & `"`title'"' == "" {
		local title title(Classification table of variable `cvar')
	}
	else if "`prvars'" != "" & `"`title'"' == "" {
		local title ///
		    title(Average-posterior-probabilities classification table)
	}
	else if `isresub' & `"`title'"'=="" {
		if "`probabilities'" != "" {
			local title ///
     title(Resubstitution average-posterior-probabilities classification table)
		}
		else {
			local title title(Resubstitution classification table)
		}
	}
	else if `"`title'"'=="" {
		if "`probabilities'" != "" {
			local title ///
		    title(Average-posterior-probabilities classification table)
		}
		else {
			local title title(Classification table)
		}
	}
	local passon `passon' `title'

	if "`grpvar'"=="" {
		if "`looclass'" != "" {
			local predopts `predopts' looclass `noupdate'
		}
		else	local predopts `predopts' classification
		local predopts predopts(`predopts' `ties')
	}

	if "`probabilities'" != "" {
		if "`prvars'" == "" {
			if "`looclass'" != "" {
				local ppo probpredopts(loopr `noupdate')
			}
			else 	local ppo probpredopts(pr)
		}
		else		local ppo prvars(`prvars')
	}

	di ""
	discrim prog_utility classtable `truegrpvar' `grpvar' 	///
			`if' `in' `fw', `passon' `predopts' `ppo'

	return add
end

program ProcessVars, sclass
	syntax varlist [, VARFmt(str) PR VARS MIN(numlist min=1 max=1) ///
		noLabels Titles(str) ]

	local vtype `pr'`vars'
	local i 0
	local n : word count `varlist'
	local infmt `varfmt'
	foreach v of local varlist {
		local ++i
		if "`vtype'" == "vars" {
			if `"`titles'"' != "" {
				local tmp : word `i' of `titles'
				local tmp `tmp'
			}
			else local tmp `v'
		}
		if "`vtype'" == "pr" {
			if "`titles'" != "" {
				local tmp : word `i' of `titles'
			}
			else if "`labels'" == "nolabels" {
				tempname gvmat
				mat `gvmat' = e(groupvalues)
				local tmp = `gvmat'[1,`i']
			}
			else local tmp : word `i' of `e(grouplabels)'
		}
		local tmp = abbrev(`"`tmp'"',10)
		local minv = max(strlen(`"`tmp'"')+2, ceil(`min'/`n'))
		local tmp `"" `tmp' ""'
		local colt `"`colt' `tmp'"'
		if "`infmt'" == "" {
			local varfmt : format `v'
		}
		FormatTool `varfmt' `minv' 1
		local pad `pad' `s(pad)'
		local wid `wid' `s(wid)'
		local fmts `fmts' `varfmt'
	}
	sreturn local nvar `i'
	sreturn local pads `pad'
	sreturn local wids `wid'
	sreturn local titles `"`colt'"'
	sreturn local fmts `fmts'
end

program FormatTool, sclass
	args fmt min pad
	if "`pad'" == "" {
		local pad 0
	}
	tokenize `"`fmt'"', parse("%,.sxgfHLe")
	capture confirm integer number `2'
	if _rc {
		if "`2'" == "tc" {
			local wid = 19 + `pad'
			local lf 18
		}
		else {
			local wid = 9 + `pad'
			local lf 8
		}
	}
	else {
		local lf `2'
		local wid = `2' + `pad' + 1
	}
	if `wid' < `min' {
		local wid `min'
	}
	local wd = `wid' - `lf' - 1
	local pad `wd'
	sreturn local pad `pad'
	sreturn local wid `wid'
end

program define FormatChk
	args format optname blankok
	if `"`blankok'"' == "blankok" & `"`format'"' == "" {
		exit
	}
	capture confirm format `format'
	if _rc {
		di as err "option {bf:`optname'()}: invalid format"
		exit 198
	}
end

program ChkIfEMat
	foreach ename of local 0 {
		capture confirm matrix e(`ename')
		if c(rc) {
			di as err "matrix e(`ename') not found"
			exit 322
		}
	}
end

program ChkIfEInt
	foreach ename of local 0 {
		capture confirm integer number `e(`ename')'
		if c(rc) {
			di as err "integer valued e(`ename') not found"
			exit 322
		}
	}
end

program ChkIfEVars
	args ename howmany
	local what `e(`ename')'
	if "`what'" == "" {
		di as err "e(`ename') not found"
		exit 322
	}
	local cnt : list sizeof what
	if `cnt' != `howmany' {
		di as err "e(`ename') has `cnt' " plural(`cnt', "element") ///
			" not `howmany'"
		exit 322
	}
	capture confirm variable `what'
	if c(rc) {
		di as err "e(`ename') does not contain current variable names"
		exit 322
	}
end
