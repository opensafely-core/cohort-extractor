*! version 1.2.0  08dec2008
program signestimationsample, eclass
	version 10

	syntax varlist(fv) [, EXTRA(varlist)]

	if (`"`e(wexp)'"'!="") {
		local wvar = strtrim(substr(strtrim(`"`e(wexp)'"'), 2, .))
		capture confirm var `wvar'
		if _rc {
			tempvar wvar 
			qui gen float `wvar' `e(wexp)' if e(sample)
		}
	}
	qui _datasignature `varlist' `wvar' `extra', ///
				esample nodefault nonames
	eret local datasignature = r(datasignature)
	eret local datasignaturevars `varlist'
end
exit
/*
    1.  Note that `wvar' is created as a -float-.  That is adequate 
        for data-signature purposes.

    2.  As of 11may2006, option extra() is not documented.   Both 
        -signestimationsample- and -checkestimationsample- allow this
        option.  It was included in case the caller had extra temporary 
        variables.  For instance, say in the estimation command there 
        is option -someformula(exp)-.  Someplace in the estimation 
        code, the caller codes, 

		if ("`someformula'"!="") {
			tempvar xyz
			qui gen double `xyz' = `someformula' if `touse'
		}

        When it comes time to sign the estimation sample, the caller can 
        code, 

		signestimationsample ..., extra(`xyz')

	At checkestimationsample time, it will be the caller's responsibility
	to recreate `xyz', e.g., 

		if ("`e(someformula)'" != "") {
			tempvar fmla
			qui gen double `fmla' = `e(someformula)' if e(sample)
		}

	and then the -checkestimationsample- command would be 

		checkestimationsample, extra(`fmla')

	The point is that the `xyz' and `fmla' variables are not expected to 
	have the same name (even if they had the same macro name), and 
	so it would not have done to code 

		signestimationsample ... `xyz'

	because -signestimationsample- saves the variable names in e() and, 
	when -checkestimationsample- reaccesses them later, that name will be 
	different.

	-extra()- is undocumented because, given how estimation commands are
	written these days, we do not know of an actual example where 
	someone would need it.

	If you use this undocumented option, please inform StataCorp. 
        We will then document it and make it official.
*/
