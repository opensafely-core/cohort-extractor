*! version 1.0.0  06mar2015
program define _parse_ignore, sclass
	version 14
	sreturn clear
	if _caller() < 14 {
		capture syntax [anything] , [ASChars] [ASBytes] [illegal]
		if !_rc {
			if "`aschars'`asbytes'`illegal'"!="" {
				display as error "may not specify options in the ignore option for Stata version less than 14"
				exit 198
			}
		}
		sreturn local aschars 0
		sreturn local illegal 0
	}
	else {
		syntax [anything] , [ASChars] [ASBytes] [illegal]
		if "`asbytes'"!="" {
			if "`aschars'"!="" {
				display as error "may specify only one of the ignore options aschars and asbytes"
				exit 198
			}
			if "`illegal'"!="" {
				display as error "may not specify the ignore option illegal when specifying asbytes"
				exit 198
			}
		}
		if "`asbytes'"=="" {
			if ustrinvalidcnt(`"`anything'"') {
				display as error "invalid Unicode characters may not be ignored when removing aschars"
				exit 198
			}
		}

		sreturn local aschars = "`asbytes'"==""
		sreturn local illegal = "`illegal'"!=""
		capture sreturn local ignore `anything'
		if _rc {
			sreturn local ignore `"`anything'"'
		}
	}
end
