*! version 1.1.0  02may2017
*! (subroutine to regres_p, tobit_p, heckma_p)
program define regre_p2 
	version 6
	args       vtyp         /* variable type for prediction
		*/ varn		/* new variable name
		*/ touse        /* touse variable
		*/ offset       /* "noffset" or "" 
		*/ p 		/* Pr() option contents
		*/ e 		/* e()  option contents
		*/ ystar	/* ystar() option contents
		*/ rmse 	/* RMSE or sigma for equation 
		*/ newcons	/* "constant(varname)" or "" 
		*/ fxbadj	/* function callback to adjust x'b for 
				   endogenous variables; used by -ivtobit- 
		*/ indlist	/* matrix indices for which endogenous 
				   covariates to condition on
		*/ base  	/*     
		*/ target

	if (`"`p'"'!="") + (`"`e'"'!="") + (`"`ystar'"'!="") > 1 { 
		error 198
	}

	local 0 `"`p'`e'`ystar'"'
	gettoken lb 0    : 0, parse(",")
	gettoken comma 0 : 0, parse(",")
	gettoken ub 0    : 0, parse(",")

	if trim(`"`0'"') != "" | trim(`"`comma'"')!="," { 
		error 198
	}

	tempvar L U
	qui gen double `L' = .
	qui gen double `U' = .
	
	Fix `lb'
	local lb `s(res)'
	local lb_o `s(res_o)'
	local lbc `s(class)'
	qui replace `L' = `lb_o'

	Fix `ub'
	local ub `s(res)'
	local ub_o `s(res_o)'
	local ubc `s(class)'
	qui replace `U' = `ub_o'

	capture assert `L' <= `U' if `touse' & !missing(`L') & !missing(`U')
	if _rc {
		if `"`p'"' != "" { local pred "{bf:pr({it:a},{it:b})}" }
		if `"`e'"' != "" { local pred "{bf:e({it:a},{it:b})}" }
		if `"`ystar'"' != "" { local pred "{bf:ystar({it:a},{it:b})}" }
		version 14: di "{err}option `pred' incorrectly " ///
			"specified; {it:b} must be >= {it:a}"
		exit 198
	}
		
	sret clear

	/*
		class contains "missing" or <nothing>.
		The title we want to set is 

				ub class
		lb class	"missing"	<nothing>
		-----------------------------------------
		"missing"	""		"y<ub"
		<nothing>	"y>lb"		"lb<y<ub"
	*/

	DepName depname
	if "`lbc'"=="missing" & "`ubc'"=="" {
		local ttl "`depname'<`ub_o'"
	}
	else if "`lbc'"=="" & "`ubc'"=="missing" {
		local ttl "`depname'>`lb_o'"
	}
	else if "`lbc'"=="" & "`ubc'"=="" {
		local ttl "`lb_o'<`depname'<`ub_o'"
	}

	tempvar yhat new
	// go through fixed values
	ParseUbase, u(`target') target
	local nvt = `r(nvars)'
	forvalues i = 1/`nvt' {
		local tdv`i' `r(var`i')'
		tempvar ot`i'
		local stotype: type `tdv`i''
		qui gen `stotype' `ot`i'' = `tdv`i'' if `touse'
	}
	forvalues i = 1/`nvt' {
		tempvar tidv`i'
		capture qui gen double `tidv`i'' = `r(expr`i')' if `touse'
		if _rc {
			di as error "{bf:target()} invalid; "
			qui gen double `tidv`i'' = `r(expr`i')' if `touse'
		}
		qui replace `tdv`i'' = `tidv`i'' if `touse'
	}
	qui _predict double `yhat' if `touse', xb `offset' `newcons'
	forvalues i = 1/`nvt' {
		qui replace `tdv`i'' = `ot`i'' if `touse'
	}
	if "`base'" != "" {
		ParseUbase, u(`base') base
		local nvu = `r(nvars)'
		forvalues i = 1/`nvu' {
			local udv`i' `r(var`i')'
			tempvar ou`i'
			local stotype: type `udv`i''
			qui gen `stotype' `ou`i'' = `udv`i'' ///
				 if `touse'
		}
	}
	local nb break
	if "`base'" != "" {
		local nb nobreak
	}
capture noi `nb' {
	if "`base'" != "" {
		forvalues i = 1/`nvu' {
			tempvar ub`i'
			capture qui gen double `ub`i'' ///
				= `r(expr`i')' if `touse'
			if _rc {
				version 15: di as error "{bf:base()} invalid;"
				qui gen double `ub`i'' ///
					= `r(expr`i')' if `touse'
			}
			qui replace `udv`i'' = `ub`i'' ///
				if `touse'
		}
	}	
	if "`fxbadj'" != "" {
		/* -ivtobit-: adjust x'b by endogenous model residuals	*/
		qui `fxbadj' `yhat', touse(`touse') noscale index(`indlist')
	}

	if `"`p'"' != "" {
		CalcP `new' `yhat' "`rmse'" `touse' `L' `U' "`ttl'"
	}
	else if `"`e'"' != "" {
		CalcE `new' `yhat' "`rmse'" `touse' `L' `U' "`ttl'"
	}
	else 	CalcY `new' `yhat' "`rmse'" `touse' `L' `U' "`ttl'"

	local ttl : var label `new'
	gen `vtyp' `varn' = `new' if `touse'
	label var `varn' `"`ttl'"'
}
	local rc = _rc
