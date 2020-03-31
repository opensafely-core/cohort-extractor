*! version 2.1.0  07jul2011
program define predict
	version 8.2, missing

	if "`e(cmd)'" == "rocreg" & "`e(predict)'" == "" {
		di as err "predict not allowed after nonparametric ROC"
		exit 198
	}
	if "`e(mi)'"!="" & "`e(b)'"!="matrix" {
		error 321
	}

	if _caller()<=5 | "`e(predict)'"=="" {
		_predict `0'
	}
	else {
		local v : display string(_caller())
		version `v', missing
		`e(predict)' `0'
	}	
end
exit
