*! version 1.6.0  17apr2018
program define boxcox , eclass byable(recall)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm v0
	}
	else {
		local vv "version 8.1:"
		local mm rdu0
	}
	version 7.0, missing
	if _caller()<7 {
		if _by() { error 190 }
		boxcox_6 `0'
		exit
	}
						
	if replay() {
		if `"`e(cmd)'"' != "boxcox"  { error 301 }
		if _by() { error 190 }
		Display `0'
		exit
	}
	local cmdline : copy local 0

	syntax varlist(ts) [if] [in] [fweight iweight] /*
		*/ [,  NOLOg LOg ITERate( int 50000 ) MODEL(string)/*
		*/ noConstant LRTEST noLOGLR FROM(string) /*
		*/ NOTRans(varlist ts) GRaph SAVing(string) MEAN MEDian /*
		*/ Level(cilevel) GRVars LStart(real 1.0) /*
		*/ DELta(real 0.0 ) Zero(real 0.0 ) Generate(string)  * ] 

	tokenize `varlist'
	macro shift

	if "`*'`notrans'" == "" & "`constant'" != "" {
		di as err "no covariates specified"
		exit 198
	}	
	

	marksample touse 
	markout `touse' `notrans'

	tempname sig bvec

	global T_bvec `bvec'
	
	if "`loglr'" != "" {
		local loglr "nolog"
	}

	local its `iterate'	
	local iterate "iterate(`iterate')"

	mlopts mlopts, `options' `iterate'
	if `"`s(collinear)'"' != "" {
		di as err "option collinear not allowed"
		exit 198
	}
	local cns `s(constraints)'
	if "`cns'" != "" {
		local lrtest
	}

/* Old options */

	if `zero' != 0.0 {
		di as txt "zero() option is no longer supported --" /*
			*/ " set version < 7"
	}

	if `delta' != 0.0 {
		di as txt "delta() option is no longer supported -- " /*
			*/ "set version < 7"
	}
	
	if "`generate'" != "" {
		di as txt "generate() option is no longer supported -- " /*
			*/ "set version < 7"
	}
	
	if "`grvars'" != "" {
		di as txt "grvars option is no longer supported -- " /*
			*/ "set version < 7"
	}
	if "`graph'" != "" {
		di as txt "graph option is no longer supported -- " /*
			*/ "set version < 7"
	}
	if "`saving'" != "" {
		di as txt "saving() option is no longer supported -- " /*
			*/ "set version < 7"
	}
	if "`mean'" != "" {
		di as txt "mean option is no longer supported -- " /*
			*/ "set version < 7"
	}
	if "`median'" != "" {
		di as txt "median option is no longer supported -- " /*
			*/ "set version < 7"
	}



/* Determine Model */
	mparse, `model'
	local model "`s(model)'"

/* Set Globals from options */

	if "`weight'" != "" {
		tempvar wvar
		quietly gen double `wvar' `exp' if `touse' 
/* global T_wtexp "[`weight'=`wvar']"  */
		global T_wtexp "[`weight'=`wvar']"
	}
	else {
		global T_wtexp 
	}

      	global T_nocns "`constant'"


/* make global names of transformed variables */
/* perhaps reset `model' */

	tokenize `varlist'

	local dep "`1'"
	global T_dep="`dep'"
	macro shift

	global T_parm ""
	local T_i 1

	while "`1'" ~= "" { 
		if "`model'"=="lhsonly" {
			local notrans `notrans' `1'
		}	
		else {
			global T_parm  $T_parm `1'
			local T_i=`T_i'+1
		}
		macro shift
	}

	if `T_i'==1 {
		if "`model'" != "lhsonly" {
			di as err "Model not identified"
			di as err "No transformed variables leaves lambda " /*
			*/ "unidentified"
			di as err "Specify lhsonly model or transformed " /*
			*/ "variables"
			exit 102
		}
	}
	global T_notr `notrans'	

/* check for collinear variables */


	_rmcoll $T_parm $T_notr
	global T_notr `r(varlist)'
	tokenize $T_parm
	global T_parm
	local i 1
	while "``i''" != "" {
		global T_notr : subinstr global T_notr "``i''" "" , /*
			*/ word count(local ct)
		if `ct' { 
			global T_parm $T_parm ``i'' 
		}
		local i = `i' + 1
	}
	

/* would remove collinearity separately -- historical
	if "$T_parm" != "" {
		_rmcoll($T_parm)
		global T_parm `r(varlist)'
	}

	if "$T_notr" != "" {
		_rmcoll($T_notr)
		global T_notr `r(varlist)'
	}
*/

	

/*	exit with error if an observation is <=0 */

	tokenize `varlist'
	if "`model'"=="lhsonly" {
		ChkVar `1' `touse'
	}
	else {
		if "`model'"=="rhsonly" {
			mac shift
		}
		while "`1'" != "" {
			ChkVar `1' `touse'
			mac shift 
		}
	}




/* IF THIS IS A RHS ONLY MODEL DO IT HERE AND EXIT */
	if "`model'" =="rhsonly"  {
		tempname bvec bvec2 sig_r
		global T_bvec `bvec2'
		global T_sig `sig_r'

/* if there is a constant, do constant only model  */
		if "$T_nocns" == "" {
			tempvar err1  sig1 llft 
			tempname LL0
			quietly {
			
				regress `dep' if `touse' $T_wtexp
				predict double `err1', residual
				replace `err1'=`err1'*`err1'

				*summ `err1' $T_wtexp if `touse', meanonly
				*scalar `sig1'=r(mean)
						/* -summarize- does not allow
						   iweights, so use -regress-
						   with constant-only model 
						*/
				reg `err1' $T_wtexp if `touse'
				scalar `sig1' = _b[_cons]

				gen double `llft'=-.5*(1+ln(2*_pi)+ln(`sig1'))
				*summ `llft' $T_wtexp if `touse', meanonly
				*scalar `LL0'=r(sum)
				reg `llft' $T_wtexp if `touse'
				scalar `LL0' = _b[_cons]*e(N)
			}
			local  df0 2
		}

		if "`from'" != "" {
			local start "init(`from')"
		}
		else {
			if "`lstart'" != "" {
				local start "init(`lstart', copy)"
			}
		}
		di as txt _n "Fitting full model"
	
		#delimit ;
		`vv'
		ml model `mm'  "boxco_l RHS" (lambda: `dep' = ) 
			if  `touse'  $T_wtexp, technique(nr) search(off)
			`start' `mlopts' `log' `nolog'
			max  ;
		#delimit cr
		tempname llf bf Vf bpar lsig
		scalar `llf' = e(ll)
		local ic=e(ic)
		local rc=e(rc)
		local wt "`e(wtype)'"
		local wex "`e(wexp)'"
	
		matrix `Vf'=e(V)
		matrix `bpar'=e(b)

