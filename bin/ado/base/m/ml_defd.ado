*! version 6.0.0  13dec1997
program define ml_defd
	version 6
	if "$ML_stat" != "model" { 
		di in red "you must issue -ml model- first"
		exit 198
	}
	capture confirm var $ML_samp $ML_wgt
	if _rc { 
		#delimit ;
		di in red 
"Since issuing the -ml model- statement, you have done something to drop" _n
"temporary variables ml added to your data.  You must start again." ;
		#delimit cr
		ml_clear
		exit 111
	}
end
exit
