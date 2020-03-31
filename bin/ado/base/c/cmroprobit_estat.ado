*! version 1.0.0  06feb2019
program cmroprobit_estat
	version 16

	if ("`e(cmd)'" != "cmroprobit") { 
				
di as err "{helpb cmroprobit##|_new:cmroprobit} estimation results not found"
		
		exit 301
	}

	gettoken sub : 0, parse(" ,")

	local lsub = strlen("`sub'")
	
	if (   "`sub'" == substr("covariance",  1, max(3, `lsub'))     ///
	     | "`sub'" == substr("correlation", 1, max(3, `lsub'))     ///
	     | "`sub'" == substr("facweights",  1, max(4, `lsub')) ) {
		
		asprobit_estat `0'
	}
	else {
		estat_default `0'
	}
end

