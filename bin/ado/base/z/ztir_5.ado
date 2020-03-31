*! version 5.0.6  09feb2015
program define ztir_5
	version 5.0, missing
	di in gr "(you are running stir from Stata version 5)"
	zt_is_5
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options "STrata(string) noSHow *"
	parse "`*'"

	if "`strata'"!="" {
		unabbrev `strata', max(1)
		local strata "$S_1"
		local by "by(`strata')"
	}

	zt_sho_5 `show'

	tempvar touse 
	mark `touse' `if' `in'

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]

	if "`w'"!="" {
		local wt : char _dta[st_wt]
		if "`wt'"!="fweight" {
			di in red "stir does not allow `wt's"
			exit 101
		}
	}
	if "`t0'"=="" {
		local atrisk `t'
	}
	else {
		tempvar atrisk
		qui gen double `atrisk' = `t'-`t0'
		label var `atrisk' "Time"
	}

	if "`d'"=="" {
		tempvar d
		qui gen byte `d'=1
	}

	capture assert `d'==0 | `d'==1
	if _rc {
		tempvar myd
		qui gen `myd' = cond(`d'!=0,1,0)
	}
	else	local myd `d'

	tempname xpos
	local ty : type `varlist'
	if bsubstr("`ty'",1,3)=="str" { 
		Unstring `varlist' `touse' -> `xpos'
	}
	else	Uncode `varlist' `touse' -> `xpos'

	local label : var label `varlist'
	if trim("`label'")=="" {
		local label "`varlist'"
	}
	label var `xpos' "`label'"
	ir `myd' `xpos' `atrisk' `w' if `touse', `by' `options'
end

program define Uncode /* vn touse -> xpos */
	local vn "`1'"
	local touse "`2'"
	local xpos "`4'"

	tempname smin smax
	quietly summ `vn' if `touse'
	scalar `smin' = _result(5)
	scalar `smax' = _result(6)
	gen byte `xpos'=cond(`vn'==`smin',0, /*
			*/ cond(`vn'==`smax',1,.)) if `touse'
	capture assert `vn'>=. if `xpos'>=. & `touse'
	if _rc {
		di in red "`vn takes on more than two values"
		exit 134
	}

	local min=`smin'
	local max=`smax'
	local lbl : value label `vn'
	if "`lbl'"!="" {
		local min : label `lbl' `min'
		local max : label `lbl' `max'
	}
	di _n in gr "note:  Exposed <-> " /* 
		*/ in ye "`vn'==`max'" /*
		*/ in gr " and Unexposed <-> " /*
		*/ in ye "`vn'==`min'"
end

program define Unstring /* vn touse -> xpos */
	local vn "`1'"
	local touse "`2'"
	local xpos "`4'"

	quietly {
		sort `touse' `vn'
		by `touse' `vn': gen `c(obs_t)' `xpos'=1 if _n==1 & `touse'
		replace `xpos'=sum(`xpos')-1 if `touse'
	}
	capture assert `xpos'==1 in l
	if _rc { 
		di in red "`vn takes on more than two values"
		exit 134
	}
	local max = `vn'[_N]
	tempvar j
	quietly {
		gen `c(obs_t)' `j' = _n if `xpos'==0
		replace `j' = `j'[_n-1] if `j'>=.
	}
	local min = `vn'[`j'[_N]]
	di _n in gr "note:  Exposed <-> " /* 
		*/ in ye "`vn'==`max'" /*
		*/ in gr " and Unexposed <-> " /*
		*/ in ye "`vn'==`min'"
end
