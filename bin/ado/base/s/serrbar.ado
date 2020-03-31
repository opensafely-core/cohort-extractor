*! version 3.2.2  02mar2005
program define serrbar
	version 6, missing
	if _caller() < 8 {
		serrbar_7 `0'
		exit
	}

	syntax varlist(min=3 max=3) [if] [in] [,	///
		SCale(real 1)				///
		*					/// graph opts
	]

	_get_gropts , graphopts(`options') getallowed(MVOPts plot addplot)
	local options `"`s(graphopts)'"'
	local mvopts `"`s(mvopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts mvopts, opt(`mvopts')

	tempvar top bot
	tokenize `varlist'
	quietly {
		gen `top' = `1' + `scale' * `2' `if' `in'
		gen `bot' = `1' - `scale' * `2' `if' `in'
		label var `top' "Top"
		label var `bot' "Bottom"
	}

	local yttl : var label `1'
	if `"`yttl'"' == "" {
		local yttl `1'
	}
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	version 8, missing: graph twoway	///
	(rcap `bot' `top' `3'			///
		`if' `in',			///
		ytitle(`"`yttl'"')		///
		`legend'			///
		`options'			///
	)					///
	(scatter `1' `3'			///
		`if' `in',			///
		pstyle(p1)			///
		`mvopts'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end
