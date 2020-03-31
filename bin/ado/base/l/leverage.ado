*! version 2.0.3  01feb2012
program define leverage
	version 3.0
	mac def _varlist "req ex"
	mac def _options "*"
	mac def _in "opt"
	mac def _if "opt"
	parse "%_*"
	parse "%_varlist", parse(" ")
	mac def _lhs %_1
	mac def _rhs %_2
	mac shift
	mac shift
	tempvar RESID1 RESID2 PREDL
	quietly {
		reg %_lhs %_* %_if %_in
		predict %_RESID1 %_if %_in, resid
		reg %_rhs %_* %_if %_in
		predict %_RESID2 %_if %_in, resid
		reg %_RESID1 %_RESID2
		predict %_PREDL %_if %_in
		_crcslbl %_RESID1 %_lhs
		_crcslbl %_RESID2 %_rhs
		lab var %_PREDL " "
	}
	#delimit ;
	gr7 %_RESID1 %_PREDL %_RESID2, s(oi) c(.l) sort
		%_options
		title("     Partial Regression Leverage Plot");
	#delimit cr
end
