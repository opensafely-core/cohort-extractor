*! version 2.0.1  09feb2015
program define genrank
	version 3.0
	mac def _varlist "req new max(1)"
	mac def _exp "req nopre"
	mac def _if "opt"
	mac def _in "opt"
	parse "%_*"
	tempvar GRV GRr
	capture {
		gen %_GRV = %_exp %_if %_in
		sort %_GRV
		local obstype = c(obs_t)
		gen %_obstype %_GRr = _n if %_GRV~=.
		replace %_GRr = %_GRr[_n-1] if %_GRV~=. & %_GRV==%_GRV[_n-1]
		by %_GRV: replace %_varlist = %_GRr+(_N-1)/2
		label var %_varlist "Rank of %_exp"
		exit
	}
	mac def _rc=_rc
	capture drop %_varlist
	error %_rc
end
