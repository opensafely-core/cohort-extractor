*! version 1.0.1  18nov1997
program define _fracxo, rclass 
* touched by kth
/* transform x if necessary. Deal with zeroes.  */
	version 4.0
	local x `1'
	local lnx `2'
	local lin `3' /* 1 for m=1, powers=1 */
	local expx "`4'"
	local origin "`5'"
	local zero "`6'"
	local scaling "`7'"
	if "`zero'"!="" & !`lin' {
		replace `x'=0 if `x'<=0
		local ifxpos "if `x'>0"
	}
	if "`origin'"!="" {
		confirm num `origin'
		if `origin'<=0 | `origin'>=1 {
			noi di in red "origin must be between 0 and 1"
			exit 198
		}
	}
	ret scalar shiftflg = 0
	ret scalar scale = 1
	quietly {
		count if `x'!=.
		ret scalar N = r(N)
		sum `x' `ifxpos'
		local xmin = r(min)
		local xmax = r(max)
		if "`expx'"!="" {
			if "`origin'"!="" {
/*
	If origin is set, determine k from xmin and xmax
*/
				local k=-log(`origin')/(`xmax'-`xmin')
				if "`expx'"=="-" { local expx=-`k' }
				else if "`expx'"=="+" { local expx `k' }
				else {
					di in red "invalid expx with origin"
					exit 198
				}
			}
			else if "`expx'"=="sd" {
				local expx=-1/sqrt(r(Var))
			}
			else {
				conf num `expx'
			}
			replace `x'=exp(`expx'*`x') `ifxpos'
			ret scalar expx = `expx'
		}
		else if "`origin'"!="" {
/*
	Transform X to set scaled origin to `origin'.
*/
			loc zeta=(`xmin'-`origin'*`xmax')/(1-`origin')
			replace `x'=(`x'-`zeta')/(`xmax'-`zeta') `ifxpos'
			ret scalar shift = `zeta'
		}
		if "`expx'"=="" & "`origin'"=="" & `xmin'<=0 & !`lin' {
/*
	Shift x by rounding interval (min spacing) minus min of x.
	Note: this CANNOT HAPPEN if `zero' (`ifxpos') option is used,
	as any x <= 0 are mapped to 0 and remain 0 during FP operations;
	`xmin' is the min of the positive values of x.
*/
			tempvar diff ord
			gen `ord' = _n /* save original order */
			sort `x'
			gen `diff' = `x'-`x'[_n-1]
			sum `diff' if `diff'>0
			local shift = r(min)-`xmin'
			replace `x' = `x'+`shift'
			ret scalar shift = `shift'
			ret scalar shiftflg = 1
			sort `ord'
		}
		if !`lin' & "`scaling'"!="noscaling" {
			sum `x'
			tempname s
			scalar `s'=r(max)-r(min)
			ret scalar scale=10^(sign(log10(`s'))*int(abs(log10(`s'))))
			replace `x'=`x'/return(scale)
		}
		if !`lin' {
			replace `lnx' = cond(`x'==0,0,log(`x'))
		}
	}
end
