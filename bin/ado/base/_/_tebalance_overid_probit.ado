*! version 1.0.0  24sep2014

program define _tebalance_overid_probit
	version 14
	args todo b q

	local model $TEFFECTS_tmodel
	local hprob = ("`model'"=="hetprobit")
	local att = ("$TEFFECTS_stat"=="atet")
	local tlevels $TEFFECTS_tlevels
	local klev : list sizeof tlevels
	local control = $TEFFECTS_control
	local treated = $TEFFECTS_treated
	local tvars $TEFFECTS_tvars
	/* overid variables						*/
	local bvlist $TEFFECTS_bvlist
	local bhvlist $TEFFECTS_bhvlist
	local bhvar = ("`bhvlist'"!="")
	/* model variables & higher order terms				*/
	local fvlist $TEFFECTS_fvlist
	local fhvlist $TEFFECTS_fhvlist
	local wts = ("$TEFFECTS_wtype"=="fweight")

	if (`klev'!=2) error 498 

	tempvar xb p f tr cdf phi r r0
	tempname u U W W0 W1

	local if if $ML_samp
	if `wts' {
		local wgts [fw=$ML_w]
	}

	qui mleval `xb' = `b', eq(1)
	if (`hprob') {
		tempvar z s

		qui mleval `s' = `b', eq(2)
		qui replace `s' = exp(`s') `if'
		qui replace `s' = max(`s',c(epsdouble)) `if'
		qui gen double `z' = `xb'/`s' `if'
	}
	else {
		local z `xb'
		local s = 1
	}
	if (`att') {
		local jt : list posof "`treated'" in tlevels
		local jc = mod(`jt',2)+1
		local control : word `jc' of `tlevels'
	}
	else {
		local jc : list posof "`control'" in tlevels
		local jt = mod(`jc',2)+1
		local treated : word `jt' of `tlevels'
	}
	qui gen double `cdf' = normal(`z') `if'

	local tr : word `jt' of `tvars'
	qui gen double `p' = cond(`tr',`cdf',1-`cdf') `if' 
	qui replace `p' = max(`p',c(epsdouble)) `if'

	qui gen double `phi' = normalden(`z') `if'
	qui gen double  `f' = cond(`tr',`phi',-`phi') `if'

	qui gen double `r0' = `f'/`p' `if'
	if (`hprob') {
		qui replace `r0' = `r0'/`s' `if'
		qui gen double `r' = -`r0'*`xb' `if'
	}
	scalar `q' = 1
	mlvecsum `q' `U' = `r0' `if', eq(1)
	if (`hprob') {
		mlvecsum `q' `u' = `r' `if', eq(2)
		mat `U' = (`U',`u')
		qui drop `r'
	}

	/* covariate moments						*/
	if (`att') {
		tempname Nt
		if `wts' {
			summarize $ML_w `wgts' `if' & `tr', meanonly
			scalar `Nt' = r(sum)
			summarize $ML_w `wgts' `if', meanonly
			scalar `Nt' = r(sum)/scalar(`Nt')
		}
		else {
			qui count `if' & `tr'
			scalar `Nt' = r(N)
			qui count `if' 
			scalar `Nt' = r(N)/scalar(`Nt')
		}
		/* `r' = (`N'/`N1')*(`tr'-`cdf')/(1-`cdf') `if'		*/
		qui gen double `r' = cond(`tr',scalar(`Nt'), ///
				-scalar(`Nt')*`cdf'/`p') `if'
	}
	else {
		/* `r' = (`tr'-`cdf')/`cdf'/(1-`cdf') `if'		*/
		qui gen double `r' = cond(`tr',1/`p',-1/`p') `if'
	}
	if `wts' {
		qui replace `r' = `r'*$ML_w
	}
	// qui mlvecsum `q' `u' = `r' `if', eq(1)
	mata: st_matrix("`u'",cross(st_data(.,"`r'","$ML_samp"), ///
		st_data(.,tokens("`bvlist'"),"$ML_samp")))
	mat `U' = (`U',`u')
	if (`hprob' & `bhvar') {
		// qui mlvecsum `q' `u' = `r' `if', eq(2)
		mata: st_matrix("`u'",cross(st_data(.,"`r'","$ML_samp"), ///
			st_data(.,tokens("`bhvlist'"),"$ML_samp")))
		mat `U' = (`U',`u')
	}
	/* GMM weight matrix						*/
	tempvar rw rw1 rw2 rw3
	tempname s1 w1 sw1 W
	if (`hprob') {
		tempname s2 s12 w2 w12 sw2 sw12 sw21
		qui replace `phi' = `phi'/`s' `if'
	}

	if (`att') {
		qui gen double `rw1' = `cdf'/(1-`cdf')+1 `if'
		qui gen double `rw3' = `Nt'*`phi'*`rw1' `if'
		qui replace `rw1' = `Nt'^2*`cdf'*`rw1' `if'
		qui gen double `rw2' = `phi'/`cdf'/(1-`cdf') `if'
	}
	else {
		qui gen double `rw1' = 1/`cdf'/(1-`cdf') `if'
		qui gen double `rw2' = `phi'*`rw1' `if'
		qui gen double `rw3' = `rw2'
	}
	qui gen double `rw' = `phi'*`rw2' `if'

	mlmatsum `q' `s1' = `rw' `if', eq(1)

	if `wts' {
		tempvar rwt
		qui replace `rw1' = `rw1'*$ML_w `if'
	}
	// mlmatsum `q' `w1' = `rw1' `if', eq(1)
	mata: st_matrix("`w1'",cross(			  ///
		st_data(.,tokens("`bvlist'"),"$ML_samp"), ///
		st_data(.,"`rw1'","$ML_samp"),            ///
		st_data(.,tokens("`bvlist'"),"$ML_samp")))

	if `wts' {
		qui replace `rw3' = `rw3'*$ML_w
	}
	// mlmatsum `q' `sw1' = `rw3' `if', eq(1)
	mata: st_matrix("`sw1'",cross(			  ///
		st_data(.,tokens("`fvlist'"),"$ML_samp"), ///
		st_data(.,"`rw3'","$ML_samp"),            ///
		st_data(.,tokens("`bvlist'"),"$ML_samp")))

	if (`hprob') {
		qui replace `rw' = `rw'*`xb'^2 `if'
		mlmatsum `q' `s2' = `rw' `if', eq(2)

		if `bhvar' {
			// mlmatsum `q' `w2' = `rw1' `if', eq(2)
			mata: st_matrix("`w2'",cross(			   ///
				st_data(.,tokens("`bhvlist'"),"$ML_samp"), ///
				st_data(.,"`rw1'","$ML_samp"),             ///
				st_data(.,tokens("`bhvlist'"),"$ML_samp")))

			// mlmatsum `q' `w12' = `rw1' `if', eq(1,2)
			mata: st_matrix("`w12'",cross(			  ///
				st_data(.,tokens("`bvlist'"),"$ML_samp"), ///
				st_data(.,"`rw1'","$ML_samp"),            ///
				st_data(.,tokens("`bhvlist'"),"$ML_samp")))

			// mlmatsum `q' `sw12' = `rw3' `if', eq(1,2)
			mata: st_matrix("`sw12'",cross(			  ///
				st_data(.,tokens("`fvlist'"),"$ML_samp"), ///
				st_data(.,"`rw3'","$ML_samp"),            ///
				st_data(.,tokens("`bhvlist'"),"$ML_samp")))
		}

		qui replace `rw3' = -`rw3'*`xb' `if'
		qui replace `rw2' = -`rw2'*`phi'*`xb' `if'
		//mlmatsum `q' `sw21' = `rw3' `if', eq(2,1)
		mata: st_matrix("`sw21'",cross(			  ///
			st_data(.,tokens("`fhvlist'"),"$ML_samp"), ///
			st_data(.,"`rw3'","$ML_samp"),            ///
			st_data(.,tokens("`bvlist'"),"$ML_samp")))

		mlmatsum `q' `s12' = `rw2' `if', eq(1,2)
		if `bhvar' {
			// mlmatsum `q' `sw2' = `rw3' `if', eq(2)
			mata: st_matrix("`sw2'",cross(			  ///
				st_data(.,tokens("`fhvlist'"),"$ML_samp"), ///
				st_data(.,"`rw3'","$ML_samp"),            ///
				st_data(.,tokens("`bhvlist'"),"$ML_samp")))
