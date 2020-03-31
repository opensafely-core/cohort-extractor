*! version 5.0.2  29jan2015
program define ztcox_5
	version 5.0, missing
	di in gr "(you are running stcox from Stata version 5)"

	if "`1'"=="" | bsubstr("`1'",1,1)=="," {
		local options "ESTImate noHR *"
		parse "`*'"
		if "`estimat'"=="" {
			if "$S_E_cmd2" != "stcox" {
				error 301 
			}
			if "`hr'"=="" { local hr "hr" }
			else local hr 
			if "$S_E_svn"=="" {
				local h "Cox regression"
			}
			else	local h "Stratified Cox regr."
			if "$S_E_t0"=="" {
				local t0 0
			}
			else	local t0 $S_E_t0
			di _n in gr "`h' -- entry time `t0'" _n
			zt_hcd_5
			di
			cox, nohead `hr' `options'
			exit
		}
	}

	zt_is_5


	local varlist "opt ex none"
	local options "CLuster(string) CMD ESTImate noHR Level(integer $S_level) Robust noSHow *"
	local if "opt"
	local in "opt"
	parse "`*'" 

	local id : char _dta[st_id]
	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]
	local wt : char _dta[st_wt]

	tempvar touse 
	zt_smp_5 `touse' "`if'" "`in'" "`cluster'"
	markout `touse' `varlist'

	if "`wt'"=="pweight" {
		local robust "robust"
	}

	if "`robust'"!="" & "`cluster'"=="" & "`id'"!="" {
		local cluster "`id'"
	}
	if "`cluster'"!="" {
		local cluster "cluster(`cluster')"
	}

	if "`t0'" != "" {
		local t0 "t0(`t0')"
	}

	if "`d'" != "" { 
		local d "dead(`d')"
	}

	zt_sho_5 `show'

	if "`cmd'"!="" {
		di _n in gr "-> cox `t' `varlist' `w' `if' `in', `robust' `cluster' `t0' `hr' `d' `options'"
		exit
	}
	cox `t' `varlist' `w' if `touse', `robust' `cluster' `t0' `d' `options' nocoef
	if _result(1)==0 | _result(1)>=. { 
		exit 2001
	}
	global S_E_ll = _result(2)
	global S_E_chi2 = _result(6)
	global S_E_mdf = _result(3)
	zt_hc_5 `touse'
	global S_E_cmd2 "stcox"
	stcox, `hr' level(`level')
end
