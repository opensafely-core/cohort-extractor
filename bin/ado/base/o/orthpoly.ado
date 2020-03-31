*! version 1.0.6  23sep2004
* Computes orthogonal polynomials using the Christoffel-Darboux
* recurrence formula
program define orthpoly, rclass
	version 6, missing
	syntax varname(numeric) [iw pw aw fw] [if] [in] [, /*
		*/ Degree(integer 1) Generate(string) Poly(string) ]
	marksample doit
	local x "`varlist'"

	if `degree' < 1 {
		di in red "degree() must be positive"
		exit 499
	}
	if "`generat'"=="" & "`poly'"=="" {
		di in red "generate() or poly() required"
		exit 100
	}
	if "`generat'" != "" {
		parsevar `degree' `generat'
		local varlist "`s(varlist)'"
	}
	if "`poly'" != "" {
		tempname p p1
		local dd = `degree' + 1
		matrix `p' = J(`dd', `dd', 0)
		matrix `p'[1, 1] = 1
	}
	if "`weight'"!="" {
		local awt `"[aw`exp']"'
	}

	tempname a b c
	tempvar t

	quietly {
		gen double `t' = .
		local q0 1
		local i 1
		while `i' <= `degree' {
			local j = `i' - 1
			replace `t' = `x'*((`q`j'')^2) if `doit'
			summarize `t' `awt' if `doit', meanonly
			local nobs `r(N)'
			scalar  `b' = r(mean)
			replace `t' = `x'*`t' if `doit'
			summarize `t' `awt' if `doit', meanonly
			scalar  `a' = r(mean)
			if `i' > 1 {
				local k = `i' - 2
				replace `t' = `x'*`q`j''*`q`k'' if `doit'
				summarize `t' `awt' if `doit', /*
				*/ meanonly
				scalar  `c' = r(mean)
			}
			else {
				local k 0
				scalar `c' = 0
			}

			scalar `a' = 1/sqrt(`a' - `b'*`b' - `c'*`c')
			scalar `b' = -`a'*`b'
			scalar `c' =  `a'*`c'

			tempvar q`i'
			gen double `q`i'' = (`a'*`x' + `b')*`q`j'' /*
			*/		    - `c'*`q`k'' if `doit'

			local i = `i' + 1

			if "`poly'" != "" {
				local j = `j' + 1
				local k = `k' + 1
				local pnames "`pnames' deg`j'"
				matrix `p'[`i',1] =   `b'*`p'[`j',1] /*
				*/		    - `c'*`p'[`k',1]
				local h 2
				while `h' <= `i' {
					matrix `p'[`i',`h'] =        /*
					*/	  `a'*`p'[`j',`h'-1] /*
					*/	+ `b'*`p'[`j',`h']   /*
					*/	- `c'*`p'[`k',`h']
					local h = `h' + 1
				}
			}
		} /* end of i loop */
	} /* end of quietly */

	if "`generat'" != "" {
		nobreak {
			capture noisily break {
				tokenize `varlist'
				local i 1
				while `i' <= `degree' {
					rename `q`i'' ``i''
					label var ``i'' /*
					*/ "deg=`i' orth. poly. for `x'"
					local i = `i' + 1
				}
			}
			if _rc {
				local rc = _rc
				local i 1
				while `i' <= `degree' {
					capture drop ``i''
					local i = `i' + 1
				}
				error `rc'
			}
		}
	}

	if "`poly'" != "" {
		matrix `p1' = `p'[1,1...]  /* interchange top row and bottom */
		matrix `p' = `p'[2...,1...]
		matrix `p' = nullmat(`p') \ `p1'
		matrix `p1' = `p'[1...,1]  /* interchange first column and last
		*/
		matrix `p' = `p'[1...,2...]
		matrix `poly' = `p' , `p1'
		matrix colnames `poly' = `pnames' _cons
		matrix rownames `poly' = `pnames' _cons
	}

	ret scalar N = `nobs'
end

program define parsevar, sclass
	gettoken number 0 : 0
	tokenize `"`0'"', parse(" *")
	if "`2'"=="*" & "`3'"=="" {
		if `number' > 1 {
			local 0 `"`1'1-`1'`number'"'
		}
		else 	local 0 `"`1'1"'
	}
	syntax newvarlist
	local nvar : word count `varlist'
	if `nvar' != `number' {
		if `number' > 1 { local s "s" }
		di in red "generate() must specify `number' new variable`s'"
		exit cond(`nvar'<`number', 102, 103)
	}
	sret local varlist "`varlist'"
end
