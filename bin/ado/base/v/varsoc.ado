*! version 1.1.8  12feb2010
program define varsoc, rclass byable(recall) sort
	version 8.0
	syntax [varlist(default=none ts numeric)] [if] [in], 	/*
		*/ [ESTimates(string)			/*
		*/ Maxlag(string) 			/*
		*/ EXog(varlist ts)			/*
		*/ rmexog				/*
		*/ CONSTraints(numlist)			/*
		*/ RMCONSTraints			/*
		*/ noCONStant				/*
		*/ ADDCONStant				/*
		*/ LUTstats 				/*
		*/ RMLUTstats  				/*
		*/ Level(cilevel)			/* 
		*/ SEParator(numlist max=1 >=0 integer) ]


	if "`estimates'" == "" & "`varlist'" == "" {
		if "`e(cmd)'" == "var" | "`e(cmd)'" == "svar" {
			local estimates "."
		}
	}
		

	if "`estimates'" == "" {
		if "`rmexog'" != "" {
			di as err "{cmd:rmexog} can only be specified "	/*
				*/ "with {cmd:estimates()}"
			exit 198
		}
		if "`rmlutstats'" != "" {
			di as err "{cmd:rmlutstats} can only be "	/*
				*/ "specified with {cmd:estimates()}"
			exit 198
		}
		if "`rmconstraints'" != "" {
			di as err "{cmd:rmconstraints} can only be "	/*
				*/ "specified with {cmd:estimates()}"
			exit 198
		}
		if "`addconstant'" != "" {
			di as err "{cmd:addconstant} can only be "	/*
				*/ "specified with {cmd:estimates()}"
			exit 198
		}
	}	

	if "`rmexog'" != "" & "`exog'" != "" {
		di as error "{p 0 4 0}{cmd:rmexog} and {cmd:exog(`exog')} "/*
			*/ "cannot both be specified{p_end}"
		exit 198
	}	

	if "`rmlutstats'" != "" & "`lutstats'" != "" {
		di as error "{cmd:rmlutstats} and {cmd:lutstats} "	/*
			*/ "cannot both be specified"
		exit 198
	}	

	if "`rmconstraints'" != "" & "`constraints'" != "" {
		di as error "{cmd:rmconstraints} and {cmd:constraints} "/*
			*/ "cannot both be specified"
		exit 198
	}	

	if "`constant'" != "" & "`addconstant'" != "" {
		di as error "{cmd:noconstant} and {cmd:addconstant} "/*
			*/ "cannot both be specified"
		exit 198
	}	

	qui tsset, noquery

	if "`separator'" == "" {
		local separator 0
	}	

	if "`exog'" != "" {
		tsvlist `exog'
		local exog `r(varlist)'
	}	
		
	tempname llt lr0 stats last lr df p pvar smp0

	if "`estimates'" != "" {
		 _estimates hold `pvar', restore copy nullok varname(`smp0')
		capture estimates restore `estimates'
		if _rc > 0 {
			di as err "cannot restore estimates(`estimates')"
			exit 198
		}	
	
		if "`e(cmd)'" == "svar" {
			local svar _var
		}	

		_cknotsvaroi varsoc
		
		if "`e(cmd)'" == "var" | "`e(cmd)'" == "svar" {
			if "`varlist'" == "" {
				local varlist      "`e(endog`svar')'"
			}	
			
			if "`if'`in'" == "" {
				tempname touse 
				gen byte `touse' = e(sample)
			}	
			else{
				marksample touse
			}
			
			if "`lutstats'" == "" {
				local lutstats     "`e(lutstats`svar')'"
			}	
			
			if "`lutstats'" == "" & "`rmlutstats'" != "" {
				di as err "{p 0 4 0}{cmd:rmlutstats} "	/*
					*/ "cannot be specified when "	/*
					*/ "{cmd:lutstats} was not "	/*
					*/ "specified in "		/*
					*/ "{cmd:estimates(`estimates')}"/*
					*/ "{p_end}"
				exit 498
			}	
			if "`rmlutstats'" != "" {
				local lutstats     ""
			}	
			
			if "`constant'" != "" & "`e(nocons`svar')'" != "" {
				di as err "{p 0 4 0}{cmd:noconstant} "	/*
					*/ "cannot be specified when "	/*
					*/ "{cmd:noconstant} was "	/*
					*/ "specified in "		/*
					*/ "{cmd:estimates(`estimates')}"/*
					*/ "{p_end}"
				exit 498
			}	

			if "`addconstant'" != "" & 		/*
				*/ "`e(nocons`svar')'" == "" {
				di as err "{p 0 4 0}{cmd:addconstant} "	/*
					*/ "cannot be specified when "	/*
					*/ "{cmd:noconstant} was not "	/*
					*/ "specified in "		/*
					*/ "{cmd:estimates(`estimates')}"/*
					*/ "{p_end}"
				exit 498
			}	

			if "`e(nocons`svar')'" != ""  {
				local constant noconstant
			}	

			if "`addconstant'" != "" 	{
				local constant 
			}
			
			if "`maxlag'" == "" {
				local maxlag       "`e(mlag`svar')'"
			}	
			else {
				pmaxlag ,maxlag(`maxlag')
				local maxlag = r(mlag)

				if `maxlag' > e(N)-1 {
di as err "maxlag(`maxlag') not feasible with " e(N) " observations "
exit 198
				}	
			}
			
			if "`exog'" == "" {
				local exog "`e(exog`svar')'"
			}	
			
			if "`constraints'" == "" {
/* remove old method using saved off cnslist
 * local constraints "`e(cnslist`svar')'"
 */ 
 				if "`e(constraints`svar')'" != "" {
					_getvarcns
					local constraints $T_VARcnslist
// do not drop T_VARcnslist here, it is used below to drop constraints
					macro drop T_VARcnslist2

				}
			}
		
		}	
		else {
			di as err "estimates(`estimates') are not "/*
				*/ "from either {cmd:var} or {cmd:svar}"
			exit 198
		}	
	}
	else {
		 _estimates hold `pvar', restore copy nullok varname(`smp0')
		marksample touse
		if "`varlist'" == ""  {
			di as error "either specify a {cmd:varlist} or " /*
				*/ "the {cmd:estimates()} from either "/*
				*/ "{cmd: var} or {cmd: svar}"
			exit 198
		}
		qui count if `touse' == 1

		if "`maxlag'" == "" {
			local maxlag 4
		}
		else  {
			pmaxlag ,maxlag(`maxlag')
			local maxlag = r(mlag)
		}
	
		if `maxlag' > r(N)-1 {
di as err "maxlag(`maxlag') not feasible with " r(N) " observations "
exit 198
		}	
	}


	if "`constraints'" != "" {
		local cns " constraints(`constraints') "
	}	

	if "`rmconstraints'" != "" & "`cns'" == "" {
		di as err "{p 0 4 0}{cmd:rmconstraints} cannot be "	/*
			*/ "specified when no constraints were "	/*
			*/ "specified in estimates(`estimates'){p_end}"
		exit 498
	}

	if "`rmconstraints'" != "" {
		local cns 
	}

	if "`exog'" == "" & "`rmexog'" != "" {
		di as err "{p 0 4 0}{cmd:rmexog} cannot be specified "	/*
			*/ "when no exogenous variables were "		/*
			*/ "specified in estimates(`estimates'){p_end}"
		exit 498
	}	

	if "`rmexog'" != "" {
		local exog 
	}	

