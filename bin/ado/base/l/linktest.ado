*! version 3.3.5  30may2019
program define linktest, rclass
* touched by kth -- double saves in S_# and r() 
	version 9.2, missing
	local ver : display string(_caller())
	global T_lnkver "version `ver', missing:"
	version 6, missing
	/* double save in S_# and r() */
	global S_1 . 		/* t of hat squared */
	global S_2 . 		/* dof 		*/

	if _caller()<6 {
		syntax [aw fw pw] [if] [in] [, *]
		marksample touse
		local weight `"[`weight'`exp']"'
	}
	else {
		syntax [if] [in] [, *]
		local weight `"[`e(wtype)'`e(wexp)']"'
		tempvar touse 
		if `"`if'`in'"' != "" {
			mark `touse' `weight' `if' `in' 
		}
		else 	qui gen byte `touse' = e(sample)
	}

	if `"`e(cmd)'"'=="" {
		error 301
	}
	local cmd `"`e(cmd)'"'
	local lhs `"`e(depvar)'"'

	if `"`e(cmd2)'"'=="stcox" {
		local cmd stcox
		local lhs
		local options `options' nohr
	}

	if `"`e(cmd2)'"'=="streg" {
		local cmd streg
		local lhs
	}

	if bsubstr(`"`cmd'"',1,2)=="sw" { 
		local cmd = bsubstr(`"`cmd'"',3,.)
		if `"`cmd'"'=="logis" { local cmd "logistic" }
		else if `"`cmd'"'=="oprbt" { local cmd "oprobit" }
		else if `"`cmd'"'=="pois" { local cmd "poisson" } 
		else if `"`cmd'"'=="weib" { local cmd "weibull" }
	}

	if `"`cmd'"'=="blogit" | `"`cmd'"'=="bprobit" | `"`cmd'"'=="corc" | /*
		*/ `"`cmd'"'=="glogit" | `"`cmd'"'=="gprobit" | /*
		*/ `"`cmd'"'=="rreg" | `"`cmd'"'=="mlogit" | /*
		*/ "`cmd'" == "zip" | "`cmd'" == "zinb" | /*
		*/ "`cmd'" == "biprobit" | bsubstr("`cmd'",1,2) == "xt" | /*
		*/ `"`cmd'"'=="sureg"|`"`cmd'"'=="mvreg" |`"`cmd'"'=="manova"|/*
		*/ `"`cmd'"'=="reg3" | "`cmd'" == "heckprob"| /*
		*/ `"`cmd'"'=="churdle"|`"`cmd'"'=="fracreg"| /*
		*/ `"`cmd'"'=="betareg" | bsubstr("`cmd'",1,2)=="iv" | /*
		*/ "`cmd'" == "zioprobit" | `"`cmd'"'=="spregress" | /* 
		*/ "`cmd'" == "spivregress" | `"`cmd'"'=="spxtregress" | /*
		*/ "`cmd'" == "meta regress" | `"`cmd'"'=="eivreg" |	/*
		*/ "`e(lasso)'" != "" { 
		di as err in smcl `"not possible after {bf:`cmd'}"'
		exit 131
	}

	if `"`cmd'"'!="stcox" && `"`cmd'"'!="streg" {
		capture confirm var `lhs'
		if _rc { 
			di in red `"dependent variable `lhs' not found"'
			exit 111
		}
	}

	confirm new var _hat _hatsq

		
	tempvar hat hat2 base
	quietly { 
		$T_lnkver _predict `hat' if `touse', xb
		count if `touse' & `hat'< . & `e(depvar)'< .
		if r(N)<3 { 
			noisily error 2001
		}
	}
	if `"`cmd'"'=="regress" | `"`cmd'"'=="anova" | `"`cmd'"'=="stepwise" { 
		local nxtcmd "regress"
	}
	else if `"`cmd'"'=="logistic" { 
		local nxtcmd "logit"
	}
	else if `"`cmd'"'=="cnsreg" | `"`cmd'"'=="eivreg" {
		local nxtcmd "regress"
		local options
	}
	else	local nxtcmd `cmd'

	local pref `"`e(prefix)'"'
	local sub `"`e(subpop)'"'
	local vce `"`e(vce)'"'
	local mse `"`e(mse)'"'

	quietly gen `hat2'=`hat'^2
	estimates hold `base'
	capture { 
		rename `hat' _hat
		rename `hat2' _hatsq
		if `"`pref'"'=="svy" {
			if `"`sub'"'~="" {
				$T_lnkver noisily svy `vce', subpop(`sub') /*
				*/ `mse': `nxtcmd' `lhs' _hat _hatsq /*
				*/ if `touse', /*
				*/ `options'
			}
			else {
				$T_lnkver noisily svy `vce', `mse': `nxtcmd' /*
				*/ `lhs' _hat _hatsq /*
				*/ if `touse', /*
				*/ `options'
			}
		}
		else {
			$T_lnkver noisily `nxtcmd' `lhs' _hat _hatsq `weight' /*
			*/ if `touse', /*
			*/ `options'
		}
		/* double save in S_# and r() */
		ret scalar t = _b[_hatsq]/_se[_hatsq]
		ret scalar df = e(df_r)
		global S_1 `"`return(t)'"'
		global S_2 `"`return(df)'"'
* replaced this -- new syntax _result(5) and S_E_tdf both now saved in e(df_r)
*		global S_2 "$S_E_tdf"
*		if "$S_2"=="" {
*			global S_2 = _result(5) 
*		}
	}
	local rc=_rc
	estimates unhold `base'
	capture drop _hat
	capture drop _hatsq
	exit `rc'
end
