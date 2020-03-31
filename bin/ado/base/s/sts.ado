*! version 8.6.0  19feb2019
program define sts, sort
	if _caller() < 10 {
		sts_9 `0'
		exit
	}
	version 6, missing

	st_is 2 analysis
	gettoken cmd : 0, parse(" ,")
	if `"`cmd'"'=="," | "`cmd'"=="" {
		local cmd graph
	}
	else	gettoken cmd 0 : 0, parse(" ,")

	local l = length("`cmd'")
	if bsubstr("list",1,`l')==`"`cmd'"' {
		List `0'
	}
	else if bsubstr("graph",1,`l')=="`cmd'" {
		Graph `0'
	}
	else if bsubstr("generate",1,`l')=="`cmd'" {
		Gen `0'
	}
	else if bsubstr("test",1,`l')=="`cmd'" {
		Test `0'
	}
	else if "`cmd'"=="if" | "`cmd'"=="in" {
		Graph `cmd' `0'
	}
	else {
		di in red "unknown sts subcommand `cmd'"
		exit 198
	}
end

program define Test, rclass
	local wt : char _dta[st_wt]
	if "`wt'"=="pweight" {
		local options "Cox"
	}
	else	local options "Logrank Breslow Cox Wilcoxon TWare Peto"
	syntax varlist [if] [in] /*
	*/ [, `options' BY(string) Detail noSHow TRend /*
	*/ Fh(numlist min=2 max=2) * ]

	if "`trend'"!="" {
		local n: word count `varlist'
		if `n'>1 {
di in red "only one grouping variable allowed for trend tests"
di in red "use egen, group() to generate one group variable"
			exit 198
		}
		confirm numeric variable `varlist'
	}

	if "`by'"!="" {
		di in red "by() not allowed"
		exit 198 
	}
	local by "by(`varlist')"

	local n1 = ("`fh'"!="")+ /*
	*/ ("`breslow'"!="")+("`wilcoxo'"!="")+("`tware'"!="")+("`peto'"!="")
	if `n1'+("`cox'"!="")+("`logrank'"!="")>1 {
		di in red /*
	    */ "options logrank, wilcoxon, tware, peto, fh and cox are alternatives"
		di in red "they may not be specified together"
		exit 198
	}
	if "`wilcoxo'"!="" {
		local cmd "wilc_st"
	}
	else if "`cox'"!="" | "`wt'"=="pweight" {
		if "`trend'"~="" {
			di in red "trend not valid with option cox or pweight"
			exit 198
		}
		local cmd "ctst_st"
	}
	else if "`tware'"~="" {
		local cmd "tware_st"
	}
	else if "`peto'"~="" {
		local cmd "peto_st"
	}
	else if "`fh'"~="" {
		local cmd "fh_st"
		tokenize `fh'
		if `1'<0 | `2'<0 {
			noi di in red "p and q must be nonnegative"
			exit 198	
		}
		local p="p(`1')"
		local q="q(`2')"

	}
	else	local cmd "logrank"

	st_show `show'
	tempvar touse
	st_smpl `touse' `"`if'"' "`in'"

	if "`cmd'"=="ctst_st" {
		tempname oldest 
		capture {
			capture estimate hold `oldest'
			noisily `vv' `cmd' `varlist' if `touse', `options'
			ret add
		}
		local rc = _rc
		capture estimate unhold `oldest'
		exit `rc'
	}

	local w  : char _dta[st_w]
	if `"`_dta[st_id]'"' != "" {
		local id `"id(`_dta[st_id]')"'
	}
	`vv' `cmd' _t _d `w' if `touse', /*
		*/ t0(_t0) `id' `by' `options' `detail' `trend' `p' `q'
	ret add
	if ("`fh'"!="")+("`tware'"!="")+("`peto'"!="")>0 {
		ret local by
	}
end



/* 
	gen var=thing [var=thing] ...
*/

program define Gen

	local rest `"`0'"'
	gettoken varname rest : rest, parse(" =,")
	gettoken eqsign  rest : rest, parse(" =,")
	gettoken thing   rest : rest, parse(" =,")

	if `"`eqsign'"' != "=" { error 198 }
	while `"`eqsign'"' == "=" {
		confirm new var `varname'
		local thing = lower(`"`thing'"')

		if `"`thing'"' == "s" {
			local Surv `varname'
		}
		else if `"`thing'"' == "ns" {
			local nSurv "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="se(s)" {
			NotPw "se(s)"
			local Se "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="h" | `"`thing'"'=="dchaz" {
			local Haz "`varname'"
		}
		else if `"`thing'"'=="se(lls)" {
			NotPw "se(lls)"
			local sllS "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="ub(s)" | `"`thing'"'=="ub" {
			NotPw "ub(s)"
			local ub "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="lb(s)" | `"`thing'"'=="lb" {
			NotPw "lb(s)"
			local lb "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="n" {
			local Pop "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="na" | `"`thing'"'=="cumrisk" {
			local Aalen "`varname'"
			local notcox `"`varname'=`thing'"'
			local risk "`thing'"
		}
		else if `"`thing'"'=="se(na)" {
			NotPw "se(na)"
			local saalen "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="ub(na)" {
			NotPw "ub(na)"
			local uba "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="lb(na)" {
			NotPw "lb(na)"
			local lba "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="d" { 
			local Die "`varname'"
			local notcox `"`varname'==`thing'"'
		}
		else {
			di in red `"`thing' unknown function"'
			exit 198
		}
		local 0 `"`rest'"'
		gettoken varname rest : rest, parse(" =,")
		gettoken eqsign  rest : rest, parse(" =,")
		gettoken thing   rest : rest, parse(" =,")
	}

	syntax /* ... */ [if] [in] [,  ADjustfor(varlist) BY(varlist) /*
	       */  Level(cilevel) noSHow STrata(varlist)]

	ByStAdj "`by'" "`strata'" "`adjustf'"

	if "`adjustf'" != "" {
		if "`notcox'" != "" {
			di in red "cannot calculate `notcox' with adjustfor()"
			exit 198
		}
		qui DoAdjust "`by'" "`strata'" "`adjustf'" `"`if'"' "`in'" /*
			*/ -> "`Haz'" "`Surv'"
		if "`Surv'"!="" {
			label var `Surv' "S(t+0), adjusted"
		}
		if "`Haz'"!="" {
			label var `Haz' "Delta_H(t), adjusted"
		}
		exit
	}

	if "`Pop'"=="" { tempvar Pop }
	if "`Die'"=="" { tempvar Die }
	tempvar touse mresult
	st_smpl `touse' `"`if'"' "`in'" "`by'" ""
	preserve 
	quietly {
		keep if `touse'
		st_ct "`by'" -> _t `Pop' `Die' 
		count if `Die'
		if r(N) {		/* keep all obs if no failures */
			keep if `Die'
		}
		AddSurv "`by'" _t `Pop' `Die' `level' -> /* 
		*/ "`Haz'" "" "`Surv'" "`Se'" "`sllS'" "`lb'" "`ub'" /*
		*/ "`Aalen'" "`saalen'" "`uba'" "`lba'" "`nSurv'"
		if "`Haz'" != "" {
			qui sum `Haz', meanonly
			if r(max)==0 {
				qui replace `Haz'=.
			}
		}

		keep `by' _t `Haz' `Surv' `Se' `sllS' `lb' `ub' /*
			*/ `Pop' `Die' `Aalen' `saalen' `uba' `lba' `nSurv'
		gen byte `touse' = 1
		sort `touse' `by' _t
	
		tempfile one 
		save "`one'"
		restore, preserve
		sort `touse' `by' _t 
		merge `touse' `by' _t using "`one'", _merge(`mresult')
		keep if `mresult'==1 | `mresult'==3
		drop `mresult'
		sort `touse' `by' _t 
		local byp "by `touse' `by':"
		if "`Surv'" != "" {
			`byp' replace `Surv' = cond(_n==1,1,`Surv'[_n-1]) /*
				*/ if `Surv'>=. & `touse'
			replace `Surv' = . if `touse'==0
			label var `Surv' "S(t+0)"
		}
		if "`nSurv'" != "" {
			`byp' replace `nSurv' = cond(_n==1,1,`nSurv'[_n-1]) /*
				*/ if `nSurv'>=. & `touse'
			replace `nSurv' = . if `touse'==0
			label var `nSurv' "Modified K-M
		}
		if "`Se'" != "" {
			`byp' replace `Se' = `Se'[_n-1] if `Se'>=. & `touse'
			label var `Se' "se(S) (Greenwood)"
		}
		if "`sllS'" != "" {
			`byp' replace `sllS' = `sllS'[_n-1] if /* 
				*/ `sllS'>=. & `touse'
			label var `sllS' "se(-ln ln S)"
		}
		if "`lb'" != "" {
			`byp' replace `lb' = `lb'[_n-1] if `lb'>=. & `touse'
label var `lb' `"S() `=strsubdp("`level'")'% lower bound"'
		}
		if "`ub'" != "" {
			`byp' replace `ub' = `ub'[_n-1] if `ub'>=. & `touse'
label var `ub' `"S() `=strsubdp("`level'")'% upper bound"'
		}
		if "`Haz'" != "" {
			label var `Haz' "Delta_H(t)"
		}
		if "`Aalen'"!="" {
			`byp' replace `Aalen' = cond(_n==1,0,`Aalen'[_n-1]) /*
				*/ if `Aalen'>=. & `touse'
			replace `Aalen' = . if `touse'==0
			label var `Aalen' "Nelson-Aalen cumulative hazard"
			if "`risk'" == "cumrisk" {
		       		replace `Aalen'=-expm1(-`Aalen') if `touse'
			       label var `Aalen' "Nelson-Aalen cumulative risk"
			}
		}
		if "`saalen'" != "" {
			`byp' replace `saalen' = sqrt(`saalen') 
			`byp' replace `saalen' = `saalen'[_n-1] /*
			*/ if `saalen'>=. & `touse'
			label var `saalen' "se(Nelson-Aalen)"
		}
		if "`lba'" != "" {
			`byp' replace `lba' = `lba'[_n-1] if `lba'>=. & `touse'
label var `lba' `"Nelson-Aalen `=strsubdp("`level'")'% lower bound"'
		}
		if "`uba'" != "" {
			`byp' replace `uba' = `uba'[_n-1] if `uba'>=. & `touse'
label var `uba' `"Nelson-Aalen `=strsubdp("`level'")'% upper bound"'
		}
		label var `Pop' "N, entering population"
		label var `Die' "d, number of failures"
	}
	restore, not
end

program define NotPw /* text */
	if `"`_dta[st_wt]'"' == "pweight" {
		di in red "`*' not possible with pweighted data"
		exit 404
	}
end
		