/* make call to evaluator with converged lambda */
		global ML_y1 `dep'
		global ML_samp `touse'
		
		tempname lamc bc
		matrix `bc'=e(b)
		scalar `lamc'=`bc'[1,1]

		tempvar lltmp
		gen double `lltmp' = 0
		boxco_l RHS `lltmp' `bc' `lltmp'
	
		matrix `bf'=$T_bvec
		scalar `lsig'=$T_sig
		macro drop ML_y1 
		macro drop ML_samp
		

/* Do LR tests lambda=-1,0,1 */
		tempname ll_t0 chit0 p_t0 ll_t1 chit1 p_t1 
		tempname ll_tm1 chitm1 p_tm1
  
		lincompR `ll_t1'  `touse' /* program for computing LL 
						when lam=1*/
		scalar `chit1'=2*(`llf'-`ll_t1')
		scalar `p_t1'=1-chi2(1, `chit1')

				
		invcompR `ll_tm1' `touse' /* program for computing LL 
						when lam=-1 */
		scalar `chitm1'=2*(`llf'-`ll_tm1')
		scalar `p_tm1'=1-chi2(1, `chitm1')
	
		logcompR  `ll_t0' `touse' /* program for computing LL 
						when lam=0 */
		scalar `chit0'=2*(`llf'-`ll_t0')
		scalar `p_t0'=1-chi2(1, `chit0')

		if "`lrtest'" != ""	{
			di as txt _n "Fitting comparison models for LR tests"
			local firstlr 1

			local notr "$T_notr"
			local parm "$T_parm"

			tempname lltr pv p chi2 df
	
			
			tokenize $T_notr
			while "`1'" != "" {
				global T_notr : subinstr global T_notr /*
					*/ "`1'" "", word
	
				#delimit ;
				`vv'
				ml model `mm'  "boxco_l RHS" 
					(lambda: `dep' = ) 
					if `touse'  $T_wtexp, technique(nr) 
					search(off) `mlopts'  nocnsnotes
					`start'  max `loglr' ;
				#delimit cr
		
				scalar `lltr'=2*(`llf'-e(ll))	
				scalar `pv' = 1-chi2(1, `lltr' )
				matrix `chi2' = nullmat(`chi2') ,	/*
					   */ cond(`lltr'>=., -1, `lltr')
				matrix `p' = nullmat(`p') , 		/*
					*/ cond(`pv'>=., -1, `pv')
				matrix `df' = nullmat(`df') , 1
			
				local pname " `pname' `1'"
				local pcol " `pcol' Notrans "

				local c2name " `c2name' `1'"
				local c2col " `c2col' Notrans "

				global T_notr "`notr'"
				macro shift
			}

			local n : word count $T_parm

			tokenize $T_parm

			while "`1'" != "" {
				global T_parm : subinstr global T_parm /*
					*/  "`1'" "", word
				if `n'==1 {
					di as txt _n /*
					   */ "Comparison model for LR " /*
					   */ "test on `1' is a linear " /*
					   */ "regression."	
					di as txt "Lambda is not identified " /*
					   */ "in the restricted model."

					quietly {
regress `dep' $T_notr if `touse' $T_wtexp, $T_nocns
tempvar err llf2
tempname sigmat llt
predict double `err', residuals
replace `err'=`err'^2
*summ `err' if `touse' $T_wtexp, meanonly  
*scalar `sigmat'=r(mean)
reg `err' if `touse' $T_wtexp
scalar `sigmat' = _b[_cons]

gen double `llf2'=-.5*(1 + ln(2*_pi)+ ln(`sigmat') ) if `touse'
*summ `llf2' $T_wtexp if `touse'
*scalar `llt'  =r(sum)
reg `llf2' $T_wtexp if `touse'
scalar `llt'  = _b[_cons]*e(N)
est scalar ll = `llt'

local dfs 2
					}
				}
				else {
					#delimit ;
					`vv'
					ml model `mm'  "boxco_l RHS" 
						(lambda: `dep'= )
						if  `touse'  $T_wtexp, 
						technique(nr) search(off)
						`mlopts' nocnsnotes
						`start'  max `loglr' ;
					#delimit cr
					local dfs 1
				}

				scalar `lltr'=2*(`llf'-e(ll))

				scalar `pv' = 1-chi2(`dfs', `lltr' )
			
				matrix `chi2' = nullmat(`chi2') ,	/*
					   */ cond(`lltr'>=., -1, `lltr')
				matrix `p' = nullmat(`p') , 		/*
					*/ cond(`pv'>=., -1, `pv')
				matrix `df' = nullmat(`df') , 1
			
				local pname " `pname' `1'"
				local pcol " `pcol' Trans "

				local c2name " `c2name' `1'"
				local c2col " `c2col' Trans "

			
				global T_parm "`parm'"
				macro shift
			}

			matrix colnames `p'= `pname'
			matrix coleq `p' = `pcol'

			matrix colnames `chi2'= `c2name'
			matrix coleq `chi2' = `c2col'

			matrix colnames `df'= `c2name'
			matrix coleq `df' = `c2col'
		}

/* CALL POST PROGRAM */	
		BasePost `touse' "`model'" `bf' `Vf' `bpar' `lsig'

		if "`lrtest'" != "" {		
			est matrix chi2m `chi2'
			est matrix pm `p'
			est matrix df `df'
		}

		if "$T_nocns" == "" & "`cns'" == "" {
			tempname llt
			scalar `llt'=2*(`llf'-`LL0')
			est scalar ll0=`LL0'
			est scalar df_r=`df0'
			est scalar chi2=`llt'
		}

		est scalar ll=`llf'

		est scalar chi2_t1=`chit1'
		est scalar p_t1 =`p_t1'
		est scalar ll_t1=`ll_t1'

		est scalar chi2_tm1=`chitm1'
		est scalar p_tm1 =`p_tm1'
		est scalar ll_tm1=`ll_tm1'

		est scalar chi2_t0=`chit0'
		est scalar p_t0 =`p_t0'
		est scalar ll_t0=`ll_t0'
	
		est scalar ic=`ic'
		est scalar rc=`rc'
/*	est local wtype="`wt'" */
		est local wtype="`weight'"
		if "`wt'" != "" {
			est local wexp="`exp'"
		}
		est local depvar  "`dep'"
		est local lrtest "`lrtest'"
		est local chi2type "LR"
		est local predict "boxcox_p"
		est local model  "`model'"
		if "`ntrans'"=="" & "$T_nocns" != "" {
			est local ntrans 
		}
		else 	est local ntrans "yes"
		_post_vce_rank

		version 10: ereturn local cmdline `"boxcox `cmdline'"'
		est local marginsnotok _ALL
		est local cmd "boxcox"
		macro drop T_*

/* Call display programs */
		Display, level(`level')
		exit

	}
/* END RHS ONLY MODEL */	


/* ESTIMATE COMPARISON MODEL, If there is a constant in the model  */

	if "$T_nocns" == "" & `its' > 0 {
		di as txt "Fitting comparison model"

		tempname bvec1 LL0
		matrix `bvec1'=1
	
		`vv' ///
		ml model `mm' "boxco_l ConsOnly" ( `dep' = ) /*
		    */    if  `touse'  $T_wtexp, technique(nr)  search(off) /*
		    */  init(1, copy)   max noheader `log' `nolog'

		scalar `LL0'=e(ll)
		local df0 3
	}


/* IF THIS IS A LEFT HAND SIDE ONLY MODEL DO IT HERE  */

	if "`model'" == "lhsonly" {
		tempname btvec bvec
		global T_bvec "`btvec'"

	 	/* get starts */


		if "`from'" != "" {
			local start "init(`from')"
		}
		else {
			if "`lstart'" != "" {
				local start "init(`lstart', copy)"
			}
		}
	
		di as txt _n "Fitting full model"

		#delimit ;
		`vv'
		ml model `mm' "boxco_l LHS" (ntrans: `dep' = ) 
		     if  `touse'  $T_wtexp, technique(nr)
  		    `mlopts' `log' `nolog' search(off)
		     `start'   max  ; 
		#delimit cr

/* Save off value of LL and other values of interest */

		tempname llf lsig
		scalar `llf'=e(ll)

		local ic=e(ic)
		local rc=e(rc)
		local wt "`e(wtype)'"
		local wex "`e(wexp)'"
	
		tempname bf Vf bpar

		matrix `Vf'=e(V)
		matrix `bpar'=e(b)

/* make call to evaluator with converged lambda */
		global ML_y1 `dep'
		global ML_samp `touse'
		
		tempname lamc bc
		matrix `bc'=e(b)
		scalar `lamc'=`bc'[1,1]

		tempvar lltmp
		gen double `lltmp' = 0
		boxco_l LHS `lltmp' `bc' `lltmp'
	
		matrix `bf'=$T_bvec
		macro drop ML_y1 
		macro drop ML_samp
		scalar `lsig' = $T_sig
		
/* Do LR tests theta=-1,0,1 in LHS model */
		tempname ll_t1 chit1 p_t1 ll_tm1 chitm1 p_tm1 
		tempname ll_t0 chit0 p_t0

		lincompL `ll_t1'  `touse' /* program for computing LL 
						when theta=1*/
		scalar `chit1'=2*(`llf'-`ll_t1')
		scalar `p_t1'=1-chi2(1, `chit1')

				
		invcompL `ll_tm1' `touse' /* program for computing LL 
						when theta =-1 */
		scalar `chitm1'=2*(`llf'-`ll_tm1')
		scalar `p_tm1'=1-chi2(1, `chitm1')
	
		logcompL  `ll_t0' `touse' /* program for computing LL 
						when theta =0 */
		scalar `chit0'=2*(`llf'-`ll_t0')
		scalar `p_t0'=1-chi2(1, `chit0')

