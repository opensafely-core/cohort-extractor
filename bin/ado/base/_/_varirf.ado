*! version 1.9.1  07mar2018
program define _varirf, rclass
	version 8.0
	syntax [varlist(ts default=none)], 	/*
		*/ SAving(string) 		/*
		*/ irfname(string) 		/*
		*/[  Step(integer 4) 		/*
		*/ noPUTchar			/*
		*/ BSAving(string) 		/*
		*/ noSE 			/*
		*/ BS 				/*
		*/ BSP 				/*
		*/ Reps(string) 		/*
		*/ noDots			/*
		*/ Level(cilevel) ]

/* noputchar suppresses varirf characteristics from .vrf file*/

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "_varirf only works after var or svar"
		exit 198
	}	
	
	if "`bs'`bsp'" != "" {
		if e(N_gaps) > 0 & e(N_gaps) < . {
			di "bootstrap methods not available with " /*
				*/ "gaps in the data"
			exit 198	
		}	
	}	

	if "`e(cmd)'" == "svar" {
		mat dispCns, r
		local k = r(k)
		forvalues i = 1/`k' {
			local svarcns_char "`svarcns_char':`r(cns`i')'"
		}
		local version = cond(missing(e(version)),1,e(version))
		local vcaller = string(_caller())
		if `version' == 1 {
			if `vcaller' >= 16 {
				local vcaller = 15.1
			}
		}
		else if `vcaller' < 16 {
			local vcaller = 16
		}
		local vv : display "version `vcaller':"
	}
	else {
		local svarcns_char "."
	}

	if "`e(cmd)'" == "svar" {
		local svar "_var"
		if "`e(lrmodel)'" != "" {
			local svarp lr svar
			local lrcns  lrcns	
			if "`e(cns_lr)'" == "" {
				di as err "cannot find constraints "	/*
					*/ "specified on svar"
				exit 498
			}
		}	
		else {
			if "`e(cns_a)'`e(cns_b)'" == "" {
					di as err "cannot find constraints"/*
						*/ " specified on svar"
					exit 498
			}
			local svarp sr svar

		}
	}
	else {
			local svarp var
	}

	if "`e(constraints`svar')'" != "" {
		_getvarcns 
		local cnslist_var $T_VARcnslist
		if "`svar'" != "" {
			local cnslist_varm  varconstraints(`cnslist_var')
		}
		else {
			local cnslist_varm  constraints(`cnslist_var')
		}
		local varcnschar  "$T_VARcnslist2"
		capture macro drop T_VARcnslist 
		capture macro drop T_VARcnslist2
	}
	else {
		local varcnschar unconstrained
	}	

	local tminchar  = e(tmin)
	local tmaxchar  = e(tmax)
	local tsfmtchar	 `e(tsfmt)'
	local timevarchar `e(timevar)'
	local lagschar    `e(lags`svar')'
	
	qui count if e(sample) ==1
	if r(N) == 0 {
		di as err "e(sample) is never equal to 1"
		exit 498
	}	

/* if e(bigf)=="nobigf" then nose is implicitly specified. if nose
   is not specified, set it with a warning message */
   	
	if "`e(bigf`svar')'" != "" & "`se'"== "" {
		di as txt "nose implicitly specified, nobigf on the " /*
			*/ "estimated VAR implies nose " 
		local se "nose"
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
	


	local order "`varlist'"

	if "`order'" != "" & "`bs'`bsp'" != "" {
		di as err "order() cannot be specified with `bs'`bsp'"
		exit 198
	}	

	if `"`bsaving'"' != "" & "`bs'`bsp'" == "" {
		di as error "bs or bsp must be specified with bsaving()"
		exit 198
	}

	if `"`bsaving'"' != "" {
		local bsave_on "bsave_on"
		
		PSaving `bsaving'
		local bsfile `"`r(fname)'"' 
		local bsfile: subinstr local bsfile "." ".", 	/*
			*/ count(local bsext)
		if `bsext' == 0 {
			local bsfile `"`bsfile'.dta"'
		}	
		local bsreplace "`r(ireplace)'"
		if "`bsreplace'" == "" {
			confirm new file `"`bsfile'"'
		}	
	}	
	else {
		local bsave_on ""
		local qsave qui
		tempfile bsfile 
	}	



/* check that order contains the depvars in a different order */
	if "`order'" == "" {
		local order "`e(depvar`svar')'"
	}
	else {
		local order2 "`order'"	
		local dep2 "`e(depvar`svar')'"	
		while "`order2'" != "" {
			gettoken ovar order2 : order2
			local dep2: subinstr local dep2 "`ovar'" "", /*
				*/ all word count(local found)
			if int(`found') == 0 {
				di as err "order(`order') contains "/*
					*/"variables that were not "
				di as err "specified as endogenous variables"
				exit 198	
			}
		}
		local dep3 : subinstr local dep2 " " "", all
		if "`dep3'" != "" {
			di as err "the depvar(s) {cmd: `dep2'} "/*
				*/ "were not specified in order(`order')"
			exit 198	
		}
	}

	if "`reps'" != "" {
		capture confirm integer number `reps'
		if _rc > 0 {
			di as err "reps() must specify a strictly "/*
				*/ "positive integer"
			exit 198	
		}
		if `reps' <=0 {
			di as err "reps() must specify a strictly "/*
				*/ "positive integer"
			exit 198	
		}
		if "`bs'" == "" & "`bsp'" == ""  {
			di as err "reps() cannot be specified without "/*
				*/ "bs or bsp"
			exit 198	
		}	
	}
	else {
		local reps 200
	}


	if "`step'"  == "" {
		local step 4
	}

	PSaving `saving'
	local mrfile `r(fname)'
	local ireplace `r(ireplace)'

/* check that both bs and bsp were not specified on command line */	

	if "`bs'" != "" & "`bsp'" != "" {
		di as error "specify bs or bsp, not both"
		exit 198
	}
/* but set local bs "bs" if bsp, this simplifies if conditions */

	if "`bsp'" != "" {
		local bs "bs"
	}	

	
