*! version 1.3.10  22feb2016
program define _varfcast
	version 8.0
	syntax ,  [STep(numlist max=1 integer >0)		/*
		*/ Dynamic(string) 				/*
		*/ noSE 					/*
		*/ BS						/*
		*/ BSP 						/*
		*/ Reps(numlist >0 integer max=1)		/*
		*/ BSCentile					/*
		*/ noDOts					/*
		*/ Level(cilevel)	  			/*
		*/ ESTimates(string)				/*
		*/ CLear					/*
		*/ SAving(string) ]

/* To deal with timeseries operators in depvar names
   there are three parallel lists
	e(endog) contains names (possibly with ts ops) that
		were specified by user of var
		this list is a valid varlist on lhs but
		not on rhs
	e(eqnames) contains names with "." after any
		ts op replaced by "_"
		these names are valid for creating names that 
		can be used on lhs or rhs.  However, variables
		with these names do not exist.  But this list
		does contain the list of eq names.
	endog_ts contains names of temporary variables generated
		from e(endog)  The variables in tmpvarlist are
		used in creating the dynamic forecasts.  At the
		end the variables in tmpvarlist are renamed and
		labeled.
   note that matrix `b_ts' is created by from e(b) by replacing all 
   	endogenous variables by tempvar name via 
		op_colnm `b_ts' orig tempname
	This replacement method accounts for all timeseries operators 
	on lhs and rhs.
*/	

	if "`bscentile'" != "" & "`bs'`bsp'" == "" {
		di as err "{cmd:bscentile} cannot be specified "	/*
			*/ "without either {cmd:bs} or {cmd:bsp}"
		exit 198
	}	

	if "`saving'" != "" & "`bs'`bsp'" == "" {
		di as err "{cmd:saving()} cannot be specified "	/*
			*/ "without either {cmd:bs} or {cmd:bsp}"
		exit 198
	}	


	if "`dots'" != "" & "`bs'`bsp'" == "" {
		di as err "{cmd:nodots} must be specified with "	/*
			*/ "either {cmd:bs} or {cmd:bsp}"
		exit 198
	}	


	if "`reps'" != "" & "`bs'`bsp'" == "" {
		di as err "{cmd:reps()} must be specified with "	/*
			*/ "either {cmd:bs} or {cmd:bsp}"
		exit 198
	}	

	if "`reps'" == "" {
		local reps 200
	}	


	local steps `step'

	local fbegin `dynamic'
	if "`steps'"== "" {
		local steps 1
	}	

	if `reps' <= 0 {
		di as err "reps() must specify a strictly positive " /*
			*/ "integer"
		exit 198
	}	
	if "`fbegin'" != "" {
		local fbdate = `fbegin'
		capture confirm integer number `fbdate'
		if _rc > 0 {
			di as err "fbegin() must specify an integer"
			exit 198
		}	
	}	
	
	if `steps' <=0 {
		di as err "steps() must specify a strictly positive "/*
			*/"integer"
		exit 198
	}	
	if "`bs'`bsp'" != "" {
		if "`bs'" != "" & "`bsp'" != "" {
			di as err "specify {cmd:bs} or {cmd:bsp}, not both"
			exit 198
		}	
	}	

	if `"`saving'"' != "" {
		gettoken bsfile replace : saving , parse(",")
		local tcnt : word count `bsfile'
		if `tcnt' != 1 {
			di as err "saving(`saving') not valid"
			exit 198
		}	
		local replace : subinstr local replace "," ""
		local replace : subinstr local replace " " "", all
		local tcnt : word count `replace'
		if `tcnt' == 1 {
			if "`replace'" != "replace"  {
				di as err "saving(`saving') not valid"
				exit 198
			}
		}	
		else {
			if `tcnt' != 0  {
				di as err "saving(`saving') not valid"
				exit 198
			}	
		}
	}	
	else {
		tempfile bsfile 
	}	


	tempname pest
	tempvar esamp
	qui _estimates hold `pest', copy restore nullok varname(`esamp')

	if "`estimates'" == "" {
		local estimates .
	}

	capture est restore `estimates'
	if _rc > 0 {
		di as err "cannot restore estimates(`estimates')"
		exit 498
	}	

	_cknotsvaroi varfcast compute

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
	di as error "{help varfcast##|_new:varfcast} only works " 	/*
		*/ " with estimates from {help var##|_new:var} and "	/*
			*/ "{help svar##|_new:svar}"
		exit 198
	}

	if "`e(cmd)'" == "svar" {
		local svar _var
	}

