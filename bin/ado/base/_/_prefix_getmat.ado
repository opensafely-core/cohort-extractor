*! version 1.0.1  03jan2005
program _prefix_getmat, rclass
	version 9
	syntax varlist , opt(name) [	///
		char(name)		///
		mat(string)		///
		Required		///
		caller(name)		///
	]

	local ncol : word count `varlist'
	if `"`mat'"' != "" {
		tempname b
		// user supplied matrix
		capture numlist `"`mat'"'
		if !c(rc) {
			local nlist `r(numlist)'
			local rmat : subinstr local nlist " " ",", all
			capture matrix `b' = `rmat'
			if c(rc) {
				di as err "option `opt'() invalid"
				exit 198
			}
		}
		else {
			capture matrix `b' = `mat'
			if c(rc) {
				di as err "option `opt'() invalid"
				exit 198
			}
		}
		if rowsof(`b') != 1 {
			di as err "option `opt'() requires a row vector"
			exit 198
		}
		if `ncol' < colsof(`b') {
			di as err "too many values in option `opt'()"
			exit 503
		}
		else if `ncol' > colsof(`b') {
			di as err "too few values in option `opt'()"
			exit 503
		}
		local cnames : colfullnames `b'
		if !`:list cnames === varlist' {

			// NOTE: if column names in user supplied `b' do not
			// match up with `varlist', assume the column names
			// are meaningless, but the order is correct

			matrix colname `b' = `varlist'
			matrix rowname `b' = y1
		}
		else if !`:list cnames == varlist' {

			// NOTE: column names in user supplied `b' 
			// match up with `varlist', but they are in a
			// different order, so reorder `b'

			tempname bb
			matrix `bb' = J(1,`ncol',0)
			matrix colname `bb' = `varlist'
			matrix rowname `bb' = y1
			forval i = 1/`ncol' {
				local var : word `i' of `varlist'
				matrix `bb'[1,`i'] = `b'[1,"`var'"]
			}
			matrix `b' = `bb'
		}
	}
	else {
		if `"`char'"' == "" & "`required'" != "" {
			NeedOpt `opt' `caller'
		}
		if `"`char'"' != "" {
			tempname b
			// get matrix elements from variable characteristics
			foreach var of local varlist {
				local ch : char `var'[`char']
				capture confirm number `ch'
				if !_rc {
					matrix `b' = nullmat(`b'), `ch'
				}
				else if "`required'" != "" {
					NeedOpt `opt' `caller'
				}
				else {
					local b
					continue, break
				}
			}
			if "`b'" != "" {
				matrix colname `b' = `varlist'
				matrix rowname `b' = y1
			}
		}
	}
	if "`b'" != "" {
		return matrix mat `b'
	}
end

program NeedOpt
	args opt caller
	if "`caller'" == "" {
		di in smcl as err "{p 0 0 2}option `opt'() required{p_end}"
	}
	else {
		di in smcl as err ///
		"{p 0 0 2}option `opt'() is required" ///
		" with datasets that are not generated" ///
		" by the `caller' command{p_end}"
	}
	exit 198
end

exit
