*! version 2.0.0  07/19/91
program define trim
	version 3.0
	if "%_*"=="" { error 198 }
	tempvar t L
	if "%_1"=="left" { 
		mac def _bc "1"		/* column for blank char	*/
		mac def _cf "2"		/* column to copy from		*/
		mac def _l "."		/* length of copy		*/
	}
	else if "%_1"=="right" { 
		mac def _bc "%_L"
		mac def _cf "1"
		mac def _l "%_L-1"
	} 
	else { error 198 } 
	mac shift
	mac def _varlist "req ex max(1)"
	mac def _if "opt"
	mac def _in "opt"
	parse "%_*"
	confirm str var %_varlist
	quietly { 
		gen int %_t=1 %_if %_in
		replace %_t=0 if %_t==.
		gen int %_L=length(%_varlist) if %_t
		capture assert substr(%_varlist,%_bc,1)!=" " if %_t
		while _rc { 
			#delimit ; 
			replace %_varlist=substr(%_varlist,%_cf,%_l) 
				if substr(%_varlist,%_bc,1)==" " & %_t ;
			#delimit cr
			replace %_L = length(%_varlist) if %_t
			capture assert substr(%_varlist,%_bc,1)!=" " if %_t
		}
		compress %_varlist
	}
end
