*! version 1.0.1  25feb2019
program _bayesmh_check_saved
	version 16
	
	args bayescmd subcmd caller
	
	if ("`e(cmd)'" != "bayesmh" & "`e(prefix)'"!="bayes") {
		exit
	}
	
	if (`"`e(filename)'"'==`"`c(bayesmhtmpfn)'"' | ///
	    `"`e(filename)'"'=="_bayesmh_sim.dta") {
		di as err "{p}you must save simulation results"
		di as err "using {bf:`bayescmd', saving()} before"
		if `"`caller'"' != "" {
			di as err "using {bf:`caller'}{p_end}"
		}
		else {
			di as err "using {bf:estimates `subcmd'}{p_end}"
		}
		exit 321
	}
end