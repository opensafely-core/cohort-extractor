*! version 2.0.1  07/23/91
program define disp_res
	version 3.0
	if "`*'"!="" { error 198 }
	local i 0
	while `i' <= 20 { 
		if _result(`i') !=. {
			di in gr %4.0f `i' ".  " in ye _result(`i')
		}
		local i=`i'+1
	}
end
