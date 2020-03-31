*! version 3.0.16 04feb2015
*! made boxcox_6 on 22may2000
program define boxcox_6, eclass
	version 6, missing
	if replay() {
		if "`e(cmd)'"!="boxcox_6" { error 301 } 
	}
	else { 
		/*
			Global macros used, other than S_*:
			S_B_exp, S_B_ix, S_B_ropt, S_B_rhs, S_B_lmax, S_B_rms,
			S_B_gm.
		*/
		syntax varlist(numeric) [if] [in] [aw fw] [, /*
			*/ DELta(real .01) Generate(string) GRaph GRVars /*
			*/ Iterate(integer 0) Level(integer 0) noLOg /*
			*/ LStart(real 1e20) MEAn MEDian /*
			*/ Ropt(string) SAVing(string) Zero(real .001) ]

		if "`generat'"!="" { 
			conf new var `generat'
		}
		if "`grvars'"!="" { 
			conf new var _ll _lx 
		}

		tempvar x lx ll s xtsf 
		marksample touse

		est clear

		if `level'<10 | `level'>99 { 
			local level 95
			local ci 0
		} 
		else 	local ci=`level'/100

		global S_B_exp `"[`weight'`exp']"'
		global S_B_ropt "`ropt'"

		tokenize `varlist'
		local lhs "`1'"
		mac shift
		global S_B_rhs "`*'"

		qui gen double `x' = `lhs' if `touse'
		qui summ `x'
		if r(N)<3 { error 2001 } 
		if r(min) == r(max) {
			di in red "`lhs' has no variance"
			exit 498
		}
		if (`zero' == 0) & (`ci' > 0) {
			di in red "no confidence interval when zero = 0"
			exit 198
		}
		if `iterate' <= 0 { local iterate 20 }
		local noisy = ("`log'" == "")

		local finalrc 0
		/*
			Calc geometric mean of `x' or its transform
		*/
		if "`mean'"!="" | "`median'"!="" {
			if "`mean'"!="" & "`median'"!="" { error 198 } 
			if "`median'"!="" { 
				qui summ `x', d
				local cent = r(p50)
			}
			else {
				qui summ `x', meanonly
				local cent = r(mean)
			}
			local sym 1
			quietly { 
				gen `s' = sign(`x'-`cent')
				replace `x' = abs(`x'-`cent')+1
				gen double `xtsf' = ln(`x')
				summ `xtsf', meanonly
				global S_B_gm = exp(r(mean))
			}
		}
		else {
			local sym 0
			capture assert `x'>0
			if _rc {
				di in red "`lhs' has zero or negative values"
				exit 498
			}
			quietly { 
				gen `s' = 1
				gen double `xtsf' = ln(`x')
				summ `xtsf', meanonly
				global S_B_gm = exp(r(mean))
			}
		}

			/*
				Calculate LL for untransformed data.
			*/
		_crcbcll `xtsf' `x' `s' 1 1
		local lraw $S_B_lmax
		_crcbcll `xtsf' `x' `s' 0 $S_B_gm
		local lln $S_B_lmax
		_crcbcll `xtsf' `x' `s' -1 $S_B_gm
		local lneg1 $S_B_lmax
		local k = cond(`lstart'<.999e20, `lstart', 1)

		if `noisy' & `zero'!=0 {
			di in gr "(note: iterations performed using zero =" /*
				*/ in ye `zero' in gr ")" _n
		}
		qui gen `lx' = .
		qui gen `ll' = .
		global S_B_ix 0

		local kl .
		local kh .
		local target 0
		local deriv 1
		global S_1 0
		global S_5 0
		_crcbcrt `x' `lx' `ll' `s' `xtsf' `k' `zero' `delta' /*
			*/ `target' `iterate' `noisy' `deriv' 
		if `zero'==0 { 
			di in gr "Log likelihood(L=" $S_1 ") = " in ye $S_5
			global S_4 $S_5
			exit
		}
		local k $S_1 /* lambda */
		local ltsf $S_5 /* maximized log likelihood */
		if ($S_2 == -1) {
			capture noisily error 430
			local finalrc 430
		}
		local x2 0
		if (`ci' > 0) & (`k' < .) & `finalrc'==0 {
			/*
				Find support interval for lambda.
				First calculate LL for untransformed data.
			*/
			local x2 = 0.5*invnorm(0.5+0.5*`ci')^2
			/*
				Lower confidence limit (if it exists).
				If not, it is taken as missing (minus infinity).
			*/
			local target = -`x2'
			local deriv 0
			global S_1 `k'
			/*
				Starting value for lower limit for lambda
				is lambda-0.1. Pass max LL via S_5
				and lambda via S_1.
			*/
			local kl = `k'-.5
			if `noisy' { 
				di _n in gr /*
				*/ "Iterations for lower confidence interval:"
			}
			_crcbcrt `x' `lx' `ll' `s' `xtsf' `kl' `zero' /*
				*/ `delta' `target' `iterate' `noisy' `deriv'
			local kl $S_1
			if ($S_2 == -1) {
				local kl .
				di in red /*
				*/ "lower limit: convergence not achieved"
			}
			local target = -`target'
			global S_1 `k'
			global S_5 `ltsf'
			local kh = `k'+0.5
			if `noisy' { 
				di _n in gr /*
				*/ "Iterations for upper confidence interval:"
			}
			_crcbcrt `x' `lx' `ll' `s' `xtsf' `kh' `zero' /*
				*/ `delta' `target' `iterate' `noisy' `deriv'
			local kh $S_1
			if ($S_2 == -1) {
				local kh .
				di in red /*
				*/ "upper limit: convergence not achieved"
			}
		}

		lab var `ll' "Log likelihood"
		lab var `lx' "Lambda"
		if "`graph'"!="" { 
			if `"`saving'"'!="" { 
				local saving `"saving(`"`saving'"')"'
			}
			if (`ltsf' < .) & (`x2' > 0) {
				local yl = `ltsf'-`x2'
				gr7 `ll' `lx', c(s) s(O) xla yla /*
				*/ yline(`yl') sort `saving'
			}
			else {
				gr7 `ll' `lx', c(s) s(O) xla yla sort `saving'
			}
		}


		if `finalrc'==0 {
			if "`generat'"!="" | "$S_B_rhs"!="" { 
				if "`generat'"=="" { 
					tempvar generat
					local depname "depname(_boxcox)"
				}
				if abs(`k')>1e-10 {
					qui gen `generat' = `s'*((`x')^`k'-1)/`k'
					version 2.1, missing
					local kr=round(`k',.0001)
					version 6, missing
					if "`mean'"!="" {
						lab var `generat'/*
						*/ "s*BC(|`lhs'-mn+1|,`kr')"
					}
					else if "`median'"!="" { 
						lab var `generat'/*
						*/ "s*BC(|`lhs'-md+1|,`kr')"
					}
					else 	lab var `generat' /*
						*/ "BC(`lhs',`kr')"
				}
				else {
					qui gen `generat' = `s'*ln(`x')
					if "`mean'"!="" { 
						lab var `generat' /*
						*/ "s*ln(|`lhs'-mn+1|)"
					}
					else if "`median'"!="" { 
						lab var `generat' /*
						*/ "s*ln(|`lhs'-md+1|)"
					}
					else	lab var `generat' "ln(`lhs')"
				}
				if "$S_B_rhs"!="" { 
					qui reg `generat' $S_B_rhs $S_B_exp, /*
					*/ $S_B_ropt `depname'
					global S_E_reg 1     /* double save */
					est scalar reg = 1
				}
			}
		}
		if "`grvars'"!="" { 
			rename `ll' _ll
			rename `lx' _lx
		}

			/* double save results in e() and S_E_ */
		est scalar L = `k'
		global S_E_L `k'
		if `ci' {
			est scalar lb_L = `kl'
			est scalar ub_L = `kh'
			global S_E_L0 `kl'
			global S_E_L1 `kh'
		}
		else {
			est scalar lb_L = .
			est scalar ub_L = .
			global S_E_L0
			global S_E_L1
		}
		if "`mean'`median'" != "" {
			est local center "`mean'`median'"
			if "`mean'" != "" { est scalar mean = `cent' }
			else              { est scalar median = `cent' }
			global S_E_xf "`mean'`median'"
			global S_E_ctr `cent'
		}
		est local ll_0		/* clear from regress */
		est scalar ll = `ltsf'
		est local depvar "`lhs'"
		est scalar level = `level'
		est scalar chi2_m1 = 2*(`ltsf'-`lneg1')
		est scalar chi2_0 = 2*(`ltsf'-`lln')
		est scalar chi2_1 = 2*(`ltsf'-`lraw')
		est scalar rc = `finalrc'
		global S_E_ll `ltsf'
		global S_E_depv "`lhs'"
		global S_E_lvl	`level'
		global S_E_llm1 = e(chi2_m1)
		global S_E_ll0 = e(chi2_0)
		global S_E_ll1 = e(chi2_1)
		global S_E_rc `finalrc'

		est local predict boxcox_6_p
		est local cmd "boxcox_6"
		global S_E_cmd "boxcox_6"

		mac drop S_B_ropt S_B_exp S_B_ix S_B_rhs S_B_lmax /*
			*/ S_B_rms S_B_gm

	} /* end estimate */

	/* double save also in S_# (in addition to S_E_ and e()) */
	global S_1 $S_E_L
	global S_2 $S_E_L0
	global S_3 $S_E_L1
	global S_4 $S_E_ll
	global S_5 $S_E_llm1
	global S_6 $S_E_ll0
	global S_7 $S_E_ll1

	if "`e(center)'" != "" { 
		di _n in gr "Transform:  " /*
*/ "sign(`e(depvar)'-`e(center)')*((|`e(depvar)'-`e(center)'|)+1^L-1)/L, `e(center)' = " /*
		*/ e(`e(center)')
	}
	else 	di _n in gr "Transform:  (`e(depvar)'^L-1)/L"

	di _n in gr /*
		*/ _col(18) "L" /*
		*/ _col(26) "[`e(level)'% Conf. Interval]" /*
		*/ _col(51) "Log Likelihood" _n /*
		*/ _col(13) _dup(52) "-" 
	di _col(13) %9.4f e(L) "    " _c
	if e(lb_L)<. { 
		di %9.4f e(lb_L) "  " %9.4f e(ub_L) _c
	}
	else	di in gr "  (not calculated)  " _c
	di "         " %10.0g e(ll) _n

	di in gr _col(6) "Test:  L == -1" _col(26) "chi2(1) = " /*
		*/ in ye %8.2f e(chi2_m1) /*
		*/ in gr _col(48) "Pr>chi2 =" /*
		*/ in ye %8.4f chiprob(1,e(chi2_m1))
	
	di in gr _col(13) "L ==  0" _col(26) "chi2(1) = " /*
		*/ in ye %8.2f e(chi2_0) /*
		*/ in gr _col(48) "Pr>chi2 =" /*
		*/ in ye %8.4f chiprob(1,e(chi2_0))

	di in gr _col(13) "L ==  1" _col(26) "chi2(1) = " /*
		*/ in ye %8.2f e(chi2_1) /*
		*/ in gr _col(48) "Pr>chi2 =" /*
		*/ in ye %8.4f chiprob(1,e(chi2_1))

	if "`e(reg)'"!="" { 
		di _n in gr "(type " in ye "regress" in gr /*
	*/ " without arguments for regression estimates conditional on L)"
	}
	error `e(rc)'
end


program define _crcbcrt
/*
	Right-hand side variables for regression or anova passed in $S_B_rhs.
	Returns lambda in $S_1, #iterations in $S_2, max LL in $S_5.
*/
	local k0 = $S_1		/* ML est of lambda, if already calculated */
	local ltsf = $S_5	/* Max log likelihood, if already calculated */
	local x 	"`1'"
	local lx 	"`2'"
	local ll 	"`3'"
	local s 	"`4'"
	local xtsf 	"`5'"
	local k   	`6'	/* Starting value for lambda 		*/
	local zero	`7'	/* def of zero, 0 -> calc. just once	*/
	local delta	`8'
	local target	`9'	/* target LL 				*/
	local itmax	`10'	/* max allowed iterations		*/
	local noisy	`11'	/* 1 -> noisy mode			*/
	local deriv	`12'

	local iter 0
	/*
		Transformation is standardized Box-Cox (Atkinson p.87)
	*/
	_crcbcll `xtsf' `x' `s' `k' $S_B_gm
	local lmax $S_B_lmax
	local rms $S_B_rms
	if `noisy' & `zero'!=0 {
		di in gr _col(4) /*
	*/ "Iteration      Lambda         Zero     Variance        LL" /*
		*/ _n _col(4) _dup(60) "-"
	}
	if `zero' == 0 { local f0 0 }
	else {
		if `deriv' {
			local e = `k'+`delta'
			_crcbcll `xtsf' `x' `s' `e' $S_B_gm
			local f0 = ($S_B_lmax-`lmax')/`delta'
		}
		else {
			local f0 = `ltsf'-$S_B_lmax
			if `k' < `k0' { local f0 = -`f0' }
			local f0 = `f0'-`target'
		}
/* wwg */
		local f0m2 .
		local f0m1 . 
		local k2 . 
		local k1 .
		local reason
/* end wwg */
		while (abs(`f0') > `zero') & (`iter' < `itmax') {
			local f0m2 `f0m1'
			local k2 `k1'
			local f0m1 `f0'
			local k1 `k'
			if `noisy' {
				di in ye _col(4) %7.0f `iter' /*
					*/ _col(16) %9.4f `k' /*
					*/ %13.5f `f0'  /*
					*/ "  " %11.0g $S_B_rms %13.5f $S_B_lmax /* 
					*/ in gr " `reason'"
			}
			local reason
			global S_B_ix = $S_B_ix+1
			if $S_B_ix<=_N { 
				qui replace `lx' = `k' in $S_B_ix
				qui replace `ll' = `lmax' in $S_B_ix
			}
			local iter = `iter'+1
			local e = `k'+`delta'
			_crcbcll `xtsf' `x' `s' `e' $S_B_gm
			if `deriv' {
				local f1 $S_B_lmax
				local e = `e'+`delta'
				_crcbcll `xtsf' `x' `s' `e' $S_B_gm
				local f1 = ($S_B_lmax-`f1')/`delta'
			}
			else {
				local f1 = `ltsf'-$S_B_lmax
				if `k' < `k0' { local f1 = -`f1' }
				local f1 = `f1'-`target'
			}
			local m = (`f1'-`f0')/`delta'
			if `m' == 0 {
				noisily di in red /*
				*/ "Convergence problem, doubling the value of delta."
				local delta = `delta'*2
			}
			else {
				local k = `k'-`f0'/`m'
/* BEGIN INSERT */
				if `f0m2'<. & `f0m1'<. & `f0m2'*`f0m1'<0 {
					/* k1 k k2   or  k2 k k1 */
					if !(`k1'<`k' & `k'<`k2' | /* 
					*/ `k2'<`k' & `k'<`k1') {
						local k=(`k1'+`k2')/2
						local reason "(*)"
						local hasmp "yes"
					}
				}
				if abs(`k')>20 {
					local k=uniform()*2 - 1
					local reason "(**)"
					local hasrnd "yes"
					local iter 0	/* reset */
				}
/* END INSERT */
				_crcbcll `xtsf' `x' `s' `k' $S_B_gm
				local lmax $S_B_lmax
				local rms $S_B_rms
				if `deriv' {
					local e = `k'+`delta'
					_crcbcll `xtsf' `x' `s' `e' $S_B_gm
					local f0 = ($S_B_lmax-`lmax')/`delta'
				}
				else {
					local f0 = `ltsf'-$S_B_lmax
					if `k' < `k0' { local f0 = -`f0' }
					local f0 = `f0'-`target'
				}
			}
			if $S_B_lmax >= . { local iter `itmax' }
		}
		if abs(`f0') > `zero' {
		/*
			Convergence failure - iterations set to -1.
		*/
			global S_2 -1
		}
		else	global S_2 `iter'
	}
	if `noisy' & `zero'!=0 {
		di in ye _col(4) %7.0f `iter' /*
			*/ _col(16) %9.4f `k' /*
			*/ %13.5f `f0' "  " %11.0g $S_B_rms %13.5f $S_B_lmax /*
			*/ _n _col(4) in gr _dup(60) "-"
		if "`hasmp'"=="yes" {
			di in gr /*
*/ "    * (lambda obtained as midpoint of previous two iterations)"
		}
		if "`hasrnd'"=="yes" { 
			di in gr /* 
*/ "   ** (lambda obtained by randomly choosing a new starting value)"
		}
		if ("`hasrnd'"=="yes" | "`hasmp'"=="yes") & $S_2!=-1 { 
			di in gr /* 
*/ "      (despite this, convergence was achieved)"
		}
	}
	global S_1 `k'
	global S_5 `lmax'
end


program define _crcbcll
/*
	Either regress `xtsf' on $S_B_rhs or summarize `xtsf'.
	RMS, in $S_B_rms, and partially maximized likelihood in $S_B_lmax.
*/

	local xtsf 	"`1'"		/* var to be (re)created	*/
	local x 	"`2'"
	local sign 	"`3'"		/* sign of `x'			*/
	local k 	`4'		/* Lambda			*/
	local gmean 	`5'		/* geometric mean of `x'	*/

	cap drop `xtsf'

	quietly {
		if abs(`k')>1e-10 {
			gen double `xtsf'=/*
				*/ `sign'*((`x')^`k'-1)/(`k'*(`gmean')^(`k'-1))
		}
		else {
			gen double `xtsf'=`sign'*`gmean'*ln(`x')
		}
		if "$S_B_rhs" == "" {
			summ `xtsf' $S_B_exp, detail
			local rss = (r(N)-1)*r(Var)
			global S_B_rms = `rss'/r(N)
			if $S_B_rms == 0 { global S_B_rms = 1e-7 }
			global S_B_lmax = -0.5*r(N)*ln($S_B_rms)
		}
		else {
			reg `xtsf' $S_B_rhs $S_B_exp, $S_B_ropt
			local rss = e(rss)
			global S_B_rms = `rss'/e(N)
			if $S_B_rms == 0 { global S_B_rms = 1e-7 }
			global S_B_lmax = -0.5*e(N)*ln($S_B_rms)
		}
	}
end
