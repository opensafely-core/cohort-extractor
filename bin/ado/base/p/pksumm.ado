*! version 1.6.0  24apr2007
program define pksumm, rclass sort
	version 7, missing
	if _caller() < 8 {
		pksumm_7 `0'
		return add
		exit
	}
	local vv : display "version " string(_caller()) ", missing:"

	syntax varlist(numeric min=3 max=3)	///
		[if] [in] [,			///
		Trapezoid			///
		fit(integer 3)			///
		stat(string)			///
		noDots				///
		noTIMEchk			///
		Graph				///
		DENsity FRACtion FREQuency	///
		*				///
	]
	_get_gropts , graphopts(`options')

	if "`graph'"  == "" {
		syntax varlist(numeric min=3 max=3) [if] [in] /*
                */ [, Trapezoid fit(integer 3) stat(string) noDots noTIMEchk ]
	}
	else {
		local type `density' `fraction' `frequency'
		local k : word count `type'
		if `k' > 1 {
			local type : list retok type
			di as err "options `type' may not be combined"
			exit 198
		}
		else if `k' == 0 {
			local type fraction
		}
	}

	marksample touse

	local stat = cond("`stat'"=="", "auc", "`stat'")
	GetStatRtn `"`stat'"'
	local dfltclab  "`s(clab)'"

	tokenize `varlist'
	local id    "`1'"
	local time  "`2'"
	local conc  "`3'"

	if "`fit'" != "" { 
		local fit "fit(`fit')"
	}

	if "`timechk'" == "" {
		tempname tmp
		sort `touse' `id' `time'
		scalar `tmp' = `time'[_N]
		sort `touse' `id' `time'
		capture by `touse' `id': assert `tmp' == `time'[_N] if `touse'
		if _rc {
			di as err /*
			*/ "follow-up times are different for each patient"
			exit 459
		}
	}

	local dots = cond("`dots'"=="", "", "*")
	qui {
		tempvar nid auc aucline auclog aucexp ke half tmax cmax tomc
		by `touse' `id' (`time'), sort: gen `nid' = 1 /*
			*/ if _n == 1 & `touse'
		replace `nid' = sum(`nid') if `touse'
		sum `nid',meanonly
		local max = r(max) 
		sort `touse' `nid' `time'
		gen double `auc' = .  
		gen double `aucline' = . 
		gen double `auclog' = . 
		gen double `aucexp' = . 
		gen double `ke' = . 
		gen double `half' = . 
		gen double `tmax' = . 
		gen double `cmax' = . 
		gen double `tomc' = .

		forvalues index = 1/`max' {
			`dots' noi di as res "." _c
			`vv' pkexamine `time' `conc' /*
				*/ if `nid'==`index' & `touse', /*
				*/ `trapezoid' `fit'
			replace `auc' = r(auc) if `touse' & `nid'==`index' & /*
				*/ `time'==r(tmax)
			replace `aucline' = r(auc_line) if `touse' & /*
				*/ `nid'==`index' & `time'==r(tmax)
			replace `aucexp' = r(auc_exp) if `touse' & /*
				*/ `nid'==`index' & `time'==r(tmax)
			replace `auclog' = r(auc_ln) if `touse' & /*
				*/ `nid'==`index' & `time'==r(tmax)
			replace `half' = r(half) if `touse' & `nid'==`index' /*
				*/ & `time'==r(tmax)
			replace `ke' = r(ke) if `touse' & `nid'==`index' & /*
				*/ `time'==r(tmax)
			replace `cmax' = r(cmax) if `touse' & `nid'==`index' /*
				*/ & `time'==r(tmax)
			replace `tomc' = r(tomc) if `touse' & `nid'==`index' /*
				*/& `time'==r(tmax)
			replace `tmax' = r(tmax) if `touse' & `nid'==`index' /*
				*/ & `time'==r(tmax)
			ret add
		} 
	} /* end qui loop */

	if "`dots'" == "" { 
		di
	}
	di _n as txt _col(2) "Summary statistics for the pharmacokinetic measures"
	di
	di as txt _col(50) "Number of observations =" as res %6.0f `max'
	di
	di as txt "     Measure {c |}      Mean     Median     Variance  Skewness   Kurtosis   p-value"
	di as txt "{hline 13}{c +}{hline 65}"

	foreach name in auc aucline aucexp auclog half ke cmax tomc tmax {
		qui su ``name'', detail
		local mean_fmt "%10.2f"
		if (abs(r(mean)) > 1e6  | abs(r(mean)) < 1e-6) & r(mean)~=0 {
			local mean_fmt "%10.2e"
		}
		local p50_fmt "%10.2f"
		if (abs(r(p50)) > 1e6 | abs(r(p50)) < 1e-6)  & r(p50)~=0 {
       		        local p50_fmt "%10.2e"
        	}
		local var_fmt "%12.2f"
        	if (abs(r(Var)) > 1e8 | abs(r(Var)) < 1e-8) & r(Var)~=0 {
                	local var_fmt "%12.2e"
        	}
		local skew_fmt "%9.2f"
        	if (abs(r(skewness)) > 1e5 | abs(r(skewness)) < 1e-5) & /* 
		*/ r(skewness)~=0 {
                	local skew_fmt "%9.2e"
        	}
		local kurt_fmt "%10.2f"
        	if (abs(r(kurtosis)) > 1e6 | abs(r(kurtosis)) < 1e-6) & /*
		*/ r(kurtosis)~=0 {
			local kurt_fmt "%10.2e"
		}	
		local len = length("`name'")
		di as txt %12s `"`name'"' `" {c |}"' as res /* 
		*/ `mean_fmt' r(mean) /*
		*/ " " as res `p50_fmt' r(p50) as txt " " /*
		*/ as res `var_fmt' r(Var) as txt " " as res /*
		*/ `skew_fmt' r(skewness) /*
		*/ as txt " " as res `kurt_fmt' r(kurtosis) _c
		qui sktest ``name''
		local chi_fmt "%9.2f"
		if (abs(r(P_chi2)) > 1e7 | abs(r(P_chi2)) < 1e-7) & /* 
	  	*/ r(P_chi2)~=0 {
			local chi_fmt "%9.2e"
		}
		di as txt " " as res `chi_fmt' r(P_chi2)
	}

	ret clear

	local clab: variable label `conc'
	if "`clab'" == "" {
		local clab "`dfltclab'"
	}
	label var ``stat'' "`clab'"

	if "`graph'" != "" {
		qui histogram ``stat'', `type' `options'
	}

end

program define GetStatRtn, sclass
	args stat

	sret clear
	if `"`stat'"' == "aucline" {
		sret local clab "Linear fit for AUC 0-inf."
	}
	else if `"`stat'"' == "aucexp" {
		sret local clab "Exponential fit for AUC 0-inf."
	}
	else if `"`stat'"' == "auclog" {
		sret local clab /*
			*/ "Linear fit to log concentration AUC for AUC 0-inf."
	}
	else if `"`stat'"' == "auc" { 
		sret local clab "Area Under Curve (AUC)"
	}
	else if `"`stat'"' == "ke" { 
		sret local clab = "Elimination rate"
	}
	else if `"`stat'"' == "half" { 
		sret local clab "Half life"
	}
	else if `"`stat'"' == "cmax" { 
		sret local clab "Maximum concentration"
	}
	else if `"`stat'"' == "tomc" { 
		sret local clab "Time of maximum concentration"
	}
	else if `"`stat'"' == "tmax" { 
		sret local clab "Maximum observed time"
	}
	else {
		di as err /*
*/ "stat() must be one of auc, aucline, aucexp, auclog, half, ke, cmax," _n /*
*/ "tomc, or tmax" 
		exit 198 
	}
end
exit
