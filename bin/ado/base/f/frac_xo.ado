*! version 1.1.2 06May2000.
program define frac_xo, rclass 
/* transform x if necessary. Deal with zeroes.  */
/*
	Calculates transformed xvar for all data, but uses touse filter
	when numbers (e.g. expx) must be calculated to do transformations.
	Returns:
		scalar r(N) 	number of obs
		scalar r(zeta)
		scalar r(shifted) 
		string r(expxest)
		scalar r(scale)
		string r(adjust)
*/
	version 6
	args x lnx lin expx origin zero scaling v touse adjust
	/*
		x   = xvar initially
		lnx = missing initially
		lin = 1 for m=1, powers=1

		v   = original xvar 
	*/

	if "`origin'"!="" {
		confirm num `origin'
		if `origin'<=0 | `origin'>=1 {
			noi di in red "origin must be between 0 and 1"
			exit 198
		}
	}
	return scalar shifted = 0
	return scalar scale = 1
	if "`adjust'"!="" { return local adjust `adjust' }
	quietly {
		count if `touse'
		return scalar N = r(N)
		if "`zero'"!="" {
			local ifvpos "if `v'>0 & `v'!=."
			replace `x'=0 if `touse' & `v'<=0
			sum `v' if `touse' & !(`v'<=0)
		}
		else	sum `v' if `touse'
		if "`adjust'"=="mean" { return local adjust = r(mean) }
		tempname xmin xmax
		scalar `xmin' = r(min)
		scalar `xmax' = r(max)

		if "`expx'"!="" {
			if "`origin'"!="" {
/*
	If origin is set, determine k from xmin and xmax
*/
				tempname k
				scalar `k'=-log(`origin')/(`xmax'-`xmin')
				if "`expx'"=="-" { local expx=-`k' }
				else if "`expx'"=="+" { local expx=`k' }
				else {
					di in red "invalid expx with origin"
					exit 198
				}
			}
			else if "`expx'"=="sd" {
				local expx=-1/sqrt(r(Var))
			}
			else {
				confirm num `expx'
			}
			replace `x'=exp(`expx'*`x') `ifvpos'
			return local expxest `expx'
		}
		else if "`origin'"!="" {
/*
	Transform X to set scaled origin to `origin'.
*/
			tempname zeta
			scalar `zeta'=(`xmin'-`origin'*`xmax')/(1-`origin')
			replace `x'=(`x'-`zeta')/(`xmax'-`zeta') `ifvpos'
			return scalar zeta = `zeta'
		}
		if "`expx'"=="" & "`origin'"=="" & `xmin'<=0 & !`lin' {
/*
	Shift x by rounding interval (min spacing) minus min of x.
	Note: this CANNOT HAPPEN if `zero' (`ifvpos') option is used,
	as `xmin', the minimum of the positive values of x, is positive.
*/
			tempvar diff ord
			gen `ord' = _n /* save original order */
			sort `touse' `x'
			gen `diff' = `x'-`x'[_n-1] if `touse'
			sum `diff' if `diff'>0
			tempname shift
			scalar `shift' = r(min) - `xmin'
			replace `x' = `x'+`shift'
			return scalar zeta = `shift'
			return scalar shifted = 1 
			sort `ord'	/* restore order */
		}
		if !`lin' & "`scaling'"!="noscaling" {
			sum `x' if `touse'
			tempname s
			scalar `s'=r(max)-r(min)
			return scalar scale = /*
				*/ 10^(sign(log10(`s'))*int(abs(log10(`s'))))
			replace `x'=`x'/return(scale) `ifvpos'
		}
		if !`lin' {
                        replace `lnx' = cond(`x'==0,0,log(`x'))
		}
	}
end
