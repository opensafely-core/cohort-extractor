*! version 5.0.1  29jan2015
program define ztweib_5
	version 5.0
	di in gr "(you are running stweib from Stata version 5)"
	if "`1'"=="" | bsubstr("`1'",1,1)=="," {
		local options "ESTImate noHR TR *"
		parse "`*'"
		if "`estimat'"=="" {
			if "$S_E_cmd2" != "stweib" { error 301 }
			if "$S_E_frm2"=="hazard" {
				if "`hr'"=="" { local hr "hr" }
				else local hr 
				if "`tr'"!="" {
					di in red "tr not allowed"
					exit 198
				}
			}
			else	local hr

			if "$S_E_t0"=="" {
				local t0 0
			}
			else	local t0 "$S_E_t0"
			di _n in gr /*
			*/ "Weibull regression -- entry time `t0'"
			if "$S_E_frm2"=="time" {
				di in gr "log expected time form" _n
			}
			else	di in gr "log relative hazard form" _n
			zt_hcd_5
			di
			weibull, `hr' `tr' `options' nohead
			exit
		}
	}

	zt_is_5


	local varlist "opt ex none"
	local options "CLuster(string) CMD ESTImate noHR Level(integer $S_level) Robust noSHow TIme TR *"
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

	if "`time'"=="" & "`tr'"=="" {
		local time "hazard"
		if "`hr'"=="" {
			local ehr "hr"
		}
		else	local ehr
	}
	else	local time

	zt_sho_5 `show'

	di

	if "`cmd'"!="" {
		di _n in gr "-> weibull `t' `varlist' `w' `if' `in', `time' `robust' `cluster' `t0' `ehr' `d' `options'"
		exit
	}
	weibull `t' `varlist' `w' if `touse', nocoef `time' `robust' `cluster' `t0' `ehr' `d' `options'
	zt_hc_5 `touse'
	global S_E_cmd2 "stweib"
	stweib, `hr' `tr' level(`level')
end
