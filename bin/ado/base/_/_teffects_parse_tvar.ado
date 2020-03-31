*! version 1.0.3  01dec2014

program define _teffects_parse_tvar, sclass sortpreserve
	version 13

	sreturn local tvar 
	sreturn local klev

	cap noi syntax varname(numeric), touse(varname) stat(string)  ///
			[ freq(varname) CONtrol(string) TLEvel(string) ///
			BASEoutcome(string) noMARKout  binary  cmd(string) ]
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The treatment-model is misspecified.{p_end}"	
		exit `rc'
	}
	if "`baseoutcome'" != "" & "`control'" != "" {
		di as err "{p}options {bf:baseoutcome()} and " ///
		 "{bf:control()} may not be combined{p_end}"
		exit 184
	}
	if ("`baseoutcome'"!="") local control "`baseoutcome'"

	if ("`stat'"=="att") local stat atet

	local tvar `varlist'
	if "`markout'" == "" {
		markout `touse' `tvar'
		_teffects_count_obs `touse', freq(`freq') ///
			why(observations with missing values)
	}
	_teffects_validate_catvar `tvar', argname(treatment variable) ///
		touse(`touse') `binary'
	local klev = `r(klev)'

	tempname tlev tfrq
	local bcontrol = ("`control'"=="")
	if !`bcontrol' {
		if "`stat'" == "pomeans" {
			di as err "{p}options {bf:control()} and " ///
			 "{bf:pomeans} may not be combined{p_end}"
			exit 184
		}
		_teffects_label2value `tvar', label(`control')
		local lcontrol `control'
		local control = `r(value)'
	}
	local btreat = ("`tlevel'"=="")
	if !`btreat' {
		if "`stat'" != "atet" {
			if "`stat'" == "ate" {
				local def " (the default)"
			}
			di as err "{p}options {bf:tlevel()} and " ///
			 "{bf:`stat'}`def' may not be combined{p_end}"
			exit 184
		}
		_teffects_label2value `tvar', label(`tlevel')
		local ltlevel `tlevel'
		local tlevel = `r(value)'

		if !`bcontrol' {
			if `control' == `tlevel' {
				di as err "{p}{bf:control(`lcontrol')} and " ///
				 "{bf:tlevel(`ltlevel')} cannot be the "     ///
				 "same value{p_end}"
				exit 198
			}
		}
	}
	if ("`freq'"!="") local wt [fw=`freq']

	qui tabulate `tvar' if `touse' `wt', matrow(`tlev') matcell(`tfrq')
	local icontrol = 0
	local itreat = 0
	forvalues i=1/`klev' {
		local lev = `tlev'[`i',1]
		if `lev' != round(`lev') {
			di as err "{p}levels of treatment variable " ///
			 "{bf:`tvar'} must be integer valued{p_end}"
			exit 459
		}
		if !`bcontrol' {
			local bcontrol = (`control'==`lev')
			if (`bcontrol') local icontrol = `i'
		}	
		if !`btreat' {
			local btreat = (`tlevel'==`lev')
			if (`btreat') local itreat = `i'
		}
		local k = `tfrq'[`i',1]
		local n`lev' = `k'
	}
	if !`bcontrol' {
		di as err "{p}invalid {bf:control(`lcontrol')} "     ///
		 "specification; level {bf:`control'} not found in " ///
		 "treatment variable {bf:`tvar'}{p_end}"
		exit 459
	}
	if !`btreat' {
		di as err "{p}invalid {bf:tlevel(`ltlevel')} "      ///
		 "specification; level {bf:`tlevel'} not found in " ///
		 "treatment variable {bf:`tvar'}{p_end}"
		exit 459
	}
	if "`control'" == "" {
		if "`tlevel'" != "" {
			forvalues i=1/`klev' {
				local lev = `tlev'[`i',1]
				if `lev' != `tlevel' {
					local icontrol = `i'
					continue, break
				}
			}
		}
		else {
			local icontrol = 1
			local itreat = 2
		}
	}
	if !`itreat' {
		if (`icontrol'!=1) local itreat = 1
		else local itreat = 2
	}
	local control = `tlev'[`icontrol',1]
	local tlevel = `tlev'[`itreat',1]

	forvalues i=1/`klev' {
		local lev = `tlev'[`i',1]
		local levels `levels' `lev'
		sreturn local n`lev' = `n`lev''
	} 
	local levels : list retokenize levels

	sreturn local tvar `tvar'
	sreturn local klev = `klev'
	sreturn local levels `"`levels'"'
	sreturn local control = `control'
	if "`tlevel'" != "" {
		sreturn local tlevel = `tlevel'
	}
end
exit