/* if e(bigf)=="nobigf" then nose is implicitly specified. if nose
   is not specified, set it with a warning message */
   	
	if "`e(bigf`svar')'" != "" & "`se'" == "" {
		di as txt "nose implicitly specified, nobigf on the " /*
			*/ "estimated VAR implies nose " 
		local se "nose"
	}	
   

	if "`clear'" != "" {
		local _varfcastnames : char _dta[_varfcastnames]
		foreach v of local _varfcastnames {
			capture drop `v'
		}
		char define _dta[_varfcastnames]
	}

	tempname bf0
	capture mat `bf0' = e(bf`svar')
	if _rc > 0 & "`se'" == "" {
		di as txt "could not assign e(bf), nose implicitly "	/*
			*/ "specified"
		local se nose	
	}	

	if matmissing(`bf0') & "`se'" != "nose" {
		di as txt "e(bf) contains missing values, nose "	/*
			*/ "implicitly specified"
		local se nose	
	}	
	
	
	/* check that fbegin is at least maxlags+1 into the sample */
	if "`fbegin'" != "" {
		if `fbegin' < e(tmin) {
			di as err "dynamic() cannot specify a time prior to "/*
				*/ "the beginning of the estimation sample"
			exit 198
		}
	}	
	capture tsset, noquery
	local t "`r(timevar)'"

	if "`r(panelvar)'" != "" {
		di as error "this command does not work with panel data"
		exit 198 
	}	

	local eqlist "`e(eqnames`svar')'"
	local endog "`e(endog`svar')'"
	local exog  "`e(exog`svar')'"
	local lags  "`e(lags`svar')'"
	tempvar obsvar

	local neqs : word count `eqlist'

/* make endog_ts and b_ts that are safe with ts op on rhs */
	tempname b_ts
	mat `b_ts' = e(b`svar')
	local i 1

	qui count if e(sample) ==1
	if r(N) == 0 {
		di as err "e(sample) is never equal to 1"
		exit 498
	}	

	foreach v of local endog {
		local vt : subinstr local v "." "_"
		tempvar tv`i'
		qui gen double `tv`i'' = `v' if e(sample)
		op_colnm `b_ts' `v' `tv`i''
		local endog_ts "`endog_ts' `tv`i'' "
		local i = `i' + 1
	}
	
	qui gen `obsvar'=_n if e(sample)==1
	qui sum `obsvar'
	local lastob=r(max)
	local leastob=r(min)

	if "`fbegin'" != "" {
		tempvar gbob gbob2 
		tempname max1 max2
		gen `gbob'=cond(`t'==`fbegin'-1,_n,0)
		gen `gbob2'=sum(`gbob')
		qui sum `gbob'
		local max1=r(max)
		qui sum `gbob2'
		local max2=r(max)
					/* note since `t' is tsset, this 
					 can never happen, but just in 
					 case  refuse to it */
		if `max1' != `max2' {
			di as error "`fbegin' is not a valid date for this data"
			exit 198
		}	

		
		if `max1' <= `lastob' {
			if "`se'"  == "" {
				di as txt "since `fbegin' is in the "/*
					*/ "estimation sample, nose is " /*
					*/ "implicitly specified"
			}		
			local se "nose"	
		}

		if `max1' < `leastob' + e(mlag`svar')-1 {
			di as err "forecast must begin " e(mlag`svar') /*
				*/ " or more periods into estimation sample"
				exit 198
		}
		if `max1' > `lastob'+1  {
			di as err "forecast must begin no later than one" /*
				*/ " period after estimation period."
				exit 198
		}

		local lastob = `max1'
	}
		
/* make call to tsfill or tsappend */	

	local obs2add=-1*(_N-(`lastob'+`steps'))

	if `obs2add' <= 0 {
		tsfill
	}
	else {
		tsappend , add(`obs2add') 
	}
	qui replace `esamp' = 0 if `esamp' >= .
	if "`estimates'" != "." {
		qui replace _est_`estimates' = 0 	/*
			*/ if _est_`estimates' >= .
	}		

	if "`exog'" != "" {

		if "`se'" == "" {
			local se "nose"
			di as txt "asymptotic standard error not available " /*
				*/ "with exogenous variables"
		}		
	}

	fcast2 `endog_ts' , steps(`steps') lastob(`lastob') b_ts(`b_ts')


/* rename forecasted variables  */
	if "`fbegin'" == "" {
		local fbegin = `lastob' + 1
	}	
	
	local i 1
	foreach v of local eqlist {
		local vorig : word `i' of `endog'
		local dyn  "dyn(`fbegin')"
		local lbl "forecasted `vorig', `dyn'"
		qui rename `tv`i'' `v'_f
		label variable `v'_f `"`lbl'"'
		local i = `i' + 1
	}

/* now compute and insert standard errors */
	if "`bs'" != "" | "`bsp'" != "" {



/* check that there is sufficient memory for bs data */

/* size of bs dataset */

		local bsobs = (`steps')*`reps'

/* bwidth includes width which 3 for int step, 15*8 for 15 doubles
 * 15*3 for 3 15 character strings, and 4 for pointer overhead for each
 * observation
 */
		local bswidth = (8*(2+`neqs')+4)
		
		local bssize = `bsobs'*`bswidth'

/* only do check if !Small Stata */

		if "$S_FLAVOR" != "Small" {
qui memory

local free_m = r(M_data)-_N*(r(size_ptr)+r(width)+5*8)
local talloc = .01*(ceil(r(M_total)/(1024^2)*100))
local moreal = .01*(ceil((`bssize'-`free_m')/(1024^2)*100))

if `bssize' >= `free_m' {

	if `talloc' == 1 {
		local mys1 
	} 
	else {
		local mys1  s
	}

	if `moreal' == 1 {
		local mys2 
	} 
	else {
		local mys2  s
	}

	di as err "insufficient memory allocated for "	/*
		*/ "bootstrapped dataset"
	di as err "{p 0 4}there are `free_m' bytes free, "/*
		*/ "but the bootstrapped dataset will "	/*
		*/ "require `bssize' bytes{p_end}"
	di as err "{p 0 4}At present you have about "	///
		"`talloc' megabyte`mys1' "   		///
		"allocated and you need approximately "	///
		"`moreal' additional megabytes{p_end}"
	
	exit 901
}	
		}

		preserve
		tempname fsamp
		qui gen byte `fsamp' =e(sample)
		qui replace `fsamp' =1 if _n>=`lastob' /*
			*/ &  _n <= `lastob'+`steps'
		noi _varbsf using "`bsfile'", reps(`reps') step(`steps') /*
			*/ lastob(`lastob') `bsp' `replace' /*
			*/ fsamp(`fsamp') `dots'
		qui drop _all
		qui use "`bsfile'"
		if "`bscentile'" != "" {
			local lcent=100*(1-.01*`level')/2
			local ucent=`level' + `lcent'

			forvalues i = 1(1)`steps' {
				foreach v of local eqlist {
					tempname `v'L`i' `v'U`i' /*
						*/ `v'STD`i'
					qui centile `v'_f if /* 
						*/ step == `i', cent(`lcent')
					scalar ``v'L`i''=r(c_1)		
					qui centile `v'_f if /*
						*/ step == `i', cent(`ucent')
					scalar ``v'U`i''=r(c_1)	

					qui sum `v'_f if step == `i'
					scalar ``v'STD`i'' = r(sd)

				}
			}
		}
		else {
			local alpha = 1-.5*(100-`level')/100
			local std_alpha = invnorm(`alpha')
			forvalues i = 1(1)`steps' {
				foreach v of local eqlist {
					tempname `v'L`i' `v'U`i' /*
						*/ `v'STD`i'

					qui sum `v'_f if step == `i'
					scalar ``v'STD`i'' = r(sd)

					scalar ``v'L`i''= -1*`std_alpha'* /*
						*/ ``v'STD`i''
					scalar ``v'U`i''= `std_alpha'* /*
						*/ ``v'STD`i''

				}
			}
		}
		
		restore
		forvalues i = 1(1)`steps' {
			foreach v of local eqlist {
				if `i' == 1 {
					qui gen double `v'_f_L = .  
					qui gen double `v'_f_U = .
					qui gen double `v'_f_se = .
				}	

				if "`bscentile'" != "" {
					qui replace `v'_f_L = ``v'L`i'' /*
						*/ if _n==`lastob'+`i'
					qui replace `v'_f_U = ``v'U`i'' /*
						*/ if _n==`lastob'+`i'
					qui replace `v'_f_se = ``v'STD`i'' /*
						*/ if _n==`lastob'+`i'
				}
				else {
					qui replace `v'_f_L = `v'_f + 	/*
						*/ ``v'L`i''		/*
						*/ if _n==`lastob'+`i'
					qui replace `v'_f_U = `v'_f  + 	/*
						*/ ``v'U`i'' 		/*
						*/ if _n==`lastob'+`i'
					qui replace `v'_f_se = ``v'STD`i'' /*
						*/ if _n==`lastob'+`i'

				}
			}
		}		
		

		local i 1
		foreach v of local eqlist {

label variable `v'_f_L `"`=strsubdp("`level'")'% lower bound:`v'_f"'
label variable `v'_f_U `"`=strsubdp("`level'")'% upper bound:`v'_f"'
			label variable `v'_f_se `"s.e. for `v'_f"'
		
			local i = `i' + 1
		}
	
	}
	else {
		if "`se'" == "" {

/* make endog_ts and b_ts that are safe with ts op on rhs from e(bf) */
		tempname bf_ts
		mat `bf_ts' = e(bf`svar')
		local i 1

			foreach v of local endog {
				local vt : subinstr local v "." "_"
				tempvar tv`i'
				qui gen double `tv`i'' = `v' if e(sample)
				op_colnm `bf_ts' `v' `tv`i''
				local endogbf_ts "`endogbf_ts' `tv`i'' "
				local i = `i' + 1
			}
				
			getSEb , endog_ts(`endogbf_ts') 		///
				 lastob(`lastob') steps(`steps') 	///
				 level(`level') b_ts(`bf_ts')

			foreach v of local eqlist {
				label variable `v'_f_L 		/*
				*/ `"`=strsubdp("`level'")'% lower bound:`v'_f"'
				label variable `v'_f_U 		/*
				*/ `"`=strsubdp("`level'")'% upper bound:`v'_f"'
				label variable `v'_f_se `"s.e. for `v'_f"'
			}
		}
	}	

	foreach v of local eqlist {
		local created `created' `v'_f 
	}

	if "`bs'`bsp'" != "" {
		foreach v of local eqlist {
			local created `created' `v'_f_L `v'_f_U `v'_f_se 
		}
	}
	else {
		if "`se'" == "" {
			foreach v of local eqlist {
local created `created' `v'_f_L `v'_f_U `v'_f_se 
			}
		}
	}
	
	local _varfcastnames : char _dta[_varfcastnames]
	if "`_varfcastnames'" != "" {
		local _varfcastprior : char _dta[_varfcastprior]
		local _varfcastprior : list _varfcastprior | _varfcastnames
		char define _dta[_varfcastprior] "`_varfcastprior'"
	}	
	char define _dta[_varfcastnames] "`created'"
	_estimates unhold `pest'

end	

program define fcast2
	version 8.0
	syntax varlist , steps(integer) lastob(integer) b_ts(string)

	/* there are three parallel varlists
		e(endog) contains names (possibly with ts ops) that
			were specified by user of var
		e(eqnames) contains names with "." after any
			ts op replaced by "_"
		varlist contains names of temporary variables generated
			from e(endog)
	   note that matrix `b_ts', passed in via t_ts(string) has had any 
	   	endogenous ts op variable replaced by tempvar name 
		via op_colnm `b_ts' orig tempname
	*/	

	local lastobp = `lastob' + `steps'

	if "`e(cmd)'" == "svar" {
		local svar _var
	}	

	local eqlist "`e(eqnames`svar')'"
	local endog "`e(endog`svar')'"
	local exog  "`e(exog`svar')'"
	local lags  "`e(lags`svar')'"

	qui tsset, noquery
	local ta "`r(timevar)'"
	local tsfmt "`r(tsfmt)'"

	if "`ta'" == "" {
		di as error "you must tsset your data before using varfcast"
		exit 198
	}

	tempvar obsvar temp ones 
	
	local newobs=-1*(_N-(`lastob'+`steps'))
	local newobs=max(0,`newobs')+_N

	if _N < `newobs' { 
		local oldobs=_N
		set obs `newobs'	
		local addobs "yes"
	}
	else {
		local addobs "no"
	}

	if "`exog'" != "" {
		tempvar xsamp
		qui mark `xsamp' 
		qui markout `xsamp' `exog'
		qui sum `xsamp' in `lastob'/`lastobp' 
		if r(mean) < 1 {
			di as error "exogenous variables cannot be " /*
				*/ "missing in the forecast period"
			exit 198
		}	
	}

	tempname b_pred
	
	mat `b_pred'=`b_ts'

	local vars_orig : word count `varlist'
	local vars_for  : word count `eqlist'
	
	if `vars_orig' != `vars_for' {
		di as error "number of variables to forecast differs from " /*
			*/ "number of forecasted variables"
		exit 9000
	}


	if "`e(nocons`svar')'" != "" {
		local exog2 "`exog' "
	}
	else {
		local exog2 "`exog' _cons "
	}

	local predob=`lastob'+1


	forvalues i =1(1)`steps' {
		forvalues j = 1/`vars_for' {
			local varf : word `j' of `varlist'
			local eqn  : word `j' of `eqlist'
			mat score `varf'= `b_pred' in `predob', /*
				*/ eq(`eqn') replace
		}	
		local predob = `predob'+1	
	}

	foreach varf of local varlist {
		qui replace `varf'=. if _n<`lastob' | _n>=`predob' 
	}
end


program define getSEb
	version 8.0
	syntax , endog_ts(varlist) lastob(integer) steps(integer) /*
		*/ level(cilevel) b_ts(string)

	/* endog_ts contains endog_ts-list of temporary variables
		that contain dynamic predictions.

	   endog contains list endogenous variables specified in var,
	   	list may contain time series operators.
	   eqlist contains list of equation names, i.e. endog with "."
	  	replaced by "_"
	   Also note that b_ts is e(b) with original endogenous variables
	   	replaced by temporary names.
	  
	*/	

	if "`e(cmd)'" == "svar" {
		local svar _var
	}	

	local eqlist "`e(eqnames`svar')'"
	local endog "`e(endog`svar')'"
	
	foreach var of local eqlist {
		qui gen double `var'_f_L=.
		qui gen double `var'_f_U=.
		qui gen double `var'_f_se=.
	}
	
	tempname B thetai G J Bi A Bt Btt theta
	
	/* make B which is (Kp+1) x (Kp+1) */
	
	if "`e(nocons`svar')'" == "" {
		local cons cons
	}	

	local eqs = e(neqs)
	local mlag = e(mlag`svar')

	if "`cons'" != "" {
		local Bdim = `eqs'*`mlag'+1
	}
	else {
		local Bdim = `eqs'*`mlag'
	}
	local kpm1 = `eqs'*(`mlag'-1)

	_mka2  `endog_ts' , lags(`mlag') aname(`A') `cons' b_ts(`b_ts')

	if `mlag' > 1 {
		local lm1 = `mlag' - 1 
		forvalues i = 0(1)`mlag' {
			if `i' == 0 {
				if "`cons'" != "" {
					matrix `B' = 1 \ `A'cons \ J(`kpm1',1,0)
				}	
			}
			else {
				capture matrix drop `Btt'
				capture matrix drop `Bt'

				forvalues j = 1(1)`lm1' {
					if `j' == `i' {
						matrix `Btt' = nullmat(`Btt') \ I(`eqs')
					}
					else {
						matrix `Btt' = /* 
					     	*/nullmat(`Btt')\J(`eqs',`eqs',0)

					}
				}
				if "`cons'" != "" {
					matrix `Bt' = J(1,`eqs',0) \ `A'`i' \ `Btt' 
				}
				else {
					matrix `Bt' = `A'`i' \ `Btt' 
				}
				matrix `B' =( nullmat(`B') , `Bt' )
			}
		}
	
		if "`cons'" != "" {
			matrix `J' = J(`eqs',1,0) , I(`eqs') , J(`eqs',`kpm1', 0 ) 
		}
		else {
			matrix `J' =  I(`eqs') , J(`eqs',`kpm1', 0 ) 
		}

	}
	else {
		if `mlag' == 1 {
			if "`cons'" != "" {
				matrix `B' = 1 \ `A'cons 
					matrix `Bt' = J(1,`eqs',0) \ `A'1
				matrix `B' =( nullmat(`B') , `Bt' )
			}	
			else {
				matrix `B' = `A'1
			}
			if "`cons'" != "" {
				matrix `J' = J(`eqs',1,0) , I(`eqs') 
			}
			else {
				matrix `J' =  I(`eqs') 
			}
		}

	}
	
	local hm1 = `steps'-1
	
	matrix `theta'0 = I(`eqs')
	matrix `Bi' = `B'
	
	forvalues i = 1(1)`hm1' {
		matrix `theta'`i' = `J'*`Bi'*`J''
		matrix `Bi' = `Bi'*`Bi'
	}


	matrix `G'=e(G`svar')
	local T = e(T`svar') 
	
	tempname BTP BP sig_u O temp1 temp2 Ginv sigy sigyhat norm  /*
		*/ stderr stderrm Cns V2 sigyh sigyhath
	
	matrix `sig_u' = e(Sigma)
	local eqns3 : colnames `sig_u'
	local vns3  : colnames `G'

	foreach vn of local vns3 {
		foreach eqn of local eqns3 {
			local eqn : subinstr local eqn "." "_", all
			local nstripe "`nstripe' `eqn':`vn' "
		}
	}
	matrix `Ginv' = syminv(`G')

	mat `V2' = (1/`T')*(`Ginv'#`sig_u')
	mat colnames `V2' = `nstripe'
	mat rownames `V2' = `nstripe'

	if "`e(constraints`svar')'" != "" {

		_getvarcns
		local cnslist $T_VARcnslist 
		macro drop T_VARcnslist
		macro drop T_VARcnslist2

		_getcns  , v(`V2') cnslist(`cnslist') cnsmat(`Cns')
		capture constraint drop `cnslist'

		local c_cns = colsof(`Cns')
		local c_cns = `c_cns' - 1

		tempname v3 R vce1 IAR

		mat `vce1' = `V2'
		mat `R' = `Cns'[1...,1..`c_cns']
	
		matrix `v3' = syminv(`R'*`vce1'*`R'')
		local a_size = rowsof(`v3')

		local j = 1
		while `j' <= `a_size' {
			if `v3'[`j',`j'] == 0 { 
				error 412 
			} 
			local ++j 
		}

		matrix `v3' = `vce1'*`R''*`v3'
		matrix `IAR' = I(colsof(`vce1')) - `v3'*`R'
		matrix `V2' = `IAR' * `vce1' * `IAR''

	}

	matrix `BTP'0=I(`Bdim')
	matrix `BP'0  =I(`Bdim')

	forvalues i = 1(1)`hm1' {
		local im1 = `i' -1
		matrix `BTP'`i'= `BTP'`im1'*(`B')'
		matrix `BP'`i'= `BP'`im1'*(`B')
	}

	local predob=`lastob'+1

	local level = `level'/100
	scalar `norm' = abs(invnorm( (1-`level')/2))

