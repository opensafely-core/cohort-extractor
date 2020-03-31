*! version 3.0.2  08/09/94 (minor change 15aug2006)
program define wdatetof
	version 3.0
	mac def _varlist "req ex max(1)"
	mac def _if "opt"
	mac def _in "opt"
	mac def _options "Generate(string)"
	parse "%_*"
	if "%_generat"=="" { error 198 }
	conf new var %_generat
	conf str var %_varlist
	mac def _type : type %_varlist
	tempvar touse mo da yr idx sda syr
	quietly { 
		gen byte %_touse = 0
		replace %_touse = 1 %_if %_in
		gen byte %_mo=.
		gen byte %_idx=.
		_crcwda2 %_varlist jan 1 %_idx %_mo	/* srchmo */
		_crcwda2 %_varlist feb 2 %_idx %_mo
		_crcwda2 %_varlist mar 3 %_idx %_mo
		_crcwda2 %_varlist apr 4 %_idx %_mo
		_crcwda2 %_varlist may 5 %_idx %_mo
		_crcwda2 %_varlist jun 6 %_idx %_mo
		_crcwda2 %_varlist jul 7 %_idx %_mo
		_crcwda2 %_varlist aug 8 %_idx %_mo
		_crcwda2 %_varlist sep 9 %_idx %_mo
		_crcwda2 %_varlist oct 10 %_idx %_mo
		_crcwda2 %_varlist nov 11 %_idx %_mo
		_crcwda2 %_varlist dec 12 %_idx %_mo
		replace %_touse=0 if %_mo==. & %_touse
		gen %_type %_sda = substr(%_varlist,1,%_idx-1) if %_touse
		trim right %_sda if %_touse
		gen int %_da=real(%_sda)
		drop %_sda
		replace %_touse=0 if %_da==. & %_touse
		gen %_type %_syr = substr(%_varlist,%_idx+3,.)
		trim right %_syr
		_crcwda1 %_syr	/* eatchar */
		gen int %_yr=real(%_syr)
		drop %_syr %_idx
		replace %_touse=0 if %_yr==. & %_touse
	}
	#delimit ;
	gen long %_generat=
		cond(%_yr>1900,%_yr-1900,%_yr)*10000+%_mo*100+%_da if %_touse;
	#delimit cr
end


program define _crcwda1
	version 3.0
	quietly { 
		capture assert real(substr(%_1,1,1))!=. if length(%_1)>0
		while _rc { 
			replace %_1=substr(%_1,2,.) if real(substr(%_1,1,1))==.
			capture assert real(substr(%_1,1,1))!=. if length(%_1)>0
		}
	}
end

program define _crcwda2
	version 3.0
	tempvar srchmo
	quietly {
		gen byte %_srchmo = index(lower(%_1),"%_2")
		replace %_4=%_srchmo if %_srchmo
		replace %_5=%_3 if %_srchmo
	}
end
exit
/*
	_crcwda1
	_eatchar:  Usage:  _eatchar <string_var_name>

		removes from front of string all nonnumeric characters.
		e.g., "  jan  90jkl" becomes "90jkl"
*/

/*
	_crcwda2
	_srchmo:  Usage:  _srchmo <string_var> <string_lit> <#> <idx> <mo>
		  looks for <string_lit> in <string_var> and, if found, 
		  stores in corresponding obs of <idx> location of 
		  of the literal and in <mo> the number.  

		_srchmo strvar mar 3 _idx _mo
		
		  looks for "mar" in strvar and, where found, stores a 3 
		  in _mo
*/
