*! version 1.0.3  28apr2009
program define _isfit /* cons */
	version 7
	if "`e(cmd)'" == "anova" {
		if 0`e(version)' > 1 {
			if "`1'"!="anovaok" & "`2'"!="anovaok" ///
			   & "`1'"!="newanovaok" & "`2'"!="newanovaok" {
				di as err "not appropriate after anova"
				exit 301
			}
		}
		else if "`1'"!="anovaok" & "`2'"!="anovaok" {
			di as err "not appropriate after anova"
			exit 301
		}
	}
	else if "`e(cmd)'"!="fit" & "`e(cmd)'"!="regress" {
		error 301
	}
	if "`e(model)'"!="ols" {
		di as err "not appropriate after IV estimation"
		exit 301
	}
	if "`1'"=="cons" | "`2'"=="cons" { 
		if "`e(cmd)'" == "anova" && "`e(version)'" == "2" {
			capture local b = _b[_cons]
			if _rc { 
				di as err /*
				   */ "not appropriate after anova, nocons"
				exit 301
			}
		}
		else if "`e(cmd)'" == "anova" {
			anovadef
			if "`r(tid1)'" != "1" {
				di as err "not appropriate after anova, nocons"
				exit 301
			}
		}
		else {
			capture local b = _b[_cons]
			if _rc { 
				di as err /*
				   */ "not appropriate after regress, nocons"
				exit 301
			}
		}
	}
end
