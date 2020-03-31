*! version 1.1.3  20jan2015
program scoreplot
	version 9.0

	if "`e(cmd)'" == "" {
		error 301
	}
	else if !inlist("`e(cmd)'`e(subcmd)'", ///
				"pca","factor","discrimlda","candisc") {
		dis as err "{p}scoreplot is allowed only after "
		dis as err "factor, pca, candisc, and discrim lda{p_end}"
		exit 301
	}

	syntax [if] [in], 			///
	[					///
		FACtors(str)			///
		COMponents(str)			///
		noROTated			///
		SCOREopt(str)			///
		COMBINEd			///
		MATRIX				///
		MLabel(str)	/// already documented as part of graph opts
		*				///
	]

	local dopf   "*"
	local dodisc "*"
	if inlist("`e(cmd)'","pca","factor") {
		local dopf
		if "`e(cmd)'" == "factor" {
			local fname factor
		}
		else if "`e(cmd)'" == "pca" {
			local fname component
		}
	}
	else {
		local dodisc
		if `"`scoreopt'"' == "" {
			local scoreopt dscore
		}
		else {
			local scoreopt = trim(`"`scoreopt'"')
			local slen = length(`"`scoreopt'"')
			if `"`scoreopt'"' != bsubstr("dscore",1,max(3,`slen')) {
				di as err "{p}invalid scoreopt(); "
				di as err "only discriminant scores, "
				di as err "scoreopt(dscore), allowed{p_end}"
				exit 198
			}
		}
		if `"`mlabel'"' == "" {
			local mlabel `e(groupvar)'
		}
		local fname discriminant function
	}

	if `"`mlabel'"' != "" {
		// stuff mlabel() back in options
		local options `"`options' mlabel(`mlabel')"'
	}

	if `e(f)' == 1 {
		dis as err "only one `fname' retained"
		exit 321
	}

	if "`combined'" != "" & "`matrix'" != "" {
		display as error 	///
		    "options matrix and combined may not be specified together"

		exit 198
	}

	if `"`factors'"' != "" & `"`components'"' != "" {
		display as error		///
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
	_get_gropts , graphopts(`options') getallowed(scheme) `getcombine'

        if `"`s(scheme)'"' != "" {
                local scheme `"scheme(`s(scheme)')"'
        }
	local options `"`s(graphopts)'"'
	local gcopts  `"`s(combineopts)'"'

// create scores
	marksample touse
	forvalues i = 1 / `f' {
		tempvar s`i'
		local slist `slist' `s`i''
	}

	`dopf'   quietly predict `slist' , notable `rotated' `scoreopt' 
	`dodisc' quietly predict `slist' , `scoreopt'

	forvalues i = 1/`f' {
		local scname`i' : var label `s`i''
		if "`scname`i''" == "" {
			`dopf'   local scname`i' "score `i'"
			`dodisc' local scname`i' "discriminant score `i'"
		}
	}

	`dopf'   local title `"Score variables (`e(cmd)')"'
	`dodisc' local title "Discriminant function scores"

	if "`rotated'" != "norotated" & "`e(r_criterion)'" != "" {
		if "`e(r_class)'`e(r_ctitle)'" != "" {
			local rotation ///
				`""Rotation: `e(r_class)' `e(r_ctitle)'""'
		}
		if "`e(mtitle)'" != "" {
			local method `""Method: `e(mtitle)'""'
		}
		local note note(`rotation' `method')
	}
	
	if `isMatrix' {
		graph matrix `slist' if `touse', title(`title')	`note'	///
			`scheme' `options'
	}
	else {
		// make individual plots
		tempvar p
		forvalues i = 1/`f' {
			forvalues j = 1 / `=`i'-1' {
				tempname f`i'_`j'
				local clist `clist' `f`i'_`j''

				scatter `s`i'' `s`j'' if `touse',	///
					ytitle(`scname`i'')		///
					xtitle(`scname`j'')		///
					nodraw name(`f`i'_`j'') 	///
					`scheme' `options'
			}
		}

		// show combined plot
		graph combine `clist' , title(`title') `note' `scheme' `gcopts'
		graph drop `clist'
	}
end
exit
