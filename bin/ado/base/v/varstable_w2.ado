*! version 2.0.1  01mar2005
program define varstable_w2, rclass
	version 8.2

	syntax [, GRAph vec * ]
	local 0  `", `options' "'

	_vec_pgridplots , `graph' `options' 

	local options    `"`s(options)'"'
	local pgridplots `"`s(pgridplots)'"'

	local 0  `", `options' "'


	syntax , [ 			///
		Amat(passthru) 		///
		ESTimates(passthru) 	///
		Dlabel			///
		MODlabel		///
		*			///
		]


	_vec_ckgraph, `dlabel' `modlabel' `graph' `options'

	local options `"`s(options)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	

	capture noi varstable_w , `amat' `estimates' `vec' 
	if _rc == 0 {
		tempname re im mod
		mat `re'  = r(Re)
		mat `im'  = r(Im)
		mat `mod' = r(Modulus)

		if "`vec'" != "" {
			tempname unitmod
			scalar `unitmod' = r(unitmod)
		}

		return clear

		ret mat Re `re', copy 	
		ret mat Im `im', copy 
		ret mat Modulus `mod', copy 

		if "`vec'" != "" {
			ret scalar unitmod = `unitmod'
		}
	}
	else {
		exit _rc
	}

	if "`graph'" != "" {

		_vec_grcroots, addplot(`addplot') plot(`plot')		///
			rlopts(`rlopts') `vec'				///
			`dlabel' `modlabel' re(`re') im(`im') 		///
			mod(`mod') pgridplots(`pgridplots') `options'	///
			umod(`unitmod')

	}
	

end	


