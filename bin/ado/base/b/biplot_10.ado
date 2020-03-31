*! version 1.0.3  09feb2009

program biplot_10
	version 9.0

	syntax  varlist(numeric min=2)  [if] [in]	///
	[,						///
	   	STD 					///
		MAHalanobis				///
		ALPha(numlist max=1 >=0 <=1)		///
	   	DIM(numlist integer min=2 max=2 >=1)	///
		*					///
	] 

// produce properly labeled data matrix M

	tempname M M2 xmean xdiv

	marksample touse
	quietly count if `touse' 
	local mrows = r(N)
	if `mrows' < 2 {
		error 2001
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

	forvalues i = 1 / `c(N)' {
		if `touse'[`i'] {
			local rownames `rownames' `i' 
		}	
	}
	local rname Observations	


	local nvar : word count `varlist'
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

// center or standardize
	mkmat `varlist' if `touse' , matrix(`M')
	local colnames : colnames `M'
	local col 1
	foreach v of local varlist {
		qui summ `v' if `touse'
		scalar `xmean' = r(mean)
		if "`std'" != "" { // subtract mean and divide by std dev.
			scalar `xdiv' = r(sd)
		}
		else { // subtract mean (but don't divide by std dev.)
			scalar `xdiv' = 1
		}
		mat `M2' = nullmat(`M2'), ///
			( (`M'[1...,`col'] - J(`mrows',1,`xmean')) ///
			  / `xdiv' )
		local ++col
	}
	mat `M' = `M2'
	matrix rownames `M' = `rownames'
	matrix colnames `M' = `colnames'


// display and plot

	_biplotmat `M' , 			///
		rowopts(name("Observations"))	///
		colopts(name("Variables")) 	///
		negcolopts(name("-Variables"))	///
		`mahalopt' `alpha'		///
		touse(`touse')			///
		dim(`i2' `i1')			///
		`options'
end
exit
