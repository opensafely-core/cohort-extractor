*! version 6.0.4  27feb2006
program define ml_clear
	version 6
	if `"`0'"'!="" {
		error 198
	}
	capture drop $ML_w
	capture drop $ML_samp
	capture drop $ML_subv
	capture sca drop $ML_f
	capture mat drop $ML_b
	capture mat drop $ML_g
	capture mat drop $ML_V
	capture mat drop $ML_dfp_b
	capture mat drop $ML_dfp_g
	capture mat drop ML_log
	capture mat drop ML_d0_S
	capture mat drop ML_Ca
	capture mat drop ML_CT
	capture mat drop ML_CC
	mac drop ML_*
end
exit
