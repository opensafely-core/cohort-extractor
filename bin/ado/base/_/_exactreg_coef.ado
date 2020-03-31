*! version 1.1.1  16jun2008
* _exactreg_coef - exact logistic/poisson regression programmers tool

program _exactreg_coef, rclass
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else	local mm d2
	version 10
	syntax varlist, f(varname) yx(name) b0(name) eps(name) [ ///
		MUE(string) level(cilevel) constant(string) poisson trace  ///
		midp se0(name) debug ]

	preserve
	local nv : word count `varlist'
	tempname b v ci p yx1 b1 ci1 imue sf p1 p2  
	tempvar iv iv1

	if "`trace'" == "" {
		local outopt nooutput
		local cap cap
	}
	local q = (1-`level'/100)/2
	mat `b' = J(1,`nv',.)
	mat colnames `b' = `varlist'
	mat `v' = J(1,`nv',.)
	mat colnames `v' = `varlist'
	mat `ci' = J(2,`nv',.)
	mat colnames `ci' = `varlist'
	mat `imue' = J(1,`nv',0)
	mat colnames `imue' = `varlist'
	mat `p' = J(1,`nv',.)
	mat colnames `p' = `varlist'
	if ("`mue'"=="_all") local mue `varlist'

	local i = 0
	tempvar keep
	foreach x of varlist `varlist' {
		if (`++i' > 1) restore, preserve

		local k = colnumb(`yx',"`x'")
		mat `yx1' = `yx'[1,`k']
		mat colnames `yx1' = `x'
		local C
		foreach xi of varlist `varlist' {
			if ("`x'" != "`xi'") {
				local ki = colnumb(`yx',"`xi'")
				if "`C'" == "" {
					qui gen byte `keep' = (abs(`xi'-   ///
					 `yx'[1,`ki'])<=abs(`yx'[1,`ki'])* ///
					 `eps')
				}
				else {
					qui replace `keep' = `keep'* ///
					 (abs(`xi'-`yx'[1,`ki'])<=   ///
					 abs(`yx'[1,`ki'])*`eps')
				}
				local C `C' `xi'
			}
		}
		if "`C'" != "" {
			qui keep if `keep'
			cap drop `keep'
		}
		/* constant variable is a temporary variable */
		if ("`x'"=="`constant'") local dispx _cons
		else local dispx `x'

		qui gen byte `iv' = (abs(`x'-`yx1'[1,1])<=abs(`yx1'[1,1])*`eps')
		gsort + `x' - `iv'
		/* shift data for exp(x) in likelihood and QUE */
		summarize `x', meanonly
		if r(min) > 0 {
			tempvar x1
			qui gen double `x1' = `x' - r(min)
			mat `yx1'[1,1] = `yx1'[1,1] - r(min)
		}
		else if r(max) < 0 {
			tempvar x1
			qui gen double `x1' = `x' - r(max)
			mat `yx1'[1,1] = `yx1'[1,1] - r(max)
		}
		else local x1 `x'

		local k = colnumb(`b0',"`x'")
		local initopt
		local mueinit
		local se1
		if `k' < . {
			mat `b1' = `b0'[1,`k']
			if abs(`b1'[1,1])>0 & `b1'[1,1]<. {
				mat colnames `b1' = `x1'
				local initopt init(`b1') search(off)
				local mueinit b0(`b1') 
				if "`se0'" != "" {
					tempname se1
					scalar `se1' = `se0'[1,`k']
					if (`se1'>abs(`b1'[1,1])) local se1
				}
			}
		}
		local bmue = 0
		if "`mue'" != "" {
			local bmue : list posof "`x'" in mue
			local midpopt `midp'
		}
		if (_N == 1) {
			di in gr "note: distribution for (" ///
			 abbrev("`dispx'",12) " | "         ///
			 abbrev("`C'",12) ") is degenerate" 
			mat `p'[1,`i'] = .
			mat `ci'[1,`i'] = .
			mat `ci'[2,`i'] = .
			mat `imue'[1,`i'] = 0
			/* b cannot be missing, post will not 	*/
			/*  allow it				*/
			mat `b'[1,`i'] = 0
			continue
		}
		qui count if `iv'
		if r(N) > 1 {
			scalar `yx1' = `yx'[1,`k']
			di as err "{p}relative precision of " `eps' " is "  ///
			 "too large for the sufficient statistic " `yx1'    ///
			 "; make sure you are not using single precision "  ///
			 "floating point variables or change the scale of " ///
			 "your data{p_end}"
			exit 498
		}
		if r(N) == 0 {
			scalar `yx1' = `yx'[1,`k']
			di as err "{p}failed to match the sufficient " ///
			 "statistic " `yx1' "{p_end}"
			exit 498
		}
		if `iv'[1]==1 | `iv'[_N]==1 {
			if (`iv'[1]==1) local sgn -
			else local sgn +

			if !`bmue' {
				di in gr "{p}note: CMLE estimate for " ///
				 abbrev("`dispx'",12) " is `sgn'inf; " ///
				 "computing MUE{p_end}"

				if "`midp'" != "" {
					di "{p 6}mid-p-value not " ///
					 "available{p_end}"
				}
			}
			else if "`midp'" != "" {
				di in gr "{p}note: MUE mid-p-value not " ///
				 "available for " abbrev("`dispx'",12)   ///
				 "{p_end}"
			}
			local bmue = 1
			local mueinit
			local midpopt
			local se1
		}
		if !`bmue' {
			global EXREG_iv `iv'
			global EXREG_t `yx1'
			if "`trace'" != "" {
				di in gr _n "computing CMLE for " ///
				 abbrev("`dispx'",12)
				local cap cap noi
			}
			else local cap cap

			if "`debug'" != "" {
				`vv' ///
				cap noi ml model `mm'debug _exactreg_lf   ///
					(`f'=`x1', nocons), max `outopt' ///
					`initopt' iter(100) collinear    ///
					gradient hessian showstep trace  ///
					`negh'
			}
			else {
				`vv' ///
				`cap' ml model `mm' _exactreg_lf          ///
					(`f'=`x1', nocons), max `outopt' ///
					`initopt' iter(100) collinear    ///
					`negh'
			}
			if _rc!=0 | e(converged)==0 {
				di in gr "{p}note: conditional MLE failed " ///
				 "for variable " abbrev("`dispx'",12) "{p_end}"

				local `bmue' = 1
			}
			else {
				if ("`trace'" != "") `vv' ml display
				mat `b1' = J(1,1,.)
				mat `b1'[1,1] = _b[`x1']
				mat `b'[1,`i'] = _b[`x1']
				mat `v'[1,`i'] = _se[`x1']
				if `v'[1,`i'] < abs(`b1'[1,1]) {
					if ("`se1'"=="") tempname se1
					scalar `se1' = `v'[1,`i']
				}
			}
		}
		if `bmue' {
			if "`trace'" != "" {
				di in gr _n "computing MUE for " ///
				 abbrev("`dispx'",12)
			}
			QUE `x1', f(`f') iv(`iv') eps(`eps') name(`dispx') ///
				`mueinit' `midpopt' `trace'
			mat `b1' = r(b) 
			mat `b'[1,`i'] = `b1'[1,1]
		}
		if `b1'[1,1] < . {
			if "`trace'" != "" {
				di in gr _n "computing CI for " ///
				 abbrev("`dispx'",12)
			}
			QUE `x1', f(`f') iv(`iv') q(`q') b0(`b1') se0(`se1') ///
				eps(`eps') name(`dispx') `midp' `trace'
			mat `ci1' = r(b) 
		}
		else {
			/* b cannot be missing, post will not 	*/
			/* allow it				*/
			`b1'[1,1] = 0
			`ci1' = (.\.)
		}
		summarize `f', meanonly
		scalar `sf' = r(sum)
		qui gen byte `iv1' = sum(`iv')
		summarize `iv1', meanonly
		local j = _N - r(sum) + 1

		summarize `f' if `iv1', meanonly
		scalar `p1' = r(sum)/`sf'

		qui replace `iv1' = 1-`iv1'+`iv'
		summarize `f' if `iv1', meanonly
		scalar `p2' = r(sum)/`sf'
		if "`midp'" != "" {
			summarize `f' if `iv', meanonly
			scalar `sf' = r(sum)/2/`sf'
			scalar `p1' = `p1' - `sf'
			scalar `p2' = `p2' - `sf'
		}
		mat `p'[1,`i'] = min(2*min(`p1',`p2'),1.0)
		if "`trace'" != "" {
			local n1 = max(`j'-10,1)
			local n2 = min(`j'+10,_N)
			local pp1 = round(`p1',1e-5)
			local pp2 = round(`p2',1e-5)
			format `f' %20.15g
			list `iv' `iv1' `x' `f' in `n1'/`n2'
			di in gr %20.15g "suff " `x'[`j'] "  prob = " ///
			 "2*min(`pp1',`pp2') = " `p'[1,`i']
		}
		mat `ci'[1,`i'] = `ci1'[1,"`x1'"]
		mat `ci'[2,`i'] = `ci1'[2,"`x1'"]
		mat `imue'[1,`i'] = (`bmue' > 0)
	}
	matrix colnames `b' = `varlist'
	return matrix b = `b'
	matrix colnames `v' = `varlist'
	return matrix se = `v'
	matrix colnames `p' = `varlist'
	return matrix p = `p'
	matrix colnames `ci' = `varlist'
	return matrix ci = `ci'
	return local level = `level'
	matrix colnames `imue' = `varlist'
	return matrix imue = `imue'
end

program Fn, rclass
	syntax varname, f(varname) iv(varname) b(name) q(name) [ ///
		k(integer 0) pronly ]
		
	tempvar bt
	tempname sbt sbt1 s s1

	local var `varlist'
	matrix score double `bt' = `b'
	qui replace `bt' = `f'*exp(`bt')

	qui count if `bt'>=.
	/* overflow 	*/
	if (r(N) > 0) exit 1400

	summarize `bt', meanonly
	scalar `sbt' = r(sum)
	summarize `bt' if `iv', meanonly
	scalar `sbt1' = r(sum)

	if "`pronly'" == "" {
	        qui replace `bt' = `bt'/`sbt'
		summarize `var' [iw=`bt'], meanonly
		scalar `s' = r(sum)
		if `k'>0  & `k'<=_N {
			/* mid-p-value	*/
                	scalar `sbt1' = `sbt1' - `sbt'*`bt'[`k']/2
			qui replace `bt' = `bt' - `bt'[`k']/2 if _n == `k'
		}
		summarize `var' [iw=`bt'] if `iv', meanonly
		scalar `s1' = r(sum)
	        return scalar g = `s1'-`sbt1'*`s'/`sbt'
	}
	else if `k'>0  & `k'<=_N {
		scalar `sbt1' = `sbt1' - `bt'[`k']/2
	}
	return scalar fn = `sbt1'/`sbt'-`q'
end

/* initial step search -- find a bracketed point 	*/
program Bracket, rclass
	syntax varname, f(passthru) iv(passthru) b0(name) q(name) ///
		step0(name) [ k(passthru) trace ]

	tempname start mid end eval mval try sval tval goldmlt br b step

	mat `b' = `b0'
	scalar `sval' = .
	scalar `mid'  = `b'[1,1]
	scalar `goldmlt' = 1.618
	scalar `step' = `step0'

	Fn `varlist', `f' `iv' b(`b') q(`q') `k' 
	scalar `mval' = r(fn)
	if abs(`mval') < c(epsdouble) {
		/* accidentally hit the root	*/
		return scalar root  = `mid'
		exit
	}
	if ("`trace'" != "") di in gr "Search steps: " _c

	if r(g)*`mval' > 0 {
		/* gradient direction		*/
		scalar `step' = -`step'
	}
	local iter = 0
	while `++iter' <= 100 {
		scalar `try' = `mid' + `step'
		mat `b'[1,1] = `try'
		Fn `varlist', `f' `iv' b(`b') q(`q') `k' pronly
		scalar `tval' = r(fn)
		if abs(`tval') < c(epsdouble) {
			return scalar root  = `try'
			exit
		}
		if `tval'*`mval' <= 0 {
			/* found bracket		*/
			if `step' < 0 {
				scalar `start' = `try'
				scalar `end' = `mid'
				scalar `sval' = `tval'
				scalar `eval' = `mval'
			}
			else {
				scalar `start' = `mid'
				scalar `end' = `try'
				scalar `sval' = `mval'
				scalar `eval' = `tval'
			}
			if ("`trace'"!="") di "b" _c 
			/* bisection refinement		*/
			forvalues i=1/10 {
				scalar `mid' = (`end'+`start')/2
				mat `b'[1,1] = `mid'
				Fn `varlist', `f' `iv' b(`b') q(`q') `k' pronly
				scalar `mval' = r(fn)
				if abs(`mval') < c(epsdouble) {
					return scalar root  = `mval'
					exit
				}
				if `mval'*`sval' < 0 {
					scalar `end' = `mid'
					scalar `eval' = `mval'
					if ("`trace'"!="") di "<" _c 
				}
				else {
					scalar `start' = `mid'
					scalar `sval' = `mval'
					if ("`trace'"!="") di ">" _c 
				}
				if abs(`end'-`start') < abs(`step0') {
					continue, break
				}
			}
			if ("`trace'" != "") di "."

			continue, break
		} 
		else if abs(`tval') < abs(`mval') {
			/* still stepping 		*/
			scalar `start' = `mid'
			scalar `sval' = `mval'
			scalar `mid' = `try'
			scalar `mval' = `tval'
			scalar `step' = `step'*`goldmlt'
			if ("`trace'"!="") di ">" _c 
		}
		else {
			/* reverse direction 		*/
			scalar `start' = `try'
			scalar `sval' = `tval'
			scalar `step' = -`step'         
			if ("`trace'"!="") di "<--|" _c 
		}
	}
	if (`iter' > 100) exit 498

	if "`trace'" != "" {
		di in gr "bracketed points:  " `start' ", " `end'
		di in gr "fn values:         " `sval' ", " `eval'
	}
	mat `br' = (`start',`end')
	return mat bnds = `br'
end

program QUE, rclass
	syntax varname, f(varname) iv(varname) eps(name) [ q(real 0.5) ///
		b0(name) se0(name) name(string) midp trace ]

	tempvar iv1
	tempname b1 fn g p1 b db db1 eps1 br q1 step bnds bb r

	local var `varlist'
	matrix `b' = J(2,1,.)
	scalar `db' = .

	scalar `q1' = `q'
	if `iv'[1]==1 {
		local i1 = 2
		local i2 = 2
		qui gen byte `iv1' = `iv'
		local k = 1
		if (float(`q1') == .5) local midp
	}
	else if `iv'[_N]==1 {
		local i1 = 1
		local i2 = 1
		qui gen byte `iv1' = `iv'
		local k = _N
		if (float(`q1') == .5) local midp
	}
	else {
		local i1 = 1
		local i2 = 2
		qui gen byte `iv1' = sum(`iv')
		if (float(`q1') > .5) local q1 = 1-`q1'

		summarize `iv1', meanonly
		local k = _N-r(sum)+1
	}
	scalar `eps1' = 2e-10
	if "`b0'" == "" {
		tempname b0 
		mat `b0' = J(1,1,0)
		local se0
	}
	if ("`midp'" != "") local kopt k(`k')

	if "`se0'" != "" {
		scalar `step' = `se0'/2
	}
	else if abs(`b0'[1,1]) > 0.01 {
		scalar `step' = abs(`b0'[1,1])/2
	}
	else { 
		tempvar v1
		qui gen double `v1' = abs(`var')
		summarize `v1' [iw=`f'], meanonly
		scalar `step' = 1/abs(r(mean))/2
		qui drop `v1'
	}
	forvalues i=`i1'/`i2' {
		scalar `r' = 0.5
		mat `b1' = `b0'
		mat colnames `b1' = `var'
		if "`se0'" != "" {
			if (`i' == 1) mat `b1'[1,1] = `b1'[1,1] - `se0'
			if (`i' == 2) mat `b1'[1,1] = `b1'[1,1] + `se0'
		}
		local iter = 0
		cap noi Bracket `var', f(`f') iv(`iv1') b0(`b1') q(`q1') ///
			step0(`step') `kopt' `trace'
		local rc = _rc
		if `rc' {
			local iter = 100
			scalar `db1' = .
			scalar `fn' = .
		}
		else {
			scalar `bb' = r(root)
			if `bb' < . {
				/* bracketing algorithm hit root	*/
				mat `b1'[1,1] = `bb'
				mat `bnds' = (`bb'-`step',`bb'+`step')
			}
			else {
				mat `bnds' = r(bnds)
				mat `b1'[1,1] = `bnds'[1,1]
				scalar `r' = 3/4
			}
			Fn `var', f(`f') iv(`iv1') b(`b1') q(`q1') `kopt' 
			scalar `fn' = r(fn)
			scalar `g' = r(g)
			scalar `db1' = (`bnds'[1,2]-`bnds'[1,1])/3
			if ("`trace'" != "") di in gr "Newton steps:"
		}
		while (`++iter'<=100) {
			scalar `db' = `fn'/`g'
			scalar `bb' = `b1'[1,1] 
			if "`trace'" != "" {
				di in gr "iter `iter': x " `bb' " fn " `fn' ///
				 " step " `db' 
			}
			scalar `bb' = `bb' - `db'

			if `bb'<`bnds'[1,1] | `bb'>`bnds'[1,2] {
				if (`db1' >= .) {
					local rc = 499
					continue, break
				}
				scalar `db1' = `db1'*`r'
				if (abs(`db1')<`eps'*abs(`b1'[1,1])) ///
					local iter = 100
				matrix `b1'[1,1] = `b1'[1,1] + `db1'
				if ("`trace'" != "") di in gr "step-halve"
			}
			else {
				scalar `db1' = `db'
				scalar `r' = 0.5
				matrix `b1'[1,1] = `bb'
				if abs(`db')<=`eps'*abs(`b1'[1,1]) | ///
					abs(`fn')<=`eps1' {
					continue, break
				}
			}
			Fn `var', f(`f') iv(`iv1') b(`b1') q(`q1') `kopt' 
			scalar `fn' = r(fn)
			scalar `g' = r(g)
		}
		if `rc'!= 0 | `iter'>100 {
			if float(`q1')!=.5 | `i'!=`i2' {
				local q0 = `q1'
				if (float(`q1')!=.5 & `i'==`i2') ///
					local q0 = 1-`q0'

				di in gr "{p 0 7 2}note: `q0' quantile " ///
				 "estimate for " abbrev("`name'",12) " " ///
				 "failed" _c
				if `rc' == 1400 {
					di in gr "; probability function "  ///
					 "overflowed{p_end}"
				}
				else if `rc' == 498 {
					di in gr " to bracket the value{p_end}"
				}
				else {
				 	di " to converge{p_end}"
				}
			}
			mat `b'[`i',1] = .
		}
		else mat `b'[`i',1] = `b1'

		if (`i'==1 & `i1'!=`i2') qui replace `iv1' = 1-`iv1'+`iv'
	}
	if float(`q') == .5 {
		/* MUE */
		if `i1'==`i2' {
			if (`i1'==1) scalar `b1' = `b'[1,1]
			else scalar `b1' = `b'[2,1]
		}
		else scalar `b1' = (`b'[1,1]+`b'[2,1])/2

		if (`b1' >= .) scalar `b1' = 0
		mat `b' = J(1,1,`b1')
		mat colnames `b' = `var'
		mat rownames `b' = `q50'
	}
	else {
		/* level CI */
		mat colnames `b' = `var'
		local l1 = round(100*`q',.1)
		local l2 = round(100-`l1',.1)
		local l1 = subinstr("`l1'",".","_",1)
		local l2 = subinstr("`l2'",".","_",1)
		mat rownames `b' = q`l1' q`l2'
	}
	return mat b = `b'
end

exit


