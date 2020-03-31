*! version 3.0.1  27oct1998
program define ml_log 
	version 6
	global ML_ic = $ML_ic + 1
	local i = mod($ML_ic-1,20) + 1
	if scalar($ML_f) == . {
		mat ML_log[1,`i'] = 0
	}
	else	mat ML_log[1,`i'] = scalar($ML_f)
end
