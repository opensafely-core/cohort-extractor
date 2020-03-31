*! version 1.2.0  10mar2015
program gsem_markout
	version 13
	syntax anything [,	idvars(varlist)		///
				depvar(string)		///
				LDepvar(string)		///
				UDepvar(string)		///
				LCensored(string)	///
				RCensored(string)	///
				LTruncated(string)	///
				RTruncated(string)	///
				FAILure(string)		///
	]

	gettoken touse anything : anything
	gettoken ytouse anything : anything
	if !`:list touse == ytouse' {
		capture confirm new variable `ytouse'
		if c(rc) == 0 {
			mark    `ytouse'
		}
		quietly replace `ytouse' = 0 if `touse' == 0
	}
	if "`ldepvar'" != "" {
		quietly replace `ytouse' = 0			///
			if missing(`ldepvar')			///
			 & missing(`depvar')
		CheckOrder `ytouse' `ldepvar' `depvar'
	}
	else if "`udepvar'" != "" {
		quietly replace `ytouse' = 0			///
			if missing(`depvar')			///
			 & missing(`udepvar')
		CheckOrder `ytouse' `depvar' `udepvar'
	}
	else {
		local anything `anything' `depvar'
	}
	if "`failure'" != "" {
		local anything `anything' `failure'
	}
	if "`ltruncated'" != "" & "`rtruncated'" != "" {
		CheckOrder `ytouse' `ltruncated' `rtruncated'
	}
	if "`ltruncated'" != "" {
		if "`depvar'" != "" {
			MarkOrder `ytouse' `ltruncated' `depvar'
		}
		if "`ldepvar'" != "" {
			MarkOrder `ytouse' `ltruncated' `ldepvar'
		}
		if "`udepvar'" != "" {
			MarkOrder `ytouse' `ltruncated' `udepvar'
		}
		if "`lcensored'" != "" {
			MarkOrder `ytouse' `ltruncated' `lcensored'
		}
		if "`rcensored'" != "" {
			MarkOrder `ytouse' `ltruncated' `rcensored'
		}
	}
	if "`rtruncated'" != "" {
		if "`depvar'" != "" {
			MarkOrder `ytouse' `depvar' `rtruncated'
		}
		if "`ldepvar'" != "" {
			MarkOrder `ytouse' `ldepvar' `rtruncated'
		}
		if "`udepvar'" != "" {
			MarkOrder `ytouse' `udepvar' `rtruncated'
		}
		if "`lcensored'" != "" {
			MarkOrder `ytouse' `lcensored' `rtruncated'
		}
		if "`rcensored'" != "" {
			MarkOrder `ytouse' `rcensored' `rtruncated'
		}
	}
	markout `ytouse' `anything'
	if `:length local idvars' {
		markout `ytouse' `idvars', strok
	}
end

program CheckOrder
	args touse y1 y2

	capture assert `y1' <= `y2'	///
		if `touse'		///
		 & !missing(`y1')	///
		 & !missing(`y2')
	if c(rc) {
		di as err "observations with `y1' > `y2' not allowed"
		exit 498
	}
end

program MarkOrder
	args touse y1 y2

	quietly replace `touse' = 0		///
		if `y1' >= `y2'			///
		 & `touse'			///
		 & !missing(`y1')		///
		 & !missing(`y2')
end

exit