/* Do LR tests if requested */

		if "`lrtest'" != "" {
			tempname p chi2 df
			di _n as txt "Fitting comparison models for LR tests"

			local firstlr 1

			local notr "$T_notr"
			local parm "$T_parm"

			tempname lltr pv
	
			tokenize $T_notr
			while "`1'" != "" {
				global T_notr : subinstr global T_notr /*
					*/ "`1'" "", word
	
				#delimit ;
				`vv'
				ml model `mm' "boxco_l LHS" 
					(ntrans: `dep' = ) 
					if  `touse'  $T_wtexp, technique(nr) 
					search(off) `mlopts' 
					`start'  max `loglr' ;
				#delimit cr

				scalar `lltr'=2*(`llf'-e(ll))	
				scalar `pv' = 1-chi2(1, `lltr' )

				matrix `chi2' = nullmat(`chi2') ,	/*
					   */ cond(`lltr'>=., -1, `lltr')
				matrix `p' = nullmat(`p') , 		/*
					*/ cond(`pv'>=., -1, `pv')
				matrix `df' = nullmat(`df') , 1

				local pname `pname' `1'
				local pcol `pcol' Notrans

				local c2name `c2name' `1'
				local c2col `c2col' Notrans

				global T_notr "`notr'"
				macro shift
			}

			tokenize $T_parm
			while "`1'" != "" {
				global T_parm : subinstr global /* 
					*/ T_parm "`1'" "", word

				#delimit ;
				`vv'
				ml model `mm'  "boxco_l LHS" 
					(ntrans: `dep' = ) 
					if  `touse'  $T_wtexp, technique(nr) 
					search(off) `mlopts' 
					`start'  max `loglr' ;
				#delimit cr
				

				scalar `lltr'=2*(`llf'-e(ll))
				scalar `pv' = 1-chi2(1, `lltr' )

				matrix `chi2' = nullmat(`chi2') ,	/*
					   */ cond(`lltr'>=., -1, `lltr')
				matrix `p' = nullmat(`p') , 		/*
					*/ cond(`pv'>=., -1, `pv')
				matrix `df' = nullmat(`df') , 1
				
				local pname `pname' `1'
				local pcol `pcol' Notrans

				local c2name `c2name' `1'
				local c2col `c2col' Notrans

				global T_parm "`parm'"
				macro shift
			}
			matrix colnames `p'= `pname'
			matrix coleq `p' = `pcol'

			matrix colnames `chi2'= `c2name'
			matrix coleq `chi2' = `c2col'

			matrix colnames `df'= `c2name'
			matrix coleq `df' = `c2col'
		}

/* CALL POST PROGRAM */	
		BasePost `touse' "`model'" `bf' `Vf' `bpar' `lsig'

		if "`lrtest'" != "" {		
			est matrix chi2m `chi2'
			est matrix pm `p'
			est matrix df `df' 
		}


		if "$T_nocns" == "" & "`LL0'" != ""  {
			local llt=2*(`llf'-`LL0')
			est scalar ll0=`LL0'
			est scalar df_r=`df0'
			est scalar chi2=`llt'
		}

		est scalar ll=`llf'

		est scalar chi2_t1=`chit1'
		est scalar p_t1 =`p_t1'
		est scalar ll_t1=`ll_t1'

		est scalar chi2_tm1=`chitm1'
		est scalar p_tm1 =`p_tm1'
		est scalar ll_tm1=`ll_tm1'

		est scalar chi2_t0=`chit0'
		est scalar p_t0 =`p_t0'
		est scalar ll_t0=`ll_t0'

		est scalar ic=`ic'
		est scalar rc=`rc'
/* est local wtype="`wt'" */
		est local wtype="`weight'"
		if "`wt'" != "" {
			est local wexp="`exp'"
		}

		est local depvar "`dep'"
		est local lrtest "`lrtest'"
		est local chi2type "LR"
		est local predict  "boxcox_p"
		est local model  "`model'"

		if "`ntrans'"=="" & "$T_nocns" != "" {
			est local ntrans ""
		}
		else 	est local ntrans "yes"
		_post_vce_rank

		version 10: ereturn local cmdline `"boxcox `cmdline'"'
		est local marginsnotok _ALL
		est local cmd "boxcox"
		macro drop T_*

		Display, level(`level')
		exit
	}
/* END LHS ONLY MODEL */

/* THIS SECTION DOES FULL MODEL WITH COMMON LAMBDA OR
		LAMBDA ON THE RHS AND THETA ON THE LHS */

	tempname bvec bvec2 sig
	global T_bvec "`bvec'" 
	global T_sig  "`sig'"	 /* use the globals to work on
					the matrix and the scalar in the 
					evaluator program */

	if "`model'" == "theta" {
		local lrhs "/theta"
		local evalpgm "Theta"
	}
	else {
		local evalpgm "Lambda"
	}

/* Get starts for full model */

	if `lstart' != 1 {
		di as txt "lstart only valid for LHS or RHS model" /*
		*/ "--option ignored"
	}
	
	if "`from'" != "" {
		local starts  "init(`from')"
	}
	else {
		if "`model'"=="theta" {
		   	matrix `bvec'= (1, 1)
 		}
    		else {
	   		matrix `bvec'= 1
    		}
	
		local starts "init(`bvec', copy)"
	}

	di as txt _n "Fitting full model"

	`vv' ///
 	ml model `mm' "boxco_l `evalpgm'" (ntrans: `dep' = ) /*
		*/  `lrhs' if  `touse'  $T_wtexp, technique(nr)  /*
  		*/ search(off) `mlopts' /* 
		*/ `starts'   max  `log' `nolog'

	tempname llf bf Vf bpar lsig
	scalar `llf' = e(ll)

	local ic=e(ic)
	local rc=e(rc)
	local wt "`e(wtype)'"
	local wex "`e(wexp)'"

	matrix `Vf'=e(V)
	matrix `bpar'=e(b)

/* make call to evaluator with converged lambda */
	global ML_y1 `dep'
	global ML_samp `touse'
		
	tempname lamc bc
	matrix `bc'=e(b)

	tempvar lltmp
	gen double `lltmp' = 0
	boxco_l `evalpgm' `lltmp' `bc' `lltmp'
	
	matrix `bf'=$T_bvec
	scalar `lsig' = $T_sig

	macro drop ML_y1
	macro drop ML_samp

/* Do LR tests lambda=theta=-1,0,1  Note Lambda and Theta 
	models have same restricted LL in this case  */

	tempname chit1 p_t1 chitm1 p_tm1 chit0 p_t0 ll_t1 ll_tm1 ll_t0

	lincompT `ll_t1'  `touse' /* program for computing LL 
						when theta=1*/
	scalar `chit1'=2*(`llf'-`ll_t1')
	scalar `p_t1'=1-chi2(1, `chit1')

	invcompT `ll_tm1' `touse' /* program for computing LL 
						when theta=-1 */
	scalar `chitm1'=2*(`llf'-`ll_tm1')
	scalar `p_tm1'=1-chi2(1, `chitm1')
	
	logcompT  `ll_t0' `touse' /* program for computing LL 
						when theta =0 */
	scalar `chit0'=2*(`llf'-`ll_t0')
	scalar `p_t0'=1-chi2(1, `chit0')

	if "`lrtest'" != ""	{

		di _n as txt "Fitting comparison models for LR tests"
		tempname p chi2 df

		local firstlr 1

		local notr "$T_notr"
		local parm "$T_parm"

		tempname lltr pv
	
		tokenize $T_notr
		while "`1'" != "" {
			global T_notr : subinstr global T_notr /*
				*/  "`1'" "", word
	
			#delimit ;
			`vv'
			ml model `mm' "boxco_l `evalpgm'" 
				(ntrans: `dep' = ) `lrhs'
				if  `touse'  $T_wtexp, technique(nr) 
				search(off) `mlopts' 
				`start'  max `loglr' ;
			#delimit cr
				
			scalar `lltr'=2*(`llf'-e(ll))
			scalar `pv' = 1-chi2(1, `lltr' )

			matrix `chi2' = nullmat(`chi2') ,	/*
				   */ cond(`lltr'>=., -1, `lltr')
			matrix `p' = nullmat(`p') , cond(`pv'>=., -1, `pv')
			matrix `df' = nullmat(`df') , 1

			local pname `pname' `1'
			local pcol `pcol' Notrans

			local c2name `c2name' `1'
			local c2col `c2col' Notrans
				
			global T_notr "`notr'"
			macro shift
		}

		local n : word count $T_parm
		
		tokenize $T_parm
		while "`1'" != "" {
			global T_parm : subinstr global /*
				*/  T_parm "`1'" "", word

			if `n'==1  & "`model'"=="theta" {
				di as txt _n "Comparison model " /*
					*/ "for `1' is left-hand " /*
					*/ "side only."
				di as txt "Lambda is not " /*
					*/ "identified in the "
				di as txt "restricted model."

				local dfs 2 
				#delimit ;
				`vv'
				ml model `mm' "boxco_l LHS" 
					(ntrans: `dep' = ) if  `touse'
					$T_wtexp, technique(nr) 
					search(off) `mlopts' 
					`start'  max `loglr' ;
				#delimit cr
			}
			else {
				local dfs 1 
				#delimit ;
				`vv'
				ml model `mm'  "boxco_l `evalpgm'"
					(ntrans: `dep' = ) 
					`lrhs' if  `touse'  
					$T_wtexp, technique(nr) 
					search(off) `mlopts' `start'  
					max `loglr' ;
				#delimit cr
			}

			scalar `lltr'=2*(`llf'-e(ll))
			scalar `pv' = 1-chi2(`dfs', `lltr' )

			matrix `chi2' = nullmat(`chi2') ,	/*
				   */ cond(`lltr'>=., -1, `lltr')
			matrix `p' = nullmat(`p') , cond(`pv'>=., -1, `pv')
			matrix `df' = nullmat(`df') , 1

			local pname `pname' `1'
			local pcol `pcol' Notrans

			local c2name `c2name' `1'
			local c2col `c2col' Notrans
			
			global T_parm "`parm'"
			macro shift
		}
		matrix colnames `p'= `pname'
		matrix coleq `p' = `pcol'

		matrix colnames `chi2'= `c2name'
		matrix coleq `chi2' = `c2col'

		matrix colnames `df'= `c2name'
		matrix coleq `df' = `c2col'

	}

/* CALL POST PROGRAM */	
	BasePost `touse' "`model'" `bf' `Vf' `bpar' `lsig'

	if "`lrtest'" != "" {		
		est matrix chi2m `chi2'
		est matrix pm `p'
		est matrix df `df'
	}

	if "$T_nocns" == "" {
		local llt=2*(`llf'-`LL0')
		est scalar df_r=`df0'
		est scalar chi2=`llt'
		est scalar ll0=`LL0'
	}


	est scalar ll=`llf'
	est scalar chi2_t1=`chit1'
	est scalar p_t1 =`p_t1'
	est scalar ll_t1=`ll_t1'

	est scalar chi2_tm1=`chitm1'
	est scalar p_tm1 =`p_tm1'
	est scalar ll_tm1=`ll_tm1'

	est scalar chi2_t0=`chit0'
	est scalar p_t0 =`p_t0'
	est scalar ll_t0=`ll_t0'

	est scalar ic=`ic'
	est scalar rc=`rc'
/* est local wtype="`wt'" */
	est local wtype="`weight'"
	if "`wt'" != "" {
		est local wexp="`exp'"
	}
	est local depvar "`dep'"
	est local lrtest "`lrtest'"
	est local chi2type "LR"
	est local predict  "boxcox_p"

	if "`ntrans'"=="" & "$T_nocns" != "" {
		est local ntrans ""
	}
	else {
		est local ntrans "yes"
	}	
	_post_vce_rank	

	version 10: ereturn local cmdline `"boxcox `cmdline'"'
	est local model  "`model'"
	est local marginsnotok _ALL
	est local cmd "boxcox"

	macro drop T_*

/* Call display programs */
	Display, level(`level')
end


program define mparse, sclass
	sret clear
	syntax, [LHSonly RHSonly LAMbda THETA ]
	
	if "`lhsonly'`rhsonly'`lambda'`theta'" == "" {
		sret local model "lhsonly"
	}
	else {
		local sum =  ("`lhsonly'" != "") + ("`rhsonly'" != "") /* 
			*/ + ("`lambda'" != "") + ("`theta'" != "") 
		if `sum' > 1 {
			di as err /*
*/ "model specifications are mutually exclusive:  specify only one model"
			exit 198
		}
		sret local model "`lhsonly'`rhsonly'`lambda'`theta'"
	}
end

program define bhead
	di
	tempname p
	local dft= e(df_m)-e(df_r)
	#delimit ;
	di _col(51) as txt "Number of obs"  _col(67) "= " _col(68) 
		 %10.0gc as res e(N);
	di _col(51) as txt "LR chi2(" as res `dft' as txt ")" 
		_col(67) "=" _col(69) %10.2f as res e(chi2);
	scalar `p' = 1-chi2(`dft',e(chi2) );
	di as txt "Log likelihood = " as res e(ll) _col(51) as txt "Prob > chi2" 
		_col(67) "=" _col(69) as res %10.3f `p';
	di " ";
	#delimit cr
end

program define btitle
	args level
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	#delimit ;
	di as txt "{hline 13}{c TT}{hline 64}" ;
	di %12s as txt abbrev("`e(depvar)'",12) " {c |}"
		as txt _col(12) "      Coef.   Std. Err.      z    P>|z|"
		_col(`=61-`cil'') `"[`=strsubdp("`level'")'% Conf. Interval]"';
	di as txt "{hline 13}{c +}{hline 64}" ;
	#delimit cr
end

program define cdisp
	di as txt "{hline 13}{c BT}{hline 64}"
	di " "
	di as txt "Estimates of scale-variant parameters"
	di as txt "{hline 13}{c TT}{hline 14}
	di as txt _col(14) "{c |}      Coef." 
	
	tempname b
	matrix `b'=e(b)
	local eqs : coleq `b'
	local names : colnames `b'
	local cnt 1
	tokenize `eqs'
	if "`1'" == "Notrans" {
		di as txt "{hline 13}{c +}{hline 14}"
		di as res "Notrans" _col(14) as txt "{c |}"
	}
	while "`1'" == "Notrans" {
		local coef :  word `cnt' of `names'
		di as txt %12s abbrev("`coef'",12)  " {c |}  "  /*
			*/ as res %9.0g `b'[1,`cnt']
		local cnt = `cnt' +1
		macro shift
	}
	
	if "`1'" == "Trans" {
		di as txt "{hline 13}{c +}{hline 14}"
		di as res "Trans" _col(14) as txt "{c |}"
	} 
	while "`1'" == "Trans" {
		local coef :  word `cnt' of `names'
		di as txt %12s abbrev("`coef'",12) " {c |}  " /*
			*/ as res %9.0g `b'[1,`cnt']
		local cnt = `cnt' +1
		macro shift
	}
	while "`1'" != "sigma" {
		local cnt = `cnt' +1
		macro shift
	}
	if "`1'" == "sigma" {
		di as txt "{hline 13}{c +}{hline 14}"
		di as txt %12s "/sigma" " {c |}  " as res /*
			*/  %9.0g `b'[1,`cnt']
		di as txt "{hline 13}{c BT}{hline 14}"
	}
end

program define cdisplr
	di as txt "{hline 13}{c BT}{hline 64}"
	di " "
	di as txt "Estimates of scale-variant parameters"
	di as txt "{hline 13}{c TT}{hline 47}"
	di as txt _col(14) "{c |}      Coef." _col(27) /*
		*/ " chi2(df)" /*
		*/  _col(36) "  P>chi2(df)" /*
		*/ _col(52) "df of chi2"	
	tempname b chi p df
	matrix `b'=e(b)
	matrix `chi'=e(chi2m)
	matrix `p'=e(pm)
        matrix `df'=e(df)
	
	local eqs : coleq `b'
	local names : colnames `b'
	local cnt  1
	local pcnt 1
	tokenize `eqs'
	if "`1'" == "Notrans" {
		di as txt "{hline 13}{c +}{hline 47}"
		di as res "Notrans" _col(14) as txt "{c |}"
	}
	while "`1'" == "Notrans" {
		local coef :  word `cnt' of `names'
		if "`coef'" == "_cons"   {
			di as txt %12s abbrev("`coef'",12) " {c |}"  /*
				*/ _col(17) as res %9.0g `b'[1,`cnt'] 
		}
		else {
			di as txt %12s abbrev("`coef'",12) " {c |}  " /*
				*/ as res %9.0g `b'[1,`cnt'] " " %9.3f /*
				*/ `chi'[1,`pcnt']  "  " %7.3f /*
				*/ `p'[1,`pcnt'] _col(54) %2.0f `df'[1,`pcnt']
			local pcnt = `pcnt' +1
		}
		local cnt = `cnt' +1
		macro shift
	}


	if "`1'" == "Trans" {
		di as txt "{hline 13}{c +}{hline 47}"
		di as res "Trans" _col(14) as txt "{c |}"
	} 

	while "`1'" == "Trans" {
		local coef :  word `cnt' of `names'
		di as txt %12s abbrev("`coef'",12) " {c |}  "  /*
			*/ as res %9.0g `b'[1,`cnt'] " " %9.3f /*
			*/ `chi'[1,`pcnt']  " " %7.3f /*
			*/ `p'[1,`pcnt'] _col(54) %2.0f `df'[1,`pcnt']
		local cnt = `cnt' +1
		local pcnt = `pcnt' +1
		macro shift
	}
	while "`1'" != "sigma" {
		local cnt = `cnt' +1
		macro shift
	}
	if "`1'" == "sigma" {
		di as txt "{hline 13}{c +}{hline 47}"
		di as txt %12s "/sigma" _col(14) "{c |}  " /*
		*/  as res %9.0g `b'[1,`cnt']
		di as txt "{hline 13}{c BT}{hline 47}"
	}
end


program define BasePost, eclass
	args touse model bf Vf bpar lsig

	tempname b1 b V V1 newb

	matrix `b1'=`bf'

	local size = colsof(`b1')

	local eqnames ""
	local names ""
	local cnt 1
	local first 1


	tokenize $T_notr
	while "`1'" != "" {
		local eqnames `eqnames' Notrans
		local names `names' `1'
		if `first'==1 {
			matrix `newb'=`b1'[1,`cnt']
			local first 0
		}
		else 	matrix `newb'=`newb',`b1'[1,`cnt']
		macro shift 
		local cnt =`cnt' +1 
	}

	if "$T_nocns" == "" {
		local eqnames `eqnames' Notrans
		local names `names' _cons
		if `first'==1 {
			matrix `newb'=`b1'[1,`size']
			local first  0 
		}
		else 	matrix `newb'=`newb',`b1'[1,`size']
	}

	tokenize $T_parm
	while "`1'" != "" {
		local eqnames `eqnames' Trans
		local names `names' `1'
		if `first'==1 {
			matrix `newb'=`b1'[1,`cnt']
			local first 0
		}
		else 	matrix `newb'=`newb',`b1'[1,`cnt']
		macro shift 
		local cnt =`cnt' +1 
	}

	matrix colnames `newb' = `names'
	matrix coleq `newb' = `eqnames' 

	if "`model'"=="lhsonly" {
		local bparms "theta:_cons"	
	}

	if "`model'"=="rhsonly" | "`model'"=="lambda"  {
		local bparms "lambda:_cons"	
	}

	if "`model'"=="theta" {
		local bparms "lambda:_cons theta:_cons"	
	}

/* 	matrix `b1'=`bpar',sqrt($T_sig) */
 	matrix `b1'=`bpar',sqrt(`lsig')
	matrix colnames `b1'=  `bparms'  sigma:_cons
	matrix `b'=`newb',`b1'

	local nmes : colnames `b'
	local eqnames : coleq `b'

	local size = colsof(`b')

	matrix `V'=J(`size',`size',0)
	matrix `V1'=`Vf'

	if "`model'" != "theta" {
		matrix `V'[`size'-1,`size'-1]=`V1'[1,1]
	}
	else {
		local low = `size'-2
		local high=`size'-1
		matrix `V'[`low',`low']=`V1'[1,1]
		matrix `V'[`low',`high']=`V1'[1,2]
		matrix `V'[`high',`low']=`V1'[2,1]
		matrix `V'[`high',`high']=`V1'[2,2]
	}
	matrix colnames `V'=`nmes'
	matrix coleq `V' = `eqnames'

	matrix rownames `V' = `nmes'
	matrix roweq `V' = `eqnames'

	local df=colsof(`b')
	estimates post `b' `V', dep(`e(depvar)') obs(`e(N)') /*
		*/  esample(`touse') 

	est scalar df_m=`df'
end

program define lincompR
	args ll touse
	/* this program computes the value of the log likelihood for 
		the RHSONLY	model when lambda=1  
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse 
		*/
	
	tokenize $T_parm
	local i 1
	local trans "" 

	while "`1'" != "" {
		tempvar t`i'
		gen double `t`i''=`1'-1
		local trans `trans' `t`i''
		macro shift
		local i=`i' +1
	}

	quietly {
		regress $T_dep $T_notr `trans' if `touse' $T_wtexp, $T_nocns
		tempvar err llfv
		tempname sigmat
	
		predict double `err', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
   		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double `llfv' = -.5*(1+ln(2*_pi)+ ln(`sigmat')) if `touse'
		*summ `llfv' $T_wtexp, meanonly
		*scalar `ll'  =r(sum)
		reg `llfv' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
	}
end

program define invcompR
	args ll touse
	/* this program computes the value of the log likelihood
			for the RHSONLY model when lambda=-1  
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse */

	tokenize $T_parm
	local i 1
	local trans "" 

	while "`1'" != "" {
		tempvar t`i'
		gen double `t`i''=1-(1/`1')
		local trans `trans' `t`i''
		macro shift
		local i=`i' +1
	}


	quietly	 {
		regress $T_dep $T_notr `trans' if `touse' $T_wtexp, $T_nocns
		tempvar err llf
		tempname sigmat
	
		predict double `err', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double `llf'=-.5*(1 + ln(2*_pi)+ ln(`sigmat') ) if `touse'
		*summ `llf' $T_wtexp, meanonly
		*scalar `ll' = r(sum)
		reg `llf' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
	}
end

program define logcompR
	args ll touse
	/* this program computes the value of the log likelihood 
			for the RHSONLY model when lambda=0  
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse */

	
	tokenize $T_parm
	local i 1
	local trans "" 

	while "`1'" != "" {
		tempvar t`i'
		gen double `t`i''=ln(`1')
		local trans `trans' `t`i''
		macro shift
		local i=`i'+1
	}

	quietly	 {
		regress $T_dep $T_notr `trans' if `touse' $T_wtexp, $T_nocns
		tempvar err llf
		tempname sigmat
	
		predict double `err', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
   		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double `llf'= -.5*(1 + ln(2*_pi)+ ln(`sigmat') ) if `touse'
		*summ `llf' $T_wtexp, meanonly
		*scalar `ll'=r(sum)
		reg `llf' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
	}
end




program define lincompL
	args ll touse
	/* this program computes the value of the log likelihood for 
			the LHSONLY	model when theta=1  
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse */

	quietly	{
		regress $T_dep $T_notr  if `touse' $T_wtexp, $T_nocns
		tempvar err llf
		tempname sigmat 
	
		predict double `err', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
   		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double `llf'=-.5*(1 + ln(2*_pi)+ ln(`sigmat') ) if `touse'
		*summ `llf' $T_wtexp, meanonly
		*scalar `ll'  =r(sum)
		reg `llf' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
	}
end

program define invcompL
	args ll touse
	/* this program computes the value of the log likelihood
			for the LHSONLY model when theta=-1  
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse */

	tempvar yt

	quietly {
		gen double `yt'=1-(1/$T_dep) if `touse'
		regress `yt' $T_notr  if `touse' $T_wtexp, $T_nocns
		tempvar err llf
		tempname sigmat 
	
		predict double `err', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
   		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double `llf' = -.5*(1 + ln(2*_pi)+ ln(`sigmat') ) /*
			*/ -2*ln($T_dep) if `touse'
		reg `llf' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
		*summ `llf' $T_wtexp , meanonly 
		*scalar `ll' = r(sum)
	}
end

program define logcompL
	args ll touse
	/* this program computes the value of the log likelihood 
			for the LHSONLY model when theta=0  
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse */

	tempvar yt llf err
	tempname sigmat 

	quietly	 {
		gen double `yt'=ln($T_dep) if `touse'
		regress `yt' $T_notr if `touse' $T_wtexp, $T_nocns

		predict double `err', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
  		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double  `llf'  = -.5*(1 + ln(2*_pi)+ ln(`sigmat') ) /*
			*/  -ln($T_dep) if `touse'
		*summ `llf' $T_wtexp, meanonly 
		*scalar `ll'=r(sum)
		reg `llf' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
	}
