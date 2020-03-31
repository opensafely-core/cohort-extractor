*! version 2.0.0  20mar2007
program mdsshepard
	version 10

	if !inlist("`e(cmd)'","mds","mdsmat","mdslong") {
		error 301
	}

	syntax [, 				///
		SEParate 			///
		noTRANSform 			///
		BYOpts(string) 			///
		AUTOaspect			///
		ASPECTratio(str)		///
		*				///
	]

	local id `e(id)'
	local nid : word count `e(id)'
	if `nid' == 1 {
		local id1 `id'1
		local id2 `id'2
	}
	else if `nid' == 2 {
		local id1 : word 1 of `e(id)'
		local id2 : word 2 of `e(id)'
	}
	else {
		di as error "more than two variables in e(id)"
		exit 498
	}

	if "`aspectratio'" != "" & "`autoaspect'" != "" {
		display as error				///
		    "options aspectratio() and autoaspect may not be combined"
		exit 198
	}

	if "`separate'" == "" & "`byopts'" != "" {
		display as error 	///
		  "option byopts() may only be specified with separate option"
		exit 198
	}

	if "`separate'" != "" {
		local full  full
	}

	tempfile f
	
	quietly predict disparities dissimilarities distances weight, ///
	   pairwise(disp diss dist weight) saving(`"`f'"') `full' 

	preserve
	quietly use `"`f'"', clear
	quietly drop if `id1' == `id2' | weight==0
		
	label var disparities
	label var dissimilarities
	label var distances
	
	if "`transform'" == "" { 
		local y distances
		local x disparities
	}
	else { 
		local y distances
		local x dissimilarities
	}
	
	summarize `x' , meanonly
	local xmin `r(min)'
	local xmax `r(max)'
	summarize `y' , meanonly
	local ymin `r(min)'
	local ymax `r(max)'

	.atk = .aspect_axis_toolkit.new
	.atk.setPreferredLabelCount 7

	_parse comma aspect_ratio placement : aspectratio
	if "`aspect_ratio'" != "" {
		confirm number `aspect_ratio'
		.atk.setPreferredAspect `aspect_ratio'
		.atk.setShowAspectTrue
	}

	if "`autoaspect'" != "" {
		.atk.setAutoAspectTrue
	}

	.atk.getAspectAdjustedScales ,	///
		xmin(`xmin') xmax(`xmax') ymin(`ymin') ymax(`ymax')

	if "`e(loss)'" == "" { 
		local note note(Classical MDS, span)
	}
	else {
		local note `"Modern MDS (loss=`e(loss)'; transform=`e(tfunction)')"'
		local note note(`note',span)
	}
	local ytitle ytitle(`y')
	local xtitle xtitle(`x')

	if "`separate'" == "" {
		local title title(Shepard diagram, span)
		
		twoway	(scatter `y' `x', `title' `note' legend(off) ///
				aspectratio(`s(aspectratio)'`placement') ///
				`xtitle' `ytitle' `s(scales)' `options'	 ///
			) 						 ///
			(function y=x, range(`x')),
	}
	else {
		dis as txt "(mdsshepard is producing a separate "	///
		           "plot for each obs; this may take a while)"
		           
		local title title(Shepard diagrams, span)

		twoway	(scatter `y' `x', `xtitle' `ytitle'		///
			     aspectratio(`s(aspectratio)'`placement')	///
			      `s(scales)' `options'			///
			)						///
			(function y=x, range(`x')) , 		///
			by(`id1', note("") legend(off) compact 		///
				`title' `note' `byopts' 		///
			)
	}
end
exit
