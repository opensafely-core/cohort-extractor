*! version 1.0.1  16apr2013

program define _xtur_getic, rclass
	
	syntax anything

	local ic `anything'

	tempname v

	if "`ic'" == "aic" {
		sca `v' = (-2*e(ll) + 2*(e(df_m)+1))/e(N)
	}
	else if "`ic'" == "bic" {
		sca `v' = (-2*e(ll) + ln(e(N))*(e(df_m)+1))/e(N)
	}
	else if "`ic'" == "hqic" {
		sca `v' = (-2*e(ll) + 2*ln(ln(e(N)))*(e(df_m)+1))/e(N)
	}
	else {
		noi di in smcl as err 			///
			"{bf:`ic'} is not a valid information criterion"
		exit 498
	}

	return scalar ic = `v'

end

