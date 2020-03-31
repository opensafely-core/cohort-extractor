*! version 1.0.11  16feb2015
program define hareg
	quietly version 
	if _result(1)>=5 { 
		OodMsg 
		exit
	}
	version 3.1
	local options "Level(integer $S_level)"
	if ("`1'"!="" & bsubstr("`1'",1,1)!=",") {
		local varlist "req ex"
		local if "opt"
		local in "opt"
		local weight "fweight aweight pweight iweight"
		local options "`options' Absorb(string) Group(string)"
		parse "`*'"
		if ("`group'"!="") {
			confirm var `group'
			local grs "group(`group')"
		}
		if "`absorb'"=="" {
			di in red "absorb() required"
			exit 198
		}
		unabbrev `absorb'
		local absorb "`s(varlist)'"
		local n : word count `absorb'
		if `n'!=1 {
			di in red "absorb() invalid"
			exit 103
		}
		parse "`varlist'", parse(" ")
		tempvar x c w touse
		local dv `1'
		quietly {
			mark `touse' [`weight'`exp'] `if' `in'
			markout `touse' `varlist' `absorb' `group'
			count if `touse'
			if _result(1)<=1 { error 2001 } 
			preserve
			keep if `touse'
			if "`weight'"!="" {
				tempvar userwgt
				gen float `userwgt' `exp'
				local exp "= `userwgt'"
			}
			keep `varlist' `absorb' `group' `userwgt'
			recast float `varlist'
			sort `absorb'
			by `absorb': gen `c(obs_t)' `c' = _N
			local myc = _N
			if ("`weight'"!="") {
				gen `w' `exp'
				summ `w'
				local myc = _result(1)*_result(3)
				qui by `absorb': replace `c' = sum(`w')
				if ("`weight'"=="pweight") { 
					local sweight aweight 
				}
				else 	local sweight `weight'
			}
			else 	gen byte `w' = 1 
			summ `1' [`sweight'`exp']
			local sst = (_result(1)-1)*_result(4)
			gen `x'=. 
			while ("`1'"!="") {
				replace `x' = sum(`w'*`1')
				local mymean = `x'[_N]/`myc'
				by `absorb': replace `x' = sum(`w'*`1')
				by `absorb': replace `1' = `1' - /* 
						*/ `x'[_N]/`c'[_N] + `mymean'
				mac shift
			}
			* drop if `c'==1
			count if `absorb'!=`absorb'[_n-1]
			local dfa = _result(1)-1
			regress `varlist' [`sweight'`exp']
			local dfb = _result(3)
			local dfe = _result(5)
			local sse = _result(4)
			local nobs = _result(1)
			local dfe = `dfe' - `dfa'
/*
			drop `x'
			predict `x'
			replace `dv' = (`dv'-`x') + `x'
*/
			* we could avoid this if only we knew dfe in advance
			hreg `varlist' [`weight'`exp'] , dof(`dfe') `grs'
			global S_E_sst = `sst'
			global S_E_nobs = `nobs'
			global S_E_mdf = `dfa' + `dfb'
			global S_E_sse = `sse'
			global S_E_r2 = 1 - `sse'/`sst'
			global S_E_depv "`dv'"
			global S_E_tdf = `nobs'-1-$S_E_mdf
			global S_E_abs = "`absorb'"
			global S_E_dfa `dfa' 	/* # of coefs absorbed */
			global S_E_grs "`grs'"
			global S_E_cmd "hareg"
		}
	}
	else {
		if ("$S_E_cmd" !="hareg") { error 301 }
		parse "`*'"
	}
	if (`level'<10 | `level'>99) { local level 95 }
	local dft = $S_E_nobs - 1
	local dfe = `dft' - $S_E_mdf
	local mse = $S_E_sse/`dfe'
	local r2 = $S_E_r2
	local ar2 = 1 - (1-`r2')*`dft'/`dfe'
	di
	di in gr "Regression with Huber standard errors" /*
	*/ _col(56) "Number of obs =" in ye %8.0f $S_E_nobs
	di in gr _col(56) "R-squared     =" in ye %8.4f `r2'
	di in gr _col(56) "Adj R-squared =" in ye %8.4f `ar2'
	di in gr _col(56) "Root MSE      =" in ye %8.0g sqrt(`mse')
	if ("$S_E_grs"=="") { di }
	_huber , level(`level') $S_E_grs
	local skip = 12-length("$S_E_abs")
	local dfa1 = $S_E_dfa + 1
	local skip2 = max(40-length("`dfa'"),0)
	di in smcl _skip(`skip') in gr "$S_E_abs {c |}   absorbed" /* 
		*/ _skip(`skip2') "(`dfa1' categories)"
end

program define OodMsg
	version 5.0
	#delimit ; 
	di in ye "hareg" in gr 
		" is an out-of-date command; " in ye "areg, robust" in gr 
		" is its replacement." _n ; 
	di in smcl in gr 
		"    Rather than typing" _col(41) "Type:" _n 
		"    {hline 32}    {hline 36}" ;
	di in ye "    . hareg" in gr " yvar xvars" in ye _col(41)
		"areg " in gr "yvar xvars" in ye ", robust" ;
	di in ye "    . hareg" in gr " yvar xvars" in ye ", group(" in gr 
		"gvar" in ye ")" _col(41)
		"areg" in gr " yvar xvars" in ye ", cluster(" in gr 
		"gvar" in ye ")" ;
	di in ye "    . hareg" in gr " yvar xxvars" in ye " [pw=" in gr "w"
			in ye "]" _col(41) 
		"areg" in gr " yvar xvars" in ye " [pw=" in gr "w" 
			in ye "]" ;
	di in gr "    {hline 32}    {hline 36}" ;
	di in gr _col(41) "Note:  " in ye "cluster()" 
		in gr " implies " in ye "robust" _n _col(49)
		"pweight" in gr "s imply " in ye "robust" _n ;

	di in gr "The only difference is that " in ye 
		"areg, robust" in gr " applies a degree-of-freedom" _n 
		"correction to the VCE that " in ye "hareg" in gr 
		" did not.  " in ye "areg, robust" in gr 
		" is better." _n(2) 
		"If you must use " in ye "hareg" in gr ", type" _n ;
 
	di in ye _col(8) ". version 4.0" _n 
		_col(8) ". hareg " in gr "..." in ye _n 
		_col(8) ". version 6.0" _n ;
	#delimit cr
	exit 199
end
exit
