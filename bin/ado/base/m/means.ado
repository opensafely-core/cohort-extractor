*! version 4.2.0 10oct2016
program define means, rclass byable(recall)
	version 6.0, missing
	syntax [varlist] [if] [in] [aweight fweight] /*
		*/ [, Level(cilevel) Add(real 0) Only]
	tokenize `varlist'
	local stop : word count `varlist'
	tempvar touse
	mark `touse' `if' `in'

	if "`only'" != "" & `add' == 0 {
		di in red "Nonzero add() option required with only option"
		exit 100
	}
	if `add' < 0 {
		di in red "add(`add') invalid; add() must be positive"
		exit 198 
	}

	local levopt "level(`level')"
	if "`weight'" != "" {
		local wt_exp = "[`weight'`exp']"
	}
	else 	local wt_exp

	local ci_opt if `touse' `wt_exp', `levopt'
	local foot1 0
	local foot2 0
	local foot3 0

	tempvar VAR VAR2
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	#delimit ;
	di _new in smcl in gr 
		_col(1) "    Variable {c |}" _col(19) "Type" 
		_col(36) "Obs"
_col(47) "Mean" _col(`=60-`cil'') `"[`=strsubdp("`level'")'% Conf. Interval]"';
	di in smcl in gr "{hline 13}{c +}{hline 63}" ;
	#delimit cr

	quietly {
		local i 1
		while `i' <= `stop' {

        		capture confirm string variable ``i''
        		if _rc == 0 {
				local foot3 1
			}
			else {
				ci ``i'' `ci_opt'
				return scalar level = `level'
				return scalar N = r(N)
				return scalar mean = r(mean)
				return scalar Var = r(N)*(r(se)^2)
				return scalar lb = r(lb)
				return scalar ub = r(ub)
	
				if `add' > 0 {
					if "`only'" == "" {
						gen `VAR' = ``i''+`add' if `touse'
						local aster "*"
						local foot1 1
					}
					else {
						count if ``i'' <= 0 
						if r(N) != 0 { 
	local aster "*"
	local foot1 1
	gen `VAR' = ``i'' + `add' if `touse'
						}
						else  gen `VAR'=``i'' if `touse'
					}
				}
				else 	gen `VAR' = ``i'' if `touse'
	
				ci `VAR' `ci_opt'
				return scalar level = `level'
				return scalar N = r(N)
				return scalar mean = r(mean)
				return scalar Var = r(N)*(r(se)^2)
				return scalar lb = r(lb)
				return scalar ub = r(ub)

				gen double `VAR2'=log(`VAR') if `touse'
				ci `VAR2' `ci_opt'
				return scalar N_pos = r(N)
				return scalar mean_g = exp(r(mean))
				return scalar Var_g = r(N)*(r(se)^2)
				return scalar lb_g = exp(r(lb))
				return scalar ub_g = exp(r(ub))
	
				replace `VAR2' = cond(`VAR'>0,1/`VAR',.) /*
							*/ if `touse'
				ci `VAR2' `ci_opt'
				return scalar mean_h = 1.0/r(mean)
				return scalar Var_h = r(N)*(r(se)^2)
				if `r(lb)' > 0 {
					return scalar lb_h = 1.0/r(ub)
					return scalar ub_h = 1.0/r(lb)
				}
				else {
					local foot2 1
					return scalar lb_h = .
					return scalar ub_h = .
				}

	
				local skip = 8 - length("``i''") 
	
				#delimit ;
	noisily di in smcl in gr %12s abbrev("``i''",12) " {c |}" 
		_col(16) "Arithmetic"
		_col(29) in ye %10.0fc `return(N)' _col(42) 
		%9.0g `return(mean)'
		_col(58) %9.0g `return(lb)' _col(69) %9.0g `return(ub)'
		" `aster'";
	noisily di in smcl in gr _col(14) "{c |}" _col(17) "Geometric"
		_col(29) in ye %10.0fc `return(N_pos)' _col(42) 
		%9.0g `return(mean_g)'
		_col(58) %9.0g `return(lb_g)' _col(69) 
		%9.0g `return(ub_g)'
		" `aster'";
	noisily di in smcl in gr _col(14) "{c |}" _col(18) "Harmonic",
		_col(29) in ye %10.0fc `return(N_pos)' _col(42) 
		%9.0g `return(mean_h)'
		_col(58) %9.0g `return(lb_h)' _col(69) 
		%9.0g `return(ub_h)'
		" `aster'";
#delimit cr
	if "`2'" != "" {
		noisily di in smcl in gr "{hline 13}{c +}{hline 63}"
	}
	else	noisily di in smcl in gr "{hline 77}"
	
				drop `VAR' `VAR2'
				local aster
			}
			local i = `i' + 1

			/* Double saves */
			global S_1 = "`return(N)'"
			global S_3 = "`return(mean)'"
			global S_2 = "`return(N_pos)'"
			global S_4 = "`return(mean_g)'"
			global S_5 = "`return(mean_h)'"
		}
	}

	if `foot3' == 1 {
		di "Note:  String variables in variable list ignored."
	}
	if `foot1' == 1 {
di "(*) `add' was added to the variables prior to calculating the results."
	}
	if `foot2' == 1 {
		#delimit ;
di "Missing values in confidence intervals for harmonic mean indicate "
_new "that confidence interval is undefined for corresponding variables."
_new "Consult Reference Manual for details.";
		#delimit cr
	}
end
