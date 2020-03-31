*! version 1.3.4  15jun2007
program define spikeplot, sort
	version 6.0, missing
	if _caller() < 8 {
		spikeplot_7 `0'
		exit
	}

	syntax varname [if] [in] [fw aw iw] [,	///
		Round(real 0)			///
		FRACtion			///
		ROOT				///
		*				///
	]
	
	local frac
	if "`fraction'" != "" {
		local frac "frac"
	}
	_gs_by_combine by options : `"`options'"'
	_get_gropts , graphopts(`options' `by') grbyable getallowed(plot addplot)
	local by `s(varlist)'
	local byopts `"`s(byopts)'"'
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	if "`root'" == "root" & "`frac'" == "frac" {
		di in red "must choose only one of root and frac options"
		exit 198
	}

quietly {

	tempvar data wt freq nby

	marksample touse

	gen double `data' = round(`varlist',`round') if `touse'
	local dfmt : format `varlist'
	format `data' `dfmt'

	sort `touse' `data' `by'

	local exp = cond("`exp'"=="","= 1","`exp'")
	gen double `wt' `exp'
	by `touse' `data' `by' : gen double `freq'=sum(`wt')
	by `touse' `data' `by' : replace `freq' = `freq'[_N] if `touse'

	if "`frac'" != "" {
		sort `touse' `by'
		by `touse' `by' : gen double `nby'=sum(`wt')
		by `touse' `by' : replace `nby' = `nby'[_N] if `touse'
		
		replace `freq' = `freq' / `nby'
	}
	else if "`root'" != "" { 
		replace `freq' = sqrt(`freq') 
	}
	
	sort `by' `data' `touse'
	by `by' `data' : replace `touse' = (_n==1) if `touse'

} // quietly

	if "`frac'" != "" {
		local yttl "Fraction"
	}
	else if "`root'" != "" {
		local yttl "Root of frequency"
	}
	else	local yttl "Frequency"
	label var `freq' `"`yttl'"'

	local xttl : variable label `varlist'
	if "`xttl'" == "" {
		local xttl "`varlist'"
	}
	label var `data' `"`xttl'"'

	if "`by'" != "" {
		local byopt `"by(`by', `byopts')"'
	}

	version 8: graph twoway			///
	(spike `freq' `data'			///
		if `touse',			///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`byopt'				///
		`options'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end

