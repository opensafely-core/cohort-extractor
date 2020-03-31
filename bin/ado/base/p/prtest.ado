*! version 2.2.0  29mar2017
program define prtest, rclass byable(recall)
	version 6, missing
	global S_1			/* will be n1	*/
	global S_2			/* will be p1	*/
	global S_3			/* will be n2	*/
	global S_4			/* will be p2	*/
	global S_6			/* will be z	*/

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if "`eq'" == "==" {
		local 0 `vn' = `rest'
	}

	syntax varname [=/exp] [if] [in] [, /*
		*/ BY(varname) Level(cilevel) /*
		*/ cluster(varname) rho1(string) rho2(string) rho(string)]
	tempvar touse
	mark `touse' `if' `in'
	local is_cls 0
	if ("`cluster'"!="") { 
		markout `touse' `cluster', strok
	}	
	/* do not markout varname */
	if `"`exp'"'!="" { 
		if `"`by'"'!="" { 
			version 15:di in red 	///
			"may not combine {bf:==} and option {bf:by()}"
			exit 198
		}
		capture confirm number `exp'
		if _rc==0 {
			markout `touse' `varlist'
			if (`"`rho1'`rho2'"'!="") {
			version 15:di as err "options {bf:rho1()} and " ///
			"{bf:rho2()} not allowed with a one-sample test"
				exit 198	
			}
			if ((`"`cluster'"'!="" & `"`rho'"'=="") | ///
		(`"`cluster'"'=="" & `"`rho'"'!="")) {
		version 15:di as err "{p}both options {bf:cluster()} and " ///
	"{bf:rho()} must be specified to adjust for clustering{p_end}"
				exit 198
			}	
			if (`"`rho'"'!="") {
				cap assert (`rho'>=-1 & `rho'<=1)
				if c(rc) {
		version 15:di as err "{p}option {bf:rho()} must contain a " ///
			"real value between -1 and 1{p_end}"
						exit 198
				}
			}		
			if (`"`cluster'`rho'"'!="") {
				local is_cls 1
			}
			
			cap assert `varlist'==1 | `varlist'==0 if `touse'
			if _rc {
				di in red `"`varlist' is not a 0/1 variable"'
				exit 450
			}
			cap assert `exp'<1 & `exp'>0 if `touse'
			if _rc {
				di in red `"`exp' is not in (0,1)"'
				exit 450
			}

			tempname p1 s K M cvcl adjusts p pl pr z q
			qui summ `varlist' if `touse'
			local n1=r(N)
			scalar `p1'=r(mean)
			di 

			local xname = abbrev(`"`varlist'"',12)
			local c1 = 53 - length(`"`xname'"')
			
			di in gr `"One-sample test of proportion"' /*
			*/  in gr _col(49)  `"Number of obs      = "' /*
			*/ in ye %9.0g `n1'

			scalar `s' = sqrt(`p1'*(1-`p1')/(`n1'))
			
			if (`is_cls') {
				qui {
				preserve
				keep `cluster' `touse'
				keep if `touse'
				tempname count
				bysort `cluster': gen `count' = _N
				keep `cluster' `count'
				duplicates drop 
				scalar `K' = _N
				scalar `M' = `n1'/`K'
				sum `count'
				// want to use cvcluster but the name is too
				// long for version 6
				scalar `cvcl'=r(sd)/`M'*sqrt((`K'-1)/`K')
				restore	
				}
			scalar `adjusts' = 1+(`M'-1)*`rho'+`M'*`cvcl'^2*`rho'	
			scalar `s' = `s'*sqrt(`adjusts')
		di in gr "Cluster variable: " in ye "`cluster'" ///		
		in gr _col(49) "Number of clusters = " in ye %9.0fc `K'      

				if (`cvcl'==0) {
			di in gr _col(49) "Cluster size       = " ///
					in ye %9.0gc `M'   
				}
				else {
			di in gr _col(49) "Avg. cluster size  = " ///
				in ye %9.2fc `M'
			di in gr _col(49) "CV cluster size    = " ///
				in ye %9.4f `cvcl'
				}	
		di in gr _col(49) "Intraclass corr.   = " in ye %9.4f `rho' 
			}
			di	
				
			_ttest1 `varlist' `n1' `p1' `s' `level' 

			BotLine

			if (!`is_cls') {
				scalar `z' = (`p1'-`exp') ///
					/sqrt(`exp'*(1-`exp')/`n1')
			}
			else {
				scalar `z' = (`p1'-`exp') ///
					/sqrt(`exp'*(1-`exp')*`adjusts'/`n1')
			}

			if `exp' < 1e-6 {
				local m0 : di %8.0g `exp'
			}
			else if `exp' > (1-1e-6) {
				local m0 0.999999
			}
			else {
				local m0 : di %8.6f `exp'
				forvalues i = 0/5 {
					local zz = bsubstr(`"`m0'"',8-`i',8-`i')
					if `"`zz'"' == "0" {
						local m0 = ///
							bsubstr(`"`m0'"',1,7-`i')
					}
					else {
						continue, break
					}
				}
			}
			local m0 = trim(`"`m0'"')

			local abname=abbrev("`varlist'", 12)
			di as txt "    p = proportion(" as res `"`abname'"' ///
				as txt ")" ///
				_col(67) as txt "z = " as res %8.4f `z'
			di as txt "Ho: p = " as res `"`m0'"' 
			
                	di
			_ttest center2 "Ha: p < @`m0'@" ///
                                       "Ha: p != @`m0'@" ///
				       "Ha: p > @`m0'@" 

			scalar `p' = 2*normprob(-abs(`z'))
			if `z' < 0 {
				scalar `pl' = `p'/2
				scalar `pr' = 1 - `pl'
			}
			else {
				scalar `pr' = `p'/2
				scalar `pl' = 1 - `pr'
			}
			
			local pp1 : di %6.4f `pl'
			local pp2 : di %6.4f `p'
			local pp3 : di %6.4f `pr'

			_ttest center2 "Pr(Z < z) = @`pp1'@" ///
				       "Pr(|Z| > |z|) = @`pp2'@" ///
                                       "Pr(Z > z) = @`pp3'@" 

			scalar `q' =  invnormal((100+`level')/200)
			if (`is_cls') {
				ret scalar CV_cluster = `cvcl'
				ret hidden scalar DE	= 1+(`M'-1)*`rho'
				ret scalar rho = `rho'
				ret scalar M = `M'
				ret scalar K = `K'
			}
			
			ret scalar level = `level'
			ret scalar p_u  = `pr'
			ret scalar p    = `p'
			ret scalar p_l  = `pl'
			ret scalar z  = `z'
			ret scalar lb = `p1' - `q'*(`s')
			ret scalar ub = `p1' + `q'*(`s')
			
			ret scalar se = `s'
			ret scalar P = `p1'
			ret scalar N = `n1'
			ret hidden scalar N_1 = `n1'
			ret hidden scalar P_1 = `p1'
			/* Double saves */
			global S_1 "`return(N_1)'"
			global S_2 "`return(P_1)'"
			global S_6 "`return(z)'"
		
			exit
		}
		
		if (`"`cluster'`rho'`rho1'`rho2'"' !="") {
			version 15:di as err "{p}options {bf:cluster()}, " ///
		"{bf:rho()}, {bf:rho1()}, and {bf:rho2()} not allowed " ///
		"with the syntax comparing two variables; " ///
		"you can {manhelp reshape D} your data to long form and " ///
		"use option {bf:by()}{p_end}"
				exit 198
			}
		
		cap assert `varlist'==1 | `varlist'==0 if `touse' & `varlist'<.
		if _rc {
			di in red `"`varlist' is not a 0/1 variable"'
			exit 450
		}
		cap assert (`exp')==1 | (`exp')==0 if `touse' & (`exp')<.
		if _rc {
			di in red `"`exp' is not a 0/1 variable"'
			exit 450
		}
		
		unab exp : `exp', max(1)
		quietly sum `varlist' if `touse'
		local n1=r(N)
		local p1=r(mean)
		quietly sum `exp' if `touse'
		local n2=r(N)
		local p2=r(mean)
		* local abnam1 = abbrev("`varlist'",8)
		* local abnam2 = abbrev("`exp'",8)
		prtesti `n1' `p1' `n2' `p2', xname(`varlist') yname(`exp') /*
			*/ level(`level')

		ret add
		exit
	}
	if `"`by'"'=="" {
               version 15: di in red "option {bf:by()} required"
                exit 100
        }
	quietly tab `varlist' if `touse'
	if r(r)!=2 { 
	version 15:di in red `"{bf:`varlist'} takes on "' r(r) `" values, not 2"'
		exit 450
	}
	confirm var `by'
	quietly tab `by' if `touse'
	if r(r)!=2 { 
	version 15:di in red `"{bf:`by'} takes on "' r(r) `" values, not 2"'
		exit 450
	}
	
	if ((`"`cluster'"'!="" & `"`rho'`rho1'`rho2'"'=="") | ///
                (`"`cluster'"'=="" & `"`rho'`rho1'`rho2'"'!="")) {
        version 15: di as err "{p}specify option {bf:cluster()} and either " ///
		"option {bf:rho()} or options {bf:rho1()} and {bf:rho2()} " ///
		"to adjust for clustering{p_end}"
                exit 198
        }
        if (`"`cluster'`rho'`rho1'`rho2'"' !="") {
                if ("`rho'"!="" & "`rho1'`rho2'"!="" ) {
                version 15:di as err "{p}may not specify option " ///
                "{bf:rho()} with option {bf:rho1()} or {bf:rho2()}{p_end}"
                        exit 198
                }
                if ((`"`rho1'"'!="" & `"`rho2'"'=="") | ///
                        (`"`rho1'"'=="" & `"`rho2'"'!="" )) {
               version 15:di as err "{p}options {bf:rho1()} and {bf:rho2()} " ///
                        "must be specified together{p_end}"
			exit 198
        	}
		local is_cls 1
	}
	
	capture confirm string variable `by'
	if (_rc) {
		local is_by_n 1
	}
	else {
		local is_by_n 0
	}
		
	if (`is_by_n') {
		qui summ `by' if `touse'
		local g1 = r(min)
		local g2 = r(max)
	}
	else {
		tempvar obs val1 val2
	
		gen `c(obs_t)' `obs' = _n if `touse'
		sum `obs' if `touse', mean
	
		/* get first value */
		version 15:scalar `val1' = `by'[r(min)]
		qui replace `obs' = . if `by' == `val1'
		sum `obs', mean
		version 15:scalar `val2' = `by'[r(min)]
	
	/* Make it so that `val1' < `val2' . */
		if `val1' > `val2' {
			tempname temp
			version 15:scalar `temp' = `val1'
			version 15:scalar `val1' = `val2'
			version 15:scalar `val2' = `temp'	
		}
	}
	
	if (`is_by_n') {
		quietly sum `varlist' if `by'==`g1' & `touse'
	}
	else {
		quietly sum `varlist' if `by'==`val1' & `touse'
	}
	local n1 = r(N)
	local p1 = r(mean)
	if (`is_by_n') {
		quietly sum `varlist' if `by'==`g2' & `touse'
	}
	else {
		quietly sum `varlist' if `by'==`val2' & `touse'
	}
	local n2 = r(N)
	local p2 = r(mean)

	if (`is_cls') { 
		qui {
		preserve
		keep `cluster' `touse' `by'
		if (`is_by_n') {
			keep if `touse' & `by'==`g1'
		}
		else {
			keep if `touse' & `by'==`val1'
		}	
		tempname count
		bysort `cluster': gen `count' = _N
		keep `cluster' `count'
		duplicates drop 
		local K1 = _N
		local M1 = `n1'/`K1'
		sum `count'
		local cvcl1 = r(sd)/`M1'*sqrt((`K1'-1)/`K1')
		restore
		preserve
		keep `cluster' `touse' `by'
		if (`is_by_n') {
			keep if `touse' & `by'==`g2'
		}
		else {
			keep if `touse' & `by'==`val2'
		}
		tempname count
		bysort `cluster': gen `count' = _N
		keep `cluster' `count'
		duplicates drop 
		local K2 = _N
		local M2 = `n2'/`K2'
		sum `count'
		local cvcl2 = r(sd)/`M2'*sqrt((`K2'-1)/`K2')
		restore
		}
	}
	
	if (`is_by_n') {
		local vlab : value label `by'
		local xname = `g1'
		local yname = `g2'
		if `"`vlab'"' != `""' {
			local xname : label `vlab' `g1'
			if `"`xname'"' == `""' {
				local xname = `g1'
			}
			local yname : label `vlab' `g2'
			if `"`yname'"' == `""' {
				local yname = `g2'
			}
		}
	}
	else {
		/* Shorten groups labels if necessary. */
		local xname : display udsubstr(`val1',1,8)
		local yname : display udsubstr(`val2',1,8)
		/* Take substr() again because binary 0 might have expanded to \0 */
		local xname = udsubstr(`"`xname'"',1,8)
		local yname = udsubstr(`"`yname'"',1,8)
	}
	if (!`is_cls') {
		prtesti `n1' `p1' `n2' `p2', /*
			*/ xname(`xname') yname(`yname') level(`level') 
	}
	else {
		if ("`rho'"!="") {
			local rho1 = `rho'
			local rho2 = `rho'
		}	
		prtesti `n1' `p1' `n2' `p2', /*
			*/ xname(`xname') yname(`yname') level(`level') /*
	*/ rho1(`rho1') rho2(`rho2') mm1(`M1') k1(`K1') mm2(`M2') k2(`K2') /*
	*/ cvcl1(`cvcl1') cvcl2(`cvcl2') idname("`cluster'")
	}

	ret add
