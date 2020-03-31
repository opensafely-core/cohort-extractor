*! version 2.4.4  PR  17sep2004
program define fracplot_7
	version 6, missing
	if "`e(fp_cmd)'"!="fracpoly" {	/* generic fracpoly class supported */
		error 301
	}
	local cmd "`e(cmd)'"
	local dist = e(fp_dist)
	if "`cmd'"=="mlogit" | "`cmd'"=="clogit" | "`cmd'"=="probit" {
		di in red "fracplot not supported for `cmd'"
		exit 198
	}
	local y "`e(fp_depv)'"

	syntax [varlist(default=none)] [if] [in] [, noPTs noWTs noCI /*
		*/ Symbol(string) Connect(string) T1title(string) /*
		*/ * ]

	if "`varlist'"=="" {
		local num 1 
		local rhs `e(fp_x1)'
		local x `rhs'
	}
	else {
		local n : word count `varlist'
		if `n'>2 { error 103 }
		tokenize `varlist'
		local rhs `1'
		local x `2'			/* X-axis variable for plot */
		if "`x'"=="" { local x `rhs' }
		local i 0
		while `i'<e(fp_nx) {
			local i=`i'+1
			if "`rhs'"=="`e(fp_x`i')'" & "`e(fp_k`i')'"!="." {
				local num `i'
				local i =  e(fp_nx)
			}
		}
		if "`num'"=="" {
			di in red "`rhs' not in model"
			exit 198	
		}
	}
	local powers `e(fp_k`num')'
	quietly {
		if "`pts'"=="" {	/* points to be plotted */
			tempvar dr
			fracpred `dr', dresid
		}
		if e(fp_nx)>1 {
			local adj ", adjusted for covariates"
		}
		if `"`t1title'"'=="" {
			frac_mdp 4 `powers'
			local t1title `"`e(fp_t1t)' ($S_1)`adj'"'
		}
		tempvar etahat
		fracpred `etahat', for(`rhs')
		lab var `etahat' "Fitted component"
		if "`ci'"!="noci" {
			tempvar se low high
			fracpred `se', for(`rhs') stdp
			tempname z
			scalar `z'=-invnorm(0.5-$S_level/200)
			gen `low'=`etahat'-`z'*`se'
			gen `high'=`etahat'+`z'*`se'
		}
		if "`pts'"=="" {
			tempvar yv
			gen `yv'=`etahat'+`dr'
			lab var `yv' "Component+residual for `y'"
			if "`ci'"!="noci" {
				if "`symbol'"=="" { local symbol "oiii" }
				if "`connect'"=="" { local connect ".sss" }
			}
			else {
				if "`symbol'"=="" { local symbol "oi" }
				if "`connect'"=="" { local connect ".s" }
			}
		}
		else {
			if "`ci'"!="noci" {
				if "`symbol'"=="" { local symbol "iii" }
				if "`connect'"=="" { local connect "sss" }
			}
			else {
				if "`symbol'"=="" { local symbol "i" }
				if "`connect'"=="" { local connect "s" }
			}
		}
	}
	/*
		Component (-plus partial-residual) plot
	*/
	gr7 `yv' `etahat' `low' `high' `x' `if' `in', /*
 	*/ t1title("`t1title'") s(`symbol') c(`connect') `options'
end


program define frac_mdp
	* 1=decimal places, rest=numbers sep by spaces
	* Output in $S_1.
	args dp
	mac shift
	while "`1'"!="" {
		cap confirm num `1'
		if _rc { local ddp `ddp' `1' }
		else {
			if int(2*`1')==(2*`1') { 
				local ddp `ddp' `1' 	/* respect .5 */
			} 
			else {
				frac_ddp `1' `dp'
				local ddp `ddp' `r(ddp)'
			}
		}
		mac shift
	}
	global S_1 `ddp'
end
