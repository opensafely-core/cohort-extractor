*! version 1.4.0  15apr2015
program _svyset
	version 9
	gettoken cmd 0 : 0

	if "`cmd'" == "clear" {
		Clear `0'
		exit
	}
	if "`cmd'" == "set" {
		Set `0'
		exit
	}
	if "`cmd'" == "get" {
		Get `0'
		exit
	}
	di as err "unrecognized subcommand"
	exit 199
end

program Clear
	if `:word count `0'' > 2 {
		di as err "too many arguments"
		exit 103
	}
	args name i
	if "`name'" == "stages" {
		confirm integer number `i'
		if `i' <= 1 {
			local i 1
		}
		local stages : char _dta[_svy_stages]
		capture CheckPosInt `stages'
		if c(rc) {
			local stages = `i' - 1
		}
		forval j = `i'/`stages' {
			char _dta[_svy_su`j']
			char _dta[_svy_strata`j']
			char _dta[_svy_fpc`j']
		}
		local --i
		if `i' > 0 {
			char _dta[_svy_stages] `i'
		}
		else	char _dta[_svy_stages]
		exit
	}
	if "`name'" == "stages_wt" {
		confirm integer number `i'
		if `i' <= 1 {
			local i 1
		}
		local stages_wt : char _dta[_svy_stages_wt]
		capture CheckPosInt `stages_wt'
		if c(rc) {
			local stages_wt = `i' - 1
		}
		forval j = `i'/`stages_wt' {
			char _dta[_svy_su`j']
			char _dta[_svy_weight`j']
		}
		local --i
		if `i' > 0 {
			char _dta[_svy_stages_wt] `i'
		}
		else	char _dta[_svy_stages_wt]
		exit
	}
	if "`name'" == "version" {
		char _dta[_svy_version]
	}
	CheckName `name'
	if "`s(sname)'" != "" {
		local name `s(sname)'
		CheckPosInt `i'
	}
	else	local name `s(gname)'
	if inlist("`name'","pweight","iweight","wtype","wexp","wvar") {
		char _dta[_svy_wtype]
		char _dta[_svy_wvar]
		exit
	}
	if "`name'" == "vce" {
		char _dta[_svy_vce]
		char _dta[_svy_mse]
		exit
	}
	if bsubstr("`name'",1,4) == "post" {
		char _dta[_svy_poststrata]
		char _dta[_svy_postweight]
		exit
	}
	if bsubstr("`name'",1,3) == "cal" {
		char _dta[_svy_calmethod]
		char _dta[_svy_calmodel]
		char _dta[_svy_calopts]
		exit
	}
	if "`name'" == "sdrweight" {
		char _dta[_svy_sdrfpc]
	}
	char _dta[_svy_`name'`i']
end

program Set
	gettoken name value : 0
	CheckName `name'
	local name `s(gname)'
	if "`name'" == "" {
		local name `s(sname)'
		gettoken i value : value
		CheckPosInt `i'
		if "`name'" == "su" {
			if !inlist(trim("`value'"), "", "_n") {
				CheckVar `value'
				local value `s(varname)'
			}
		}
		if "`name'" == "strata" {
			CheckVar `value'
			local value `s(varname)'
		}
		if "`name'" == "fpc" {
			CheckNumVar `value'
			local value `s(varname)'
		}
		if "`name'" == "weight" {
			CheckNumVar `value'
			local value `s(varname)'
		}
		char _dta[_svy_`name'`i'] `value'
		exit
	}
	if "`name'" == "stages" {
		CheckPosInt `value'
	}
	if "`name'" == "stages_wt" {
		CheckPosInt `value'
	}
	if inlist("`name'", "pweight", "iweight") {
		char _dta[_svy_wtype] `name'
		local name wvar
		CheckNumVar `value'
		local value `s(varname)'
	}
	if "`name'" == "vce" {
		_svy_check_vce `value'
		local value `s(vce)'
		if "`s(mse)'" != "" {
			char _dta[_svy_mse] mse
		}
	}
	if "`name'" == "mse" {
		// ignore user supplied `value'
		local value mse
	}
	if inlist("`name'","brrweight","bsrweight","jkrweight","sdrweight") {
		CheckNumVarlist `value'
		local value `s(varlist)'
	}
	if "`name'" == "sdrfpc" {
		if `"`:list retok value'"' != "" {
			confirm number `value'
		}
	}
	if "`name'" == "fay" {
		CheckFay `value'
	}
	if "`name'" == "bsn" {
		CheckBSN `value'
	}
	if "`name'" == "dof" {
		CheckDOF `value'
	}
	if "`name'" == "poststrata" {
		CheckVar `value'
		local value `s(varname)'
	}
	if "`name'" == "postweight" {
		CheckPostW `value'
		local value `s(varname)'
	}
	if "`name'" == "calmethod" {
		CheckCalMethod `value'
		local value `s(method)'
	}
	if "`name'" == "singleunit" {
		CheckSingle `value'
		local value `s(singleunit)'
	}
	char _dta[_svy_`name'] `value'
end

program Get, rclass
	if `:word count `0'' > 2 {
		di as err "too many arguments"
		exit 103
	}
	args name i
	CheckName `name'
	if "`s(sname)'" != "" {
		local name `s(sname)'
		CheckPosInt `i'
	}
	else	local name `s(gname)'
	if inlist("`name'", "wtype", "wvar", "wexp") {
		local wtype : char _dta[_svy_wtype]
		local wvar  : char _dta[_svy_wvar]
		if `"`wtype'`wvar'"' != "" {
			if `"`wtype'"' == "" {
				di as err ///
"error in svy settings; weight variable set without weight type"
				exit 459
			}
			if `"`wvar'"' == "" {
"error in svy settings; weight type set without weight variable"
				exit 459
			}
			CheckName `wtype'
			local wtype `s(gname)' `s(sname)'
			if !inlist("`wtype'", "pweight", "iweight") {
"error in svy settings; invalid weight type"
				exit 459
			}
			CheckNumVar `wvar'
			local wvar `s(varname)'
			local wexp "= `wvar'"
			return local wtype `"`wtype'"'
			return local wvar  `"`wvar'"'
			return local wexp  `"`wexp'"'
		}
		exit
	}
	if "`name'" == "stages" {
		local stages : char _dta[_svy_stages]
		capture CheckPosInt `stages'
		if c(rc) {
			return scalar stages = 0
		}
		return scalar stages = `stages'
		exit
	}
	if "`name'" == "stages_wt" {
		local stages_wt : char _dta[_svy_stages_wt]
		capture CheckPosInt `stages_wt'
		if c(rc) {
			return scalar stages_wt = 0
		}
		else {
			return scalar stages_wt = `stages_wt'
		}
		exit
	}
	if inlist("`name'", "vce", "mse") {
		local vce : char _dta[_svy_vce]
		local mse : char _dta[_svy_mse]
		if `"`vce'`mse'"' != "" {
			_svy_check_vce `vce', `mse'
			return local vce `s(vce)'
			return local mse `s(mse)'
		}
		exit
	}
	if "`name'" == "brrweight" {
		local brr : char _dta[_svy_brrweight]
		if `"`brr'"' != "" {
			CheckNumVarlist `brr'
			return local brrweight `s(varlist)'
		}
		exit
	}
	if "`name'" == "fay" {
		local fay : char _dta[_svy_fay]
		if `"`fay'"' != "" {
			CheckFay `fay'
			return scalar fay = `s(value)'
		}
		exit
	}
	if "`name'" == "bsrweight" {
		local bsr : char _dta[_svy_bsrweight]
		if `"`bsr'"' != "" {
			CheckNumVarlist `bsr'
			return local bsrweight `s(varlist)'
		}
		exit
	}
	if "`name'" == "bsn" {
		local bsn : char _dta[_svy_bsn]
		if `"`bsn'"' != "" {
			CheckBSN `bsn'
			return scalar bsn = `s(value)'
		}
		exit
	}
	if "`name'" == "jkrweight" {
		local jkr : char _dta[_svy_jkrweight]
		if `"`jkr'"' != "" {
			CheckNumVarlist `jkr'
			return local jkrweight `s(varlist)'
		}
		exit
	}
	if "`name'" == "sdrweight" {
		local sdr : char _dta[_svy_sdrweight]
		if `"`sdr'"' != "" {
			CheckNumVarlist `sdr'
			return local sdrweight `s(varlist)'
			local fpc : char _dta[_svy_sdrfpc]
			if `"`fpc'"' != "" {
				return local sdrfpc `"`fpc'"'
			}
		}
		exit
	}
	if "`name'" == "dof" {
		local dof : char _dta[_svy_dof]
		if `"`dof'"' != "" {
			CheckDOF `dof'
			return scalar dof = `s(value)'
		}
		exit
	}
	if "`name'" == "poststrata" {
		local poststrata : char _dta[_svy_poststrata]
		local postweight : char _dta[_svy_postweight]
		if `"`poststrata'`postweight'"' != "" {
			if "`postweight'" == "" {
				di as err ///
"error in svy settings; poststrata set without postweight"
				exit 459
			}
			if "`poststrata'" == "" {
				di as err ///
"error in svy settings; postweight set without poststrata"
				exit 459
			}
			CheckVar `poststrata'
			return local poststrata `s(varname)'
			CheckPostW `postweight'
			return local postweight `s(varname)'
		}
		exit
	}
	if "`name'" == "calmethod" {
		local calmethod	: char _dta[_svy_calmethod]
		local calmodel	: char _dta[_svy_calmodel]
		local calopts	: char _dta[_svy_calopts]
		if `"`calmethod'`calmodel'`calopts'"' != "" {
			if "`calmethod'" == "" {
				di as err ///
"error in svy settings; calibration method not properly set"
				exit 459
			}
			if "`calmodel'" == "" {
				di as err ///
"error in svy settings; calibration model not properly set"
				exit 459
			}
			if "`calopts'" == "" {
				di as err ///
"error in svy settings; calibration options not properly set"
				exit 459
			}
			CheckCalMethod `calmethod'
			return hidden local calmethod	`"`s(method)'"'
			return hidden local calmodel	`"`calmodel'"'
			return hidden local calopts	`"`calopts'"'
		}
		exit
	}
	if "`name'" == "su" {
		CheckPosInt `i'
		local su : char _dta[_svy_su`i']
		if !inlist("`su'", "", "_n") {
			CheckVar `su'
			return local su`i' `s(varname)'
		}
		else	return local su`i' `su'
		exit
	}
	if "`name'" == "weight" {
		CheckPosInt `i'
		local weight : char _dta[_svy_weight`i']
		if "`weight'" != "" {
			CheckVar `weight'
			return local weight`i' `s(varname)'
		}
		exit
	}
	if "`name'" == "strata" {
		CheckPosInt `i'
		local strata : char _dta[_svy_strata`i']
		if "`strata'" != "" {
			CheckVar `strata'
			return local strata`i' `s(varname)'
		}
		exit
	}
	if "`name'" == "fpc" {
		CheckPosInt `i'
		local fpc : char _dta[_svy_fpc`i']
		if "`fpc'" != "" {
			CheckVar `fpc'
			return local fpc`i' `s(varname)'
		}
		exit
	}
	if "`name'" == "singleunit" {
		local singleunit : char _dta[_svy_singleunit]
		CheckSingle `singleunit'
		return local singleunit `s(singleunit)'
		exit
	}
	di as err "_svyset get `name' not allowed"
