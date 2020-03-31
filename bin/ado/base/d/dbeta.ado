*! version 2.0.0  07/22/91
program define dbeta
	version 3.0
	mac def _varlist "req ex min(2)"
	mac def _if "opt"
	mac def _in "opt"
	mac def _options "Generate(string)"
	parse "%_*"
	if "%_generat"=="" { error 198 } 
	conf new var %_generat
	parse "%_varlist", parse(" ")
	tempvar HAT RSTU RES SRES RESULT
	mac def _lhs %_1
	mac shift
	noisily reg %_lhs %_* %_if %_in
	if _b[%_1]==0 {
		di in blu "(%_1 was dropped)"
		exit
	}
	if _b[_cons]==0 {
		di in red "specify model with constant"
		exit 2001
	}
	mac def _i 2
	while ("%`_%_i"~="") {
		if _b[%`_%_i]==0 {
			mac def _%_i " "
		}
		mac def _i=%_i+1
	}
	quietly {
		pred double %_HAT %_if %_in, hat
		pred double %_RSTU %_if %_in, rstud
		reg %_* %_if %_in
		pred double %_RES %_if %_in, res
		gen double %_SRES=sum(%_RES^2)
		gen %_RESULT=%_RSTU*%_RES/sqrt((1-%_HAT)*%_SRES[_N])
		label var %_RESULT "DF-Betas for %_1"
	}
	di _n in bl "(%_generat now contains DF-Betas for %_1)"
	rename %_RESULT %_generat
end
