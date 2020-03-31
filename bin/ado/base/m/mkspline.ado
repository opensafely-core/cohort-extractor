*! version 1.2.5  28jan2009
program define mkspline, rclass sortpreserve
	version 6, missing
	gettoken name 0 : 0, parse(" =")
	gettoken eqsign : 0, parse(" =") 
	if "`eqsign'" == "=" { 	/*cubic spline*/
		gettoken eqsign 0 : 0, parse(" =") 
		syntax varname [if] [in] [fweight], cubic ///
			[NKnots(numlist max=1) Knots(numlist) DIsplayknots]

		marksample touse

		if "`weight'" != "" {
			tempvar wgt
			qui gen `wgt' `exp'
		}
		if "`nknots'"!="" {
			local nk `nknots'
		} 
		else {
			local nk=5
		}
 		if "`knots'"!="" {
			local nc 0
			tokenize "`knots'"
			while "`1'" != "" {
				local nc = `nc' + 1
				local t`nc' "`1'"
				mac shift
			}
		}
		if "`nknots'"!="" & "`knots'"=="" {
	  		local nc `nk'
		}
		if "`nknots'"=="" & "`knots'"!="" {
	  		local nk `nc'
		}

  		if "`nknots'"!="" & "`knots'"!="" {
			if `nc' != `nk' {
				display as error ///
	"Count in nknots must be the same as the number of knots specified."
				error 498
			}
  		}

		sort `varlist'
	
		if "`knots'"!="" {
			if `nc' < 2 {
				display as error ///
	"Restricted cubic splines must have at least 2 knots."
				error 498
			}
			local prevt=`t1'
			local j=2
			while `j'<=`nk' {
				if `t`j'' <= `prevt' {
					disp as error ///
					"Knots must be in increasing order."
					error 498
				}
				local prevt=`t`j''
				local j=`j'+1
			}
		}
		else {
			if "`weight'"!="" {
				local f = "f"
				local fwgt = "[fw `exp']"
			}
			if `nk' == 3 {
				qui `f'centile `varlist' if `touse' `fwgt', ///
					centile(10 50 90)
			}
			else if `nk'== 4 {
				qui `f'centile `varlist' if `touse' `fwgt', ///
					centile(5 35 65 95)
			}
			else if `nk'== 5 {
				qui `f'centile `varlist' if `touse' `fwgt', ///
					centile(5 27.5 50 72.5 95)
			}
			else if `nk'== 6 {
				qui `f'centile `varlist' if `touse' `fwgt', ///
					centile(5 23 41 59 77 95)
			}
			else if `nk'== 7 {
				qui `f'centile `varlist' if `touse' `fwgt', ///
				centile(2.5 18.33 34.17 50 65.83 81.67 97.5)
			}
			else 	{
				display as error ///
   "Restricted cubic splines with `nk' knots at default values not implemented."
				display as error ///
   "Number of knots specified in nknots() must be between 3 and 7."
				error 498
			}
					
			forvalues i=1 / `nk' {
				local t`i' = r(c_`i')
			}

			qui sum `varlist' `fwgt', meanonly
			local cenmin = 5/(r(N)+1)*100
			local cenmax = (r(N)-4)/(r(N)+1)*100
			qui `f'centile `varlist' if `touse' `fwgt', ///
				centile(`cenmin' `cenmax')
			local min = r(c_1)
			local max = r(c_2)
  			
			if `t1' < `min' {
				local t1 = `min' 
			} 

  			if `t`nk'' > `max'	{ 
				local t`nk' = `max'
			} 
		}

		local j = 1
		matrix loc = J(1,`nk',0)
		local col ""
		while `j' <= `nk' {
			mat loc[1,`j'] = `t`j''
			local col "`col' knot`j'"
			local j = `j'+1
		}
		mat colnames loc = `col'
		matrix rownames loc = "`varlist'"

		local km1 = `nk' - 1
		if `t1' >= `t2' | `t`nk'' <= `t`km1''  {
			display as error ///
				"Sample size too small for this many knots."
			error 198
		}

		qui gen `name'1=`varlist' if `touse'

		local j = 1
		while `j' <= `nk' {
			qui gen _Xm`j' = `varlist' - `t`j''
			uplus _Xm`j'  _Xm`j'p
			local j = `j'+1
		}

		local j = 1
		while `j' <= `nk' -2 {
			local jp1 = `j' + 1
			qui gen `name'`jp1' = (_Xm`j'p^3 - (_Xm`km1'p^3)* ///
				(`t`nk''   - `t`j'')/(`t`nk'' - `t`km1'') ///
				+ (_Xm`nk'p^3  )*(`t`km1'' - `t`j'')/ ///
				(`t`nk'' - `t`km1'')) / (`t`nk'' - `t1')^2 ///
				if `touse'
			local j = `j' + 1
		}

		drop _Xm* _Xm*p
		
		if "`displayknots'"!="" {
			matlist loc
		}
		return scalar N_knots = `nk'
		return matrix knots loc
		exit
	}
	gettoken n 0 : 0, parse(" =") 
	gettoken eqsign : 0, parse(" =") 
	if "`eqsign'" == "=" { 			/* newstub # = ... */
		gettoken eqsign 0 : 0, parse(" =") 
		local hold
		confirm integer number `n'
		if `n'<2 { error 198 } 
		if _caller() < 10 {
			syntax varname [if] [in] ///
				[, Marginal Pctile DIsplayknots]
		}
		else {
			syntax varname [if] [in] [fw] ///
				[, Marginal Pctile DIsplayknots]
		}
		if "`weight'" != "" {
			tempvar wgt
			qui gen `wgt' `exp'
			local f = "f"
			local fwgt = "[fw `exp']"
		}
		marksample touse
		matrix loc = J(1,`n'-1,0)
		local col ""
		if "`pctile'"=="" {
			quietly summ `varlist' if `touse', meanonly
			local base = r(min)
			local incr = (r(max)-r(min))/`n'
			local i 1
			while `i'<`n' {
				local base = `base' + `incr'
				mat loc[1,`i'] = `base'
				local col "`col' knot`i'"
				local fmted : dis string(`base', "%9.0g") 
				local arg "`arg' `name'`i' `base'"
				local i=`i'+1
			}
		}
		else {
			local base = 0 
			tempvar p
			local base 0
			local incr = 100/`n'
			local i 1
			while `i'<`n' {
				local base = `base' + `incr'
				if _caller()<10 {
					capture drop `p'
					qui egen float `p'=pctile(`varlist') /*
					*/ if `touse', p(`base')
					qui summ `p', meanonly
					mat loc[1,`i'] = r(mean)

					local fmted:di string(r(mean), "%9.0g")
					local arg "`arg' `name'`i' `r(mean)'"
				}
				else {
					qui `f'centile `varlist' if `touse' ///
						`fwgt', centile(`base')
					mat loc[1,`i'] = r(c_1)
					local fmted : di string(r(c_1), "%9.0g")
                                        local arg "`arg' `name'`i' `r(c_1)'"
				}
				local col "`col' knot`i'"
				local i=`i'+1			
			}
		}
		local arg "`arg' `name'`i'"
		matrix colnames loc = `col'
		return clear
		return matrix knots loc
		return scalar N_knots = `n' - 1  
		mkspline `arg' = `varlist' if `touse', `margina' `displayknots'
		exit
	}


	/* newvar # newvar # ... newvar = ... */
	local i 0
	local last -1e+30
	while "`eqsign'" != "=" { 
		confirm new variable `name'
		confirm number `n' 
		if `n' <= `last' { error 198 } 
		local i = `i' + 1
		local v`i' "`name'"
		local n`i' `n'
		tempvar t`i'
		gettoken name 0 : 0, parse(" =")
		gettoken eqsign 0 : 0, parse(" =")
		if "`eqsign'"!="=" { 
			local n "`eqsign'"
		}
	}


		
	local n = `i' + 1
	confirm new variable `name'
	local v`n' `name'
	tempvar t`n'
	local n`n' .

	syntax varname [if] [in] [, Marginal DIsplayknots]
	marksample touse
	if `n'<2 { error 198 } 

	if ("`margina'"!="") { 
		qui gen float `t1' = `varlist' if `touse'
		qui compress `t1'
		label var `t1' `"`varlist': (.,.)"'
		local last `n1'
		local i 2 
		while `i'<=`n' {
			qui gen float `t`i''=max(0,`varlist'-`last') if `touse'
			qui compress `t`i''
			local ttl : di "`varlist': (" `last' ",.)"
			label var `t`i'' "`ttl'"
			local last `n`i''
			local i=`i'+1
		}
	}
	else {
		qui gen float `t1' = min(`varlist',`n1') if `touse'
		qui compress `t1'
		local ttl : di "`varlist': (.," `n1' ")"
		label var `t1' "`ttl'"
		local last `n1'
		local i 2
		while `i'<=`n' {
			qui gen float `t`i'' = /*
				*/ max(min(`varlist',`n`i''),`last') - `last' /*
				*/ if `touse'
			qui compress `t`i''
			local ttl : di "`varlist': (`last'," `n`i'' ")"
			label var `t`i'' "`ttl'"
			local last `n`i''
			local i=`i'+1
		}
	}

	local i 1 
	while `i'<=`n' {
		rename `t`i'' `v`i''
		local i=`i'+1
	}
	
	local nk = `n'-1
	matrix loc = J(1,`nk',0)
	local col ""
	forvalues i = 1/`nk'{
		mat loc[1,`i'] = `n`i''
		local col "`col' knot`i'"
	}
	matrix rownames loc = "`varlist'"
	mat colnames loc = `col'
	if "`displayknots'"!="" {
		matlist loc
	}
	return scalar N_knots = `nk' 
	return matrix knots loc
end

program define uplus 
	version 7
	args u uplus
	qui gen `uplus' = `u'
	quietly replace `uplus' = 0 if `u' <= 0
end 

program  fcentile, rclass sortpreserve
	version 9.0
	syntax [varlist] [if] [in] [fw] [,  Centile(numlist >=0 <=100) ]
	marksample touse
	if "`weight'" != "" {
		tempvar wgt
		qui gen `wgt' `exp'
	}
	local nc 0
	tokenize "`centile'"
	while "`1'" != "" {
		local nc = `nc' + 1
		local c`nc' `1'
		local cents "`cents' `1'"
		mac shift
	}

	tempvar x cum records flag flag2
	qui gen `x' = `varlist'
	
	preserve
	qui keep if `touse'
	sort `wgt', stable
	sort `x', stable
	qui sum `wgt'
	local n = r(sum)
	local xrecords = r(N)
	qui gen `cum' = sum(`wgt')
	
	local j 1
	while `j' <= `nc' {
		sort `x', stable
		scalar R = (`n'+1)*`c`j''/100
		scalar r_ = int(R)
		scalar frac = R-r_
		qui gen `flag' = 1 if r_ <=`cum' & (r_ > `cum'[_n-1] | _n==1)
		qui replace `flag' = 2 if `flag'[_n-1] == 1
		qui gen `flag2' =  r_ == `cum' & _n < `xrecords'
		sort `flag', stable
		scalar cq = `x'[1] + frac*`flag2'[1]*(`x'[2]-`x'[1])
		drop `flag' `flag2'
		return scalar c_`j' = cq
		local j = `j' + 1
	}
	restore	
end
