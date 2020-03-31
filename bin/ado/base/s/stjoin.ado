*! version 6.0.6  16may2019
program define stjoin 
	version 6, missing

	u_mi_not_mi_set stjoin other

	if _caller()<6 {
		ztjoin_5 `0'
		exit
	}
	st_is 2 full
	syntax [, Censored(numlist missingok)]

	local id "`_dta[st_id]'"
	if "`id'"=="" {
		di in gr
	*/ "(stjoin amounts to a request to do nothing with single-record data)"
		exit
	}

	if "`censore'" == "" { 
		IsVar `_dta[st_bd]'
		if `s(exists)' { 
			if `"`_dta[st_ev]'"' == "" {
				local censore "0"
				local version : di "version " ///
					string(_caller()) ", missing:"
		
			    if _caller() > 15 {
				`version' ///
				di as txt "(option {bf:censored(0)} assumed)"
			    }
			    else {
		di in gr "(option " in ye "censored(0)" in gr " assumed)"
			    }
			}
		}
	}
		

	local origN = _N

	qui count if _st 
	if r(N) { 
		quietly {
			local bd  `_dta[st_bd]'
			local bt  `_dta[st_bt]'
			local bt0 `_dta[st_bt0]'
			IsVar `bd'
			if !`s(exists)' { 
				tempvar bd
				gen byte `bd' = cond(_d & _st, 1, .)
			}
			IsVar `bt'
			if !`s(exists)' { 
				tempvar bt
				gen double `bt' = /*
					*/ _t*`_dta[st_s]'+`_dta[st_o]' if _st
				compress `bt'
			}
			IsVar `bt0'
			if !`s(exists)' {
				tempvar bt0
				gen double `bt0' = /*
					*/ _t0*`_dta[st_s]'+`_dta[st_o]' if _st
				compress `bt0'
			}
			preserve

			count if _st==0
			if r(N) {
				tempfile rest
				keep if _st==0
				save `"`rest'"', replace
				restore, preserve
				local keep "keep if _st"
				`keep'
			}

			keep in 1 
			drop _st _t0 _t `id' `bt0' `bt' `bd' _d
			local 0 _all
			syntax varlist
			restore, preserve
			`keep'

			sort `id' `varlist'
			tempvar pat dup iscens grp
			by `id' `varlist': gen `c(obs_t)' `pat' = 1 if _n==1 
			replace `pat' = sum(`pat')
			sort `id' _t
			/* at this point 

				id  _t0   _t   bt0  bt  bd  pat
      				5    8                 	    #1
      				8    9                      #1
			*/
			gen byte `iscens' = `bd'>=. 
			tokenize `censore'
			while "`1'" != "" {
				replace `iscens' = 1 if float(`bd')==float(`1')
				mac shift 
			}
			replace `iscens' = 0 if _d

			gen byte `dup' = `pat'==`pat'[_n+1] & /*
				*/ float(_t) == float(_t0[_n+1]) & /*
				*/ float(`bt') == float(`bt0'[_n+1]) & /*
				*/ `iscens'

			gen `c(obs_t)' `grp' = sum(_n==1 | `dup'[_n-1]==0)
			sort `grp' `id' _t
			by `grp': replace _t = _t[_N]
			by `grp': replace _d = _d[_N]
			by `grp': replace `bt' = `bt'[_N]
			by `grp': replace `bd' = `bd'[_N]
			by `grp': keep if _n==1

			if `"`rest'"' != "" {
				append using `"`rest'"'
			}
			restore, not
		}
	}
	di in gr "(" (`origN'-_N) " obs. eliminated)"
	if `origN'-_N == 0 & "`censore'"=="" { 
		di in gr /*
		*/ "(perhaps you need to specify stjoin's censored() option)"
	}
end

		
program define IsVar, sclass
	nobreak {
		capture confirm new var `1'
		if _rc {
			capture confirm var `1'
			if _rc==0 { 
				sret local exists 1
				exit 
			}
		}
	}
	sret local exists 0
end
exit