nobreak {
	if "`base'" != "" {
		forvalues i = 1/`nvu' {
			qui replace `udv`i'' = `ou`i'' if `touse'
		}
	}
}
	if `rc' {
		exit `rc'
	
	}	
end

program define CalcP
	args P yhat s touse lb ub ttl
	quietly {
		gen double `P' = 1 if `touse' & `lb'==. & `ub'==.
		replace `P' = normprob(-(`lb'-`yhat')/`s') /*
			*/ if `touse' & `lb'!=. & `ub'==.
		replace `P' = normprob((`ub'-`yhat')/`s') /*
			*/ if `touse' & `lb'==. & `ub'!=. 
		replace `P' = normal((`ub'-`yhat')/`s') - /*
			*/ normal((`lb'-`yhat')/`s') /*
			*/ if `touse' & `lb'!=. & `ub'!=. 
	}
	DepName depname
	if "`ttl'"=="" {
		label var `P' `"Pr(`depname')"'
	}
	else 	label var `P' `"Pr(`ttl')"'
end

program define CalcE
	args E yhat s touse lb ub ttl
	local L "((`lb'-`yhat')/`s')"
	local U "((`ub'-`yhat')/`s')"
	quietly {
		gen double `E' = `yhat' if `touse' & `lb'==. & `ub'==.
		replace `E' = `yhat' + `s'*normd(`L')/normprob(-`L') /*
			*/ if `touse' & `lb'!=. & `ub'==.

		replace `E' = `yhat' - `s'*normd(`U')/normprob(`U') /*
			*/ if `touse' & `lb'==. & `ub'!=.

		replace `E' = `yhat' - /*
			*/ `s'*(normd(`U')-normd(`L')) / /*
			*/		(normprob(`U')-normprob(`L')) /*
			*/ if `touse' & `lb'!=. & `ub'!=.
	}
	DepName depname
	if "`ttl'"=="" {
		label var `E' `"E(`depname')"'
	}
	else	label var `E' `"E(`depname'|`ttl')"'
end

program define CalcY
	args Y yhat s touse lb ub ttl

	tempvar E p p2
	CalcE `E'  `yhat' `s' `touse' `lb' `ub'  ""
	CalcP `p'  `yhat' `s' `touse' `lb' `ub'  ""
	CalcP `p2' `yhat' `s' `touse'   .  `lb'  ""

	quietly { 
		gen double `Y' = `E' if `touse' & `lb'==. & `ub'==. 
		replace `Y' = `p'*`E' + (1-`p')*`lb' /*
			*/ if `touse' & `lb'!=. & `ub'==.
		replace `Y' = `p'*`E' + (1-`p')*`ub' /*
			*/ if `touse' & `lb'==. & `ub'!=.
		replace `Y' = `p'*`E' + `p2'*`lb' + (1-`p'-`p2')*`ub' /*
			*/ if `touse' & `lb'!=. & `ub'!=. 
	}
	DepName depname
	if "`ttl'"=="" {
		label var `Y' `"E(`depname')"'
	}
	else	label var `Y' `"E(`depname'*|`ttl')"'
end
	
program define Fix, sclass
	sret clear
	capture confirm numeric variable `0'
	if _rc {
		capture confirm number `0'
		if _rc==0 { 
			sret local res `0'
			sret local res_o `0'
			exit
		}
		else {
			capture local expr = `0'
			if _rc==0 {
				capture confirm number `expr'
				if _rc==0 {
					sret local res `expr'
					sret local res_o `0'
					exit
				}
			}
		}
	}
	
	if trim(`"`0'"')=="." {
		sret local res "."
		sret local res_o "."
		sret local class missing
		exit
	}
	syntax varname
	sret local res `varlist'
	sret local res_o `varlist'
end

program define DepName
	args name          /* name is lmacname to store the depvar name */

	local depname `e(depvar)'
	gettoken depname : depname
	if "`e(cmd)'" == "intreg" { local depname "y" }
	if "`e(cmd)'" == "svyintreg" { local depname "y" }

	c_local `name' `depname'
end


program ParseUbase, rclass
	version 15
	syntax, [u(string) target base] 
	if "`u'" == "" {
		return local nvars = 0
		exit
	} 
	local ou `u'
	local i = 1
	while "`u'" != "" {
		gettoken var u: u, bind parse("=")
		capture confirm variable `var'
		if _rc {
			di as error "{bf:`base'`target'()} invalid; "
			confirm variable `var'
			exit 198
		}
		return local var`i' `var'
		gettoken eq u: u, bind parse("=")
		capture assert "`eq'" == "=" 
		if _rc {
			di as error "{bf:`base'`target'()} invalid"
			exit 198
		}
		gettoken expr u: u, bind parse(" ")
		local ok 0
		capture confirm number `expr'
		if !_rc {
			local ok 1
		}
		capture confirm variable `expr'
		if !_rc {
			local ok 1
		}
		if ~`ok' {
			local lu = ustrltrim(ustrrtrim(`"`expr'"'))
			local ok = usubstr(`"`lu'"',1,1)=="(" & ///
				   usubstr(`"`lu'"',-1,1)==")" 
		}
		if ~`ok' {
			di as error "{bf:`base'`target'()} invalid"
			exit 198
		}					
		return local expr`i' `expr'
		local i = `i' + 1		
	}
	return local nvars = `i'-1	
end