/* declare all tempnames here */

	tempname A phi sig_u P 
	tempname theta cphi ctheta sirf
	tempname mresults
	

	_mksigma `order' , sig(`sig_u')  /* _mksigma works with var and svar
					  * but note that order must be 
					  * original order with svar */
	matrix `P'= cholesky(`sig_u')

	local eqs = colsof(`sig_u')
	local vars "`order'" 

	local lags = e(mlag`svar')
	local lagl  "`e(lags`svar')'"

	if "`e(exog`svar')'" != "" {
		local exogc "`e(exog`svar')'"
		local exog "exog(`e(exog`svar')')"
	}	
	else {
		local exogc none
	}
	
	if "`e(nocons`svar')'" != "" {
		local consc noconstant
	}
	else {
		local consc constant
	}

	if "`bs'" != "" {


	if "`e(cmd)'" == "svar" {
		if "`e(lrmodel)'" != "" {
			if "`e(cns_lr)'" == "" {
					di as err "cannot find constraints"/*
						*/ " specified on svar"
					exit 498
			}
			local cns_lr "`e(cns_lr)'"	

			macro drop T_cns_lr_n
			while "`cns_lr'" != "" {
				gettoken next cns_lr:cns_lr , parse(":")
				if "`next'" != ":" {
					constraint free 
					constraint define `r(free)' `next'
					global T_cns_lr_n $T_cns_lr_n `r(free)'
				}
			}

			local lrconstraints "lrconstraints($T_cns_lr_n)"

		}
		else {
			if "`e(cns_a)'`e(cns_b)'" == "" {
					di as err "cannot find constraints"/*
						*/ " specified on svar"
					exit 498
			}
			local cns_a "`e(cns_a)'"	
			local cns_b "`e(cns_b)'"	

			macro drop T_cns_a_n
			while "`cns_a'" != "" {
				gettoken next cns_a:cns_a , parse(":")
				if "`next'" != ":" {
					constraint free 
					constraint define `r(free)' `next'
					global T_cns_a_n $T_cns_a_n `r(free)'
				}
			}

			local aconstraints "aconstraints($T_cns_a_n)"

			macro drop T_cns_b_n
			while "`cns_b'" != "" {
				gettoken next cns_b:cns_b , parse(":")
				if "`next'" != ":" {
					constraint free 
					constraint define `r(free)' `next'
					global T_cns_b_n $T_cns_b_n `r(free)'
				}
			}
			local bconstraints "bconstraints($T_cns_b_n)"
		}
	}

		tempname b sample
		local endog "`e(endog`svar')'"
		local eqlist "`e(eqnames`svar')'"
		mat `b'=e(b`svar')
		
		if "`e(dfk`svar')'" != "" {
			local dfk = "dfk"
		}

		qui gen byte `sample'=e(sample)  /* same with var and svar */
		local laglist "lags(`e(lags`svar')')"
		
		if "`e(nocons`svar')'" != "" {
			local nocons "nocons"
		}
		else {
			local nocons 
		}
		
		tempname vres pest
		tempfile bstmp bsresult
		tempvar vres_smp
		
/* make endog_ts and b_ts that are safe with ts op on rhs */
		tempname b_ts
		mat `b_ts' = e(b`svar')
		local i 1

		foreach v of local endog {
			local vt : subinstr local v "." "_"
			tempvar tv`i'
			qui gen double `tv`i'' = `v' 
			op_colnm `b_ts' `v' `tv`i''
			local endog_ts "`endog_ts' `tv`i'' "
			local i = `i' + 1
		}


/* check that there is sufficient memory for bs data */

/* size of bs dataset */

		local bsobs = (`step'+1)*`eqs'*`eqs'*`reps'

/* bwidth includes width which 3 for int step, 15*8 for 15 doubles
 * 15*3 for 3 15 character strings, and 4 for pointer overhead for each
 * observation
 */
		local bswidth = (3 + 15*8+15*3+4)
		
		local bssize = `bsobs'*`bswidth'

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

		local fail 0
		forvalues r=1(1)`reps' {
			qui preserve
			_varsim `endog_ts' , neqs(`eqs') b(`b_ts') `bsp' /*
				*/ fsamp(`sample') eqlist(`eqlist')
			forvalues i3 = 1/`eqs' {
				local tv1 : word `i3' of `endog_ts'
				local tv2 : word `i3' of `eqlist'
				capture confirm new variable `tv2'
				if _rc > 0  {
					qui replace `tv2' =`tv1'
				}
				else {
					qui rename `tv1' `tv2'
				}
			}
			_est hold `vres', copy restore nullok 	/*
				*/ varname(`vres_smp') 

			if "`svar'" == "" {
				qui var `eqlist' if `sample', /*
					*/ `laglist' `dfk' `exog'/*
					*/ `nocons' `cnslist_varm'
				local res_ok 1
			}
			else {
				`vv' ///
				qui svar `eqlist' if `sample', /*
					*/ `laglist' `dfk' `exog'/*
					*/ `nocons' `cnslist_varm' /*
					*/ `lreqm' `lrconstraints'/*
					*/ `aeqm' `beqm' `acnsm'  /*
					*/ `bcnsm' `aconstraints' /*
					*/ `bconstraints' 	  /*
					*/ iterate(500)
				if e(rc_ml) == 0 & e(ic_ml) < 500 {
					local res_ok 1
				}
				else {
					local res_ok 0
				}
			}

			if `res_ok' == 1 {
				qui _varirf , step(`step')         /*
					*/ nose			   /*
					*/ irfname(rep`r') noput   /*
					*/ saving(`bstmp', replace) 
				if `r' == 1 {
					qui use `"`bstmp'"', clear
					`qsave' save `"`bsfile'"', /*
						*/ `bsreplace'
				}
				else {
					qui use `"`bsfile'"', clear
					qui append using `"`bstmp'"'
					qui save `"`bsfile'"', replace
				}	
			}
			capture _est unhold `vres'
			qui restore
			
			if "`dots'" == "" & `r'<`reps' {
				if `res_ok' {
					di as txt "." _c
				}
				else {
					di as err "x" _c
					local ++fail
				}
			}	
			if "`dots'" == "" & `r' == `reps' {
				if `res_ok' {
					di as txt "." 
				}
				else {
					di as err "x"
					local ++fail
				}
			}
		}
		
		if `reps'-`fail' < 2 {
di as err "insufficient observations to compute bootstrap standard errors"
di as err "no results will be saved"
exit 2000
		}
		
		if "`bs'" != "" {
			local std_char bs
		}	

		if "`bsp'" != "" {
			local std_char bsp
		}	

/* sirf stdsirf sfevd and stfevd have been added to dataset */		
		local funcs "irf cirf oirf coirf sirf dm cdm fevd sfevd "	
		foreach func of local funcs {
			local clist "`clist' (sd) std`func'=`func' "
		}	
		qui preserve
		qui use `"`bsfile'"', clear

		sort step response impulse
		qui collapse `clist', by(step response impulse)
		qui gen str15 irfname = "`irfname'" 
		forvalues i3 = 1/`eqs' {
			local tv1 : word `i3' of `eqlist'
			local tv2 : word `i3' of `endog'
			qui replace impulse = "`tv2'" if impulse == "`tv1'"
			qui replace response = "`tv2'" if response == "`tv1'"
		}
		sort irfname step response impulse
		qui save `"`bstmp'"', replace
		restore
		_varirf `order', step(`step') nose /*
			*/ saving(`"`mrfile'"', replace) /*
			*/ irfname(`irfname') 
		qui use `"`mrfile'"', clear
			
			
		sort irfname step response impulse
		merge irfname step response impulse using `"`bstmp'"',	/*
			*/ update replace
		qui count if _merge!=4
		if r(N)>0 {
			di as error "problem merging bs dataset with point "/*
				 */ "estimates"
			exit 498
		}
		else {
			qui drop _merge
		}	
		_virf_char , change(irfname(`irfname') 		/*
			*/ stderr(`std_char') reps(`reps') )
		qui save "`mrfile'", replace

		if "`cnslist_var'" != "" {
			constraint drop `cnslist_var'
		}	
		exit
	}
	else {
		if "`se'" == "" {
			local std_char asymptotic
		}
		else {
			local std_char none
		}
	}	

/* call programs to make the A_i and phi_i , phi_i are the non-orthogonalized 
	impulse response matrices. 
*/	
	
	matrix `A'0 = I(`eqs')

	_var_mka `vars' , aname(`A')

	phi_i, step(`step') lags(`lags') aname(`A') phiname(`phi') /*
		*/ eqs(`eqs') 


/* make theta matrices, these hold the orthogonalized impulse responses */


	forvalues i = 0(1)`step' {
		matrix `theta'`i' = `phi'`i' * `P'
	}	

	if "`svar'" != "" {
				/* svarP0 is AG p 64 P_0 */
		tempname svarP0 svarA svarB svarAI svarBI 
		mat `svarA'  = e(A)
		mat `svarB'  = e(B)
		capture mat `svarAI' = inv(`svarA')
		if _rc > 0 {
			di as err "svar estimate of A matrix is " /*
				*/ "not invertible"
			di as err "cannot estimate structural IRFs"
			exit 498
		}	
		mat `svarP0' = `svarAI'*`svarB'
	forvalues i = 0(1)`step' {
			matrix `sirf'`i' = `phi'`i' * `svarP0'
		}	
	
	}
	else {
		forvalues i = 0(1)`step' {
			matrix `sirf'`i' = J(`eqs',`eqs', .) 
		}	

	}

	forvalues i = 0(1)`step' {
		local im1 = `i' -1
		if `i' == 0 {
			matrix `cphi'0 = `phi'0
			matrix `ctheta'0 = `theta'0
		}
		else {
			matrix `cphi'`i' = `cphi'`im1' + `phi'`i'
			matrix `ctheta'`i' = `ctheta'`im1' + `theta'`i'

		}
	}	

	forvalues i = 1(1)`eqs' {
		local vname : word `i' of `vars'
		local mylabel "`mylabel' `i' `vname' "
	}	

						//next line will not find
						// exog_v_svar  This is
						// intentional because DM with 
						// svar are different and not
						// yet implemented
	if "`svar'" == "" {						
		local exogvars  "`e(exogvars)'" 
		local exlags "`e(exlags)'"
	}	

	if "`exogvars'" != "" & "`svar'" == "" {
		if "`se'" == "" {
			tempname dname dsename mname msename
			_dm_create, step(`step') dname("`dname'") 	///
				dsename("`dsename'") `consc'		///
				mname("`mname'") msename("`msename'")
		}
		else {
			tempname dname mname
			_dm_create, step(`step') dname("`dname'")	///
				mname("`mname'") `consc'
		}
	}

	if "`svar'" == "" & "`exogvars'" != "" {
		local mylabel2 "`mylabel'"
		local i = `eqs'
		foreach vname of local exogvars{
			local vname : subinstr local vname "." "_"
			local ++i
			local mylabel2 "`mylabel2' `i' `vname' "
		}
	}
	
	local cnames "step responseid"
	if "`se'" == "" {
		local need = `eqs'*`eqs' 
		if c(max_matdim) < `need' {
			error 915
		}	
	}

	local mylabs "irf cirf oirf coirf sirf dm cdm stdirf stdcirf "
	local mylabs "`mylabs' stdoirf"
	local mylabs "`mylabs' stdcoirf stdsirf stddm stdcdm fevd sfevd mse"
	local mylabs "`mylabs' stdfevd stdsfevd" 

	foreach lab of local mylabs  {
		forvalues i = 1(1)`eqs' {
			local cnames "`cnames' `lab'`i' "
		}	
	}
	

	if "`se'" == "" {
		qui postfile `mresults' step responseid impulseid  /*
			*/ `mylabs' using "`mrfile'", double replace
		GetirfSE `order' , theta(`theta') ctheta(`ctheta') 	/*
			*/ phi(`phi')	sirf(`sirf')			/*
			*/ cphi(`cphi') s(`step') eqs(`eqs') 		/*
			*/ lags(`lags') a(`A') sig_u(`sig_u') 		/*
			*/ p(`P') pname(`mresults') `exog' 		/*
			*/ dname(`dname') dsename(`dsename') 		/*
			*/ mname(`mname') msename(`msename') 		/*
			*/ exogvars(`exogvars')
	}
	else {
		qui postfile `mresults' step responseid impulseid /*
			*/  `mylabs' using "`mrfile'", double replace
		GetirfSE2 , theta(`theta') ctheta(`ctheta') phi(`phi')	/*
			*/ sirf(`sirf') cphi(`cphi') s(`step') 		/*
			*/ eqs(`eqs') lags(`lags') a(`A') 		/*
			*/ sig_u(`sig_u') p(`P') pname(`mresults')	/*
			*/ dname(`dname') mname(`mname') exogvars(`exogvars')
		local star "*"
	}

	postclose `mresults'



	qui preserve
	qui drop _all
	qui use "`mrfile'"
	_virf_nlen `irfname'
	if r(len) > 15 {
		di as err "_varirf requires that irfname have 15 or" /*
			*/ " or fewer characters"
		exit 198
	}	

	if "`putchar'" == "" {
		_virf_char , put(irfname(`irfname') vers(1.1) /*
			*/ order(`order') step(`step') 		/*
			*/ model(`svarp') exog(`exogc')		/*
			*/ constant(`consc') 			/*
			*/ varcns(`varcnschar')			/*
			*/ stderr(`std_char')			/*
			*/ reps(.)				/*
			*/ tmin(`tminchar')			/*
			*/ tmax(`tmaxchar')			/*
			*/ tsfmt(`tsfmtchar')			/*
			*/ timevar(`timevarchar')		/*
			*/ lags(`lagschar')			/*
			*/ svarcns(`svarcns_char')		/*
			*/ exogvars(`exogvars')			/*
			*/ exlags(`exlags')			/*
			*/)
	}		
	qui gen str15 irfname = "`irfname'"
	qui label define varid_lbl `mylabel'
	qui label values responseid varid_lbl
	qui decode responseid, generate(response)
	if "`svar'" == "" & "`exogvars'" != "" {
		qui label define varid_lbl2 `mylabel2'
		qui label values impulseid varid_lbl2
	}
	else {
		qui label values impulseid varid_lbl
	}	
	qui decode impulseid, generate(impulse)
	qui label var cirf "cumulative irf"
	qui label var irf  "impulse-response function"
	qui label var oirf "orthogonalized irf"
	qui label var coirf "cumulative orthogonalized irf"
	qui label var sirf  "structural irf"
	qui label var dm    "dynamic multipliers"
	qui label var cdm   "cumulative dynamic multipliers"
	qui label var mse  "SE of forecast of response variable"
	qui label var fevd "fraction of mse due to impulse"
	qui label var sfevd "(structural) fraction of mse due to impulse"
	qui label var step  "step"
	qui label var irfname "name of results"
	qui label var impulse "impulse variable"
	qui label var response "response variable"
	`star' qui replace stdirf=sqrt(stdirf)
	`star' qui replace stdcirf=sqrt(stdcirf)
	`star' qui replace stdoirf=sqrt(stdoirf)
	`star' qui replace stdcoirf=sqrt(stdcoirf)
	`star' qui replace stdsirf=sqrt(stdsirf)
	`star' qui label var stdirf "std error of irf"
	`star' qui label var stdoirf "std error of oirf"
	`star' qui label var stdcirf "std error of cirf"
	`star' qui label var stdcoirf "std error of coirf"
	`star' qui label var stdsirf "std error of sirf"
	`star' qui label var stddm   "std error of dm"
	`star' qui label var stdcdm  "std error of cdm"
	qui replace mse=sqrt(mse)
	`star' qui replace stdfevd=sqrt(stdfevd)
	`star' qui label var stdfevd "std error of fevd"
	`star' qui replace stdsfevd=sqrt(stdsfevd)
	`star' qui label var stdsfevd "std error of sfevd"
	recast int step impulseid responseid
	drop impulseid responseid

	qui save "`mrfile'", `ireplace'
	qui restore

	if "`cnslist_var'" != "" {
		constraint drop `cnslist_var'
	}	
end


program define phi_i, rclass
	syntax, step(integer) lags(integer) aname(string) phiname(string) /*
		*/ eqs(integer) 

	if `lags' < 1 {
		di as error "there must be at least 1 lag"
		exit 198
	}
	if `step' < 1 {
		di as error "step() must specify an integer greater " /*
			*/ "than or equal to 1"
		exit 198
	}

	local A "`aname'"

	matrix `phiname'0=I(`eqs')
	
	forvalues i = 1(1)`step' {
		forvalues j = 1(1)`i' {
			if `j'<=`lags' {
				local imj= `i' - `j'
				if `j' == 1 {
					matrix `phiname'`i' = /*
						*/ `phiname'`imj' * `A'1
				}
				else {
					matrix `phiname'`i' = /*
						*/ `phiname'`i' + /*
						*/ `phiname'`imj' * `A'`j' 
				}
			}
		}
	}
end	

/* this program makes the .5*m*(m+1) by m^2 elimination matrix
   for an (m x m) matrix  it solves
   	vech(A)=Lm vec(A) 
   see Lutkepohl pages 464-466 for details 

   L is the name of the matrix to be created

   m is the number of rows (columns) in the square matrix A

*/

program define mkLm
	syntax , l(string) m(integer)
	
	local L "`l'" 

	if `m' > 1 {
		tempname Q1 Q2 Q3
	
		matrix `L' = I(`m') , J(`m',`m'*(`m'-1) , 0 )

		local m1 = `m' - 1 

		forvalues i = 2(1)`m1' {
			matrix `Q1' = J( `m'+1-`i', (`i'-1)*`m' , 0 )
			matrix `Q2' = J( `m'+1-`i',`i'-1 , 0 ) , I(`m'+1-`i')
			matrix `Q3' = J( `m'+1-`i',(`m'-`i')*`m', 0 )
			matrix `L' = `L' \ (`Q1' , `Q2', `Q3' )

		}
	
		matrix `L' = `L' \ ( J( 1 , `m'*`m'-1, 0 ), 1 )

		exit
	}	

	if `m' == 1 {
		matrix `L' = I(1)
		exit
	}

/* should not be reached */
	di as err "invalid number of equations"
	exit 498
end	

program define mkDm
	syntax , d(string) m(integer)

	if `m' > 1 {
		matrix `d' = J(`m'*`m',round(.5*(`m'+1)*`m',1),0)

		local cin  1
		forvalues j=1(1)`m' {
			forvalues i=1(1)`m' {
				local r = `i' + (`j'-1)*`m'	
				if `i'>=`j' {
					local c = `cin'
					local cin = `cin' + 1
				}
				else {
					local q = round( .5*( `m'*(`m'+1) /*
				 	    */ - (`m'-`i'+1)*(`m'-`i'+2) ),1)
					local c = `q' + `j'-(`i'-1)
				}
				matrix `d'[`r',`c']=1
			}	
		}
		exit
	}

	if `m' == 1 {
		matrix `d' = I(1)
		exit
	}
/* should not be reached */
	di as err "invalid number of equations"
	exit 498
end	

program define mkei 
	syntax , e(string) k(integer) i(integer)

	if `k' < 1 {
		di as err "dimension of e must be greater than 1"
		exit 198
	}	
		
	if `i' < 1 | `i' > `k' {
		di as err "the one in e must be in elements 1 to `k' "
		exit 198
	}	
		
	mat `e' = J(`k',1,0)
	mat `e'[`i',1] = 1
end	


program define GetirfSE
	syntax varlist(ts) , theta(string) ctheta(string) phi(string) 	/*
		*/ sirf(string) cphi(string) s(integer) eqs(integer)   	/*
		*/ lags(integer) a(string)   				/*
		*/ sig_u(string) p(string) pname(string) 		/*
		*/ [ exog(string) exogvars(string) 			/*
		*/ dname(string) dsename(string) 			/*
		*/ mname(string) msename(string) 			/*
		*/ ]
		
	if "`e(cmd)'" == "svar" {
		local svar "_var"
		if "`e(lrmodel)'" != "" {
			local lrcns  lrcns	
		}	
	}	

	local A "`a'"
	local P "`p'"
	tempname stdtheta G J bigAP bigA temp F
	tempname C LQ KQ Cbar H D Dinv sigsig B Bbar
	tempname V V2
	tempname stdtheta stdtemp stdvec
	tempname mse omega e et q2 omega_s mse_m z3 z1 z2 d dbar
	tempname z4 z6 omegaerr zp0 zp1 zp2 zp2a
	tempname stdirfm stdirfv stdirf_am stdirf_av stdirf_a
	tempname stdphi stdoirf_m stdoirf_v stdoirf 
	tempname stdcoirf stdcoirf_m stdcoirf_v 
	tempname myT eG
	tempname NV2 NV2row

	if "`exogvars'" != "" {
		local nexogvars : word count `exogvars'
	}
	else {
		local nexogvars = 0
	}

	if "`exog'" != "" {
		local exog_v "`exog'"
		local exog "exog(`exog')"
	}	

	local order "`varlist'"

					/* mk std err for phi's */
			/* make bigAP and J from page 98 in Lutkepohl */


	local kp   = `eqs'*`lags' 
	local k2   = `eqs'*`eqs'
	local k2p  = `k2'*`lags'
	local lm1  = `lags' - 1
	local lm1p = `lm1'*`eqs'
	local sm1 = `s' -1
	local ksum = round( .5*(`eqs'*(`eqs'+1) ), 1)


	if `lags' > 1 {
		forvalues i = 1(1)`lm1' {
			capture mat drop `temp'
			forvalues j=1(1)`lm1' {
				if `j' == `i' {
					mat `temp'=( nullmat(`temp') /*
						*/ \ I(`eqs') )
				}
				else {
					mat `temp'=(nullmat(`temp') /*
				 		*/ \ J(`eqs',`eqs',0))
				}
			}
			mat `bigAP' = (nullmat(`bigAP'), (`A'`i' \ `temp') )
		}

		mat `bigAP' = (`bigAP', (`A'`lags' \ J(`lm1p',`eqs',0)) )
	}
	else {
		mat `bigAP' = (`A'`lags' )
	}

	mat `bigA'  = `bigAP'
	mat `bigAP' = (`bigAP')'

	mat `bigAP'0 = I(`kp') 
	mat `bigA'0  = I(`kp') 
	forvalues i=1(1)`s' {
		local im1 = `i' -1
		mat `bigAP'`i' =(`bigAP'`im1') * `bigAP'
		mat `bigA'`i' =(`bigA'`im1') * `bigA'
	}


	forvalues i = 1(1)`lags' {
		if `i' == 1 {
			mat `J' = I(`eqs')
		}
		else {
			mat `J' = `J' , J(`eqs',`eqs',0)
		}

	}

/* G and F matrices defined on page 99 of Lutkepohl */

	mat `G'0 = J(`k2',`k2p',0)
	mat `F'0 = J(`k2',`k2p',0)

	forvalues i=1(1)`s' {
		local im1=`i'-1
		forvalues m=0(1)`im1' {
			if `m' == 0 {
				local i_1_m=`i'-1-`m'
				mat `G'`i' =(`J'*(`bigAP'`i_1_m')) /*
					*/ # `phi'`m'
			}
			else {
				local i_1_m=`i'-1-`m'
				mat `G'`i' =`G'`i' + /*
					*/ (`J'*(`bigAP'`i_1_m')) /*
					*/ # `phi'`m'
			}
		}
		mat `F'`i'=`F'`im1'+`G'`i'
	}


/* make Ci Cbari Dinv H and B; note Bbar is made final loop section
	because it needs cumulative irf response matrix, called cphi 
	below
*/	

	mkLm , l(`LQ') m(`eqs')
	_mkkmn, k(`KQ') m(`eqs') n(`eqs')
	mkDm, d(`D') m(`eqs')

	matrix `Dinv'=(syminv((`D')'*`D'))*((`D')')


	matrix `H' = ( I(`eqs'*`eqs') + `KQ')*(`P' # I(`eqs') ) 
	matrix `H' = `LQ' * `H' * ( (`LQ')' )
	matrix `H' = inv(`H')
	matrix `H' = ((`LQ')')*`H'

	mat `B'0=J(`eqs'*`eqs', `eqs'*`eqs'*`lags', 0)

	mat `C'0=J(`eqs'*`eqs', `eqs'*`eqs'*`lags', 0)
	mat `Cbar'0 = `H' 
	forvalues i = 1(1)`s' {
		matrix `C'`i' = (((`P')') # I(`eqs'))*`G'`i'
		matrix `Cbar'`i' = ( I(`eqs') # `phi'`i' ) * `H'
		matrix `B'`i' = ((`P')' # I(`eqs') )*`F'`i'
	}

	
/* This section makes V2 and sigsig, these are the covariance matrices
	called SIGMA_alpha and SIGMA_sigma by Lutkepohl on pages 
	96-113
	
	V2=SIGMA_alpha is the VCE matrix of the A_1, A_2, ..., A_p 
	parameters 

	sigsig=SIGMA_sigma is the VCE of vec(e(Sigma))

	Note use of e(Sigma) without normalizing to ML e(Sigma) implies
	that the standard errors after var with dfk and without dfk will 
	be different.  Lutkepohl gives dfk version
*/

	tempname sigml
	mat `sigml'=`sig_u'

	scalar `myT'=e(T`svar')
	local myT2 =e(T`svar')
	tempvar mysmp
	qui gen byte `mysmp'=e(sample)

	_mkg `varlist' , gname(`eG') lags(`e(lags`svar')')  touse(`mysmp') /*
		*/ bigt(`myT2')  `e(nocons`svar')' `exog'
		
 	mat `V2'=`myT'*`eG' 
	

	mat `V2'=syminv(`V2')

	local v2eqname :  colnames `sig_u'
	local v2cname : colnames `V2'

	foreach cname of local v2cname {
		foreach eqname of local v2eqname {
			local eqnames `eqnames' `eqname'
			local colnames `colnames' `cname'
		}
	}

	

	mat `V2'=`V2'#`sig_u'
	mat colnames `V2' = `colnames'
	mat coleq `V2' = `eqnames'
	mat rownames `V2' = `colnames'
	mat roweq `V2' = `eqnames'

/* obtain constrained version of VCE */

 	if "`svar'" == "" {
 		mat dispCns, r
		if r(k) > 0 {
			_cnsVCE `V2'
		}
	}
	else {
		if "`e(constraints_var)'" != "" {
			_cnsVCE `V2'
		}
	}

	local v2names : colnames `V2'
	local v2cols = colsof(`V2')

	forvalues i = 1/`v2cols' {
		local keep 1
		local tmp: word `i' of `v2names'
		if "`tmp'" == "_cons" {
			local keep 0
		}
		foreach exv of local exog_v {
			if "`tmp'" == "`exv'" {
				local keep 0
			}
		}
		if `keep' == 1 {
			local kcols `kcols' `i'
		}	
	}


	foreach i of local kcols {
		capture mat drop `NV2row'
		foreach j of local kcols {
			mat `NV2row' = (nullmat(`NV2row'), `V2'[`i',`j'])	
		}
		mat `NV2' = ( nullmat(`NV2') \ `NV2row')
	}

	mat `V2' = `NV2'
	matrix `sigsig'=(2/`myT')*`Dinv'*(`sigml' /*
		*/ # `sigml')*((`Dinv')')

	matrix `mse'   = J(`eqs',1,0)
	matrix `omega' = J(`eqs',`eqs',0)
	matrix `omega_s' = J(`eqs',`eqs',0)
	matrix `omegaerr' = J(`eqs',`eqs',0)

/* force promotion of omega omega_s and omegaerr
 * from sysmat to GMAT 
 */	
	if `eqs' >= 2 {
		matrix `omega'[1,2] = 1
		matrix `omega'[1,2] = 0

		matrix `omega_s'[1,2] = 1
		matrix `omega_s'[1,2] = 0

		matrix `omegaerr'[1,2] = 1
		matrix `omegaerr'[1,2] = 0

		matrix `omega_s'[1,2] = 1
		matrix `omega_s'[1,2] = 0
	}	

	forvalues j3 = 1(1)`eqs' {
		matrix `z3'`j3' = J(1, `k2p' ,0)
		matrix `z6'`j3' = J(1, `ksum' ,0)
		mkei , e(`e'`j3') k(`eqs') i(`j3')
		mat `et'`j3' = `e'`j3''
	}	
	
/* this is the loop that calculates all the effects and their standard
	errors for steps 0 to `s' 
*/

/* make temporary matrices to hold sirf sfevd stdsirf stdsfevd 	
 * also calculate all step invariant matrices for svar calculations 
 * here 
 */

	tempname svarMSE svarM svarF svarFSI svarI svarW svarSIG0 	/*
		*/ svarA svarB svarSIGab svarAI svarBI svarK svarKP	/*
		*/ svarQ1 svarSIGK svarQ2 svarKI svarSIG0 svarG		/*
		*/ svarKIP svarQ4 svarQ5 svarQ6 svarQ7 svarQ8		/*
		*/ svarQ9 svarQ10 svarZ svarSIGHB svarMID		/*
		*/ sfevd_m svarQ4i svarQ4j				/*
		*/ stdsirf_m stdsfevd_m sirfs sfevds 			/*
		*/ stdsirfs stdsfevds

	tempname ftempa ftempb ftempc ftempd fworka ftempe ftempf 	/*	
		*/ ftempg fworkb fworkc dm dmse
	
/* calculate svarSIG0 here, svarSIG0 is the VCE matrix for vec(K^(*) ^(-1))
 * derived on pages 62-65 of AG
 */	
	if "`svar'" != "" {
		mat `svarM' = J(`eqs', `eqs', 0)
		mat `svarF' = J(`eqs', `eqs', 0)
		mat `svarI' = I(`eqs')

		mat `svarA' 	= e(A)
		mat `svarB' 	= e(B)
		mat `svarSIGab'	= e(V)

		capture mat `svarAI' = inv(`svarA')
		if _rc > 0 {
			di as err "svar estimate of A matrix not invertible"
			exit 198
		}	

		capture mat `svarBI' = inv(`svarB')
		if _rc > 0 {
			di as err "svar estimate of B matrix not invertible"
			exit 198
		}	

		mat `svarK' = `svarBI'*`svarA'
		mat `svarKI' = `svarAI'*`svarB' 
		mat `svarKIP' = `svarKI''
		mat `svarKP' = `svarK''

		mat `svarQ1'	= (`svarI' # `svarBI'), 	/*
			*/ (-1*`svarKP'#`svarBI')
		
		mat `svarQ2' = (`svarKI'')#`svarKI'

		if "`lrcns'" == "" {
			mat `svarSIGK' = `svarQ1'*`svarSIGab'*`svarQ1''	
			mat `svarSIG0' = `svarQ2'*`svarSIGK'*`svarQ2''
		}

		mat `svarG'0 = J(`eqs'*`eqs',`eqs'*`eqs'*`lags', 0)

		forvalues svari = 1/`s' {
			local im1 = `svari'-1
			mat `svarG'`svari' = J(`eqs'*`eqs',	/*
				*/ `eqs'*`eqs'*`lags', 0)
			forvalues svarcntk = 0/`im1'{
				local svarcntk2 = `im1'-`svarcntk'	
				mat `svarG'`svari'  =  `svarG'`svari' +/*
					*/ (`svarKIP'*`J'*`bigAP'`svarcntk2')/*
					*/ # (`J'*`bigA'`svarcntk'*`J'')
			}	
		}

	}
	else {
		mat `stdsfevd_m' = J(`eqs', `eqs', .)
	}

/* end svar section */

	forvalues i = 0(1)`s' {
		local im1 = `i' -1
		matrix `Bbar'`i' = ( I(`eqs') # `cphi'`i') * `H'
						/* make sterr mats */

		mat `stdcoirf_m' = `B'`i'*`V2'*(`B'`i')' + /*
			*/ `Bbar'`i'*`sigsig'*(`Bbar'`i')'
		mat `stdcoirf_v' =vecdiag(`stdcoirf_m')	
		
		mat `stdtemp' =  `G'`i'*`V2'*((`G'`i')')
		mat `stdirf_am' = `F'`i'*`V2'*((`F'`i')')
		mat `stdvec'=vecdiag(`stdtemp')
		mat `stdirf_av'=vecdiag(`stdirf_am')

		mat `stdoirf_m' = `C'`i'*`V2'*(`C'`i')' + /*
			*/ `Cbar'`i'*`sigsig'*(`Cbar'`i')'
		mat `stdoirf_v' = vecdiag(`stdoirf_m')

		capture mat drop `stdphi'
		capture mat drop `stdirf_a'
		capture mat drop `stdoirf'
		capture mat drop `stdcoirf'
		capture mat drop `mse_m'

		forvalues j=1(1)`eqs' {
			local c1 = (`j'-1)*(`eqs')+1
			local c2 = `j'*(`eqs')
			mat `stdphi' = (nullmat(`stdphi') , /*
				*/ (`stdvec'[1,`c1'..`c2']') )
			mat `stdirf_a' = (nullmat(`stdirf_a') , /*
				*/ (`stdirf_av'[1,`c1'..`c2']') )
			mat `stdoirf' = (nullmat(`stdoirf') , /*
				*/ (`stdoirf_v'[1,`c1'..`c2']') )
			mat `stdcoirf' = (nullmat(`stdcoirf') , /*
				*/ (`stdcoirf_v'[1,`c1'..`c2']') )
		}

/* begin SVAR calculations here */
		
		if "`svar'" != "" {

			if `i' > 0 {
				mat `svarM' =				     /*
					*/ hadamard(`sirf'`im1',`sirf'`im1') /*
					*/ + `svarM'
				mat `svarF' = `sirf'`im1'*(`sirf'`im1')' /*
					*/ + `svarF'
				mat `svarFSI' = hadamard(`svarF',`svarI')
				mat `svarFSI' = syminv(`svarFSI')
	
				mat `svarW'   = `svarFSI'*`svarM'
				mat `svarQ4' = `svarI' # (`J'*`bigA'`i'*`J'')
				if "`lrcns'" == "" {
mat `stdsirf_m' = `svarG'`i'*`V2'*`svarG'`i'' /*
	*/ + `svarQ4'*`svarSIG0'*`svarQ4''
_diag2mat , mat(`stdsirf_m')		/*
	*/ dmat(`stdsirf_m') rows(`eqs')/*
	*/ cols(`eqs') corder
				}
				else {
mat `stdsirf_m' = J(`eqs',`eqs', .)
				}

/* make svarZ eqs^2 x im1*eqs^2 */

				forvalues svari3 = 0/`im1' {
					mat `svarQ5' = vec(`sirf'`svari3')

					mat `svarQ5'  = diag(`svarQ5')
					mat `svarQ6' = 			    /*
						*/ (`svarI'#`svarFSI')*`svarQ5'
					mat `svarQ7' = vec(`svarI')
					mat `svarQ7' = diag(`svarQ7')
					_mkkmn , k(`svarQ8') m(`eqs') n(`eqs')
					mat `svarQ8' = .5*(I(`eqs'*`eqs')   /*
						*/ + `svarQ8')
					mat `svarQ9' = (`svarW''#`svarFSI') /*
						*/ *`svarQ7'*`svarQ8'*      /*
						*/ (`sirf'`svari3' # `svarI')

					mat `svarZ'`svari3' =		    /*
						*/ 2*(`svarQ6'-`svarQ9')
/* svarZsvari3 is svari3 block of Z, it is `eqs'^2 by `eqs'^2
 */
				}	

