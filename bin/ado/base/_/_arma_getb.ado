*! version 1.0.1  15oct2013
program _arma_getb, rclass
	version 13

	local cmd `e(cmd)'
	if "`cmd'"=="arch" local cmd arima
	
	tempname b V bAR bMA
	
	if "`e(mar1)'`e(mma1)'"!= "" { // multiplicative ARIMA	
		local eq `e(eqnames)'
		mat `b' = e(b)
		mat coleq `b' = `eq'	
		mat `V' = e(V)
		mat roweq `V' = `eq'
		mat coleq `V' = `eq'
			
		foreach s in `e(seasons)' {
			local eq : subinstr local eq "AR`s'_terms" "_IRF_", all
			local eq : subinstr local eq "MA`s'_terms" "_IRF_", all
		}
		
		mat coleq `b' = `eq'
		mat `b' = `b'[1,"_IRF_:"]
		
		mat roweq `V' = `eq'
		mat coleq `V' = `eq'
		mat `V' = `V'["_IRF_:","_IRF_:"]
		
		return local mult _mult
	}
	else { // ARFIMA or additive ARIMA
		mat `b' = e(b)
		mat `V' = e(V)	
		if "`cmd'"=="arima" local eq ARMA:
		if "`cmd'"=="arfima" local eq ARFIMA:
		capture mat `b' = `b'[1,"`eq'"]
		capture mat `V' = `V'["`eq'","`eq'"]
	}
	
	return matrix b = `b'
	return matrix V = `V'

end
exit