/* begin new */

	tempname Qt Zt V OMh tempa tempb tempc work 
	tempvar csamp csamp2
						/* csamp is t for sample 
						   obs, note csamp constrains
						   . where there are gaps
						*/
						   
	qui gen `csamp' = e(sample)
	qui gen byte `csamp2' = e(sample)
	qui replace `csamp' = sum(`csamp')
	qui replace `csamp' = . if !e(sample)
	qui sum `csamp'

	capture assert r(N) == `T' 
	if _rc > 0 {
		di as err "standard error sample does not agree with "/*
			*/ "estimation sample"
		di as err "(observation number incorrect)"	
		exit 498
	}	
	capture assert r(max) == `T' 
	if _rc > 0 {
		di as err "standard error sample does not agree with "/*
			*/ "estimation sample"
		di as err "(`T' incorrect)"	
		exit 498
	}	


	local vcols = colsof(e(bf`svar'))

	if "`cons'" != "" {
		local cpart "1,"
		local cons_in 1
	}	
	else {
		local cons_in 0
	}

	local deps "`e(depvar`svar')'"
	local lags `e(lags`svar')'


	forvalue lag = 1/`mlag' {
		foreach dvar of local deps {
			local tslist " `tslist' L`lag'.`dvar' "
		}
	}

	local olist `tslist'
	tsrevar `tslist'
	local tslist `r(varlist)'

	local NT = _N

	forvalues h=1(1)`steps' {
		mat `OMh'   = J(`eqs',`eqs', 0)
		mat `OMh'[1,2] = 1
		mat `OMh'[1,2] = 0
		mat `sigyh' = J(`eqs',`eqs', 0)
		local sm1   = `h' -1
		
		forvalues j4 = 0/`sm1' {
			matrix `sigyh' = `sigyh' + 	/*
				*/ `theta'`j4'*`sig_u'*(`theta'`j4')'	
		}


		_varfstd  `tslist', qt(`Qt') zt(`Zt') touse(`csamp2')	///
			btp(`BTP') theta(`theta') omh(`OMh')		///
			v2(`V2')  step(`h') constant(`cons_in')		///
			eqs(`eqs') vcols(`vcols') tempa(`tempa')	///
			tempb(`tempb') tempc(`tempc') work(`work')

/* See Note 1 below */	

		mat `OMh' = (1/`T')*`OMh'
		mat `sigyhath' = `sigyh' + `OMh'

		local i 1
		foreach var of local eqlist {
		 	scalar `stderr' = sqrt(`sigyhath'[`i',`i'])	
			
			qui replace `var'_f_L=`var'_f -`norm'*`stderr' /*
				*/ in `predob'
			qui replace `var'_f_U=`var'_f +`norm'*`stderr' /*
				*/ in `predob'
			qui replace `var'_f_se=`stderr' in `predob'
			local i = `i' + 1

		}
		local predob = `predob'+1	
	}