/* for each iteration below make eqs^2 x im1*eqs^2 cols section of Sig(h) 
 *   then multiply this section with svarZ and append result to svarMID
*/

/* This next section computes the stderr of sfevd
 * only compute stdsfevd if there are no long run constraints 
 */
if "`lrcns'" == "" {

	tempname tempa tempb tempc tempd tempe worka workb workc

	mat `stdsfevd_m' = J(`eqs',`eqs',0)

/* force promotion of stdsfevd_m from SYMAT to GMAT */

	if `eqs' > 1 {
		matrix `stdsfevd_m'[1,2] = 1
		matrix `stdsfevd_m'[1,2] = 0
	}

	_sfevdstd , stdsfevdm(`stdsfevd_m') biga(`bigA') svari(`svarI')	///
		svarmid(`svarMID')  bigj(`J') tempb(`tempb')		///
		v2(`V2') svarg(`svarG') svarq4j(`svarQ4j')		///
		svarsighb(`svarSIGHB') svarq4i(`svarQ4i')		///
		svarz(`svarZ') eqs(`eqs') im1(`im1')			///
		worka(`worka') workb(`workb') workc(`workc')		///
		tempa(`tempa') tempc(`tempc') svarsig0(`svarSIG0')	///
		tempd(`tempd') tempe(`tempe')

/* see Note 1 below */


}
else {
	mat `stdsfevd_m' = J(`eqs',`eqs', .)
}
						/* end calculation of 
						 * stderr of sfevd
						 */

			}
			else {
				mat `svarW'   	= J(`eqs',`eqs', 0)
				mat `svarQ4' = `svarI' # (`J'*`bigAP'0*`J'')
				if "`lrcns'" == "" {
mat `stdsirf_m' = `svarQ4'*`svarSIG0'*`svarQ4''
_diag2mat , mat(`stdsirf_m') dmat(`stdsirf_m') rows(`eqs')/*
	*/ cols(`eqs') corder
mat `stdsfevd_m'= J(`eqs',`eqs', 0)
				}
				else {
mat `stdsirf_m'= J(`eqs',`eqs', .)
mat `stdsfevd_m'= J(`eqs',`eqs', .)
				}
			}
		}
		else {
			mat `svarW'   = J(`eqs',`eqs', .)
			mat `stdsirf_m' = J(`eqs', `eqs', .)
		}
		

