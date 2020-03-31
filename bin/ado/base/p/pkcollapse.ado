*! version 1.1.12  05feb2020
program define pkcollapse
	version 7, missing
	
	syntax varlist(numeric min=2) [if], id(varname) [stat(string) ///
	fit(string) noDots Trapezoid keep(string) force ]

	local vv : display "version " string(_caller()) ", missing:"

	marksample touse
	qui count if `touse'
	if r(N) == 0 {
		error 2000
	}
	local var_cnt: word count `varlist'
	tokenize `varlist'

	if "`stat'" != "" {
                local tmp : word count `stat'
                forvalues X=1/`tmp' {
                        local tmp2 : word `X' of `stat'
			if "`tmp2'"!="auc" & "`tmp2'"!="aucline" & /*
			*/ "`tmp2'"!="aucexp" & "`tmp2'"!="auclog" & /*
			*/ "`tmp2'"!="half" & "`tmp2'"!="ke" & /*
			*/ "`tmp2'"!="cmax" & "`tmp2'"!="tmax" & /*
			*/ "`tmp2'"!="tomc" {
				di as err "stat(`tmp2') - invalid option"
				exit 198
			}
                }
        }
	
	qui capture drop auc* cmax* tomc* tmax* half* ke*
	if "`keep'" != "" & "`force'" == "" {
		local tmp: word count `keep'
		forvalues X=1/`tmp'{
			local junk : word `X' of `keep'
			confirm var `junk' 
			capture by `id', sort: assert `junk' == `junk'[1]
			if _rc {
				di as err `"Keep variable `junk' is not unique within id"'
				di as err "Use force option to retain last value"
				exit 459
			} 
		}
	}
        if "`fit'" == "" {
                local fit 3
	} 
	local fitopt= "fit(`fit')"

	tempname tmp
	sort `touse' `id' `1'
	scalar `tmp' = `1'[_N]
	capture by `touse' `id': assert `tmp' == `1'[_N] if `touse'
	if _rc {
		di as txt "Warning: follow-up times are different for each patient"
	}

        local dots = cond("`dots'"=="", "", "*")

	qui {
		tempvar nid  
		by `touse' `id' (`1'), sort: gen `nid' = 1 /*
		        */ if _n == 1 & `touse'
		replace `nid' = sum(`nid') if `touse'
		sum `nid',meanonly
		local max = r(max)
		sort `touse' `nid' `1'
	}

	local tmp = (`var_cnt')
	forvalues X=2/`tmp' {
		local auc = "auc_``X''"
		local aucline = "aucline_``X''"
		local aucexp = "aucexp_``X''"
		local auclog = "auclog_``X''"
		local half = "half_``X''"
		local ke = "ke_``X''"
		local cmax = "cmax_``X''"
		local tmax = "tmax_``X''"
		local tomc = "tomc_``X''" 
		
	        qui {
			gen `auc' = .
			label var `auc' "AUC: ``X''"
			gen `aucline' = .
			label var `aucline' "AUC (linear): ``X''"
			gen `aucexp' = .
			label var `aucexp' "AUC (exponential): ``X''"
			gen `auclog' = .
			label var `auclog' "AUC (log): ``X''"
			gen `half' = .
			label var `half' "Half-life: ``X''"
			gen `ke' = .
			label var `ke' "Elimination rate: ``X''"
			gen `cmax' = .
			label var `cmax' "Max concentration: ``X''"
			gen `tmax' = .
			label var `tmax' "Last concentration time: ``X''"
			gen `tomc' = .
			label var `tomc' "Max concentration time: ``X''"


			forvalues index = 1/`max' {
				count if `nid'==`index' & `touse'
				if `fit'>r(N) {
					noi di
					noi di as err /*
					*/ "fit(`fit') is greater than the" /*
					*/ " number of obs. in at least one `id'
					exit 2001
				}
				`dots' noi di as res "." _c
				`vv' pkexamine `1' ``X'' if /* 
			          */ `nid'==`index' & `touse', /*
				  */ `trapezoid' `fitopt'
				replace `auc' = r(auc) if /*
				  */ `touse' & `nid'==`index'
				replace `aucline' = r(auc_line) if /*
				  */ `touse' & `nid'==`index'
				replace `aucexp' = r(auc_exp) if /*
				  */ `touse' & `nid'==`index'
				replace `auclog' = r(auc_ln) if /*
				  */ `touse' & `nid'==`index'
				replace `half' = r(half) if /*
				  */ `touse' & `nid'==`index'
				replace `ke' = r(ke) if /*
				  */ `touse' & `nid'==`index'
				replace `cmax' = r(cmax) if /*
				  */ `touse' & `nid'==`index'
				replace `tmax' = r(tmax) if /*
				  */ `touse' & `nid'==`index'
				replace `tomc' = r(tomc) if /*
				  */ `touse' & `nid'==`index'
			}
		}
	}
	qui by `nid' , sort: keep if _n == _N
	qui capture keep auc* cmax* tomc* tmax* half* ke* `id' `keep'
	if "`stat'" != "" {
		local tmp : word count `stat'
		forvalues X=1/`tmp' {	
			local tmp2 : word `X' of `stat'
			local tmp2 = "`tmp2'_*"
			local keepers = `"`keepers'  `tmp2'"'
		}
		qui keep `keepers' `id' `keep'
	}
		
end
exit
