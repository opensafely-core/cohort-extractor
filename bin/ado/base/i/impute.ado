*! version 3.1.7  09feb2015
program impute, sortpreserve
	version 8, missing

	syntax varlist(min=2 max=31 ts) [if] [in] [aw fw], Generate(string) /*
	 */ [ REGsample(str) ALL Varp(string) COPYrest NOMISsings(varlist ts) ]

	/*
	    if/in        sample in which missing values have to be imputed.
			 gen() is missing outside this sample

	    regsample    sample to use in regressions

	    The regsample may be larger than the imputation sample.  If
	    regsample is not specified it is equal to the imputation sample.
	*/

	marksample touse, novarlist
	if "`nomissings'" != "" {
		CheckNoMissings `touse' `nomissings'
	}
	if `"`regsample'"' != "" {
		if "`all'" != "" {
			di as err "options all and regsample() " /*
			*/ "may not be combined"
			exit 198
		}
		tempname rsample
		capt gen byte `rsample' = `regsample'
		if _rc {
			di as err `"error evaluating regsample() : `regsample'"'
			exit 198
		}
	}
	else if "`all'" != "" {
		local rsample 1
	}
	else {
		local rsample `touse'
	}

	confirm new variable `generate'
	if `"`varp'"' != "" {
		confirm new variable `varp'
	}

	local notaw = (`"`weight'"' != "aweight")
	local weight `"[`weight'`exp']"'

	quietly {
		tempvar vm vmc hasy yy yyv pp ppe
		tempname bit

		gettoken lhs rhs : varlist
		tsunab lhsn : `lhs'
		if ( index("`lhsn'", ".") != 0 ) {
	di as error "time-series operators not allowed with dependent variable"
			exit 101
		}		
		local nvar : word count `rhs'
		count if missing(`lhs') & `touse'
		local nmiss = r(N)

		gen float `yy'  = `lhs' if `touse'
		gen float `yyv' =   0   if `touse'
		count if `touse'
		local nobs = r(N)
		
		capture tsset, noquery
		if _rc == 0 {
			local panelvar `r(panelvar)'
			local timevar `r(timevar)'
		}
		
		if `nmiss' {
			/* vm is coded m.v. pattern for x */
			gen long `vm' = 0 if `touse'
			scalar `bit' = 1
			foreach var of local rhs {
				replace `vm' = `vm' + `bit'*(!missing(`var'))
				scalar `bit' = `bit' * 2
			}

			gen byte `hasy' = (!missing(`lhs')) if `touse'
			replace `hasy' = 1 if missing(`hasy')
			sort `hasy' `vm'
			by `hasy' `vm' : gen `c(obs_t)' `vmc' = (_n==1)
			replace `vmc' = sum(`vmc')
			count if !`hasy' & !missing(`vm')
			local NN = `vmc'[r(N)]
			local vmnmax 0
			forvalues i = 1/`NN' {
				count if `vmc'==`i'
				local vmcount = r(N)
				local vmnmin = `vmnmax' + 1
				local vmnmax = `vmnmax' + r(N)
				local vmid = `vm'[`vmnmin']

				if (`vmid' != 0 | "`nomissings'" != "") {
					/* something present */
					_crcplst `vmid' `nvar' `rhs'
					if "`panelvar'`timevar'" != "" {
						sort `panelvar' `timevar'
					}
					regress `lhs' `r(onevars)' /*
					*/ `nomissings'/*
					*/ `weight' if (`rsample')
					capture drop `pp'
					capture drop `ppe'
					_predict `pp'
					if `notaw' {
						_predict `ppe', stdf
					}
					else	gen `ppe' = .
					if "`panelvar'`timevar'" != "" {
						sort `hasy' `vm'
					}
					replace `yy'=`pp' ///
						if `vm'==`vmid' & !`hasy'
					capt replace `yyv' = `ppe'*`ppe' /*
					 */ if `vm'==`vmid' & !`hasy'
				}
			}
		}

		if "`copyrest'" != "" {
			replace `yy' = `lhs' if !`touse'
		}

		label var `yy' `"imputed `lhs'"'
		rename `yy' `generate'
		label var `yyv' `"variance of imputed `lhs'"'
		capt rename `yyv' `varp'
	} /* quietly */

	di as txt %6.2f 100*`nmiss'/`nobs' `"% (`nmiss') observations imputed"'
end

program CheckNoMissings
	gettoken touse 0 : 0
	syntax varlist(ts)

	marksample nomis
	quietly count if `touse'==1 & `nomis'==0
	if r(N) {
		di as err ///
"{p 0 0 2}option nomissings() requires variables that have no" ///
" missing values within the regression sample{p_end}"
		exit 198
	}
end

/* _crcplst vm nvar unquoted-varlist

   returns in r(onevars) and r(zerovars) the variables associated
   with the 1/0's in the base-2 representation of vm
*/
program _crcplst, rclass
	args vm nvar

	tempname bit
	scalar `bit' = 1
	forvalues i = 1/`nvar' {
		local var = 2 + `i'
		if (mod(int(`vm'/`bit'),2)==1) {
			return local onevars `"`return(onevars)' ``var''"'
		}
		else {
			return local zerovars `"`return(zerovars)' ``var''"'
		}
		scalar `bit' = `bit' * 2
	}
end
exit


HISTORY
3.1.0   ported to r7
	made sort-stable
	added options regsample/all
	added option copyrest
3.1.1	added option nomissings()
3.1.2   added ability to use time-series operators with RHS variables

