*! version 1.1.4  29sep2004
program define spikeplot_7, sort
	version 6.0, missing

	syntax varname [if] [in] [fw aw iw] [, Round(real 0) FRAC ROOT /*
		*/ Zero(real 0) L2title(str) B2title(str) /*
		*/ Connect(str) TOTal Symbol(str) BY(str) *]

	if "`total'" != "" {
		di in red "total option not supported"
		exit 198
	}
	if "`root'" == "root" & "`frac'" == "frac" {
		di in red "must choose only one of root and frac options"
		exit 198
	}

	quietly {
		tempvar data wt freq nby level

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

		gen `level' = `zero'
	}

	if "`l2title'" == "" {
		if "`frac'" != "" { local l2title = "Fraction" }
		else if "`root'" != "" { local l2title = "Root of frequency" }
		else local l2title = "Frequency"
	}

	if "`b2title'" == "" {
		local b2title : variable label `varlist'
		if "`b2title'" == "" { local b2title "`varlist'" }
	}

	if "`connect'" == "" { local connect "||" }
	if "`symbol'" == "" { local symbol "ii" }

	if "`by'" != "" {
		sort `by'
		local options "by(`by') `options'"
	}

	gr7 `freq' `level' `data' if `touse', c(`connect') s(`symbol') /*
		*/ l2(`"`l2title'"') b2(`"`b2title'"') `options'
end