end



program define lincompT
	args ll touse
	/* this program computes the value of the log likelihood for 
			the THETA model when theta=1 & lambda=1 
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse */

	tempvar yt
	
	tokenize $T_parm
	local i 1
	local trans "" 

	quietly { 
		gen double `yt'=$T_dep-1 if `touse'
		while "`1'" != "" {
			tempvar t`i'
			gen double `t`i''=`1'-1 if `touse'
			local trans "`trans' `t`i''"
			macro shift
			local i=`i' +1
		}
		regress $T_dep $T_notr  `trans' if `touse' $T_wtexp, $T_nocns
		tempvar err llf
		tempname sigmat 
	
		predict double `err' if `touse', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
   		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double `llf'=-.5*(1 + ln(2*_pi)+ ln(`sigmat') ) if `touse'
		*summ `llf' $T_wtexp, meanonly
		*scalar `ll'  =r(sum)
		reg `llf' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
	}
end

program define invcompT
	args ll touse
	/* this program computes the value of the log likelihood
			for the THETA model when theta=-1 and lambda= -1  
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse */

	tempvar yt 
	

	tokenize $T_parm
	local i 1
	local trans "" 

	quietly {
		gen double `yt'=1-(1/$T_dep) if `touse'
		while "`1'" != "" {
			tempvar t`i'
			gen double `t`i''=1-(1/`1') if `touse'
			local trans " `trans' `t`i'' "
			macro shift
			local i=`i' +1
		}

		regress `yt' $T_notr `trans'  if `touse' $T_wtexp, $T_nocns
		tempvar err llf
		tempname sigmat
	
		predict double `err' if `touse', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
   		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double `llf' = -.5*(1 + ln(2*_pi)+ /*
			*/ ln(`sigmat') )-2*ln($T_dep) if `touse'
		*summ `llf' $T_wtexp , meanonly 
		*scalar `ll' = r(sum)
		reg `llf' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
	}
end

program define logcompT
	args ll touse
	/* this program computes the value of the log likelihood 
			for the THETA model when theta=0 and lambda=0  
		arguments
			1 is name of scalar to hold restricted  LL
			2 is name of touse */

	tempvar yt llf err
	tempname sigmat 


	tokenize $T_parm
	local i 1
	local trans "" 

	quietly {
		gen double `yt'=ln($T_dep) if `touse'
		while "`1'" != "" {
			tempvar t`i'
			gen double `t`i''=ln(`1') if `touse'
			local trans " `trans' `t`i'' "
			macro shift
			local i=`i' +1
		}

		regress `yt' $T_notr `trans' if `touse' $T_wtexp, $T_nocns

		predict double `err' if `touse', residuals
		replace `err'=`err'^2
		*summ `err' if `touse' $T_wtexp, meanonly  
  		*scalar `sigmat'=r(mean)
		reg `err' if `touse' $T_wtexp
		scalar `sigmat' = _b[_cons]

		gen double  `llf'  = -.5*(1 + ln(2*_pi)+ ln(`sigmat') )/*
			*/  -ln($T_dep) if `touse'
		*summ `llf' $T_wtexp, meanonly 
		*scalar `ll'=r(sum)
		reg `llf' if `touse' $T_wtexp
		scalar `ll' = _b[_cons]*e(N)
	}
end


program define lrdispR
	di
	di as txt "{hline 57}"
	di as txt _col(4) "Test" _col(17) "Restricted" _col(32) /* 
		*/ "LR statistic"  _col(50) "P-value"
	di  as txt _col(5) "H0:"  _col(15) "log likelihood" _col(36) "chi2" /*
		*/ _col(47) "Prob > chi2"
	di as txt "{hline 57}"
	di as txt "lambda = -1" _col(17)  %10.0g as res e(ll_tm1) /* 
		*/ _col(32)  as res %8.2f e(chi2_tm1) /*
		*/  _col(51) %5.3f as res e(p_tm1)

	di as txt "lambda =  0" _col(17) %10.0g as res e(ll_t0) /* 
		*/ _col(32) as res %8.2f e(chi2_t0) /*
		*/ _col(51)  %5.3f as res e(p_t0)

	di as txt "lambda =  1" _col(17)  %10.0g as res e(ll_t1) /* 
		*/ _col(32) as res %8.2f e(chi2_t1) /*
		*/ _col(51)  %5.3f as res e(p_t1)
	di as txt "{hline 57}"
end

program define lrdispL
	di
	di as txt "{hline 57}"
	di as txt _col(4) "Test" _col(17) "Restricted" _col(32) /* 
		*/ "LR statistic"  _col(50) "P-value"
	di  as txt _col(5) "H0:"  _col(15) "log likelihood" _col(36) "chi2" /*
		*/ _col(47) "Prob > chi2"
	di as txt "{hline 57}"
	di as txt "theta = -1" _col(17)  %10.0g as res e(ll_tm1) /* 
		*/ _col(32)  as res %8.2f e(chi2_tm1) /*
		*/  _col(51) %5.3f as res e(p_tm1)

	di as txt "theta =  0" _col(17) %10.0g as res e(ll_t0) /* 
		*/ _col(32) as res %8.2f e(chi2_t0) /*
		*/ _col(51)  %5.3f  as res e(p_t0)

	di as txt "theta =  1" _col(17)  %10.0g as res e(ll_t1) /* 
		*/ _col(32) as res %8.2f e(chi2_t1) /*
		*/ _col(51)  %5.3f as res e(p_t1)
	di as txt "{hline 57}"
end

program define lrdispT
	di " "
	if "`e(model)'" == "lambda" {
		di as txt "{hline 57}"
		di as txt _col(4) "Test" _col(17) "Restricted" _col(32) /*
			*/ "LR statistic" /*
			*/  _col(50) "P-value"
		di as txt _col(5) "H0:"  _col(15) "log likelihood" /*
			*/  _col(36) "chi2" _col(47) "Prob > chi2"
		di as txt "{hline 57}"

		di as txt "lambda = -1" _col(17)  %10.0g as res e(ll_tm1) /* 
			*/ _col(32)  as res %8.2f e(chi2_tm1) /*
			*/  _col(51) %5.3f as res e(p_tm1)

		di as txt "lambda =  0" _col(17) %10.0g as res e(ll_t0) /* 
			*/ _col(32) as res %8.2f e(chi2_t0) /*
			*/ _col(51)  %5.3f as res e(p_t0)

		di as txt "lambda =  1" _col(17)  %10.0g as res e(ll_t1) /* 
			*/ _col(32) as res %8.2f e(chi2_t1) /*
			*/ _col(51)  %5.3f as res e(p_t1)
		di as txt "{hline 57}"
	}
	else {
		di as txt "{hline 63}"
		di as txt _col(4) "Test" _col(23) "Restricted" _col(38) 
			*/ "LR statistic"  _col(56) "P-value"
		di  as txt _col(5) "H0:"  _col(21) "log likelihood" /* 
			*/ _col(42) "chi2" _col(53) "Prob > chi2"
		di as txt "{hline 63}"

		di as txt "theta=lambda = -1" _col(23)  %10.0g as res /* 
			*/ e(ll_tm1) _col(38) as res %8.2f e(chi2_tm1) /*
			*/  _col(57) %5.3f as res e(p_tm1)

		di as txt "theta=lambda =  0" _col(23) %10.0g as res e(ll_t0) /* 
			*/ _col(38) as res %8.2f e(chi2_t0) /*
			*/ _col(57)  %5.3f as res e(p_t0)

		di as txt "theta=lambda =  1" _col(23)  %10.0g as res e(ll_t1)/* 
			*/ _col(38) as res %8.2f e(chi2_t1) /*
			*/ _col(57)  %5.3f as res e(p_t1)

		di as txt "{hline 63}"
	}

end


program define ChkVar
	args var touse
	qui count if `var'<=0 & `touse'
	if r(N) { 
		di as err /*
		*/ "`1' contains observations that are not strictly positive"
		exit 411
	}
end


program define Display
	syntax [, Level(cilevel)]

	bhead
	btitle `level'
	local level "level(`level')"
	if "`e(model)'"=="lambda" |"`e(model)'"=="rhsonly"   {
		_diparm lambda, `level'
	}
	if  "`e(model)'"=="theta" {
		_diparm lambda, `level'
		_diparm theta, `level'
	}
	if  "`e(model)'"=="lhsonly" {
		_diparm theta, `level'
	}

	if "`e(lrtest)'" != "" {
		cdisplr
	}
	else {
		cdisp
	}

	if "`e(model)'"=="rhsonly"   {
		lrdispR
	}
	if  "`e(model)'"=="lhsonly" {
		lrdispL
	}
	if "`e(model)'"=="lambda" |  "`e(model)'"=="theta" {
		lrdispT
	}
end
 
exit

Use of globals
--------------

	$T_bvec		name of matrix containing coefficient vector
	$T_wtexp 	"[fweight=`wvar']"
	$T_nocns	"" or "noconstant"
	$T_dep		name of dependent variable
	$T_parm		list of var names:  transformed variables
	$T_notr		list of var names:  nontransformed variables
	$T_sig		name of scalar containing value of sigma

Updates
-------

06/20/02	fixed iweights to take non-integer values (whg)
