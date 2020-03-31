*! version 2.0.0  13dec1994 StataCorp use only
program define disp_s
	version 4.0
	local i = 0 
	while `i'<=30 { 
		if "${S_`i'}"!="" { mac list S_`i' }
		local i = `i' + 1
	}
end