end

program define BotLine
	di in smcl in gr "{hline 13}{c BT}{hline 64}"
end

program define _ttest1
	local name = abbrev(`"`1'"', 12)
	local n "`2'"
	local mean "`3'"
	local se "`4'"
	local level "`5'"
	local show = "`6'" 

	if `n' == 1 | `n' >= . {
		local se = .
	}
	local beg = 13 - length(`"`name'"')
	if "`show'" != "" {
		local z z
		local zp P>|z| 
	}
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	*noi di 
	noi di in smcl in gr "{hline 13}{c TT}{hline 64}"
	noi di in smcl in gr "    Variable {c |}" /*
	*/ _col(22) "Mean" _col(29) /*
	*/ "Std. Err." _col(44) "`z'" _col(49) /*
	*/ "`zp'" _col(`=61-`cil'') `"[`=strsubdp("`level'")'% Conf. Interval]"'
	noi di in smcl in gr "{hline 13}{c +}{hline 64}"
	
	local vval = (100-(100-`level')/2)/100
	noi di in smcl in gr _col(`beg') `"`name'"' /*
	*/ in gr _col(14) "{c |}" in ye /*
	*/ _col(17) %9.0g  `mean'   /*
	*/ _col(28) %9.0g  `se'     /*
	*/ _col(58) %9.0g  `mean'-invnorm(`vval')*`se'   /*
	*/ _col(70) %9.0g  `mean'+invnorm(`vval')*`se'
end
exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
------------------------------------------------------------------------------
Variable     |       Mean   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   _cons     |  26165.257  1342.8719                     xxxxxxxxx   xxxxxxxxx 

