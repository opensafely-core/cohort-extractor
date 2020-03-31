*! version 1.0.2  23oct2013
program define _estat_aroots_w2, rclass
	version 13

	syntax [, noGRAph *]

	local aste
	if ("`graph'" != "nograph") {
		local graphi graph
		local aste *	 
	}
	else {
		local graphi
	}
	
	syntax [, noGRAph vec arima 	/*
		*/ ARmat(string) 	/* Undocumented
		*/ MAmat(string) 	/* Undocumented
		*/ ESTimates(passthru) 	/* Undocumented
		*/ `aste' ]

	local graph `graphi'
	if ("`armat'" == "") {
		tempname armat
	}
	if ("`mamat'" == "") {
		tempname mamat
	}

	local 0  `", `options' "'

	_vec_pgridplots , `graph' `options'
	local options    `"`s(options)'"'
	local pgridplots `"`s(pgridplots)'"'
	
	local 0  `", `options' "'
	
	syntax , [ 			///
		Dlabel			///
		MODlabel		///
		*			///
		]
	
	_vec_ckgraph, `dlabel' `modlabel' `graph' `options'
	
	local options `"`s(options)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	
	if `e(ar_max)' local ar ar
	if `e(ma_max)' local ma ma
	
	if "`ar'`ma'"=="" {
		di in red "the model does not contain AR or MA terms"
		exit 198
	}
	
	return clear
	
	foreach i in `ar' `ma' {
		
		tempname re`i' im`i' mod`i'
		
		if "``i'mat'"!="" local amat amat(``i'mat')
		else local amat
		
		capture noi varstable_w , `amat' `estimates' arima(`i')
		
		if _rc == 0 {	
			mat `re`i''  = r(Re)
			mat `im`i''  = r(Im)
			mat `mod`i'' = r(Modulus)
			
			ret mat Re_`i' `re`i'', copy
			ret mat Im_`i' `im`i'', copy 
			ret mat Modulus_`i' `mod`i'', copy
			ret mat `i' ``i'mat', copy
		}
		else {
			exit _rc
		}
	}
	
	if "`graph'" != "" {
		_arma_grcroots, addplot(`addplot') plot(`plot')		///
			rlopts(`rlopts') `dlabel' `modlabel' 		///
			arre(`rear') arim(`imar') armod(`modar') 	///
			mare(`rema') maim(`imma') mamod(`modma') 	///
			pgridplots(`pgridplots') `options' umod(`unitmod')
	}
	
	return hidden local key_ma `s(key_ma)'
	return hidden local key_ar `s(key_ar)'

end
