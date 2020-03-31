*! version 3.8.4  09feb2015
program define _xtabond9, eclass sortpreserve byable(onecall) prop(xt)
	quietly query born
	if $S_1 < d(23may2002) {
		di as err "your Stata executable is out of date"
		di as err "    type -update executable- at the Stata prompt"
		exit 498
	}

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun xtabond, nojack noboot : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtabond `0'"'
		exit
	}
	version 7.0, missing

	if replay() {
		if "`e(cmd)'" != "xtabond" { error 301 } 
		if _by() { error 190 }
		syntax [, Level(cilevel) ]
		Disp `level'
		exit
	}	
	`BY' Estimate `0'
	version 10: ereturn local cmdline `"xtabond `0'"'
end

program Estimate, sortpreserve eclass byable(recall)
	syntax varlist(ts) [if] [in] , [LAgs(integer 1) Robust TWOstep /* 
		*/ noConstant ARtests(integer 2) /*
		*/ MAXLDep(integer 0) DIFFvars(string) INST(string) /* 
		*/ MAXLAGs(string ) zout(integer 0) SMall /*
		*/ Level(cilevel) VCE(passthru) * ]
		

	_vce_parse, opt(GMM Robust) old :, `vce' `robust'
	local robust `r(robust)'
	local vce = cond("`r(vce)'" != "", "`r(vce)'", "gmm")

	if "`twostep'" != "" & "`robust'" != "" {
		di as err "robust may not be specified with twostep"
		exit 198
	}

/* check that data is xtset */

	_xt, trequired

	qui xtset
	local id   `r(panelvar)'
	local t    `r(timevar)'
	local tmin `r(tmin)'
	local tmax `r(tmax)'
	tempname tsdelta
	scalar `tsdelta' = `: char _dta[_TSdelta]'

	local tvar `t'

	if `lags' > (`= (`tmax'-`tmin')/`tsdelta' - 1') {
		di as error /*
			*/ "too many lags of the dependent variable requested"
		di as error "lags() must be between 1 and " 		/*
			*/ (`= (`tmax'-`tmin')/`tsdelta' - 2')
		exit 198
	}	
/* complain if number of lags is < 0 */
	if `lags'<1 {
		di as err "lags of dependent variable must be >=1 "
		exit 198
	}	

/* only p+1 ar tests can be performed */	
	if `artests' > `lags' + 1 {
 	      di as err "Only the number of lags on depvar +1 AR tests allowed"
		exit 198
	}	

	if "`maxlags'" != "" {
		capture local check = (`maxlags' <= 0 )
		if _rc > 0 { 
			di as err "maxlags(`maxlags') not valid"
			exit 198
		}	
		if `maxlags'<=0 {
			di as err "maxlags must be > 0"
			exit 198
		}
	}
	else {
		local maxlags = `= (`tmax' -`tmin') / `tsdelta' '
	}	

	
	tempvar touse touseb
	mark `touse' `if' `in'
	markout `touse' `id' 

	if _by() {
		qui replace `touse' = 0 if `_byindex' != _byindex()
	}

	qui sum `touse' 
	if r(max) == 0 {
		di as err "no observations"
		exit 2000
	}	

	qui gen byte `touseb' = `touse'

	preserve
	tempvar orig
	qui gen byte `orig' =1
	tsfill, full


	sort `id' `t'
	qui replace `orig' =0 if `orig' >=.

	qui count if `t'>=.
	if r(N)>0 {
		di as err "no missing values in time variable (`t') allowed"
		exit 459
	}	

/* parse diffvars */
	if "`diffvars'" != "" {
		tsvars `diffvars'
		local diffvars "`r(varlist)'"
		_rmcoll `diffvars', `constant'
		local diffvars "`r(varlist)'"
		
	}	

/* parse instruments */
	if "`inst'" != "" {
		_rmcoll `inst', `constant'
		local inst "`r(varlist)'"
		local inst_o "`r(varlist)'"
		
/* inst_l is local list of instruments */

		local inst_l "`inst'"
		tsrevar `inst', substitute
		local inst "`r(varlist)'"
	}	


	if "`constant'" == "" {
		tempname cons1
		qui gen double `cons1'=1 if `touse'
	}

	local varlist "`varlist' "
	tokenize `varlist'
	local depvar `1'
	local depvar: subinstr local depvar "." ".", count(local legal)
	if `legal' > 0 {
		di as err "`depvar' invalid in this context"
		di as err /*
		*/"dependent variable may not contain time-series operators"
		exit 198
	}	
	macro shift 
	local indeps "`*'"
	local exog `indeps' 

	_rmcoll `exog', `constant'
	local exog "`r(varlist)'"

	
	if `lags' > 0 {
		tsvars L(1(1)`lags').`depvar' 
		local laglist "`r(varlist)'"
	}
	else {
		local laglist
	}	
/* parse out predetermined variables and their lag structures */

/* preM2 is a global name of matrix that holds the parameters for the 
	predetermined variable the structure of preM2 is 
		lags of variable in model, 
		maximum number of lags that can be used as instrument */

	tempname preM2 preM2b

