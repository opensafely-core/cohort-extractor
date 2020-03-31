*! version 1.1.0  09feb2009

program biplot

	if _caller() < 11 {
		biplot_10 `0'
	      	exit
	}

	version 11.0
	syntax  varlist(numeric min=2)  [if] [in]	///
	[,						///
		MAHalanobis				///
		ALPha(numlist max=1 >=0 <=1)		///
	   	DIM(numlist integer min=2 max=2 >=1)	///
		*					///
	] 

	marksample touse
	quietly count if `touse' 
	local mrows = r(N)
	if `mrows' < 2 {
		dis as err "biplot requires at least 2 rows (observations)"
		exit 503
	}

// check and drop constant variables
	foreach var of local varlist {
		qui sum `var' if `touse'
		if (r(sd) != 0) {
			local varlistMata `varlistMata' `var'
		}
		else {
			local varlistConstant `varlistConstant' `var'
		}

	}
	
	if "`mahalanobis'" != "" {
		// send sqrt(n-1) through -multanddiv()- option
		local mahalopt "multanddiv(`= sqrt(`mrows'-1)')"

		// mahalanobis implies alpha of zero
		if "`alpha'" == "" {
			local alpha 0
		}
		else if `alpha' != 0 {
			di as error ///
			"nonzero alpha() may not be specified with mahalanobis"
			exit 198
		}
	}
	if "`alpha'" != "" {
		local alpha "alpha(`alpha')"
	}
	if ("`varlistConstant'" != "") {
		foreach a of local varlistConstant {
			di as txt "note: `a' dropped because of zero variance"
		}
	}
	local nvar : word count `varlistMata'
	if (`nvar' < 2) {
		dis as err "biplot requires at least 2 columns"
                exit 503
	}
	if "`dim'" != "" {
		local i1 : word 2 of `dim'
		local i2 : word 1 of `dim'
	}
	else {
		local i1 1
		local i2 2
	}
	if `i1' > `nvar' | `i2' > `nvar' {
		di as err "dim() invalid -- invalid numlist has elements outside of allowed range"
		exit(125)
	}

// display and plot
		_biplotmat `varlistMata',	///
		colopts(name("Variables")) 	///
		negcolopts(name("-Variables"))	///
		`mahalopt' `alpha'		///
		touse1(`touse')			///
		dim(`i2' `i1')			///
		`options'
end
exit
