*! version 2.0.1  09feb2015
program define _crcbygr
	version 3.0
	mac def _if "opt"
	mac def _varlist "req ex"
	parse "%_*"
	parse "%_varlist", parse(" ")
	tempvar INBYGRP
	quietly {
		local obstype = c(obs_t)
		gen %_obstype %_INBYGRP = _n %_if
		replace %_INBYGRP = . if %_INBYGRP[_n+1]!=.
		replace %_INBYGRP = sum(%_INBYGRP)
		mac def _bygrp = %_INBYGRP[_N]
		mac def _bys "-> "
		while ("%_1"!="") {
			emdef S__val : form %_1 %_bygrp
			mac def _bys "%_bys %_1=%S__val   "
			mac shift
		}
		mac def S__val
	}
	di _n in gr "%_bys"
end
