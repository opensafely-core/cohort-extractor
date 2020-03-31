*! version 1.1.0  08aug2016
program mestreg_p, eclass
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	
	if "`e(cmd2)'" != "mestreg" & "`e(cmd2)'" != "xtstreg" {
		di "{err}last estimates not found"
		exit 198
	}
	if "`e(distribution)'"=="" {
		di "{err}e(distribution) not found"
		exit 198
	}
		
	syntax  anything(id="stub* or newvarlist") 	///
		[if] [in] [,				///
		REFfects				///
		reses(string)	 			///
							///
		mean					///
		MEDian					///
		HAzard					///
		Surv					///
		eta					///
		xb					///
		stdp					///
		DENsity					///
		DISTribution				///
		SCores					///
							///		
		CONDitional1(string)			///
		CONDitional				///
		UNCONDitional				/// undocumented
		MARGinal				///
		EBMEANs					///
		EBMODEs					///
							///
		noOFFset				///
							///
		INTPoints(passthru)			///
		ITERate(passthru)			///
		TOLerance(passthru)			///
	]
	
	if !missing("`median'") {
		if !missing("`marginal'") {
			di as err "option {bf:marginal} not allowed "	///
				"with {bf:median}"
			exit 198
		}
		if !missing("`unconditional'") {
			di as err "option {bf:unconditional} not allowed " ///
				"with {bf:median}"
			exit 198
		}
	}
	
	local intopts `intpoints' `iterate' `tolerance'
	
	local STAT `reffects' `mean' `median' `hazard' `surv' `eta' 	///
		`xb' `stdp'  `density' `distribution' `scores'
	opts_exclusive "`STAT'"
	
	if "`scores'" != "" {
		`vv' gsem_p `0'
		exit
	}

	if missing("`STAT'")  {
		local STAT mu
		di "{txt}(option {bf:mean} assumed)"
	}
	if "`STAT'"=="mean" local STAT mu
	if "`STAT'"=="reffects" local STAT latent
	
	local NAME ///
`mean'`median'`hazard'`surv'`eta'`xb'`stdp'`density'`distribution'
	if !missing("`NAME'") {
		if !missing("`reses'") {
			di "{err}option {bf:reses()} not allowed with " ///
				"option {bf:`NAME'}"
			exit 198
		}
	}
		
	if "`unconditional'" != "" {
		opts_exclusive "unconditional `xb'"
		opts_exclusive "unconditional `stdp'"
		opts_exclusive "unconditional `reffects'"
		opts_exclusive "unconditional `ebmeans'"
		opts_exclusive "unconditional `ebmodes'"
		local marginal marginal
	}
	if "`conditional1'" == "" {
		if "`conditional'" != "" {
			opts_exclusive "conditional `xb'"
			opts_exclusive "conditional `stdp'"
			opts_exclusive "conditional `reffects'"
			opts_exclusive "conditional `unconditional'"
			opts_exclusive "conditional `marginal'"
			opts_exclusive "conditional `ebmodes'"
			local ebmeans ebmeans
		}
	}
	else {
		ParseCond1, `conditional1'
		local condopt "conditional(`conditional1')"
		opts_exclusive "`condopt' `stdp'"
		opts_exclusive "`condopt' `xb'"
		opts_exclusive "`condopt' `reffects'"
		opts_exclusive "`condopt' `unconditional'"
		opts_exclusive "`condopt' `marginal'"
		if "`conditional1'" != "fixedonly" {
			opts_exclusive "`condopt' `fixedonly'"
		}
		else	local fixedonly fixedonly
		if "`conditional1'" != "ebmeans" {
			opts_exclusive "`condopt' `ebmeans'"
			opts_exclusive "`condopt' `conditional'"
		}
		else	local ebmeans ebmeans
		if "`conditional1'" != "ebmodes" {
			opts_exclusive "`condopt' `ebmodes'"
		}
		else	local ebmodes ebmodes
	}
	
	local mm `marginal' `ebmeans' `ebmodes'
	opts_exclusive "`xb' `mm'"
	opts_exclusive "`stdp' `mm'"
	local mm `marginal'`ebmeans'`ebmodes'
	if "`mm'"=="" {
		if "`c(marginscmd)'" == "on" {
			local mm marginal
		}
		else {
			local mm ebmeans
		}
	}
	
	if "`ebmodes'" != "" {
		local mms modes
	}
	else {
		local mms means
	}
	
	local fixed `fixedonly'`xb'`stdp'
	if "`fixed'" != "" local mm
	
	if "`STAT'"=="latent" & !e(k_r) {
		di "{err}random-effects equation(s) empty; predictions of " ///
			"random effects not available"
		exit 198
	}
	
	if "`reses'" != "" local reses se(`reses')
	if "`reses'" != "" & "`reffects'"=="" {
		di "{err}option {bf:reses()} requires the {bf:reffects} " ///
			" option"
		exit 198
	}

	// need to calculate outside of gsem
	local type "`median'`hazard'"
	
	if "`reffects'" != "" {
		di as txt "(calculating posterior `mms' of random effects)"
	}
	else if "`fixed'"=="" & "`mm'"!="marginal" & "`STAT'"!="median" {
	    if e(k_hinfo) != 0 {
		di as txt "(predictions based on fixed effects and "	///
			"posterior `mms' of random effects)"
	    }
	}

	local opts `reses' `mm' `fixedonly' `intopts' `offset'

	local gsem = "`type'"==""
	if `gsem' {
		`vv' gsem_p `anything' `if' `in' , `STAT' `opts'
		exit
	}

	// predict median or hazard

	local opts `mm' `fixedonly' `intopts' `offset'

	gettoken sttyp newvar : anything
	if missing("`newvar'") local newvar `sttyp'

	if "`type'"=="median" {
		`vv' PredMedian `anything' `if' `in', `opts'
		if !missing("`fixedonly'") {
			lab var `newvar' "Predicted median, fixed portion only"
		}
		else {
			lab var `newvar' "Predicted median"
		}
		exit
	}

	if "`type'"=="hazard" {
		tempvar sur den
		qui `vv' gsem_p double `den' `if' `in', density `opts'
		qui `vv' gsem_p double `sur' `if' `in', surv `opts'
		qui gen `anything' = `den' / `sur'
		if !missing("`fixedonly'") {
			lab var `newvar' "Predicted hazard, fixed portion only"
		}
		else if "`mm'"=="marginal" {
			lab var `newvar' "Marginal predicted hazard"
		}
		else {
			lab var `newvar' "Predicted hazard"
		}
		exit
	}

