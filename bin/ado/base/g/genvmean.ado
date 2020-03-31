*! version 2.0.0  07/22/91
program define genvmean
	version 3.0
	mac def _varlist "req ex min(2)"
	mac def _in "opt"
	mac def _if "opt" 
	mac def _options "Generate(str)"
	parse "%_*"
	confirm new var %_generat
	tempvar NOBS g
	quietly { 
		gen float %_g = 0 %_if %_in
		gen long %_NOBS = 0 %_if %_in
		parse "%_varlist", parse(" ")
		while "%_1"!="" {
			replace %_g = %_g + cond(%_1==.,0,%_1) %_if %_in
			replace %_NOBS = %_NOBS + cond(%_1==.,0,1) %_if %_in
			mac shift 
		}
		replace %_g = %_g / %_NOBS %_if %_in
	}
	rename %_g %_generat
end
