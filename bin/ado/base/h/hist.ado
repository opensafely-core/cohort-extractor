*! version 2.0.2  06dec2004
program define hist
	// version statement missing on purpose
	if _caller() < 8 {
		hist_7 `0'
		exit
	}

	histogram `0'
end