end
program define _getcns, eclass

	syntax , v(name) cnslist(numlist) cnsmat(name)

	tempname b v2 pest
	tempvar samp
	
	mat `v2' = `v'
	mat `b' = `v'[1,1...]

	qui _estimates hold `pest', nullok copy restore varname(`samp')

	eret post `b' `v2'
	
	mat makeCns `cnslist'

	mat `cnsmat' = get(Cns)

	_est unhold `pest'

	
end

exit

Note 1:

The ado code below serves as documentation for the internal routine 
	_varfstd.  These computations are performed by the internal routine

		forvalues ct =1/`NT'  {
			if `csamp2'[`ct'] == 1 {
				mat `Qt' = J(`eqs',`vcols',0)

				local tslist2 "`tslist'"

				gettoken dvar tslist2:tslist2
				local lpart = `dvar'[`ct']
			
				foreach dvar of local tslist2 {
					local val = `dvar'[`ct'] 
					local lpart "`lpart', `val' "
				}
				mat `Zt' = (`cpart'`lpart')
			
				forvalues i=0(1)`sm1' {
local hm1i = `h'-1-`i'
mat `Qt' = `Qt' + ( (`Zt'*`BTP'`hm1i')#`theta'`i')
				}

				mat `OMh' = `OMh' + `Qt'*`V2'*`Qt''
			}

		}
end ado code documentation for _varfstd() 
