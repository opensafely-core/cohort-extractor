*! version 1.0.1  10oct2005
program _gs_x_create
	version 9

	syntax , X(string) TOUSE(string) [ POINTS(integer 2)		///
		MIN(string) MAX(string) HOLDX(string) ]

	if `"`min'"' != `""' | `"`max'"' != `""' {
		summarize `x' if `touse' , meanonly
		if `"`min'"' != `""' {
			if `min' >= .  {
				local min = r(min)
			}
		}
		if `"`max'"' != `""' {
			if `max' >= . {
				local max = r(max)
			}
		}
	}

	if c(N) < `points' {
		qui set obs `points'
	}

	local label  : variable label `x'
	local vallab : value label `x'

	capture rename `x' `holdx'
	qui gen `x' = `min' + (_n-1)*(`max'-`min') / (`points'-1) in 1/`points'
	label variable `x' `"`label'"'
	label values   `x' `vallab'

end
