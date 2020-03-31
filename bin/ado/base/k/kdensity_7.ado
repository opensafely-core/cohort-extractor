*! version 2.4.5  15oct2019
program define kdensity_7, rclass sortpreserve
	version 8.0, missing

	syntax varname [if] [in] [fw aw] [,	///
		Generate(string)		///
		AT(varname)			///
		N(integer 50)			///
		Width(real 0.0)			///
		noGRaph				///
		noDENsity			///
		BIweight			/// _KDE opts
		COSine				///
		EPanechnikov			///
		GAUssian			///
		PARzen				///
		RECtangle			///
		TRIangle			///
		NORmal				/// gr7 opts
		STUd(int 0)			///
		Symbol(string)			///
		Connect(string)			///
		Title(string)			///
		*				///
	]

	// check syntax
	if "`at'"!="" & `n'!=50 {
		di in red "options {bf:at()} and {bf:n()} may not be specified together"
		exit 198
	}
	local kern	`biweight'	///
			`cosine'	///
			`epanechnikov'	///
			`gaussian'	///
			`parzen'	///
			`rectangle'	///
			`triangle'
	local k : word count `kern'
	if `k' > 1 {
		di in red `"only one kernel may be specified"'
		exit 198
	}
	if `k' == 0 {
		local kernel "epanechnikov"
	}
	local kernel = upper(bsubstr(`"`kern'"',1,1)) + bsubstr(`"`kern'"',2,.)

	local ix `"`varlist'"'
	local ixl: variable label `ix'
	if `"`ixl'"'=="" { 
		local ixl "`ix'"
	}

	marksample use
	qui count if `use'
	if r(N)==0 {
		error 2000
	} 

	tokenize `generate'
	local wc : word count `generate'
	if `wc' { 
		if `wc' == 1 {
			if `"`at'"' == `""' {
				error 198
			}
			confirm new var `1'
			local yl  `"`1'"'
			local xl `"`at'"'
			local nsave 1
		}
		else {
			if `wc' != 2 {
				error 198
			}
			confirm new var `1'
			confirm new var `2'
			local xl  `"`1'"'
			local yl  `"`2'"'
			local nsave 2		
		}
	}
	else {
		local xl   `"X"'
		local yl   `"Density"'	
		local nsave 0		
	}

	tempvar d m
	qui gen double `d'=.
	qui gen double `m'=.

	if `"`at'"' != `""' {
		qui count if `at' < . 
		local n = r(N)
		qui replace `m' = `at' 
		tempvar obssrt
		gen `obssrt' = _n
		sort `m' `obssrt'
	}
	else {
		if `n' <= 1 {
			local n = 50
		}
		if `n' > _N { 
			local n = _N
			noi di in gr `"(n() set to "' `n' `")"'
		}
	}

	quietly summ `ix' [`weight'`exp'] if `use', detail
	tempname ixmean ixvar ixsd
	scalar `ixmean' = r(mean)
	scalar `ixvar'  = r(Var)
	scalar `ixsd'   = r(sd)

	local wwidth = `width'
	if `wwidth' <= 0.0 { 
		local wwidth = min( r(sd) , (r(p75)-r(p25))/1.349)
		local wwidth = 0.9*`wwidth'/(r(N)^.20)
	}

	tempname delta
	scalar `delta' = (r(max)-r(min)+2*`wwidth')/(`n'-1)

	if `"`at'"' == `""' {
		qui replace `m' = r(min)-`wwidth'+(_n-1)*`delta' in 1/`n'
	}

	// KDE of `ix' at `m' using window width `wwidth' and `kern'
	_KDE `ix' [`weight'`exp'] if `use' , ///
		`kern' at(`m') kde(`d') width(`wwidth')

	label var `d' `"`yl'"'
	label var `m' `"`ixl'"'

	qui summ `d' in 1/`n', meanonly
	local scale = 1/(`n'*r(mean))

	if `"`density'"' != `""' {
		qui replace `d' = `d'*`scale' in 1/`n'
	}

	if `"`graph'"'==`""' {
		if `"`symbol'"'  == `""' {
			local symbol `"o"'
		}
		if `"`connect'"' == `""' {
			local connect `"l"'
		}
		if `"`title'"'   == `""' {
			local title `"Kernel Density Estimate"'
		}
		if `"`normal'"' != `""' {
			tempvar zden 
			qui gen `zden' = normden(`m',`ixmean',`ixsd')
			local symbol `"`symbol'i"'
			local connect `"`connect'l"'
			if `"`density'"' != `""' {
				tempvar fz
				qui gen `fz' = sum(`zden')
				qui replace `zden' = `zden'/`fz'[_N]
			}
		}
		if `stud' > 0 {
			tempvar tden
			qui gen `tden' = (`m'-`ixmean')/`ixsd'
			qui replace `tden' = tden(`stud',`tden')/`ixsd'
			local symbol `"`symbol'i"'
			local connect `"`connect'l"'
			tempvar ft
			qui gen `ft' = sum(`tden')
			if `"`density'"' != `""' {
				qui replace `tden' = `tden'/`ft'[_N]
			}
			else {
				qui replace `tden' = `tden'/(`ft'[_N]*`scale')
			}
		}
		gr7 `d' `zden' `tden' `m', ///
			s(`symbol') c(`connect') title(`"`title'"') `options'
	}
	// double save in S_# and r()
	ret clear
	ret local kernel `"`kernel'"'
	ret scalar width = `wwidth'
	ret scalar n = `n'           // (sic)
	ret scalar scale = `scale'
	global S_1   `"`kernel'"'
	global S_3 = `wwidth'
	global S_2 = `n'
	global S_4 = `scale'

	if 0`nsave' {
		label var `d' `"density: `ixl'"'
		rename `d' `yl'
		if `nsave' == 2 {
			rename `m' `xl'	// already labeled
		}
	}
end

exit
