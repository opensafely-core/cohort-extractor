*! version 2.0.1  07/23/91 merged on 08/09/94 13feb2013
program define emdef
	version 3.0
	capture parse "%_*", parse(" :")
	if ( _rc | ("%_2"!=":")) { error 198 }
	_cr1%_3 %_1 %_4 %_5
end


program define _cr1form
	version 2.1     /* might be important */
	* convert numbers / old-style labels to strings
	mac def _tp : type %_2
	mac def _val = %_2[%_3]
	mac def _dp = index("%_val",".")
	if ("%_tp"!="string" & length("%_val")>=7 & %_dp) {
		* attempt to round it
		mac def _ival = index("%_val","999") + index("%_val","000")
		if (%_ival>%_dp) {
			mac def _val = bsubstr("%_val",1,%_ival-1)
		}
	}
	mac def _vl : value label %_2
	if ("%_vl"!="") {
		tempvar CRCVAL
		qui decode %_2, gen(%_CRCVAL)
		mac def _val = %_CRCVAL[%_3]
	}
	mac def %_1 "%_val"
end

program define _cr1invt
	version 3.0
	if (%_2 >= 1 | %_2 <= 0 | %_3 <= 0 | %_3==.) {
                mac def %_1 = .
                exit 198
        }
	mac def _x = invnorm(%_2/2+0.5)
	mac def _x0 = . 
        while (abs(%_x-%_x0)>1e-5) {
		mac def _x0 = %_x
                mac def _p = tprob(%_3,%_x)
		mac def _pp = (tprob(%_3,%_x+.01) - %_p) / .01
                mac def _x = %_x + (1-%_2-%_p)/%_pp
        }
        mac def %_1 "%_x"
end

program define _cr1se
	version 3.0
	mac def _macname %_1
	cap test %_2
	if (_rc) {
		mac def %_macname = .
		exit
	}
	mac def %_macname = abs(_b[%_2]) / sqrt(_result(6))
end

program define _cr1t
	version 3.0
	mac def _macname %_1
	cap test %_2
	if (_rc) {
		mac def %_macname = .
		exit
	}
	mac def %_macname = sqrt(_result(6))*cond(_b[%_2]>0,1,-1)
end
