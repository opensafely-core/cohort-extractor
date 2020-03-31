*! version 3.0.2  15dec1994 StataCorp use only
program define zap_s
	version 4.0
	local i = 0 
	while `i'<=30 { 
		global S_`i'
		capture scalar drop S_`i'
		capture matrix drop S_`i'
		local i = `i' + 1
	}
end
