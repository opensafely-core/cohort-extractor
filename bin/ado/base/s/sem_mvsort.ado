*! version 1.1.1  16feb2015

// NOTE: this program is used in the following places:
// _sem_build.mata (compiled into lmataado.mlib)
// sem_p.ado

// Warning: the change in the order of the observations is INTENDED
program sem_mvsort // DO NOT ADD OPTION SORTPRESERVE
	version 12

	#del ;
	syntax  varlist(numeric ts),	// manifest variables in analysis
		touse(varname)		// sample selection  
	[
		mvpat(string)		// store missing value pattern ID
		nmv(string)		// store number of missing values	
		group(varlist)		// group ID variable
		minobs(integer 1)
		minfreq(integer 1)
		ALLMISSing
	] ;
	#del cr
		// minobs() selects observations that have at least a certain
		//     number of nonmissing components.
		// minfreq() selects observations that have missing value
		//     patterns with at least a certain minimal frequency
		//
		// In some cases computing time may be greatly reduced by
		// dropping observations with rare patterns, at the cost of
		// some bias if MCAR is violated.

	tempvar cg dontuse g nvalid order
	gen `order' = _n

	capt assert `touse'==0 | `touse'==1
	if _rc {
		dis as err "error in sem_mvsort" 
		dis as err "touse() should be 0/1"
		exit 198
	}
	qui compress `touse' 

	qui count if `touse'
	local drop = r(N)
	if "`allmissing'" == "" {
		markout `touse' `varlist', sysmissok
	}
	qui count if `touse'
	local drop = `drop' - r(N)
	if `drop' {
		dis as txt ///
"(`drop' " plural(`drop',"observation")	///
" containing extended missing values excluded)"
	}
	if `"`mvpat'"'!="" {	
		confirm new variable `mvpat' 
	}	
	if `"`nmv'"'!="" {	
		confirm new variable `nmv' 
	}
	
	if `"`group'"'!="" {
		markout `touse' `group' , strok
	}

	qui count if `touse'  
	if (r(N)==0) {
		error 2000
	}	

     // determine missing value patterns and #valids

	local nvar: list sizeof varlist
	qui gen int `nvalid' = 0 if `touse' 
	local j  =  0
	local ij = -1
	foreach v of local varlist {
		if mod(`++ij',30)==0 {
			tempvar v`++j' 
			local vlist `vlist' `v`j''
			gen long `v`j'' = 0
		}
		qui replace `v`j''   = 2*`v`j'' +  missing(`v') if `touse'  
		qui replace `nvalid' = `nvalid' + !missing(`v') if `touse'  
	}
     
     // exclude observations with not-enough valid values
   
	if `minobs'>0 {
		qui count if `touse' & `nvalid'==0
		if r(N)>0 {
			dis as txt "(" r(N) " all-missing " ///
				plural(`=r(N)',"observation") " excluded)"
			qui replace `touse' = 0 if `touse' & `nvalid'==0
			qui count if `touse'  
			if (r(N)==0) {
				error 2000
			}			
		}	
	}	

	if `minobs'>1 {
		qui count if `touse' & `nvalid'<`minobs'
		if r(N)>0 {
			local m = `minobs'-1
			if `m'>1 {
				dis as txt ///
				    "(" r(N) " observations with at most " ///
				    "`m' valid values excluded)"
			}
			else {
				dis as txt ///
				    "(" r(N) " obs with 1 " ///
				    "valid value excluded)"
			}
			qui replace `touse' = 0 if `touse' & `nvalid'<`minobs'
			qui count if `touse'  
			if (r(N)==0) {
				error 2000
			}				
		}
	}

     // exclude obs in infrequent missing value patterns 

	if `minfreq'>1 { 
		qui bys `touse' `group' `vlist' : ///
			gen byte `dontuse' = _N<`minfreq' if `touse' 
		qui count if `dontuse'==1
		if r(N)>0 {
			dis as txt "(" r(N) " " ///
			    plural(`=r(N)',"observation") " in patterns " /// 
			    "with frequency<`minfreq' excluded)"
			qui replace `touse' = 0 if `dontuse'==1
			qui count if `touse'  
			if (r(N)==0) {
				error 2000
			}
		}
		drop `dontuse' 
	}

     // use stable sort to prevent randomness in sort order in data 
     
	sort `touse' `group' `vlist' `order'

     // return variables with missing value pattern indicator and #mv's 

	if `"`mvpat'"'!="" {
		// note that sort order is already ok
		qui by `touse' `group' `vlist'   : gen `g' = _n==1    if `touse'
		qui by `touse' `group' (`vlist') : gen `cg'= sum(`g') if `touse'

		qui compress `cg'
		rename `cg' `mvpat'
		label var `mvpat' "mv-pattern indicator"
	}	

	if "`nmv'"!="" { 
		gen `nmv' = `nvar'-`nvalid' if `touse' 
		qui compress `nmv' 
		label var `nmv' "# of missing values"
	}
end
