*! version 6.1.2  17apr2019
program define stir, byable(recall) sort
	version 7, missing
	if _caller()<6 { 
		if _by() { error 190 }
		ztir_5 `0'
		exit
	}
	st_is 2 analysis
	syntax varname [if] [in] [, STrata(varname) noSHow tb Level(cilevel) *]

	if `"`strata'"'!=`""' {
		local by `"by(`strata')"'
	}

	if "`options'" != "" & `"`strata'"' == `""' {
		local w: word count `options'
		if (`w' > 1) {
			di as err "options {bf:`options'} are relevant " ///
				"only if {bf:strata()} is specified"
		}
		else {
			di as err "option {bf:`options'} is relevant " ///
				"only if {bf:strata()} is specified"
		}
		exit 198
	}

	st_show `show'

	tempvar touse 
	st_smpl `touse' `"`if'"' `"`in'"'
	if _by() {
		qui replace `touse'=0 if `_byindex'!=_byindex()
	}

	local id : char _dta[st_id]
	local w  : char _dta[st_w]

	if `"`w'"'!=`""' {
		local wt : char _dta[st_wt]
		if `"`wt'"'!=`"fweight"' {
			di as err `"stir does not allow `wt's"'
			exit 101
		}
	}
	tempvar atrisk
	qui gen double `atrisk' = _t - _t0
	label var `atrisk' `"Time"'
	

	tempname xpos
	local ty : type `varlist'
	if bsubstr(`"`ty'"',1,3)==`"str"' { 
		Unstring `varlist' `touse' -> `xpos'
	}
	else	Uncode `varlist' `touse' -> `xpos'

	local label : var label `varlist'
	if trim(`"`label'"')==`""' {
		local label `"`varlist'"'
	}
	label var `xpos' `"`label'"'

	if (_caller()<14) {
		local lbl : var label _d
		if `"`lbl'"'== "" {
			tempvar d 
			qui gen byte `d' = _d
			label var `d' "Failure"
		}
		else	local d _d
	}
	else { //as of Stata 14, label is always 'Failure'
		tempvar d 
		qui gen byte `d' = _d
		label var `d' "Failure"
	}

	ir `d' `xpos' `atrisk' `w' if `touse', ///
		`by' `options' `tb' level(`level')
end

program define Uncode /* vn touse -> xpos */
	args vn touse junk  xpos

	tempname smin smax
	quietly summ `vn' if `touse'
	scalar `smin' = r(min)
	scalar `smax' = r(max)
	qui gen byte `xpos'=cond(`vn'==`smin',0, /*
			*/ cond(`vn'==`smax',1,.)) if `touse'
	capture assert `vn'>=. if `xpos'>=. & `touse'
	if _rc {
		di as err `"`vn' takes on more than two values"'
		exit 134
	}

	local min=`smin'
	local max=`smax'
	local lbl : value label `vn'
	if `"`lbl'"'!=`""' {
		local min : label `lbl' `min'
		local max : label `lbl' `max'
	}
	di _n as txt `"note:  Exposed <-> "' /* 
		*/ as res `"`vn'==`max'"' /*
		*/ as txt `" and Unexposed <-> "' /*
		*/ as res `"`vn'==`min'"'
end

program define Unstring /* vn touse -> xpos */
	version 13
	args vn touse junk xpos
	tempvar min max

	local maxdisplen 32

	quietly {
		sort `touse' `vn'
		by `touse' `vn': gen `c(obs_t)' `xpos'=1 if _n==1 & `touse'
		replace `xpos'=sum(`xpos')-1 if `touse'
	}
	capture assert `xpos'==1 in l
	if _rc { 
		di as err `"`vn takes on more than two values"'
		exit 134
	}
	scalar `max'      =  strtrim(udsubstr(`vn'[_N], 1, `maxdisplen'))
	local   maxdotdot = cond(udstrlen(`vn'[_N])>`maxdisplen', "..", "")


	tempvar j
	quietly {
		gen `c(obs_t)' `j' = _n if `xpos'==0
		replace `j' = `j'[_n-1] if `j'>=.
	}
	scalar `min'      =  strtrim(udsubstr(`vn'[`j'[_N]], 1, `maxdisplen'))
	local   mindotdot = cond(udstrlen(`vn'[`j'[_N]])>`maxdisplen', "..", "")

	di _n 
	di as smcl "{p 0 7 2}"
	di as txt `"note:  Exposed <-> "' /* 
		*/ as res `"`vn'=="' `max' as txt "`maxdotdot'"/*
		*/ as txt `" and Unexposed <-> "' /*
		*/ as res `"`vn'=="' `min' as txt "`mindotdot'"
	di as smcl "{p_end}"
end
