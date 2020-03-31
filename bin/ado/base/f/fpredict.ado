*! version 3.1.6  14dec1998
program define fpredict
	version 6.0
	_isfit cons

	tempvar new t hh
	syntax newvarname(gen) [, Cooksd COVratio DFBeta(string) DFIts Hat /*
	*/ Leverage REsiduals RSTAndard RSTUdent STDF STDP STDR Welsch ]
	rename `varlist' `new'

	local type "`cooksd'`covrati'`dfits'`hat'`leverag'`residua'`rstanda'`rstuden'`stdf'`stdp'`stdr'`welsch'"

	if "`type'"=="leverage" { local type "hat" }

	local lbl "label var `new'"

	if "`type'"=="" { 
		if "`dfbeta'"!="" { 
			if "`e(wtype)'" != "" { 
				di in red "not possible with weighted fit"
				exit 398
			}
			_crcdfbt `dfbeta' double `t'
			`lbl' "DFbeta(`dfbeta')"
		}
		else {
			quietly _predict double `t'
			`lbl' "Fitted values"
		}
	}
	else if "`type'"=="dfits" { 
		quietly _predict double `hh', hat
		quietly _predict double `t', rstudent
		quietly replace `t'=`t'*sqrt(`hh'/(1-`hh'))
		`lbl' "Dfits"
	}
	else if "`type'"=="welsch" { 
		quietly _predict double `hh', hat
		quietly _predict double `t', rstudent
		quietly replace `t'=(`t'*sqrt(`hh'/(1-`hh')))* /*
			*/ sqrt((e(N)-1)/(1-`hh'))
		`lbl' "Welsch distance"
	}
	else if "`type'"=="covratio" {
		quietly _predict double `hh', hat
		quietly _predict double `t', resid
		quietly replace `t'=`t'/(e(rmse)*sqrt(1-`hh'))
		quietly replace `t'=((/*
		*/(e(N)-e(df_m)-`t'*`t'-1)/(e(N)-e(df_m)-2) /*
		*/)^(e(df_m)+1)) / (1-`hh')
		`lbl' "Covratio"
	}
	else { 
		quietly _predict double `t', `type'
		if "`type'"=="cooksd" { `lbl' "Cook's D" } 
		else if "`type'"=="hat" { `lbl' "Leverage" } 
		else if "`type'"=="residuals" { `lbl' "Residuals" }
		else if "`type'"=="rstandard" { `lbl' "Standardized residuals" }
		else if "`type'"=="rstudent" { `lbl' "Studentized residuals" }
		else if "`type'"=="stdf" { `lbl' "Std. err. of the forecast" }
		else if "`type'"=="stdp" { `lbl' "Std. err. of the prediction" }
		else if "`type'"=="stdr" { `lbl' "Std. err. of the residual" }
	}
	quietly replace `new' = `t' if e(sample)
	rename `new' `varlist'
end

program define _crcdfbt /* var type newvar */
	version 6.0
	/* weights checked by caller */
	local var `1'
	local type `2'
	local newvar `3'
	capture local beta=_b[`var']
	if _rc { 
		di in red "`var' not in model"
		exit 398
	}

	local lhs `e(depvar)'
	_evlist 
	local rhs "`s(varlist)'"
	sret clear
	tokenize `rhs'
	local i 1
	while "``i''"!="" & "`found'"=="" { 
		if "``i''"=="`var'" {
			local found "yes"
			local `i' " "
		}
		local i=`i'+1
	}
	local rhsx "`*'"
	tempvar HAT RSTU lest RES SRES RESULT
	quietly _predict double `HAT' if e(sample), hat
	quietly _predict double `RSTU' if e(sample), rstud
	estimate hold `lest'
	capture {
		reg `var' `rhsx' if `RSTU'!=.
		_predict double `RES' if `RSTU'!=., res
	}
	local rc=_rc
	estimate unhold `lest'
	if `rc' { error `rc' }
	quietly gen double `SRES'=sum(`RES'^2)
	quietly gen `type' `newvar'=`RSTU'*`RES'/sqrt((1-`HAT')*`SRES'[_N])
	label var `newvar' "DFbeta(`var')"
end
