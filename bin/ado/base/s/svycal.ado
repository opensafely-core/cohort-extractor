*! version 1.0.1  10oct2017
program svycal
	version 14

	tempname rhold
	_return hold `rhold'
	Calibrate `0'
	_return restore `rhold'
end

program Calibrate, sclass
	gettoken cmd 0 : 0

	local parse = "`cmd'" == "parse"
	if `parse' {
		gettoken cmd 0 : 0
		capture syntax [anything] [, *]
		local MODEL : copy local anything
		local OPTIONS : copy local options
	}

	local cmdlist	regress rake
	if !`: list cmd in cmdlist ' {
		di as err `"subcommand {bf:svycal} {bf:`cmd'} is unrecognized"'
		exit 199
	}

	if `parse' == 0 {
		local GENOPT GENerate(name)
	}

	local TOL 1e-7
	local MAXITER 1000
	syntax varlist(fv) [if] [in] [pw iw],	///
		`GENOPT'			///
		TOTals(string)			///
		[	noCONStant		///
			ll(numlist missingok)	///
			ul(numlist missingok)	///
			ITERate(int `MAXITER')	///
			TOLerance(real `TOL')	///
			FORCE			///
		]

	if `iterate' < 0 {
		di as err "suboption {bf:iterate()} invalid;"
		di as err "negative values not allowed"
		exit 198
	}

	if `parse' == 0 {
		confirm new variable `generate'
	}

	if `"`ll'"' != "" {
		capture numlist "`ll'", missingok max(1) range(<1)
		if c(rc) {
			di as err "suboption {bf:ll()} invalid;"
			if `:list sizeof ll' > 1 {
				di as err "too many values specified"
				exit 103
			}
			if `ll' >= 1 {
				di as err ///
		"`ll' observed where values less than 1 expected"
				exit 198
			}
		}
		if missing(`ll') {
			local ll
		}
		if `"`cmd'"' == "rake" {
			if `ll' < 0 {
				di as err "suboption {bf:ll()} invalid;"
				di as err ///
			"negative values not allowed for the rake method"
				exit 198
			}
		}
	}
	if `"`ul'"' != "" {
		capture numlist "`ul'", missingok max(1) range(>1)
		if c(rc) {
			di as err "suboption {bf:ul()} invalid;"
			if `:list sizeof ul' > 1 {
				di as err "too many values specified"
				exit 103
			}
			if `ul' <= 1 {
				di as err ///
		"`ul' observed where values greater than 1 expected"
				exit 198
			}
		}
		if missing(`ul') {
			local ul
		}
	}

	if "`cmd'" == "rake" {
		if "`ll'" == "" & "`ul'" != "" {
			local ll 0
		}
		if !inlist("`ll'", "0", "") & "`ul'" == "" {
			di as err "option {bf:rake()} invalid;"
			di as err ///
"suboption {bf:ul()} required when suboption {bf:ll()} is specified"
			exit 198
		}
	}

	if `iterate' < 0 {
		local iterate `MAXITER'
	}

	if `tolerance' <= 0 {
		local tolerance `TOL'
	}

	marksample touse

	tempname wvar
	if "`weight'" != "" {
		local wgt `"[`weight'=`wvar']"'
		quietly gen double `wvar' `exp' if `touse'
	}
	else {
		quietly gen double `wvar' = `touse' if `touse'
	}

	CheckConstant `totals'

	if `parse' {
		fvexpand `varlist' if `touse' `wgt'
	}
	else {
		_rmcoll `varlist' if `touse' `wgt', `constant' expand
	}
	local varlist `"`r(varlist)'"'
	local dim : list sizeof varlist
	local colna : copy local varlist

	if "`constant'" == "" {
		local ++dim
		local varlist `varlist' `touse'
		local colna `colna' _cons
	}

	tempname t
	matrix `t' = J(1,`dim',0)
	matrix colna `t' = `colna'

	_mkvec `t', from(`totals') update first error("totals")

	tempname all0
	mata: st_numscalar("`all0'", allof(st_matrix("`t'"),0))
	if `all0' {
		di as err "suboption {bf:totals()} invalid;"
		di as err "all totals set to zero"
		exit 198
	}

	if `parse' {
		local 0 `", `OPTIONS'"'
		syntax, TOTals(string) [*]
		gettoken totals tops : totals, parse(",")
		capture confirm matrix `totals'
		if c(rc) == 0 {
			// NOTE: redo OPTIONS, substituting the name=value
			// pairs syntax for the matrix
			local OPTIONS : copy local options
			local 0 : copy local tops
			syntax [, copy skip]
			if "`copy'`skip'" != ""{
				local TOPTS ", `copy'`skip'"
			}
			local dim = colsof(`t')
			local colna : colna `t'
			forval i = 1/`dim' {
				local val = `t'[1,`i']
				gettoken name colna : colna
				local TOTALS `TOTALS' `name'=`val'
			}
			local OPTIONS	totals(`TOTALS'`TOPTS')	`OPTIONS'
		}
		sreturn local method	`"`cmd'"'
		sreturn local model	`"`MODEL'"'
		sreturn local options	`"`OPTIONS'"'
		exit
	}

	// The following Mata functions assumes the following macro
	// definitions:
	//
	// 	t		- vector of population totals
	//	varlist		- variables corresponding to t
	//	wvar		- variable with original weight values
	//	generate	- new variable for adjusted weights
	//	ll		- lower limit for truncated linear calib
	//	ul		- upper limit for truncated linear calib
	//	iterate		- maximum iterations
	//	tolerance	- convergence tolerance
	//	force		- warning instead of error
	//	cmd		- name of calibration method:
	//				'linear'
	//				'rake'

	tempname ehold
	_est hold `ehold', restore nullok

	mata: st_svycal()
end

program CheckConstant
	syntax [anything(equalok)] [, COPY SKIP]

	if "`copy'" != "" {
		exit
	}

	capture confirm matrix `anything'
	if c(rc) == 0 {
		local colna : colna `anything'
		local junk : subinstr local colna "_cons" "", ///
			word count(local hascons)
		if `hascons' == 0 {
			c_local constant noconstant
		}
		exit
	}
	gettoken tok anything : anything , parse(" =")
	while "`tok'" != "" {
		if "`tok'" == "_cons" {
			exit
		}
		gettoken tok anything : anything , parse(" =")
	}
	c_local constant noconstant
end
exit