program define AddSurv /* by t Pop Die lvl -> Haz VHaz Surv Se sllS lb ub */
	args by t N D lvl ARROW h Vh S Se sllS lb ub Aalen saalen uba lba NS
	if "`h'"=="" {
		tempvar h 
	}
	tempvar nh
	gen double `h' = cond(`N'==0,0,`D'/`N')
	gen double `nh' = cond(`N'==0,0,`D'/(`N'+1))
	sort `by' _t
	if "`by'" != "" {
		local byp "by `by':"
	}
	if "`Vh'" == "" {
		tempvar Vh
	}
	gen double `Vh' = cond(`N'==0,0,`D'/(`N'*`N'))
	if "`lba'"!="" | "`uba'"!="" { 
		if "`Aalen'"=="" { tempvar Aalen }
		if "`saalen'"=="" { tempvar saalen }
	}
	if "`Aalen'"!="" {
		`byp' gen double `Aalen' = `h'
		`byp' replace `Aalen' = `Aalen'[_n-1]+`h' if _n>1
	}
	if "`saalen'"!="" {
		tempvar sh
		gen double `sh' =  cond(`N'==0,0,`D'/(`N'^2))
		`byp' gen double `saalen' = `sh'
		`byp' replace `saalen' = `saalen'[_n-1]+`sh' if _n>1
	}
	if "`lba'"!="" | "`uba'"!="" {
		
		local z = invnorm(1-(1-`lvl'/100)/2)
		tempvar phi
		gen double `phi'=(sqrt(`saalen')/`Aalen') if `Aalen'!=0
		if "`lba'" != "" {
			gen double `lba'=(`Aalen')*exp(-`z'*`phi')
			replace `lba'=0 if `lba'<0
		}
		if "`uba'"!="" {
			gen double `uba'=(`Aalen')*exp(`z'*`phi')
		}
	}
	if "`Se'"!="" | "`lb'"!="" | "`ub'"!="" { 
		if "`S'"=="" { tempvar S }
		if "`lb'"!="" | "`ub'"!="" {
			if "`sllS'"=="" { tempvar sllS }
		}
	}
	if "`S'" != "" {
		`byp' gen double `S' = 1-`h'
		`byp' replace `S' = `S'[_n-1]*(1-`h') if _n>1
	}
	if "`NS'" != "" {
		`byp' gen double `NS' = 1-`nh'
		`byp' replace `NS' = `NS'[_n-1]*(1-`nh') if _n>1
	}
	if "`Se'" != "" {
		`byp' gen double `Se' = /*
		*/ `S'*sqrt(sum(`D'/(`N'*(`N'-`D')))) if `S'!=0
		replace `Se' = . if `S'==1
	}
	if "`sllS'" != "" {
		`byp' gen double `sllS' = sqrt( /*
		*/ sum(`D'/(`N'*(`N'-`D'))) / (sum(ln((`N'-`D')/`N'))^2) )
	}
	if "`lb'"!="" | "`ub'"!="" {
		local z = invnorm(1-(1-`lvl'/100)/2)
		if "`lb'" != "" {
			gen double `lb'=(`S')^(exp(`z'*`sllS')) if `S'!=0
		}
		if "`ub'"!="" {
			gen double `ub'=(`S')^(exp(-`z'*`sllS')) if `S'!=0
		}
	}
end


program define List
	syntax [if] [in] [, SURvival 		/// the default
			    Failure		/// abbr. (backward compatib.)
			    CUMHaz		/// synonym for na
			    NA			/// deprecated syn. for cumhaz
			    ADjustfor(varlist) 	///
			    AT(numlist sort)	///
			    BY(varlist)		/// 
			    STrata(varlist)	///
			    Compare 		///
			    Enter 		///
			    Level(cilevel) 	///
			    noSHow		///
			    SAVing(string asis) ///
			]

	local w  : char _dta[st_w]
	local wt : char _dta[st_wt]
	 
	if `"`cumhaz'"' != "" & `"`na'"' != "" {
		// cumhaz and na are synonyms, 
		//	but only one or the other should be used.
		display as error	///
			"options cumhaz and na may not be combined"
		exit 198
	}
	if `"`saving'"' != "" {
	        ParseSaving `saving'
        	local replace  "`s(replace)'"
        	mata : GetZipFileName()
		tempfile tmpsave
	}
	// mutually exclusive functions
	local exclus `"`survival' `failure' `cumhaz' `na'"' 
	local optcnt : word count `exclus' 
	if `optcnt' > 1 {
		display as error	///
			"options `:word 1 of `exclus'' "	///
			"and `:word 2 of `exclus'' may not be combined"
		exit 198
	}
	// implied survival option
	if `"`survival'`failure'`cumhaz'`na'"' == "" {
		// set the default
		local survival survival
	}
	if "`cumhaz'" != "" & "`adjustf'" != "" {
		display as error	///
			"options adjustfor() and cumhaz may not be combined"
		exit 198
	}	
	if "`na'"!="" & "`adjustf'"!="" {
		display as error	///
			"options adjustfor() and na may not be combined"
		exit 198
	}
	if `"`cumhaz'"' != "" {
		// stick with -na- for backward compatibility
		local na na 
	}
	ByStAdj "`by'" "`strata'" "`adjustf'"
	local sb "`s(sb)'"
	if "`compare'" != "" {
		if "`at'" == "" { 
			local at "10"
		}
		if "`sb'"=="" {
			if "`na'"!="" {
				di in red "compare requires by()"
				exit 198
			}
			di in red "compare requires by() or strata()"
			exit 198
		}
	}


	if "`at'" != "" { 
		Procat `at'
		local at `"`s(at)'"'
	}

	st_show `show'


	tempvar touse  mark n d cens ent  s se lb ub aal saalen uba lba
	st_smpl `touse' `"`if'"' "`in'" "`sb'" "`adjustf'"
	preserve
	quietly {
		keep if `touse'
		if "`adjustf'"=="" {
			st_ct "`by'" -> _t `n' _d `cens' `ent'
			if "`enter'"=="" {
				replace `cens' = `cens' - `ent'
				drop if _d==0 & `cens'==0
				replace `ent' = 0 
			}
			AddSurv "`by'" _t `n' _d `level' -> /* 
		       */ "" "" `s' `se' "" `lb' `ub' `aal' `saalen' `uba' `lba'
		}
		else {
			DoAdjust "`by'" "`strata'" "`adjustf'" "" "" -> "" `s'
			KeepDead "`sb'"
		}
		if "`failure'" != "" {
                        replace `s'=1-`s'
			if "`adjustf'"=="" {
				replace `lb'=1-`lb'
				replace `ub'=1-`ub'
				local hold "`lb'"
				local lb "`ub'"
				local ub "`hold'"
			}
		}
		if "`na'" != "" {
			replace `s'=`aal'
			replace `lb'=`lba'
			replace `ub'=`uba'
			replace `se'=sqrt(`saalen')
			drop `aal' `lba' `uba' `saalen'
		}
	}

	if "`sb'"!="" {
        	quietly {
			tempvar grp
			by `sb': gen `grp'=1 if _n==1
			replace `grp' = sum(`grp')
		}
	}


	if "`compare'"!="" { 
		Reat _t `at'
		if "`s(at)'"!="" {
			local at "`s(at)'"
		}
		if "`adjustf'"=="" {
			drop `n' _d `cens' `ent' `se' `lb' `ub'
		}
		if "`na'"!="" {
			local failure "aalen"
		}
		Licomp "" "`sb'" "`grp'" _t `s' "`at'" "`failure'" /*
			*/ "`adjustf'" `"`tmpsave'"'
                if `"`saving'"' != "" {
			use `"`tmpsave'"', clear
			qui save `"`newfile'"', `replace'
			restore
		}
		exit
	}
	if "`na'"!="" {
		local ttl "Nelson-Aalen"
		local blnk " "
	}	
	else if "`failure'"!="" { 
		local ttl "Failure"
		local blnk " "
		local attl " Adjusted Failure Function"
	}
	else {
		local ttl "Survivor"
		local attl "Adjusted Survivor Function"
	}

	if "`at'"!="" {
		Reat _t `at'
		if "`s(at)'"!="" {
			local at "`s(at)'"
		}
		if "`adjustf'"=="" {
			Listat "`sb'" "`grp'" _t `n' _d `cens' `ent' /*
			*/ `s' `se' `lb' `ub' "`at'" /*
			*/ `"`=strsubdp("`level'")'"' "`ttl'" `"`tmpsave'"' /*
			*/ "`wt'" "`failure'"
		}
		else	Listata "`sb'" "`grp'" _t `s' "`at'" /*
			*/ "`ttl'" "`blnk'" "`adjustf'" `"`tmpsave'"' "`failure'"
                if `"`saving'"' != "" {
                        use `"`tmpsave'"', clear
                        qui save `"`newfile'"', `replace'
                        restore
                }
		exit
	}


	if "`adjustf'"=="" {
		if "`enter'"!="" {
			local ettl "Enter"
			local liste 1
		}
		else {
			qui drop if _t==0
			local ettl "     "
			local liste 0
			local net "Net"
		}
		local cil `=string(`level')'
		local cil `=length("`cil'")'
		if `cil' == 2 {
			local spaces "     "
		}
		else if `cil' == 4 {
			local spaces "   "
		}
		else {
			local spaces "  "
		}
		if "`wt'"!="pweight" {
			if "`na'"=="" {
				di in gr _n _col(12) "Beg." _col(26) "`net'" /*
				*/ _col(41) "`ttl'" _col(55) "Std." _n /*
				*/ "  Time    Total   Fail   Lost  `ettl'" /*
				*/ _col(41) /*
*/ `"Function     Error`spaces'[`=strsubdp("`level'")'% Conf. Int.]"'
				local dupcnt 79
			}
			else {
				di in gr _n _col(12) "Beg." _col(26) "`net'" /*
				*/ _col(39) "`ttl'" _col(55) "Std." _n /*
				*/ "  Time    Total   Fail   Lost  `ettl'" /*
				*/ _col(41) /*
*/ `"Cum. Haz.    Error`spaces'[`=strsubdp("`level'")'% Conf. Int.]"'
				local dupcnt 79
			}
		}
		else  {
			di in gr _n _col(12) "Beg." _col(26) "`net'" /*
			*/ _col(39) "`ttl'" _n /*
			*/ "  Time    Total   Fail   Lost  `ettl'" /*
			*/ _col(41) "Function"
			local dupcnt 48
		}
	}
	else { 
		di in gr _n "               Adjusted" /*
		*/ _n "  Time    `blnk'`ttl' Function"
		local dupcnt 27
	}
	di in smcl in gr "{hline `dupcnt'}"

	local i 1
	while `i' <= _N {
		if "`sb'" != "" {
			if `grp'[`i'] != `grp'[`i'-1] {
				sts_sh `grp' "`grp'[`i']" "`sb'"
				di in gr "$S_3"
			}
		}
		if "`adjustf'"=="" {
			di in gr %6.0g _t[`i'] " " in ye /*
			*/ %8.0g `n'[`i'] " " /*
			*/ %6.0g (_d[`i']) " " /*
			*/ %6.0g `cens'[`i'] " "  _c 
			if `liste' {
				di in ye %6.0g `ent'[`i'] _c
			}
			else	di _skip(6) _c
			di in ye " " /*
			*/ %11.4f `s'[`i'] " " _c
			if "`wt'"!="pweight" {
				di in ye /*
				*/ %9.4f  `se'[`i'] /* standard error */ " " /*
				*/ %10.4f `lb'[`i'] /* lower cb */ " " /*
				*/ %9.4f `ub'[`i'] /* upper cb */
			}
			else	di
		}
		else {
			di in gr %6.0g _t[`i'] "     " in ye /* 
			*/ %11.4f `s'[`i']
		}
		local i = `i'+1
	}
	di in smcl in gr "{hline `dupcnt'}"
	if "`adjustf'" != "" {
		di in gr "`ttl' function adjusted for `adjustf'"
	}
	if `"`saving'"' != "" {
		if "`adjustf'" == "" {
			if `liste' {
				SaveList _t `n' _d `cens' `s' `se' `lb' `ub', /*
				*/ saving(`"`tmpsave'"') `failure' `na' /*
				*/ by(`by') enter(`ent') level(`level') wt(`wt')  
			}
			else {
				SaveList _t `n' _d `cens' `s' `se' `lb' `ub', /*
                        	*/ saving(`"`tmpsave'"') `failure' `na' /*
				*/ by(`by') level(`level') wt(`wt')
			}
		}
		else {
			SaveList _t `s', saving(`"`tmpsave'"') `failure'  /*
			*/ by(`by') adjustf(`adjustf') strata(`strata') /*
			*/ level(`level') wt(`wt')
		}
                capture use `"`tmpsave'"', clear
                if c(rc) {
                        if inrange(c(rc),900,903) {
                                di as err ///
                        "insufficient memory to load file with results"
                        }
                        restore
                        error c(rc)
                }
                qui save `"`newfile'"', `replace'
                restore
	}
end

program SaveList
	preserve
	syntax varlist, SAVing(string) [NA Failure by(varlist) /*
		*/ adjustf(varlist) strata(varlist) level(cilevel) /*
		*/ enter(varlist) wt(string)]
	keep `by' `strata' `varlist' `enter'
	order `by' `strata' `varlist' 
	if "`enter'" != "" {
		move `enter' `5'
		rename `enter' enter
		label variable enter "Enter"
	} 
	tokenize `varlist'
	if "`adjustf'" == "" {
		rename `1' time
		label variable time "Time"
		rename `2' begin
		label variable begin "Beg. Total"
		rename `3' fail
		label variable fail "Fail"
		if "`enter'" != "" {
                        rename `4' lost
                        label variable lost "Lost"
		}
		else {
 			rename `4' net_lost
  			label variable net_lost "Net Lost"
		}
  		if "`failure'" != "" {
     			rename `5' failure
  			label variable failure "Failure Function"
		}
        	if "`na'" != "" {
        	        rename `5' cumhaz
        	        label variable cumhaz "Nelson-Aalen Cum. Haz. Function"
		}
		if "`failure'" == "" & "`na'" == "" {
			rename `5' survivor
  			label variable survivor "Survivor Function"
		}
  		rename `6' std_err
		label variable std_err "Std. Error" 
		rename `7' lb
		label variable lb "Lower Bound of `level'% Conf. Int."
        	rename `8' ub
        	label variable ub "Upper Bound of `level'% Conf. Int."
		if "`wt'"=="pweight" {
			drop std_err lb ub
		}
	}
	else {
		rename `1' time
		label variable time "Time"
		if "`failure'" != "" {
			rename `2' failure
			label variable failure "Adjusted Failure Function"
		}
		if "`failure'" == "" {
                        rename `2' survivor
                        label variable survivor "Adjusted Survivor Function"
		}
	}
	sort `by' `strata' time
	label data
	qui save `"`saving'"'
	restore
end


program define GetVal /* grpvar g# var maxlen */
	args grp g v maxlen


	tempvar obs newv
	quietly {
		gen `c(obs_t)' `obs' = _n if `grp'==`g'

		summ `obs', mean
		local j = r(min)

		local typ : type `v'
		if (bsubstr("`typ'", 1, 3)=="str") {
			local val : di udsubstr(`v'[`j'], 1, 255)
		}
		else {
			local val = `v'[`j']
		}

		global S_2
		if bsubstr("`typ'",1,3)!="str" {
			local lbl : value label `v'
			if "`lbl'" != "" {
				local val : label `lbl' `val'
			}
			else {
				global S_2 "`v'="
				local val=string(`val')
			}
		}
		global S_1 = udsubstr(trim("`val'"),1,`maxlen')
	}
end


program define sts_sh /* grp g# <byvars> */
	args grp g by

	tokenize "`by'"
	global S_3
	while "`1'" != "" {
		GetVal `grp' `g' `1' 20
		global S_3 "$S_3$S_2$S_1 "
		* di in gr "$S_2$S_1 " _c
		mac shift
	}
	* di
end

program define Reat /* t <processed at-list> */, sclass
	sret clear
	if "`2'"!="reat" {
		exit
	}
	quietly { 
		local t "`1'"
		local n = `3'
		local n = cond(`n'-2<1, 1, `n'-2)
		qui summ _t if _t!=0
		local tmin = r(min)
		local tmax = r(max)
		local dt = (`tmax' -`tmin')/`n'
		if `dt'>=1 {
			local dt = int(`dt')
		}
		local v = int(`tmin')
		/* s(at) contains nothing right now */
		while `v' < `tmax' {
			sret local at "`s(at)' `v'"
			local v = `v' + `dt'
		}
		sret local at "`s(at)' `v'"
	}
end
	

program define Procat /* at-list */, sclass
	sret clear
	local i : word count `0'
	if `i'==1 {
		capture confirm integer numb `0'
		if _rc == 0 { 
			capture assert `0' >= 1
		}
		if _rc {
			di in red `"at(`0') invalid"'
			exit 198
		}
		sret local at "reat `0'"
	}
	else	sret local at `"`0'"'
end


program define Listata
	args by grp t s at ttl blnk adjustf saving failure

	if "`by'"!="" {
		local byp "by `by':"
	}
	di in gr _n "                  Adjusted"
	di in smcl in gr /*
	*/ "    Time    `blnk'`ttl' Function" _n "{hline 29}"

	if "`grp'"=="" {
		tempvar grp
		qui gen byte `grp' = 1
		local ngrp 1
	}
	else {
		qui summ `grp'
		local ngrp = r(max)
	}
        if `"`saving'"' != "" & `"`by'"' != ""{
                tokenize `"`by'"'
		while "`1'" != "" {
			local bytype: type `1'
			local bypost "`bypost' `bytype' `1'"
			mac shift
		}
	}
        if `"`saving'"' != "" {
                tempname memhold
                capture postclose `memhold'
                if "`ttl'"=="Survivor" {
                        postfile `memhold' `bypost' time survivor ///
                        	using `"`saving'"'
                }
                else if "`ttl'"=="Failure" {
                        postfile `memhold' `bypost' time failure ///
				using `"`saving'"'
                }
                else {
                        postfile `memhold' `bypost' time cumhaz ///
				using `"`saving'"'
                }
        }

	tempvar obs
	local g 1
	while `g' <= `ngrp' {
		/* set i0, i1: bounds of group */
		qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
		qui summ `obs'
		local i0 = r(min)
		local i1 = r(max)
		drop `obs'

		if "`by'" != "" {
			sts_sh `grp' `g' "`by'"
			di in gr "$S_3"
		}

                if `"`saving'"' != "" & `"`by'"' != ""{
                        tokenize `"`by'"'
                        while "`1'" != "" {
                                qui levelsof `1' if `grp'==`g', local(val)
				local val: subinstr local val "`" ""
				local val: subinstr local val "'" ""
                                local byval "`byval' (`val')"
                                mac shift
                        }
                }

		tokenize "`at'"
                local z = cond("`failure'"=="",1,0)
		local j 1
		while "``j''" != "" {
			qui gen `c(obs_t)' `obs' = _n if _t>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(r(min)>=.,`i1',r(min)-1)
			drop `obs'
               		if `i'<`i0' {
				di in gr %8.0g ``j'' "     " in ye /* 
				*/ %11.4f `z'
                                if `"`saving'"' != "" {
                                        post `memhold' `byval' (``j'') (`z')
                                }
			}
			else if `i'==`i1' & ``j''>_t[`i1'] {
				di in gr %8.0g ``j'' "     " in ye /*
				*/ %11.4f .
                                if `"`saving'"' != "" {
                                        post `memhold' `byval' (``j'') (.)
                                }
			}
			else {
				di in gr %8.0g ``j'' "     " in ye /*
				*/ %11.4f `s'[`i']
                                if `"`saving'"' != "" {
                                        post `memhold' `byval' (``j'') /*
						*/ (`s'[`i'])
                                }
			}
			local j=`j'+1
		}
		local g=`g'+1
		local byval ""
	}
	di in smcl in gr "{hline 29}" _n /*
	*/  "`ttl' function adjusted for `adjustf'"

        if `"`saving'"' != "" {
                postclose `memhold'
                preserve
                capture use `"`saving'"', clear
                if c(rc) {
                        if inrange(c(rc),900,903) {
                                di as err ///
                        "insufficient memory to load file with results"
                        }
                        restore
                        error c(rc)
                }
		label variable time "Time"
                if "`ttl'"=="Survivor" {
                        label variable survivor "Adjusted Survivor Function"
                }
                else if "`ttl'"=="Failure" {
                        label variable failure "Adjusted Failure Function"
                }
                qui save `"`saving'"', replace
                restore
        }
end



program define Listat
	args by grp t n d cens ent s se lb ub at level ttl saving wt failure
	/* ttl is "Survival" "Failure" "Nelson-Aalen" */

	if "`by'"!="" {
		local byp "by `by':"
	}
	quietly {
		`byp' replace _d=sum(_d)
		`byp' replace `cens'=sum(`cens')
		`byp' replace `ent' = sum(`ent')
	}
	if "`ttl'"=="Nelson-Aalen" {
		local pos 39
		local func "Cum. Haz."
	}
	else {  
		local pos 41
		local func "Function "
	}
        if `"`saving'"' != "" & `"`by'"' != ""{
                tokenize `"`by'"'
                while "`1'" != "" {
                        local bytype: type `1'
                        local bypost "`bypost' `bytype' `1'"
                        mac shift
                }
        }
        if `"`saving'"' != "" {
		tempname memhold
		capture postclose `memhold'i
		if "`wt'" != "pweight" {
			if "`ttl'"=="Survivor" {
				postfile `memhold' `bypost' time begin fail /*
                             		*/ survivor std_err lb ub /*
					*/ using `"`saving'"'
              		}
             		else if "`ttl'"=="Failure" {
                 		postfile `memhold' `bypost' time begin fail /*
                        		*/ failure std_err lb ub /*
					*/ using `"`saving'"'
              		}
           		else {
           		postfile `memhold' `bypost' time begin fail /*
                         	*/ cumhaz std_err lb ub using `"`saving'"'
          		}
		}
		else {
                        if "`ttl'"=="Survivor" {
                                postfile `memhold' `bypost' time begin fail /*
                                        */ survivor using `"`saving'"'
                        }
                        else if "`ttl'"=="Failure" {
                                postfile `memhold' `bypost' time begin fail /*
                                        */ failure using `"`saving'"'
                        }
                        else {
                        postfile `memhold' `bypost' time begin fail /*
                                */ cumhaz using `"`saving'"'
                        }
		}
   	}

	if "`wt'" != "pweight" {
		di in smcl in gr _n _col(15) "Beg." /*
		*/ _col(`pos') "`ttl'" _col(55) "Std." _n /*
		*/ "    Time     Total     Fail" /*
*/ _col(41) `"`func'    Error     [`=strsubdp("`level'")'% Conf. Int.]"' _n /* 
		*/ "{hline 79}"
	}
	else{
                di in smcl in gr _n _col(15) "Beg." /*
                */ _col(`pos') "`ttl'" _n /*
                */ "    Time     Total     Fail" /*
		*/ _col(41) `"`func'"' _n /* 
                */ "{hline 48}"
	}

	if "`grp'"=="" {
		tempvar grp
		qui gen byte `grp' = 1
		local ngrp 1
	}
	else {
		qui summ `grp'
		local ngrp = r(max)
	}

	tempvar obs
	local g 1
	while `g' <= `ngrp' {
		/* set i0, i1: bounds of group */
		qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
		qui summ `obs'
		local i0 = r(min)
		local i1 = r(max)
		drop `obs'
		if `"`saving'"' != "" & `"`by'"' != ""{
                	tokenize `"`by'"'
                	while "`1'" != "" {
                                qui levelsof `1' if `grp'==`g', local(val)
                                local val: subinstr local val "`" ""
                                local val: subinstr local val "'" ""
                                local byval "`byval' (`val')"
                                mac shift
                	}
		}

		if "`by'" != "" {
			sts_sh `grp' `g' "`by'"
			di in gr "$S_3"
		}
		
		tokenize "`at'"
		local lfail 0
                local z = cond("`failure'"=="",1,0)
		local j 1
		while "``j''" != "" {
			qui gen `c(obs_t)' `obs' = _n if _t>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(r(min)>=.,`i1',r(min)-1)
			drop `obs'
			if `i'<`i0' {
				di in gr %8.0g ``j'' "  " in ye /*
				*/          /*
				*/ %8.0g 0 " " /*
				*/ %8.0g 0 " " /*
				*/ _skip(8) /* 
				*/ %11.4f `z' " " _c
				if "`wt'"!="pweight" {
					di in ye %9.4f  . " " /*
					*/ %10.4f . " " /*
					*/ %9.4f .
				}
				else {
					di
				}
				if `"`saving'"' != ""{
					if "`wt'" != "pweight" {
						post `memhold' `byval' /* 
							*/ (``j'') (0) (0) /*
							*/ (`z') (.) (.) (.)
					}
					else {
						post `memhold' `byval' /* 
                                                        */ (``j'') (0) (0) (`z')
					}
				}
			}
			else if `i'==`i1' & ``j''>_t[`i1'] {
				local ifail = _d[`i'] - `lfail'
				local lfail = _d[`i'] 
				di in gr %8.0g ``j'' "  " in ye /*
				*/          /*
				*/ %8.0g `n'[`i'] " " /*
				*/ %8.0g `ifail' " " /*
				*/ _skip(8) /*
				*/ %11.4f . " " _c
                                if "`wt'"!="pweight" {
					di in ye %9.4f  . " " /*
					*/ %10.4f . " " /*
					*/ %9.4f .
				}
				else {
					di
				}
                                if `"`saving'"' != "" {
					if "`wt'" != "pweight" {
                                        	post `memhold' `byval' /* 
						*/ (``j'') (`n'[`i']) /*
						*/ (`ifail') /*
						*/ (.) (.) (.) (.)
					}
					else {
						post `memhold' `byval' /* 
                                                */ (``j'') (`n'[`i']) /*
                                                */ (`ifail') (.)
					}
                                }
			}
			else {
				local ifail = _d[`i'] - `lfail'
				local lfail = _d[`i']
				di in gr %8.0g ``j'' "  " in ye /*
				*/          /*
				*/ %8.0g `n'[`i'] " " /*
				*/ %8.0g `ifail' " " /*
				*/ _skip(8) /* 
				*/ %11.4f `s'[`i'] " " _c
                                if "`wt'"!="pweight" {
                                        di in ye %9.4f  `se'[`i'] " " /*
					*/ %10.4f `lb'[`i'] " " /*
					*/ %9.4f `ub'[`i']
				}
				else {
					di
				}
                                if `"`saving'"' != "" {
					if "`wt'" != "pweight" {
                                        	post `memhold' `byval' /* 
							*/ (``j'') (`n'[`i']) /*
                                                	*/ (`ifail') /*
                                                	*/ (`s'[`i']) /* 
							*/ (`se'[`i']) /*
							*/ (`lb'[`i'] ) /*
							*/ (`ub'[`i'])
					}
					else {
						post `memhold' `byval' /* 
                                                        */ (``j'') (`n'[`i']) /*
                                                        */ (`ifail') /*
                                                        */ (`s'[`i'])
					}
                                }
			}
			local j=`j'+1
		}
		local g=`g'+1
		local byval ""
	}
	if "`wt'" != "pweight" {
		di in smcl in gr "{hline 79}"
		local p4 81
	}
	else {
		di in smcl in gr "{hline 48}"
		local p4 50
	}
	di in smcl in gr "{p 0 6 2 `p4'}"
	di in smcl in gr ///
`"Note: `ttl' function is calculated over full data and evaluated at"' 
	di in smcl in gr ///
"indicated times; it is not calculated from aggregates shown at left."
	di in smcl in gr "{p_end}"

	if `"`saving'"' != "" {
		postclose `memhold'
                preserve
                capture use `"`saving'"', clear
                if c(rc) {
                        if inrange(c(rc),900,903) {
                                di as err ///
                        "insufficient memory to load file with results"
                        }
                        restore
                        error c(rc)
                }
                label variable time "Time"
                label variable begin "Beg. Total"
                label variable fail "Fail"
                if "`ttl'"=="Survivor" {
			label variable survivor "Survivor Function"
                }
                else if "`ttl'"=="Failure" {
                        label variable failure "Failure Function"
                }
                else {
                        label variable cumhaz "Nelson-Aalen Cum. Haz. Function"
                }
		if "`wt'" != "pweight" {
                	label variable std_err "Std. Error"
                	label variable lb "Lower Bound of `level'% Conf. Int."
                	label variable ub "Upper Bound of `level'% Conf. Int."
		}
		qui save `"`saving'"', replace
                restore
	}
end


program define Licomp 
	args mark by grp t s at failure adjustf saving
	/* failure contains "failure", "aalen" or "" */

	qui summ `grp'
	local ngrp = r(max)
	local maxng = ceil(`ngrp'/6)*6-5

	local ng 1
	while `ng' <= `ngrp' {
		local nglast=min(`ng'+5,`ngrp')
		Licompu "`mark'" "`by'" "`grp'" _t `s' "`at'" `ng' `nglast' /*
			*/ "`maxng'" "`failure'" "`adjustf'" `"`saving'"'
		local ng=`ng'+6
	}
	if "`adjustf'"!="" {
		if "`failure'"=="" {
			local ttl "Survivor"
		}
		else	local ttl "Failure"
		di in gr "`ttl' function adjusted for `adjustf'"
	}
end

program define Licompu
	args IGNORE by grp t s at g0 g1 maxng failure adjustf saving
	/* failure contains "failure", "aalen" or "" */
	di
	if "`failure'"=="" {
		local ttl "Survivor"
		local vname "survivor"
	}
	else if "`failure'"=="aalen" {
		local ttl "Nelson-Aalen"
		local vname "cumhaz"
	}
	else {
		local ttl "Failure"
		local vname "failure"
	}
	if "`adjustf'" != "" { 
		local ttl `"Adjusted `ttl'"'
	}
	if "`failure'"=="aalen" {
		local ttl `"`ttl' Cum. Haz."'
	}
	else local ttl `"`ttl' Function"'
	local tl = udstrlen(`"`ttl'"')

	local wid = (`g1'-`g0'+1)*11-5
	local ldash = int((`wid' - `tl')/2)
	local rdash = `wid' - `tl' - `ldash' 

	if `ldash'>0 & `rdash'>0 {
		di in smcl in gr /*
		*/ _col(18) "{hline `ldash'}`ttl'{hline `rdash'}"
	}
	else {
		local skip = max(17 + `wid' - `tl', 0)
		di in gr _skip(`skip') "`ttl'"
	}
	tokenize `"`by'"'
	while "`1'" != "" {
		di in gr "`1'" _col(13) _c
		local g `g0'
		while `g' <= `g1' {
			GetVal `grp' `g' `1' 9
			local skip = 11 - udstrlen("$S_1")
			di in gr _skip(`skip') "$S_1" _c
			* di in gr "12" %9.0g 1 _c
			local g = `g'+1
		}
		di
		mac shift
	}
	if `"`saving'"' != "" {
		forvalues i=`g0'/`g1'{
			local newvars "`newvars' `vname'_`i'"
			local label`i' "`ttl' for "
			tokenize `"`by'"'
			while "`1'" != "" {
				local typ: type `1'
				qui levelsof `1' if `grp'==`i', local(val)
                                local len = length(`"`val'"')
				if bsubstr(`"`typ'"',1,3) == "str" {
					/* remove compound quotes */
					local val = bsubstr(`"`val'"',3,`len'-4)
				}
				local label`i' "`label`i'' `1'=`val'"
				mac shift
			}
		}
		tempname memhold
		tempfile temp`g0'
		capture postclose `memhold'
		postfile `memhold' time `newvars' using `"`temp`g0''"'	
	}

	local ndash = 12+(`g1'-`g0'+1)*11
	di in smcl in gr "{hline `ndash'}"

	tempvar obs
	tokenize `"`at'"'
	local j 1 
	local thead "time"
	while "``j''" != "" {
		di in gr "`thead'" %8.0g ``j'' _c
		local thead "    "
		local g `g0'
		while `g'<=`g1' {
			qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
			qui summ `obs'
			local i0 = r(min)
			local i1 = r(max)
			drop `obs'
			qui gen `c(obs_t)' `obs' = _n if _t>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(r(min)>=.,`i1',r(min)-1)
			drop `obs'
			if `i'<`i0' {
				local res 1
			}
			else if `i'==`i1' & _t[`i']!=``j'' {
				local res .
			}
			else 	local res = `s'[`i']
			di in ye %11.4f `res' _c
			local save "`save' (`res')"
			local g=`g'+1
		}
		di
		if `"`saving'"' != "" {
			post `memhold' ``j'' `save'
		}
		local save ""
		local j=`j'+1
	}
	di in smcl in gr "{hline `ndash'}"
        if `"`saving'"' != "" {
                postclose `memhold'
		if `g0'==1 {
                	preserve
                	capture use `"`temp`g0''"', clear
                	if c(rc) {
                        	if inrange(c(rc),900,903) {
                                	di as err ///
                        	"insufficient memory to load file with results"
                        	}
                        	restore
                       	 	error c(rc)
                	}
                	forvalues i=1/`g1'{
                        	label variable `vname'_`i' "`label`i''"
                	}
                	qui save `"`saving'"', replace
                	restore
		}
		else if `g0'>1 {
			preserve
                	capture use `"`saving'"', clear
                	if c(rc) {
                        	if inrange(c(rc),900,903) {
                                	di as err ///
                        	"insufficient memory to load file with results"
                        	}
                        	restore
                        	error c(rc)
                	}
			capture merge time using `"`temp`g0''"', sort
                        if c(rc) {
                                if inrange(c(rc),900,903) {
                                        di as err ///
                                "insufficient memory to load file with results"
                                }
                                restore
                                error c(rc)
                        }
			forvalues i=`g0'/`g1'{
                                label variable `vname'_`i' "`label`i''"
                        }
			drop _merge
                        qui save `"`saving'"', replace
                        restore
		}
        }
end

program define ChkYScale4Log, sclass
	syntax [, YLOg LOG * ]

	sreturn clear
	if "`ylog'`log'" != "" {
		sreturn local log log
	}
	sreturn local options `"`s(log)' `options'"'
end

program define Graph, rclass
	.__stsutil = .sts_graph_util.new
	.__stsutil.setOriginalArgs `"`0'"'
	
	capture noisily Graph_wrk `0'
	local rc = _rc
	ret add
	if ! `rc' {
	    capture noisily {
		if `.__stsutil.doPostGraphAdjustments, dryrun' {
			if `.__stsutil.getNoDraw' {
				version 10 : display as error		///
					"{opt nodraw} may not be "	///
					"combined with options that "	///
					"cause title auto alignment"
				exit 198
			}
			version 10 : .`.__stsutil.getGraphName'.drawgraph, ///
				nomaybedraw `.__stsutil.getSizeOpts'
			.__stsutil.doPostGraphAdjustments
		}
		if ! `.__stsutil.getNoDraw' {
			version 10 : gr display `.__stsutil.getGraphName', ///
				`.__stsutil.getSizeOpts'
		}
	    }
	    local rc = _rc
	}
	classutil drop .__stsutil
	exit `rc'
end

program define Graph_wrk, rclass
	syntax [if] [in] [,		///
		SURvival 		/// the default
		Failure			/// abbrev. (backward compatibility)
		Hazard 			///
		CUMHaz			/// synonym for na
		NA			/// deprecated synonym for cumhaz
		Gwood			/// deprecated synonym for ci
		CIHazard		/// deprecated synonym for ci
		CNA			/// deprecated synonym for ci
		CI			///
		ADjustfor(varlist)	///
		CENsored(string)	///
		CENSOpts(string asis)	///
		Enter			///
		ATRisk			///		
		LOST			///
		noORIgin		///
		noSHow			///
		STrata(varlist)		///
		BY(varlist)		///
		SEParate		///
		TMIn(real -1)		///
		TMAx(real -1)		///
		TRim(integer 32)	///
		per(real 1.0)		///
		YLOg			///
		Kernel(string)          ///
		width(string)		///
		noBoundary		///
		OUTfile(string)		/// undocumented
		LEFTBOUNDARY(real -1)	/// undocumented
		Level(cilevel)		///		
		NAME(passthru)		///
		NODRAW			///
		XAXis(passthru)		///
		XSIZe(passthru)		///
		YSIZe(passthru)		///
		ASPECTratio(passthru)	///
		*			///
	]
	_gs_byopts_combine byopts options : `"`options'"'

	.__stsutil.setNoDraw `nodraw'
	
	if `.__stsutil.getItteration' == 1 {
		.__stsutil.setSizeOpts `xsize' `ysize'
		
		if `"`name'"' != "" {
			local gname `.__stsutil.parseGraphName, `name''
		}
		else {
			local gname Graph
		}		
		.__stsutil.setGraphName `gname'
	}
	
	if `.__stsutil.getItteration' == 2 {
		if `"`name'"' != "" {
			local name `"name(`.__stsutil.getGraphName', replace)"'
		}
	}

	if `"`cumhaz'"' != "" & `"`na'"' != "" {
		// cumhaz and na are synonyms, 
		//	but only one or the other should be used.
		display as error	///
			"options cumhaz and na may not be combined"
		exit 198
	}
	if `"`by'"' != "" & `"`strata'"' != "" {
		display as error	///
			"options by() and strata() may not be combined"
		exit 198
	}
	if `"`by'`strata'"' == "" & "`separate'" != "" {
		display as error	///
			"option separate requires either by() or strata()"
		exit 198
	}
	if `"`by'`strata'"' == "" & `"`byopts'"' != "" {
		display as error	///
			"option byopts() requires either by() or strata()"
		exit 198
	}
	
	// mutually exclusive functions
	local exclus `"`survival' `failure' `hazard' `cumhaz' `na'"' 
	local optcnt : word count `exclus' 
	if `optcnt' > 1 {
		display as error	///
			"options `:word 1 of `exclus'' "	///
			"and `:word 2 of `exclus'' may not be combined"
		exit 198
	}
	
	// mutually exclusive confidence intervals
	local exclus `"`ci' `gwood' `cna' `cihazar'"' 
	local optcnt : word count `exclus' 
	if `optcnt' > 1 {
		display as error	///
			"options `:word 1 of `exclus'' "	///
			"and `:word 2 of `exclus'' may not be combined"
		exit 198
	}
	
	// implied survival option
	if `"`survival'`failure'`hazard'`cumhaz'`na'"' == "" {
		// only allow deprecated gwood with default survival
		if `"`cihazard'`cna'"' != "" {
			display as error	///
				"option `cihazard'`cna' may not be "	///
				"used with the default survivor function"
			exit 198
		}
		// set the default; 
		// surviva needs to be defined for compatibility 
		// with version 6 (macros have max len of 7 characters)
		local surviva survival
	}

	// only allow deprecated gwood with survival or failure
	local exclus `"`survival' `failure' `cna' `cihazard'"' 
	local optcnt : word count `exclus' 
	if `optcnt' > 1 {
		display as error	///
			"options `:word 1 of `exclus'' "	///
			"and `:word 2 of `exclus'' may not be combined"
		exit 198
	}
	
	// only allow deprecated cna with cumhaz or deprecated na
	local exclus `"`na' `cumhaz' `gwood' `cihazard'"' 
	local optcnt : word count `exclus' 
	if `optcnt' > 1 {
		display as error	///
			"options `:word 1 of `exclus'' "	///
			"and `:word 2 of `exclus'' may not be combined"
		exit 198
	}
	
	// only allow deprecated cihazard with hazard
	local exclus `"`hazard' `gwood' `cna'"' 
	local optcnt : word count `exclus' 
	if `optcnt' > 1 {
		display as error	///
			"options `:word 1 of `exclus'' "	///
			"and `:word 2 of `exclus'' may not be combined"
		exit 198
	}	
		
	if `"`cumhaz'"' != "" {
		// stick with -na- for backward compatibility
		local na na 
	}
	
	// handle ci backwards compatibility
	if `"`survival'`failure'"' != "" & `"`ci'"' != "" {
		local gwood gwood
	}
	if `"`cumhaz'`na'"' != "" & `"`ci'"' != "" {
		local cna cna
	}
	if `"`hazard'"' != "" & `"`ci'"' != "" {
		local cihazar cihazard
	}

	if `"`strata'"' != "" {
		if "`adjustf'" == "" {
			di in red /*
		*/ "strata() requires adjustfor(); perhaps you mean by()"
			exit 198 
		}
		local by `strata'
	}
	if `"`separate'"' != "" {
		local separat set
	}
	else {
		local separat
	}
	
	/* .sts_graph_util.parseRiskTable should be called on both passes
	 * because it performs tasks that are unique each time.
	 * ... non risk table options can be extracted each after pass, but
	 * options for creating the risk table are only available after calling
	 * .sts_graph_util.parseRiskTable during the second pass.
	 */

	.__stsutil.parseRiskTable  , `options'
	local gropts `.__stsutil.getNotRiskTableOpts'

	
	if `"`separat'"' != "" & `.__stsutil.hasRiskTable' {
		display as error	///
			"options separate and risktable may not be combined"
		exit 198
	}
	
	if `"`atrisk'"' != "" & `.__stsutil.hasRiskTable' {
		display as error	///
			"options atrisk and risktable may not be combined"
		exit 198
	}
	if `"`lost'"' != "" & `.__stsutil.hasRiskTable' {
		display as error	///
			"options lost and risktable may not be combined"
		exit 198
	}
	if `"`enter'"' != "" & `.__stsutil.hasRiskTable' {
		display as error	///
			"options enter and risktable may not be combined"
		exit 198
	}
	if `"`aspectr'"' != "" & `.__stsutil.hasRiskTable' {
		display as error	///
			"options aspectratio and risktable may not be combined"
		exit 198
	}	
	
	if `.__stsutil.hasRiskTable' & `.__stsutil.getItteration' == 1 	///
		& "`nodraw'" == "" 					///
	{
		// never draw the first pass
		local rNoDraw nodraw
	}
	
	local name2 `.__stsutil.parseGraphName , `name''
	_get_gropts , graphopts(`gropts')	///
		grbyable			///
		getallowed(			///
			CIOPts			///
			ATRISKOPts		///
			LOSTOPts		///
			plot			///
			addplot			///
			YSCale			///
		)
	local options `"`s(graphopts)'"'
	local ciopts `"`s(ciopts)'"'
	local atopts `"`s(atriskopts)'"'
	local lstopts `"`s(lostopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	local yscale `"`s(yscale)'"'
	_check4gropts ciopts, opt(`ciopts')
	
	ParseByOpts , `byopts'
	local bylgnd `"`s(bylgnd)'"'
	local byttl `"`s(byttl)'"'
	local byopts `"`s(byopts)'"'


	if `"`atopts'"' != "" {
		local atrisk atrisk
	}
	if `"`lstopts'"' != "" {
		local lost lost
	}

	ChkYScale4Log , `ylog' `yscale'
	local ylog `s(log)'
	if `"`s(options)'"' != "" & `"`s(options)'"' != " " {
		local options `"yscale(`s(options)') `options'"'
		local yscale
	}

	if "`hazard'"!="" {
		if `per' != 1.0 {
			di in red "option hazard not allowed with per()"
			exit 198
		}
		foreach x in na cna enter failure gwood ///
			lost atrisk {
			ForbidOpt ``x''
		}
		if `.__stsutil.hasRiskTable' {
			display as error	///
			    "options hazard and risktable may not be combined"
			exit 198
		}
		if `"`censored'"'!="" {
			display as error	///
			    "options censored() and hazard may not be combined"
			exit 198
		}
		local origin noorigin
		local conopt connect(l ...)
	}
	else {
		local conopt connect(J ...)
		local ylabopt ylabel(\`ylab', grid)
	}

	local w  : char _dta[st_w]
	if "`enter'"!="" & "`lost'"=="" {
		local lost="lost"
	}	
	if `level'<10 | `level'>=100 { 
		di in red "level() invalid"
		exit 198
	}
	if `"`kernel'"' != "" {
		if "`hazard'" == "" {
			display as error 	///
				"option kernel() only allowed with hazard"
			exit 198
		}
	}
	if `"`width'"' != "" {
		if "`hazard'" == "" {
			display as error 	///
				"option width() only allowed with hazard"
			exit 198
		}
	}
	if `"`boundary'"' != "" {
		if "`hazard'" == "" {
			display as error 	///
				"option noboundary only allowed with hazard"
			exit 198
		}
	}
	// mutually exclusive functions
	if "`cumhaz'" != "" {
		if "`adjustf'" != "" {
			display as error	///
"options adjustfor() and cumhaz may not be combined"
			exit 198
		}
	}
	if "`na'"!="" {
		if "`adjustf'"!="" {
			display as error	///
"options adjustfor() and na may not be combined"
			exit 198
		}
	}
	if "`ci'" != "" {
		if "`adjustf'" != "" {
			display as error	///
"options adjustfor() and ci may not be combined"
			exit 198
		}
	}
	if "`cihazard'"!="" {
		if "`adjustf'"!="" {
			display as error	///
"options adjustfor() and cihazard may not be combined"
			exit 198
		}
	}
	if "`gwood'" != "" {
		if "`adjustf'" != "" {
			display as error 	///
"options adjustfor() and gwood may not be combined"
			exit 198
		}
	}
	if "`cumhaz'" != "" & `per' != 1.0 {
		display as error	///
			"options cumhaz and per() may not be combined"
		exit 198
	}
	if "`na'"!="" & `per' != 1.0 {
		display as error	///
			"options na and per() may not be combined"
		exit 198
	}
/*	if "`failure'"!="" & `per' != 1.0 {
		di in red "option failure not allowed with per()"
		exit 198
	}
*/
	if "`gwood'"!="" {
		if "`_dta[st_wt]'"=="pweight" { 
			di in red "option ci not allowed with pweighted data"
			exit 198
		}
		if `per' != 1.0 {
			di in red "option ci not allowed with per()"
			exit 198
		}
	}
	if "`cna'"!="" {
		if `per' != 1.0 {
			di in red "option ci not allowed with per()"
			exit 198
		}
		if "`_dta[st_wt]'"=="pweight" { 
			di in red "option ci not allowed with pweighted data"
			exit 198
		}
	}
	if `per' != 1.0 {
		if "`atrisk'"!="" {
			di in red "option atrisk not allowed with per()"
			exit 198
		}
		if "`lost'"!="" {
		di in red "options lost and enter not allowed with per()"
			exit 198
		}
	}
	if "`ylog'"!="" & `per' != 1.0 {
		di in red "option ylog not allowed with per()"
		exit 198
	}
	if "`na'"!="" {
		local origin "noorigin"
		local ttlpos 5
	}
	else	local ttlpos 1

	local sb "`by'"
	if "`sb'" != "" {
		local n : word count `sb'
		if `n' > 1 & "`hazard'" != "" {
			di in red "may not specify " _c
			di in red "hazard" _c
			di in red " with more than one by/strata variable;"
			di in red /* 
			*/ "use " _quote "egen ... = group(`by')" _quote /*
			*/ " to make a single variable"
			exit 198
		}
	}
	

	if  "`censored'"!="" & ("`lost'"!="" | "`enter'"!="" | "`atrisk'"!="") {
		di in red /*
		*/ "censored() not possible with lost, enter, or atrisk" 
		exit 198
	}
	if "`censored'"~="" {
		local l = length("`censored'")
		if bsubstr("numbered",1,max(1,`l')) == "`censored'" {
			local censt= "numbered"
		}
		else if bsubstr("single",1,max(1,`l')) == "`censored'" {
			local censt= "single"
		}
		else if bsubstr("multiple",1,max(1,`l')) == "`censored'" {
			local censt= "multiple"
		}
		else {
			di in red "invalid option censored(`censored')"
			exit 198
		}
	}

	if `"`censt'"' == "multiple" & `.__stsutil.hasRiskTable' {
		display as error	///
		  "options censored(multiple) and risktable may not be combined"
		exit 198
	}	

	if  "`enter'"!="" & "`atrisk'"!="" {
		display as error	///
		  "atrisk and enter not possible at the same time"
		exit 198
	}
	if "`adjustf'"!="" {
		if "`lost'`enter'`atrisk'`censored'" != "" {
			display as error	///
				"options atrisk, censored, lost, and enter may not be combined with adjustfor()"
			exit 198
		}
		if `.__stsutil.hasRiskTable' {
			display as error	///
				"options adjustfor() and risktable may not be combined"
			exit 198
		}
	}

	if !(`.__stsutil.hasRiskTable' & `.__stsutil.getItteration' == 2) {
		// only show on the 1st pass when graphing twice for risktable
		st_show `show'
	}

	tempvar touse  mark n d cens ent h Vh s lb ub aal uba lba
	st_smpl `touse' `"`if'"' "`in'" "`sb'" "`adjustf'"

	preserve

quietly {

	keep if `touse'
	tempvar failvar
	if "`adjustf'"=="" {
		if "`censored'" != "" {
			tempvar mycens
			st_ct "`by'" -> _t `n' _d "" `ent' `mycens'
			local enter="enter"
			local notreal="notreal"
			gen double `cens'=`mycens'
			drop `mycens'
		}
		else {
			st_ct "`by'" -> _t `n' _d `cens' `ent'
		}
		if "`enter'"=="" & "`atrisk'"=="" {
			replace `cens' = `cens' - `ent' if _t
			drop if _d==0 & `cens'==0
			replace `ent' = 0 
		}
		if "`atrisk'"!="" {
			replace `ent' = `n'[_n+1] if _d
			if "`lost'"=="" {
				replace `cens'=0
			}
		}
		AddSurv "`by'" _t `n' _d `level' -> /* 
		*/ `h' `Vh' `s' "" "" `lb' `ub' `aal' ""  `uba' `lba'
		quietly generate `failvar' = _d

	}
	else { 
		if `"`strata'"' != "" {
			DoAdjust "" "`by'" "`adjustf'" "" "" -> `h' `s'
		}
		else {
			DoAdjust "`by'" "" "`adjustf'" "" "" -> `h' `s'
		}
		if "`hazard'"=="" {
			KeepDead "`sb'"
		}
		gen `Vh' = 1 // not used with adjustfor
		gen `ub' = . // not used with adjustfor
		gen `lb' = . // not used with adjustfor
	}
	if "`hazard'" != "" {
		keep if _d
		sort `sb' _t 
		by `sb' _t: keep if _n==1
		tempvar ub1 lb1
		SmoothHazard  _t `h' `Vh' "`kernel'" `"`width'"' `tmin' ///
			`tmax' `"`sb'"' `"`ub1'"' `"`lb1'"' `level' ///
			`leftboundary' `boundary'
		ret add		
		sort `sb' _t 
		qui replace `s' = `h'
		qui replace `ub' = `ub1'
		qui replace `lb' = `lb1'
	}
	label var `s' "Survivor function"
	if "`failure'" != "" {
		replace `s'=1-`s'
		if "`adjustf'" == "" {
			replace `lb'=1-`lb'
			replace `ub'=1-`ub'
			local hold "`lb'"
			local lb "`ub'"
			local ub "`hold'"
		}
		label var `s' "Failure function"
	}
	if "`hazard'"!="" {
		label var `s' "Smoothed hazard function"
	}
	if "`na'" != "" {
		replace `s'=`aal'
		replace `lb'=`lba'
		replace `ub'=`uba'
		drop `aal' `lba' `uba' 
		label var `s' "Cumulative hazard"
	}
	cap confirm var `lb'
	if !_rc {
		label var `lb' `"`=strsubdp("`level'")'% CI"'
		label var `ub' `"`=strsubdp("`level'")'% CI"'
	}

	if !`.__stsutil.hasRiskTable' {
		// postpone dropping data until risktable has built labels
		if `tmin' != -1 {
			drop if _t<`tmin'
		}
		if `tmax' != -1 { 
			drop if _t>`tmax'
		}
		qui count 
		if r(N)<1 { 
			di in red "no observations"
			exit 2000
		}
	}

	// assure confidence intervals extend properly
	quietly replace `ub' = `ub'[_N - 1] if _N == _n & `ub'[_N] == .
	quietly replace `lb' = `lb'[_N - 1] if _N == _n & `lb'[_N] == .
	
	if "`lost'"=="" & "`atrisk'"=="" {
		if "`adjustf'"=="" {
			drop _d 
		}
	}
	else {
		summ `s'
		local eps = max( (r(max)-r(min))/30, .0)
		tempvar dj tnext s2 s3 newt
		sort `sb' _t _d
		if "`sb'"!="" {
			local byst "by `sb':"
		}

		`byst' replace _d=1 if _d==0 & (_n==1 | _n==_N)
		`byst' gen `c(obs_t)' `dj' = _n if _d 
		`byst' replace `dj'=`dj'[_n-1] if `dj'>=.
		sort `sb' `dj' _d
		by `sb' `dj': replace `cens'=sum(`cens')
		by `sb' `dj': replace `ent' =sum(`ent')
		by `sb' `dj': keep if _n==_N
		drop `dj'
		sort `sb' _t
		`byst' gen `tnext'=_t[_n+1]
		`byst' replace `tnext'=_t if _n==_N
		expand 3 
		sort `sb' _t
		by `sb' _t: gen `newt' = cond(_n==1, _t, /*
				*/ (_t+`tnext')/2)
		drop `tnext'
		by `sb' _t: gen `s2' = `s'+`eps' if _n==2
		by `sb' _t: gen `s3' = `s'-`eps' if _n==3
		by `sb' _t: replace `s'=. if _n>1
		by `sb' _t: replace `cens' = 0 /*
			*/ if _n==1 | _n==3
		by `sb' _t: replace `ent' = 0 /*
			*/ if _n==1 | _n==2
		by `sb' _t: keep if _n==1 | /*
			*/ (_n==2 & `cens') | (_n==3 & `ent')
		local lbl : var label _t
		drop _t 
		rename `newt' _t
		label var _t `"`lbl'"'
		local lbl
		sort `sb' _t
		sum `s2', mean
		if r(N) > 0 {
			label var `s2' "Number lost"
			local s2l `cens'
		}
		else	local s2
		sum `s3', mean
		if r(N) > 0 {
			label var `s3' "Number entered"
			local s3l `ent'
		}
		else	local s3
		if `"`s2'"' != "" {
			local mgraph			///
			(scatter `s2' _t,		///
				sort			///
				connect(none)		///
				msymbol(none)		///
				mlabel(`s2l')		///
				mlabposition(0)		///
				pstyle(p1)		///
				\`ysca'			/// yet to exist
				`lstopts'		///
			)				///
			// blank
		}
		if `"`s3'"' != "" {
			local mgraph			///
			`mgraph'			///
			(scatter `s3' _t,		///
				sort			///
				connect(none)		///
				msymbol(none)		///
				mlabel(`s3l')		///
				mlabposition(0)		///
				pstyle(p1)		///
				\`ysca'			/// yet to exist
				`atopts'		///
			)				///
			// blank
		}
	}

} // quietly
	local lorder
	local lcnt = 0	
	local insave `in'
	local ifsave `if'
	
	/* determine if legend(cols()) is specified */
	local opsave `options'
	local 0, `options'
	local hasCols = 0
	syntax [, legend(string asis) * ]
	while `"`legend'"' != "" {
		local 0, `legend'
		local holdops `options'
		
		syntax [, cols(string) * ]
		if `"`cols'"' != "" {
			local hasCols = 1
		}
		local 0 `", `holdops'"'
		syntax [, legend(string asis) * ]
	}
	local options `opsave'
	/* end legend(cols()) logic */

	if "`separat'" != "" | "`sb'" == "" {
		// by graph or single plot
		local svars "`s'"
		local opsave `options'
		if "`gwood'" != "" | "`cna'" != "" | "`cihazard'" != "" {
			if "`cihazard'" != "" {
				local cicon direct
			}
			else {
				local cicon stairstep
			}
			local 0, `ciopts'
			syntax [, recast(passthru) * ]
			if `"`recast'"' == "" {
				/* rarea is handled differently with this 
				 * command so that the line options refer 
				 * to the overlaid line instead of the 
				 * border of the area
				 */
				local 0, `options'
				syntax [, 	COLor(string) 		///
						FColor(string)	 	///
						LColor(string)		///
						LPattern(passthru) 	///
						LWidth(passthru) 	///
						PSTYle(string)		///
					* ]

				if `"`pstyle'"' != "" {
					local color scheme `pstyle'
				}
				local basecol `color'
				if `"`color'"' == "" {
					local color scheme p1
					local basecol `color'
					local color `color'*.15
				}
				if `"`lcolor'"' == "" {
					local lcolor `basecol'*.5
				}
				if `"`fcolor'"' != "" {
					local color `fcolor'
				}

				local cigraph `cigraph'			///
				(rarea `lb' `ub' _t , 			///
					sort				///
					connect(`cicon')		///
					color("`color'") 		///
					fcolor("`fcolor'")		///
					fintensity(100)			///
					pstyle("`pstyle'")		///
					`recast'			///
					\`ysca'			/// yet to exist
					`options'			///
				)
				local lcnt = `lcnt' + 1
				local lorder `lorder' `lcnt'
				// overlay rline over rarea border
				local cigraph `cigraph'			///
				(rline `lb' `ub' _t,			///
					sort				///
					connect(`cicon')		///
					color("`color'")		///
					fcolor("`fcolor'")		///
					lcolor("`lcolor'")		///
					pstyle("`pstyle'")		///
					`lpattern'			///
					`lwidth'			///
					\`ysca'			/// yet to exist
					`options'			///
				)
				local lcnt = `lcnt' + 1
			}
			else {
				local cigraph `cigraph'			///
				(rarea `lb' `ub' _t , 			///
					sort				///
					connect(`cicon')		///
					`recast'			///
					pstyle(ci)			///
					\`ysca'			/// yet to exist
					`options'			///
				)
				local lcnt = `lcnt' + 1
				local lorder `lorder' `lcnt'
			}
		}
		local options `opsave'		
	}
	else {
		// overlaid plot
		tempvar grp id
		quietly by `sb': gen int `grp' = 1 if _n==1
		quietly replace `grp' = sum(`grp')
		quietly gen `id' = _n
		local ng = `grp'[_N]
		local i 1
		local j 1
		local ci_0 `ciopts'
		while `i' <= `ng' {
			tempvar x
			quietly gen float `x' = `s' * `per' if `grp'==`i'
			local svars "`svars' `x'"
			GetGroupLabel `sb' if `grp'==`i', id(`id')
			label var `x' `"`r(label)'"'
			if "`gwood'" != "" | "`cna'" != "" 		///
				| "`cihazard'" != "" 			///
			{
				if "`cihazard'" != "" {
					local cicon direct
				}
				else {
					local cicon stairstep
				}			
				// **** parse out ci`i'opts	
				local 0 , `options'
				syntax [, CI`i'opts(string asis) * ]
				local ciopts `ci`i'opts'
				while `"`ci`i'opts'"' != "" {
					local 0 `", `options'"'
					syntax [, CI`i'opts(string asis) * ]
					if `"`ci`i'opts'"' != "" {
					   local ciopts `"`ciopts' `ci`i'opts'"'
					}
				}
				// ****

				local ciopts `ci_0' `ciopts'
			    	local opsave `options'
				local 0, `ciopts'
				syntax [, recast(passthru) * ]
				if `"`recast'"' == "" {
					/* rarea is handled differently 
					 * with this command so that the 
					 * line options refer to the overlaid
					 * line instead of the border of the 
					 * area
					 */
					local 0, `options'
					syntax [, 	COLor(string)	   ///
							FColor(string)	   ///
							LColor(string)	   ///
							LPattern(passthru) ///
							LWidth(passthru)   ///
							PSTYle(string)	   ///
						* ]

					local basecol `color'
					if `"`pstyle'"' != "" {
						local color scheme `pstyle'
					}
					if `"`color'"' == "" {
						local color scheme p`=`i''
						local basecol `color'
						local color `color'*.15
					}
					if `"`lcolor'"' == "" {
						local lcolor `basecol'*.5
					}
					if `"`fcolor'"' != "" {
						local color `fcolor'
					}
					local cigraph `cigraph'		///
					(rarea `lb' `ub' _t if `grp' == `i', ///
						sort			///
						connect(`cicon')	///
						color("`color'")	///
						fcolor("`fcolor'")	///
						fintensity(100)		///
						pstyle("`pstyle'")	///
						`recast'		///
						\`ysca'		/// yet to exist
						`options'		///
					)
					local lcnt = `lcnt' + 1
					local lorder `lorder' `lcnt'
					// overlay rline over rarea border
					local cigraph `cigraph'		///
					(rline `lb' `ub' _t if `grp' == `i', ///
						sort			///
						connect(`cicon')	///
						color("`color'")	///
						fcolor("`fcolor'")	///
						lcolor("`lcolor'") 	///
						pstyle("`pstyle'")	///
						`lpattern'		///
						`lwidth'		///
						\`ysca'		/// yet to exist
						`options'		///
					)
					local lcnt = `lcnt' + 1
				}
				else {
					local 0, `options'
					syntax [, LColor(string) * ]
					if `"`lcolor'"' == "" {
						local lcolor scheme p`=`i''
						local lcolor `lcolor'*.5
					}
					local cigraph `cigraph'		///
					(rarea `lb' `ub' _t if `grp' == `i', ///
						sort			///
						connect(`cicon')	///
						lcolor("`lcolor'")	///
						`recast'		///
						\`ysca'		/// yet to exist
						`options'		///
					)
					local lcnt = `lcnt' + 1
					local lorder `lorder' `lcnt'					
				}
				local options `opsave'
			}
			local i = `i' + 1
		}
		local if `ifsave'
		local in `insave'
	}

	if "`na'" == "" & "`hazard'" == "" {    // survival
		if "`ylog'"!="" {
			local ylab ".01 .05 .10 .25 .50 .75 1"
		}
		else {
			local yfact= .25*`per'
			local ylab "0(`yfact')`per'"
		}
	}

	// format the first var to be graphed, this makes the yaxis labels
	// look nice

	if "`hazard'"=="" {
		local fvar : word 1 of `svars'
		format `fvar' %9.2f
	}

	if "`na'"!="" {
		local ttl "Nelson-Aalen cumulative hazard estimate"
	}
	else if "`hazard'"!="" {
		local ttl "Smoothed hazard estimate"
	}
	else if "`failure'"=="" {
		if "`adjustf'"!="" {
			local ttl "Survivor function"
		}
		else{
			local ttl "Kaplan-Meier survival estimate"
		}
	}
	else {
		if "`adjustf'"!="" {
			local ttl "Failure function"
		}
		else {
			local ttl "Kaplan-Meier failure estimate"
		}
	}

	if "`sb'"!="" {
		if `per' != 1 {
			local ttl `"`ttl's per `per'"'
		} 
		else local ttl `"`ttl's"'
	}
	else {
		if `per' != 1 {
			local ttl `"`ttl' per `per'"'
		}
	}


	if "`adjustf'"!="" {
		if ustrlen("`adjustf'")>50 {
			local adjustf = usubstr("`adjustf'",1,47)
			local adjustf "`adjustf'..."
		}
		local ttl2 "adjusted for `adjustf'"
	}

	if "`ylog'" != "" {
       		local varcnt: word count  `svars'
		local i 1
		while `i' <= `varcnt' {
			local varn: word `i' of `svars' 
			qui replace `varn'=. if `varn'<=0 
			local i=`i'+1
		}
		local ysca yscale(log)
	}

	/*** new by mac *****/
	if "`origin'"=="" {
		tempvar last flg
		local N = _N
		if "`by'" == "" {
			qui gen byte `last'=2 if _n==_N
			qui expand `last'
			qui gen `flg'=1 if _n>`N'
			qui replace _t=0 if `flg'==1
			if "`failure'" == "" {
				qui replace `s'=1 if `flg'==1
			}
			else qui replace `s'=0 if `flg'==1
		}
		else {
			sort `by'
			qui by `by' :  gen byte `last'=2 if _n==_N
			qui expand `last'
			qui gen `flg'=1 if _n>`N'
			qui replace _t=0 if `flg'==1
			local varcnt: word count  `svars'
			local i 1
			while `i' <= `varcnt' {
				local varn: word `i' of `svars' 
				if "`failure'" == "" {
					qui replace `varn'=1*`per' if _t==0 
				}
				else qui replace `varn'=0 if _t==0
				local i=`i'+1
			}
		}

		if "`gwood'"!="" {
			qui replace  `lb'=. if `flg'==1
			qui replace  `ub'=. if `flg'==1
		}
		if "`notreal'"=="" {
			if "`lost'" !="" | "`enter'" !=""  {
				tempvar tempce
				qui gen str8 `tempce' = string(`cens')
				qui replace `tempce'="" if `flg'==1	
				qui drop `cens'
				qui rename `tempce' `cens'
				qui replace `cens'=trim(`cens')
			}
		}
	}
	if "`na'"~="" | "`origin'"~="" { 
		tempvar flg
		qui gen int `flg'=.
	}
	if `"`censt'"'== "numbered" | `"`censt'"'=="single" {
		tempvar tmvars expw tu nextt mins
		qui gen double `mins'=1-`s' 
		sort `sb' `mins' _t
		if "`sb'" != "" {
			qui by `sb': gen double `nextt'=_t[_n+1]
		}
		else {
			qui gen double `nextt'=_t[_n+1]
		}
		qui by `sb' `mins' (_t): replace `nextt'=`nextt'[_N]
		qui sum _t, meanonly
		local adjd=(r(max)-r(min))/450
		qui gen int `expw'=2  if `cens'>0 & `cens'<. & `flg'>=.
		local N=_N
		qui expand `expw'
		qui replace `expw'=cond(_n>`N',2,.)
		sort `sb'  _t `s' `expw'
		qui by `sb' _t: replace _t=_t+`adjd' if `expw'==2 & _n==1 & /*
		*/ _t+`adjd'<`nextt'
		qui gen double `tmvars'=`s' if `expw'==2
		format `tmvars' %9.2f
		label var `tmvars' "Censored"
		if "`na'"=="" & "`cna'"=="" {
			qui gen `tu'=`tmvars'+.02 if `expw'==2
		}
		else {
			noi sum `s', meanonly
			qui gen `tu'=`tmvars'+ (r(max)-r(min))/45 if `expw'==2
		}
		label var `tu' "Censored"
		local tmvars="`tmvars' `tu'"

		if  `"`censt'"'=="numbered" {
			tempvar expw1
			qui gen `expw1' = `expw'
			local N=_N
			qui expand `expw'
			qui replace `expw'=cond(_n>`N',2,.)
			qui replace `s'=.  if `expw'==2
			qui replace `cens'=. if `expw'~=2 
				// not sure why this is necessary
			local ctgraph			///
			(scatter `tu' _t if `expw' == 2, ///
				connect(none)		///
				msymbol(none)		///
				mlabel(`cens')		///
				mlabpos(12)		///
				mlabcolor(black)	///
				`ysca'			///
				`censopts'		///
			)
		}
		local ctgraph				///
		(rspike `tmvars' _t if `expw' == 2,	///
			lstyle(tick)			///
			`ysca'				///
			`censopts'			///
		)					///
		`ctgraph'				///
		// blank
	}
	else if  `"`censt'"'=="multiple" {
		tempvar tmvars expw tu nextt mins
		qui gen double `mins'=1-`s' 
		sort `sb' `mins' _t
		if "`sb'" != "" {
			qui by `sb': gen double `nextt'=_t[_n+1]
		}
		else {
			qui gen double `nextt'=_t[_n+1]
		}
		qui by `sb' `mins' (_t): replace `nextt'=`nextt'[_N]
	

		qui sum _t, meanonly
		local adjd=(r(max)-r(min))/350
		qui gen int `expw'=`cens'+1  if `cens'>0 & `cens'<. & `flg'>=.
		local N=_N
		qui expand `expw'
		qui replace `expw'=cond(_n>`N',2,.)
		qui gen double `tmvars'=`s' if `expw'==2
		sort `sb' _t `s' `expw'
		tempvar move ttime 
		qui by `sb' _t: gen int `move'=1 if _t+`adjd'*_n<=`nextt' /*
		*/ & `expw'==2
		qui by `sb' _t: replace `move'=2 if `move'>=. & /*
		*/ _t-`adjd'*_n>=_t[1] & `expw'==2
		qui by `sb' _t: gen double `ttime'= _t+`adjd'*_n if `move'==1
		qui by `sb' _t: replace `ttime'= _t-`adjd'*_n if `move'==2
		qui replace _t= `ttime' if `ttime'<.
		drop `ttime' `move' 


		sort  `s' _t `expw'
		format `tmvars' %9.2f
		if "`na'"=="" & "`cna'"=="" {
			qui gen `tu'=`tmvars'+.02 if `expw'==2
		}
		else {
			noi sum `s', meanonly
			qui gen `tu'=`tmvars'+ (r(max)-r(min))/45 if `expw'==2
		}
		label var `tmvars' "Censored"
		local tmvars="`tmvars' `tu'"
		label var `tu' "Censored"

		local ctgraph				///
		(rspike `tmvars' _t,			///
			lstyle(tick)			///
			`ysca'	`censopts'		///
		)					///
		// blank
	}

	local nv : word count `svars'
	if `nv' > 1 | `lcnt' >= 1 {
		forvalues i = 1/`nv' {
			local lcnt = `lcnt' + 1
			local lorder `lorder' `lcnt'
		}
		if `nv' > 1 & `"`cigraph'"' != "" & `hasCols' == 0 {
			local lrows rows(2)
		}
		local legend legend(`lrows' order(`lorder'))
	}
	else if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
		if `"`bylgnd'"' == "" {
			local bylgnd `legend'
		}
	}

	if `"`separat'"' != "" {
		if `"`byttl'"' == "" {
			local byttl `"title(`"`ttl'"' `"`ttl2'"')"'
		}
		local byopt `"by(`sb' , `bylgnd' `byttl' `byopts')"'
	}
	else {
		local title `"title(`"`ttl'"' `"`ttl2'"')"'
	}

	if `"`plot'`addplot'"' != "" {
		local draw nodraw
	}
	local nvars : word count `svars'
	local nvars = min(`nvars',15)
	forval i = 1/`nvars' {
		local pseries `"`pseries' p`i'line"'
	}
	quietly replace `s' = `s'*`per'
	
	local ver `c(version)'
	version 10
	if `.__stsutil.hasRiskTable' & `.__stsutil.getItteration' == 2 {
		tempfile abab
		qui save `"`abab'"', replace
		capture keep if `expw'==.
		capture keep if `expw1' == .
		.__stsutil.getRiskTableOpts, timevar(_t)	///
				riskvar(`n') failvar(`failvar')	///
				groups(`svars')	by(`by')	///
				axis1(10) // special axes start at 10
		local xaxisOp `"`s(xaxisOps)'"'
		qui use `"`abab'"',clear
	}

	if `"`tmin'"' != "" {
		foreach svar of local svars {
			qui replace `svar' = . if _t < `tmin'
		}
	}
	
	local toDraw
	if `"`draw'`nodraw'`rNoDraw'"' != "" {
		local toDraw nodraw
	}
	
	if "`separat'" != "" | "`sb'" == "" {
		// **** parse out plotopts	
		local 0 , `options'
		syntax [, PLOTOpts(string asis) * ]
		local plops `plotopts'
		while `"`plotopts'"' != "" {
			local 0 `", `options'"'
			syntax [, PLOTOpts(string asis) * ]
			if `"`plotopts'"' != "" {
			    local plops `"`plops' `plotopts'"'
			}
		}
		// ****		
		local plots `cigraph'			///
		(line `svars' _t,			///
			sort				///
			`conopt'			///
			`ylabopt'       		///
			ytitle(`""')			///
			`ysca'				///
			xtitle(`"analysis time"')	///
			pstyle(`pseries')		///
			`title'				///
			`legend'			///
			`byopt'				///
			`plops'				///
			`xaxisOp'			///
			`xaxis'				///
		)					///
		`mgraph'			/// labels censored, lost
		`ctgraph'			/// censor ticks
		,  `name' `xsize' `ysize' `aspectr' nodraw `options'
	}
	else {
		// **** parse out plotopts	
		local 0 , `options'
		syntax [, PLOTOpts(string asis) * ]
		local plops `plotopts'
		while `"`plotopts'"' != "" {
			local 0 `", `options'"'
			syntax [, PLOTOpts(string asis) * ]
			if `"`plotopts'"' != "" {
			    local plops `"`plops' `plotopts'"'
			}
		}
		// ****	

		// overlaid plots
		local i = 0
		foreach var of local svars {
			local `++i'
			// **** parse out plot`i'opts	
			local 0 , `options'
			syntax [, PLOT`i'opts(string asis) * ]
			local plotops `plot`i'opts'
			while `"`plot`i'opts'"' != "" {
				local 0 `", `options'"'
				syntax [, PLOT`i'opts(string asis) * ]
				if `"`plot`i'opts'"' != "" {
				    local plotops `"`plotops' `plot`i'opts'"'
				}
			}
			// ****
			local plots `plots' 				///
				(line `var' _t, sort 			///
					pstyle(p`i'line)		///
					`conopt' `xaxisOp' `xaxis'	///
					`plops' `plotops'		///
				)
			local xaxisOp 
			local plotops
		}
		local plots `cigraph' `plots'	///
			`mgraph'		/// labels censored, lost
			`ctgraph'		/// censor ticks
			, `ylabopt'  `ysca'	///
			xtitle(analysis time) 	///
			`title' `legend' `options' `name' `xsize' `ysize' `aspectr' nodraw
	}
	if `.__stsutil.hasRiskTable' {
		quietly {
			if `tmin' != -1 {
				drop if _t<`tmin' & _t != 0
			}
			if `tmax' != -1 { 
				drop if _t>`tmax'
			}
			qui count 
			if r(N)<1 { 
				di in red "no observations"
				exit 2000
			}
		}
	}

	graph twoway `plots'

	if `"`plot'`addplot'"' != "" {
		restore, preserve
		local name1 name(`.__stsutil.getGraphName', replace)
		graph addplot `plot' || `addplot' || , 	///
			norescaling nodraw `name1'
	}
	version `ver'
	
	if `.__stsutil.hasRiskTable' & `.__stsutil.getItteration' == 1 {
		restore, preserve
		.__stsutil.setItteration 2
		
		if `"`censored'"' != "" {
			// -censored- is not allowed with -enter-, however
			// preexisting code sets -enter- after that error 
			// condition has been tested. -enter- is reset here
			// so that the error condition will be tested on the
			// second pass as it was on the first pass. After
			// that happens the preexisting code will set -enter-
			// again.
			local enter
		}
		local passops		///
			 `failure' `na' `gwood' `cna' `enter' `lost' `atrisk'
		if `"`tmin'"' != "" {
			local passops `passops' tmin(`tmin')
		}
		if `"`tmax'"' != "" { 
			local passops `passops' tmax(`tmax')
		}
		if `"`per'"' != "" {
			local passops `passops' per(`per')
		}
		if `"`censored'"' != "" {
			local passops `passops' censored(`censored')
		}
		if `"`censopts'"' != "" {
			local passops `passops' censopts(`censopts')
		}
		if `"`level'"' != "" {
			local passops `passops' level(`level')
		}
		if `"`origin'"' != "" {
			local passops `passops' noorigin
		}
		Graph_wrk `ifsave' `insave', `passops' by(`by') ///
			`.__stsutil.getNotRiskTableOpts' `name' `nodraw'
	}
	if "`outfile'"~="" {
		keep `sb' _t `s' `Vh'
		order `sb' _t `s' `Vh'
		format %10.0g `s' `Vh'
		local name `survival'`failure'`hazard'`cumhaz'
		if `"`name'"' == "" {
			local name survival
		}
		cap rename `s' `name'
		cap rename `Vh' V`name'
		tokenize "`outfile'", parse(",")
		// trim any trailing spaces in the filename
		local 1 `1'
		qui save "`1'" `2' `3'
	}
end

program define ParseByOpts, sclass
	syntax [, LEGend(passthru) TItle(passthru) MISSing total * ]

	if "`total'" != "" {
		display as error		 ///
			"byopts(total) not allowed with sts graph"
		exit 191
	}

	if "`missing'" != "" {
		display as error		 ///
			"byopts(missing) not allowed with sts graph"
		exit 191
	}

	sreturn local bylgnd `"`legend'"'
	sreturn local byttl `"`title'"'
	sreturn local byopts `"`options'"'
end

program define DoAdjust /* by strata adjustf if in -> haz s */
	local by     "`1'"		/* optional 	*/
	local strata "`2'"		/* optional 	*/
	local adjustf "`3'"		/* required	*/
	local if      "`4'"		/* optional	*/
	local in      "`5'"		/* optional	*/

/* */
	local haz "`7'"			/* optional 	*/
	local s   "`8'"			/* optional 	*/

	if "`strata'"!="" {
		local stopt "strata(`strata')"
	}

	if "`by'"=="" {
		if "`s'" != "" {
			local sopt "bases(`s')"
		}
		if "`haz'" != "" {
			local hopt "basehc(`haz')"
		}
		stcox `adjustf' `if' `in', /*
			*/ `stopt' `sopt' `hopt' estimate norobust
		exit
	}
	if "`haz'" != "" {
		tempvar hi
		local hopt "basehc(`hi')"
		gen double `haz' = . 
	}
	if "`s'" != "" {
		tempvar si
		local sopt "bases(`si')"
		gen double `s' = .
	}
	if !(`"`if'"'=="" & "`in'"=="") {
		tempvar touse 
		mark `touse' `if' `in'
		local cond "if `touse'"
		local andcond "& `touse'"
	}
	tempvar grp
	sort `touse' `by'
	by `touse' `by': gen int `grp' = 1 if _n==1 `andcond'
	replace `grp'=sum(`grp') `cond'
	local ng = `grp'[_N]
	local i 1
	while `i' <= `ng' { 
		capture stcox `adjustf' if `grp'==`i', /*
			*/ `stopt' `sopt' `hopt' estimate norobust
		if _rc==0 {
			if "`hopt'"!="" {
				replace `haz' = `hi' if `grp'==`i' 
				drop `hi'
			}
			if "`sopt'"!="" {
				replace `s' = `si' if `grp'==`i'
				drop `si'
			}
		}
		local i = `i' + 1
	}
end


program define KeepDead /* strata */
	args strata

	local d : char _dta[st_d]
	if `"`_dta[st_d]'"'!="" {
		/* keep if `_dta[st_d]' */
		drop `_dta[st_d]'
	}
	sort `strata' _t
	by `strata' _t: keep if _n==1
end

program define MarkPt /* t strata s -> ttl s2 */
	args t strata s ARROW ttl s2

quietly {

	tempvar mark marksum ls

	summarize `t', mean
	local tval = r(min) + (r(max)-r(min))*2/3

	gen byte `mark' = cond(`t'<`tval', 1, 0)
	by `strata': replace `mark'=0 if `mark'[_n+1]==1
	by `strata': gen byte `marksum' = sum(`mark')
	by `strata': replace `mark'=1 if _n==_N & `marksum'==0
	drop `marksum'

	summarize `s', mean
	local eps = 0 // this use to be "= max( (r(max)-r(min))/20, 0)"
	gen float `ls' = `s'
	by `strata': replace `ls' = `ls'[_n-1] if `ls'>=.
	gen float `s2' = `ls'+`eps' if `mark'
	replace `s2' = `ls'[_n-1]+`eps' if `mark' & `strata'==`strata'[_n-1]

	summarize `s2', mean

	capture confirm string variable `strata'
	if _rc {
		gen str20 `ttl' = "`strata' " + trim(string(`strata')) if `mark'
		local lab : value label `strata'
		if "`lab'" != "" {
			tempvar delab
			decode `strata', gen(`delab') maxlen(20)
			replace `ttl' = `delab' if `mark'
		}
	}
	else	gen str20 `ttl' = trim(`strata') if `mark'
	compress `ttl'

} // quietly

end

program define ByStAdj, sclass
	args by strata adjustf

	sret clear

	if "`by'" == "" & "`strata'"!="" {
		if "`adjustf'"=="" {
			di in red /*
		*/ "strata() requires adjustfor(); perhaps you mean by()"
			exit 198 
		}
	}

	if !("`by'"=="" & "`strata'"=="") {
		if "`by'"!="" & "`strata'"!="" {
			di in red /*
			*/ "options by() and strata() may not be combined"
			exit 198
			// this is no longer allowed (as of version 10) 
			// sret local sb "`by' `strata'"
		}
		else if "`by'"!="" { 
			sret local sb "`by'" 
		}
		else 	sret local sb "`strata'"
	}
