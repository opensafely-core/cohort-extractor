*! version 2.0.3  03nov1994
program define teststd
	version 3.0
	di in blu "(please use sdtest in the future)"
	mac def _varlist "req ex max(1)"
	mac def _exp "req noprefix"
	mac def _in "opt"
	mac def _if "opt"
	parse "%_*"
	capture conf numb %_exp
	if _rc==0 {
		_tscon %_varlist %_exp "%_if" "%_in"
		exit
	}
	conf var %_exp
	_tsvar %_varlist %_exp "%_if" "%_in"
end

program define _tscon
	version 3.0
	sum %_1 %_3 %_4
	mac def _c2=(_result(1)-1)*(_result(4)/((%_2)^2))
	mac def _p = max(chiprob(_result(1)-1,(%_c2)+(1e-20)),.0001)
	di _n in gr "Test: standard deviation of %_1 = %_2`:" _n
	#delimit ;
	di in gr "chi-squared = " in ye %5.2f %_c2 in gr " with "
	   in ye _result(1)-1 in gr " d.f." ;
	di in gr "probability = " in ye %6.4f min(%_p,1-(%_p))
	   in gr " (one-sided test)" ;
	#delimit cr
end

program define _tsvar
	version 3.0
	sum %_1 %_2 %_3 %_4
	quietly summ %_1 %_3 %_4
	mac def _N1 = _result(1)
	mac def _M1 = _result(3)
	mac def _V1 = _result(4)
	quietly summ %_2 %_3 %_4
	mac def _N2 = _result(1)
	mac def _M2 = _result(3)
	mac def _V2 = _result(4)

	if %_V1<%_V2 {
		mac def _f=%_V2/%_V1
		mac def _h=%_N1
		mac def _N1=%_N2
		mac def _N2=%_h
	}
	else	mac def _f = %_V1/%_V2
	di in gr _n "Test: variances of %_1 and %_2 are equal" _n
	#delimit ;
	di in gr "F-statistic = " in ye %6.3f %_f in gr " with ("
	   in ye %_N1-1 in gr "," in ye %_N2-1 in gr ") d.f.";
	di in gr "   Prob > F = "
	   in ye %6.4f max(fprob(%_N1-1,%_N2-1,%_f),.0001) ;
	#delimit cr
end