/* end SVAR calculations here */

/* make forecast error variance components matrix omega 
*/
/* See Note 2 below for _fevdstd documentation */
		if `i' > 0 {
			if `eqs' > 1 {
_fevdstd , zp2a(`zp2a') et(`et') 	///
	phi(`phi') ftempa(`ftempa') 	///
	eqs(`eqs') im1(`im1') 		///
	zp2(`zp2') sigu(`sig_u') 	///
	mse(`mse') z3(`z3') gname(`G')	///
	k2p(`k2p') ftempb(`ftempb') 	///
	ftempc(`ftempc') 		///
	ftempd(`ftempd') ksum(`ksum')	///
	dname(`D') z6(`z6') 		///
	worka(`fworka') theta(`theta')	///
	omegas(`omega_s') 		///
	omegab(`omega') z1name(`z1')	///
	z4name(`z4') zp0name(`zp0')	///	
	pname(`P') ftempe(`ftempe')	///
	ftempf(`ftempf') 		///
	ftempg(`ftempg') hname(`H')	///
	littled(`d') dbar(`dbar')	///
	v2(`V2') sigsig(`sigsig')	///
	omegaerr(`omegaerr')		///
	workb(`fworkb') workc(`fworkc')	
			}
			else {
				matrix `omega'[1,1] = 1
				matrix `omegaerr'[1,1] = 0
			}

			forvalues j4=1(1)`eqs' {
				mat `mse_m'= ( nullmat(`mse_m') , `mse' )
			}	
		}	
		else {
			matrix `mse_m'=J(`eqs',`eqs',0)
		}

/* There are eqs=number of endogenous variables in each of the 
 *	matrices.  make k posts to dataset */

		tempname periods resids impids phis cphis thetas cthetas /*
			*/ stdirfs stdcirfs stdoirfs stdcoirfs omegas2 /*
			*/ mses omegaerrs cdm cdmse
		
		scalar `periods'=`i'
		
		forvalues dc=1(1)`eqs' {
			scalar `resids'=`dc'
			
			forvalues dc2=1(1)`eqs' {
				scalar `impids'=`dc2'
				scalar `phis'=`phi'`i'[`dc',`dc2']	
				scalar `cphis'=`cphi'`i'[`dc',`dc2']	
				scalar `thetas'=`theta'`i'[`dc',`dc2']	
				scalar `cthetas'=`ctheta'`i'[`dc',`dc2']	
				scalar `sirfs'  =`sirf'`i'[`dc',`dc2']
				scalar `stdirfs'=`stdphi'[`dc',`dc2']	
				scalar `stdcirfs'=`stdirf_a'[`dc',`dc2']	
				scalar `stdoirfs'=`stdoirf'[`dc',`dc2']	
				scalar `stdcoirfs'=`stdcoirf'[`dc',`dc2']	
				scalar `stdsirfs' = `stdsirf_m'[`dc',`dc2']
				scalar `omegas2'=`omega'[`dc',`dc2']	
				scalar `sfevds' = `svarW'[`dc',`dc2']
				scalar `mses'=`mse_m'[`dc',`dc2']	
				scalar `omegaerrs'=`omegaerr'[`dc',`dc2']	
				scalar `stdsfevds' = `stdsfevd_m'[`dc',`dc2']


				post `pname' (`periods') (`resids') 	    /*
					*/ (`impids') (`phis') 		    /*
					*/ (`cphis') (`thetas') (`cthetas') /*
			 */ (`sirfs') (.) (.) (`stdirfs') (`stdcirfs')      /*
					*/ (`stdoirfs') (`stdcoirfs')       /*
					*/ (`stdsirfs') (.) (.) (`omegas2') /*
					*/ (`sfevds') (`mses')	   	    /*
					*/ (`omegaerrs') (`stdsfevds')
			}

			local eqspex = `eqs' + `nexogvars'
			local eqs1   = `eqs' + 1
			forvalues exogv_cnt = `eqs1' / `eqspex' {
				local dc2 = (`i')*`nexogvars' + `exogv_cnt'-`eqs'
				scalar `dm'   = `dname'[`dc',`dc2']
				scalar `cdm'   = `mname'[`dc',`dc2']
				scalar `dmse' = `dsename'[`dc',`dc2']
				scalar `cdmse' = `msename'[`dc',`dc2']

				post `pname' (`periods') (`resids') 	/*
					*/ (`exogv_cnt') (.) 		/*
					*/ (.) (.) (.) 			/*
					*/ (.) (`dm') (`cdm') (.) (.) 	/*
					*/ (.) (.) 			/*
					*/ (.) (`dmse') (`cdmse') (.)	/*
					*/ (.) (.)			/*
					*/ (.) (.)
			}		
				
		}
	}

end

program define GetirfSE2
	syntax , theta(string) ctheta(string) phi(string) 		/*
		*/ sirf(string) cphi(string) s(integer) eqs(integer)   	/*
		*/ lags(integer) a(string)   				/*
		*/ sig_u(string) p(string) pname(string)		/*
		*/ [							/*
		*/ dname(string) exogvars(string) mname(string) 		/*
		*/ ]
		

	if "`e(cmd)'" == "svar" {
		local svar "_var"
	}	

	local A "`a'"
	local P "`p'"
	tempname D mse omega e q2 omega_s mse_m z2 /* 
		*/ zp2 zp2a

	mkDm, d(`D') m(`eqs')
	
	matrix `mse'   = J(`eqs',1,0)
	matrix `omega' = J(`eqs',`eqs',0)
	matrix `omega_s' = J(`eqs',`eqs',0)

	forvalues j3 = 1(1)`eqs' {
		mkei , e(`e'`j3') k(`eqs') i(`j3')
	}	

	if "`exogvars'" != "" {
		local nexogvars : word count `exogvars'
	}
	else {
		local nexogvars 0
	}

/* make temporary matrices to hold sirf sfevd stdsirf stdsfevd */

	tempname svarM svarF svarFSI svarW sirfs sfevds svarI

	if "`svar'" == "" {
		mat `svarW' = J(`eqs', `eqs', .)
	}
	else {
		mat `svarM' = J(`eqs', `eqs', 0)
		mat `svarF' = J(`eqs', `eqs', 0)
		mat `svarI' = I(`eqs')
	}

	
/* this is the loop that calculates all the effects and their standard
	errors for steps 0 to `s' 
*/

	forvalues i = 0(1)`s' {
		local im1 = `i' -1
		capture mat drop `mse_m'

/* make forecast error variance components matrix omega */
		if `i' > 0 {

/* begin svar section */
			if "`svar'" != "" {
				mat `svarM' =				     /*
					*/ hadamard(`sirf'`im1',`sirf'`im1') /*
					*/ + `svarM'
				mat `svarF' = `sirf'`im1'*(`sirf'`im1')' /*
					*/ + `svarF'
				mat `svarFSI' = hadamard(`svarF',`svarI')
				mat `svarFSI' = syminv(`svarFSI')
	
				mat `svarW'   = `svarFSI'*`svarM'
			}	
/* end svar section */
		
			forvalues j3=1(1)`eqs' {
				matrix `zp2a' =  `e'`j3'' * `phi'`im1' 
				matrix `zp2' =  `zp2a' * `sig_u'
				matrix `mse'[`j3',1] = `mse'[`j3',1] /*
					*/ + `zp2' * `zp2a'' 
				forvalues i3=1(1)`eqs' {
matrix `q2' =  ( `e'`j3'' * `theta'`im1' * `e'`i3' )
matrix `q2' = (`q2'[1,1] * `q2'[1,1]) 
matrix `omega_s'[`j3',`i3'] = `omega_s'[`j3',`i3'] + `q2'[1,1] 
matrix `omega'[`j3',`i3'] = `omega_s'[`j3',`i3'] / `mse'[`j3',1]

				}
				
			}
			forvalues j4=1(1)`eqs' {
				mat `mse_m'= ( nullmat(`mse_m') , `mse' )
			}	
		}	
		else {
			mat `svarW'   	= J(`eqs',`eqs', 0)
			matrix `mse_m'=J(`eqs',`eqs',0)
		}

		tempname periods resids impids phis cphis thetas cthetas /*
			*/ omegas2 mses dm cdm
		
		scalar `periods'=`i'
		
		forvalues dc=1(1)`eqs' {
			scalar `resids'=`dc'
			
			forvalues dc2=1(1)`eqs' {
				scalar `impids'=`dc2'
				scalar `phis'=`phi'`i'[`dc',`dc2']	
				scalar `cphis'=`cphi'`i'[`dc',`dc2']	
				scalar `thetas'=`theta'`i'[`dc',`dc2']	
				scalar `cthetas'=`ctheta'`i'[`dc',`dc2']	
				scalar `sirfs'  = `sirf'`i'[`dc',`dc2']
				scalar `omegas2'=`omega'[`dc',`dc2']	
				scalar `sfevds' = `svarW'[`dc',`dc2']
				scalar `mses'=`mse_m'[`dc',`dc2']	


				post `pname' (`periods') (`resids')         /*
					*/ (`impids') (`phis')              /*
					*/ (`cphis') (`thetas') (`cthetas') /*
					*/ (`sirfs') (.) (.) (.) (.)        /*
					*/ (.) (.) 			    /*
					*/ (.) (.) (.) (`omegas2')          /*
					*/ (`sfevds') (`mses')		    /*
					*/ (.) (.)


			}
			local eqspex = `eqs' + `nexogvars'
			local eqs1   = `eqs' + 1
			forvalues exogv_cnt = `eqs1' / `eqspex' {
				local dc2 = (`i')*`nexogvars' + `exogv_cnt'-`eqs'
				scalar `dm'   = `dname'[`dc',`dc2']
				scalar `cdm'  = `mname'[`dc',`dc2']
		
				post `pname' (`periods') (`resids') 	/*
					*/ (`exogv_cnt') (.) 		/*
					*/ (.) (.) (.) 			/*
					*/ (.) (`dm') (`cdm') (.) (.)	/*
					*/ (.) (.) 			/*
					*/ (.) (.) (.) (.)		/*
					*/ (.) (.)			/*
					*/ (.) (.)
				
			}
		}
	}

end


program define _cnsVCE
	args vce1			/* name of VCE mat to convert from
					unconstrained to constrained*/
	tempname T a C R A IAR e_res b b2 v2 C2
	tempvar samp

	mat `v2' = `vce1'

	if "`e(cmd)'" == "svar" {
		local svar "_var"
	}	

	_getvarcns 
	local cnslist $T_VARcnslist 
	capture macro drop T_VARcnslist
	capture macro drop T_VARcnslist2

	if "`cnslist'" == "" {
		di as txt "no applicable constraints specified"
		exit
	}

	nobreak {
		_est hold `e_res', copy restore nullok varname(`samp')
		mat `b' = `vce1'[1,1...]
		mat `v2' = `vce1'
		eret post `b' `v2'
		`vv' mat makeCns `cnslist'
		mat `C' = get(Cns)
		capture _est unhold `e_res'
	}
	

	local cdim = colsof(`C')
	local cdim1 = `cdim' - 1


	matrix `R' = `C'[1...,1..`cdim1']

	matrix `A' = syminv(`R'*`vce1'*`R'')
	local a_size = rowsof(`A')

	local j = 1
	while `j' <= `a_size' {
		if `A'[`j',`j'] == 0 { 
			error 412 
		} 
		local ++j 
	}

	matrix `A' = `vce1'*`R''*`A'
	matrix `IAR' = I(colsof(`vce1')) - `A'*`R'
	matrix `vce1' = `IAR' * `vce1' * `IAR''

	constraint drop `cnslist'
end

program define PSaving, rclass
	capture syntax anything , [replace]
	if _rc > 0 {
		di as err "saving(`0') not valid"
		exit 198
	}	

	local fname `anything'
	local ireplace `replace'
	
	ret local fname "`fname'"
	ret local ireplace `replace'
end


exit


Note 1:

/* this is the old ado code  that has been replaced by
	the internal routine _sfevdstd() 
	the old ado-code is saved here as documentation for the internal
	routine  

begin old ado code
	mat `stdsfevd_m' = J(`eqs',`eqs', 0)
	local svarrow = 0
	forvalues svarj1 = 1/`eqs' {
		forvalues svarj2 = 1/`eqs' {
			local ++svarrow 

					forvalues svari4 = 0/`im1' {
mat `svarQ4i' = `svarI' # (`J'*`bigA'`svari4'*`J'')
mat `svarMID' = J(`eqs'*`eqs',1,0)	
forvalues svari5 = 0/`im1' {

						/// svarSIGHB is the 
						///  `svari4', `svari5' 
						///  sub-block of svarSIG(h)
						///  it is `eqs'^2 by `eqs'^2
						 

	mat `svarQ4j' = `svarI' # (`J'*`bigA'`svari5'*`J'')
	mat `svarSIGHB' =  `svarG'`svari4'*`V2'*`svarG'`svari5''	///
		 + `svarQ4i'*`svarSIG0'*`svarQ4j'' 

	mat `svarMID' = `svarMID' + 					///
		 `svarSIGHB'*(`svarZ'`svari5'[`svarrow',1...]')
}

mat `stdsfevd_m'[`svarj2',`svarj1'] = 				///
	 `stdsfevd_m'[`svarj2',`svarj1']    			///
	 + (`svarZ'`svari4'[`svarrow',1...])  * `svarMID'

					}

/// svarMID is now eqs^2 x 1 , svarZ svarMID yields stdsfevd_m 

		}
	}

end old ado code internalized in _sfevedstd()

Note 2:

/* this is the old ado code that has been internalized in the routine
	_fevdstd().  The old ado code is saved here as documentation for the 
	internal routine.

			forvalues j3=1(1)`eqs' {
				matrix `zp2a' =  `e'`j3'' * `phi'`im1' 
				matrix `zp2' =  `zp2a' * `sig_u'
				matrix `mse'[`j3',1] = `mse'[`j3',1] 
					 + `zp2' * `zp2a'' 
				
				matrix `z3'`j3'=`z3'`j3' 
					 +((`zp2') # `e'`j3'' ) * `G'`im1'

				matrix `z6'`j3' = `z6'`j3' + 
					 ( (`zp2a' ) # (`zp2a' ) )*`D'

				forvalues i3=1(1)`eqs' {
matrix `q2' =  ( `e'`j3'' * `theta'`im1' * `e'`i3' )
matrix `q2' = (`q2'[1,1] * `q2'[1,1]) 
matrix `omega_s'[`j3',`i3'] = `omega_s'[`j3',`i3'] + `q2'[1,1] 
matrix `omega'[`j3',`i3'] = `omega_s'[`j3',`i3'] / `mse'[`j3',1]



matrix `z1'=J(1,`k2p',0)
matrix `z2'=J(1,1,0)
matrix `z4'=J(1,`ksum',0)

forvalues h2=0(1)`im1' {

	matrix `zp0' = `e'`j3'' * `phi'`h2'
	matrix `zp1' = (`zp0' *`P'* `e'`i3')
	matrix `z1' = `z1' + ( `zp1'* 
		 ((`e'`i3'' * `P'')#(`e'`j3'')) )*`G'`h2'
	matrix `z2' = `z2' + `zp1'* `zp1'
	matrix `z4' = `z4'+ `zp1' * 
		 ( (`e'`i3'') # (`zp0') ) * `H'

}
matrix `d' = (2/(`mse'[`j3',1]*`mse'[`j3',1]))*(`mse'[`j3',1] * `z1' 
	 - `z2'*`z3'`j3' )
matrix `dbar' = (2*`mse'[`j3',1]*`z4' - `z2' * `z6'`j3' ) 
	 / ( `mse'[`j3',1] * `mse'[`j3', 1] )

matrix `omegaerr'[`j3',`i3'] = `d'*`V2'*`d'' + `dbar'*`sigsig'*`dbar''

				}
				
			}

end section internalized in _fevdstd

