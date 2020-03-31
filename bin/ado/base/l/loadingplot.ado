*! version 1.1.2  08oct2019
program loadingplot
	version 9.0

	if "`e(cmd)'" == "" {
		error 301
	}
	else if !inlist("`e(cmd)'`e(subcmd)'", ///
				"pca","factor","discrimlda","candisc") {
		dis as err "{p}loadingplot is allowed only after "
		dis as err "factor, pca, candisc, and discrim lda{p_end}"
		exit 301
	}

	syntax, [			///
		FACtors(str)		///
		COMponents(str)		///
		noROTated		///
		MAXlength(int 12)	///
		COMBINEd		///
		MATRIX			///
		*			///
	]

	if "`e(cmd)'" == "factor" {
		local fname Factor
	}
	else if "`e(cmd)'" == "pca" {
		local fname Component
	}
	else {
		local fname Standardized discriminant function
	}

	if `e(f)' == 1 {
		display as error "only one `=lower("`fname'")' retained"
		exit 321
	}
	else if `e(f)' == 0 {
		dis as err "no `=lower("`fname'")'s retained"
		exit 321
	}	

	if "`combined'" != "" & "`matrix'" != "" {
		display as error 	///
		    "options matrix and combined may not be specified together"
		    
		exit 198
	}

	if `"`factors'"' != "" & `"`components'"' != "" {
		display as error 	///
		    "options factors() and components() may not be combined"
		    
		exit 198
	}
	
	if `"`factors'"' == "" & `"`components'"' == "" {
		local f = 2
	}
	else {
		local f = `components' `factors'
		confirm integer number `f'
		if ! inrange(`f',2,e(f)) {
			display as error "option " 			///
				=cond("`components'" != "", 		///
			   	    "components()", "factors()") 	///
			   	" invalid; out of range"
			   	
			display as error 				///
				"expected "				///
				= cond(`e(f)' == 2, "value is 2" ,	///
					"between 2 and `e(f)'")
				
			exit 125
		}
	}

	if ((`f' > 2 | "`matrix'" != "") & "`combined'" == "") {
		local isMatrix = 1
	}
	else {
		local isMatrix = 0
		local getcombine getcombine
	}

// parse graph options
	_get_gropts , graphopts(`options') `getcombine'			///
		getallowed(MLABPosition scheme)

        if `"`s(scheme)'"' != "" {
                local scheme `"scheme(`s(scheme)')"'
        }		
	local options `"`s(graphopts)'"'
	local gcopts  `"`s(combineopts)'"'
	local mlabpos `"`s(mlabposition)'"'

	tempname L
	tempvar mark

	if "`rotated'" != "norotated" & "`e(r_criterion)'" != "" {
		// rotated is the default when available
		matrix `L' = e(r_L)
		if "`e(r_class)'`e(r_ctitle)'" != "" {
			local rotation `""Rotation: `e(r_class)' `e(r_ctitle)'""'
		}
		if "`e(mtitle)'" != "" {
			local method `""Method: `e(mtitle)'""'
		}
		local note note(`rotation' `method')
	}
	else if inlist("`e(cmd)'`e(subcmd)'","discrimlda","candisc") {
		matrix `L' = e(L_std)
	}
	else {
		matrix `L' = e(L)
	}

	local n = rowsof(`L')

	local preserve preserve
	if `n' > c(N) {
		preserve
		quietly set obs `n'
		local preserve
	}

	// set up default marker labels
	local rnames : rownames `L'
	quietly gen str32 `mark' = ""
	forvalues i = 1/`n' {
		quietly replace `mark' = `"`:word `i' of `rnames''"' in `i'
	}
	quietly replace `mark' = abbrev(`mark',`maxlength')

	if "`mlabpos'" != "" {
		local labelposition "mlabposition(`mlabpos')"
	}

	local title `"`fname' loadings"'

	if `isMatrix' {
		`preserve'
		tempname stub
		svmat `L' , name(`stub')
		forvalues i = 1/`f' {
			local vlist `vlist' `stub'`i'
			label var `stub'`i' "`fname' `i'"
		}
		graph matrix `vlist', title(`title') `note'	///
			mlabel(`mark')  `labelposition' `scheme' `options'
	}
	else {
		// make individual plots
		tempvar s1 s2 p
		forvalues i = 1/`f' {
			forvalues j = 1 / `=`i'-1' {
				capture drop `p'
				capture drop `s1' `s2'

				tempname f`i'_`j'
				local clist `clist' `f`i'_`j''

				quietly gen `s1' = `L'[_n,`i']  in 1/`n'
				quietly gen `s2' = `L'[_n,`j']  in 1/`n'
				if "`mlabpos'" == "" {
					_plotpos `s2' `s1' in 1/`n' , gen(`p')
					local labelposition "mlabvpos(`p')"
				}

				scatter `s1' `s2' in 1/`n',	///
					ytitle(`fname' `i')	///
					xtitle(`fname' `j')	///
					mlabel(`mark') 		///
					`labelposition'		///
					nodraw name(`f`i'_`j'') ///
					`scheme' `options'
			}
		}

		// show combined plot
		graph combine `clist' , title(`title') `note' `scheme' `gcopts'
		graph drop `clist'
	}
end
