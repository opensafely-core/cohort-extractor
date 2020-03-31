*! version 2.0.1  21nov1997
program define remap
* touched by jwh
	version 3.0
	if "%_4"=="" { error 198 }
	confirm variable %_1
	confirm new variable %_2
	mac def _old "%_1"
	mac def _new "%_2"
	mac shift
	mac shift
	quietly gen %_new = .
	di in gr _n _col(8) "%_old" _col(24) "%_new" _n _col(8) _dup(24) "-"
	while "%_1"!="" {
		di in ye _col(10) "%_1" _col(26) "%_2"
		if "%_2"=="" {
			quietly drop %_new
			#delimit ;
			di in red _n
			"no value specified for %_old == %_1, %_new not created"
			;
			#delimit cr
			exit 198
		}
		mac def _orig "float(%_old)==float(%_1)"
		if "%_1"=="*" {
			mac def _orig "%_old~=. & %_new==."
		}
		capture replace %_new = %_2 if %_orig
		if _rc {
			quietly drop %_new
			di in red _n "map %_1 to %_2?  %_new not created"
			exit 198
		}
		mac shift
		mac shift
	}
	label var %_new "Remapped %_old"
	quietly count if %_old!=. & %_new==.
	if r(N)!=0 {
		#delimit ;
		di _n _col(8) in gr "(" in ye r(N)
		   in gr " nonmissing obs not mapped)" ;
		#delimit cr
	}
end
