*! version 1.0.1  08sep2006
program procoverlay
	version 9.0

	if "`e(cmd)'" != "procrustes" {
		error 301
	}

	syntax [if] [in]			///
		[, 				///
			SOURCEopts(str) 	///
			TARGETopts(str) 	///
			AUTOaspect		///
			ASPECTratio(str)	///
			*			///
		]
		
	_gs_byopts_combine  byopts options : `"`options'"'

	marksample touse
	local graphopts `options'

	if "`aspectratio'" != "" & "`autoaspect'" != "" {
		display as error				///
		    "options aspectratio() and autoaspect may not be combined"
		exit 198
	}

	// parse out source options
	_get_gropts, graphopts(`sourceopts') getallowed(MLabel)
	local srcopts `"`s(graphopts)'"'
	local mlabelSrc `"`s(mlabel)'"'
	local 0 , `srcopts'
	syntax [ , noLABel * ]
	local srcopts `options'
	local nosource `label'

	// parse out target options
	_get_gropts, graphopts(`targetopts') getallowed(MLabel)
	local tgtopts `"`s(graphopts)'"'
	local mlabelTgt `"`s(mlabel)'"'
	local 0 , `tgtopts'
	syntax [ , noLABel * ]
	local tgtopts `options'
	local notarget `label'

	.atk = .aspect_axis_toolkit.new
	.atk.setPreferredLabelCount 4

	_parse comma aspect_ratio placement : aspectratio
	if "`aspect_ratio'" != "" {
		confirm number `aspect_ratio'
		.atk.setPreferredAspect `aspect_ratio'
		.atk.setShowAspectTrue
	}

	if "`autoaspect'" != "" {
		.atk.setAutoAspectTrue
	}

	// generate observation numbers
	tempvar obs
	generate `obs' = _n

	preserve
	quietly keep if `touse'
	local ylist `e(ylist)'
	local xlist `e(xlist)'	// never used
	local ny : list sizeof ylist

	if `ny' == 1 {
		dis as txt "(nothing to plot)"
		exit 0
	}

	forvalues i = 1/`ny' {
		tempvar yh`i'
		local yhatlist `yhatlist' `yh`i''
	}
	quietly predict `yhatlist' if `touse' , fitted

	// Setup observation labels
	if "`mlabelSrc'" == "" & "`nosource'" != "nolabel" {
		local mlabelSrc `obs'
	}
	if "`mlabelTgt'" == "" & "`notarget'" != "nolabel" {
		local mlabelTgt `obs'
	}

	if `ny' == 2 {
		local y : word 1 of `ylist'
		local x : word 2 of `ylist'

		summarize `yh1' `y', meanonly
		local y_max = ceil(`r(max)')
		local y_min = floor(`r(min)')
		local y_diff = `y_max' - `y_min'

		summarize `yh2' `x', meanonly
		local x_max = ceil(`r(max)')
		local x_min = floor(`r(min)')
		local x_diff = `x_max' - `x_min'

		.atk.getAspectAdjustedScales , xmin(`x_min') xmax(`x_max') ///
			ymin(`y_min') ymax(`y_max')

		if "`mlabelSrc'" != "" {
			local mlabelSrc `"mlabel(`mlabelSrc')"'
		}
		if "`mlabelTgt'" != "" {
			local mlabelTgt `"mlabel(`mlabelTgt')"'
		}

		scatter `ylist' , `mlabelTgt' 	`tgtopts'		///
		|| 							///
		scatter `yhatlist' , `mlabelSrc' `srcopts'		///
		|| ,							///
		`s(scales)' aspectratio(`s(aspectratio)'`placement')	///
		legend(label(1 "Target") label(2 "Source")) `graphopts'
	}
	else if `ny' > 2 {
		.atk.setPreferredLabelCount 3

	      quietly {
		// generate longitudinal data
		local origObs = _N
		local loopCNT = 1
		tempvar group x y yh_x yh_y labelvar1 labelvar2
		generate `group' = .
		generate `x' = .
		generate `y' = .
		generate `yh_x' = .
		generate `yh_y' = .
		if "`mlabelSrc'" ! = "" {
			generate `labelvar1' = `mlabelSrc'
			local mlabelSrc `"mlabel(`labelvar1')"'
		}
		if "`mlabelTgt'" ! = "" {
			generate `labelvar2' = `mlabelTgt'
			local mlabelTgt `"mlabel(`labelvar2')"'
		}

		forvalues i = 1/`ny' {
		    forvalues j = `=`i'+1' / `ny' {
			set obs `=`origObs' * `loopCNT''
			local inarg "`=(`origObs' * (`loopCNT'-1)) + 1'/`=_N'"
			local subscript "_n - (`origObs' * (`loopCNT' - 1))"
			local v1 : word `i' of `ylist'
			local v2 : word `j' of `ylist'
			local yh1: word `i' of `yhatlist'
			local yh2: word `j' of `yhatlist'
			replace `group' = `loopCNT' in `inarg'
			replace `x' = `v2'[`subscript'] in `inarg'
			replace `y' = `v1'[`subscript'] in `inarg'
			replace `yh_x' = `yh2'[`subscript'] in `inarg'
			replace `yh_y' = `yh1'[`subscript'] in `inarg'
			replace `obs'  = `obs'[`subscript'] in `inarg'
			if "`mlabelSrc'" != "" {
				replace `labelvar1' = 		///
					`labelvar1'[`subscript'] in `inarg'
			}
			if "`mlabelTgt'" != "" {
				replace `labelvar2' = 		///
					`labelvar2'[`subscript'] in `inarg'
			}
			local vlabel "`v1' / `v2'"
			local vLabelList `"`vLabelList' `loopCNT' "`vlabel'""'
			local loopCNT = `loopCNT' + 1
		    }
		}
	      }

		// Setup value labels to be used as by title
		tempname values
		label define `values' `vLabelList'
		label values `group' `values'

		// Setup axis ranges
		summarize `y' `yh_y' , meanonly
		local y_max = ceil(`r(max)')
		local y_min = floor(`r(min)')

		summarize `x' `yh_x', meanonly
		local x_max = ceil(`r(max)')
		local x_min = floor(`r(min)')

		.atk.getAspectAdjustedScales , xmin(`x_min') xmax(`x_max') 	///
			ymin(`y_min') ymax(`y_max')
		scatter `y' `x', `mlabelTgt' `tgtopts'				///
			|| 							///
			scatter `yh_y' `yh_x' , `mlabelSrc' `srcopts'		///
			|| , 							///
			by(`group', title("Procrustes overlay plot") note("") 	///
				`byopts')					///
			subtitle(, size(small)) 				///
			`s(scales)' aspectratio(`s(aspectratio)'`placement')	///
			legend(label(1 "Target") label(2 "Source")) `graphopts'
	}
end
exit
