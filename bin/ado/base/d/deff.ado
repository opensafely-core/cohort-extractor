*! version 3.0.2  19sep1998
program define deff
	version 3.0
	mac def S_1	/* intra-indepvar correlation	*/
	mac def S_2	/* DEFF	*/
	mac def S_3	/* ACS 	*/
	local varlist "req ex max(2) min(1)"
	local in "opt"
	local if "opt"
	local weight "aweight"
	local options "Group(string)"
	parse "`*'"
	if "`group'"=="" { error 198 }
	conf var `group'
	unab group : `group'
	local weight "[`weight'`exp']"
	parse "`varlist'", parse(" ")

	di _n in smcl in gr /*
	*/ "                            Intracluster    'Average'" _n /*
	*/ "Cluster       Variable      Correlation    Cluster Sz.      DEFF" _n /* 
	*/ "{hline 64}"

	if "`2'"=="" {
		loneway `1' `group' `weight' `if' `in', quiet
		di in gr abbrev("`group'", 12)  _col(15) abbrev("`1'",12) in ye _col(29) %8.3f $S_1 /*
			*/ _col(43) %9.2f $S_3 _col(56) %9.2f $S_2
	}
	else { 
		loneway `1' `group' `weight' `if' `in', quiet
		di in gr abbrev("`group'", 12) _col(15) abbrev("`1'", 12) in ye _col(29) %8.3f $S_1 /*
			*/ _col(43) %9.2f $S_3 _col(56) %9.2f $S_2
		local cdeff "$S_2"
		loneway `2' `group' `weight' `if' `in', quiet
		di in gr abbrev("`group'",12)  _col(15) abbrev("`2'", 12) in ye _col(29) %8.3f $S_1 /*
			*/ _col(43) %9.2f $S_3 _col(56)  %9.2f $S_2
		local cdeff = 1 + (`cdeff'-1) * $S_1
		di in gr abbrev("`group'", 12) _col(15) "(regression)" in ye /* 
			*/ _col(43) %9.2f $S_3 /*
			*/ _col(56)  %9.2f `cdeff'
	}
end


program define loneway, rclass
* touched by kth -- double save in r() and S_#
	version 6.0
	global S_1	/* intra-indepvar correlation */
	global S_2	/* DEFF	*/
	global S_3	/* ACS */

	syntax varlist(min=2 max=2) [in] [if] [awei] [, Quiet]
	parse `"`varlist'"', parse(" ")
	tempvar fac nn nn1
	tempname SSW DFT DFA SST SSA DFW F
	tempname D2OVNU VARF SDF NN RATIO SDRATIO RHO SDRHO RELIA
	tempname estsd DEFLAT
	preserve
	quietly {
		if `"`if'`in'"'~="" {
			keep `if' `in'
		}
		drop if `1'==. | `2'==.
		if `"`exp'"'~="" {
			tempvar wt
			gen double `wt' `exp'
			drop if `wt' <= 0 | `wt'==.
			summ `wt'
			replace `wt' = `wt' / r(mean)
			keep `1' `2' `wt'
		}
		else {
			keep `1' `2'
			local wt 1
		}
		sort `2'
		by `2': gen double `fac' = sum(`1'*`wt')/sum(`wt')
		by `2': replace `fac' = (`1' - `fac'[_N])^2
		replace `fac' = sum(`fac'*`wt')
		scalar `SSW' = `fac'[_N]
		count if `2' != `2'[_n-1]
		scalar `DFA' = r(N) - 1
		summ `1' [aw=`wt']
		scalar `DFT' = r(N) - 1
		scalar `SST' = r(Var) * `DFT'
		scalar `SSA' = `SST' - `SSW'
		scalar `DFW' = `DFT' - `DFA'
		scalar `F'   = `SSA' / `DFA' * `DFW' / `SSW'


		* D2 is the noncentrality for the numerator; Scheffe p. 413
		/* mac def estsdw = sqrt(`SSW'/`DFW') */
		scalar `D2OVNU' = max(`F'-1,0)
		scalar `VARF' = (2+4*`D2OVNU')/`DFA' + `F'^2*2/`DFW'
		scalar `SDF' = sqrt(`VARF')
		by `2': gen double `nn' = _N
		by `2': drop if _n!=_N
		gen double `nn1' = (`nn'*(`nn' -1))
		replace `nn' = sum(1/`nn')
		replace `nn1' = sum(`nn1')
		scalar `NN' = `nn'[_N]
		scalar `RATIO' = (`F' - 1) * (`DFA'+1) / (`DFT'+1)
		scalar `SDRATIO' = (`DFA'/`DFT') * `SDF'
		scalar `RHO' = `RATIO'/(1+`RATIO')
		scalar `SDRHO' = `SDRATIO' / (1+`RATIO')^2
		scalar `RELIA' = 1 / (1 + (1-`RHO')/`RHO'*(`NN'/(`DFA'+1)))
		scalar `estsd' = sqrt(`SST'/`DFT' - `SSW'/`DFW')
		scalar `DEFLAT' = sqrt((`nn1'[_N]*`RHO')/(`DFT'+1) + 1)
		/* double save in S_# and r() */
		ret scalar rho = `RHO'
		ret scalar deff = (`nn1'[_N]*`RHO')/(`DFT'+1) + 1
		ret scalar B = `nn1'[_N]/(`DFT'+1) + 1
		global S_1 `"`return(rho)'"'
		global S_2 `"`return(deff)'"'
		global S_3 `"`return(B)'"'
	}
end
