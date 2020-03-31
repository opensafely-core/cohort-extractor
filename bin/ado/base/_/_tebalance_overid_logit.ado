*! version 1.0.0  12sep2014

program define _tebalance_overid_logit
	version 14
	args todo b f

	local model $TEFFECTS_tmodel
	local att = ("$TEFFECTS_stat"=="atet")
	local tlevels $TEFFECTS_tlevels
	local klev : list sizeof tlevels
	local control = $TEFFECTS_control
	local treated = $TEFFECTS_treated
	local tvars $TEFFECTS_tvars
	local kvar = $TEFFECTS_kvar
	/* overid variables						*/
	local bvlist $TEFFECTS_bvlist
	/* model variables & higher onder terms				*/
	local fvlist $TEFFECTS_fvlist
	local wts = ("$TEFFECTS_wtype"=="fweight")

	local if if $ML_samp
	local eq = 0
	tempvar den p r 
	tempname W W0 W1 S N s
	qui gen double `den' = 1 `if'
	forvalues j=1/`klev' {
		tempvar p`j'
		local lev : word `j' of `tlevels'
		if `lev' == `control' {
			local jc = `j'
			continue
		}
		qui mleval `p`j'' = `b', eq(`++eq')
		qui replace `p`j'' = exp(`p`j'') `if' 
		qui replace `den' = `den' + `p`j'' `if'
	}
	qui gen double `p`jc'' = 1/`den' `if'
	/* ATE & ATT `tj' is the constant term, a full vector of ones	*/
	local tc : word `jc' of `tvars'
	qui gen double `p' = `p`jc'' `if' & `tc'

	qui gen double `r' = .
	local km = 2*(`klev'-1)
	local kv = `km'*`kvar'
	
	local k = 0
	scalar `f' = 0
	local eq = 0
	forvalues j=1/`klev' {
		local pvars `pvars' `p`j''
		if `j' == `jc' {
			continue
		}
		local tj : word `j' of `tvars'
		qui replace `p`j'' = `p`j''/`den' `if'
		qui replace `p' = `p`j'' `if' & `tj'
		qui mlvecsum `f' `s' = `tj' - `p`j'' `if', eq(`++eq')
		mat `S' = (nullmat(`S'),`s')
	}
	if `wts' {
		summarize $ML_w `if', meanonly
		scalar `N' = r(sum)
	}
	else {
		qui count `if'
		scalar `N' = r(N)
	}
	/* covariate moments						*/
	if (`att') {
		local jt : list posof "`treated'" in tlevels
		local tr : word `jt' of `tvars'
		tempname Nt
		if `wts' {
			summarize $ML_w `if' & `tr', meanonly
			scalar `Nt' = scalar(`N')/r(sum)
		}
		else {
			qui count `if' & `tr'
			scalar `Nt' = scalar(`N')/r(N)
		}
	}
	local eq = 0
	forvalues j=1/`klev' {
		if `j' == `jc' {
			continue
		}
		local tj : word `j' of `tvars'
		if (`att') {
			if `j' == `jt' {
				qui replace `r' = cond(`tc', 		///
					-scalar(`Nt')*`p`jt''/`p`jc'',  ///
					cond(`tr',scalar(`Nt'),0)) `if'
			}
			else {
				qui replace `r' = cond(`tc', 		///
					-scalar(`Nt')*`p`jt''/`p`jc'',  ///
					cond(`tj',scalar(`Nt')*`p`jt''/ ///
					`p`j'',0)) `if'
			}
		}
		else {
			qui replace `r' = cond(`tc',-1/`p', ///
				cond(`tj',1/`p',0)) `if' 
		}
		/* overid moments					*/
		if `wts' {
			mata: st_matrix("`s'",cross( 		///
				st_data(.,"`r'","$ML_samp"),	///
				st_data(.,"$ML_w","$ML_samp"),	///
				st_data(.,tokens("`bvlist'"),"$ML_samp")))
		}
		else {
			mata: st_matrix("`s'",cross( 		///
				st_data(.,"`r'","$ML_samp"),	///
				st_data(.,tokens("`bvlist'"),"$ML_samp")))
		}
		mat colnames `s' = `bvlist'
		mat `S' = (`S',`s')
	}
	/* only 2 levels, simple form					*/
	tempname w11 w12 w22 W1
	tempvar pp pn one

	qui gen double `pp' = `p'*(1-`p')

	mlmatsum `f' `w11' = `pp' `if', eq(1)
	if (`att') {
		qui replace `pp' = scalar(`Nt')*`p`jt'' `if'
		if `wts' {
			qui replace `pp' = `pp'*`wt' `if'
		}
		// mlmatsum `f' `w12' = `pp' `if', eq(1)
		mata: st_matrix("`w12'",cross( ///
			st_data(.,tokens("`fvlist'"),"$ML_samp"), ///
			st_data(.,"`pp'","$ML_samp"),		  ///
			st_data(.,tokens("`bvlist'"),"$ML_samp")))
		mat colnames `w12' = `bvlist'
		mat rownames `w12' = `fvlist'

		qui replace `pp' = `Nt'*`Nt'*`p`jt''/`p`jc'' `if'
	}
	else  {
		if `wts' {
			mata: st_matrix("`w12'",cross( ///
				st_data(.,tokens("`fvlist'"),"$ML_samp"), ///
				st_data(.,"$ML_w","$ML_samp"),		  ///
				st_data(.,tokens("`bvlist'"),"$ML_samp")))
			mat colnames `w12' = `bvlist'
			mat rownames `w12' = `fvlist'
		}
		else {
			mata: st_matrix("`w12'",cross( ///
				st_data(.,tokens("`fvlist'"),"$ML_samp"), ///
				st_data(.,tokens("`bvlist'"),"$ML_samp")))
			mat colnames `w12' = `bvlist'
			mat rownames `w12' = `fvlist'
		}
		qui replace `pp' = cond(`pp'<c(epsdouble),c(epsdouble),`pp') ///
				`if'
		qui replace `pp' = 1/`pp' `if'
	}
	if `wts' {
		qui replace `pp' = `pp'*`wt' `if'
	}
	// mlmatsum `f' `w22' = `pp' `if', eq(1)
	mata: st_matrix("`w22'",cross( ///
		st_data(.,tokens("`bvlist'"),"$ML_samp"), ///
		st_data(.,"`pp'","$ML_samp"),		  ///
		st_data(.,tokens("`bvlist'"),"$ML_samp")))
	mat colnames `w22' = `bvlist'
	mat rownames `w22' = `bvlist'

	mat `W' = (`w11',`w12' \ `w12'', `w22')
	mat $TEFFECTS_W = `W'
	mat $TEFFECTS_W0 = `w11'
	mat $TEFFECTS_W1 = `w22'
	/* rank(W)-rank(W0) is the degrees of freedom of J statistic	*/
	cap mat `W' = invsym(`W')
	if c(rc) {
		scalar `f' = .
	}
	else {
		mat `s' = `S'*`W'*`S''
		/* add 1 to denominator to prevent division by zero	*/
		scalar `f' = 1/(`s'[1,1]+1)
	}
end

exit
