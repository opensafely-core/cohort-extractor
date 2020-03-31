*! version 2.2.0  21mar2011
program define fillin
	if _caller() >= 12 {
		local vv : di "version " string(_caller()) ":"
	}
	version 6
	syntax varlist(min=2)
	tokenize `varlist'
	confirm new var _fillin _merge
	tempfile FILLIN0 FILLIN1
	preserve
	quietly {
		keep `varlist' 
		save `"`FILLIN0'"', replace
		keep `1'
		`vv' sort `1'
		by `1':  keep if _n==_N
		save `"`FILLIN1'"', replace 
		mac shift
		local stop : word count `varlist'
		local stop = `stop' - 1
		local i 1
		while `i' <= `stop' { 
			use `"`FILLIN0'"', clear
			keep ``i''
			`vv' sort ``i''
			by ``i'':  keep if _n==_N
			`vv' cross using `"`FILLIN1'"'
			save `"`FILLIN1'"', replace 
			local i = `i' + 1
		}
		erase `"`FILLIN0'"'		/* to save disk space only */
		`vv' sort `varlist'
		save `"`FILLIN1'"', replace 
		restore, preserve
		`vv' sort `varlist' 
		merge `varlist' using `"`FILLIN1'"'
		noisily assert _merge!=1
		gen byte _fillin=_merge==2
		drop _merge 
		`vv' sort `varlist'
		restore, not
	}
end