end

program CheckName, sclass
	local 0 `", `0'"'
	capture syntax [,			///
		WTYPE WEXP WVAR			/// global names
		PWeight IWeight			///
		VCE MSE				///
		BRRweight FAY			///
		BSRweight BSN			///
		JKRweight			///
		SDRweight SDRFPC		///
		DOF				///
		POSTStrata POSTWeight		///
		CALMethod CALMOdel CALOpts	///
		SINGLEunit			///
		SU STRata FPC			/// stage names
		Weight				///
		STAGES				///
		stages_wt			///
	]
	if c(rc) {
		di as err "invalid survey characteristic"
		exit 198
	}
	local gname				///
		`stages'			///
		`stages_wt'			///
		`pweight' `iweight'		///
		`wtype' `wvar' `wexp'		///
		`vce' `mse'			///
		`brrweight' `fay'		///
		`bsrweight' `bsn'		///
		`jkrweight'			///
		`sdrweight' `sdrfpc'		///
		`dof'				///
		`poststrata' `postweight'	///
		`calmethod'			///
		`calmodel'			///
		`calopts'			///
		`singleunit'
	local sname `su' `strata' `fpc' `weight'
	local k : word count `gname' `sname'
	if `k' > 1 {
		di as err "too many names"
		exit 103
	}
	if `k' == 0 {
		di as err "name required"
		exit 100
	}
	sreturn local gname `gname'
	sreturn local sname `sname'
