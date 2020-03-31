*! version 3.1.10  09feb2015  
program define hereg
	quietly version 
	if _result(1)>=5 { 
		OodMsg 
		exit
	}
	version 3.1
	local options "Level(integer $S_level) Hr Tr"
	if "`1'"!="" & bsubstr("`1'",1,1)!="," { 
		local varlist "req ex"
		local options /*
*/ "`options' noLOg LTolerance(real -1) ITerate(integer 0) Dead(string) HAzard Group(string)"
		local in "opt"
		local if "opt"
		local weight "fweight aweight pweight"
		parse "`*'"
		parse "`varlist'", parse(" ")
		tempvar touse lstobs predz wt epred Fakedv died score hess
		tempname coefs VCE
		if ("`group'"!="") {
			sort `group'
			local grs "group(`group')"
		}
		local dv "`1'"
		mac shift
		if "`log'"=="" { local log noisily }
		else local log "*"
		if ("`hazard'"=="" & "`hr'"!="") { local hazard "hazard" }
		if ("`hazard'"!="" & "`tr'"!="") { error 198 }

		global S_E_cmd

		if "`weight'"=="pweight" {
			local wtype "aweight"
		}
		else	local wtype "`weight'"

		quietly {
			mark `touse' [`weight'`exp'] `if' `in'
			markout `touse' `varlist' `group'

			cap assert `dv'>0 if `touse'
			if (_rc) {
				noisily di in red /*
				*/ "Dependent variable must be positive"
				exit 450 
			}

			if ("`dead'"!="") { gen byte `died' = `dead' }
			else { gen byte `died' = 1 }
			if "`exp'"!="" {
				gen float `wt' `exp' if `touse'
				* replace `wt'=. if `wt'<=0
				* replace `touse'=0 if `wt'==.
				if "`weight'"!="fweight" {
					reg `dv' `*' if `touse'
					* predict `predz'
					* replace `touse'=0 if `predz'==.
					* drop `predz'
					sum `wt' if `touse'
					replace `wt' = `wt'/_result(3)
				}
			}
			else    gen float `wt'=`touse'
			regress `dv' `*' [aw=`wt'] if `touse'
			local tminusk = _result(5)
			if _result(1)==0 | _result(1)==. { 
				regress `dv' `*' if `touse'
				if _result(1)==0 | _result(1)==. { 
					noisily error 2000
				}
				noisily error 1400
			}
			* predict `predz'
			* replace `touse'=0 if `predz'==.
			* drop `predz'

			count if `touse'
			if _result(1)==0 { noisily error 2000 }
			if `ltolera'<0 { local ltolera 1e-7 } 
			if `iterate'<=0 { local iterate 1000 }
			local dll 1
			local niter 0

			gen `c(obs_t)' `lstobs'=_n if `touse'
			replace `lstobs'=`lstobs'[_n-1] if `lstobs'==.
			local lastobs=`lstobs'[_N]
			drop `lstobs'
			sum `dv' [`wtype'`exp'] if `touse'
			local emu = _result(3)
			local nobs = _result(1)
			sum `died' [aw=`wt']
			local obsdead = _result(2)*_result(3)
			local emu = `emu'*`nobs'/`obsdead'
			gen float `predz' = -ln(`emu') if `touse'
			gen float `epred' = 1/`emu' if `touse'
			gen float `Fakedv' = - `dv'*`epred' if `touse'
			replace `Fakedv'=`Fakedv'+log(`dv')+`predz' if `died'
			replace `Fakedv' = sum(`Fakedv'*`wt') if `touse'
			local ll0 = `Fakedv'[`lastobs']
			replace `Fakedv' = - 1 - `dv'
			replace `Fakedv' = sum(`Fakedv'*`wt'*`died')
			local llperf = `Fakedv'[`lastobs']
			local myll = `ll0'
			`log' di
			while ((abs(`dll')>`ltolera'*abs(`myll') /*
			*/ & `niter'<`iterate') | (`niter'==0)) {
				#delimit ;
				`log' di in gr
					"Iteration `niter': Log Likelihood = "
					in ye `myll' ;
				* weight = 2nd derivative
				* y = deriv/weight + old predicted;
				replace `Fakedv'=cond(`died',
					1/`epred'/`dv'-1, -1) + `predz';
				reg `Fakedv' `*'
					[iw=(`dv'*`epred')*`wt'], 
					mse1 dep(`dv') dof(`tminusk');
				#delimit cr
				cap drop `hess' `score'
				gen `hess' = `dv'*`epred'
				gen `score' = (`Fakedv'-`predz')*`hess'
				if _result(1)==0 | _result(1)==. { 
					noisily error 1400 
				}
				local regMDF = _result(3)
				drop `predz'
				predict `predz' if `touse'
				replace `epred' = exp(`predz')
				capture assert `epred'!=. if `touse'
				if _rc { noisily error 1400 } 
				replace `Fakedv' = - `dv'*`epred' if `touse'
				replace `Fakedv' = `Fakedv' + log(`dv') + /*
					*/ `predz' if `died' & `touse'
				replace `Fakedv' = sum(`Fakedv'*`wt') if `touse'
				local mynll = `Fakedv'[`lastobs']
				local dll = `mynll'-`myll'
				local myll `mynll'
				local niter = `niter'+1
			}
			if ("`hazard'"=="") {
				local form "(log expected time form)"
				replace `Fakedv' = cond(`died', /*
					*/ (-1/`epred'/`dv')+1,1) - `predz'
				reg `Fakedv' `*' [iw=`dv'*`epred'*`wt'], /*
					*/ mse1 dep(`dv') dof(`tminusk')
			}
			else { 
				local form "(log relative hazard form)" 
			}
		}
		if _b[_cons]==0 { global S_E_nc "nocons" }
		if ("`weight'"=="") { local weight "aweight"}
		capture assert `touse'
		if _rc { 
			preserve
			quietly keep if `touse'
		}
		quietly _huber `score' `hess' [`weight'=`wt'], `grs'
		mat `coefs' = get(_b) 
		mat `VCE' = get(VCE)
		mat post `coefs' `VCE', obs(`nobs') depn(`dv')
		global S_E_ll `myll'
		global S_E_chi2= 2*(`myll'-`ll0')
		global S_E_pr2 = 1-`myll'/`ll0'
		global S_E_mdf `regMDF'
		global S_E_nobs `nobs'
		global S_E_htyp `hazard'
		global S_E_frm "`form'"
		global S_E_tdf "."
		global S_E_depv "`dv'"
		global S_E_cmd "hereg"
	}
	else {
		if "$S_E_cmd"!="hereg" {
			error 301
		}
		parse "`*'"
		if ("$S_E_htyp"=="" & "`hr'"!="") { error 198 }
		if ("$S_E_htyp"!="" & "`tr'"!="") { error 198 }
	}

	if `level'<10 | `level'>99 { local level 95 }
	if "`hr'"!="" {
		if "$S_E_nc"=="" { local hr "eform(Hz. Ratio)" }
		else {
			local hr
			local ncnote "yes"
		}
	}
	if "`tr'"!="" {
		if "$S_E_nc"=="" { local hr "eform(Time Ratio)" }
		else {
			local hr
			local ncnote "yes"
		}
	}

	#delimit ;
	di _n in gr 
	"Exponential regression $S_E_frm" _col(53)
		"Number of obs    =" in yel %8.0f $S_E_nobs _n
	in gre "Log Likelihood" _col(29) "=" in yel %10.3f $S_E_ll 
		_col(53) in gr "Pseudo R2        ="
		in yel %8.4f $S_E_pr2
		_n ;
	#delimit cr
	mat mlout, level(`level') `hr'
	if "`ncnote'"!="" {
		di in bl /*
*/ "(cannot show relative risk ratios since _cons was dropped)"
	}
end


program define OodMsg
	version 5.0
	#delimit ; 
	di in ye "hereg" in gr 
		" is an out-of-date command; " in ye "ereg, robust" in gr 
		" is its replacement." _n ; 
	di in smcl in gr 
		"    Rather than typing" _col(41) "Type:" _n 
		"    {hline 30}      {hline 36}" ;
	di in ye "    . hereg" in gr " yvar xvars" in ye _col(41)
		"ereg " in gr "yvar xvars" in ye ", robust" ;
	di in ye "    . hereg" in gr " yvar xvars" in ye ", group(" in gr 
		"gvar" in ye ")" _col(41)
		"ereg" in gr " yvar xvars" in ye ", cluster(" in gr 
		"gvar" in ye ")" ;
	di in ye "    . hereg" in gr " yvar xxvars" in ye " [pw=" in gr "w"
			in ye "]" _col(41) 
		"ereg" in gr " yvar xvars" in ye " [pw=" in gr "w" 
			in ye "]" ;
	di in smcl in gr "    {hline 30}      {hline 36}" ;
	di in gr _col(41) "Note:  " in ye "cluster()" 
		in gr " implies " in ye "robust" _n _col(48)
		"pweight" in gr "s imply " in ye "robust" _n ;

	di in gr "The only difference is that " in ye 
		"ereg, robust" in gr " applies a degree-of-freedom" _n 
		"correction to the VCE that " in ye "hereg" in gr 
		" did not.  " in ye "ereg, robust" in gr 
		" is better." _n(2) 
		"If you must use " in ye "hereg" in gr ", type" _n ;
 
	di in ye _col(8) ". version 4.0" _n 
		_col(8) ". hereg " in gr "..." in ye _n 
		_col(8) ". version 6.0" _n ;
	#delimit cr
	exit 199
end
exit
	
hereg is an out-of-date command; ereg, robust is its replacement.

    Rather than typing                  Type:
    --------------------------------    ------------------------------------
    . hereg yvar vars                   . ereg yvar xvars, robust
    . hereg yvar xvars, group(gvar)     . ereg yvar xvars, cluster(gvar)
    . hereg yvar xvars [pw=2]           . ereg yvar xvars [pw=w]
    --------------------------------    ------------------------------------
                                        Note:  cluster() implies robust
                                               pweights imply robust

The only difference is that ereg, robust applies a degree-of-freedom 
correction to the VCE that hereg did not.  ereg, robust is better.

If you must use hereg, type

        . version 4.0
        . hereg ...
        . version 6.0

r(199);