/* check that constraints apply to exogenous variables */
	if "`cns'" != ""  & "`exog'" == "" & "`constant'" != "" {
		di as err "{help varsoc##|_new:varsoc} only allows "	/*
			*/ "constraints on exogenous variables"
		di as err "use {help var##|_new:var} to place "	/*
			*/ "constraints on endogenous variable"
		exit 198
	}

	if "`cns'" != "" {
		tempname bcns vcns
		if "`constant'" == "" {
			local cons _cons
		}
		local exog_cns1 `exog' `cons'

		local excnsdim 0
		foreach var of local varlist {
			local var : subinstr local var "." "_"
			foreach exvar of local exog_cns1 {
				local ++excnsdim
				local exog_cnsf "`exog_cnsf' `var':`exvar' "
			}	
		}
		mat `bcns' = J(1,`excnsdim',1)
		mat colnames `bcns' = `exog_cnsf'
		mat `vcns' = `bcns''*`bcns'
		eret post `bcns' `vcns'
		capture noi mat makeCns `constraints'
		if _rc > 0 { 
			di as err "specified constraints invalid"
			exit _rc
		}	
		
	}

	if "`maxlag'" == "" {
		local maxlag 4
	}
	else  {
		pmaxlag ,maxlag(`maxlag')
		local maxlag = r(mlag)
	}
	

	if "`exog'" != "" {
		local exogv "exog(`exog')"
	}
	else {
		local exogv ""
	}
	
	if `maxlag'<2 {
		di as error "maxlag() must be at least 2"
		exit 198
	}	

	if _by() { 
		qui replace `touse' = 0 if `_byindex' != _byindex()
	}	

	qui var `varlist' if `touse'==1, lags(1/`maxlag') /* 
		*/ `exogv' `lutstats'  `cns' `constant'

	mat dispCns, r
	local k_cns = r(k)
	forvalues i = 1/`k_cns' {
		local cns`i' "`r(cns`i')'"
	}	

	qui replace `touse'=e(sample)
	local tsfmt "`e(tsfmt)'"
	local tmin  = e(tmin)
	local tmax  = e(tmax)
	local N     = e(N)
	local N_gaps     = e(N_gaps)

	scalar `lr0'=e(ll)
	mat `last' = `maxlag' , e(ll) , 0 ,0,0 , e(fpe), e(aic) , /*
		*/ e(hqic) , e(sbic) 
	
/* if noconstant and no exog, then zero lag model is not well defined
 * thus go on to 1 lag model
 */
	if "`constant'" != "" & "`exogv'" == "" {
			scalar `llt'  = .
			local blag 1	
	}	
	else {
		local blag 0
	}	

	local mm1=`maxlag'-1
	forvalues i=`blag'(1)`mm1' {

		if `i' > 0 {
			local lagl "1/`i'"
			local zlags 
		}
		else {
			local lagl 
			local zlags zlags
		}

		qui var `varlist' if `touse'==1, lags(`lagl') /* 
			*/ `exogv' `lutstats'  `nomodel' `cns' `zlags' /*
			*/ `constant'
		
		if `i' > 0 {
			scalar `df'=(e(neqs))^2
			scalar `lr'=2*(e(ll)-`llt')

			if `lr' > 0 {
				scalar `p'=chi2tail(`df',`lr')
			}
			else {
				scalar `p'=.
			}
		}
		else {
				scalar `lr'=.b
				scalar `df'=.b
				scalar `p'=.b
		}	
			
		scalar `llt'=e(ll)
		
		
		mat `stats' = (  nullmat(`stats') \ (`i', 	/*
			*/ e(ll) , `lr', `df', `p', e(fpe), 	/*
			*/ e(aic), e(hqic), e(sbic) ))

	}

	mat `last'[1,3]=2*(`last'[1,2]-`llt')
	mat `last'[1,4]= `df'
	if `last'[1,3] > 0 {
		mat `last'[1,5]=chi2tail(`df',`last'[1,3])
	}
	else {
		mat `last'[1,5]= .
	
	}

	mat `stats' = `stats' \ `last'

	matrix colnames `stats' = lag LL LR df p FPE AIC HQIC SBIC

	
        local t0 : di `tsfmt' `tmin'
	local tN : di `tsfmt' `tmax'
	local t0 = strtrim(`"`t0'"')
	local tN = strtrim(`"`tN'"')

	local offset 4
	di
	if "`lutstats'" != "" {
		di as txt "{col `offset'}Selection-order criteria (lutstats)" 
	}
	else {
		di as txt "{col `offset'}Selection-order criteria" 
	}
	if "`cns'" != "" {
		di
		di as txt "{col `offset'}constraints applied to all vars"
		MatdispCns
	}	
	if `N_gaps' > 0 {
		local gaps ", but with gaps"
	}	

/*
	di as txt "{col `offset'}Sample:  " as result 		///
		`"`=strtrim(`"`t0'"')'"'			///
		" - "						///
		`"`=strtrim(`"`tN'"')'"'			///
		`"`gaps'"' _c