// prelist contains [{pre_el} [{pre_el}]..[{pre_el}]}
// where pre_el is {varname} {rlags} {rmlags} {firstpl}
//  rlags is the number of lags of the predetermined 
//        variable in the model 
//  rmlags is the number of lags that can be used as instruments for the
//        the predetermined variables
//  firstpl is the minimum lag that can be included in as instrument minus 1, 
//        i.e.,  firstpl = first + rlags, 
//    		where first=0 if predetermined and first=1 if endogenous
	
	while "`options'" != "" {
		local 0 ",`options'"
		syntax [, PRE(string) * ]
		if "`pre'" == "" {
			di as err " `options' invalid"
			exit 198
		}	

		local tmp : subinstr local pre "," ",", all 	/*
			*/ count(local ncommas)	

		if `ncommas' == 0 {
			local mycomma ","
		}
		else {
			local mycomma 
		}

		pre_p `pre' `mycomma' exog(`exog' `diffvars')	/*
			*/ prevs(`prevs') `constant'

		local rprelist "`r(pre)'"

		if "`rprelist'" != "" {
			local prevs "`prevs' `rprelist'"
		
			local firstpl = r(first)			
		
			if r(lags)>=.	{
				local rlags 0
			}	
			else {
				local rlags = r(lags)
			}
		
			if r(maxlags)>=.  {
				local rmlags =  `maxlags' 
			}	
			else {
				local rmlags = r(maxlags) 
			}	

			if `rlags' < 0 {
di as err "Lags of predetermined variables must be >= 0"
exit 198 
			}	
			if `rmlags' < 1 {
				di as err "Max number of instruments for "/*
			 	    */ "predetermined variables must be >= 1 "
				exit 198
			}	
		
			local prelist "`prelist'`rprelist',"	
			local prelist "`prelist' `rlags' `rmlags' `firstpl':"

			local pres `rprelist'
			foreach pv of local pres {
				mat `preM2' = nullmat(`preM2') \ 	/*
					*/ (`rlags' , `rmlags' ) 
				mat `preM2b' = nullmat(`preM2b') \ /*
					*/ (`rlags' , `rmlags', `firstpl' ) 

			}
		}	
	}	

	if `lags' == 0 & "`prelist'" == "" {
		di as err "no lags of the dependent variable or " /*
			*/ "predetermined variables specified"
		exit 198	
	}

	if "`options'" != "" {
		di as err "`options' invalid"
		exit 198
	}	

	if "`prevs'" != "" {
		local pre ""
		local j 1
		tokenize `prevs'
		while "``j''" != "" {
			local vlag=`preM2'[`j',1]
			local pre "`pre' L(0(1)`vlag').``j'' "
			local j = `j' + 1
		}	
	
		tsvars `pre'
		local pre "`r(varlist)'"
	}
	else {
		local pre ""
		local preM2 ""
	}	


/* check for collinearity */

/* t2 contains `absolute t' which goes from 1 to number of observations in
 *    longest panel
 */

	tempvar t2 
	qui gen double `t2'= (`tvar'-`tmin') / `tsdelta' + 1 
	qui sum `t2'
	local t2max = r(max)

/* t2min contains first value of absolute t in model */ 	
	local t2min = 1 + `lags' + 1

	local trows = `t2max' - (`lags'+1)

	local fvarlist " `laglist' `indeps' "

	if "`constant'"=="" {
		_rmcoll `fvarlist' `diffvars' `pre'  /* 
	 		*/ if `touse' & `t2'>`lags'+1	
	}
	else {
		_rmcoll `fvarlist' `diffvars' `pre'  /* 
		 	*/ if `touse' & `t2'>`lags'+1 , nocons
	}		
	local fvarlist "`r(varlist)'"


	foreach tv of local fvarlist {
		local laglist: subinstr local laglist "`tv'" "`tv'", /*
			*/ word count(local n)
		if `n'==1 {
			local newlaglist "`newlaglist' `tv' "
		}
		
		local n 0
		local indeps: subinstr local indeps "`tv'" "`tv'", /*
			*/ word count(local n)
		if `n'==1 {
			local newindeps "`newindeps' `tv' "
		}

		local n 0
		local diffvars: subinstr local diffvars "`tv'" "`tv'", /*
			*/ word count(local n)
		if `n'==1 {
			local newdiffs "`newdiffs' `tv' "
		}

		local n 0
		local exog: subinstr local exog "`tv'" "`tv'", /*
			*/ word count(local n)
		if `n'==1 {
			local newexog "`newexog' `tv' "
		}

		local n 0
		local pre: subinstr local pre "`tv'" "`tv'", /*
			*/ word count(local n)
		if `n'==1 {
			local newpre "`newpre' `tv' "
		}
	
	}	

	local laglist "`newlaglist'"
	local laglist_n "`laglist'"

	if `lags' > 0 {
		qui tsrevar `laglist' if `touse', substitute
		local laglist "`r(varlist)'"
	}
	else {
		local laglist ""
	}	

	local indeps "`newindeps'"
	local diffvars "`newdiffs'"
	local pre "`newpre'"

	local exog `newexog' `newdiffs'

