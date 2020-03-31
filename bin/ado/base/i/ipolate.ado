*! version 1.3.3  21sep2004
program define ipolate, byable(onecall) sort
	version 6, missing
	syntax varlist(min=2 max=2) [if] [in], Generate(string) /*
		*/ [ BY(varlist) Epolate ]
	if _by() {
		if "`by'"!="" {
			di in red /*
			*/ "option by() may not be combined with by prefix"
			exit 190
		}
		local by "`_byvars'"
	}


	confirm new var `generat'
	tokenize `varlist'
	local usery "`1'"
	local x "`2'"
	tempvar touse negx negy xhi yhi xlo ylo m b z y
	quietly {
		mark `touse' `if' `in'
		replace `touse' = 0 if `x'>=.
		sort `touse' `by' `x'
		quietly by `touse' `by' `x': /*
			*/ gen double `y'=sum(`usery')/sum(`usery'< .) if `touse'
		quietly by `touse' `by' `x': replace `y'=`y'[_N]
		gen double `negx'=-`x'
		gen double `negy'=-`y'
		sort `touse' `by' `negx' `negy'
		gen double `xhi'=`x' if `touse'
		gen double `yhi'=`y' if `touse'
		by `touse' `by': replace `yhi'=`yhi'[_n-1] if `y'>=. & `touse'
		by `touse' `by': replace `xhi'=`xhi'[_n-1] if `y'>=. & `touse'
		sort `touse' `by' `x' `y'
		gen double `xlo'=`x' if `touse'
		gen double `ylo'=`y' if `touse'
		by `touse' `by': replace `ylo'=`ylo'[_n-1] if `y'>=. & `touse'
		by `touse' `by': replace `xlo'=`xlo'[_n-1] if `y'>=. & `touse'
		gen double `m'=(`yhi'-`ylo')/(`xhi'-`xlo')
		drop `yhi' `xhi'
		gen double `b'=`ylo' - `m'*`xlo' 
		drop `ylo' `xlo' `negx' `negy'
		gen double `z'=`y' if `touse'
		replace `z'=`m'*`x'+`b' if `touse' & `z'>=.

		if `"`epolate'"' != "" {
			sort `touse' `by' `x' `z' /* already sorted */
			drop `m' `b'
			by `touse' `by': gen double /*
			*/ `m'=(`z'[_n+1]-`z')/(`x'[_n+1]-`x')
			gen double `b' = `z'-`m'*`x'
			tempvar M B ismiss
			gen double `M' = `m' 
			gen double `B' = `b'
			by `touse' `by': replace `m'=`m'[_n-1] if `m'[_n-1]< .
			by `touse' `by': replace `b'=`b'[_n-1] if `b'[_n-1]< .
			gen byte `ismiss' = `z'>=.
			by `touse' `by': replace `ismiss'=0 /*
				*/ if _n>1 & `ismiss'[_n-1]==0
			by `touse' `by': replace `z'=`m'[_N]*`x'+`b'[_N] /*
					*/ if `touse' & `ismiss'
			drop `ismiss' `m' `b'
			gen double `negx'=-`x'
			gen double `negy'=-`z'
			sort `touse' `by' `negx' `negy'
			by `touse' `by': replace `M'=`M'[_n-1] if `M'[_n-1]< .
			by `touse' `by': replace `B'=`B'[_n-1] if `B'[_n-1]< .
			gen byte `ismiss' = `z'>=.
			by `touse' `by': replace `ismiss'=0 /*
				*/ if _n>1 & `ismiss'[_n-1]==0
			by `touse' `by': replace `z'=`M'[_N]*`x'+`B'[_N] /*
					*/ if `touse' & `ismiss'
		}

		rename `z' `generat'
		count if `generat'>=.
	}
	if r(N)>0 {
		if r(N)!=1 { local pl "s" }
		di in blu "(" r(N) `" missing value`pl' generated)"'
	}
end
