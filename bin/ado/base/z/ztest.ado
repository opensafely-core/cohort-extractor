*! version 1.1.0  28mar2017
program define ztest, rclass byable(recall)
	version 14

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if `"`eq'"' == "==" {
		local 0 `vn' = `rest'
	}

	syntax varname [=/exp] [if] [in] [, /*
	*/ BY(varname) UNPaired Level(cilevel) /*
	*/ sddiff(passthru) corr(passthru) /*
	*/ sd1(passthru) sd2(passthru) sd(passthru) /*
	*/ cluster(passthru) rho1(passthru) rho2(passthru) rho(passthru)]

	
	marksample touse, novarlist 

	if `"`exp'"'!="" {
		if `"`by'"'!="" {
			di as err /*
		 */ "{p}option {bf:by()} and {bf:==} may not be combined{p_end}"
			exit 198
		}

		if `"`unpaired'"'!="" { /* do two-sample (unpaired) test */

			cap confirm variable `exp'
			if (_rc) {
				di as err /*
				*/ "{p} two variables must be specified " /*
				*/ "for unpaired z test {p_end}"
				exit 198
			}	
			if (`"`sddiff'`corr'"' != "") {
				di as err /*
			*/ "{p}options {bf:corr()} and {bf:sddiff()} may not" /*
				*/ " be specified for unpaired z test {p_end}"
				exit 198
			}
			
			if (`"`cluster'`rho'`rho1'`rho2'"' !="") {
				di as err "{p}options {bf:cluster()}, " ///
		"{bf:rho()}, {bf:rho1()}, and {bf:rho2()} not allowed " ///
		"with the syntax comparing two variables; " ///
		"you can {manhelp reshape D} your data to long form and " ///
		"use option {bf:by()}{p_end}"
				exit 198
			}
			Zt_two `varlist' `exp' if `touse',  /*
			*/ level(`level') `sd1' `sd2' `sd'
				
			ret add
			exit
		}

		/* If here, we do one-sample (paired) test. */

		capture confirm number `exp'
		if _rc==0 {
			if (`"`sddiff'`sd1'`sd2'`corr'"' != "") {
				di as err /*
*/ "{p}options {bf:sddiff()}, {bf:corr()}, {bf:sd1()}, and {bf:sd2()} " /*
	*/ "may not be specified for one-sample z test {p_end}"
				exit 198
			}

		if (`"`rho1'`rho2'"'!="") {
				di as err "options {bf:rho1()} and " ///
			"{bf:rho2()} not allowed with a one-sample test"
				exit 198	
			}
			if ((`"`cluster'"'!="" & `"`rho'"'=="") | ///
		(`"`cluster'"'=="" & `"`rho'"'!="")) {
		di as err "{p}both options {bf:cluster()} and " ///
	"{bf:rho()} must be specified to adjust for clustering{p_end}"
				exit 198
			}
			Zt_one `varlist' if `touse', /*
			*/ level(`level') `sd' exp(`exp') `cluster' `rho'
			ret add
			exit
		}

		confirm variable `exp'		
	
		if (`"`cluster'`rho'`rho1'`rho2'"' !="") {
			di as err "{p}options {bf:cluster()}, " ///
		"{bf:rho()}, {bf:rho1()}, and {bf:rho2()} not allowed " ///
		"with a paired test{p_end}"
			exit 198
		}
		
		Zt_paired `varlist' `exp' if `touse', /*
			*/ level(`level') `sddiff' `corr' `sd' `sd1' `sd2'
		
		ret add
		exit
	}

	/* If here, do two-sample (unpaired) test with by(). */

	if `"`by'"'=="" {
                di in red "option {bf:by()} required"
                exit 100
        }

	if (`"`sddiff'`corr'"' != "") {
		di as err "{p}options {bf:corr()} and {bf:sddiff()} "  /*
		*/ "may not be specified for unpaired z test {p_end}"
		exit 198
	}


        if ((`"`cluster'"'!="" & `"`rho'`rho1'`rho2'"'=="") | ///
                (`"`cluster'"'=="" & `"`rho'`rho1'`rho2'"'!="")) {
                di as err "{p}specify option {bf:cluster()} and either " ///
		"option {bf:rho()} or options {bf:rho1()} and {bf:rho2()} " ///
		"to adjust for clustering{p_end}"
                exit 198
        }
        if (`"`cluster'`rho'`rho1'`rho2'"' !="") {
                if ("`rho'"!="" & "`rho1'`rho2'"!="" ) {
                        di as err "{p}may not specify option " ///
                "{bf:rho()} with option {bf:rho1()} or {bf:rho2()}{p_end}"
                        exit 198
                }
                if ((`"`rho1'"'!="" & `"`rho2'"'=="") | ///
                        (`"`rho1'"'=="" & `"`rho2'"'!="" )) {
                        di as err "{p}options {bf:rho1()} and {bf:rho2()} " ///
                        "must be specified together{p_end}"
			exit 198
        	}
	}

	Zt_by `varlist' if `touse', level(`level') `sd1' `sd2' `sd' by(`by') ///
		`cluster' `rho' `rho1' `rho2'
	
	ret add
end

/* follow _ttest:ByString */
program define Zt_by, rclass
	syntax varlist [if] [in], level(cilevel) by(varname) /*
	*/ [sd(string) sd1(string) sd2(string) /*
	*/ cluster(varname) rho(string) rho1(string) rho2(string)]
	
	if (`"`rho'`rho1'`rho2'"'!="") {
		if (`"`rho'"'!="") {
			cap assert (`rho'>=-1 & `rho'<=1)
			if c(rc) {
				di as error "{p}option {bf:rho()} must " ///
				"contain a real value between -1 and 1{p_end}"
				exit 198
			}
			local rho1 `rho'
			local rho2 `rho'
		}
		else{
			cap assert (`rho1'>=-1 & `rho1'<=1)
			if c(rc) {
				di as error "{p}option {bf:rho1()} must " ///
				"contain a real value between -1 and 1{p_end}"
				exit 198
			}
			cap assert (`rho2'>=-1 & `rho2'<=1)
			if c(rc) {
				di as error "{p}option {bf:rho2()} must " ///
				"contain a real value between -1 and 1{p_end}"
				exit 198
			}
		}
	}		
					
	if (`"`sd'`sd1'`sd2'"' == "" ) {
		local sd1 = 1
		local sd2 = 1
	}

	else if (`"`sd'"'!= "" & (`"`sd1'"'!="" | `"`sd2'"'!=""))  {
		di as err "{p}may not specify option {bf:sd()} "  /*
		*/ "with option {bf:sd1()} or {bf:sd2()}{p_end}"
		exit 184
	}
	
	else if (`"`sd'"'!= "" & `"`sd1'`sd2'"'=="")  {
		cap assert `sd' > 0
		if (_rc) {
			di as err ///
			 "option {bf:sd()} must contain positive values"
			exit 411
		}	
		local sd1 = `sd'
		local sd2 = `sd'
	}	
	
	
	else if ((`"`sd1'"' != "" & `"`sd2'"' == "") | /*
	*/ (`"`sd2'"' != "" & `"`sd1'"' == "")) {
		di as err "{p}options {bf:sd1()} and {bf:sd2()} must be "  /*
		*/ "specified together{p_end}"
		exit 198
	}	

	else if (`"`sd1'"' != "" & `"`sd2'"' != "") {
		cap assert `sd1' > 0
		if (_rc) {
			di as err ///
			"option {bf:sd1()} must contain positive values"
			exit 411
		}
		cap assert `sd2' > 0
		if (_rc) {
			di as err ///
			"option {bf:sd2()} must contain positive values"
			exit 411
		}		
	}	

			
	capture confirm string variable `by'
	if c(rc) {
		Zt_by_number `varlist' `if' `in', level(`level') /*
		*/ by(`by') sd1(`sd1') sd2(`sd2') /*
		*/ rho1(`rho1') rho2(`rho2') cluster(`cluster')
	}
	else Zt_by_string `varlist' `if' `in', level(`level')/*
	*/ by(`by') sd1(`sd1') sd2(`sd2') /*
	*/ rho1(`rho1') rho2(`rho2') cluster(`cluster')
	ret add
end	

program define Zt_by_string, rclass
	syntax varlist [if] [in], level(cilevel) by(varname) ///
		sd1(real) sd2(real) ///
		[cluster(varname) rho(string) rho1(string) rho2(string)]
	marksample touse
	markout `touse' `by', strok
	if ("`cluster'"!="") { 
		markout `touse' `cluster', strok
	}		
	tempvar obs val1 val2
	
	gen `c(obs_t)' `obs' = _n if `touse'
	sum `obs' if `touse', mean
	if r(N) == 0 {
		noi error 2000
	}

/* get first value */
	scalar `val1' = `by'[r(min)]
	qui replace `obs' = . if `by' == `val1'
	sum `obs', mean
	if r(N) == 0 {
		di in red "1 group found, 2 required"
		exit 420
	}	
	scalar `val2' = `by'[r(min)]
	qui replace `obs' = . if `by' == `val2'
	sum `obs', mean
	if r(N) {
		di in red "more than 2 groups found, only 2 allowed"
		exit 420
	}
	
	
/* Make it so that `val1' < `val2' . */
	if `val1' > `val2' {
		tempname temp
		scalar `temp' = `val1'
		scalar `val1' = `val2'
		scalar `val2' = `temp'	
	}

/* Get #obs, mean for first group */	
	sum `varlist' if `by'==`val1' & `touse', mean
        local n1 = r(N)
        local m1 = r(mean)
/* Get #obs, mean for second group */	
	sum `varlist' if `by'==`val2' & `touse', mean
        local n2 = r(N)
        local m2 = r(mean)

	if ("`cluster'"!="") { 
		qui {
		preserve
		keep `cluster' `touse' `by'
		keep if `touse' & `by'==`val1'
		tempname count
		bysort `cluster': gen `count' = _N
		keep `cluster' `count'
		duplicates drop 
		local K1 = _N
		local M1 = `n1'/`K1'
		sum `count'
		local cvcluster1 = r(sd)/`M1'*sqrt((`K1'-1)/`K1')
		restore
		preserve
		keep `cluster' `touse' `by'
		keep if `touse' & `by'==`val2'
		tempname count
		bysort `cluster': gen `count' = _N
		keep `cluster' `count'
		duplicates drop 
		local K2 = _N
		local M2 = `n2'/`K2'
		sum `count'
		local cvcluster2 = r(sd)/`M2'*sqrt((`K2'-1)/`K2')
		restore
		}
	}
/* Shorten groups labels if necessary. */
	local val1 : display udsubstr(`val1',1,8)
	local val2 : display udsubstr(`val2',1,8)
/* Take substr() again because binary 0 might have expanded to \0 */
	local val1 = udsubstr(`"`val1'"',1,8)
	local val2 = udsubstr(`"`val2'"',1,8)
	
	
	if ("`cluster'"=="") {
		ztesti `n1' `m1' `sd1' `n2' `m2' `sd2', /*
		*/ xname(`"`val1'"') yname(`"`val2'"') level(`level')
	}
	else {
		ztesti `n1' `m1' `sd1' `n2' `m2' `sd2', /*
		*/ xname(`"`val1'"') yname(`"`val2'"') level(`level') /*
	*/ rho1(`rho1') rho2(`rho2') mm1(`M1') k1(`K1') mm2(`M2') k2(`K2') /*
	*/ cvcluster1(`cvcluster1') cvcluster2(`cvcluster2') idname("`cluster'")
	}
	ret add
end

program define Zt_by_number, rclass
	syntax varlist [if] [in], level(cilevel) by(varname) ///
		sd1(real) sd2(real) [cluster(varname) ///
		rho(string) rho1(string) rho2(string)]
	marksample touse
	markout `touse' `by'
	if ("`cluster'"!="") { 
		markout `touse' `cluster', strok
	}
	qui sum `by' if `touse', mean
	if r(N) == 0 {
		noi error 2000
	}

	/* check that there are exactly 2 groups */
	local min = r(min)
	local max = r(max)
        if `min' == `max' {
		di in red "1 group found, 2 required"
		exit 420
	}	
        qui count if `by'!=`min' & `by'!=`max' & `touse'   
	if r(N) {
		di in red "more than 2 groups found, only 2 allowed"
		exit 420
	}
	
	
	/* Get #obs, mean for first group */	
	qui sum `varlist' if `by'==`min' & `touse', mean
        local n1 = r(N)
        local m1 = r(mean)
	/* Get #obs, mean for first group */	
	qui sum `varlist' if `by'==`max' & `touse', mean
        local n2 = r(N)
        local m2 = r(mean)
	
	/* Get group labels */
	local lab1 `min'
	local lab2 `max'
	
	local bylab: value label `by'
	if `"`bylab'"'!="" {
		local lab1:label `bylab' `lab1'
		local lab2:label `bylab' `lab2'
	}	
	
	local lab1 = udsubstr(`"`lab1'"',1,8)
	local lab2 = udsubstr(`"`lab2'"',1,8)
	if ("`cluster'"=="") {
		ztesti `n1' `m1' `sd1' `n2' `m2' `sd2', /*
		*/ xname("`lab1'") yname("`lab2'") level(`level') 
	}
	else { 
		qui {
		preserve
		keep `cluster' `touse' `by'
		keep if `touse' & `by'==`min'
		tempname count
		bysort `cluster': gen `count' = _N
		keep `cluster' `count'
		duplicates drop 
		local K1 = _N
		local M1 = `n1'/`K1'
		sum `count'
		local cvcluster1 = r(sd)/`M1'*sqrt((`K1'-1)/`K1')
		restore
		preserve
		keep `cluster' `touse' `by'
		keep if `touse' & `by'==`max'
		tempname count
		bysort `cluster': gen `count' = _N
		keep `cluster' `count'
		duplicates drop 
		local K2 = _N
		local M2 = `n2'/`K2'
		sum `count'
		local cvcluster2 = r(sd)/`M2'*sqrt((`K2'-1)/`K2')
		restore
		}
		
		ztesti `n1' `m1' `sd1' `n2' `m2' `sd2', /*
		*/ xname("`lab1'") yname("`lab2'") level(`level') /*
	*/ rho1(`rho1') rho2(`rho2') mm1(`M1') k1(`K1') mm2(`M2') k2(`K2') /*
	*/ cvcluster1(`cvcluster1') cvcluster2(`cvcluster2') idname("`cluster'")
	}
	
	ret add
end

program define Zt_two, rclass
	syntax varlist [if] [in], level(cilevel) /*
	*/ [sd(string) sd1(string) sd2(string)]
	
	if (`"`sd'`sd1'`sd2'"' == "" ) {
		local sd1 = 1
		local sd2 = 1	
		
	}
	else if (`"`sd'"'!= "" & (`"`sd1'"'!="" | `"`sd2'"'!=""))  {
		di as err "{p}may not specify option {bf:sd()} with "  /*
		*/ "option {bf:sd1()} or {bf:sd2()}{p_end}"
		exit 184
	}
	else if (`"`sd'"'!= "" & `"`sd1'`sd2'"'=="")  {
		cap assert `sd' > 0
		if (_rc) {
			di as err ///
			"option {bf:sd()} must contain positive values"
			exit 411
		}	
		local sd1 = `sd'
		local sd2 = `sd'
	}		
	else if ((`"`sd1'"' != "" & `"`sd2'"' == "") | /*
	*/ (`"`sd2'"' != "" & `"`sd1'"' == "")) {
		di as err "{p}options {bf:sd1()} and {bf:sd2()} must be "  /*
		*/ "specified together{p_end}"
		exit 198
	}	
	else if (`"`sd1'"' != "" & `"`sd2'"' != "") {
		cap assert `sd1' > 0
		if (_rc) {
			di as err ///
				"option {bf:sd1()} must contain positive values"
			exit 411
		}
		cap assert `sd2' > 0
		if (_rc) {
			di as err ///
				"option {bf:sd2()} must contain positive values"
			exit 411
		}		
	}	
	
		
	marksample touse, novarlist 

        tokenize `varlist'
	qui sum `1' if `touse', mean
        local n1 = r(N)
        local m1 = r(mean)     

	qui sum `2' if `touse', mean
        local n2 = r(N)
        local m2 = r(mean)
 
	ztesti `n1' `m1' `sd1' `n2' `m2' `sd2', /*
		*/ xname("`1'") yname("`2'") level(`level')
	ret add

end

program define Zt_one, rclass
	syntax varname [if] [in], level(cilevel) exp(real) [sd(real 1) ///
		cluster(varname) rho(string)] 
	if (`"`rho'"'!="") {
		cap assert (`rho'>=-1 & `rho'<=1)
		if c(rc) {
			di as error "{p}option {bf:rho()} must contain a " ///
			"real value between -1 and 1{p_end}"
			exit 198
		}
	}	
	if (`sd' <= 0) {
		di as err "option {bf:sd()} must contain positive values"
		exit 411		
	}	

        marksample touse
	if ("`cluster'"!="") {
		markout `touse' `cluster', strok
	}	
	qui sum `varlist' if `touse', mean
        local n = r(N)
        local m = r(mean)     

	if ("`cluster'"=="") {
		ztesti `n' `m' `sd' `exp', xname("`varlist'") level(`level')
	}
	else { 
		qui {
		preserve
		keep `cluster' `touse'
		keep if `touse'
		tempname count
		bysort `cluster': gen `count' = _N
		keep `cluster' `count'
		duplicates drop 
		local K = _N
		local M = `n'/`K'
		sum `count'
		local cvcluster = r(sd)/`M'*sqrt((`K'-1)/`K')
		restore
		}
		ztesti `n' `m' `sd' `exp', xname("`varlist'") level(`level') ///
	rho(`rho') mm(`M') k(`K') cvcluster(`cvcluster') idname("`cluster'")
	}
	ret add

end


program define Zt_paired, rclass
	syntax varlist [if] [in], level(cilevel) [sddiff(string) /*
	*/ corr(string) sd(string) sd1(string) sd2(string)]

	/* parse options */
	if (`"`sddiff'"' != "") {
		if ("`corr'`sd1'`sd2'`sd'" != "") {
			di as err /*
		  */ "{p}may not specify option {bf:sddiff()} with option " /*
	*/ "{bf:corr()}, {bf:sd()}, {bf:sd1()}, or {bf:sd2()}{p_end}"
			exit 184	
		}

		cap assert `sddiff' > 0
		if (_rc) {
			di as err ///
			"option {bf:sddiff()} must contain positive values"
			exit 411
		}	
	}
		
		
	else if (`"`sddiff'`corr'"' == "") {
		di as err /*
	*/ "{p}option {bf:corr()} or option {bf:sddiff()} must be specified" /*
		*/ " for a paired z test {p_end}"
		exit 198
	}
	
	else if (`"`corr'"' != "") {	
		
		cap assert (`corr' >= -1 & `corr' <=1)
		if (_rc) {
			di as err "{p}option {bf:corr()} must be between -1" /*
			*/ " and 1, inclusively {p_end}"
			exit 198
		}	
			
		if (`"`sd'`sd1'`sd2'"' == "" ) {
			local sd1 = 1
			local sd2 = 1
		}

		else if (`"`sd'"'!= "" & (`"`sd1'"'!="" | `"`sd2'"'!=""))  {
			di as err "{p}may not specify option {bf:sd()}"  /*
			*/ "with option {bf:sd1()} or {bf:sd2()}{p_end}"
			exit 184
		}
	
		else if (`"`sd'"'!= "" & `"`sd1'`sd2'"'=="")  {
			cap assert `sd' > 0
			if (_rc) {
				di as err /*
			*/ "option {bf:sd()} must contain positive values"
				exit 411
			}
			local sd1 = `sd'
			local sd2 = `sd'
		}	
	
		else if ((`"`sd1'"' != "" & `"`sd2'"' == "") | /*
		*/ (`"`sd2'"' != "" & `"`sd1'"' == "")) {
			di as err "{p}options {bf:sd1()} and {bf:sd2()} " /*
			*/ "must be specified together{p_end}"
			exit 198
		}	

		else if (`"`sd1'"' != "" & `"`sd2'"' != "") {
			cap assert `sd1' > 0
			if (_rc) {
				di as err /*
			*/ "option {bf:sd1()} must contain positive values"
				exit 411
			}
			cap assert `sd2' > 0
			if (_rc) {
				di as err /*
			*/ "option {bf:sd2()} must contain positive values"
				exit 411
		}		
	}	
	
		local sddiff = sqrt(`sd1'^2+`sd2'^2-2*`corr'*`sd1'*`sd2')
	
	}	
		
	marksample touse
	tokenize `varlist'
	tempvar diff

	
	quietly {
		summarize `1' if `touse', mean
		local m1 = r(mean)
		summarize `2' if `touse', mean
		local m2 = r(mean)
		
		gen double `diff' = `1' - `2' if `touse'
		summarize `diff', mean
		local n = r(N)
		local m = r(mean)
	
		if `n' == 0  {
			noisily error 2000 
		}
	}
/* Compute statistics. */

        local z  = `m'*sqrt(`n')/`sddiff'
        local se = `sddiff'/sqrt(`n')

        local p = 2 - 2*normal(abs(`z'))
        if `z' < 0 {
                local pl = `p'/2
                local pr = 1 - `pl'
        }
        else {
                local pr = `p'/2
                local pl = 1 - `pr'
        }

/* Display table of mean, std err, etc. */

	di _n in gr "Paired z test"

	_ttest header `level' `1'

	if (`"`corr'"'!="") {
		_ttest table `level' `1' `n' `m1' `sd1' ztest
		_ttest table `level' `2' `n' `m2' `sd2' ztest
		_ttest divline
	}
	_ttest table `level' "diff" `n' `m' `sddiff' ztest

	_ttest botline
	di as txt _col(6) "mean(diff) = mean(" as res /// 
		abbrev(`"`1'"',16) as txt ///
		" - " as res abbrev(`"`2'"',16) as txt ")" ///
		as txt _col(67) "z = " as res %8.4f `z'

/* Display Ho. */

	di as txt " Ho: mean(diff) = 0" _col(50) as txt 

/* Display Ha. */

        local tt : di %8.4f `z'
        local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'

        di
        _ttest center2 "Ha: mean(diff) < 0"  /*
	*/             "Ha: mean(diff) != 0" /*
	*/             "Ha: mean(diff) > 0"

        _ttest center2 "Pr(Z < z) = @`p1'@"   /*
        */             "Pr(|Z| > |z|) = @`p2'@" /*
        */             "Pr(Z > z) = @`p3'@"

/* Save results. */

	local q =  invnormal((100+`level')/200)
	ret scalar level = `level'
	ret scalar p_u  = `pr'
	ret scalar p    = `p'
	ret scalar p_l  = `pl'
	ret scalar z    = `z'
	ret scalar ub_diff = `m1' - `m2' + `q'*(`se')
	ret scalar lb_diff = `m1' - `m2' - `q'*(`se')
	ret scalar se_diff   = `se'
	ret hidden scalar se   = `se'
	ret scalar sd_diff = `sddiff'
	ret hidden scalar sd_d = `sddiff'
	if (`"`corr'"' !="") {
		ret scalar ub2 = `m2' + `q'*(`sd2'/sqrt(`n'))
		ret scalar lb2 = `m2' - `q'*(`sd2'/sqrt(`n'))
		ret scalar ub1 = `m1' + `q'*(`sd1'/sqrt(`n'))
		ret scalar lb1 = `m1' - `q'*(`sd1'/sqrt(`n'))
		ret scalar se2 = `sd2'/sqrt(`n')
		ret scalar se1 = `sd1'/sqrt(`n')
		ret scalar sd2 = `sd2'
		ret scalar sd1 = `sd1'
		ret hidden scalar sd_2 = `sd2'
		ret hidden scalar sd_1 = `sd1'
		ret scalar corr = `corr'
	}
	
	ret scalar mu_diff = `m1' - `m2'
	ret scalar mu2 = `m2'
	ret scalar mu1 = `m1'
        ret scalar N2  = `n'
	ret scalar N1  = `n'
	ret hidden scalar mu_2 = `m2'
	ret hidden scalar mu_1 = `m1'
        ret hidden scalar N_2  = `n'
	ret hidden scalar N_1  = `n'
	
end