if (0) {
mat li `s1', title(s1)
mat li `s12',title(s12)
mat li `s2', title(s2)

mat li `w1', title(w1)
mat li `w12', title(w12)
mat li `w2', title(w2)

mat li `sw1', title(sw1)
mat li `sw12', title(sw12)
mat li `sw21', title(sw21)
mat li `sw2', title(sw2)
}
			mat `W' = (`s1',  `s12', `sw1', `sw12' \ ///
		        	   `s12'', `s2', `sw21', `sw2' \ ///
			           `sw1'',`sw21'',`w1',  `w12' \ ///
				   `sw12'',`sw2'',`w12'',`w2')

			mat `W0' = (`s1',`s12' \ `s12'',`s2')
			mat `W1' = (`w1',`w12' \ `w12'',`w2')
		}
		else {
			mat `W' = (`s1',  `s12', `sw1'  \ ///
		        	   `s12'', `s2', `sw21' \ ///
			           `sw1'',`sw21'',`w1')

			mat `W0' = (`s1',`s12' \ `s12'',`s2')
			mat `W1' = `w1'
		}
	}
	else {
		mat `W' = (`s1', `sw1' \ `sw1'', `w1')
		mat `W0' = `s1'
		mat `W1' = `w1'
	}
	mat $TEFFECTS_W = `W'
	/* rank(W)-rank(W0) is the degrees of freedom of J statistic	*/
	mat $TEFFECTS_W0 = `W0'
	mat $TEFFECTS_W1 = `W1'
	cap mat `W' = invsym(`W')
	if c(rc) {
		scalar `q' = .
	}
	else {
		mat `u' = `U'*`W'*`U''
		/* add 1 to denominator to prevent division by zero	*/
		scalar `q' = 1/(1+`u'[1,1])
	}
end

exit