/* now use time-series operators to difference indeps and laglist */

	tokenize `laglist'
	while "`1'" != "" {
		local 1 "D.`1'"
		local laglist2 "`laglist2' `1'" 
		macro shift
	}
	local laglist "`laglist2'"

	local laglist_ud "`laglist_n'"
	tokenize `laglist_n'
	while "`1'" != "" {
		local 1 "D.`1'"
		local laglist_n2 "`laglist_n2' `1'" 
		macro shift
	}
	local laglist_n "`laglist_n2'"
	
	local indeps_ud "`indeps' `diffvars' "
	tokenize `indeps'
	while "`1'" != "" {
		local 1 "D.`1'"
		local indeps2 "`indeps2' `1'" 
		macro shift
	}
	local indeps "`indeps2'"


/* now put diffvars into indeps */	
	local indeps "`indeps' `diffvars' "

	local indeps_o `indeps'

	qui tsrevar `pre' if `touse', list
	local prebase "`r(varlist)'"

/* create differenced names for pre */

	local pre_ud "`pre'"
	tokenize `pre'
	while "`1'" != "" {
		local 1 "D.`1'"
		local pre2 "`pre2' `1'" 
		macro shift
	}
	local pre_n "`pre2'"

	local prevars_o `pre'
	qui tsrevar `pre' if `touse',substitute 
	local prevars "`r(varlist)'"

	tokenize `prebase'
	local j 1
	while "``j''" != "" {
		tempname pre`j'
		qui gen double `pre`j''=``j''
		local prebase2 " `prebase2' `pre`j'' "

		local j = `j' + 1
	}	

	local prebase "`prebase2'"

/* difference prevars */
	tokenize `prevars'
	while "`1'" != "" {
		local 1 "D.`1'"
		local prevars2 "`prevars2' `1'" 
		macro shift
	}
	local prevars "`prevars2'"

/* put in cons */


	if "`constant'" == "" {
		local names_ud "`laglist_ud' `pre_ud' `indeps_ud' _cons "
		local namesf "`laglist_n' `pre_n' `indeps' _cons "
		local indeps "`indeps' `cons1'"
		local fvarlist "`depvar' `laglist' `prevars' `indeps' " 
		local exog `exog' `cons1'
	}
	else {
		local names_ud "`laglist_ud' `pre_ud' `indeps_ud' "
		local fvarlist "`depvar' `laglist' `prevars' `indeps' " 
		local namesf "`laglist_n' `pre_n' `indeps' "
	}

	local names_ud : subinstr local names_ud "  " " ", all
	local names_ud : subinstr local names_ud "  " " ", all

	tempname p  m Ti_max Ti_obs Ti_min
	tempname  W A b yi Zy maxl2


/* Do this for all individuals, regardless of touse status 
	the internal routines will drop ids for which the sum of touse 
	is zero 
*/	

	local q = `lags' + 1
	local tau = (`tmax'-`tmin')/`tsdelta'+1
	local t0  = `tmin'+`q'*`tsdelta'
	if `maxldep' <0 {
		di as err "maxldep must be strictly greater than zero."
		exit 198
	}	

	if `maxldep'==0 {
		scalar `maxl2'=`tau'-1
		local maxldep2 = (`tmax'-`tmin')/`tsdelta'-1
	}
	else {
		scalar `maxl2'=`maxldep'
		local maxldep2 = `maxldep' 
	}



/* update depvar and predetermined matrices */


	tempname dargmat
	mat `dargmat'=(`lags', `maxl2') 

	if "`preM2'" != "" {
		mat `preM2' =`dargmat' \ `preM2'
	}
	else {
		tempname preM2
		mat `preM2' = `dargmat'
	}
	local prows = rowsof(`preM2')


/* substitute out time-series operators in laglist indeps prevars */

	if "`laglist'" != "" {
		tsrevar `laglist' if `touse', substitute
		local laglist "`r(varlist)'"
	}

	tsrevar `indeps' if `touse', substitute
	local indeps "`r(varlist)'"

	tsrevar `prevars' if `touse', substitute
	local prevars "`r(varlist)'"

	markout `touse' `laglist' `indeps' `depvar' `prevars' `inst_o' 

	qui sum `touse' 
	if r(max) == 0 {
		di as err "no observations"
		exit 2000
	}	

	tempvar l2touse
	qui gen byte `l2touse'= (L`lags'D.`depvar' < .  & `touse' )


/* Make position and absolute id variables */
	
	
	tempvar inobs abid inobs2 pos0 posa 
	tempname tobs_min tobs_max tobs_av id2max_t
	tempvar abid2
	
	qui gen `c(obs_t)' `posa' = _n
	qui by `id': gen `c(obs_t)' `pos0'= `posa'[1] if _n > 1

	qui gen `c(obs_t)' `inobs' = 1 if `l2touse' 
	qui by `id': replace `inobs' = sum(`inobs')
	qui by `id': replace `inobs' = `inobs'[_N] if _n < _N


	qui sum `inobs' if `t2'==1, meanonly

/* max holds Ti_max, min holds Ti_min and mean holds Ti_mean */
/* Generate and summarize absolute id */	

	qui by `id': gen `inobs2' = ( `inobs' > 0 & _n == 1 )
	qui sort `inobs2' `id' `t'
	qui gen long `abid' = sum(`inobs2') if `inobs2' > 0 
	qui sum `abid' , meanonly  

/* max hold max absolute id */	
	scalar `id2max_t'= r(max)
	local id2max     = r(max)
	qui sort `id' `t'
	qui by `id': replace `abid' = `abid'[1]  if _n >1  


	qui by `id': gen `abid2'=1 if _n==1
	qui replace `abid2' = sum(`abid2')
	qui by `id': replace `abid2'=`abid2'[1] if _n>1 
	qui sum `abid2', meanonly
	local abid2m = r(max)

	qui sum `inobs' if `t2'==1 & `inobs' > 0, meanonly
/* max holds Ti_max, min holds Ti_min and mean holds Ti_mean */
	
	scalar `tobs_min' = r(min)
	scalar `tobs_max'=r(max)
	scalar `tobs_av'=r(mean)

	
