*! version 1.3.3  19dec2016
program define lfit_p, sclass
	local vcaller = string(_caller())
	version 6.0, missing
/*
    This is a driver program for lfit, lroc, lstat, and lsens
    which parses and computes predicted probabilities.

    Input:   `1'  = tempvar name for mark/markout
	     `2'  = tempvar name for p (predicted probabilities)
	     `3'  = tempvar name for w (weights)
	     `4'+ = stuff to be parsed

    Output:   `1' = touse filled in
	      `2' = p filled in (missing if `touse'==0) 
	      `3' = w filled in (missing if `touse'==0) 
	      s(N)       = number of observations
	      s(depvar)  = y (dependent variable name)
	      s(beta)    = beta (vector) if beta() option specified
	      s(rules)   = `"rules"' if rules option specified
	      s(options) = macro holding other options
*/
	sret clear 
	gettoken touse 0: 0
	gettoken p     0: 0
	gettoken w     0: 0

	/* Parse. */

	syntax [varname(default=none)] [if] [in] [fweight] [, /*
		*/ ALL ASIF RULEs BETA(string) * ]

if "`asif'"!="" | "`rules'"!="" {
	if "`asif'"!="" { 
		di in red "option asif invalid"
	}
	else	di in red "option rules invalid"
	exit 198
}

	if `"`beta'"' == `""' { /* this is a post-logistic [probit] call */
		if `"`e(cmd)'"' != `"logistic"' & "`e(cmd)'"!="logit" & /*
		*/ `"`e(cmd)'"' != "probit" & `"`e(cmd)'"' != "dprobit" & /*
		*/ `"`e(cmd)'"' != "ivprobit" { 
			error 301
		}
		if `"`e(cmd)'"' == "ivprobit" & `"`e(method)'"' == "twostep" {
di in smcl as error "not available after {cmd:ivprobit, twostep}"
			exit 321
		}
		local y : word 1 of `e(depvar)'
		if `"`varlist'"' != `""' & `"`varlist'"' != `"`y'"' {
			di in red /*
			*/ `"varlist not allowed (except with beta() option)"'
			error 198
		}
		if `"`asif'"' != `""' & `"`rules'"' != `""' {
			di in red `"both asif and rules cannot be specified"'
			error 198
		}
        	if `"`if'`in'`all'"' == `""' {
			local if "if e(sample)"
        	}
		else if `"`all'"' != `""' & `"`if'`in'"' != `""' {
			di in red `"all option not allowed with if or in"'
			error 198
		}
        	if `"`weight'"' == `""' {
                	local weight `"`e(wtype)'"'
                	local exp    `"`e(wexp)'"'
        	}
	}
	else {	/* this is a call with vector of coefficients `beta' */
		/* assumed to be logit vector */

		if `"`asif'"' != `""' {
			di in red `"asif option not allowed with beta() option"'
			error 198
		}
		if `"`rules'"' != `""' {
			di in red `"rules option not allowed with beta() option"'
			error 198
		}
		capture di matrix(`beta'[1, 1])
		if _rc {
			di in red `"matrix `beta' not found"'
			exit 111
		}
		if `"`varlist'"' == `""' {
			di in red /*
			*/ `"dependent variable required with beta() option"'
			error 198
		}
		local y `"`varlist'"'
	}

       	mark `touse' `if' `in' [`weight'`exp']


	if "`e(cmd)'" == "ivprobit" {
		local vv version `vcaller':
	}
        quietly {
		if `"`beta'"' == `""' {
			if `vcaller' >= 15 & "`e(cmd)'" == "ivprobit" {
				`vv' predict double `p' if `touse', ///
					p `asif' `rules' total
			}
			else {
				`vv' ///
				predict double `p' if `touse', p `asif' `rules'
			}
		}
		else {
			matrix score double `p' = `beta' if `touse'
			replace `p' = exp(`p')/(1 + exp(`p')) if `touse'
		}

		markout `touse' `y' `p'

		replace `p' = . if `touse'==0

                if `"`weight'"' != `""' {
			gen double `w' `exp' if `touse'
		}
		else    gen byte   `w' = 1   if `touse'

		summarize `touse' [`weight'`exp'] if `touse'
	}

	if r(N) == 0 { error 2000 }

	sret local N = round(r(N),1)		/* number of obs */
	sret local depvar "`y'"			/* dependent variable name */
	sret local beta "`beta'"		/* `beta' if specified  */
	sret local rules "`rules'"		/* `rules' if specified	*/
	sret local options "`options'"		/* other options 	*/
end
