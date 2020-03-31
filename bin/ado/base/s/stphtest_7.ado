*! version 6.1.5  15oct2019
program define stphtest_7, rclass sort
version 6
qui {
	syntax [, KM LOG PLOT(varname) RANK TIME(string) Detail /*
		*/ T1title(string) B2title(string) /*
		*/ XLAbel(string) YLAbel(string) * ]
	st_is 2 analysis

/*
	plot, detail, <nothing> will be three alternatives
*/
	if "`plot'"!="" {
		if "`detail'"!="" {
			version 7: di in red "options {bf:plot} and {bf:detail} may not be specified together"
			exit 198
		}
	}
	else {
		if `"`options'"'!="" {
			local ops = plural(`:word count `options'', "option")
			version 7: di in red `"`ops' {bf:`options'} not allowed"'
			exit 198
		}
	}


	local nopts = ("`km'"!="") + ("`log'"!="") + /*
			*/ ("`rank'"!="") + (`"`time'"'!="")

	if `nopts'>1 { 
		version 7: noi di in red /*
		*/ "may only specify one of options {bf:km}, {bf:log}, {bf:plot}, {bf:rank}, and {bf:time()}"
		exit 198
	}


       	if "`e(cmd2)'" != "stcox" {
               	error 301
       	}

        if "`detail'" != "" | "`plot'" != "" {
		if "`e(vl_ssc)'" == ""  {
            		version 7: noi di in red  /*
*/ "{bf:stcox} did not save scaled Schoenfeld residuals" _n /*
*/ "{p 4 4 2}Option {bf:scaledsch(newvars)} must have been specified with command {bf:stcox} " /*
*/ "prior to using options {bf:detail} or {bf:plot} with this command.{p_end}"
			exit 198
		}
       	}

	local flag  0
       	if "`plot'"=="" & "`e(vl_sch)'" == ""  {
		if "`detail'"!="" {
			version 7: noi di in gr /*
*/ "note: cannot perform global test because option {bf:schoenfeld(newvars)} was" /*
			*/ _n _col(7) "not specified with command {bf:stcox}"
		local flag 1
		}
		else {
			version 7: noi di in red /*
*/ "cannot perform global test because option {bf:schoenfeld(newvars)} was" /*
			*/ _n _col(7) "not specified with command {bf:stcox}"
			exit 198
		}
	}


	tempname V
	mat `V' = get(VCE)
	
        local n : word count `e(vl_ssc)'


	tempvar rnk
	if "`log'"!="" { 
		gen double `rnk'=log(_t) if e(sample) &  _d~=0
		local title "Log(t)"
	}
	else if "`rank'"!="" { 
		egen `rnk'=rank(_t) if e(sample) &  _d~=0
		local title "Rank(t)"
	}
	else if "`time'"!="" { 
		gen double `rnk'=`time' if e(sample) &  _d~=0
		local title "`time'"
	}
	else if "`km'"!="" { 
		tempname coxest
		tempvar s mysamp ns negd first
		gen byte `mysamp'=e(sample)
		estimates hold `coxest'
		capture noisily {
			qui sts gen `s' = s if `mysamp'
			qui gen `negd'=1-_d
			sort `mysamp' _t `negd'
			drop `negd'
			qui by `mysamp' _t: /*
				*/ gen double `first'=1 if _n==1 
			sort `mysamp' `first' _t
			qui gen double `ns'=`s'[_n-1] if `mysamp' & `first'==1
			qui replace `ns'=1 if `ns'==. & `mysamp' & `first'==1
			sort `mysamp' _t `first' 
			qui by `mysamp' _t: /*
				*/ replace `ns'=`ns'[1] if `ns'==. & `mysamp'
			qui gen double `rnk'=1-`ns' if `mysamp' &  _d~=0 
			drop `mysamp' `s' `ns' `first' 
		}
		local rc = _rc
		estimates unhold `coxest'
		if `rc' { exit `rc' }
		local title "Kaplan-Meier"
	}
	else {
		gen double `rnk'=_t      if  _d~=0  & e(sample)
		local title "Time"
	}

if "`plot'"=="" {


	noi di in gr _n "      Test of proportional hazards assumption" _n
	noi di in gr  "      Time:  " in ye "`title'"
	noi di in smcl in gr "      {hline 12}{c TT}{hline 51}"
	if "`detail'" !="" {
		noi di in smcl in gr /*
		*/"                  {c |}       rho            chi2       df       Prob>chi2"
		noi di in smcl in gr "      {hline 12}{c +}{hline 51}"
	}
	else {
		noi di in smcl in gr /*
		*/"                  {c |}                      chi2       df       Prob>chi2"
	}

}

	tempvar wrk
	tempname td chi2 snum gden chi2 rho rvar

	sum `rnk' if e(sample), meanonly
	scalar `rvar'=r(mean)

	gen double `wrk' = sum(cond(e(sample), (`rnk'-`rvar')^2,0))
	scalar `gden' = `wrk'[_N]
	drop `wrk'

	count if  _d!=0 & e(sample)
	scalar `td'=r(N)
	if "`plot'"!="" | "`detail'"!="" {

        	tokenize "`e(vl_ssc)'"
 		local i 1

		if "`plot'"!="" {
			while `i' <=`n' {
				local lbl: variable label ``i''
				local lbl=substr("`lbl'",20,.)
				if "`lbl'"=="`plot'" {
					tempname coxest
					estimates hold `coxest'
					if "`log'"~="" { 
						local logopt xlog 
 						replace `rnk'=_t
						local title "Time"
					}
					capture noisily {
						if `"`t1title'"'!="" {
							local t1opt `"t1(`t1title')"'
						}
						else local t1opt  /*
						  */ "t1(Test of PH Assumption)"

						if `"`b2title'"'!="" {
							local b2opt `"b2(`b2title')"'
						}
						else local b2opt  `"b2(`title')"'

						if "`xlabel'"!="" {
							local xopt  /*
							*/ "xlabel(`xlabel')"
						}
						else local xopt  "xlabel" 

						if "`ylabel'"!="" {
							local yopt  /*
							*/ "ylabel(`ylabel')"
						}
						else local yopt  "ylabel" 

	      					ksm ``i'' `rnk', `logopt' /*
						*/ `xopt' `yopt' `t1opt' /*
						*/ `b2opt' `options'
					}
					local rc = _rc 
					estimates unhold `coxest'
					exit `rc'
				}
				local i = `i' + 1
			}
			di in red "`plot' not found in model"
			exit 198
		}
		else {
			while `i'<=`n' { 

				gen double `wrk' = sum(cond(e(sample), /*
					*/ (`rnk'-`rvar')*``i'', 0)) 
				scalar `snum' = `wrk'[_N]
				drop `wrk'

				scalar `chi2'= `snum'^2 / /*
					*/ (`td'*`V'[`i',`i']*`gden')

				corr ``i'' `rnk' if e(sample)
				scalar `rho'=r(rho)
				local lbl: variable label ``i''
				local lbl=substr("`lbl'",20,.)
				noi di in smcl in  gr "      "  /*
					*/ abbrev("`lbl'",12) /*
					*/ _col(19) "{c |}" /* 
					*/ in ye _col(25) %8.5f `rho' /*
					*/  _col(37) %9.2f `chi2'/*
					*/  _col(50) %5.0f 1 /*
					*/  _col(64) %5.4f chiprob(1,`chi2')
				local i=`i'+1
			}  end while */
		} /* end else */
	}

        noi di in smcl in gr "      {hline 12}{c +}{hline 51}"
	if `flag'==1 { exit }
        local n : word count `e(vl_sch)'
	tempname nV gv 

	mat `nV'=(1/`gden')*`td'*`V'
	mat `gv'=J(`n',1,0)

	tempvar gnum
       	tokenize "`e(vl_sch)'"
 	local i 1
   	while `i'<=`n' { 
		gen double `gnum' = sum(cond(e(sample), /*
			*/ (`rnk'-`rvar')*``i'',0))
		mat `gv'[`i',1] = `gnum'[_N]
		drop `gnum' 
		local i = `i' + 1
	}

	tempname gchi2 chi2

	mat `gchi2'=`gv''*`nV'*`gv'
	ret scalar chi2=`gchi2'[1,1]
	ret scalar df = `n'
	noi di in smcl in gr "      global test {c |}" in ye /*
	*/ _col(37) %9.2f return(chi2) /*
	*/  _col(50) %5.0f `n' /*
	*/  _col(64) %5.4f chiprob(`n', return(chi2))
        noi di in smcl in gr "      {hline 12}{c BT}{hline 51}"

        if "`e(vcetype)'"== "Robust" {
		noi di 
		noi di in gr /*
		*/ "note: robust variance-covariance matrix used."
	}
}
end