/* Make zvars and wvars */

/*  when finished you can read the instruments from the macros
 * zivars, timac and lvmac.  These macros form a parallel list 
 * data structure.  Each three tuple describes a valid instrument:
 * zivar element at absolute time timac element lagged lvmac element
 * is a valid instrument
 *
 */
	local wvars 
	local zivars 
	local timac
	local lvmac

/* cope with five types of variables,
 *	depvar, pred/endog, exog, already differenced variables, extra insts
 *	in this order adding to wvars as appropriate
 */	

/* i is counter over moment conditions (variables) created 
 * cutcols is counter over columns removed because of missing data
 * totcc is counter over moment conditions removed because of missing
 * data */
	local i 1

/* depvar section 
 */
	if `lags' >0 {
		tsunab ad2w : l(1/`lags')d.`depvar' 
		local wvars "`wvars' `ad2w'"
	}
	
/* if lagged depvars gen moment variables and put moment vars into zvars */


/* begin new version for depvars */

	if `lags' > 0 {
		forvalues ti=`t2min'/`t2max' {
			local newrow 1
			qui sum `touse' if `t2' == `ti', meanonly
			if r(max) == 1 {
				local lmax = `lags' + `ti'-`t2min'
				forvalues al = `lmax'(-1)1 {
					if `al'  <= `maxldep2'  {
		
local al2= `al' + 1 
qui count if (L`al2'.`depvar' < . & `ti'== `t2' & `l2touse')
if r(N) > 0 {
	local zivars `zivars' `depvar'
	local timac `timac' `ti'
	local lvmac `lvmac' `al2'

	local i = `i' +1
}	
					}
				}
			}	
		}
	}
/* end new version for depvars */


/*  pre/endog section
 * parse and add to wvars and zvars 
 */
 
	local pre `prelist'
	while "`pre'" != "" {
		gettoken tok pre : pre , parse(":")
		gettoken colon pre : pre , parse(":")
		
		if "`colon'" != ":" {
			di as err "internal xtabond error, pre_info invalid"
			exit 498
		}	
		gettoken pvars tok : tok , parse(",")
		tsunab pvars2 : `pvars'

		gettoken comma tok : tok , parse(",")

		if "`comma'" != "," {
			di as err "internal xtabond error, pre_info "/*
				*/"options invalid"
			exit 498
		}	
		
		gettoken pdlags tok : tok 

// pdlags is the number of lags in the model for these pvars

		capture confirm integer number `pdlags'
		if _rc>0 {
			di as err "internal xtabond error, pre_lags invalid"
			exit 498
		}	

		gettoken pdmlags tok : tok 
		capture confirm integer number `pdmlags'
// pdmlags is the maximum number of lags that can be used as instruments 
// for these pvarvs
		if _rc>0 {
			di as err "internal xtabond error, pre_mlags invalid"
			exit 498
		}	

// pdfirst is the first lag that can be used as an instrument minus one

		gettoken pdfirst tok : tok 
		capture confirm integer number `pdfirst'
		if _rc>0 {
			di as err "internal xtabond error, pre_first invalid"
			exit 498
		}	

		if `pdfirst' <0 {
			di as err "internal xtabond error, pre_first less " ///
				"than zero"
			exit 498
		}	

		tsunab wtmp2 : dl(0/`pdlags').(`pvars2') 
		local wvars `wvars' `wtmp2' 

		local pdfinst = `pdfirst'  + 1 
						/* pdfinst = 1 with endog
						 * and 
						 * pdfinst = 0 with pred
						 */
		foreach pvarb of local pvars2 {				 
			forvalues ti=`t2min'/`t2max' {
				local newrow 1
				qui sum `touse' if `t2' == `ti', meanonly
				if r(max) == 1 {
					local plmax = `lags' + `ti' - `t2min' 
					forvalues al = `plmax'(-1)`pdfirst' {
						if `al'  < `pdmlags'	///
							+ `pdlags' {
local al2 = `al' + 1 
qui count if (L`al2'.`pvarb' < . & `ti'== `t2' & `l2touse')
if r(N) > 0 {
	local zivars `zivars' `pvarb'
	local timac `timac' `ti'
	local lvmac `lvmac' `al2'

	local i = `i' +1
}
						}
					}
				}	
			}
		}

	}
	
/* now add on inst() variables to zvars 
 * note inst vars are not transformed by program, must be transformed
 * by user
 */

	local instmac `inst'	


/* exogenous variable section 
 * contains already differenced variables
 * already diff vars have not been diffd, other exog variable were
 * explicitly diffd in main code.
 */


	local indmac `indeps'

	if "`indeps'" != "" {
		local wvars `wvars' `indeps'
	}	

	local cnt 1
	foreach wv of local wvars {
		tempvar wv2`cnt' 
		qui gen double `wv2`cnt'' =cond(`l2touse', `wv', 0)
		local wvars2 `wvars2' `wv2`cnt''
		local cnt = `cnt' + 1
	}	
	local wvmac `wvars2'

/* Done making zvars and wvars */

	tempname dd
	qui gen double `dd'= D.`depvar' if `l2touse' 

	local wvcnt  : word count `wvmac'
	local zvcnt  : word count `zivars'
	local indcnt : word count `indmac' 
	local instcnt : word count `instmac' 

	tempname zimat hzname zitname hztname tmpm1

	_xtzw `dd', zwname(`W') aname(`A') zyname(`Zy') ivar(`abid') 	/*	
		 */ imax(`id2max') tvar(`t2') tmin(`t2min')		/*
		 */ tmax(`t2max') lags(`lags') touse(`l2touse') 	/*
		 */ zivars(zivars) timac(timac) lvmac(lvmac) 		/*
		 */ indmac(indmac) instmac(instmac) wvmac(wvmac)	/*
		 */ wwords(`wvcnt') zwords(`zvcnt') indwords(`indcnt')	/*
		 */ instwords(`instcnt') zimat(`zimat') hzname(`hzname')/*
		 */ zitname(`zitname') hztname(`hztname')


	mat `W'=`W''
	local zcols = colsof(`W') 

	qui count if `l2touse' == 1
	local n2 = r(N)

	tempvar touses
	mark `touses' if `t2'>`q'
	markout `touses' `laglist' `indeps'  

	mat `A'=syminv(`A')

 	tempname M1 V  sig b

	mat `M1'=(`W'*`A'*`W'')
	
	mat `tmpm1' = .5*(`M1'' + `M1')
	if mreldif(`tmpm1', `M1') > 1e-5 {
		di as err "onestep-naive VCE is not symmetric"
		exit 498
	}	
	mat `M1' = `tmpm1'
	mat `M1'=syminv(`M1')

	mat `b'=`M1'*`W'*`A'*`Zy'

	mat `b'=`b''


	tokenize `fvarlist'
	macro shift
	local names "`*'"
	local k: word count `names'

	mat colnames `b'=`names'
	
	
	tempname M1t sig1
	
	mat `V'=`M1'
	mat `M1t'=`M1'
	mat colnames `M1t'=`names'
	mat rownames `M1t'=`names'

	est post `b' `M1t'


	tempvar xb res1 res2

 	qui _predict double `xb', xb

	qui gen double `res1'=D.`depvar'-`xb' if `touse'
	qui gen double `res2'=`res1'^2 if `touse'
	qui summ `res2' if `touse'
	scalar `sig'=r(sum)
	local NT =r(N)


	tempvar N_idv
	qui gen long `N_idv'=(`res1' <. ) 
	qui by `id': replace `N_idv'= sum(`N_idv') if `touseb'  
	qui by `id': replace `N_idv'=. if _n<_N & `touseb' 

	qui by `byvars' `id': replace `N_idv'=cond(_n==1,(`N_idv'[_N]>0),.)

	qui replace `res1'=0 if `res1'>=.
	scalar `sig1'=`sig'/(`NT'-`k')
	
	if "`twostep'" == "" {
		if "`robust'" != "" {
		
		tempname A2 hzname

		_xta2 `res1', a2name(`A2') ivar(`abid') 		/*	
	  		*/ imax(`id2max') tvar(`t2') tmin(`t2min')	/*
	  		*/ tmax(`t2max') lags(`lags') touse(`l2touse') 	/*	
	  		*/ zivars(zivars) timac(timac) lvmac(lvmac)	/*
	  		*/ indmac(indmac) instmac(instmac) 		/*
	  		*/ zwords(`zvcnt') indwords(`indcnt')		/*
	  		*/ instwords(`instcnt') zimat(`zimat') 		/*
	 		*/ hzname(`hzname')

		mat `V'=`M1'*`W'*`A'*`A2'*`A'*`W''*`M1'	
		}
		else {
			scalar `sig'=`sig'/(`NT'-`k')
			mat `V'=`sig'*`V'

		}
 		local names "`namesf'" 
		mat `b'=e(b)
		mat colnames `b'=`names'

		mat colnames `V'=`names'
		mat rownames `V'=`names'
	}
	else {
		tempname A2 V H V_1r b_1 hzname 
		_xta2 `res1', a2name(`A2') ivar(`abid') 		/*	
	  		*/ imax(`id2max') tvar(`t2') tmin(`t2min')	/*
	  		*/ tmax(`t2max') lags(`lags') touse(`l2touse') 	/*	
	 		*/ zivars(zivars) timac(timac) lvmac(lvmac)	/*
	 		*/ indmac(indmac) instmac(instmac) 		/*
	 		*/ zwords(`zvcnt') indwords(`indcnt')		/*
	 		*/ instwords(`instcnt') zimat(`zimat') 		/*
	 		*/ hzname(`hzname')

		mat `V_1r'=`M1'*`W'*`A'*`A2'*`A'*`W''*`M1'	
		mat `b_1'=e(b)		

		mat `A2' = syminv(`A2')

		mat `M1'=(`W'*`A2'*`W'')
		
		mat `tmpm1' = .5*(`M1'' + `M1')
		if mreldif(`tmpm1', `M1') > 1e-5 {
			di as err "two-step VCE is not symmetric"
			exit 498
		}	
		mat `M1' = `tmpm1'

		mat `M1'=syminv(`M1')

		mat `b'=`M1'*`W'*`A2'*`Zy'
		
		mat `b'=`b''

		local names "`namesf'" 
		local k: word count `names'
		mat colnames `b'=`names'
	
		mat `V'=`M1'
	
		mat colnames `M1'=`names'
		mat rownames `M1'=`names'
		
		mat colnames `V_1r'=`names'
		mat rownames `V_1r'=`names'
		
		est post `b' `M1'

		mat `M1'=`V'
		tempvar xb res res2 
		tempname sig

		qui _predict double `xb' if `touses' , xb 

		qui gen double `res'=D.`depvar'-`xb'
		qui gen double `res2'=`res'^2
		qui summ `res2' if `touses'
		scalar `sig'=r(sum)
		local NT =r(N)

		scalar `sig'=`sig'/(`NT'-`k')

		mat colnames `V'=`names'
		mat rownames `V'=`names'
		mat `b'=e(b)

		tempname b_2 V_2
		mat `b_2' = `b'
		mat `V_2' = `V'

	}

	local df=`NT'-`k'

	tempvar touse3 t2b
	qui gen double `t2b'=(`t'-`tmin')/`tsdelta'+1
	mark `touse3' if `t2b'>`q'
	local namesf2 : subinstr local namesf "_cons" ""
	markout `touse3' `namesf2' 
	
	tempname b1 V1
	mat `b1' = `b'
	mat `V1' = `V'

	tempname v4
	mat `v4' = .5*(`V1'' + `V1' )

	if mreldif(`v4', `V1') > 1e-5 {
		di as err "robust VCE not symmetric"
		exit 198
	}	

	mat `V1'=`v4'
	mat `V'=`v4'

	est post `b1' `V1'
	est scalar sig=`sig'
	est scalar N_g=`id2max_t'

	
/* calculate AR statistics */	
	

	tempvar xb res wi lsqr
	tempname d0 
	qui _predict double `xb', xb
	qui gen double `res'=D.`depvar'-`xb'  if `touse'

	qui replace `res'=0 if `res'>=.

	tempname ZHW WW d1 d2m d3m d2 d3 ZV sargan wHw wHws 
	tempname hwname wtname

	_xtzv `res', zvname(`ZV') ivar(`abid') 			/*	
  		*/ imax(`id2max') tvar(`t2') tmin(`t2min')	/*
  		*/ tmax(`t2max') lags(`lags') touse(`l2touse') 	/*	
 		*/ zivars(zivars) timac(timac) lvmac(lvmac) 	/*
  		*/ indmac(indmac) instmac(instmac) 		/*
  		*/ zwords(`zvcnt') indwords(`indcnt')		/*
  		*/ instwords(`instcnt') zimat(`zimat')

		local i 1 
	
	while( `i' <= `artests') { 

		local zero -1

		tempname arm`i' 

		qui capture drop `wi' `lsqr' 
		local sarres ""
		local zvname ""

/* AR(m) statistic */
	
		qui gen double `wi'=l`i'.`res' if `touse'
		qui replace `wi'=0 if `wi'>=.

		qui gen double `lsqr'=`wi'*`res'


		qui summ `lsqr'
		scalar `d0'=r(sum)

		if `d0' == 0 {
			di as txt "note: the residuals and the L(`i') " _c
			di as txt "residuals have no obs in common" 
			di as txt "      The AR(`i') is trivially zero "
			scalar `arm`i''=.
			local zero 0
		}

		if (`zero' != 0 | `i'==1 ) {
			if "`twostep'" == "" {
				local ltwo 0
				if "`robust'" == "" {
					if `i'==1 {
						local sarres "sarres(`res')"
					}	
				}
				else {
					local ltwo 1 
					local resl " res1(`res1') "
				}
			}
			else {
				local ltwo 1 
				/* local resl " res1(`res1') " */
				local resl " res1(`res') "
				if `i'==1 {
					local sarres "sarres(`res')"
				}	
			}	
		
	
/* begin new method */
			if "`twostep'" != "" | "`robust'" != "" {
	
_xtwhw `wi' , zhname(`ZHW') wwname(`WW') ivar(`abid') imax(`id2max') 	/*
	*/ tvar(`t2') tmin(`t2min') tmax(`t2max') lags(`lags') 		/*
	*/ touse(`l2touse') zivars(zivars) timac(timac) 		/*
	*/ lvmac(lvmac) indmac(indmac) instmac(instmac) wvmac(wvmac)	/*
	*/ wwords(`wvcnt') zwords(`zvcnt') indwords(`indcnt')	 	/*
	*/ instwords(`instcnt') zimat(`zimat') hwname(`hwname')		/*
	*/ wtname(`wtname') res1(`res')
scalar `wHws' = r(wHw)
			}
			else {
_xtwhw `wi' , zhname(`ZHW') wwname(`WW') ivar(`abid') 		/*	
	 */ imax(`id2max') tvar(`t2') tmin(`t2min')		/*
	 */ tmax(`t2max') lags(`lags') touse(`l2touse')		/*
	 */ zivars(zivars) timac(timac) lvmac(lvmac) 		/*
	 */ indmac(indmac) instmac(instmac) wvmac(wvmac)	/*
	 */ wwords(`wvcnt') zwords(`zvcnt') indwords(`indcnt')	/*
	 */ instwords(`instcnt') zimat(`zimat') hwname(`hwname')/*
	 */ wtname(`wtname')
scalar `wHws' =r(wHw)
			}

/* end new method */
			
			if "`twostep'" == "" & "`robust'" == "" {
				scalar `d1'=`wHws'*`sig1'
				mat `d2m'=-2*`sig1'*`WW'*`M1'*`W'*`A'*`ZHW'
				if `i' == 1 {
			
					if (`sig1' >=. |  1/`sig1'>=. ) {
						scalar `sargan' = .
					}
					else { 
						mat `sargan'= `ZV''*`A'* /*
							*/ `ZV'*(1/`sig1')
						scalar `sargan' = `sargan'[1,1]
					}	
				}	
			}
			else {
				if "`robust'" != "" {
					scalar `d1'= `wHws'
					mat `d2m'=-2*`WW'*`M1'*`W'*`A'*`ZHW'
				}
				else {
					scalar `d1'= `wHws'
					mat `d2m'=-2*`WW'*`M1'*`W'*`A2'*`ZHW'
					if `i'==1 {
						mat `sargan'= `ZV''*`A2'*`ZV'
						scalar `sargan' = `sargan'[1,1]
					}	
				}
			}
		
			mat `d3m'=`WW'*e(V)*`WW''
		
			if `zero' != 0 {
				scalar `arm`i''=(`d0')/ /*
					*/ ( sqrt(`d1'+`d2m'[1,1]+`d3m'[1,1]) )
			}
			else {
				scalar `arm`i'' = . 
			}	
		}
		local i = `i' + 1
	}	

	restore 

 	foreach var of local prevars_o {
 		local prevars_do " `prevars_do' d.`var' "
 	}
 
 	tempname dd3 dd4
 	qui gen double `dd3' = `depvar' 
 	markout `touse' `dd3' DL(1/`lags').`dd3' `indeps_o' 		/*
 		*/ `prevars_do' `inst_o' 

	if "`small'" != "" {
		local dofm " dof( `df' ) "
	}
	est post `b' `V', depname(D.`depvar') obs(`NT') `dofm' /*
		*/ esample(`touse')



	local i 1
	while `i' <= `artests' {
		est scalar arm`i' = `arm`i''
		if "`robust'" == "" & `i'==1 {
			/* est scalar sargan = `sargan'[1,1] */
			est scalar sargan = `sargan'
		}	
		local i = `i' + 1
	}	

/* do wald test on constant */
	
	if "`constant'" == "" {
		qui test `namesf2'
		if "`small'" != "" {
			est scalar F=r(F)
			est scalar F_p = r(p)
			est scalar F_df=r(df)
		}
		else {
			tempname chi2 chi2_p chi2_df
			
			est scalar chi2    = r(chi2)
			est scalar chi2_p  = r(p)
			est scalar chi2_df = r(df)
			est local chi2type "Wald"	
		
		}
	}

	est scalar N = `n2'
	est scalar g_min=`tobs_min'
	est scalar g_max=`tobs_max'
	est scalar g_avg=`tobs_av'
	est scalar t_min=`tmin'
	est scalar t_max=`tmax'
	est scalar n_lags = `lags'

	est scalar sig2=`sig'
	est scalar N_g=`id2max_t'

	est local inst_l "`inst_l'"
	est local ivar "`id'"
	est local tvar "`t'"
	est local robust "`robust'"
	est local twostep "`twostep'"
	est local predict "xtab_p"
	est local bnames_ud `names_ud'
	est local depvar_ud "`depvar'"
	est local depvar "D.`depvar'"
	est local small "`small'"
	
	est scalar artests = `artests'
	est scalar df_m = `k'
	est scalar zcols =`zcols'
	if "`robust'" == "" {
		est scalar sar_df= `zcols'-`k'
		est local vce `vce'
	}	
	else {
		est local vce "robust"
		est local vcetype "Robust"
	}
	est local cmd "xtabond"

	Disp `level'
end


program define tsvars, rclass
	syntax varlist(ts)
	return local varlist "`varlist'"
end	


/* pre_p parses pre(<varlist>, [LAGstruct(<#_1,#_2) ENDogenous 
	exog(exogvarlist) prevs(all_ready_parsed_predeterm_vars])
*/

program define pre_p, rclass
	capture syntax varlist , [			/*
		*/ LAGstruct(string)			/*
		*/ ENDogenous				/*
		*/ exog(varlist ts)			/*
		*/ prevs(varlist ts)			/*
		*/ noCONStant				/*
		*/ ]

	if _rc > 0 {
		di as err "pre(`0') invalid "
		exit 198
	}	

	_rmcoll `varlist', `constant' 
	local varlist "`r(varlist)'"

	foreach var of local varlist {
	capture _rmdcoll `var' `prevs', nocoll `constant'
		if _rc == 459 {
			di as txt "note: `var' dropped due to collinearity"
		}
		else {
			capture _rmdcoll `var' `exog', nocoll `constant'
			if _rc == 459 {
di as txt "note: `var' dropped due to collinearity"
			}
			else {
local prelist "`prelist' `var' "
			}
		}	
	}

	local varlist "`prelist'"

	if "`lagstruct'" != "" {
		local lagstruct : subinstr local lagstruct " " "", all
		gettoken lags lagstruct : lagstruct, parse(",")
			if "`lags'"=="." {
				local lags "."
			}

		gettoken comma lagstruct : lagstruct, parse(",")
		if "`comma'"!="," {
			error 198
		}		

		gettoken maxlags lagstruct : lagstruct, parse(",")
		if "`maxlags'" == "." {
			local maxlags "."
		}	

		if "`lagstruct'"!="" {
			error 198
		}		
	
	}
	else {
		local lags "." 
		local maxlags "."
	}

	capture confirm integer number `lags'
	if _rc > 0 {
		local lagsn 0
	}
	else {
		if `lags' < 0 {
			di as err "lags of predetermined variables "	///
				"must be nonnegative"
			exit 498
		}
		local lagsn `lags'
	}

	if "`endogenous'" != "" {
		local first =   1 + `lagsn'
		if `maxlags' < . {
			local ++maxlags
		}	
	}	
	else {
		local first =   0 + `lagsn'
	}
	return scalar first = `first'


	return scalar lags = `lags'
	return scalar maxlags = `maxlags'
	return local pre "`varlist'"
end	


program define Disp, eclass
	args level 


	#delimit ;
        di _n as txt "Arellano-Bond dynamic panel-data estimation"
                _col(49) as txt "Number of obs" _col(68) "="
                _col(70) as res %9.0f e(N) ;
        di as txt "Group variable: " as res abbrev("`e(ivar)'", 12) as txt
		_col(49) "Number of groups" _col(68) "="
                _col(70) as res %9.0g e(N_g) _n ;

	#delimit cr
	if "`e(prefix)'" != "" {
		if !missing(e(df_r)) {
         		di as txt _col(49) "F(" as res e(df_m) as txt ", " /* 
				*/ as res e(df_r) as txt ")" _col(68) "=" /* 
				*/ _col(70) as res %9.2f e(F)
		}
		else {
         		di as txt _col(49) "Wald chi2(" /*
				*/ as res e(df_m) as txt  ")" _col(68) "=" /*
				*/ _col(70) as res %9.2f e(chi2)
		}
	}
	else if "`e(small)'" != "" {
         	di as txt _col(49) "F(" as res e(F_df) as txt ", " /* 
			*/ as res e(df_r) as txt ")" _col(68) "=" /* 
			*/ _col(70) as res %9.2f e(F)
	}
	else {
         	di as txt _col(49) "Wald chi2(" as res e(chi2_df) as txt  ")" /*
			*/ _col(68) "=" _col(70) as res %9.2f e(chi2)
	}
	di

	#delimit ;
        di as txt "Time variable: " as res abbrev("`e(tvar)'", 12) 
		as txt _col(49) "Obs per group: min " _col(68) "="
                _col(70) as res %9.0g e(g_min)  ;
		di as txt _col(64) "avg" _col(68) "="
                _col(70) as res %9.0g e(g_avg)  ;
		di as txt _col(64) "max" _col(68) "="
                _col(70) as res %9.0g e(g_max) _n ;
		
	#delimit cr

	if "`e(twostep)'" != "" {
		di as txt "Two-step results"
	}		 
	else {
		di as txt "One-step results"
	}	
		
	est di, level(`level') 

	if "`e(twostep)'" != "" {
		di "Warning: Arellano and Bond recommend using " /*
			*/ "one-step results for "
		di "         inference on coefficients"
		di
       }

	if "`e(robust)'" == "" {
		#delimit ;
		di as txt "Sargan test of over-identifying restrictions:     "; 
		di as txt _col(10) "chi2(" as res e(zcols)-e(df_m) as txt ") = " 
			 as res %8.2f e(sargan) _col(35) as txt "Prob > chi2 = " 
			as res %6.4f chiprob(e(zcols)-e(df_m),e(sargan)) ;
			di ;
		#delimit cr
	}

	local i  1
	while (`i' <= e(artests) ) {
		di as txt "Arellano-Bond test that average " _c
		di as txt "autocovariance in residuals of order `i' is 0:"
		di _col(10) as txt "H0: no autocorrelation " /*
			*/ _col(35) "z = "as res %6.2f e(arm`i')/* 
			*/ _col(48) as txt "Pr > z = " /*
			*/ as res %6.4f 2*(normprob(-1*abs( (e(arm`i')) ) ))
		local i = `i'+1
	}	

end


exit

