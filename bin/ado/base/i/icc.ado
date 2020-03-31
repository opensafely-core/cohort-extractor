*! version 1.0.3  14jan2016  
program define icc, rclass byable(recall) sortpreserve
	version	12
	syntax varlist [if] [in], [Level(cilevel) TESTVALue(real 0) ///
		mixed CONSistency ABSolute Format(string)]
        local level = string(`level',"%9.0g")
	tokenize `varlist'
	local depvar `1'
	local target `2'
	local rater `3'
	capture assert "`4'" == "" 
	if _rc {
		di as err "only one rater variable allowed"
		di as err "{p 4 4 2}{bf:icc} requires data in long form."
		di as err "If your data are in wide form, use {helpb reshape}"
		di as err "to convert data to long form{p_end}"
		exit 198
	}
	capture assert "`target'" != ""
	if _rc {
		di as error "No target variable specified"
		exit 198
	}
	capture assert `testvalue' >= 0 & `testvalue' < 1
	if _rc {
		di as error ///
		"{bf:testvalue()} must be nonnegative number less than 1"
		exit 198
	}
	if ("`rater'" == "") {
		local oneway oneway
	}
	if ("`consistency'" != "" & "`absolute'" != "") {
		di as error ///
"only one of {bf:consistency} or {bf:absolute} may be specified"
		exit 198
	}
	if ("`mixed'" == "") {
		local random random
	}
	else if ("`oneway'" != "") {
		di as error "{p}you must specify the rater variable " ///
				"with mixed-effects models{p_end}"
			exit 198
	}
	if ("`oneway'" != "") {
		capture assert "`consistency'" == ""
		if (_rc) {
			di as error ///
				"{p}{bf:consistency} is not allowed with " ///
				"one-way" ///
				" random-effects models{p_end}"
			exit 198
		}
	}
	else if ("`random'" == "" & "`absolute'"=="") {
		local consistency consistency
	}

        if (`"`format'"' != "") {
		local l = bsubstr("`format'",1,1)
		capt local tmp : display `format' 1
                if (_rc | "`l'" != "%") {
                        di as err `"invalid %fmt in format(): `format'"'
                        exit 120
                }
		// check that format is numeric format
		tempname isnumfmt 
		scalar `isnumfmt' = .
		mata: st_numscalar("`isnumfmt'",st_isnumfmt("`format'"))
		if (`isnumfmt' == 0) {
			di as err `"%fmt in format() is not numeric: `format'"'
			exit 7
		}
        }
	else {
		local format %9.0g
	}
	
	// check that format is not too big	
	// get width
	local formatwidth = fmtwidth("`format'")
	if (`formatwidth' > 9) {
		di as error "invalid {bf:format()};"
		di as error "width too large"
		exit 198	
	}


	marksample touse, strok
        // possible there are no observations
        // see if there are initially none
        qui count if `touse' == 1
        if (r(N) == 0) {
                error 2000
        }
        cap confirm numeric variable `target'
        local rc = _rc
        if !`rc' {
                qui summ `target' if `touse', meanonly
                if (r(min)==r(max)) {
                        di as error "insufficient number of targets"
                        exit 2001
                }
        }
        else {
                tempvar kn 
                sort `touse' `target'
                qui by `touse' `target' : gen long `kn' = _n == _N
                sum `kn' if `touse', mean
                if (r(sum) <= 1) {
                        di as error "insufficient number of targets"
                        exit 2001        
                }
        }
	tempvar order
	gen `order' = _n
	// error out if multiple observations per rater
	if ("`rater'" != "") {
		sort `touse' `target' `rater' `order'
		qui capture by `touse' `target' `rater': ///
			assert _N==1 if `touse'
		if (_rc) {
			di as error ///
		"multiple observations per target and rater not allowed"
			exit 498	
		}
	}	
	// drop out targets that cause imbalance
	// calculate k
	tempvar k Ni
	if ("`oneway'" != "") {
		sort `touse' `target' `order'	
		qui by `touse' `target': gen `c(obs_t)' `Ni' = _N if `touse' == 1
		qui sum `Ni', meanonly
		scalar `k' = r(max)
	}
	else {
		tempvar zinit
		sort `touse' `rater' `order'
		qui by `touse' `rater': gen byte `zinit' = _n == 1
		qui sum `zinit' if `touse', meanonly
		scalar `k' = r(sum)	
		sort `touse' `target' `order'
                qui by `touse' `target': gen `c(obs_t)' `Ni' = _N if `touse' == 1
	}
	if (`k' == 1) {
		di as error "{p}insufficient number of raters " /// 
			"(observations per target){p_end}"
		exit 2001
	}
	// now see if balancing targets leads to no observations
	tempvar incomplete
	qui by `touse' `target': gen byte ///
		`incomplete' = `Ni' != `k' if _n==1 & `touse'
	qui count if `incomplete' == 1
	local N_incomplete = r(N)
        if (`N_incomplete' != 0 & "`oneway'"!="") {
        	di as text ///
		"{p 0 0 2}({res}`N_incomplete'{txt} "  ///
		plural(`N_incomplete',"target") " " ///
		" omitted from computation because of" ///
		" unbalanced data){p_end}"
	}
        else if (`N_incomplete' != 0) {
        	di as text ///
		"{p 0 0 2}({res}`N_incomplete'{txt} "  ///
		plural(`N_incomplete',"target") " " ///
		" omitted from computation because" ///
		" not rated by all raters){p_end}"
        }
	qui replace `touse' = 0 if `Ni' != `k'
	qui count if `touse' == 1
	if (r(N) == 0) {
		error 2000
	}
	sort `touse' `target' `order'	
        if !`rc' {
                qui summ `target' if `touse', meanonly
                if (r(min)==r(max)) {
                        di as error "insufficient number of targets"
                        exit 2001
                }
        }
        else {
                tempvar kn
                qui by `touse' `target' : gen long `kn' = _n == _N
                sum `kn' if `touse', mean
                if (r(sum) <= 1) {
                        di as error "insufficient number of targets"
                        exit 2001        
                }
        }

		//Total Sum of Squares
	tempname N SST DFT MST
	qui sum `depvar' if `touse'

	scalar `N' = r(N)
	scalar `DFT' = `N' - 1
        scalar `SST' = r(Var) * `DFT'
	scalar `MST' = r(Var)

		//Within Targets	
	tempvar myi
	qui by `touse' `target': gen double `myi' = sum(`depvar')/`k' ///
		if `touse'
	qui by `touse' `target': replace `myi' = `myi'[_N] if `touse'
	tempvar iSSW
	qui gen double `iSSW' = (`depvar'-`myi')^2 if `touse'
	qui sum `iSSW' if `touse', meanonly
	tempname SSW
	scalar `SSW' = r(sum)
	tempvar egrpt
	qui egen `egrpt' = group(`target') if `touse'
        qui summ `egrpt', meanonly
		// calculate n
	tempname DFBMS DFWMS
        scalar `DFBMS' = r(max) - 1	
	scalar `DFWMS' = `DFT' - `DFBMS'	
	tempname n
	scalar `n' = `DFBMS'+1
	tempname WMS
	scalar `WMS' = `SSW'/`DFWMS'
	
		//Between targets
	tempname BMS
	scalar `BMS' = (`SST'-`SSW')/`DFBMS'
	tempname DFJMS
	scalar `DFJMS'  = `k' - 1
	tempname MSR MSW 
	scalar `MSR' =`BMS'
	scalar `MSW' =`WMS'
	local plevel = `level'/100
	
	tempname icc1 icck Ft Ftabl Ftabu icc1_l icc1_u icck_l icck_u ///
		 icc1_t icc1_dfn icc1_dfd icc1_p icck_t icck_dfn ///
		 icck_dfd icck_p

	if ("`oneway'" != "") {	
		scalar `icc1' = (`MSR'-`MSW')/(`MSR'+(`k'-1)*`MSW')
		scalar `icck' = (`MSR'-`MSW')/`MSR'
		scalar `Ft' = `MSR'/`MSW'
		scalar `Ftabl' = invF(`n'-1,`n'*(`k'-1),1-.5*(1-`plevel'))
		scalar `Ftabu' = invF(`n'*(`k'-1),`n'-1,1-.5*(1-`plevel'))
		scalar `icc1_l' = ((`Ft'/`Ftabl') - 1) / ///
			((`Ft'/`Ftabl')  + `k' - 1)
		scalar `icc1_u' = ((`Ft'*`Ftabu') - 1) / ///
			((`Ft'*`Ftabu')  + `k' - 1)
		scalar `icck_l' = 1 - 1/(`Ft'/`Ftabl')
		scalar `icck_u' = 1 - 1/(`Ft'*`Ftabu')
		scalar `icc1_t' = (`MSR'/`MSW')*(1-`testvalue')/ ///
			(1+(`k'-1)*`testvalue')
		scalar `icc1_p' = 1-F(`n'-1,`n'*(`k'-1),`icc1_t')
		scalar `icc1_dfn' = `n'-1
		scalar `icc1_dfd' = `n'*(`k'-1)
		scalar `icck_t' = (`MSR'/`MSW')*(1-`testvalue')
		scalar `icck_p' = 1-F(`n'-1,`n'*(`k'-1),`icck_t')
		scalar `icck_dfn' = `n'-1
		scalar `icck_dfd' = `n'*(`k'-1)
	}
	else {
		sort `touse' `rater' `order'	
		tempvar myir
		qui by `touse' `rater': gen double `myir' = ///
			sum(`depvar')/`n' if `touse'
		qui by `touse' `rater': replace `myir' = `myir'[_N] if `touse'
		tempvar iSSWr
		qui gen double `iSSWr' = (`depvar'-`myir')^2 if `touse'
		qui sum `iSSWr' if `touse', meanonly
		tempname SSWr
		scalar `SSWr' = r(sum)

		tempname JMS
		scalar `JMS' = (`SST' - `SSWr')/`DFJMS'
		tempname EMS DFEMS
		scalar `DFEMS' = `DFBMS'*`DFJMS'
		scalar `EMS' = (`SST' - `JMS'*`DFJMS' - `BMS'*`DFBMS')/`DFEMS'
		tempname MSC MSE
		scalar `MSC' =`JMS'
		scalar `MSE' =`EMS'

		scalar `Ft' = `MSR'/`MSE' 
		scalar `Ftabl' = invF(`n'-1,(`n'-1)*(`k'-1),1-.5*(1-`plevel'))
		scalar `Ftabu' = invF((`n'-1)*(`k'-1),`n'-1,1-.5*(1-`plevel'))	
		
		if ("`consistency'" != "") {
			scalar `icc1' = (`MSR'-`MSE')/(`MSR' + (`k'-1)*`MSE')
			scalar `icck' = (`MSR'-`MSE')/`MSR'
			scalar `icc1_l' = ((`Ft'/`Ftabl') - 1) / ///
				((`Ft'/`Ftabl')  + `k' - 1)
			scalar `icc1_u' = ((`Ft'*`Ftabu') - 1) / ///
				((`Ft'*`Ftabu')  + `k' - 1)
			scalar `icck_l' = 1 - 1/(`Ft'/`Ftabl')
			scalar `icck_u' = 1 - 1/(`Ft'*`Ftabu')
			scalar `icc1_t' = ///
				(`MSR'/`MSE')*(1-`testvalue')/ ///
				(1+(`k'-1)*`testvalue')
			scalar `icc1_p' = 1-F(`n'-1,(`n'-1)*(`k'-1),`icc1_t')
			scalar `icc1_dfn' = `n'-1
			scalar `icc1_dfd' = (`n'-1)*(`k'-1)
			scalar `icck_t' = (`MSR'/`MSE')*(1-`testvalue')
			scalar `icck_p' = 1-F(`n'-1,(`n'-1)*(`k'-1),`icck_t')
			scalar `icck_dfn' = `n'-1
			scalar `icck_dfd' = (`n'-1)*(`k'-1)
		}
		else {
			scalar `icc1' = (`MSR'-`MSE')/ ///
					(`MSR' + (`k'-1)*`MSE' + ///
					(`k'/`n')*(`MSC'-`MSE'))
			scalar `icck' = (`MSR'-`MSE')/(`MSR'+(`MSC'-`MSE')/`n')
			tempname a b v c d 
			scalar `a' = `k'*`icc1'/(`n'*(1-`icc1'))
			scalar `b' = 1 + `k'*`icc1'*(`n'-1)/(`n'*(1-`icc1'))
			scalar `v' = ((`a'*`MSC' + `b'*`MSE')^2)/( ///
				((`a'*`MSC')^2)/(`k'-1) + ///
				((`b'*`MSE')^2)/((`n'-1)*(`k'-1)))
			scalar `Ftabl' = invF(`n'-1,`v',1-.5*(1-`plevel'))
			scalar `Ftabu' = invF(`v',`n'-1,1-.5*(1-`plevel'))	
			scalar `icc1_l' = `n'*(`MSR'-`Ftabl'*`MSE')/ ///
				(`Ftabl'*(`k'*`MSC' + ///
				(`k'*`n'-`k'-`n')*`MSE')+`n'*`MSR')
			scalar `icc1_u' = `n'*(`Ftabu'*`MSR'-`MSE')/ ///
				(`k'*`MSC' + (`k'*`n'-`k'-`n')*`MSE' + ///
				`n'*`Ftabu'*`MSR')
			
			scalar `a' = `icck'/(`n'*(1-`icck'))
			scalar `b' = 1 + `icck'*(`n'-1)/(`n'*(1-`icck'))
			scalar `v' = ((`a'*`MSC' + `b'*`MSE')^2)/( ///
				((`a'*`MSC')^2)/(`k'-1) + ((`b'*`MSE')^2) ///
				/((`n'-1)*(`k'-1)))		
			scalar `Ftabl' = invF(`n'-1,`v',1-.5*(1-`plevel'))
			scalar `Ftabu' = invF(`v',`n'-1,1-.5*(1-`plevel'))	
			scalar `icck_l' = `n'*(`MSR'-`Ftabl'*`MSE')/ ///
				(`Ftabl'*(`MSC'-`MSE') + `n'*`MSR')
			scalar `icck_u' = `n'*(`Ftabu'*`MSR'-`MSE')/ ///
				(`MSC'-`MSE'+`n'*`Ftabu'*`MSR')
				
			scalar `a' = `k'*`testvalue'/(`n'*(1-`testvalue'))
			scalar `b' = 1 + `k'*`testvalue'*(`n'-1)/ ///
				(`n'*(1-`testvalue'))
			scalar `v' = ((`a'*`MSC' + `b'*`MSE')^2)/ ///
				(((`a'*`MSC')^2)/(`k'-1) + ///
				((`b'*`MSE')^2)/((`n'-1)*(`k'-1)))
			scalar `icc1_t' = `MSR'/(`a'*`MSC'+`b'*`MSE')
			scalar `icc1_dfn' = `n'-1
			scalar `icc1_dfd' = `v'
			scalar `icc1_p' = 1-F(`n'-1,`v',`icc1_t')

			scalar `c' = `testvalue'/(`n'*(1-`testvalue'))
			scalar `d' = 1 + `testvalue'*(`n'-1)/ ///
				(`n'*(1-`testvalue'))
			scalar `v' = ((`c'*`MSC' + `d'*`MSE')^2)/ ///
				(((`c'*`MSC')^2)/(`k'-1) + ///
				((`d'*`MSE')^2)/((`n'-1)*(`k'-1)))
			scalar `icck_t' = `MSR'/(`c'*`MSC'+`d'*`MSE')
			scalar `icck_dfn' = `n'-1 
			scalar `icck_dfd' = `v'
			scalar `icck_p' = 1-F(`n'-1,`v',`icck_t')
		}							
	}	
	
	if ("`consistency'" != "") {
		return local type consistency
	}
	else {
		return local type absolute
	}

	return local rater `rater'
	return local target `target'
	return local depvar `depvar'

	local depvar = abbrev("`depvar'",22)
	local target = abbrev("`target'",14)
	local rater = abbrev("`rater'",14)
	local dfmt = max(length("`target'"),length("`rater'"))
        local dcol = 31 - max(length("`target'"),length("`rater'"))
	di ""
	di as text "Intraclass correlations"
	if ("`oneway'" != "") {
		di as text "One-way random-effects model"
		di as text "Absolute agreement"
		di ""
                di as text "Random effects: " as res %-`dfmt's ///
			"`target'" ///
			as text _col(34) "Number of targets =  " ///
			as result %8.0f `n'
		di as text _col(34) "Number of raters  =  "  ///
			as result %8.0f `k'
		di	
	}
	else if ("`random'" != "") {
		di as text "Two-way random-effects model"
	        if ("`consistency'" != "") {
                        di as text "Consistency of agreement"
                }
                else {
                        di as text "Absolute agreement"
                }
		di ""
		di as text "Random effects: " as res %-`dfmt's ///
			"`target'"  ///
			as text _col(34) "Number of targets =  " ///
			as result %8.0f `n'
		di as text "Random effects: " as res %-`dfmt's ///
			"`rater'"  ///
			as text _col(34) "Number of raters  =  "  ///
			as result %8.0f `k'
		di	
	}
	else {
		di as text "Two-way mixed-effects model"
         	if ("`consistency'" != "") {
			di as text "Consistency of agreement"
                }
                else {
                        di as text "Absolute agreement"
                }

		di ""
		di as text "Random effects: " as res %-`dfmt's ///
			"`target'"  ///
			as text _col(34) "Number of targets =  " ///
			as result %8.0f `n'
		di as text " Fixed effects: " as res %-`dfmt's ///
			"`rater'"  ///
			as text _col(34) "Number of raters  =  "  ///
			as result %8.0f `k'	
		di 
	}	

	//check that displayed format is not too small
	foreach lname in `icc1' `icc1_l' `icck_u'  `icc1' `icck_l' `icck_u' {
		capture assert length(string(`lname',"`format'")) ///
			<= `formatwidth'
		if _rc {
			di in smcl as error "invalid {bf:format()};"
			di as error "width too small"
			exit 198	
		}	
	}

	// determine numeric output columns based on `formatwidth'
	local left = bsubstr("`format'",2,1) == "-"
	tempname mytab
	.`mytab' = ._tab.new, col(5) lmargin(0)
        .`mytab'.width    23   |12  2  12    12
	.`mytab'.sep, top
	if (`left' == 0) {
		local padit1 = 12-(`formatwidth'+1)
		local padit2 = 12-`formatwidth'
	}
	else {
		local padit1 = 2
		local padit2 = 3
	}
	.`mytab'.pad       .     `padit1'  .  `padit2'     `padit2'
        .`mytab'.titlefmt  .   %6s  %2s %24s     .
	.`mytab'.numfmt    . `format' . `format' `format'
        .`mytab'.titles "`depvar'"                      ///
                        "        ICC"       "  "                  ///
                        "[`=strsubdp("`level'")'% Conf. Interval]" ""
	
	.`mytab'.sep
	.`mytab'.row    "Individual"              ///
                                `icc1'  "  "      ///
                                `icc1_l' `icc1_u'
	.`mytab'.row    "Average"                ///
                                `icck'   "  "     ///
                                `icck_l' `icck_u'				
	.`mytab'.sep, bottom

	di as text "F test that"
	if (`testvalue' != 0) {
		local fstatstr1 = "{txt}ICC(1)={res}" + ///
			string(`testvalue',"%4.2f") + ///
			"{txt}: F({res}" + ///
			string(`icc1_dfn',"%8.1f") + "{txt}, {res}" ///
			+ string(`icc1_dfd',"%8.1f") + "{txt}) = {res}" + ///
			string(`icc1_t',"%8.2f")
		local nosmcfstatstr1 = "ICC(1)=" + ///
			string(`testvalue',"%4.2f") + ///
			": F(" + string(`icc1_dfn',"%8.1f") + ", " ///
			+ string(`icc1_dfd',"%8.1f") + ") = " + ///
			string(`icc1_t',"%8.2f")			
	}
	else {
		local fstatstr1 = "{txt}ICC={res}" + ///
			string(`testvalue',"%4.2f") + ///
			"{txt}: F({res}" + ///
			string(`icc1_dfn',"%8.1f") + "{txt}, {res}" ///
			+ string(`icc1_dfd',"%8.1f") + "{txt}) = {res}" + ///
			string(`icc1_t',"%8.2f")
		local nosmcfstatstr1 = "ICC=" + ///
			string(`testvalue',"%4.2f") + ///
			": F(" + string(`icc1_dfn',"%8.1f") + ", " ///
			+ string(`icc1_dfd',"%8.1f") + ") = " + ///
			string(`icc1_t',"%8.2f")	 	
	}		
	
	local fstatstrk = "{txt}ICC(k)={res}" + ///
		string(`testvalue',"%4.2f") + ///
		"{txt}: F({res}" + ///
		string(`icck_dfn',"%8.1f") + "{txt}, {res}" ///
		 + string(`icck_dfd',"%8.1f") + "{txt}) = {res}" + ///
		 string(`icck_t',"%8.2f")
	local nosmcfstatstrk = "ICC(k)=" + string(`testvalue',"%4.2f") + ///
		": F(" + string(`icck_dfn',"%8.1f") + ", " ///
		 + string(`icck_dfd',"%8.1f") + ") = " + ///
		 string(`icck_t',"%8.2f")
 		  
	local maxl = max(length(`"`nosmcfstatstr1'"'), ///
			length(`"`nosmcfstatstrk'"'))
	local space
	forvalues i = 1/2 {
		if (`i' + `maxl' < 47 -1) {
			local space "`space' "
		}		
	}	
	di in smcl `"`space'`fstatstr1'"' _col(47) ///
		"{txt}Prob > F = {res}" %5.3f `icc1_p'
	if (`testvalue' != 0) {	
		di in smcl `"`space'`fstatstrk'"' _col(47) ///
			"{txt}Prob > F = {res}" %5.3f `icck_p'
	}
	if ("`oneway'" != "" | ///
		(("`random'" != "" & "`consistency'" == "") | ///
		 ("`random'" == "" & "`consistency'" != ""))) {
		di ""
		di as text ///
		"{p 0 6 2 67}Note: ICCs estimate correlations between " ///
		"individual measurements and between average " ///
		"measurements made on the same target.{p_end}"
	}
	if ("`oneway'" != "") {
		return local model "one-way random effects"
	}
	else if ("`random'" == "") {
		return local model "two-way mixed effects"
	}	
	else {
		return local model "two-way random effects"
	}

	return scalar level = `level'
	return scalar testvalue = `testvalue'	
	
	if ("`oneway'" == "") {
		return hidden scalar ems = `EMS'
		return hidden scalar wms = `WMS'
		return hidden scalar jms = `JMS'
		return hidden scalar bms = `BMS'		
	}
	else {
		return hidden scalar wms = `WMS'
		return hidden scalar bms = `BMS'
	}

        return scalar icc_avg_ub = `icck_u'
        return scalar icc_avg_lb = `icck_l'
	return scalar icc_avg_p = `icck_p'
	return scalar icc_avg_df2 = `icck_dfd'
	return scalar icc_avg_df1 = `icck_dfn'
	return scalar icc_avg_F = `icck_t'
	return scalar icc_avg = `icck'
	
        return scalar icc_i_ub = `icc1_u'
        return scalar icc_i_lb = `icc1_l'
	return scalar icc_i_p = `icc1_p'
	return scalar icc_i_df2 = `icc1_dfd'	
	return scalar icc_i_df1 = `icc1_dfn'
	return scalar icc_i_F = `icc1_t'
	return scalar icc_i = `icc1'
	return scalar N_rater = `k'
	return scalar N_target = `n'

end

exit
