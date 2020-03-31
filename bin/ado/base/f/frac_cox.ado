*! version 2.0.0  17nov1998
program define frac_cox
	version 6
	args dead dist 
	if "`dead'"!="" {
		if `dist'!=3 & `dist'!=6 {	/* ereg/weibull/cox */
			di in red "option dead() not allowed"
			exit 198
		}
	}
	else {
		if `dist'==3 {
			di in red "option dead() required with cox"
			exit 198
		}
	}
end
