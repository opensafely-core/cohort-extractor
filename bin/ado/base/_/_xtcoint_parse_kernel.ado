*! version 1.0.0  15mar2017

program _xtcoint_parse_kernel, sclass

	args input
	
	tokenize `input'
	local kernel `1' 
	local bw `2'
	macro shift 2
	if `"`1'"' != "" {
		di in smcl as error `"{bf:kernel(`input')} invalid"'
		exit 198
	}

	local kernlen : length local kernel
	if `"`kernel'"' == bsubstr("nwest", 1, max(2,`kernlen')) |	///
		`"`kernel'"' == bsubstr("bartlett", 1, max(2,`kernlen')) {
		local hac_kernel "bartlett"
	}
	else if `"`kernel'"' == bsubstr("gallant", 1, max(2,`kernlen')) | ///
		`"`kernel'"' == bsubstr("parzen", 1, max(2,`kernlen')) {
		local hac_kernel "parzen"
	}
	else if `"`kernel'"' == 					///
		bsubstr("quadraticspectral", 1, max(2, `kernlen')) |	///
		`"`kernel'"' == bsubstr("andrews", 1, max(2,`kernlen')) {
		local hac_kernel "quadraticspectral"
	}
	else {
		di in smcl as error "{bf:kernel()} kernel invalid"
		exit 198
	}
	capture confirm number `bw'
	if _rc==0 {
		if `bw' < 0  | (`bw' != int(`bw')) {
			di as err "{p}number of lags in {bf:kernel()} must be "
			di as err "a nonnegative integer{p_end}"
			exit 198
		}
		sreturn local hac_kernel "`hac_kernel'"
		sreturn local hac_lags = `bw'
		sreturn local hac_bsel ""
		exit
	}
	
	// See which BW selection algorithm user specified
	local bwlen : length local bw
	if `"`bw'"' == bsubstr("nwest", 1, max(2, `bwlen')) {
		local bsel "nwest"
	}
	else if `"`bw'"' == "" {
		local bsel ""
	}
	else {
		di in smcl as error 	///
			"{bf:kernel()} lag-selection algorithm invalid"
		exit 198
	}
	sreturn local hac_kernel "`hac_kernel'"
	sreturn local hac_lags = .
	sreturn local hac_bsel "`bsel'"
	
end