*/
	local indent = `offset' - 1
	_mvtsheadr `"`t0'"' `"`tN'"' `indent'
	di as txt "{col 49}Number of obs {col 68}= " as result %9.0f `N' 
	
	DISP2, stats(`stats') separator(`separator') level(`level')

	if "`constant'" == "" local exog "`exog'  _cons"

	di as txt "{space 3}Endogenous:  " _c
	PDisp `varlist'

	di as txt "{space 3} Exogenous:  " _c
	PDisp `exog'



	capture _estimates unhold `pvar'
	
	forvalue i = 1/`k_cns' {
		ret local cns`i' "`cns`i''"
	}	

	if "$T_VARcnslist" != "" {
		constraint drop $T_VARcnslist
		macro drop T_VARcnslist
	}	
	ret scalar tmin = `tmin'
	ret scalar tmax = `tmax'
	ret scalar N    = `N'
	ret scalar mlag = `maxlag'
	ret scalar N_gaps = `N_gaps'
	
	ret local constant  `constant'
	ret local endog    = "`varlist'"
	ret local exog     = "`exog'"
	ret local lutstats = "`lutstats'"
	ret local rmlutstats    = "`rmlutstats'"

	return matrix stats `stats' 
end	


program define PDisp 
	local first ""
	local piece : piece 1 62 of `"`0'"'
	local i 1
	while "`piece'" != "" {
		di as txt "`first'`piece'"
		local first "{space 16}"
		local i = `i' + 1
		local piece : piece `i' 62 of `"`0'"'
	}
	if `i'==1 { 
		di 
	}
end
 

program define tsvlist, rclass
	syntax varlist(ts)
	ret local varlist `varlist'
end	
program define pmaxlag , rclass
	syntax , maxlag(integer)
	ret scalar mlag = `maxlag'
end

program define DISP2 
	
	syntax , stats(name) separator(numlist max=1 integer >=0) /*
		*/ [level(cilevel) ]


	local rows = rowsof(`stats')

	local length 79 

	tempname table

	.`table' = ._tab.new, col(15) scolor(yellow) lcolor(green) 	///
		ignore(.b) separator(`separator')

	.`table'.width |4|	/// 1
			9 	/// 2
			8 	/// 3 
			1 	/// 4
			5 	/// 5
			7 	/// 6
			8 	/// 7
			1 	/// 8 
			9 	/// 9
			1	/// 10
			9 	/// 11
			1	/// 12
			9     	/// 13
			1	/// 14
			1|     	//  15

	.`table'.numfmt %3.0f 	/// 1
			%8.7g 	/// 2
			%7.6g 	/// 3
			. 	/// 4
			%4.0f	/// 5
			%6.3f 	/// 6
			%8.7g 	/// 7
			. 	/// 8
			%8.7g 	/// 9
			. 	/// 10
			%8.7g 	/// 11
			. 	/// 12
			%8.7g	/// 13
			.	/// 14
			.	//  15

	.`table'.pad 	. 	/// 1
			1 	/// 2
			1 	/// 3
			.	/// 4
			. 	/// 5
			. 	/// 6
			0 	/// 7	
			1 	/// 8
			1 	/// 9
			. 	/// 10
			1 	/// 11
			. 	/// 12
			1 	/// 13
			.	/// 14
			.	//  15

	.`table'.numcolor green . . . . . . . . . . . . . .
	.`table'.sep, top
	.`table'.titles	"lag"	/// 1
			"LL  "	/// 2
			"LR  "	/// 3
			""	/// 4
			"df"	/// 5
			"p  "	/// 6
			"FPE "	/// 7
			""	/// 8
			"AIC "	/// 9
			""	/// 10
			"HQIC "	/// 11
			""	/// 12
			"SBIC "	/// 13
			""	/// 14
			""	//  15

	.`table'.sep, mid

	tempname fpes aics hqics sbics fpev aicv hqicv sbicv
	
	local rows1 = `rows' -1
	
	local lrs = -1
	local size = (100-`level')/100
	local lrs  = cond(`lrs' < 0  & `stats'[`rows',5]<=`size', /*
		*/ `rows', -1)
	local  fpes   `rows'
	local  aics   `rows'
	local  hqics   `rows'
	local  sbics   `rows'
	
	forvalues i = `rows1'(-1)1 {
		local lrs  = cond(`lrs' > 0, `lrs',		/*
			*/ cond(`stats'[`i',5]<=`size', `i', -1 ) )
		local fpes = cond(`stats'[`i',6] < `stats'[`fpes',6], /*
			*/   `i', `fpes')
		local aics = cond(`stats'[`i',7] < `stats'[`aics',7], /*
			*/   `i', `aics')
		local hqics = cond(`stats'[`i',8] < `stats'[`hqics',8], /*
			*/   `i', `hqics')
		local sbics = cond(`stats'[`i',9] < `stats'[`sbics',9], /*
			*/   `i', `sbics')
	}

	forvalues i = 1/`rows' {
		local lrs`i' = cond(`i'==`lrs', "*", "")
		local fpes`i' = cond(`i'==`fpes', "*", "")
		local aics`i' = cond(`i'==`aics', "*", " ")
		local hqics`i' = cond(`i'==`hqics', "*", " ")
		local sbics`i' = cond(`i'==`sbics', "*", " ")
	}	
	
	local cnt 0
	forvalues i = 1/`rows' {
		local ++cnt

		local aic_el  : display %8.7g `stats'[`i',7] "`aics`i''"
		local hqic_el : display %8.7g `stats'[`i',8] "`hqics`i''"
		local sbic_el : display %8.7g `stats'[`i',9] "`sbics`i''"
		
		.`table'.row	`stats'[`i',1]		/// 1
				`stats'[`i',2]		/// 2
				`stats'[`i',3]		/// 3
				"`lrs`i''"		/// 4
				`stats'[`i',4]		/// 5	
				`stats'[`i',5]		/// 6
				`stats'[`i',6]		/// 7
				"`fpes`i''"		/// 8
				`stats'[`i',7]		/// 9
				"`aics`i''"		/// 10
				`stats'[`i',8]		/// 11
				"`hqics`i''"		/// 12
				`stats'[`i',9]		/// 12
				"`sbics`i''"		/// 14
				""			//  15
	}
	
	.`table'.sep, bot
	
end

program define MatdispCns
	
	mat dispCns, r

	local k = r(k)
	forvalues i = 1/`k' {
		local cns "`r(cns`i')'"
		di as txt "{col 4}(`i')" as res "{col 11}`cns'"
	}

end
exit