end

program define GetGroupLabel, rclass
	syntax varlist [if] , id(varname)

	sum `id' `if', mean
	local n = r(min)
	foreach var of local varlist {
		cap confirm numeric var `var'
		if _rc {		// string variable
			local ll = usubstr(`var'[`n'],1,20)
		}
		else {			// numeric variable
			sum `var' `if', mean
			local ll `"`var' = `: label (`var') `=r(min)''"'
		}
		local lab `"`lab'`sep'`ll'"'
		local sep "/"
	}
	return local label `"`lab'"'
end

program define SmoothHazard, rclass
	args time deltah deltaVh kernel width tmin tmax sb ub lb level ///
	     leftbnd nobnd

	local by `"`sb'"'
	if `"`by'"' != "" {
		local byLabel : value label `by'
		local varLab : variable label `by'
	}

	drop if `deltah' == 0 | `deltah' == .
	tempvar tvar group id
	if `"`width'"' != "" {
		foreach j of local width {
			if "`j'"!="." {
				confirm number `j'
			}
		}
	}
	if "`by'" != "" {
		qui egen `group' = group(`by')
		qui summarize `group', meanonly
		local ngroup = r(max)
		qui gen `id' = _n
	}
	else {
		qui gen `group' = `time'<.
		local ngroup = 1
	}
	if _N < 101 {
		set obs 101
	}
	qui summarize `time'
	if `tmin' == -1 {
		if `leftbnd' == -1 {
			local tmin = r(min)
		}
		else {
			local tmin = `leftbnd'
		}
	}
	if `tmax' == -1 {
		local tmax = r(max)
	}
	qui gen `tvar' = `tmin' + (_n-1)/100*(`tmax'-`tmin') in 1/101
	if "`nobnd'" == "" {
		if `"`kernel'"'=="epan2" | ///
		   bsubstr(`"`kernel'"',1,2) == "bi" | ///
		   bsubstr(`"`kernel'"',1,3) == "rec" {
			if  bsubstr(`"`kernel'"',1,2) == "bi" {
				local kernel biweight
			}
			if  bsubstr(`"`kernel'"',1,3) == "rec" {
				local kernel rectangle
			}
			local dobndk = 1
		}
		else {
			local dobndk = 0
		}
	}
	forvalues i = 1/`ngroup' {
		local w : word `i' of `width'
		if `"`w'"' != "" {
			if `"`w'"' == "." {
				local wopt 
			}
			else {
				local wopt width(`w')
			}
		}
		else {
			local wopt
		}
		version 8: qui kdensity `time' [iw=`deltah'] ///
			if `group'==`i', ///
			`kernel' `wopt' ///
			gen(__y`i') at(`tvar') ///
			nograph
		if `ngroup' == 1 {
			ret hidden scalar bwidth = `r(width)'
		}
		ret hidden scalar bwidth`i' = `r(width)'
		
		if "`nobnd'" == "" {
			// correct for boundary effects
			tempvar bnd
			local wwidth = r(width)
			qui summ `time' if `group'==`i'
			if `leftbnd' == -1 {
				local lbnd = r(min) + `wwidth'
			}
			else {
				local lbnd = `leftbnd' + `wwidth'
			}
			local rbnd = r(max) - `wwidth'
			if `lbnd' >= `rbnd' {
di as err "left and right boundary regions overlap;"
di as err "specify smaller bandwidth(s) in width()"
exit 198
			}
			qui gen `bnd' = ((`tvar'<`lbnd')|(`tvar'>`rbnd')) ///
					   &(`tvar'<.)
			// use boundary kernels or restrict range to 
			// [tmin+h,tmax-h]
			if `dobndk' == 1 {
				// do not recompute at interior points
				tempvar atbnd bndkern touse
				qui gen `touse' = (`time'<.)*(`deltah'<.)* ///
						  (`group'==`i')
				qui gen `bndkern' = .
				qui gen `atbnd' = `tvar' if `bnd' == 1
				qui count if `tvar'<=`rbnd'
				local indrb = r(N) + 1
				mata: _sts_bndkdensity( "`time'", "`atbnd'", ///
					"`deltah'", "`bndkern'", "`touse'",  ///
					"`bnd'", 1, `indrb', `wwidth',       ///
					`lbnd', `rbnd', &`kernel'(), 0)
				qui replace __y`i' = `bndkern' if `bnd'==1
			}
			else {
				qui replace __y`i' = . if `bnd' == 1
			}
		}
		// truncate negative estimates to zero
 		qui replace __y`i' = 0 if __y`i'<0
		// restrict the plotting range to [t_min_i, t_max_i]
		qui summ `time' if `group'==`i'
		if `leftbnd' == -1 {
			qui replace __y`i'=. if `tvar'<r(min) | `tvar'>r(max)
		}
		else {
			qui replace __y`i'=. if `tvar'<`leftbnd' | `tvar'>r(max)
		}
		qui gen __yy`i' = .
		if `"`wopt'"' == "" {
			quietly summ `time' if `group'==`i', detail
			local wid2 = min(r(sd), (r(p75)-r(p25))/1.349)
			if `wid2' <= 0.0 {
				local wid2 = r(sd)
			}
			local wid2 = 0.9*`wid2'/(r(N)^.20)
			local wopt width(`wid2')
		}
		di `" --wopt is--`wopt'"'
		_KDE2 `time' [iw=`deltaVh'] if `group'==`i', `kernel' ///
			at(`tvar') kde(__yy`i') `wopt'
		if "`dobndk'" == "1" {
			tempvar bndse
			// do not recompute at interior points
			qui replace `touse' = (`time'<.)*(`deltaVh'<.)* ///
					      (`group'==`i')
			qui gen `bndse' = .
			mata: _sts_bndkdensity( "`time'", "`atbnd'", ///
				      "`deltaVh'", "`bndse'", "`touse'",  ///
					"`bnd'", 1, `indrb', `wwidth',       ///
					`lbnd', `rbnd', &`kernel'(), 1)
			qui replace __yy`i' = `bndse' if `bnd'==1
		}
		if "`by'"!="" {
			sort `group' `time' `tvar'
			qui summ `id' if `group'==`i'
			local index r(min)
			version 8: qui gen __by`i' = `by'[`index'] in 1/101
		}
		local z = invnorm(1-(1-`level'/100)/2)
		quietly generate   __lb`i'= __y`i'* 		///
				exp(-`z'*sqrt(__yy`i')/__y`i') if __y`i'<.
		quietly generate   __ub`i' = __y`i'* 		///
				exp(`z'*sqrt(__yy`i')/__y`i')  if __y`i'<.
	}
	keep in 1/101
	if "`by'"!="" {
		qui replace `id' = _n
		reshape long __y __yy __ub __lb __by, i(`id')
	}
	drop `time' `deltah' `deltaVh' 
	if "`by'"!="" {
		drop `by'
		rename __y `deltah'
		rename __yy `deltaVh'
		rename __by `by'
		rename __ub `ub'
		rename __lb `lb'
		qui label variable `by' `"`varLab'"'
		cap confirm numeric variable `by'
		if _rc==0 {
			qui label values `by' `byLabel'
		}
	}
	else {
		rename __y1 `deltah'
		rename __yy1 `deltaVh'
		rename __ub1 `ub'
		rename __lb1 `lb'
	}
	rename `tvar' `time'
end

program define ForbidOpt
	if `"`1'"'!="" {
		di in red `"options `1' and hazard may not be combined"'
		exit 198
	}
end

program define ParseSaving, sclass
        * fn[,replace]

        sret clear
        if `"`0'"' == "" {
                exit
        }
        gettoken fn      0 : 0, parse(",")
        gettoken comma   0 : 0
        if length("`comma'") > 1 {
		local 0 = bsubstr("`comma'",2,.) + "`0'"
 		local comma = bsubstr("`comma'", 1,1)
	}
        gettoken replace 0 : 0
	
	local fn = trim(`"`fn'"')
        local 0 = trim(`"`0'"')
        if `"`fn'"'!="" & `"`0'"'=="" {
                if `"`comma'"'=="" | (`"`comma'"'=="," & `"`replace'"'=="") {
                        sret local fn `"`fn'"'
                        exit
                }
                if `"`comma'"'=="," & `"`replace'"'=="replace" {
                        sret local fn `"`fn'"'
                        sret local replace "replace"
                        exit
                }
        }
        di as err "option saving() misspecified"
        exit 198
end

version 10.0
mata:

void GetZipFileName()
{
        string scalar Tok, ReverseTok, FileName, Path

        Tok = st_global("s(fn)")
        Tok = subinstr(Tok, "\", "/")
        if (strpos(Tok, "/")) {
                ReverseTok = strreverse(Tok)
                FileName = ///
                strreverse(bsubstr(ReverseTok, 1, strpos(ReverseTok, "/")-1))
                Path = ///
                strreverse(bsubstr(ReverseTok, strpos(ReverseTok, "/"), .))

                if(strpos(FileName, ".") == 0) {
                        FileName = FileName + ".dta"
                        Tok = Path + FileName
                        st_local("newfile", Tok)
                }
                else {
                        st_local("newfile", Tok)
                }
        }
        else {
                if(strpos(Tok, ".") == 0) {
                        Tok = Tok + ".dta"
                        st_local("newfile", Tok)
                }
                else {
                        st_local("newfile", Tok)
                }
        }
}
end
exit
