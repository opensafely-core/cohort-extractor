*! version 1.0.0  20may2004
program define fcast_compute, sort
	version 8.2

	syntax name(name=prefix id="prefix") , [		///
		ESTimates(string)				///
		*						///
		]


	if "`estimates'" != "" {
		tempname pest 
		tempvar esmp

		qui _estimates hold `pest', copy restore nullok varname(`esmp')

		capture est restore `estimates'
		if _rc > 0 {
			di as err "cannot restore estimates(`estimates')"
			exit 498
		}	
	}

	_cknotsvaroi fcast compute

	local cmd  "`e(cmd)'"

	if "`cmd'" == "vec" {
		_vecfcast_compute `prefix' , `options' 		///
			esamp1(`esmp') est(`estimates')
	}
	else if "`cmd'" == "var" | "`cmd'" == "svar" {
		_varfcast_fcast `prefix', `options'			///
			esamp(`esmp') est(`estimates')

	}
	else {
		if "`cmd'" == "" {
			di as err "estimates not found"
			exit 301
		}
		di as err "{cmd:fcast compute} does not work with `cmd'"
		exit 198
	}


end	

