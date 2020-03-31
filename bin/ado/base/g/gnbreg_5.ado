*! version 1.1.9  15oct2019
* Final; version 5 backwards compatibility 
program define gnbreg_5, eclass
	version 6.0, missing
	local options "Level(cilevel) IRr"
	if (`"`1'"'!="" & bsubstr(`"`1'"',1,1)!=",") {
		parse `"`*'"', parse(" ,")
		local lnmean `1'
		local lnalpha `2'
		mac shift 2

		local options /*
		*/ `"`options' noLOg Offset(varname) Exposure(varname) TRace"'
		local in "opt"
		local if "opt"
		local weight "fweight aweight"
		parse "`*'"

		if `"`log'"'!="" { 
			local log "quietly"
		}

		eq ? `lnmean'
		local lnmean `r(eqname)'
		parse `"`r(eq)'"', parse(" ")
		local dv `1'
		if (`"`dv'"'=="") { local dv `lnmean' }
		mac shift
		local vl1 `"`*'"'
		eq ? `lnalpha'
		local lnalpha `r(eqname)'
		local vl2 `"`r(eq)'"'

		if "`offset'"!="" {
			if "`exposur'"!="" {
				version 7: di in red /*
			*/ "options {bf:offset()} and {bf:exposure()} may not be specified together"
				exit 198
			}
			local off1 "`offset'"
		}
		else if "`exposur'"!="" {
			local off1 "ln(`exposur')"
		}

		tempvar mysamp
		tempname b bb f V
		ml_5 begin
		if (`"`exposur'"'!="") {
			tempvar offset
			qui gen `offset' = ln(`exposur')
		}
		global S_mloff `"`offset'"'    /* ok to use S_ here */
		ml_5 func ml_nb0
		ml_5 method lf
		mat `bb' = J(1,2,0)
		mat colnames `bb' = _cons _cons
		mat coleq `bb' = `lnmean' `lnalpha'
		ml_5 sample `mysamp' `dv' `vl1' `vl2' `offset' `if' `in' [`weight'`exp']
		qui summ `dv' [aw=`mysamp']
		mat `bb'[1,1] = ln(r(mean))
		if (`"$S_mloff"'!="") {
			local offparm offset(`offset')
			qui summ `offset' [aw=`mysamp']
			mat `bb'[1,1] = `bb'[1,1] - r(mean)
		}
		global S_mlmb `bb'  /* ok to use S_ here */
		ml_5 depn `dv'
		`log' ml_5 max `f' `V', `trace' style(2) dacc(1e-4)
		local lf00 = `f'

		if `"`weight'"'=="fweight" {
			qui poisson `dv' `vl1' [fweight=`mysamp'], `offparm'
		}
		else	qui poisson `dv' `vl1' [aweight=`mysamp'], `offparm'
		local lf0 = e(ll)
		mat `b' = get(_b)
		mat coleq `b' = `lnmean'
		global S_mlmb `b'   /* ok to use S_ here */
		local k : word count `vl2'
		local mymodel = e(df_m) + `k'
		if (`lf0'<`lf00') {
			local i = colsof(`b')
			mat `b' = `b' * 0
			mat `b'[1,`i'] = `bb'[1,1]
		}
		mat `bb' = `bb'[1,2]
		mat `bb' = `b' , `bb'
		ml_5 model `b' = `lnmean' `lnalpha', depv(0) from(`bb')
		mat `b' = `b'[1,2...] /* strip off unwanted dependent variable */
		ml_5 depn `dv'
		global S_mlmdf `mymodel'    /* ok to use S_ here */
		`log' ml_5 max `f' `V', `trace' style(2) dacc(1e-3)
		mat `bb' = `b'[1,`"`lnalpha':"']
		ml_5 post gnbreg, title(Negative Binomial Regression) lf0(`lf00') pr2
		est scalar ll_p = `lf0'  /* double save */
		est local predict 
		est local offset1 "`off1'"
		global S_E_pll `lf0'
	}
	else {
		if (`"`e(cmd)'"'!="gnbreg") { error 301 }
		parse `"`*'"'
	}
	if `"`irr'"'!="" {
		local irr "eform(IRR)"
	}
	est scalar chi2_p = 2*(e(ll)-e(ll_p))  /* double save */
	global S_1 `"`e(chi2_p)'"'
	ml_5 mlout gnbreg, level(`level') `irr'
	di _col(21) in gr "(LR test against Poisson, chi2(1) = " /* 
	*/ in ye %9.0g e(chi2_p) /*
	  */ in gr " P = ", in ye %6.4f chiprob(1,e(chi2_p)) in gr ")"
end
