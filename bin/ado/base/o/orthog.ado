*! version 1.1.3  23sep2004
* 12dec2003 : BPP added time-series ops. for varlist
program define orthog, rclass
	version 6, missing

/* Parse. */

	syntax [varlist(ts numeric) ] [iweight pweight aweight fweight] /*
	*/ [if] [in], Generate(string) [ MATrix(string) ]

	tokenize `varlist'

	if "`matrix'"=="" {
		local o "*"
	}

/* Initialize matrices and variables. */

	local nvar : word count `varlist'
	`o' local ndim = `nvar' + 1
	`o' tempname r1 r2
	`o' matrix `r1' = J(`ndim',`ndim',0)
	`o' matrix `r1'[`ndim',`ndim'] = 1
	`o' matrix `r2' = `r1'

	tempvar xx
	qui gen double `xx' = . in 1 /* so any memory failure occurs
	                                in ParseVar
				     */
	ParseVar `nvar' `generat'
	local newvars `s(varlist)'

/* Mark sample and count obs. */

	marksample doit

	_nobs `doit' [`weight'`exp']
	local nobs `r(N)'

	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wexp [fweight`exp']
		}
		else	local wexp [aweight`exp']
	}

	quietly {

	/* First pass. */

		local i 1
		while `i' <= `nvar' {
			tempvar x`i'
			summarize ``i'' `wexp' if `doit', meanonly
			`o' matrix `r1'[`ndim',`i'] = r(mean)
			gen double `x`i'' = ``i'' - r(mean) if `doit'
			local i = `i' + 1
		}

		local i 1
		while `i' <= `nvar' {
			replace `xx' = `x`i''^2
			summarize `xx' `wexp', meanonly
			`o' matrix `r1'[`i',`i'] = sqrt(r(mean))
			replace `x`i'' = `x`i''/sqrt(r(mean))

			local j = `i' + 1
			while `j' <= `nvar' {
				replace `xx' = `x`i''*`x`j''
				summarize `xx' `wexp', meanonly
				`o' matrix `r1'[`i',`j'] = r(mean)
				replace `x`j'' = `x`j'' - r(mean)*`x`i''
				local j = `j' + 1
			}
			local i = `i' + 1
		}

	/* Second pass. */

		local i 1
		while `i' <= `nvar' {
			summarize `x`i'' `wexp', meanonly
			`o' matrix `r2'[`ndim',`i'] = r(mean)
			replace `x`i'' = `x`i'' - r(mean)
			local i = `i' + 1
		}

		local i 1
		while `i' <= `nvar' {
			replace `xx' = `x`i''^2
			summarize `xx' `wexp', meanonly
			`o' matrix `r2'[`i',`i'] = sqrt(r(mean))
			replace `x`i'' = `x`i''/sqrt(r(mean))

			local j = `i' + 1
			while `j' <= `nvar' {
				replace `xx' = `x`i''*`x`j''
				summarize `xx' `wexp', meanonly
				`o' matrix `r2'[`i',`j'] = r(mean)
				replace `x`j'' = `x`j'' - r(mean)*`x`i''
				local j = `j' + 1
			}
			local i = `i' + 1
		}
	}

	if "`matrix'"!="" {
		matrix `matrix' = `r1'*`r2'
		matrix rownames `matrix' = `newvars' _cons
		matrix colnames `matrix' = `*' _cons
	}

	ret scalar N = `nobs'

	nobreak {
		capture noisily break {
			local i 1
			while `i' <= `nvar' {
				local varname : word `i' of `newvars'
				rename `x`i'' `varname'
				label var `varname' "orthogonalized ``i''"
				local i = `i' + 1
			}
		}
		if _rc {
			local rc = _rc
			DropIt `newvars'
			error `rc'
		}
	}
end

program define ParseVar, sclass
	args nvar
	macro shift
	tokenize "`*'", parse("*")
	if "`2'"=="*" & "`3'"=="" {
		local i 1
		while `i' <= `nvar' {
			local newvars "`newvars' `1'`i'"
			local i = `i' + 1
		}
	}
	else local newvars `*'

	local 0 double(`newvars')
	nobreak {
		cap break syntax newvarlist(min=`nvar' max=`nvar' gen)
		local rc = _rc
		DropIt `varlist'
	}
	if `rc'==102 | `rc'==103 {
		if `nvar' > 1 { local s "s" }
		di in red "generate() must specify `nvar' new variable`s'"
		error `rc'
	}
	else if `rc' {
		di in red "error in generate()"
		local 0 double(`newvars')
		nobreak {
			cap noi break syntax /*
			*/ newvarlist(min=`nvar' max=`nvar' gen)
			local rc = _rc
			DropIt `varlist'
			exit `rc'
		}
	}

	sret local varlist `varlist'
end

program define DropIt
	local i 1
	while "``i''"!="" {
		cap drop ``i''
		local i = `i' + 1
	}
end