end

program CheckVar, sclass
	syntax varname
	sreturn local varname `varlist'
end

program CheckNumVar, sclass
	syntax varname(numeric)
	sreturn local varname `varlist'
end

program CheckFay, sclass
	local 0 `", fay(`0')"'
	syntax , fay(numlist max=1 >=0 <=2)
	if `fay' == 1 {
		di as err "option fay(1) is not allowed"
		exit 198
	}
	sreturn local value `fay'
end

program CheckBSN, sclass
	local 0 `", bsn(`0')"'
	syntax , BSN(numlist max=1 >0)
	sreturn local value `bsn'
end

program CheckDOF, sclass
	local 0 `", dof(`0')"'
	syntax , DOF(numlist max=1 >0)
	sreturn local value `dof'
end

program CheckVarlist, sclass
	syntax varlist
	sreturn local varlist `varlist'
end

program CheckNumVarlist, sclass
	syntax varlist(numeric)
	sreturn local varlist `varlist'
end

program CheckPostW, sclass
	syntax varname
	capture confirm string variable `varlist'
	if c(rc) == 0 {
		di as error "postweight may not be a string variable"
		exit 109
	}
	capture assert `varlist' >=0
	if c(rc) {
		di as err "poststratification weights cannot be negative"
		exit 459
	}
	sreturn local varname `varlist'
end

program CheckCalMethod, sclass
	local method : copy local 0
	if `"`method'"' == "" {
		di as err "calibration method required"
		exit 198
	}
	local 0 `", `0'"'
	capture syntax [, RAKE REGress]
	if c(rc) {
		di as err `"calibration method {br:`method'} not recognized"'
		exit 198
	}
	sreturn local method `rake' `regress'
end

program CheckPosInt
	confirm integer number `0'
	if `0' < 1 {
		di as err "'`0'' found where positive integer required"
		exit 7
	}
end

program CheckSingle, sclass
	local zero `"`0'"'
	local 0 `", `zero'"'
	capture syntax [, MISsing CERtainty SCAled CENtered ]
	if c(rc) {
		di as err `"singleunit(`zero') invalid"'
		exit 198
	}
	if `:list sizeof zero' == 0 {
		local missing missing
	}
	sreturn local singleunit `missing' `scaled' `certainty' `centered'
end

exit