end

program ParseCond1
	local	OPTS	EBMEANs		///
			EBMODEs		///
			FIXEDonly
	capture syntax [, `OPTS' ]
	if c(rc) {
		di as err "invalid {bf:conditional()} option;"
		syntax [, `OPTS' ]
		error 198 // [sic]
	}
	local cond `ebmeans' `ebmodes' `fixedonly'
	if `:list sizeof cond' > 1 {
		di as err "invalid {bf:conditional()} option;"
		opts_exclusive "`cond'"
	}
	c_local conditional1 `cond'
end

program PredMedian
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	syntax newvarname [if] [in] [, noOFFset EBMEANs EBMODEs FIXEDonly *]
	
	local ff `ebmeans' `ebmodes' `fixedonly'
	local cc conditional(`ff')
	if "`e(cmd2)'" == "mestreg" local eta eta `cc'
	else local eta xb
	
	marksample touse, novarlist

	local dist `e(distribution)'
	local time = "`e(frm2)'"=="time"
	
	tempvar z
	tempname p ll2

	scalar `ll2' = log(log(2))

	if "`dist'"=="weibull" {
		qui predict double `z' if `touse', `eta' `offset' `options'
		scalar `p' = exp(_b[/ln_p])
		if `time' qui replace `z' = exp(`z'+`ll2'/`p') if `touse'
		else qui replace `z' = exp(-`z'/`p'+`ll2'/`p') if `touse'
	}

	if "`dist'"=="exponential" {
		qui predict double `z' if `touse', `eta' `offset' `options'
		if `time' qui replace `z' = exp(`z' + `ll2') if `touse'
		else qui replace `z' = exp(-`z' + `ll2') if `touse'
	}

	if "`dist'"=="lognormal" | "`dist'"=="loglogistic" {
		qui predict double `z' if `touse', `eta' `offset' `options'
		qui replace `z' = exp(`z') if `touse'
	}

	if "`dist'"=="gamma" {
		qui `vv' gsem_p double `z' if `touse', mu `offset' `ff' `options'
		scalar `p' = exp(_b[/logs])
		qui replace `z' = `p'^2*`z'*invgammap(1/`p'^2,.5) if `touse'
	}
	
	qui generate `typlist' `varlist' = `z' if `touse'
end

exit
